import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/prompt.dart';
import '../models/category.dart';

class StorageService {
  static const String _promptsKey = 'prompts';
  static const String _favoritesKey = 'favorites';
  static const String _isDarkModeKey = 'isDarkMode';
  static const String _categoriesKey = 'categories';

  final SharedPreferences _prefs;

  StorageService(this._prefs);

  static Future<StorageService> init() async {
    final prefs = await SharedPreferences.getInstance();
    return StorageService(prefs);
  }

  // Prompts CRUD
  List<Prompt> getPrompts() {
    final String? promptsJson = _prefs.getString(_promptsKey);
    if (promptsJson == null || promptsJson.isEmpty) {
      return [];
    }
    try {
      final List<dynamic> promptsList = jsonDecode(promptsJson);
      return promptsList.map((e) => Prompt.fromJson(e)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<bool> savePrompts(List<Prompt> prompts) async {
    try {
      final String promptsJson = jsonEncode(prompts.map((e) => e.toJson()).toList());
      return await _prefs.setString(_promptsKey, promptsJson);
    } catch (e) {
      debugPrint('Error saving prompts: $e');
      return false;
    }
  }

  Future<bool> addPrompt(Prompt prompt) async {
    try {
      final prompts = getPrompts();
      prompts.add(prompt);
      return await savePrompts(prompts);
    } catch (e) {
      debugPrint('Error adding prompt: $e');
      return false;
    }
  }

  Future<bool> updatePrompt(Prompt prompt) async {
    try {
      final prompts = getPrompts();
      final index = prompts.indexWhere((p) => p.id == prompt.id);
      if (index != -1) {
        prompts[index] = prompt;
        return await savePrompts(prompts);
      }
      return false;
    } catch (e) {
      debugPrint('Error updating prompt: $e');
      return false;
    }
  }

  Future<bool> deletePrompt(String id) async {
    try {
      final prompts = getPrompts();
      prompts.removeWhere((p) => p.id == id);
      return await savePrompts(prompts);
    } catch (e) {
      debugPrint('Error deleting prompt: $e');
      return false;
    }
  }

  // Favorites
  Set<String> getFavorites() {
    final List<String>? favorites = _prefs.getStringList(_favoritesKey);
    return favorites?.toSet() ?? {};
  }

  Future<bool> saveFavorites(Set<String> favorites) async {
    return await _prefs.setStringList(_favoritesKey, favorites.toList());
  }

  // Theme
  bool getIsDarkMode() {
    return _prefs.getBool(_isDarkModeKey) ?? false;
  }

  Future<bool> setIsDarkMode(bool isDarkMode) async {
    return await _prefs.setBool(_isDarkModeKey, isDarkMode);
  }

  // Categories
  List<Category> getCategories() {
    final String? categoriesJson = _prefs.getString(_categoriesKey);
    if (categoriesJson == null || categoriesJson.isEmpty) {
      return [];
    }
    try {
      final List<dynamic> categoriesList = jsonDecode(categoriesJson);
      return categoriesList.map((e) => Category.fromJson(e)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<bool> saveCategories(List<Category> categories) async {
    try {
      final String categoriesJson = jsonEncode(categories.map((e) => e.toJson()).toList());
      return await _prefs.setString(_categoriesKey, categoriesJson);
    } catch (e) {
      debugPrint('Error saving categories: $e');
      return false;
    }
  }

  // Clear all data
  Future<bool> clearAll() async {
    return await _prefs.clear();
  }
}
