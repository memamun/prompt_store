import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class TermsOfServiceScreen extends StatelessWidget {
  const TermsOfServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms of Service'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Terms of Service',
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
              'Acceptance of Terms',
              'By using Prompt Store, you agree to these terms of service. If you do not agree to these terms, please do not use the app.',
              isDark,
            ),
            _buildSection(
              'Use of the App',
              'Prompt Store is provided for personal use to store, manage, and organize AI prompts. You may not use this app for any illegal or unauthorized purpose.',
              isDark,
            ),
            _buildSection(
              'User Content',
              'You retain ownership of any prompts you create and add to the app. By adding content, you confirm that you have the right to use and share that content.',
              isDark,
            ),
            _buildSection(
              'Disclaimer',
              'The prompts provided in the app are examples and templates. We do not guarantee the quality, accuracy, or effectiveness of any prompts. Use them at your own discretion.',
              isDark,
            ),
            _buildSection(
              'Limitation of Liability',
              'Prompt Store is provided "as is" without warranty of any kind. We shall not be liable for any damages arising from your use of the app.',
              isDark,
            ),
            _buildSection(
              'Changes to Terms',
              'We reserve the right to modify these terms at any time. Continued use of the app after changes constitutes acceptance of the new terms.',
              isDark,
            ),
            _buildSection(
              'Contact',
              'If you have any questions about these terms, please contact us through the app store listing.',
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
