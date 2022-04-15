import 'package:chat_app/constants.dart';
import 'package:chat_app/screens/user_chats_screen.dart';
import 'package:chat_app/screens/groups_screen.dart';
import 'package:chat_app/screens/setting_screen.dart';
import 'package:chat_app/screens/users_screen.dart';
import 'package:chat_app/widgets/custom_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  //var screens = [HomeScreen(),SearchScreen(),];
  late PageController _pageController;
  int _page = 0;

  void _navigationTapped(int page) {
    _pageController.jumpToPage(page);
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  void _onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Container(
        color: Styles.backgroundPrimary,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          resizeToAvoidBottomInset: false,
          //height: MediaQuery.of(context).size.height * 0.9,

          body: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              width: double.infinity,
              child: PageView(
                physics: const NeverScrollableScrollPhysics(),
                controller: _pageController,
                onPageChanged: _onPageChanged,
                children: <Widget>[
                  UsersScreen(),
                  UserChatsScreen(),
                  const GroupsScreen(),
                  SettingScreen(),
                ],
              ),
            ),
          ),
          bottomNavigationBar: Container(
            margin: EdgeInsets.all(size.width * 0.03),
            height: size.width * 0.1,
            decoration: BoxDecoration(
                color: Styles.primaryColor,
                borderRadius: BorderRadius.circular(20.0),
                boxShadow: Styles.softShadowsInvert),
            child: CustomBottomNavigationBar(
              items: const <IconData>[
                FontAwesomeIcons.users,
                FontAwesomeIcons.solidCommentDots,
                FontAwesomeIcons.solidComments,
                FontAwesomeIcons.gear,
              ],
              iconSize: 35,
              width: double.infinity,
              onTap: _navigationTapped,
              currentIndex: _page,
            ),
          ),
        ),
      ),
    );
  }
}
