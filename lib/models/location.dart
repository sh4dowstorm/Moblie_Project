enum PlaceCategory { beach, forest, city, restaurant, hotel }

class Place {
  final String name;
  final PlaceCategory category;
  final String description;
  final String imagePath;
  final String located;
  final double rated;

  Place({
    required this.name,
    required this.category,
    required this.description,
    required this.imagePath,
    required this.located,
    required this.rated,
  });
}
