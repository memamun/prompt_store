import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../theme/app_colors.dart';
import '../models/category.dart';
import '../widgets/prompt_card.dart';
import 'prompt_detail_screen.dart';
import 'create_prompt_screen.dart';

class MyPromptsScreen extends StatefulWidget {
  final int currentIndex;
  final Function(int) onNavigate;
  final VoidCallback openDrawer;

  const MyPromptsScreen({
    super.key,
    required this.currentIndex,
    required this.onNavigate,
    required this.openDrawer,
  });

  @override
  State<MyPromptsScreen> createState() => _MyPromptsScreenState();
}

class _MyPromptsScreenState extends State<MyPromptsScreen> {
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
    final appState = context.watch<AppState>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final userPrompts = appState.prompts
        .where((p) => p.author == 'You' || p.isCustom == true)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Prompts'),
        centerTitle: true,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: widget.openDrawer,
          ),
        ),
      ),
      body: userPrompts.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.edit_note,
                    size: 80,
                    color: isDark ? AppColors.mutedDark : AppColors.mutedLight,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No prompts yet',
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
                    'Create your first prompt!',
                    style: TextStyle(
                      color: isDark
                          ? AppColors.mutedDark
                          : AppColors.mutedLight,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const CreatePromptScreen(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Create Prompt'),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: userPrompts.length,
              itemBuilder: (context, index) {
                final prompt = userPrompts[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: PromptCard(
                    prompt: prompt,
                    isFavorite: appState.isFavorite(prompt.id),
                    categoryColor: _getCategoryColor(prompt.category),
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
            ),
    );
  }
}
