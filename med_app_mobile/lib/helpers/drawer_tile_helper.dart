import 'package:flutter/material.dart';

// Ta klasa zawiera wzór elementu ListTile do Drawer'a.
class DrawerTileHelper{
  final double _drawerIconSize = 24;
  final double _drawerFontSize = 17;

  ListTile defaultTile(
    BuildContext context,
    IconData icon,
    String name,
    Widget Function() page,
  ) {
    return ListTile(
      leading: Icon(
        icon,
        size: _drawerIconSize,
        color: Theme.of(context).primaryColor,
      ),
      title: Text(
        name,
        style: TextStyle(
          fontSize: _drawerFontSize,
          color: Theme.of(context).primaryColor,
        ),
      ),
      onTap: () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (BuildContext context) {
              return page();
            }
          ),
        );
      },
    );
  }
}

