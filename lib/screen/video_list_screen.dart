import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mediaflow/constants/colors.dart';
import 'package:mediaflow/screen/loading_screen.dart';

class VideoListScreen extends StatelessWidget {
  const VideoListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                elevation: 0,
                backgroundColor: Colors.transparent,
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
              const SliverPadding(padding: EdgeInsetsGeometry.only(top: 15)),

              SliverList.builder(
                itemCount: 10,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: VideoItem(isDark: isDark),
                  );
                },
              ),
              const SliverPadding(padding: EdgeInsetsGeometry.only(top: 40)),
            ],
          ),
        ),
      ),
    );
  }
}

class VideoItem extends StatelessWidget {
  const VideoItem({super.key, required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          Material(
            color: CustomColor.greenColor,
            borderRadius: BorderRadius.circular(15),
            child: InkWell(
              onTap: () {},
              borderRadius: BorderRadius.circular(15),
              child: const SizedBox(
                width: 100,
                height: 100,
                child: Center(child: FaIcon(FontAwesomeIcons.play)),
              ),
            ),
          ),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [Text('عنوان ویدیو')],
            ),
          ),
          Icon(
            Icons.more_vert_outlined,
            color: isDark ? CustomColor.greenColor : CustomColor.blueColor,
          ),
        ],
      ),
    );
  }
}
