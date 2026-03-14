import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../models/models.dart';
import '../theme/app_colors.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final categories = appState.prompts.map((p) => p.category).toSet();

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Prompt Store',
                              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Discover and copy AI prompts',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Theme.of(context).brightness == Brightness.dark
                                    ? AppColors.mutedDark
                                    : AppColors.mutedLight,
                              ),
                            ),
                          ],
                        ),
                        IconButton(
                          onPressed: () => appState.toggleDarkMode(),
                          icon: Icon(
                            appState.isDarkMode ? Icons.light_mode : Icons.dark_mode,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const SearchScreen()),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardTheme.color,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Theme.of(context).brightness == Brightness.dark
                                ? AppColors.borderDark
                                : AppColors.borderLight,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.search,
                              color: Theme.of(context).brightness == Brightness.dark
                                  ? AppColors.mutedDark
                                  : AppColors.mutedLight,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Search prompts...',
                              style: TextStyle(
                                color: Theme.of(context).brightness == Brightness.dark
                                    ? AppColors.mutedDark
                                    : AppColors.mutedLight,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Featured Prompts',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 180,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: appState.featuredPrompts.length,
                  itemBuilder: (context, index) {
                    final prompt = appState.featuredPrompts[index];
                    return _FeaturedCard(prompt: prompt);
                  },
                ),
              ),
            ),
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
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1.5,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final categoryList = [
                      {'id': 'tasks', 'name': 'Tasks', 'color': '#0A7EA4', 'icon': '📋'},
                      {'id': 'images', 'name': 'Images', 'color': '#8B5CF6', 'icon': '🖼️'},
                      {'id': 'videos', 'name': 'Videos', 'color': '#F59E0B', 'icon': '🎬'},
                      {'id': 'writing', 'name': 'Writing', 'color': '#22C55E', 'icon': '✍️'},
                      {'id': 'coding', 'name': 'Coding', 'color': '#EF4444', 'icon': '💻'},
                      {'id': 'education', 'name': 'Education', 'color': '#06B6D4', 'icon': '📚'},
                    ];
                    final category = categoryList[index];
                    return _CategoryCard(
                      id: category['id']!,
                      name: category['name']!,
                      color: category['color']!,
                      icon: category['icon']!,
                    );
                  },
                  childCount: 6,
                ),
              ),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(height: 100),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeaturedCard extends StatelessWidget {
  final Prompt prompt;

  const _FeaturedCard({required this.prompt});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PromptDetailScreen(prompt: prompt),
          ),
        );
      },
      child: Container(
        width: 280,
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.primary,
              AppColors.primary.withOpacity(0.7),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            Row(
              children: [
                Icon(Icons.copy, color: Colors.white.withOpacity(0.8), size: 16),
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
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final String id;
  final String name;
  final String color;
  final String icon;

  const _CategoryCard({
    required this.id,
    required this.name,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final colorValue = Color(int.parse(color.replaceFirst('#', '0xFF')));

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CategoryDetailScreen(categoryId: id, categoryName: name),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colorValue.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: colorValue.withOpacity(0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(icon, style: const TextStyle(fontSize: 28)),
            const SizedBox(height: 8),
            Text(
              name,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: colorValue,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              onChanged: (value) => appState.setSearchQuery(value),
              decoration: InputDecoration(
                hintText: 'Search prompts...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          appState.setSearchQuery('');
                        },
                      )
                    : null,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _FilterChip(
                    label: 'All',
                    isSelected: appState.selectedCategory == 'all',
                    onTap: () => appState.setSelectedCategory('all'),
                  ),
                  _FilterChip(
                    label: 'Tasks',
                    isSelected: appState.selectedCategory == 'tasks',
                    onTap: () => appState.setSelectedCategory('tasks'),
                  ),
                  _FilterChip(
                    label: 'Images',
                    isSelected: appState.selectedCategory == 'images',
                    onTap: () => appState.setSelectedCategory('images'),
                  ),
                  _FilterChip(
                    label: 'Videos',
                    isSelected: appState.selectedCategory == 'videos',
                    onTap: () => appState.setSelectedCategory('videos'),
                  ),
                  _FilterChip(
                    label: 'Writing',
                    isSelected: appState.selectedCategory == 'writing',
                    onTap: () => appState.setSelectedCategory('writing'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: appState.filteredPrompts.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 64,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? AppColors.mutedDark
                              : AppColors.mutedLight,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No prompts found',
                          style: TextStyle(
                            color: Theme.of(context).brightness == Brightness.dark
                                ? AppColors.mutedDark
                                : AppColors.mutedLight,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: appState.filteredPrompts.length,
                    itemBuilder: (context, index) {
                      final prompt = appState.filteredPrompts[index];
                      return _PromptListItem(prompt: prompt);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.borderLight,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : null,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

class _PromptListItem extends StatelessWidget {
  final Prompt prompt;

  const _PromptListItem({required this.prompt});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final isFavorite = appState.isFavorite(prompt.id);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => PromptDetailScreen(prompt: prompt),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            prompt.category,
                            style: const TextStyle(
                              fontSize: 10,
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      prompt.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      prompt.description,
                      style: TextStyle(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? AppColors.mutedDark
                            : AppColors.mutedLight,
                        fontSize: 14,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {
                  appState.toggleFavorite(prompt.id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        isFavorite ? 'Removed from favorites' : 'Added to favorites',
                      ),
                      duration: const Duration(seconds: 1),
                    ),
                  );
                },
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? AppColors.error : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CategoryDetailScreen extends StatelessWidget {
  final String categoryId;
  final String categoryName;

  const CategoryDetailScreen({
    super.key,
    required this.categoryId,
    required this.categoryName,
  });

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final categoryPrompts = appState.prompts
        .where((p) => p.category == categoryId)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(categoryName),
      ),
      body: categoryPrompts.isEmpty
          ? Center(
              child: Text(
                'No prompts in this category',
                style: TextStyle(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? AppColors.mutedDark
                      : AppColors.mutedLight,
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: categoryPrompts.length,
              itemBuilder: (context, index) {
                return _PromptListItem(prompt: categoryPrompts[index]);
              },
            ),
    );
  }
}

class PromptDetailScreen extends StatelessWidget {
  final Prompt prompt;

  const PromptDetailScreen({super.key, required this.prompt});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final isFavorite = appState.isFavorite(prompt.id);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Prompt Details'),
        actions: [
          IconButton(
            onPressed: () {
              appState.toggleFavorite(prompt.id);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    isFavorite ? 'Removed from favorites' : 'Added to favorites',
                  ),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? AppColors.error : null,
            ),
          ),
          IconButton(
            onPressed: () {
              // Share functionality
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Share feature coming soon!'),
                  duration: Duration(seconds: 1),
                ),
              );
            },
            icon: const Icon(Icons.share),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    prompt.category.toUpperCase(),
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              prompt.title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              prompt.description,
              style: TextStyle(
                color: Theme.of(context).brightness == Brightness.dark
                    ? AppColors.mutedDark
                    : AppColors.mutedLight,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(
                  Icons.person_outline,
                  size: 16,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? AppColors.mutedDark
                      : AppColors.mutedLight,
                ),
                const SizedBox(width: 4),
                Text(
                  prompt.author ?? 'Unknown',
                  style: TextStyle(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? AppColors.mutedDark
                        : AppColors.mutedLight,
                  ),
                ),
                const SizedBox(width: 16),
                Icon(
                  Icons.calendar_today_outlined,
                  size: 16,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? AppColors.mutedDark
                      : AppColors.mutedLight,
                ),
                const SizedBox(width: 4),
                Text(
                  '${prompt.createdAt.day}/${prompt.createdAt.month}/${prompt.createdAt.year}',
                  style: TextStyle(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? AppColors.mutedDark
                        : AppColors.mutedLight,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              'Prompt Content',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).cardTheme.color,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? AppColors.borderDark
                      : AppColors.borderLight,
                ),
              ),
              child: SelectableText(
                prompt.content,
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: prompt.content));
                  HapticFeedback.lightImpact();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Row(
                        children: [
                          Icon(Icons.check_circle, color: Colors.white),
                          SizedBox(width: 8),
                          Text('Copied to clipboard!'),
                        ],
                      ),
                      backgroundColor: AppColors.success,
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
                icon: const Icon(Icons.copy),
                label: const Text('Copy to Clipboard'),
              ),
            ),
            const SizedBox(height: 16),
            if (prompt.tags.isNotEmpty) ...[
              Text(
                'Tags',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: prompt.tags.map((tag) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      '#$tag',
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontSize: 12,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
      ),
      body: appState.favoritePrompts.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite_border,
                    size: 64,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? AppColors.mutedDark
                        : AppColors.mutedLight,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No favorites yet',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Explore and save your favorites!',
                    style: TextStyle(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? AppColors.mutedDark
                          : AppColors.mutedLight,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: appState.favoritePrompts.length,
              itemBuilder: (context, index) {
                return _PromptListItem(prompt: appState.favoritePrompts[index]);
              },
            ),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: ListTile(
              leading: Icon(
                appState.isDarkMode ? Icons.dark_mode : Icons.light_mode,
              ),
              title: const Text('Dark Mode'),
              trailing: Switch(
                value: appState.isDarkMode,
                onChanged: (_) => appState.toggleDarkMode(),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('About'),
              subtitle: const Text('Prompt Store v1.0.0'),
              onTap: () {
                showAboutDialog(
                  context: context,
                  applicationName: 'Prompt Store',
                  applicationVersion: '1.0.0',
                  applicationLegalese: '© 2024 Prompt Store',
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              leading: const Icon(Icons.delete_outline),
              title: const Text('Clear Cache'),
              subtitle: const Text('Free up storage space'),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Cache cleared!'),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
