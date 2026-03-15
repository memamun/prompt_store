import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../theme/app_colors.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // App Info Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Center(
                      child: Text(
                        'PS',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 28,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Prompt Store',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Version 1.0.0',
                    style: TextStyle(
                      color: isDark ? AppColors.mutedDark : AppColors.mutedLight,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Theme Toggle
          Card(
            child: ListTile(
              leading: Icon(
                appState.isDarkMode ? Icons.dark_mode : Icons.light_mode,
                color: AppColors.primary,
              ),
              title: const Text('Dark Mode'),
              subtitle: Text(appState.isDarkMode ? 'On' : 'Off'),
              trailing: Switch(
                value: appState.isDarkMode,
                onChanged: (_) => appState.toggleDarkMode(),
                activeColor: AppColors.primary,
              ),
            ),
          ),
          const SizedBox(height: 8),

          // Stats
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Statistics',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _StatItem(
                        icon: Icons.prompt,
                        label: 'Prompts',
                        value: '${appState.prompts.length}',
                      ),
                      _StatItem(
                        icon: Icons.favorite,
                        label: 'Favorites',
                        value: '${appState.favorites.length}',
                      ),
                      _StatItem(
                        icon: Icons.copy,
                        label: 'Total Uses',
                        value: '${appState.prompts.fold<int>(0, (sum, p) => sum + p.usageCount)}',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),

          // About
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.info_outline, color: AppColors.primary),
                  title: const Text('About'),
                  trailing: const Icon(Icons.chevron_right),
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
                        const SizedBox(height: 16),
                        const Text(
                          '© 2024 Prompt Store',
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    );
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.privacy_tip_outlined, color: AppColors.primary),
                  title: const Text('Privacy Policy'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Privacy policy coming soon!'),
                      ),
                    );
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.description_outlined, color: AppColors.primary),
                  title: const Text('Terms of Service'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Terms of service coming soon!'),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // Developer
          Card(
            child: ListTile(
              leading: const Icon(Icons.code, color: AppColors.primary),
              title: const Text('Developer'),
              subtitle: const Text('Prompt Store Team'),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Thank you for using Prompt Store!'),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: AppColors.primary, size: 28),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Theme.of(context).brightness == Brightness.dark
                ? AppColors.mutedDark
                : AppColors.mutedLight,
          ),
        ),
      ],
    );
  }
}
