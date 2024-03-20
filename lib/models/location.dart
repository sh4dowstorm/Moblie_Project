enum PlaceCategory { beach, forest, city, restaurant, hotel }

class Place {
  final String name;
  final PlaceCategory category;
  final String description;
  final String image;
  final String located;

  Place({
    required this.name,
    required this.category,
    required this.description,
    required this.image,
    required this.located,
  });

  // @override
  // String toString() {
  //   // TODO: implement toString
  //   return super.toString();
  // }
}
