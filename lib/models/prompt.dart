class Prompt {
  final String id;
  String title;
  String description;
  String content;
  String category;
  String? author;
  DateTime createdAt;
  DateTime updatedAt;
  int usageCount;
  bool isFavorite;
  List<String> tags;
  String? imageUrl;
  String? outputPreview;

  Prompt({
    required this.id,
    required this.title,
    required this.description,
    required this.content,
    required this.category,
    this.author,
    required this.createdAt,
    required this.updatedAt,
    this.usageCount = 0,
    this.isFavorite = false,
    this.tags = const [],
    this.imageUrl,
    this.outputPreview,
  });

  factory Prompt.fromJson(Map<String, dynamic> json) {
    return Prompt(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      content: json['content'] as String,
      category: json['category'] as String,
      author: json['author'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      usageCount: json['usageCount'] as int? ?? 0,
      isFavorite: json['isFavorite'] as bool? ?? false,
      tags: (json['tags'] as List<dynamic>?)?.cast<String>() ?? [],
      imageUrl: json['imageUrl'] as String?,
      outputPreview: json['outputPreview'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'content': content,
      'category': category,
      'author': author,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'usageCount': usageCount,
      'isFavorite': isFavorite,
      'tags': tags,
      'imageUrl': imageUrl,
      'outputPreview': outputPreview,
    };
  }

  Prompt copyWith({
    String? id,
    String? title,
    String? description,
    String? content,
    String? category,
    String? author,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? usageCount,
    bool? isFavorite,
    List<String>? tags,
    String? imageUrl,
    String? outputPreview,
  }) {
    return Prompt(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      content: content ?? this.content,
      category: category ?? this.category,
      author: author ?? this.author,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      usageCount: usageCount ?? this.usageCount,
      isFavorite: isFavorite ?? this.isFavorite,
      tags: tags ?? this.tags,
      imageUrl: imageUrl ?? this.imageUrl,
      outputPreview: outputPreview ?? this.outputPreview,
    );
  }
}

class Category {
  final String id;
  final String name;
  final String description;
  final String icon;
  final String color;
  final String? imageUrl;

  Category({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.color,
    this.imageUrl,
  });
}
