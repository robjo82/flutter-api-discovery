import 'package:flutter/material.dart';
import 'package:myapp/models/found_object.dart';
import 'package:myapp/services/sncf_data.dart';
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

  // Méthode pour choisir une date min
  Future<void> _selectMinDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedMinDate) {
      setState(() {
        _selectedMinDate = picked;
      });
    }
  }

  // Méthode pour choisir une date max
  Future<void> _selectMaxDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedMaxDate) {
      setState(() {
        _selectedMaxDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recherche d\'objets'),
      ),
      body: Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_futureFoundObjects == null) ...[
                TextFormField(
                  controller: _stationController,
                  decoration: InputDecoration(labelText: 'Nom de la gare'),
                ),
                TextFormField(
                  controller: _typeController,
                  decoration: InputDecoration(labelText: 'Type d\'objet'),
                ),
                Row(
                  children: [
                    const Text('Date min : '),
                    TextButton(
                      onPressed: () => _selectMinDate(context),
                      child: Text(_selectedMinDate == null
                          ? 'Sélectionner une date'
                          : '${_selectedMinDate?.day}/${_selectedMinDate?.month}/${_selectedMinDate?.year}'),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Text('Date max : '),
                    TextButton(
                      onPressed: () => _selectMaxDate(context),
                      child: Text(_selectedMaxDate == null
                          ? 'Sélectionner une date'
                          : '${_selectedMaxDate?.day}/${_selectedMaxDate?.month}/${_selectedMaxDate?.year}'),
                    ),
                  ],
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
                  child: FoundObjectsList(foundObjects: _futureFoundObjects!),
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
    );
  }
}
