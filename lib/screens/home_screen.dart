import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../theme/app_colors.dart';
import '../widgets/prompt_card.dart';
import '../widgets/category_card.dart';
import 'search_screen.dart';
import 'prompt_detail_screen.dart';
import 'category_screen.dart';
import 'drawer_menu.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Modern App Bar
          SliverAppBar(
            floating: true,
            pinned: true,
            expandedHeight: 100,
            backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
            leading: IconButton(
              icon: Icon(
                Icons.menu,
                color: isDark ? AppColors.foregroundDark : AppColors.foregroundLight,
              ),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
            flexibleSpace: FlexibleSpaceBar(
              title: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppColors.primary, AppColors.primaryDark],
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: Text(
                        'PS',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Prompt Store',
                    style: TextStyle(
                      color: isDark ? AppColors.foregroundDark : AppColors.foregroundLight,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              titlePadding: const EdgeInsets.only(left: 0, bottom: 16),
              centerTitle: false,
            ),
            actions: [
              IconButton(
                onPressed: () => appState.toggleDarkMode(),
                icon: Icon(
                  appState.isDarkMode ? Icons.light_mode : Icons.dark_mode,
                  color: isDark ? AppColors.foregroundDark : AppColors.foregroundLight,
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
                    category: category,
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

          // Bottom padding for FAB
          const SliverToBoxAdapter(
            child: SizedBox(height: 80),
          ),
        ],
      ),
    );
  }
}
