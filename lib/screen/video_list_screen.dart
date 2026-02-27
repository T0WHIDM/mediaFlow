import 'dart:io';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mediaflow/core/constants/colors.dart';
import 'package:mediaflow/provider/download_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:provider/provider.dart';

class VideoListScreen extends StatefulWidget {
  const VideoListScreen({super.key});

  @override
  State<VideoListScreen> createState() => _VideoListScreenState();
}

class _VideoListScreenState extends State<VideoListScreen> {
  late TextEditingController myController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DownloadProvider>().loadDownloadedFiles();
    });
    myController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await context.watch<DownloadProvider>().loadDownloadedFiles();
          },
          color: CustomColor.blueColor,
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                elevation: 0,
                backgroundColor: Colors.transparent,
                centerTitle: true,
                floating: true,
                iconTheme: IconThemeData(
                  color: isDark ? Colors.white : CustomColor.blueColor,
                ),
                title: Text(
                  'MediaFlow Gallery',
                  style: TextStyle(
                    color: isDark ? Colors.white : CustomColor.blueColor,
                    fontSize: 22,
                    fontFamily: 'GH',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SliverPadding(padding: EdgeInsetsGeometry.only(top: 15)),
              SliverToBoxAdapter(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(12)),
                    color: isDark ? Colors.grey[850] : Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),

                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        const SizedBox(width: 10),
                        const FaIcon(
                          FontAwesomeIcons.magnifyingGlass,
                          size: 22,
                        ),
                        const SizedBox(width: 5),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: TextField(
                              controller: myController,
                              decoration: InputDecoration(
                                border: const OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                ),

                                hintText: 'Search',
                                hintStyle: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 16,
                                  fontFamily: 'GH',
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SliverPadding(padding: EdgeInsetsGeometry.only(top: 15)),

              Consumer<DownloadProvider>(
                builder: (context, provider, child) {
                  if (provider.downloadedFiles.isEmpty) {
                    return SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FaIcon(
                              FontAwesomeIcons.boxOpen,
                              size: 50,
                              color: isDark
                                  ? Colors.white24
                                  : Colors.grey.withOpacity(0.5),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              "No videos found",
                              style: TextStyle(
                                fontFamily: 'GH',
                                color: isDark
                                    ? Colors.white54
                                    : Colors.grey.withOpacity(0.8),
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  return SliverList.builder(
                    itemCount: provider.downloadedFiles.length,
                    itemBuilder: (context, index) {
                      final file = provider.downloadedFiles[index] as File;
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8.0,
                          horizontal: 16.0,
                        ),
                        child: VideoItem(
                          isDark: isDark,
                          file: file,
                          onDelete: () {
                            _showDeleteConfirmDialog(context, file, provider);
                          },
                        ),
                      );
                    },
                  );
                },
              ),
              const SliverPadding(padding: EdgeInsetsGeometry.only(top: 50)),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmDialog(
    BuildContext context,
    File file,
    DownloadProvider provider,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF2C2C2C) : Colors.white,
        title: Text(
          "Delete Video?",
          style: TextStyle(
            fontFamily: 'GH',
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        content: Text(
          "Are you sure you want to delete this file?",
          style: TextStyle(
            fontFamily: 'GH',
            color: isDark ? Colors.grey[300] : Colors.grey[700],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text("Cancel", style: TextStyle(fontFamily: 'GH')),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              provider.deleteVideo(file);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    "Video deleted successfully",
                    style: TextStyle(color: Colors.white),
                  ),
                  backgroundColor: Colors.red,
                  behavior: SnackBarBehavior.floating,
                  duration: Duration(seconds: 2),
                ),
              );
            },
            child: const Text(
              "Delete",
              style: TextStyle(color: Colors.red, fontFamily: 'GH'),
            ),
          ),
        ],
      ),
    );
  }
}

class VideoItem extends StatelessWidget {
  const VideoItem({
    super.key,
    required this.isDark,
    required this.file,
    required this.onDelete,
  });

  final bool isDark;
  final File file;
  final VoidCallback onDelete;

  String _getFileSize(File file) {
    try {
      int sizeInBytes = file.lengthSync();
      double sizeInMb = sizeInBytes / (1024 * 1024);
      return "${sizeInMb.toStringAsFixed(1)} MB";
    } catch (e) {
      return "Unknown";
    }
  }

  String _getFileName(File file) {
    return file.path.split('/').last.replaceAll('.mp4', '');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2C2C2C) : Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            // Thumbnail / Play Button
            Material(
              color: CustomColor.greenColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
              child: InkWell(
                onTap: () {
                  try {
                    OpenFile.open(file.path);
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        backgroundColor: Colors.red,
                        behavior: SnackBarBehavior.floating,
                        content: Text(
                          "Cannot open video player",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    );
                  }
                },
                borderRadius: BorderRadius.circular(12),
                child: const SizedBox(
                  width: 80,
                  height: 80,
                  child: Center(
                    child: FaIcon(
                      FontAwesomeIcons.play,
                      color: CustomColor.greenColor,
                      size: 24,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 15),

            // Video Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _getFileName(file),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: isDark ? Colors.white : CustomColor.blueColor,
                      fontSize: 16,
                      fontFamily: 'GH',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.data_usage,
                        size: 14,
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _getFileSize(file),
                        style: TextStyle(
                          color: isDark ? Colors.grey[400] : Colors.grey[600],
                          fontSize: 12,
                          fontFamily: 'GH',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Context Menu (Delete)
            PopupMenuButton<String>(
              icon: Icon(
                Icons.more_vert_rounded,
                color: isDark ? CustomColor.greenColor : CustomColor.blueColor,
              ),
              color: isDark ? const Color(0xFF333333) : Colors.white,
              onSelected: (value) {
                if (value == 'delete') {
                  onDelete();
                } else if (value == 'play') {
                  OpenFile.open(file.path);
                }
              },
              itemBuilder: (BuildContext context) {
                return [
                  PopupMenuItem<String>(
                    value: 'play',
                    child: Row(
                      children: [
                        Icon(
                          Icons.play_arrow,
                          size: 20,
                          color: isDark ? Colors.white : Colors.black,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Play',
                          style: TextStyle(
                            fontFamily: 'GH',
                            color: isDark ? Colors.white : Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const PopupMenuItem<String>(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete, color: Colors.red, size: 20),
                        SizedBox(width: 10),
                        Text(
                          'Delete',
                          style: TextStyle(fontFamily: 'GH', color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                ];
              },
            ),
          ],
        ),
      ),
    );
  }
}
