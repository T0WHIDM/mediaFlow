import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:mediaflow/core/constants/colors.dart';
import 'package:mediaflow/screen/about_screen.dart';
import 'package:mediaflow/provider/theme_provider.dart';
import 'package:mediaflow/provider/download_provider.dart';
import 'package:mediaflow/core/util/url_luncher.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
  
  static String get routeName => 'home';
}

class _HomeScreenState extends State<HomeScreen> {
  late FocusNode _focusNode;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _controller = TextEditingController();

    _focusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  Future<void> _pasteLink() async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    if (data != null && data.text != null) {
      setState(() {
        _controller.text = data.text!;
      });
      FocusScope.of(context).unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            iconTheme: IconThemeData(
              color: isDark ? Colors.white : CustomColor.blueColor,
            ),
            title: Text(
              'MediaFlow',
              style: TextStyle(
                color: isDark ? Colors.white : CustomColor.blueColor,
                fontSize: 22,
                fontFamily: 'GH',
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          drawer: _buildModernDrawer(context, isDark),
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                SizedBox(height: size.height * 0.12),
                Hero(
                  tag: 'logo',
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(50),
                      onTap: () async {
                        try {
                          await MyUrlLauncher.launchLink(
                            'https://www.youtube.com',
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Could not launch YouTube'),
                              backgroundColor: Colors.red,
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        }
                      },
                      child: Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          color: CustomColor.blueColor.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: FaIcon(
                            FontAwesomeIcons.youtube,
                            size: 50,
                            color: CustomColor.redColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                const Text(
                  "Video Downloader",
                  style: TextStyle(
                    fontFamily: 'GH',
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 40),

                _buildTextField(isDark),

                const SizedBox(height: 30),

                Consumer<DownloadProvider>(
                  builder: (context, downloadProv, child) {
                    return Column(
                      children: [
                        if (downloadProv.isDownloading ||
                            downloadProv.statusText.isNotEmpty)
                          _buildStatusCard(downloadProv, isDark),

                        const SizedBox(height: 20),

                        _buildMainButton(downloadProv, isDark),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[850] : Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: TextField(
        controller: _controller,
        focusNode: _focusNode,
        style: const TextStyle(fontFamily: 'GH'),
        decoration: InputDecoration(
          hintText: 'Paste video link here...',
          hintStyle: TextStyle(color: Colors.grey[600], fontFamily: 'GH'),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 20,
          ),
          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_controller.text.isNotEmpty)
                IconButton(
                  icon: const Icon(Icons.clear, size: 20, color: Colors.grey),
                  onPressed: () {
                    _controller.clear();
                    context.read<DownloadProvider>().clearStatus();
                  },
                ),
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: IconButton(
                  icon: Icon(
                    Icons.paste,
                    color: isDark
                        ? CustomColor.greenColor
                        : CustomColor.blueColor,
                  ),
                  tooltip: "Paste",
                  onPressed: _pasteLink,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusCard(DownloadProvider provider, bool isDark) {
    return AnimatedContainer(
      duration: const Duration(seconds: 3),
      curve: Curves.easeInOut,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[850] : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: CustomColor.blueColor.withValues(alpha: 0.1)),
        boxShadow: [
          BoxShadow(
            color: CustomColor.blueColor.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                provider.isDownloading ? "Downloading..." : '',
                style: const TextStyle(
                  fontFamily: 'GH',
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (provider.isDownloading)
                Text(
                  "${(provider.progress * 100).toStringAsFixed(0)}%",
                  style: const TextStyle(
                    fontFamily: 'GH',
                    fontWeight: FontWeight.bold,
                    color: CustomColor.blueColor,
                  ),
                ),
            ],
          ),

          if (provider.isDownloading) ...[
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: provider.progress > 0 ? provider.progress : null,
                backgroundColor: Colors.grey[200],
                color: CustomColor.blueColor,
                minHeight: 8,
              ),
            ),
          ],

          const SizedBox(height: 10),
          Text(
            provider.statusText,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'GH',
              fontSize: 14,
              color:
                  provider.statusText.contains('❌') ||
                      provider.statusText.contains('⛔')
                  ? CustomColor.redColor
                  : (isDark ? Colors.grey[400] : Colors.grey[700]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainButton(DownloadProvider provider, bool isDark) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: provider.isDownloading
              ? CustomColor.redColor
              : isDark
              ? CustomColor.greenColor
              : CustomColor.blueColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 5,
          shadowColor:
              (provider.isDownloading
                      ? CustomColor.redColor
                      : CustomColor.blueColor)
                  .withOpacity(0.4),
        ),
        onPressed: () {
          if (provider.isDownloading) {
            provider.cancelDownload();
          } else {
            if (_controller.text.trim().isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Row(
                    children: [
                      Icon(Icons.error_outline, color: Colors.white),
                      SizedBox(width: 10),
                      Text(
                        'Please enter a link first!',
                        style: TextStyle(fontFamily: 'GH', color: Colors.white),
                      ),
                    ],
                  ),
                  backgroundColor: CustomColor.redColor,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  duration: const Duration(seconds: 2),
                ),
              );
              return;
            }

            FocusScope.of(context).unfocus();
            provider.downloadVideo(_controller.text);
          }
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              provider.isDownloading
                  ? Icons.stop_circle_outlined
                  : Icons.download_rounded,
              color: Colors.white,
            ),
            const SizedBox(width: 10),
            Text(
              provider.isDownloading ? 'Cancel Download' : 'Start Download',
              style: const TextStyle(
                fontSize: 18,
                fontFamily: 'GH',
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModernDrawer(BuildContext context, bool isDark) {
    return Drawer(
      backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [CustomColor.greenColor, CustomColor.blueColor],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
            accountName: const Text(
              "MediaFlow",
              style: TextStyle(
                fontFamily: 'GH',
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            accountEmail: const Text(
              "v1.0.0",
              style: TextStyle(
                fontFamily: 'GH',
                color: Colors.white70,
                fontSize: 12,
              ),
            ),
            currentAccountPicture: Container(
              padding: const EdgeInsets.all(1),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const CircleAvatar(
                backgroundImage: AssetImage('assets/images/flutterflow.jpg'),
              ),
            ),
          ),
          ListTile(
            leading: FaIcon(
              FontAwesomeIcons.solidCircleQuestion,
              color: isDark ? CustomColor.greenColor : CustomColor.blueColor,
            ),
            title: const Text(
              'about',
              style: TextStyle(fontFamily: 'GH', fontSize: 15),
            ),
            onTap: () {
              Navigator.pop(context);
              context.goNamed(AboutScreen.routeName);
            },
          ),
          Consumer<ThemeProvider>(
            builder: (context, themeProv, child) {
              return ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                leading: FaIcon(
                  isDark ? Icons.sunny : FontAwesomeIcons.moon,
                  color: isDark ? Colors.orange : CustomColor.blueColor,
                  size: 25,
                ),
                title: Text(
                  isDark ? 'light mode' : 'dark mode',
                  style: const TextStyle(fontFamily: 'GH', fontSize: 15),
                ),
                trailing: Transform.scale(
                  scale: 0.6,
                  child: Switch(
                    value: isDark,
                    activeThumbColor: CustomColor.blueColor,
                    onChanged: (val) {
                      themeProv.toggleTheme();
                    },
                  ),
                ),
              );
            },
          ),
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            leading: FaIcon(
              FontAwesomeIcons.shareNodes,
              size: 25,
              color: isDark ? CustomColor.greenColor : CustomColor.blueColor,
            ),
            title: const Text(
              'share',
              style: TextStyle(fontFamily: 'GH', fontSize: 15),
            ),
            onTap: () async {
              await SharePlus.instance.share(
                ShareParams(
                  text: '''"Download youtube videos fast with MediaFlow! 🚀


[https://github.com/T0WHIDM/mediaFlow/releases/download/v1.0.0/mediaflow.apk]"''',
                ),
              );
            },
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              'Designed with ❤️',
              style: TextStyle(fontFamily: 'GH', color: Colors.grey[500]),
            ),
          ),
        ],
      ),
    );
  }
}
