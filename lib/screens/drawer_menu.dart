import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../theme/app_colors.dart';

class AppDrawer extends StatelessWidget {
  final int currentIndex;
  final Function(int) onItemSelected;

  const AppDrawer({
    super.key,
    required this.currentIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final totalUses = appState.prompts.fold<int>(0, (sum, p) => sum + p.usageCount);

    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.primary,
                    AppColors.primaryDark,
                  ],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Center(
                      child: Text(
                        'PS',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Prompt Store',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Version 1.0.0',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.7),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),

            // Quick Stats
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _StatItem(
                    value: '${appState.prompts.length}',
                    label: 'Prompts',
                    icon: Icons.description,
                  ),
                  _StatItem(
                    value: '${appState.favorites.length}',
                    label: 'Favorites',
                    icon: Icons.favorite,
                  ),
                  _StatItem(
                    value: '$totalUses',
                    label: 'Uses',
                    icon: Icons.copy,
                  ),
                ],
              ),
            ),

            const Divider(),

            // Menu Items
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _DrawerItem(
                    icon: Icons.home,
                    label: 'Home',
                    isSelected: currentIndex == 0,
                    onTap: () => onItemSelected(0),
                  ),
                  _DrawerItem(
                    icon: Icons.category,
                    label: 'Categories',
                    isSelected: currentIndex == 1,
                    onTap: () => onItemSelected(1),
                  ),
                  _DrawerItem(
                    icon: Icons.person,
                    label: 'My Prompts',
                    isSelected: currentIndex == 2,
                    onTap: () => onItemSelected(2),
                  ),
                  _DrawerItem(
                    icon: Icons.favorite,
                    label: 'Favorites',
                    isSelected: currentIndex == 3,
                    onTap: () => onItemSelected(3),
                  ),

                  const Divider(height: 32),

                  _DrawerItem(
                    icon: Icons.settings,
                    label: 'Settings',
                    isSelected: currentIndex == 4,
                    onTap: () => onItemSelected(4),
                  ),
                  _DrawerItem(
                    icon: Icons.info,
                    label: 'About',
                    isSelected: false,
                    onTap: () {
                      showAboutDialog(
                        context: context,
                        applicationName: 'Prompt Store',
                        applicationVersion: '1.0.0',
                        applicationIcon: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Center(
                            child: Text(
                              'PS',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        children: [
                          const Text(
                            'A modern app to store, manage, and use AI prompts for various tasks.',
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),

            // Dark Mode Toggle
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        appState.isDarkMode ? Icons.dark_mode : Icons.light_mode,
                        color: AppColors.primary,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Dark Mode',
                        style: TextStyle(
                          color: isDark
                              ? AppColors.foregroundDark
                              : AppColors.foregroundLight,
                        ),
                      ),
                    ],
                  ),
                  Switch(
                    value: appState.isDarkMode,
                    onChanged: (_) => appState.toggleDarkMode(),
                    activeColor: AppColors.primary,
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

class _StatItem extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;

  const _StatItem({
    required this.value,
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: AppColors.primary, size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Theme.of(context).brightness == Brightness.dark
                ? AppColors.mutedDark
                : AppColors.mutedLight,
          ),
        ),
      ],
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _DrawerItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ListTile(
      leading: Icon(
        icon,
        color: isSelected
            ? AppColors.primary
            : (isDark ? AppColors.mutedDark : AppColors.mutedLight),
      ),
      title: Text(
        label,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected
              ? AppColors.primary
              : (isDark ? AppColors.foregroundDark : AppColors.foregroundLight),
        ),
      ),
      selected: isSelected,
      selectedTileColor: AppColors.primary.withValues(alpha: 0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      onTap: onTap,
    );
  }
}
