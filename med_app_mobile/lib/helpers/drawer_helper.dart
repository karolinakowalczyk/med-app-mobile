import 'package:flutter/material.dart';
import 'package:med_app_mobile/helpers/drawer_tile_helper.dart';
import 'package:med_app_mobile/pages/appoint_manager_page.dart';
import 'package:med_app_mobile/pages/main_page.dart';

// Dzięki tej klasie będzie można łatwo umieścić Drawer na każdej stronie
class DrawerHelper extends StatelessWidget {
  const DrawerHelper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Drawer(
    child: Container(
      color: Colors.white,
      child: ListView(
        padding: const EdgeInsets.all(0.0),
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor
            ),
            child: Container(
              alignment: Alignment.bottomLeft,
              child: const Text(
                // TODO: wstawić prawdziwą nazwę użytkownika zamiast 'User name'
                'User name',
                style: TextStyle(
                  fontSize: 25,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          DrawerTileHelper().defaultTile(
            context,
            Icons.home,
            'Home',
            () => const MainPage()
          ),
          DrawerTileHelper().defaultTile(
            context, 
            Icons.calendar_month, 
            "Manage appointments", 
            () => const AppointManagerPage()
          ),
          Divider(
            height: 1,
            thickness: 1,
            indent: 30,
            endIndent: 30,
            color: Theme.of(context).primaryColor,
          ),
          // TODO: wstawić prawdziwe wylogowanie
          DrawerTileHelper().defaultTile(
            context, 
            Icons.logout, 
            "Log out", 
            () => const AppointManagerPage()
          ),
        ],
      ),
    ),
  );
}