import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class SearchPlace extends StatefulWidget {
  const SearchPlace({
    super.key,
    required this.places,
    required this.addFunc,
  });

  final List<QueryDocumentSnapshot<Map<String, dynamic>>> places;
  final Function(Map<String, dynamic>, String) addFunc;

  @override
  State<SearchPlace> createState() => _SearchPlaceState();
}

class _SearchPlaceState extends State<SearchPlace> {
  late List<Map<String, dynamic>> _matchPlaces;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _matchPlaces = _check(widget.places, '');
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).colorScheme.background,
      content: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context)
                        .colorScheme
                        .onBackground
                        .withOpacity(0.3),
                    blurRadius: 4,
                  )
                ],
              ),
              child: TextFormField(
                onChanged: (value) {
                  setState(() {
                    _matchPlaces = _check(widget.places, value);
                  });
                },
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.only(left: 20),
                  labelStyle: Theme.of(context).textTheme.labelSmall,
                  labelText: 'Your Plan',
                ),
              ),
            ),
            Column(
              children: List.generate(
                (_matchPlaces.length > 3) ? 3 : _matchPlaces.length,
                (index) => ListTile(
                  onTap: () {
                    widget.addFunc(_matchPlaces[index], widget.places[index].id);
                    Navigator.pop(context);
                  },
                  leading: const Icon(Ionicons.locate),
                  title: Text(
                    _matchPlaces[index]['name'],
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                  subtitle: Text(
                    _matchPlaces[index]['located'],
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'cancle',
                    style: Theme.of(context)
                        .textTheme
                        .labelMedium!
                        .copyWith(color: Colors.red),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _check(
    List<QueryDocumentSnapshot<Map<String, dynamic>>> places,
    String input,
  ) {
    List<Map<String, dynamic>> temp = [];
    for (var i in places) {
      String placeName = i.data()['name'];
      if (placeName.contains(input)) {
        temp.add(i.data());
      }
    }

    return temp;
  }
}
