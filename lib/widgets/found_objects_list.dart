import 'package:flutter/material.dart';
import 'package:myapp/models/found_object.dart';
import 'package:myapp/pages/found_object_detail_page.dart';
import 'package:myapp/widgets/object_card.dart';

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
        return ObjectCard(object: foundObject);
      },
    );
  }
}
