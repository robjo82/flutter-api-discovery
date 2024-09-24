import 'package:flutter/material.dart';
import 'package:myapp/models/found_object.dart';
import 'package:myapp/services/sncf_data.dart';
import 'package:myapp/widgets/custom_text_input.dart';
import 'package:myapp/widgets/date_picker.dart';
import 'package:myapp/widgets/found_objects_list.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<FoundObject>? _futureFoundObjects;

  final TextEditingController _stationController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();
  DateTime? _selectedMinDate;
  DateTime? _selectedMaxDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromRGBO(245, 223, 255, 1),
        appBar: AppBar(
          title: Image.asset("assets/logo-dark.png", width: 160),
          centerTitle: true,
          backgroundColor: Color.fromRGBO(245, 223, 255, 1),
        ),
        body: Expanded(
            child: Container(
          margin: const EdgeInsets.only(top: 8.0),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Recherche d'objets",
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                        color: Colors.grey[800]),
                  ),
                  Divider(
                    height: 2,
                    color: Colors.purple[200],
                    thickness: 2,
                    endIndent: 250,
                  ),
                  if (_futureFoundObjects == null) ...[
                    CustomTextInput(
                      controller: _stationController,
                      backgroundColor: Colors.grey[200],
                      placeholder: 'Nom de la gare',
                      borderRadius: 15.0,
                      icon: Icons.train,
                    ),
                    CustomTextInput(
                      controller: _typeController,
                      backgroundColor: Colors.grey[200],
                      placeholder: 'Type d\'objet',
                      borderRadius: 15.0,
                      icon: Icons.handyman,
                    ),
                    DatePicker(
                      backgroundColor: Colors.grey[200],
                      borderRadius: 15,
                      initialMinDate: _selectedMinDate,
                      initialMaxDate: _selectedMaxDate,
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Expanded(
                            child: ElevatedButton(
                          onPressed: () {
                            // Rechercher et afficher les résultats
                            final String stationName = _stationController.text;
                            final String objectType = _typeController.text;
                            SncfData()
                                .searchFoundObjects(
                              stationName: stationName,
                              objectType: objectType,
                              dateMin: _selectedMinDate,
                              dateMax: _selectedMaxDate,
                            )
                                .then((value) {
                              setState(() {
                                _futureFoundObjects = value;
                              });
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.purple[200],
                            foregroundColor: Colors.white,
                            textStyle: const TextStyle(fontSize: 18),
                          ),
                          child: const Text('Rechercher'),
                        ))
                      ],
                    )
                  ] else ...[
                    Expanded(
                      child:
                          FoundObjectsList(foundObjects: _futureFoundObjects!),
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: ElevatedButton(
                          onPressed: () => {
                            setState(() {
                              _futureFoundObjects = null;
                              _stationController.clear();
                              _typeController.clear();
                              _selectedMaxDate = null;
                              _selectedMinDate = null;
                            })
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.purple[200],
                            foregroundColor: Colors.white,
                            textStyle: const TextStyle(fontSize: 18),
                          ),
                          child: const Text('Nouvelle recherche'),
                        ))
                      ],
                    )
                  ]
                ],
              )),
        )));
  }
}
