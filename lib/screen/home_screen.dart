import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FocusNode negahban1 = FocusNode();

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
          style: TextStyle(fontSize: 22, fontFamily: 'GH'),
        ),
        centerTitle: true,
      ),

      //drawer menu
      drawer: const Drawer(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 100),
              CircleAvatar(
                radius: 70,
                backgroundImage: AssetImage('assets/images/flutterflow.jpg'),
              ),
              SizedBox(height: 70),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(width: 30),
                  FaIcon(FontAwesomeIcons.telegram),
                  SizedBox(width: 15),
                  Text(
                    'contact us',
                    style: TextStyle(fontSize: 22, fontFamily: 'GH'),
                  ),
                ],
              ),
              SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(width: 30),
                  FaIcon(FontAwesomeIcons.display),
                  SizedBox(width: 15),
                  Text(
                    'theme',
                    style: TextStyle(fontSize: 22, fontFamily: 'GH'),
                  ),
                ],
              ),
              SizedBox(height: 430),
              Padding(
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
                  fontSize: 18,
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
