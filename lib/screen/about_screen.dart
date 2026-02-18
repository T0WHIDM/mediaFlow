import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mediaflow/constants/colors.dart';
import 'package:mediaflow/util/url_luncher.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 40.0),
        child: Column(
          children: [
            ListTile(
              leading: FaIcon(
                FontAwesomeIcons.telegram,
                color: isDark ? CustomColor.greenColor : CustomColor.blueColor,
              ),
              title: Text(
                'telegram',
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black,
                  fontSize: 20,
                  fontFamily: 'GH',
                  fontWeight: FontWeight.normal,
                ),
              ),
              onTap: () {
                MyUrlLauncher.launchLink('https://t.me/T0WHID');
              },
              trailing: FaIcon(
                FontAwesomeIcons.caretRight,
                size: 25,
                color: isDark ? CustomColor.greenColor : CustomColor.blueColor,
              ),
            ),
            const SizedBox(height: 30),
            ListTile(
              leading: Icon(
                Icons.mail,
                color: isDark ? CustomColor.greenColor : CustomColor.blueColor,
              ),
              title: Text(
                'email',
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black,
                  fontSize: 20,
                  fontFamily: 'GH',
                  fontWeight: FontWeight.normal,
                ),
              ),
              trailing: FaIcon(
                FontAwesomeIcons.caretRight,
                size: 25,
                color: isDark ? CustomColor.greenColor : CustomColor.blueColor,
              ),
              onTap: () {
                MyUrlLauncher.launchLink('mailto:towhidmgholami@gmail.com');
              },
            ),
            const SizedBox(height: 30),
            ListTile(
              leading: FaIcon(
                FontAwesomeIcons.github,
                color: isDark ? CustomColor.greenColor : CustomColor.blueColor,
              ),
              title: Text(
                'source code',
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black,
                  fontSize: 20,
                  fontFamily: 'GH',
                  fontWeight: FontWeight.normal,
                ),
              ),
              trailing: FaIcon(
                FontAwesomeIcons.caretRight,
                size: 25,
                color: isDark ? CustomColor.greenColor : CustomColor.blueColor,
              ),
              onTap: () {
                MyUrlLauncher.launchLink(
                  'https://github.com/T0WHIDM/mediaFlow',
                );
              },
            ),
            const Spacer(),
            Center(
              child: Text(
                "v1.0.0",
                style: TextStyle(
                  fontFamily: 'GH',
                  color: isDark ? Colors.white : Colors.black,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
