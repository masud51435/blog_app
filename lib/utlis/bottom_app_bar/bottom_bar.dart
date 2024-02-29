import 'package:blog_app/view/HomePage/HomeScreen.dart';
import 'package:blog_app/view/Post/add_post.dart';
import 'package:blog_app/view/profile/profile.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  final PersistentTabController _controller =
      PersistentTabController(initialIndex: 0);

  List<Widget> _screens() {
    return [
      const HomePage(),
      const Center(
        child: Text('dashBoard'),
      ),
      const AddPost(),
      const Center(
        child: Text('dashBoard'),
      ),
      const ProfileView(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarItems() {
    return [
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.home_outlined),
        title: 'Home',
        activeColorPrimary: Colors.blue.shade300,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.chat_bubble_outline),
        title: "Chat",
        activeColorPrimary: Colors.teal,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.add),
        title: "Add",
        activeColorPrimary: Colors.blueAccent,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.people_outline),
        title: "People",
        activeColorPrimary: Colors.cyan.shade300,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.person_outline),
        title: "Profile",
        activeColorPrimary: Colors.lightGreen.shade300,
        inactiveColorPrimary: Colors.grey,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      controller: _controller,
      items: _navBarItems(),
      screens: _screens(),
      navBarStyle: NavBarStyle.style12,
      navBarHeight: 50,
      backgroundColor: const Color.fromARGB(255, 58, 64, 84),
      padding: const NavBarPadding.all(10),
      margin: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
      bottomScreenMargin: 0,
      decoration: NavBarDecoration(
        borderRadius: BorderRadius.circular(40),
      ),
    );
  }
}
