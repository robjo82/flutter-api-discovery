import 'package:flutter/material.dart';
import 'package:myapp/models/found_object.dart';
import 'package:myapp/pages/found_object_detail_page.dart';

class ObjectCard extends StatelessWidget {
  final FoundObject object;

  const ObjectCard({super.key, required this.object});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: ListTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
                child: Text(
              object.nature,
              softWrap: false,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            )),
            const SizedBox(
              width: 8.0,
            ),
            if (object.dateRestituted != null)
              DecoratedBox(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: Colors.green[200]),
                  child: Padding(
                      padding: const EdgeInsets.fromLTRB(4.0, 2.0, 4.0, 2.0),
                      child: Text('Rendu',
                          style: TextStyle(
                              color: Colors.green[900], fontSize: 12))))
            else
              DecoratedBox(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: Colors.red[200]),
                  child: Padding(
                      padding: const EdgeInsets.fromLTRB(4.0, 2.0, 4.0, 2.0),
                      child: Text('Perdu',
                          style:
                              TextStyle(color: Colors.red[900], fontSize: 12))))
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              object.type,
              style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                  overflow: TextOverflow.ellipsis,
                  color: Colors.grey[600]),
            ),
            const SizedBox(
              height: 4.0,
            ),
            const Divider(
              height: 1,
            ),
            const SizedBox(
              height: 4.0,
            ),
            Row(
              children: [
                const Icon(Icons.train),
                const SizedBox(width: 4.0),
                Text(object.stationName ?? "?"),
              ],
            ),
            Row(
              children: [
                const Icon(Icons.calendar_month),
                const SizedBox(width: 4.0),
                Text(
                    '${object.date.day}/${object.date.month}/${object.date.year}'),
              ],
            ),
          ],
        ),
        isThreeLine: true,
        onTap: () {
          // Naviguer vers la page de détails lors du clic
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FoundObjectDetailPage(
                foundObject: object,
              ),
            ),
          );
        },
      ),
    );
  }
}
