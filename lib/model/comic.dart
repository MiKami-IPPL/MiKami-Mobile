class Comic {
  final int id;
  final String title;
  final String description;
  final String author;
  final String coverUrl;
  final int rate;

  Comic({
    required this.id,
    required this.title,
    required this.description,
    required this.author,
    required this.coverUrl,
    required this.rate,
  });

  factory Comic.fromJson(Map<String, dynamic> json) {
    return Comic(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      author: json['author'],
      coverUrl: json['cover'],
      rate: json['rate'],
    );
  }
}
