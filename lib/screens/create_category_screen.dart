import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/category.dart';
import '../providers/app_state.dart';
import '../theme/app_colors.dart';

class CreateCategoryScreen extends StatefulWidget {
  final Category? category; // For editing

  const CreateCategoryScreen({super.key, this.category});

  @override
  State<CreateCategoryScreen> createState() => _CreateCategoryScreenState();
}

class _CreateCategoryScreenState extends State<CreateCategoryScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  String _selectedIcon = 'category';
  String _selectedColor = '#0A7EA4';
  bool _isLoading = false;

  bool get isEditing => widget.category != null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.category?.name ?? '');
    if (widget.category != null) {
      _selectedIcon = widget.category!.iconName;
      _selectedColor = widget.category!.colorHex;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _saveCategory() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final appState = context.read<AppState>();

    if (isEditing) {
      // Update existing category
      await appState.updateCategory(
        id: widget.category!.id,
        name: _nameController.text,
        iconName: _selectedIcon,
        colorHex: _selectedColor,
      );
    } else {
      // Create new category
      await appState.addCategory(
        name: _nameController.text,
        iconName: _selectedIcon,
        colorHex: _selectedColor,
      );
    }

    setState(() => _isLoading = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isEditing ? 'Category updated!' : 'Category created!',
          ),
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
        title: Text(isEditing ? 'Edit Category' : 'Create Category'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Preview Card
            Center(
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(int.parse(_selectedColor.replaceFirst('#', '0xFF'))),
                      Color(int.parse(_selectedColor.replaceFirst('#', '0xFF'))).withValues(alpha: 0.8),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  Category.getIcon(_selectedIcon),
                  color: Colors.white,
                  size: 50,
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Name Field
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Category Name',
                hintText: 'Enter category name',
                prefixIcon: Icon(Icons.category),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a name';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),

            // Icon Selection
            Text(
              'Select Icon',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.foregroundDark : AppColors.foregroundLight,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: CategoryData.presetIconNames.map((iconName) {
                final isSelected = _selectedIcon == iconName;
                return GestureDetector(
                  onTap: () => setState(() => _selectedIcon = iconName),
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary.withValues(alpha: 0.2)
                          : (isDark ? AppColors.surfaceContainerDark : AppColors.surfaceContainerLight),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected ? AppColors.primary : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: Icon(
                      Category.getIcon(iconName),
                      color: isSelected ? AppColors.primary : (isDark ? AppColors.mutedDark : AppColors.mutedLight),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            // Color Selection
            Text(
              'Select Color',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.foregroundDark : AppColors.foregroundLight,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: CategoryData.presetColorHex.map((colorHex) {
                final isSelected = _selectedColor == colorHex;
                final color = Color(int.parse(colorHex.replaceFirst('#', '0xFF')));
                return GestureDetector(
                  onTap: () => setState(() => _selectedColor = colorHex),
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected ? Colors.white : Colors.transparent,
                        width: 3,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: color.withValues(alpha: 0.5),
                                blurRadius: 8,
                                spreadRadius: 2,
                              ),
                            ]
                          : null,
                    ),
                    child: isSelected
                        ? const Icon(Icons.check, color: Colors.white)
                        : null,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 32),

            // Save Button
            ElevatedButton(
              onPressed: _isLoading ? null : _saveCategory,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : Text(isEditing ? 'Update Category' : 'Create Category'),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
