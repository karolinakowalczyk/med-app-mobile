import 'package:flutter/material.dart';
import 'package:med_app_mobile/helpers/card_helper.dart';
import 'package:med_app_mobile/helpers/drawer_helper.dart';
import 'package:med_app_mobile/models/user_patient.dart';
import 'package:med_app_mobile/services/auth.dart';
import 'package:provider/provider.dart';

// Główna strona aplikacji z Drawer'em, TabBar'em i wylogowaniem
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
            Tab(child: Text("Appointments", style: TextStyle(fontSize: 16))),
            Tab(child: Text("Prescriptions", style: TextStyle(fontSize: 16))),
            Tab(child: Text("Recommendations", style: TextStyle(fontSize: 16))),
          ],
        ),
      ),
      drawer: const DrawerHelper(),
      body: TabBarView(
        // TODO: wstawić "prawdziwe" kafelki z bazy
        controller: _tabController,
        children: [
          // Każda kolumna to inny Tab, np. tu mamy 'Appointments' ...
          Column(
            children: <Widget>[
              CardHelper().appointCard(
                context,
                'covid vaccination', 
                'Monday, January 27, 2022', 
                '11:45 AM', 
                'dr Garviel Loken'
              ),
            ],
          ),
          // ... a tu mamy już 'Prescriptions'
          Column(
            children: <Widget>[
              CardHelper().prescCard(
                context,
                'asamax 500', 
                'dr Garviel Loken', 
                '6969', 
                '27.06.2022 - 27.07.2022',
                '2x2'
              ),
            ],
          ),
          Column(
            children: <Widget>[
              CardHelper().recomCard(
                context,
                'i don\'t even know', 
                'what is supposed to be here', 
                'Lorem ipsum'
              ),
            ],
          )
        ],
      )
    );
  }
}
