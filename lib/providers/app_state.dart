import 'package:flutter/material.dart';
import '../models/models.dart';
import '../data/sample_data.dart' as data;

class AppState extends ChangeNotifier {
  List<Prompt> _prompts = data.prompts;
  Set<String> _favorites = {};
  String _searchQuery = '';
  String _selectedCategory = 'all';
  bool _isDarkMode = false;

  List<Prompt> get prompts => _prompts;
  Set<String> get favorites => _favorites;
  String get searchQuery => _searchQuery;
  String get selectedCategory => _selectedCategory;
  bool get isDarkMode => _isDarkMode;

  List<Prompt> get filteredPrompts {
    return _prompts.where((prompt) {
      final matchesSearch = _searchQuery.isEmpty ||
          prompt.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          prompt.description.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          prompt.tags.any((tag) => tag.toLowerCase().contains(_searchQuery.toLowerCase()));
      
      final matchesCategory = _selectedCategory == 'all' ||
          prompt.category == _selectedCategory ||
          (_selectedCategory == 'favorites' && _favorites.contains(prompt.id));
      
      return matchesSearch && matchesCategory;
    }).toList();
  }

  List<Prompt> get favoritePrompts {
    return _prompts.where((prompt) => _favorites.contains(prompt.id)).toList();
  }

  List<Prompt> get featuredPrompts {
    return _prompts.take(5).toList();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setSelectedCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void toggleFavorite(String promptId) {
    if (_favorites.contains(promptId)) {
      _favorites.remove(promptId);
    } else {
      _favorites.add(promptId);
    }
    notifyListeners();
  }

  bool isFavorite(String promptId) {
    return _favorites.contains(promptId);
  }

  void toggleDarkMode() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }
}
