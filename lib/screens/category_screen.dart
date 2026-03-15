import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/category.dart';
import '../providers/app_state.dart';
import '../theme/app_colors.dart';
import '../widgets/prompt_card.dart';
import 'prompt_detail_screen.dart';
import 'create_prompt_screen.dart';

class CategoryScreen extends StatelessWidget {
  final String categoryId;
  final String categoryName;

  const CategoryScreen({
    super.key,
    required this.categoryId,
    required this.categoryName,
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

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'tasks':
        return Icons.task_alt;
      case 'images':
        return Icons.image;
      case 'videos':
        return Icons.videocam;
      case 'writing':
        return Icons.edit;
      case 'coding':
        return Icons.code;
      case 'education':
        return Icons.school;
      default:
        return Icons.category;
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final categoryColor = _getCategoryColor(categoryId);
    final categoryPrompts = appState.getPromptsByCategory(categoryId);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                categoryName,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      categoryColor,
                      categoryColor.withValues(alpha: 0.7),
                    ],
                  ),
                ),
                child: Center(
                  child: Icon(
                    _getCategoryIcon(categoryId),
                    size: 80,
                    color: Colors.white.withValues(alpha: 0.3),
                  ),
                ),
              ),
            ),
          ),
          if (categoryPrompts.isEmpty)
            SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.inbox_outlined,
                      size: 64,
                      color: isDark ? AppColors.mutedDark : AppColors.mutedLight,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No prompts in this category',
                      style: TextStyle(
                        color: isDark ? AppColors.mutedDark : AppColors.mutedLight,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final prompt = categoryPrompts[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: PromptCard(
                        prompt: prompt,
                        isFavorite: appState.isFavorite(prompt.id),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => PromptDetailScreen(prompt: prompt),
                            ),
                          );
                        },
                        onFavoriteTap: () {
                          appState.toggleFavorite(prompt.id);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                appState.isFavorite(prompt.id)
                                    ? 'Added to favorites'
                                    : 'Removed from favorites',
                              ),
                              duration: const Duration(seconds: 1),
                            ),
                          );
                        },
                      ),
                    );
                  },
                  childCount: categoryPrompts.length,
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CreatePromptScreen()),
          );
        },
        backgroundColor: categoryColor,
        child: const Icon(Icons.add),
      ),
    );
  }
}
