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
              const SliverPadding(padding: EdgeInsetsGeometry.only(top: 50)),
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
    return ListTile(
      leading: InkWell(
        onTap: () {},
        child: Container(
          width: 100,
          height: 150,
          decoration: const BoxDecoration(
            color: CustomColor.greenColor,
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
          child: const Center(child: FaIcon(FontAwesomeIcons.play),),
        ),
      ),
      titleTextStyle: TextStyle(
        color: isDark ? Colors.white : CustomColor.blueColor,
        fontSize: 16,
        fontFamily: 'GH',
        fontWeight: FontWeight.w400,
      ),
      title: const Padding(
        padding: EdgeInsets.only(left: 15.0),
        child: Text('this is test', style: TextStyle(color: Colors.white)),
      ),
      trailing: Icon(
        Icons.more_vert_outlined,
        color: isDark ? CustomColor.greenColor : CustomColor.blueColor,
      ),
    );
  }
}
