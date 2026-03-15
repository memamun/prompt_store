import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../theme/app_colors.dart';
import '../models/category.dart';
import '../widgets/prompt_card.dart';
import '../widgets/category_card.dart';
import 'search_screen.dart';
import 'prompt_detail_screen.dart';
import 'category_screen.dart';

class HomeScreen extends StatefulWidget {
  final int currentIndex;
  final Function(int) onNavigate;
  final VoidCallback openDrawer;

  const HomeScreen({
    super.key,
    required this.currentIndex,
    required this.onNavigate,
    required this.openDrawer,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Modern Header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                child: Row(
                  children: [
                    Builder(
                      builder: (context) => IconButton(
                        onPressed: widget.openDrawer,
                        icon: Icon(
                          Icons.menu,
                          color: isDark
                              ? AppColors.foregroundDark
                              : AppColors.foregroundLight,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Prompt Store',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: isDark
                                  ? AppColors.foregroundDark
                                  : AppColors.foregroundLight,
                            ),
                          ),
                          Text(
                            'Discover AI prompts',
                            style: TextStyle(
                              fontSize: 14,
                              color: isDark
                                  ? AppColors.mutedDark
                                  : AppColors.mutedLight,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => appState.toggleDarkMode(),
                      icon: Icon(
                        appState.isDarkMode
                            ? Icons.light_mode
                            : Icons.dark_mode,
                        color: isDark
                            ? AppColors.foregroundDark
                            : AppColors.foregroundLight,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Search Bar
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const SearchScreen()),
                      );
                    },
                    borderRadius: BorderRadius.circular(28),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
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
            ),

            // Featured Section Header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
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
                          MaterialPageRoute(
                            builder: (_) => const SearchScreen(),
                          ),
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
                height: 180,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: appState.featuredPrompts.length,
                  itemBuilder: (context, index) {
                    final prompt = appState.featuredPrompts[index];
                    return Padding(
                      padding: EdgeInsets.only(
                        right: index < appState.featuredPrompts.length - 1
                            ? 12
                            : 0,
                      ),
                      child: FeaturedCard(
                        prompt: prompt,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  PromptDetailScreen(prompt: prompt),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ),

            // Categories Section Header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
                child: Text(
                  'Categories',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
            ),

            // Categories Grid
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1.3,
                ),
                delegate: SliverChildBuilderDelegate((context, index) {
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
                }, childCount: appState.categories.length),
              ),
            ),

            // Recent Prompts Section Header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
                child: Text(
                  'Recent Prompts',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
            ),

            // Recent Prompts List
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final prompt = appState.prompts[index];
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
                }, childCount: appState.prompts.length.clamp(0, 5)),
              ),
            ),

            // Bottom padding for FAB
            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
    );
  }
}
