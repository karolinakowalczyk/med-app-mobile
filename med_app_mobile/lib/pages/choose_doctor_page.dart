import 'package:flutter/material.dart';
import 'package:med_app_mobile/helpers/theme_helper.dart';

// Ta klasa odpowiada za wyszukanie lekarza
// TODO: trzeba zrobić logikę wyszukiwania i wstawić lekarzy z bazy
class ChooseDoctorPage extends StatefulWidget {
  const ChooseDoctorPage({Key? key}) : super(key: key);

  @override
  State<ChooseDoctorPage> createState() => _ChooseDoctorPageState();
}

class _ChooseDoctorPageState extends State<ChooseDoctorPage> {
  TextEditingController editingController = TextEditingController();
  final duplicateItems = List<String>.generate(50, (i) => "Lorem ipsum $i");
  var items = <String>[];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          height: 60,
          alignment: Alignment.topCenter,
          child: TextFormField(
            controller: editingController,
            decoration: ThemeHelper().textInputDecoration('Search', 'Search', Icons.search),
          ),
        ),
        // TODO: ARTUR - Expanded i automatyczne dopasowanie długości listy byłoby lepsze niż
        // SizedBox, ale wtedy apka ma crash, możesz na to zerknąć jeśli będziesz miał chwilę
        SizedBox(
          height: 320,
          child: ListView.builder(
            shrinkWrap: true,
            itemExtent: 40,
            itemCount: duplicateItems.length,
            padding: const EdgeInsets.only(bottom: 5),
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                title: Text(
                  duplicateItems[index],
                  style: const TextStyle(
                    fontSize: 25,
                  ),
                ),
              );
            }
          ),
        ),
      ],
    );
  }
}

