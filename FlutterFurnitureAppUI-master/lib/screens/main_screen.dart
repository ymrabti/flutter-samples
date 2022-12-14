import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:furniture_app/screens/home.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  PageController _pageController;
  int _page = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        physics: BouncingScrollPhysics(),
        controller: _pageController,
        onPageChanged: onPageChanged,
        children: List.generate(4, (index) => Home()),
      ),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Theme.of(context).primaryColor,
          //   primaryColor: Theme.of(context).,
          textTheme: Theme.of(context).textTheme.copyWith(
                caption: TextStyle(color: Colors.grey[500]),
              ),
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(
                Feather.home,
              ),
              label: 'home',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Feather.heart,
              ),
              label: 'heart',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Feather.user,
              ),
              label: 'user',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Feather.grid,
              ),
              label: 'grid',
            ),
          ],
          onTap: navigationTapped,
          currentIndex: _page,
        ),
      ),
    );
  }

  void navigationTapped(int page) {
    _pageController.animateToPage(
      page,
      curve: Curves.bounceIn,
      duration: Duration(milliseconds: 500),
    );
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 2);
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  void onPageChanged(int page) {
    setState(() {
      this._page = page;
    });
  }
}
