import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:mediaflow/core/constants/colors.dart';

class NavigatorSell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const NavigatorSell({
    super.key,
    required this.navigationShell,
  });


  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: BottomNavigationBar(
        iconSize: 24,
        currentIndex: navigationShell.currentIndex,
        onTap: (int index) {
          navigationShell.goBranch(
            index,
            // این گزینه باعث می‌شود اگر روی تب فعلی دوباره کلیک شد، به اول صفحه برگردد (رفتار استاندارد)
            initialLocation: index == navigationShell.currentIndex,
          );
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
             backgroundColor: Colors.transparent 
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.download),
            label: 'Downloads',
            backgroundColor: Colors.transparent
          ),
        ],
      ),
    );
  }
}