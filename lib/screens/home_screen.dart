import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../theme/app_colors.dart';
import '../widgets/prompt_card.dart';
import 'search_screen.dart';
import 'prompt_detail_screen.dart';
import 'create_prompt_screen.dart';
import 'category_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            floating: true,
            pinned: true,
            expandedHeight: 120,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.primary,
                      AppColors.primary.withOpacity(0.8),
                    ],
                  ),
                ),
              ),
              title: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Center(
                      child: Text(
                        'PS',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'Prompt Store',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
              titlePadding: const EdgeInsets.only(left: 16, bottom: 16),
            ),
            actions: [
              IconButton(
                onPressed: () => appState.toggleDarkMode(),
                icon: Icon(
                  appState.isDarkMode ? Icons.light_mode : Icons.dark_mode,
                  color: Colors.white,
                ),
              ),
            ],
          ),

          // Search Bar
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SearchScreen()),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.surfaceContainerDark
                        : AppColors.surfaceContainerLight,
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(
                      color: isDark
                          ? AppColors.borderDark
                          : AppColors.borderLight,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.search,
                        color: isDark
                            ? AppColors.mutedDark
                            : AppColors.mutedLight,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Search prompts...',
                        style: TextStyle(
                          color: isDark
                              ? AppColors.mutedDark
                              : AppColors.mutedLight,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Featured Section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Featured',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const SearchScreen()),
                      );
                    },
                    child: const Text('See all'),
                  ),
                ],
              ),
            ),
          ),

          // Featured Carousel
          SliverToBoxAdapter(
            child: SizedBox(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: appState.featuredPrompts.length,
                itemBuilder: (context, index) {
                  final prompt = appState.featuredPrompts[index];
                  return FeaturedCard(
                    prompt: prompt,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PromptDetailScreen(prompt: prompt),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),

          // Categories Section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Categories',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          // Categories Grid
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.2,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final category = appState.categories[index];
                  return CategoryCard(
                    id: category.id,
                    name: category.name,
                    icon: category.icon,
                    color: category.color,
                    imageUrl: category.imageUrl,
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
                childCount: appState.categories.length,
              ),
            ),
          ),

          // Recent Prompts Section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Recent Prompts',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          // Recent Prompts List
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final prompt = appState.prompts[index];
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
                childCount: appState.prompts.length.clamp(0, 5),
              ),
            ),
          ),

          // Bottom padding
          const SliverToBoxAdapter(
            child: SizedBox(height: 100),
          ),
        ],
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
}
