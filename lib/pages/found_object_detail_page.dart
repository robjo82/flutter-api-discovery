import 'package:flutter/material.dart';
import 'package:flutter_api_discovery/models/found_object.dart';

class FoundObjectDetailPage extends StatelessWidget {
  final FoundObject foundObject;

  const FoundObjectDetailPage({super.key, required this.foundObject});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Found Object Detail'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
                child: Center(
              child: Icon(Icons.no_photography,
                  size: 180, color: Colors.grey[400]),
            )),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                    child: Text(
                  foundObject.nature,
                  softWrap: false,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 28),
                )),
                const SizedBox(
                  width: 8.0,
                ),
                if (foundObject.dateReturned != null)
                  DecoratedBox(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: Colors.green[200]),
                      child: Padding(
                          padding:
                              const EdgeInsets.fromLTRB(4.0, 2.0, 4.0, 2.0),
                          child: Text('Returned',
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
                          child: Text('Lost',
                              style: TextStyle(
                                  color: Colors.red[900], fontSize: 12))))
              ],
            ),
            Text(
              foundObject.type,
              style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 14),
            ),
            const SizedBox(
              height: 8.0,
            ),
            const Divider(
              height: 1,
            ),
            const SizedBox(
              height: 8.0,
            ),
            Row(
              children: [
                const Icon(Icons.train),
                const SizedBox(width: 4.0),
                Text(foundObject.stationName ?? "?",
                    style: const TextStyle(fontSize: 18)),
              ],
            ),
            const SizedBox(
              height: 8.0,
            ),
            Row(
              children: [
                const Icon(Icons.vpn_key),
                const SizedBox(width: 4.0),
                Text(foundObject.stationCode ?? "?",
                    style: const TextStyle(fontSize: 18)),
              ],
            ),
            const SizedBox(
              height: 8.0,
            ),
            Row(
              children: [
                const Icon(Icons.calendar_month),
                const SizedBox(width: 4.0),
                Text(
                    '${foundObject.date.day}/${foundObject.date.month}/${foundObject.date.year}',
                    style: const TextStyle(fontSize: 18)),
              ],
            ),
            const SizedBox(height: 8.0),
            Row(
              children: [
                const Icon(Icons.schedule),
                const SizedBox(width: 4.0),
                Text('${foundObject.date.hour}:${foundObject.date.minute}',
                    style: const TextStyle(fontSize: 18)),
              ],
            ),
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
                  child: const Text('Contact'),
                ))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
