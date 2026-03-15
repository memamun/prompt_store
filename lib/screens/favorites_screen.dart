import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../theme/app_colors.dart';
import '../widgets/prompt_card.dart';
import 'prompt_detail_screen.dart';
import 'create_prompt_screen.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
        centerTitle: true,
      ),
      body: appState.favoritePrompts.isEmpty
          ? _buildEmptyState(isDark)
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: appState.favoritePrompts.length,
              itemBuilder: (context, index) {
                final prompt = appState.favoritePrompts[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: PromptCard(
                    prompt: prompt,
                    isFavorite: true,
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
                          content: const Text('Removed from favorites'),
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.large(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CreatePromptScreen()),
          );
        },
        child: const Icon(Icons.add, size: 32),
      ),
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_border,
            size: 80,
            color: isDark ? AppColors.mutedDark : AppColors.mutedLight,
          ),
          const SizedBox(height: 16),
          Text(
            'No favorites yet',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isDark ? AppColors.foregroundDark : AppColors.foregroundLight,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Explore and save your favorites!',
            style: TextStyle(
              color: isDark ? AppColors.mutedDark : AppColors.mutedLight,
            ),
          ),
        ],
      ),
    );
  }
}
