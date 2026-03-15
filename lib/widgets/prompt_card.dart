import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/prompt.dart';
import '../models/category.dart';
import '../theme/app_colors.dart';

class PromptCard extends StatelessWidget {
  final Prompt prompt;
  final bool isFavorite;
  final VoidCallback onTap;
  final VoidCallback onFavoriteTap;
  final VoidCallback? onDeleteTap;

  const PromptCard({
    super.key,
    required this.prompt,
    required this.isFavorite,
    required this.onTap,
    required this.onFavoriteTap,
    this.onDeleteTap,
  });

  Color _getCategoryColor(String categoryId) {
    try {
      final category = CategoryData.defaultCategories.firstWhere(
        (c) => c.id == categoryId,
      );
      return category.color;
    } catch (e) {
      return AppColors.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoryColor = _getCategoryColor(prompt.category);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image section
            if (prompt.imageUrl != null && prompt.imageUrl!.isNotEmpty)
              AspectRatio(
                aspectRatio: 16 / 9,
                child: CachedNetworkImage(
                  imageUrl: prompt.imageUrl!,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: categoryColor.withOpacity(0.2),
                    child: Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: categoryColor,
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: categoryColor.withOpacity(0.2),
                    child: Icon(
                      Icons.image,
                      size: 40,
                      color: categoryColor,
                    ),
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category badge and actions
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: categoryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          prompt.category.toUpperCase(),
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: categoryColor,
                          ),
                        ),
                      ),
                      const Spacer(),
                      if (onDeleteTap != null)
                        IconButton(
                          onPressed: onDeleteTap,
                          icon: const Icon(Icons.delete_outline),
                          iconSize: 20,
                          color: AppColors.error,
                          visualDensity: VisualDensity.compact,
                        ),
                      IconButton(
                        onPressed: onFavoriteTap,
                        icon: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: isFavorite ? AppColors.error : null,
                        ),
                        iconSize: 20,
                        visualDensity: VisualDensity.compact,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Title
                  Text(
                    prompt.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  // Description
                  Text(
                    prompt.description,
                    style: TextStyle(
                      color: isDark
                          ? AppColors.mutedDark
                          : AppColors.mutedLight,
                      fontSize: 13,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  // Author and usage
                  Row(
                    children: [
                      Icon(
                        Icons.person_outline,
                        size: 14,
                        color: isDark
                            ? AppColors.mutedDark
                            : AppColors.mutedLight,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          prompt.author ?? 'Unknown',
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark
                                ? AppColors.mutedDark
                                : AppColors.mutedLight,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Icon(
                        Icons.copy,
                        size: 14,
                        color: isDark
                            ? AppColors.mutedDark
                            : AppColors.mutedLight,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${prompt.usageCount}',
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark
                              ? AppColors.mutedDark
                              : AppColors.mutedLight,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FeaturedCard extends StatelessWidget {
  final Prompt prompt;
  final VoidCallback onTap;

  const FeaturedCard({
    super.key,
    required this.prompt,
    required this.onTap,
  });

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'tasks':
        return AppColors.tasksColor;
      case 'images':
        return AppColors.imagesColor;
      case 'videos':
        return AppColors.videosColor;
      case 'writing':
        return AppColors.writingColor;
      case 'coding':
        return AppColors.codingColor;
      case 'education':
        return AppColors.educationColor;
      default:
        return AppColors.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoryColor = _getCategoryColor(prompt.category);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 300,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: categoryColor.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              // Background image
              if (prompt.imageUrl != null && prompt.imageUrl!.isNotEmpty)
                Positioned.fill(
                  child: CachedNetworkImage(
                    imageUrl: prompt.imageUrl!,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: categoryColor,
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: categoryColor,
                    ),
                  ),
                )
              else
                Positioned.fill(
                  child: Container(color: categoryColor),
                ),
              // Gradient overlay
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.8),
                      ],
                      stops: const [0.3, 1.0],
                    ),
                  ),
                ),
              ),
              // Content
              Positioned(
                left: 16,
                right: 16,
                bottom: 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        prompt.category.toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      prompt.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.copy,
                          color: Colors.white.withOpacity(0.8),
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Tap to copy',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final String id;
  final String name;
  final String icon;
  final String color;
  final String? imageUrl;
  final VoidCallback onTap;

  const CategoryCard({
    super.key,
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    this.imageUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorValue = Color(int.parse(color.replaceFirst('#', '0xFF')));

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Stack(
          children: [
            // Background image
            if (imageUrl != null && imageUrl!.isNotEmpty)
              Positioned.fill(
                child: CachedNetworkImage(
                  imageUrl: imageUrl!,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(color: colorValue.withOpacity(0.3)),
                  errorWidget: (context, url, error) => Container(color: colorValue.withOpacity(0.3)),
                ),
              ),
            // Gradient overlay
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      colorValue.withOpacity(0.8),
                      colorValue.withOpacity(0.95),
                    ],
                  ),
                ),
              ),
            ),
            // Content
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    icon,
                    style: const TextStyle(fontSize: 32),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
