import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mediaflow/constants/colors.dart';
import 'package:mediaflow/screen/contact_us_screen.dart';
import 'package:mediaflow/provider/theme_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FocusNode negahban1 = FocusNode();
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();

    negahban1.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,

      //appbar
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 1, 88, 155),
        title: const Text(
          'mediaflow',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontFamily: 'GH',
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),

      //drawer menu
      drawer: Drawer(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 100),
              const CircleAvatar(
                radius: 70,
                backgroundImage: AssetImage('assets/images/flutterflow.jpg'),
              ),
              const SizedBox(height: 70),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(width: 30),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) {
                            return const ContactUsScreen();
                          },
                        ),
                      );
                    },
                    child: const FaIcon(FontAwesomeIcons.telegram),
                  ),
                  const SizedBox(width: 15),
                  const Text(
                    'contact us',
                    style: TextStyle(fontSize: 22, fontFamily: 'GH'),
                  ),
                ],
              ),
              const SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(width: 30),
                  GestureDetector(
                    onTap: () {
                      Provider.of<ThemeProvider>(
                        context,
                        listen: false,
                      ).toggleTheme();
                    },
                    child: const FaIcon(FontAwesomeIcons.moon),
                  ),
                  const SizedBox(width: 15),
                  const Text(
                    'theme',
                    style: TextStyle(fontSize: 22, fontFamily: 'GH'),
                  ),
                ],
              ),
              const SizedBox(height: 430),
              const Padding(
                padding: EdgeInsets.all(5.0),
                child: Text(
                  'version 1.0.0',
                  style: TextStyle(fontSize: 18, fontFamily: 'GH'),
                ),
              ),
            ],
          ),
        ),
      ),

      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 250),
            const Text(
              'please enter video url',
              style: TextStyle(fontSize: 22, fontFamily: 'GH'),
            ),
            const SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),

              //text field
              child: TextField(
                controller: _controller,
                focusNode: negahban1,
                decoration: InputDecoration(
                  labelText: 'url',
                  labelStyle: TextStyle(
                    fontSize: 22,
                    fontFamily: 'GH',
                    color: negahban1.hasFocus
                        ? const Color.fromARGB(219, 1, 88, 155)
                        : const Color.fromARGB(255, 0, 0, 0),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    borderSide: BorderSide(
                      color: Color(0xffC5C5C5),
                      width: 4.0,
                    ),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    borderSide: BorderSide(
                      color: Color.fromARGB(219, 1, 88, 155),
                      width: 4.0,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 50),

            //button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(150, 40),
                backgroundColor: const Color.fromARGB(219, 1, 88, 155),
              ),
              onPressed: () {},
              child: const Text(
                'download',
                style: TextStyle(
                  fontSize: 22,
                  fontFamily: 'GH',
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
