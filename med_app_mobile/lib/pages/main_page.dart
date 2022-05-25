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
    final mainPageProvider =
        Provider.of<MainPageProvider>(context, listen: false);

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
              onPressed: () => () {},
              icon: const Icon(
                Icons.notifications,
              ),
            ),
          ],
          bottom: TabBar(
            controller: _tabController,
            isScrollable: true,
            tabs: const [
              Tab(
                child: Text(
                  "Appointments",
                  style: TextStyle(fontSize: 16),
                ),
              ),
              Tab(
                child: Text(
                  "Prescriptions",
                  style: TextStyle(fontSize: 16),
                ),
              ),
              Tab(
                child: Text(
                  "Recommendations",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
        drawer: const DrawerHelper(),
        body: TabBarView(
          // TODO: wstawić "prawdziwe" kafelki z bazy
          controller: _tabController,
          children: [
            // Każda kolumna to inny Tab, np. tu mamy 'Appointments' ...
            StreamBuilder<List<Appointment>>(
                stream: mainPageProvider.appointments(user!.id ?? ''),
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
                            context,
                            app.title,
                            app.date,
                            app.hour,
                            'Doctor: ' + app.doctor,
                            true,
                            appointmentId: app.id,
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
              stream: mainPageProvider.prescriptions(user.id ?? ''),
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
                          user.name,
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
                    ]
                        // <Widget>[
                        //   CardHelper().prescCard(
                        //     context,
                        //     'asamax 500',
                        //     'dr Garviel Loken',
                        //     '6969',
                        //     '27.06.2022 - 27.07.2022',
                        //     '2x2',
                        //   ),
                        // ],
                        ),
                  );
                } else {
                  return const Center(
                    child: Text('No prescriptions'),
                  );
                }
              },
            ),
            SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  CardHelper().recomCard(context, 'i don\'t even know',
                      'what is supposed to be here', 'Lorem ipsum'),
                ],
              ),
            )
          ],
        ));
  }
}
