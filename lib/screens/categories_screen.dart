import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../theme/app_colors.dart';
import '../widgets/category_card.dart';
import 'category_screen.dart';
import 'create_category_screen.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.2,
        ),
        itemCount: appState.categories.length + 1, // +1 for Add button
        itemBuilder: (context, index) {
          if (index == appState.categories.length) {
            // Add Category Card
            return Card(
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const CreateCategoryScreen(),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: AppColors.primary,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add_circle_outline,
                        color: AppColors.primary,
                        size: 40,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Add Category',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          final category = appState.categories[index];
          final promptCount = appState.getPromptsByCategory(category.id).length;

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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const CreateCategoryScreen(),
            ),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Category'),
      ),
    );
  }
}
