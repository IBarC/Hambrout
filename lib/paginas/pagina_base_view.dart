import 'dart:io';

import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/material.dart';

import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import '../main.dart';

/// Clase que genera la base de la app con la barra de navegación permanente
class PaginaBaseWidget extends StatefulWidget{
  const PaginaBaseWidget({super.key});

  @override
  State<StatefulWidget> createState() {
    return _PaginaBase();
  }
}

class _PaginaBase extends State<PaginaBaseWidget>{

  final PersistentTabController _controller = PersistentTabController(initialIndex: 0);

  static final List<PersistentBottomNavBarItem> _navBarsItems = <PersistentBottomNavBarItem>[
    PersistentBottomNavBarItem(
      icon: const Icon(Icons.location_on_outlined,),
      activeColorPrimary: Colors.orange,
      inactiveColorPrimary: Colors.black12,
    ),
    PersistentBottomNavBarItem(
      icon: const Icon(Icons.house_outlined),
      activeColorPrimary: Colors.orange,
      inactiveColorPrimary: Colors.black12,
    ),
    PersistentBottomNavBarItem(
      icon: const Icon(Icons.star_purple500_rounded,),
      activeColorPrimary: Colors.orange,
      inactiveColorPrimary: Colors.black12,
    ),
    PersistentBottomNavBarItem(
      icon: const Icon(Icons.event_note,),
      activeColorPrimary: Colors.orange,
      inactiveColorPrimary: Colors.black12,
    ),
    PersistentBottomNavBarItem(
      icon: const Icon(Icons.settings),
      activeColorPrimary: Colors.orange,
      inactiveColorPrimary: Colors.black12,
    ),
  ];

  @override
  void initState() {
    super.initState();
    BackButtonInterceptor.add(myInterceptor);
  }

  @override
  void dispose() {
    BackButtonInterceptor.remove(myInterceptor);
    super.dispose();
  }

  bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    if(_controller.index==0){
      exit(0);
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {

    return PersistentTabView(
      context,
      controller: _controller,
      screens: pages,
      items: _navBarsItems,
      confineInSafeArea: true,
      backgroundColor: Colors.white,
      handleAndroidBackButtonPress: true,
      resizeToAvoidBottomInset: true,
      stateManagement: true, // Default is true.
      hideNavigationBarWhenKeyboardShows: true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
      decoration: NavBarDecoration(
        colorBehindNavBar: Colors.white,
        border: Border.all(color: Colors.black12,width: 1,style: BorderStyle.solid)
      ),
      popAllScreensOnTapOfSelectedTab: false,
      popActionScreens: PopActionScreensType.all,
      itemAnimationProperties: const ItemAnimationProperties( // Navigation Bar's items animation properties.
        duration: Duration(milliseconds: 200),
        curve: Curves.ease,
      ),
      screenTransitionAnimation: const ScreenTransitionAnimation( // Screen transition animation on change of selected tab.
        animateTabTransition: true,
        curve: Curves.ease,
        duration: Duration(milliseconds: 200),
      ),
      navBarStyle: NavBarStyle.style6, // Choose the nav bar style with this property.
    );
  }
}