import 'package:flutter/material.dart';
import 'package:tasker/core/models/task.dart';
import 'package:tasker/views/create.dart';
import 'package:tasker/views/home.dart';
import 'package:tasker/utils/colors.dart';
import 'package:tasker/utils/navigation.dart';

import '../main.dart';


class HomeTabs extends StatefulWidget {
  const HomeTabs({Key key}) : super(key: key);

  @override
  _HomeTabsState createState() => _HomeTabsState();
}

class _HomeTabsState extends State<HomeTabs> {

  int _currentIndex = 0;

  PageController _pageController;

  final List<Widget> _pages = <Widget>[
    const HomeScreen(),
    const MyHomePage(),
    const MyHomePage(),
    const MyHomePage(),

  ];

  @override
  void initState() {
    _pageController = PageController(
      keepPage: false,
      initialPage: 0
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: onPageChanged,
        children: _pages,
        physics: const NeverScrollableScrollPhysics()
      ),

      bottomNavigationBar: BottomAppBar(
        elevation: 10.0,
        shape: const CircularNotchedRectangle(),
        color: XColors.bottomNavColor,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.grid_on, 
                  color: _currentIndex == 0 
                    ? XColors.buttonColor : Colors.white), 
                onPressed: () => onPageChanged(0)
              ),
              IconButton(
                icon: Icon(
                  Icons.bookmark, 
                  color: _currentIndex == 1 
                    ? XColors.buttonColor : Colors.white
                ),
                onPressed: () => onPageChanged(1),
              ),
              const SizedBox(width: 30.0),
              IconButton(
                icon: Icon(
                  Icons.notifications, 
                  color: _currentIndex == 2
                    ? XColors.buttonColor :  Colors.white), 
                onPressed: () => onPageChanged(2)
              ),
              IconButton(
                icon: Icon(
                  Icons.person, 
                  color: _currentIndex == 3 
                    ? XColors.buttonColor : Colors.white),
                onPressed: () => onPageChanged(3),
              )
            ],
          ),
        ), 
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () => push(context, CreateTask(
          Task('', '', '', 1)
        )),
        backgroundColor: XColors.buttonColor,
        child: Icon(Icons.add, color: Colors.white,),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  void onPageChanged(int page) {
    setState(() {
      _currentIndex = page;
    });
    _pageController.animateToPage(page, duration: const Duration(milliseconds: 200), curve: Curves.bounceOut);
  }
}