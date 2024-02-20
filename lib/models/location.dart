enum PlaceCategory {
  beach,
  forest,
  city,
  restaurant,
  hotel
}

class Place {
  final String _name;
  final PlaceCategory _category;
  final String _description;
  final String _imagePath;

  Place(this._name, this._category, this._description, this._imagePath);

  String get name => _name;
  PlaceCategory get category => _category;
  String get description => _description;
  String get imagePath => _imagePath;

}