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
    final hasImage = prompt.imageUrl != null && prompt.imageUrl!.isNotEmpty;

    return Card(
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: isDark ? AppColors.surfaceContainerDark : AppColors.surfaceContainerLight,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (hasImage)
              AspectRatio(
                aspectRatio: 16 / 9,
                child: CachedNetworkImage(
                  imageUrl: prompt.imageUrl!,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: categoryColor.withValues(alpha: 0.2),
                    child: Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: categoryColor,
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: categoryColor.withValues(alpha: 0.2),
                    child: Icon(Icons.image, size: 40, color: categoryColor),
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: categoryColor.withValues(alpha: 0.1),
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
                  Text(
                    prompt.title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: isDark ? AppColors.foregroundDark : AppColors.foregroundLight,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    prompt.description,
                    style: TextStyle(
                      color: isDark ? AppColors.mutedDark : AppColors.mutedLight,
                      fontSize: 13,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(
                        Icons.person_outline,
                        size: 14,
                        color: isDark ? AppColors.mutedDark : AppColors.mutedLight,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          prompt.author ?? 'Unknown',
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? AppColors.mutedDark : AppColors.mutedLight,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Icon(
                        Icons.copy,
                        size: 14,
                        color: isDark ? AppColors.mutedDark : AppColors.mutedLight,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${prompt.usageCount}',
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? AppColors.mutedDark : AppColors.mutedLight,
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
    final hasImage = prompt.imageUrl != null && prompt.imageUrl!.isNotEmpty;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 280,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: categoryColor.withValues(alpha: 0.3),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Background
              if (hasImage)
                CachedNetworkImage(
                  imageUrl: prompt.imageUrl!,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: categoryColor,
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: categoryColor,
                  ),
                )
              else
                Container(color: categoryColor),
              
              // Gradient overlay
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.8),
                    ],
                    stops: const [0.3, 1.0],
                  ),
                ),
              ),

              // Top badge
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.trending_up, color: Colors.white, size: 12),
                      const SizedBox(width: 4),
                      Text(
                        '${prompt.usageCount}+',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
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
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.25),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        prompt.category.toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
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
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.copy, color: Colors.white70, size: 12),
                        const SizedBox(width: 4),
                        Text(
                          'Tap to use',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.8),
                            fontSize: 11,
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
