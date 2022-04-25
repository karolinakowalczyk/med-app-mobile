import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChooseDatePage extends StatefulWidget {
  const ChooseDatePage({Key? key}) : super(key: key);

  @override
  State<ChooseDatePage> createState() => _ChooseDatePageState();
}

class _ChooseDatePageState extends State<ChooseDatePage> {
  DateTime currentDate = DateTime.now();
  late String formattedDate = DateFormat('dd-MM-yyy').format(currentDate);

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: currentDate,
        firstDate: DateTime(2021),
        lastDate: DateTime(2050));
    if (pickedDate != null && pickedDate != currentDate) {
      setState(() {
        formattedDate = DateFormat('dd-MM-yyy').format(pickedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        // TODO: tutaj mają być dane lekarza
        Card(
            elevation: 5,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const <Widget>[
                ListTile(
                  title: Text('dr Saul Tarvitz'),
                  trailing: Icon(Icons.person),
                )
              ],
            )),
        Card(
          elevation: 5,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Text(
                  formattedDate,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              OutlinedButton(
                  onPressed: () => _selectDate(context),
                  child: const Icon(Icons.calendar_month),
                  style: OutlinedButton.styleFrom(
                      side: BorderSide.none,
                      padding: const EdgeInsets.only(left: 5))),
            ],
          ),
        ),
        /* TODO: tutaj mają być dostępne dni i godziny przyjęć
        Ok, tutaj trzeba dodać okna w których będą godziny, dać jakiś
        fajny Padding albo Margin, jeśli bardzo ściśniesz okna godzin i samych
        godzin będzie w bazie mało to nawet nie będziesz musiał nic przewijać.
        Jeszcze jakiś komunikat w stylu "Wszystkie godziny zajęte" jak nie ma 
        już miejsc.
        */
        Card(
          elevation: 5,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const ListTile(
                title: Text('Tuesday, 28.06.2022'),
                trailing: Icon(Icons.schedule),
              ),
              /*const Padding(
                padding: EdgeInsets.only(left: 15, top: 15),
                child: Text(
                  'Tuesday, 28.06.2022',
                  style: TextStyle(fontSize: 17),
                ),
              ),*/
              SizedBox(
                height: 196,
                child: GridView.count(
                  crossAxisCount: 4,
                  children: [
                    ...List.generate(9, (index) {
                      return Center(
                        child: Text(
                          'Index $index',
                          style: const TextStyle(fontSize: 17),
                        ),
                      );
                    })
                  ],
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
