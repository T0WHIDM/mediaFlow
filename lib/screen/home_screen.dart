import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mediaflow/screen/contact_us_screen.dart';
import 'package:mediaflow/provider/theme_provider.dart';
import 'package:mediaflow/provider/download_provider.dart'; // فایل جدید را ایمپورت کنید
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
    final downloadProv = context.watch<DownloadProvider>(); //***

    return Scaffold(
      resizeToAvoidBottomInset: false,
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
                child: const Row(
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
              ),
              const SizedBox(height: 50),
              GestureDetector(
                onTap: () {
                  context.read<ThemeProvider>().toggleTheme();
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(width: 30),
                    FaIcon(FontAwesomeIcons.moon),
                    SizedBox(width: 15),
                    Text(
                      'theme',
                      style: TextStyle(fontSize: 22, fontFamily: 'GH'),
                    ),
                  ],
                ),
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
            const SizedBox(height: 220),
            const Text(
              'please enter video url',
              style: TextStyle(fontSize: 22, fontFamily: 'GH'),
            ),
            const SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: TextField(
                controller: _controller,
                focusNode: negahban1,
                decoration: InputDecoration(
                  labelText: 'url',
                  suffixIcon: _controller.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () => _controller.clear(),
                        )
                      : null,
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
            const SizedBox(height: 30),

            //progress bar
            if (downloadProv.isDownloading ||
                downloadProv.statusText.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: Column(
                  children: [
                    if (downloadProv.isDownloading)
                      LinearProgressIndicator(
                        value: downloadProv.progress > 0
                            ? downloadProv.progress
                            : null,
                        backgroundColor: Colors.white,
                        color: const Color.fromARGB(255, 1, 88, 155),
                        minHeight: 10,
                        borderRadius: BorderRadius.circular(5),
                      ),
                    const SizedBox(height: 10),
                    Text(
                      downloadProv.statusText,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'GH',
                        fontSize: 16,
                        color: downloadProv.statusText.contains('❌')
                            ? Colors.red
                            : Colors.white,
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 30),

            // download button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(150, 40),
                backgroundColor: const Color.fromARGB(219, 1, 88, 155),
              ),
              onPressed: downloadProv.isDownloading
                  ? null
                  : () {
                      FocusScope.of(context).unfocus(); //close keyBoard

                      downloadProv.downloadVideo(_controller.text);
                    },
              child: downloadProv.isDownloading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Text(
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
