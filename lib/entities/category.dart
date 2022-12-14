class Category {
  final String id;
  final String name;
  final int iconCode;
  final String iconFontFamily;

  const Category({
    required this.id,
    required this.name,
    required this.iconCode,
    required this.iconFontFamily,
  });

  Category.fromJson(Map json)
      : id = json['id'],
        name = json['name'],
        iconCode = json['iconCode'],
        iconFontFamily = json['iconFontFamily'];

  Map toJson() => {
        'id': id,
        'name': name,
        'iconCode': iconCode,
        'iconFontFamily': iconFontFamily,
      };
}
