import 'package:flutter/material.dart';
import 'package:loosted/models/found_object.dart';
import 'package:loosted/pages/found_object_detail_page.dart';
import 'package:loosted/services/database_helper.dart';

class ObjectCard extends StatefulWidget {
  final FoundObject object;
  final DatabaseHelper databaseHelper;

  const ObjectCard(
      {super.key, required this.object, required this.databaseHelper});

  @override
  State<ObjectCard> createState() => _ObjectCardState();
}

class _ObjectCardState extends State<ObjectCard> {
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
                fit: FlexFit.loose,
                child: Text(
                  widget.object.nature,
                  softWrap: false,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18),
                )),
            const SizedBox(
              width: 8.0,
            ),
            Row(
              children: [
                FutureBuilder<bool>(
                    future: widget.databaseHelper.isObjectViewed(widget.object),
                    builder:
                        (BuildContext context, AsyncSnapshot<bool> snapshot) {
                      if (snapshot.hasData && snapshot.data == true) {
                        return DecoratedBox(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color: Colors.grey[400]),
                            child: Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    4.0, 2.0, 4.0, 2.0),
                                child: Text('Vue',
                                    style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 12))));
                      } else {
                        return const SizedBox();
                      }
                    }),
                const SizedBox(
                  width: 4.0,
                ),
                if (widget.object.dateRestituted != null)
                  DecoratedBox(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: Colors.green[200]),
                      child: Padding(
                          padding:
                              const EdgeInsets.fromLTRB(4.0, 2.0, 4.0, 2.0),
                          child: Text('Rendu',
                              style: TextStyle(
                                  color: Colors.green[900], fontSize: 12))))
                else
                  DecoratedBox(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: Colors.red[200]),
                      child: Padding(
                          padding:
                              const EdgeInsets.fromLTRB(4.0, 2.0, 4.0, 2.0),
                          child: Text('Perdu',
                              style: TextStyle(
                                  color: Colors.red[900], fontSize: 12))))
              ],
            )
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.object.type,
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
                Text(widget.object.stationName ?? "?"),
              ],
            ),
            Row(
              children: [
                const Icon(Icons.calendar_month),
                const SizedBox(width: 4.0),
                Text(
                    '${widget.object.date.day}/${widget.object.date.month}/${widget.object.date.year}'),
              ],
            ),
          ],
        ),
        isThreeLine: true,
        onTap: () {
          //sauvegarder la vu de l'objet
          widget.databaseHelper.insertViewedObject(widget.object);

          // Naviguer vers la page de détails lors du clic
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FoundObjectDetailPage(
                foundObject: widget.object,
              ),
            ),
          ).then((_) => setState(() {}));
        },
      ),
    );
  }
}
