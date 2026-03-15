import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../theme/app_colors.dart';

class CreatePromptScreen extends StatefulWidget {
  const CreatePromptScreen({super.key});

  @override
  State<CreatePromptScreen> createState() => _CreatePromptScreenState();
}

class _CreatePromptScreenState extends State<CreatePromptScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _contentController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _outputPreviewController = TextEditingController();
  final _tagsController = TextEditingController();
  
  String _selectedCategory = 'tasks';
  bool _isLoading = false;

  final List<Map<String, dynamic>> _categories = [
    {'id': 'tasks', 'name': 'Tasks', 'icon': '📋'},
    {'id': 'images', 'name': 'Images', 'icon': '🖼️'},
    {'id': 'videos', 'name': 'Videos', 'icon': '🎬'},
    {'id': 'writing', 'name': 'Writing', 'icon': '✍️'},
    {'id': 'coding', 'name': 'Coding', 'icon': '💻'},
    {'id': 'education', 'name': 'Education', 'icon': '📚'},
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _contentController.dispose();
    _imageUrlController.dispose();
    _outputPreviewController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  Future<void> _savePrompt() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final appState = context.read<AppState>();
    final tags = _tagsController.text
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    await appState.addPrompt(
      title: _titleController.text,
      description: _descriptionController.text,
      content: _contentController.text,
      category: _selectedCategory,
      tags: tags,
      imageUrl: _imageUrlController.text.isNotEmpty ? _imageUrlController.text : null,
      outputPreview: _outputPreviewController.text.isNotEmpty ? _outputPreviewController.text : null,
    );

    setState(() => _isLoading = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Prompt created successfully!'),
          backgroundColor: AppColors.success,
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Prompt'),
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _savePrompt,
            child: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Save'),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Title
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                hintText: 'Enter prompt title',
                prefixIcon: Icon(Icons.title),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a title';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Description
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                hintText: 'Brief description of the prompt',
                prefixIcon: Icon(Icons.description),
              ),
              maxLines: 2,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a description';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Category
            Text(
              'Category',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.foregroundDark : AppColors.foregroundLight,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _categories.map((category) {
                final isSelected = _selectedCategory == category['id'];
                return ChoiceChip(
                  label: Text('${category['icon']} ${category['name']}'),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      _selectedCategory = category['id'];
                    });
                  },
                  selectedColor: AppColors.primary.withValues(alpha: 0.2),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),

            // Content
            TextFormField(
              controller: _contentController,
              decoration: const InputDecoration(
                labelText: 'Prompt Content',
                hintText: 'Enter the prompt text...',
                alignLabelWithHint: true,
              ),
              maxLines: 8,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter prompt content';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Image URL (optional)
            TextFormField(
              controller: _imageUrlController,
              decoration: const InputDecoration(
                labelText: 'Image URL (Optional)',
                hintText: 'https://example.com/image.jpg',
                prefixIcon: Icon(Icons.image),
              ),
            ),
            const SizedBox(height: 8),
            if (_imageUrlController.text.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  _imageUrlController.text,
                  height: 150,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 150,
                    color: AppColors.error.withValues(alpha: 0.1),
                    child: const Center(
                      child: Text('Invalid image URL'),
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 16),

            // Output Preview (optional)
            TextFormField(
              controller: _outputPreviewController,
              decoration: const InputDecoration(
                labelText: 'Output Preview (Optional)',
                hintText: 'Example output or result...',
                alignLabelWithHint: true,
              ),
              maxLines: 4,
            ),
            const SizedBox(height: 16),

            // Tags
            TextFormField(
              controller: _tagsController,
              decoration: const InputDecoration(
                labelText: 'Tags (Optional)',
                hintText: 'tag1, tag2, tag3',
                prefixIcon: Icon(Icons.tag),
                helperText: 'Separate tags with commas',
              ),
            ),
            const SizedBox(height: 32),

            // Save Button
            ElevatedButton(
              onPressed: _isLoading ? null : _savePrompt,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Create Prompt'),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
