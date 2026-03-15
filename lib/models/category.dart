import 'package:flutter/material.dart';

class Category {
  final String id;
  String name;
  String iconName;
  String colorHex;
  bool isDefault;
  bool isCustom;
  int order;

  Category({
    required this.id,
    required this.name,
    required this.iconName,
    required this.colorHex,
    this.isDefault = false,
    this.isCustom = false,
    this.order = 0,
  });

  IconData get icon {
    return _iconMap[iconName] ?? Icons.category;
  }

  Color get color {
    return Color(int.parse(colorHex.replaceFirst('#', '0xFF')));
  }

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] as String,
      name: json['name'] as String,
      iconName: json['iconName'] as String,
      colorHex: json['colorHex'] as String,
      isDefault: json['isDefault'] as bool? ?? false,
      isCustom: json['isCustom'] as bool? ?? false,
      order: json['order'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'iconName': iconName,
      'colorHex': colorHex,
      'isDefault': isDefault,
      'isCustom': isCustom,
      'order': order,
    };
  }

  Category copyWith({
    String? id,
    String? name,
    String? iconName,
    String? colorHex,
    bool? isDefault,
    bool? isCustom,
    int? order,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      iconName: iconName ?? this.iconName,
      colorHex: colorHex ?? this.colorHex,
      isDefault: isDefault ?? this.isDefault,
      isCustom: isCustom ?? this.isCustom,
      order: order ?? this.order,
    );
  }

  static const Map<String, IconData> _iconMap = {
    'home': Icons.home,
    'star': Icons.star,
    'favorite': Icons.favorite,
    'bookmark': Icons.bookmark,
    'category': Icons.category,
    'label': Icons.label,
    'tag': Icons.tag,
    'flag': Icons.flag,
    'assignment': Icons.assignment,
    'task_alt': Icons.task_alt,
    'palette': Icons.palette,
    'image': Icons.image,
    'videocam': Icons.videocam,
    'movie': Icons.movie,
    'edit_document': Icons.edit_document,
    'create': Icons.create,
    'code': Icons.code,
    'developer_mode': Icons.developer_mode,
    'school': Icons.school,
    'science': Icons.science,
    'music_note': Icons.music_note,
    'analytics': Icons.analytics,
    'campaign': Icons.campaign,
    'work': Icons.work,
    'shopping_cart': Icons.shopping_cart,
    'restaurant': Icons.restaurant,
    'fitness_center': Icons.fitness_center,
    'health_and_safety': Icons.health_and_safety,
  };

  static List<String> get availableIcons => _iconMap.keys.toList();

  static IconData getIcon(String name) => _iconMap[name] ?? Icons.category;
}

class CategoryData {
  static List<Category> defaultCategories = [
    Category(
      id: 'tasks',
      name: 'Tasks',
      iconName: 'assignment',
      colorHex: '#0A7EA4',
      isDefault: true,
      order: 0,
    ),
    Category(
      id: 'images',
      name: 'Images',
      iconName: 'palette',
      colorHex: '#8B5CF6',
      isDefault: true,
      order: 1,
    ),
    Category(
      id: 'videos',
      name: 'Videos',
      iconName: 'videocam',
      colorHex: '#F59E0B',
      isDefault: true,
      order: 2,
    ),
    Category(
      id: 'writing',
      name: 'Writing',
      iconName: 'edit_document',
      colorHex: '#22C55E',
      isDefault: true,
      order: 3,
    ),
    Category(
      id: 'coding',
      name: 'Coding',
      iconName: 'code',
      colorHex: '#EF4444',
      isDefault: true,
      order: 4,
    ),
    Category(
      id: 'education',
      name: 'Education',
      iconName: 'school',
      colorHex: '#06B6D4',
      isDefault: true,
      order: 5,
    ),
    Category(
      id: 'music',
      name: 'Music',
      iconName: 'music_note',
      colorHex: '#EC4899',
      isDefault: true,
      order: 6,
    ),
    Category(
      id: 'data',
      name: 'Data',
      iconName: 'analytics',
      colorHex: '#3B82F6',
      isDefault: true,
      order: 7,
    ),
    Category(
      id: 'marketing',
      name: 'Marketing',
      iconName: 'campaign',
      colorHex: '#F97316',
      isDefault: true,
      order: 8,
    ),
    Category(
      id: 'research',
      name: 'Research',
      iconName: 'science',
      colorHex: '#14B8A6',
      isDefault: true,
      order: 9,
    ),
  ];

  static const List<String> presetColorHex = [
    '#0A7EA4',
    '#8B5CF6',
    '#F59E0B',
    '#22C55E',
    '#EF4444',
    '#06B6D4',
    '#EC4899',
    '#3B82F6',
    '#F97316',
    '#14B8A6',
  ];

  static const List<String> presetIconNames = [
    'assignment',
    'task_alt',
    'palette',
    'image',
    'videocam',
    'movie',
    'edit_document',
    'create',
    'code',
    'developer_mode',
    'school',
    'science',
    'music_note',
    'analytics',
    'campaign',
    'home',
    'star',
    'favorite',
    'bookmark',
    'category',
  ];
}
