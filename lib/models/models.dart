class Prompt {
  final String id;
  final String title;
  final String description;
  final String content;
  final String category;
  final String? author;
  final DateTime createdAt;
  final int usageCount;
  final bool isFavorite;
  final List<String> tags;

  Prompt({
    required this.id,
    required this.title,
    required this.description,
    required this.content,
    required this.category,
    this.author,
    required this.createdAt,
    this.usageCount = 0,
    this.isFavorite = false,
    this.tags = const [],
  });

  Prompt copyWith({
    String? id,
    String? title,
    String? description,
    String? content,
    String? category,
    String? author,
    DateTime? createdAt,
    int? usageCount,
    bool? isFavorite,
    List<String>? tags,
  }) {
    return Prompt(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      content: content ?? this.content,
      category: category ?? this.category,
      author: author ?? this.author,
      createdAt: createdAt ?? this.createdAt,
      usageCount: usageCount ?? this.usageCount,
      isFavorite: isFavorite ?? this.isFavorite,
      tags: tags ?? this.tags,
    );
  }
}

class Category {
  final String id;
  final String name;
  final String description;
  final String icon;
  final String color;
  final int promptCount;

  Category({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.color,
    required this.promptCount,
  });
}
