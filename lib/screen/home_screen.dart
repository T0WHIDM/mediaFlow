import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mediaflow/screen/contact_us_screen.dart';
import 'package:mediaflow/provider/theme_provider.dart';
import 'package:mediaflow/provider/download_provider.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late FocusNode negahban1; 
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    negahban1 = FocusNode();
    _controller = TextEditingController();

    negahban1.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    negahban1.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
      drawer: _buildDrawer(context), 
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 220),
            const Text(
              'please enter video url',
              style: TextStyle(fontSize: 22, fontFamily: 'GH'),
            ),
            const SizedBox(height: 50),
            
            // TextField
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
                          onPressed: () {
                            _controller.clear();
                            // برای پاک کردن وضعیت دانلود وقتی متن پاک میشه (اختیاری)
                            context.read<DownloadProvider>().clearStatus();
                          },
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


            Consumer<DownloadProvider>(
              builder: (context, downloadProv, child) {
                return Column(
                  children: [
                    // Progress Bar Section
                    if (downloadProv.isDownloading || downloadProv.statusText.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40.0),
                        child: Column(
                          children: [
                            if (downloadProv.isDownloading)
                              LinearProgressIndicator(
                                value: downloadProv.progress > 0 ? downloadProv.progress : null,
                                backgroundColor: Colors.grey[300], 
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

                    // Download Button
                   // Download / Cancel Button
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(150, 40),
                        // تغییر رنگ دکمه در حالت دانلود برای تمایز بهتر (اختیاری)
                        backgroundColor: downloadProv.isDownloading
                            ? Colors.redAccent // رنگ قرمز برای توقف
                            : const Color.fromARGB(219, 1, 88, 155), // رنگ آبی برای دانلود
                      ),
                      onPressed: () {
                        if (downloadProv.isDownloading) {
                          // اگر در حال دانلود است، کنسل کن
                          downloadProv.cancelDownload();
                        } else {
                          // اگر دانلود نمیکند، دانلود را شروع کن
                          FocusScope.of(context).unfocus();
                          downloadProv.downloadVideo(_controller.text);
                        }
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // تغییر آیکون و متن بر اساس وضعیت
                          if (downloadProv.isDownloading) ...[
                            const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            ),
                            const SizedBox(width: 10),
                            const Text(
                              'Stop', // متن دکمه توقف
                              style: TextStyle(
                                fontSize: 20,
                                fontFamily: 'GH',
                                color: Colors.white,
                              ),
                            ),
                          ] else ...[
                            const Text(
                              'Download', // متن دکمه شروع
                              style: TextStyle(
                                fontSize: 22,
                                fontFamily: 'GH',
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
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
            const Spacer(),
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                'version 1.0.0',
                style: TextStyle(fontSize: 18, fontFamily: 'GH'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}