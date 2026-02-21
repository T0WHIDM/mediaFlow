import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mediaflow/constants/colors.dart'; 
import 'package:mediaflow/screen/home_screen.dart';
import 'package:mediaflow/screen/video_list_screen.dart';

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({super.key});

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [const HomeScreen(), const VideoListScreen()];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _screens),
      bottomNavigationBar: BottomNavigationBar(
        iconSize: 24,
        currentIndex: _selectedIndex,
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        type: BottomNavigationBarType.shifting,
        backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        elevation: 0,

        selectedItemColor: isDark
            ? CustomColor.greenColor
            : CustomColor.blueColor,

        unselectedItemColor: Colors.grey,

        showUnselectedLabels: false,
        selectedLabelStyle: TextStyle(
          fontSize: 14,
          fontFamily: 'GH',
          color: isDark ? CustomColor.greenColor : CustomColor.blueColor,
        ),
        items: const [
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.house),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.download),
            label: 'Downloads',
          ),
        ],
      ),
    );
  }
}
