import 'package:flutter/material.dart';
import 'package:med_app_mobile/helpers/drawer_tile_helper.dart';
import 'package:med_app_mobile/models/appointment_type.dart';
import 'package:med_app_mobile/models/doctor_model.dart';
import 'package:med_app_mobile/models/user_patient.dart';
import 'package:med_app_mobile/pages/appoint_manager_page.dart';
import 'package:med_app_mobile/pages/auth_wrapper.dart';
import 'package:med_app_mobile/pages/main_page.dart';
import 'package:med_app_mobile/providers/doctors_data_provider.dart';
import 'package:med_app_mobile/services/auth.dart';
import 'package:provider/provider.dart';

// Dzięki tej klasie będzie można łatwo umieścić Drawer na każdej stronie
class DrawerHelper extends StatelessWidget {
  const DrawerHelper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserPatient?>(context);
    final AuthServices _auth = AuthServices();
    final _doctorDataProvider =
        Provider.of<DoctorDataProvider>(context, listen: false);
    final Stream<List<Doctor>> _doctors = _doctorDataProvider.doctors;
    final Stream<List<AppointmentCategory>> _appointmentsTypes =
        _doctorDataProvider.appointmentCategories;
    return Drawer(
      child: Container(
        color: Colors.white,
        child: ListView(
          padding: const EdgeInsets.all(0.0),
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Theme.of(context).primaryColor),
              child: Container(
                alignment: Alignment.bottomLeft,
                child: Text(
                  user == null ? "" : user.name,
                  style: const TextStyle(
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
              () => const MainPage(),
              false,
            ),
            DrawerTileHelper().defaultTile(
              context,
              Icons.calendar_month,
              "Manage appointments",
              () => AppointManagerPage(
                doctorsStream: _doctors,
                appCategoriesStream: _appointmentsTypes,
              ),
              false,
            ),
            Divider(
              height: 1,
              thickness: 1,
              indent: 30,
              endIndent: 30,
              color: Theme.of(context).primaryColor,
            ),
            DrawerTileHelper().defaultTile(
              context,
              Icons.logout,
              "Log out",
              () => const AuthWrapper(),
              true,
              logout: () async {
                await _auth.signOut();
              },
            ),
          ],
        ),
      ),
    );
  }
}
