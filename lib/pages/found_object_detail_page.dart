import 'package:flutter/material.dart';
import 'package:myapp/models/found_object.dart';

class FoundObjectDetailPage extends StatelessWidget {
  final FoundObject foundObject;

  const FoundObjectDetailPage({super.key, required this.foundObject});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Détails de l\'objet trouvé'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
                child: Center(
              child: Image.asset("assets/logo.png"),
            )),
            Text(
              foundObject.nature,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16.0),
            Text('Type : ${foundObject.type}',
                style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8.0),
            Text('Gare : ${foundObject.stationName}',
                style: const TextStyle(fontSize: 18)),
            Text('Code UIC : ${foundObject.stationCode}',
                style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8.0),
            Text('Date trouvée : ${foundObject.date.toLocal()}',
                style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8.0),
            if (foundObject.dateRestituted != null)
              Text('Restitué le : ${foundObject.dateRestituted!.toLocal()}',
                  style: const TextStyle(fontSize: 18))
            else
              const Text('Pas encore restitué', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 8.0),
            Row(
              children: [
                Expanded(
                    child: ElevatedButton(
                  onPressed: () => {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple[200],
                    foregroundColor: Colors.white,
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                  child: const Text('Contacter'),
                ))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
