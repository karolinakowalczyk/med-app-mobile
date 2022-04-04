import 'package:flutter/material.dart';
import 'package:med_app_mobile/models/user_patient.dart';
import 'package:med_app_mobile/pages/appoint_manager_page.dart';
import 'package:med_app_mobile/services/auth.dart';
import 'package:provider/provider.dart';
import 'package:med_app_mobile/helpers/drawer_tile_helper.dart';

// Główna strona aplikacji z Drawer'em, TabBar'em i wylogowaniem, --- w trakcie tworzenia ---
class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with 
  SingleTickerProviderStateMixin, 
  RestorationMixin {

  final AuthServices _auth = AuthServices();
  late TabController _tabController;
  final RestorableInt tabIndex = RestorableInt(0);

  @override
  String get restorationId => 'tab_scrollable';

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(tabIndex, 'tab_index');
    _tabController.index = tabIndex.value;
  }

  @override
  void initState() {
    _tabController = TabController(
      initialIndex: 0,
      length: 3,
      vsync: this,
    );
    _tabController.addListener(() {
      setState(() {
        tabIndex.value = _tabController.index;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    tabIndex.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserPatient?>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Registration app',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.normal,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          /* TODO: to ma być przycisk do powiadomień ale przedtem trzeba wrzucić
           wylogowanie do Drawer'a */
          IconButton(
            onPressed: () => _auth.signOut(),
            icon: const Icon(Icons.logout,)
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(text: "Appointments",),
            Tab(text: "Prescriptions",),
            Tab(text: "Recommendations",),
          ],
        ),
      ),
      drawer: Drawer(
        child: Container(
          color: Colors.white,
          child: ListView(
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
              /* TODO: w "Manage appointments" i "Log out" wstawić ścieżki
               prowadzące do odpowiednich stron aplikacji */
              DrawerTileHelper().defaultTile(
                context, 
                Icons.calendar_month, 
                "Manage appointments", 
                () => const AppointManagerPage()
              ),
              Divider(
                color: Theme.of(context).primaryColor,
                height: 1,
              ),
              DrawerTileHelper().defaultTile(
                context, 
                Icons.logout, 
                "Log out", 
                () => const AppointManagerPage()
              ),
            ],
          ),
        ),
      ),
      body: TabBarView(
        // TODO: wstawić kafelki z wizytami, receptami itd.
        controller: _tabController,
        children: const [
          Center(
            child: Text("Appointments")
          ),
          Center(
            child: Text("Prescriptions")
          ),
          Center(
            child: Text("Recommendations")
          )
        ],
      )
    );
  }
}
