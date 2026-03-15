import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Privacy Policy',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.foregroundDark : AppColors.foregroundLight,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Last updated: March 2026',
              style: TextStyle(
                color: isDark ? AppColors.mutedDark : AppColors.mutedLight,
              ),
            ),
            const SizedBox(height: 24),
            _buildSection(
              'Data Collection',
              'Prompt Store stores all your data locally on your device. We do not collect, transmit, or store any personal information on external servers.',
              isDark,
            ),
            _buildSection(
              'Local Storage',
              'All your prompts, favorites, and preferences are stored locally using SharedPreferences. Your data never leaves your device.',
              isDark,
            ),
            _buildSection(
              'No Analytics',
              'We do not use any analytics or tracking services. Your usage patterns remain completely private.',
              isDark,
            ),
            _buildSection(
              'Third-Party Services',
              'The app may use third-party services for image caching (CachedNetworkImage) but no personal data is shared with these services.',
              isDark,
            ),
            _buildSection(
              'Image Loading',
              'When you view prompts with images, those images are loaded from their original sources. We do not collect or store any image data.',
              isDark,
            ),
            _buildSection(
              'Contact',
              'If you have any questions about this privacy policy, please contact us through the app store listing.',
              isDark,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDark ? AppColors.foregroundDark : AppColors.foregroundLight,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: TextStyle(
              fontSize: 14,
              height: 1.5,
              color: isDark ? AppColors.mutedDark : AppColors.mutedLight,
            ),
          ),
        ],
      ),
    );
  }
}
