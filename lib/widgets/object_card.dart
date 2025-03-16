import 'package:flutter/material.dart';
import 'package:flutter_api_discovery/models/found_object.dart';
import 'package:flutter_api_discovery/pages/found_object_detail_page.dart';
import 'package:flutter_api_discovery/services/database_helper.dart';
import 'package:flutter_api_discovery/widgets/badge.dart';

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
          children: [
            Flexible(
              child: Text(
                widget.object.nature,
                softWrap: false,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
            Row(
              children: [
                FutureBuilder<bool>(
                  future: widget.databaseHelper.isObjectViewed(widget.object),
                  builder: (context, snapshot) {
                    if (snapshot.hasData && snapshot.data == true) {
                      return const CustomBadge(
                        text: 'View',
                        backgroundColor: Colors.grey,
                        textColor: Colors.white,
                      );
                    } else {
                      return const SizedBox();
                    }
                  },
                ),
                const SizedBox(width: 4.0),
                if (widget.object.dateReturned != null)
                  const CustomBadge(
                    text: 'Returned',
                    backgroundColor: Colors.green,
                    textColor: Colors.white,
                  )
                else
                  const CustomBadge(
                    text: 'Lost',
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                  ),
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
          widget.databaseHelper.insertViewedObject(widget.object);

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
