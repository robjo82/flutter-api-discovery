import 'package:flutter/material.dart';
import 'package:myapp/models/found_object.dart';
import 'package:myapp/pages/search_page.dart';
import 'package:myapp/services/sncf_data.dart';
import 'package:myapp/widgets/found_objects_list.dart';
import 'package:myapp/widgets/icon_button_text.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Loosted',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.purple),
        primaryColor: Colors.purple[400],
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<List<FoundObject>> _futureFoundObjects;

  @override
  void initState() {
    super.initState();
    _futureFoundObjects =
        SncfData().fetchFoundObjects(); // Récupérer les données au démarrage
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: const Color.fromRGBO(245, 223, 255, 1),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset("assets/logo-dark.png", width: 200),
                    const SizedBox(
                      height: 24,
                    ),
                    IconTextButton(
                        text: "Rechercher un objet",
                        icon: Icons.search,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SearchPage(),
                            ),
                          );
                        }),
                  ],
                )),
            Expanded(
                child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20)),
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
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Objets fraichement trouvés!",
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
                      Expanded(
                        child: FutureBuilder<List<FoundObject>>(
                          future:
                              _futureFoundObjects, // Future contenant les données
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              // Afficher un loader tant que les données ne sont pas disponibles
                              return const Center(
                                  child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              // En cas d'erreur
                              return Center(
                                  child: Text('Erreur: ${snapshot.error}'));
                            } else if (snapshot.hasData) {
                              // Si les données sont disponibles, afficher la liste
                              return FoundObjectsList(
                                  foundObjects: snapshot.data!);
                            } else {
                              return const Center(
                                  child: Text('Aucun objet trouvé.'));
                            }
                          },
                        ),
                      )
                    ],
                  )),
            ))
          ],
        ),
      ),
    ));
  }
}
