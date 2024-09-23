import 'package:flutter/material.dart';
import 'package:myapp/models/found_object.dart';
import 'package:myapp/pages/found_object_detail_page.dart';

class FoundObjectsList extends StatelessWidget {
  final List<FoundObject> foundObjects;

  const FoundObjectsList({super.key, required this.foundObjects});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
      itemCount: foundObjects.length,
      itemBuilder: (context, index) {
        final foundObject = foundObjects[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: ListTile(
            title: Text(
              foundObject.nature,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Type : ${foundObject.type}'),
                Text('Gare : ${foundObject.stationName}'),
                Text(
                    'Date trouvée : ${foundObject.date.day}/${foundObject.date.month}/${foundObject.date.year}'),
                if (foundObject.dateRestituted != null)
                  Text('Restitué le : ${foundObject.dateRestituted!.toLocal()}')
                else
                  const Text('Pas encore restitué'),
              ],
            ),
            isThreeLine: true,
            onTap: () {
              // Naviguer vers la page de détails lors du clic
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FoundObjectDetailPage(
                    foundObject: foundObject,
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
