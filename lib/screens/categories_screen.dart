import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../theme/app_colors.dart';
import '../widgets/category_card.dart';
import 'category_screen.dart';
import 'create_category_screen.dart';

class CategoriesScreen extends StatefulWidget {
  final int currentIndex;
  final Function(int) onNavigate;
  final VoidCallback openDrawer;

  const CategoriesScreen({
    super.key,
    required this.currentIndex,
    required this.onNavigate,
    required this.openDrawer,
  });

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final customCategories = appState.categories
        .where((c) => c.isCustom)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
        centerTitle: true,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: widget.openDrawer,
          ),
        ),
      ),
      body: customCategories.isEmpty
          ? _buildEmptyState(context, isDark)
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.3,
              ),
              itemCount: customCategories.length,
              itemBuilder: (context, index) {
                final category = customCategories[index];
                final promptCount = appState
                    .getPromptsByCategory(category.id)
                    .length;

                return CategoryGridItem(
                  category: category,
                  promptCount: promptCount,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CategoryScreen(
                          categoryId: category.id,
                          categoryName: category.name,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CreateCategoryScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.category_outlined,
            size: 80,
            color: isDark ? AppColors.mutedDark : AppColors.mutedLight,
          ),
          const SizedBox(height: 16),
          Text(
            'No custom categories',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isDark
                  ? AppColors.foregroundDark
                  : AppColors.foregroundLight,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Create your own categories to organize prompts',
            style: TextStyle(
              color: isDark ? AppColors.mutedDark : AppColors.mutedLight,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CreateCategoryScreen()),
              );
            },
            icon: const Icon(Icons.add),
            label: const Text('Create Category'),
          ),
        ],
      ),
    );
  }
}
