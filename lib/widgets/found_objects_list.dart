import 'package:flutter/material.dart';
import 'package:myapp/models/found_object.dart';

class FoundObjectsList extends StatelessWidget {
  final List<FoundObject> foundObjects;

  const FoundObjectsList({super.key, required this.foundObjects});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Objets Trouvés'),
      ),
      body: ListView.builder(
        itemCount: foundObjects.length,
        itemBuilder: (context, index) {
          final foundObject = foundObjects[index];
          return ListTile(
            title: Text(foundObject.type),
            subtitle: Text(
                'Trouvé à ${foundObject.station} le ${foundObject.dateFound.toLocal()}'),
            trailing: foundObject.dateRestituted != null
                ? Text('Restitué le ${foundObject.dateRestituted!.toLocal()}')
                : const Text('Pas encore restitué'),
          );
        },
      ),
    );
  }
}
