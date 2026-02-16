import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mediaflow/constants/colors.dart';
import 'package:mediaflow/util/url_luncher.dart';

class ContactUsScreen extends StatelessWidget {
  const ContactUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColor.blueColor,
        title: const Text(
          'mediaflow',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontFamily: 'GH',
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.all(12.0),
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: const FaIcon(
              size: 20,
              FontAwesomeIcons.arrowLeft,
              color: Colors.white,
            ),
          ),
        ),
      ),
      body: Center(
        child: Container(
          width: 330,
          height: 300,
          decoration: const BoxDecoration(
            color: CustomColor.blueColor,
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    MyUrlLauncher.launchLink('https://t.me/T0WHID');
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FaIcon(FontAwesomeIcons.telegram, color: Colors.white),
                      SizedBox(width: 20),
                      Text(
                        '@T0WHID',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontFamily: 'GH',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    MyUrlLauncher.launchLink('https://github.com/T0WHIDM');
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FaIcon(FontAwesomeIcons.github, color: Colors.white),
                      SizedBox(width: 20),
                      Text(
                        'T0WHIDM',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontFamily: 'GH',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    MyUrlLauncher.launchLink('mailto:towhidmgholami@gmail.com');
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.email, color: Colors.white),
                      SizedBox(width: 10),
                      Text(
                        'towhidmgholami@gmail.com',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontFamily: 'GH',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
