import 'package:flutter/material.dart';
import 'package:flutter_api_discovery/models/found_object.dart';
import 'package:flutter_api_discovery/services/database_helper.dart';
import 'package:flutter_api_discovery/services/sncf_data.dart';
import 'package:flutter_api_discovery/widgets/custom_text_input.dart';
import 'package:flutter_api_discovery/widgets/date_picker.dart';
import 'package:flutter_api_discovery/widgets/found_objects_list.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<FoundObject>? _futureFoundObjects;
  List<Map<String, dynamic>> _recentSearches = [];

  final TextEditingController _stationController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();
  DateTime? _selectedMinDate;
  DateTime? _selectedMaxDate;
  bool onlyView = false;

  @override
  void initState() {
    super.initState();
    _loadRecentSearches();
  }

  Future<void> _loadRecentSearches() async {
    List<Map<String, dynamic>> searches =
        await DatabaseHelper().getRecentSearches();
    setState(() {
      _recentSearches = searches;
    });
  }

  void _searchFromRecent(Map<String, dynamic> recentSearch) {
    setState(() {
      _stationController.text = recentSearch['station_name'] ?? '';
      _typeController.text = recentSearch['object_type'] ?? '';
      _selectedMinDate = DateTime.tryParse(recentSearch['date_min'] ?? '');
      _selectedMaxDate = DateTime.tryParse(recentSearch['date_max'] ?? '');
      onlyView =
          recentSearch['only_new'] == 1; // SQLite stocke booléens comme int
    });

    SncfData()
        .searchFoundObjects(
            stationName: _stationController.text,
            objectType: _typeController.text,
            dateMin: _selectedMinDate,
            dateMax: _selectedMaxDate,
            onlyNew: onlyView)
        .then((value) {
      setState(() {
        _futureFoundObjects = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: const Color.fromRGBO(245, 223, 255, 1),
        appBar: AppBar(
          title: Image.asset("assets/logo.png", width: 160),
          centerTitle: true,
          backgroundColor: const Color.fromRGBO(245, 223, 255, 1),
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
                offset: const Offset(0, 3),
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
                    "Search for lost objects",
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
                      placeholder: 'Train station',
                      borderRadius: 15.0,
                      icon: Icons.train,
                      suggestions: SncfData().trainStations,
                    ),
                    CustomTextInput(
                      controller: _typeController,
                      backgroundColor: Colors.grey[200],
                      placeholder: 'Object type',
                      borderRadius: 15.0,
                      icon: Icons.handyman,
                      suggestions: SncfData().objectTypes,
                    ),
                    DatePicker(
                      backgroundColor: Colors.grey[200],
                      borderRadius: 15,
                      initialMinDate: _selectedMinDate,
                      initialMaxDate: _selectedMaxDate,
                    ),
                    CheckboxListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 2, vertical: 0),
                      title: const Text("New objects only"),
                      value: onlyView,
                      onChanged: (value) {
                        setState(() {
                          onlyView = value!;
                        });
                      },
                    ),
                    if (_recentSearches.isNotEmpty) ...[
                      const Divider(
                        height: 1,
                        thickness: 1,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Recent searches",
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: Colors.grey[800]),
                      ),
                      Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: _recentSearches.length,
                          itemBuilder: (context, index) {
                            final search = _recentSearches[index];

                            String station = search['station_name'] ?? '';
                            String objectType = search['object_type'] ?? '';
                            String dateMin = search['date_min'] != null
                                ? 'From ${search['date_min']}'
                                : '';
                            String dateMax = search['date_max'] != null
                                ? 'To ${search['date_max']}'
                                : '';
                            bool onlyNew =
                                search['only_new'] == 1;

                            String title = '';
                            String subtitle = '';

                            if (station.isNotEmpty || objectType.isNotEmpty) {
                              title = '${station.isNotEmpty ? station : ''}'
                                  '${station.isNotEmpty && objectType.isNotEmpty ? ' - ' : ''}'
                                  '${objectType.isNotEmpty ? objectType : ''}';
                              subtitle = [
                                dateMin,
                                dateMax,
                                onlyNew ? 'New objects only' : ''
                              ]
                                  .where((element) => element.isNotEmpty)
                                  .join('\n');
                            } else {
                              title = [
                                dateMin,
                                dateMax,
                                onlyNew ? 'New objects only' : ''
                              ]
                                  .where((element) => element.isNotEmpty)
                                  .join('\n');
                            }

                            return ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: Icon(Icons.history,
                                  color: Colors
                                      .grey[700]),
                              title: Text(title),
                              subtitle:
                                  subtitle.isNotEmpty ? Text(subtitle) : null,
                              trailing: IconButton(
                                icon: const Icon(Icons.close,
                                    color: Colors.purple),
                                onPressed: () async {
                                  await DatabaseHelper()
                                      .deleteRecentSearch(search['id']);
                                  _loadRecentSearches();                                },
                              ),
                              onTap: () => _searchFromRecent(search),
                            );
                          },
                        ),
                      )
                    ] else ...[
                      const Spacer(),
                    ],

                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                            child: ElevatedButton(
                          onPressed: () {
                            final String stationName = _stationController.text;
                            final String objectType = _typeController.text;

                            DatabaseHelper().insertRecentSearch(
                                stationName: stationName,
                                objectType: objectType,
                                dateMin: _selectedMinDate,
                                dateMax: _selectedMaxDate,
                                onlyNew: onlyView);

                            SncfData()
                                .searchFoundObjects(
                                    stationName: stationName,
                                    objectType: objectType,
                                    dateMin: _selectedMinDate,
                                    dateMax: _selectedMaxDate,
                                    onlyNew: onlyView)
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
                          child: const Text('Search'),
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
                            }),
                            _loadRecentSearches()
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.purple[200],
                            foregroundColor: Colors.white,
                            textStyle: const TextStyle(fontSize: 18),
                          ),
                          child: const Text('New Search'),
                        ))
                      ],
                    )
                  ]
                ],
              )),
        )));
  }
}
