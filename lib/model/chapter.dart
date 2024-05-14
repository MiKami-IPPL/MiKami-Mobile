class Chapter {
  final int id;
  final String title;
  final String description;
  final int price;

  Chapter({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
  });

  factory Chapter.fromJson(Map<String, dynamic> json) {
  return Chapter(
    id: json['id'] as int? ?? 0,
    title: json['title'] as String? ?? '', 
    description: json['subtitle'] as String? ?? '', 
    price: json['price'] as int? ?? 0,
  );
}
}
