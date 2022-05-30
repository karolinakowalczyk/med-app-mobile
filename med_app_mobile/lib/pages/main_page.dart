import 'package:flutter/material.dart';
import 'package:med_app_mobile/helpers/card_helper.dart';
import 'package:med_app_mobile/helpers/drawer_helper.dart';
import 'package:med_app_mobile/models/appointment_model.dart';
import 'package:med_app_mobile/models/prescription_model.dart';
import 'package:med_app_mobile/models/user_patient.dart';
import 'package:med_app_mobile/providers/main_page_provider.dart';
import 'package:provider/provider.dart';

// Główna strona aplikacji z Drawer'em, TabBar'em i wylogowaniem
class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>
    with SingleTickerProviderStateMixin, RestorationMixin {
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
      length: 2,
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
    final mainPageProvider =
        Provider.of<MainPageProvider>(context, listen: false);

    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Registration app',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.normal,
            ),
          ),
          iconTheme: const IconThemeData(color: Colors.white),
          bottom: TabBar(
            controller: _tabController,
            tabs: const [
              Tab(
                icon: Icon(Icons.event, size: 18),
                child: Text(
                  "Appointments",
                  style: TextStyle(fontSize: 16),
                ),
              ),
              Tab(
                icon: Icon(Icons.content_paste, size: 18),
                child: Text(
                  "Prescriptions",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
        drawer: const DrawerHelper(),
        body: TabBarView(
          controller: _tabController,
          children: [
            // Każda kolumna to inny Tab, np. tu mamy 'Appointments' ...
            StreamBuilder<List<Appointment>>(
                stream: user != null
                    ? mainPageProvider.appointments(user.id!)
                    : mainPageProvider.appointments(''),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.data!.isNotEmpty) {
                    return SingleChildScrollView(
                      child: Column(children: [
                        ...snapshot.data!.map((app) {
                          return CardHelper().appointCard(
                            context: context,
                            title: app.title,
                            date: app.date,
                            startsTime: app.hour,
                            endsTime: app.endHour,
                            doctor: app.doctor,
                            price: app.price,
                            editing: true,
                            appointmentId: app.id,
                            patientId: user!.id,
                          );
                        }),
                      ]),
                    );
                  } else {
                    return const Center(
                      child: Text('No appointments'),
                    );
                  }
                }),
            // ... a tu mamy już 'Prescriptions'
            StreamBuilder<List<Prescription>>(
              stream: user != null
                  ? mainPageProvider.prescriptions(user.id!)
                  : mainPageProvider.prescriptions(''),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.data!.isNotEmpty) {
                  return SingleChildScrollView(
                    child: Column(children: [
                      ...snapshot.data!.map((presc) {
                        return CardHelper().prescCard(
                          context,
                          user!.name,
                          user.id!,
                          presc.id,
                          presc.doctor,
                          presc.accessCode,
                          presc.medicines,
                          presc.date,
                          presc.date.add(const Duration(days: 31)),
                          presc.done,
                        );
                      })
                    ]),
                  );
                } else {
                  return const Center(
                    child: Text('No prescriptions'),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
