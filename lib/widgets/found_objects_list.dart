import 'package:flutter/material.dart';
import 'package:loosted/models/found_object.dart';
import 'package:loosted/services/database_helper.dart';
import 'package:loosted/widgets/object_card.dart';

class FoundObjectsList extends StatefulWidget {
  final List<FoundObject> foundObjects;

  const FoundObjectsList({super.key, required this.foundObjects});

  @override
  State<FoundObjectsList> createState() => _FoundObjectsListState();
}

class _FoundObjectsListState extends State<FoundObjectsList> {
  final DatabaseHelper datahelper = DatabaseHelper();
  late List<bool> _visibleItems;

  @override
  void initState() {
    super.initState();
    _visibleItems = List.generate(widget.foundObjects.length, (_) => false);

    // Déclencher le fade-in progressif des éléments
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _animateItems();
    });
  }

  void _animateItems() {
    for (int i = 0; i < _visibleItems.length; i++) {
      Future.delayed(Duration(milliseconds: i * 100), () {
        if (mounted) {
          setState(() {
            _visibleItems[i] = true;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
      itemCount: widget.foundObjects.length,
      itemBuilder: (context, index) {
        final foundObject = widget.foundObjects[index];

        return AnimatedOpacity(
          opacity: _visibleItems[index] ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeIn,
          child: ObjectCard(
            object: foundObject,
            databaseHelper: datahelper,
          ),
        );
      },
    );
  }
}
