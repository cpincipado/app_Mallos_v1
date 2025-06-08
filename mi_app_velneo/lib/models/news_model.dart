// lib/models/news_model.dart
class NewsModel {
  final String id;
  final String title;
  final String content;
  final String? imageUrl;
  final DateTime publishDate;
  final String? category;
  final bool isHighlighted;

  const NewsModel({
    required this.id,
    required this.title,
    required this.content,
    this.imageUrl,
    required this.publishDate,
    this.category,
    this.isHighlighted = false,
  });

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      imageUrl: json['image_url'],
      publishDate:
          DateTime.tryParse(json['publish_date'] ?? '') ?? DateTime.now(),
      category: json['category'],
      isHighlighted: json['is_highlighted'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'image_url': imageUrl,
      'publish_date': publishDate.toIso8601String(),
      'category': category,
      'is_highlighted': isHighlighted,
    };
  }

  // Formatear fecha para mostrar
  String get formattedDate {
    const months = [
      'enero',
      'febrero',
      'marzo',
      'abril',
      'mayo',
      'junio',
      'julio',
      'agosto',
      'septiembre',
      'octubre',
      'noviembre',
      'diciembre',
    ];

    return '${publishDate.day} ${months[publishDate.month - 1]} ${publishDate.year}';
  }
}
