import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/prompt.dart' hide Category;
import '../models/category.dart';
import '../services/storage_service.dart';

class AppState extends ChangeNotifier {
  final StorageService _storageService;
  List<Prompt> _prompts = [];
  List<Category> _categories = CategoryData.defaultCategories;
  Set<String> _favorites = {};
  String _searchQuery = '';
  String _selectedCategory = 'all';
  String _searchFilter = 'all'; // all, my, favorites
  bool _isDarkMode = false;
  bool _isLoading = true;
  bool _isOnboardingComplete = false;

  AppState(this._storageService) {
    _loadData();
  }

  // Getters
  List<Prompt> get prompts => _prompts;
  List<Category> get categories => _categories;
  Set<String> get favorites => _favorites;
  String get searchQuery => _searchQuery;
  String get selectedCategory => _selectedCategory;
  String get searchFilter => _searchFilter;
  bool get isDarkMode => _isDarkMode;
  bool get isLoading => _isLoading;
  bool get isOnboardingComplete => _isOnboardingComplete;

  void setOnboardingComplete(bool value) {
    _isOnboardingComplete = value;
    _storageService.setOnboardingComplete(value);
    notifyListeners();
  }

  // Initialize with sample data
  void _loadData() {
    _isDarkMode = _storageService.getIsDarkMode();
    _favorites = _storageService.getFavorites();
    _isOnboardingComplete = _storageService.getOnboardingComplete();
    
    // Load categories
    final storedCategories = _storageService.getCategories();
    if (storedCategories.isNotEmpty) {
      _categories = storedCategories;
    }

    final storedPrompts = _storageService.getPrompts();
    if (storedPrompts.isEmpty) {
      _prompts = _getSamplePrompts();
      _storageService.savePrompts(_prompts);
    } else {
      _prompts = storedPrompts;
    }
    _isLoading = false;
    notifyListeners();
  }

  // Filtered prompts based on search and filters
  List<Prompt> get filteredPrompts {
    return _prompts.where((prompt) {
      // Search query filter
      final matchesSearch = _searchQuery.isEmpty ||
          prompt.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          prompt.description.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          prompt.tags.any((tag) => tag.toLowerCase().contains(_searchQuery.toLowerCase()));
      
      // Category filter
      final matchesCategory = _selectedCategory == 'all' ||
          prompt.category == _selectedCategory;
      
      // Search filter (all, my prompts, favorites)
      final matchesFilter = _searchFilter == 'all' ||
          (_searchFilter == 'my' && prompt.author == 'You') ||
          (_searchFilter == 'favorites' && _favorites.contains(prompt.id));
      
      return matchesSearch && matchesCategory && matchesFilter;
    }).toList();
  }

  List<Prompt> get favoritePrompts {
    return _prompts.where((prompt) => _favorites.contains(prompt.id)).toList();
  }

  List<Prompt> get featuredPrompts {
    final sorted = List<Prompt>.from(_prompts);
    sorted.sort((a, b) => b.usageCount.compareTo(a.usageCount));
    return sorted.take(5).toList();
  }

  List<Prompt> get userPrompts {
    return _prompts.where((p) => p.author == 'You' || p.isCustom == true).toList();
  }

  // Search
  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setSearchFilter(String filter) {
    _searchFilter = filter;
    notifyListeners();
  }

  // Category filter
  void setSelectedCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  // Favorites
  void toggleFavorite(String promptId) async {
    if (_favorites.contains(promptId)) {
      _favorites.remove(promptId);
    } else {
      _favorites.add(promptId);
    }
    await _storageService.saveFavorites(_favorites);
    notifyListeners();
  }

  bool isFavorite(String promptId) {
    return _favorites.contains(promptId);
  }

  // Theme
  void toggleDarkMode() async {
    _isDarkMode = !_isDarkMode;
    await _storageService.setIsDarkMode(_isDarkMode);
    notifyListeners();
  }

  // CRUD Operations for Prompts
  Future<bool> addPrompt({
    required String title,
    required String description,
    required String content,
    required String category,
    String? author,
    List<String>? tags,
    String? imageUrl,
    String? outputPreview,
  }) async {
    final now = DateTime.now();
    final prompt = Prompt(
      id: const Uuid().v4(),
      title: title,
      description: description,
      content: content,
      category: category,
      author: author ?? 'You',
      createdAt: now,
      updatedAt: now,
      tags: tags ?? [],
      imageUrl: imageUrl,
      outputPreview: outputPreview,
      isCustom: true,
    );
    _prompts.insert(0, prompt);
    final success = await _storageService.savePrompts(_prompts);
    notifyListeners();
    return success;
  }

  Future<bool> updatePrompt({
    required String id,
    required String title,
    required String description,
    required String content,
    required String category,
    String? author,
    List<String>? tags,
    String? imageUrl,
    String? outputPreview,
  }) async {
    final index = _prompts.indexWhere((p) => p.id == id);
    if (index != -1) {
      _prompts[index] = _prompts[index].copyWith(
        title: title,
        description: description,
        content: content,
        category: category,
        author: author,
        tags: tags,
        imageUrl: imageUrl,
        outputPreview: outputPreview,
        updatedAt: DateTime.now(),
      );
      final success = await _storageService.savePrompts(_prompts);
      notifyListeners();
      return success;
    }
    return false;
  }

  Future<bool> deletePrompt(String id) async {
    _prompts.removeWhere((p) => p.id == id);
    _favorites.remove(id);
    await _storageService.saveFavorites(_favorites);
    final success = await _storageService.savePrompts(_prompts);
    notifyListeners();
    return success;
  }

  void incrementUsageCount(String promptId) async {
    final index = _prompts.indexWhere((p) => p.id == promptId);
    if (index != -1) {
      _prompts[index] = _prompts[index].copyWith(
        usageCount: _prompts[index].usageCount + 1,
      );
      await _storageService.savePrompts(_prompts);
      notifyListeners();
    }
  }

  // Get prompts by category
  List<Prompt> getPromptsByCategory(String categoryId) {
    return _prompts.where((p) => p.category == categoryId).toList();
  }

  // CRUD Operations for Categories
  Future<bool> addCategory({
    required String name,
    required String iconName,
    required String colorHex,
  }) async {
    final category = Category(
      id: const Uuid().v4(),
      name: name,
      iconName: iconName,
      colorHex: colorHex,
      isCustom: true,
      order: _categories.length,
    );
    _categories.add(category);
    final success = await _storageService.saveCategories(_categories);
    notifyListeners();
    return success;
  }

  Future<bool> updateCategory({
    required String id,
    required String name,
    required String iconName,
    required String colorHex,
  }) async {
    final index = _categories.indexWhere((c) => c.id == id);
    if (index != -1) {
      _categories[index] = _categories[index].copyWith(
        name: name,
        iconName: iconName,
        colorHex: colorHex,
      );
      final success = await _storageService.saveCategories(_categories);
      notifyListeners();
      return success;
    }
    return false;
  }

  Future<bool> deleteCategory(String id) async {
    final category = _categories.firstWhere((c) => c.id == id);
    if (category.isDefault) return false; // Can't delete default categories
    
    _categories.removeWhere((c) => c.id == id);
    final success = await _storageService.saveCategories(_categories);
    notifyListeners();
    return success;
  }

  List<Prompt> _getSamplePrompts() {
    final now = DateTime.now();
    return [
      Prompt(
        id: '1',
        title: 'Professional Email Writer',
        description: 'Write professional emails for various business scenarios',
        content: '''Write a professional email for the following scenario:

[SCENARIO]: [YOUR SCENARIO HERE]

Requirements:
- Formal tone
- Clear and concise
- Professional greeting and closing
- Include relevant details

Subject: [EMAIL SUBJECT]

Body:
[GENERATE YOUR EMAIL HERE]''',
        category: 'tasks',
        author: 'PromptStore',
        createdAt: now,
        updatedAt: now,
        usageCount: 1250,
        tags: ['email', 'business', 'professional'],
        outputPreview: 'Subject: Meeting Request\n\nDear [Name],\n\nI hope this email finds you well...',
      ),
      Prompt(
        id: '2',
        title: 'Midjourney Portrait',
        description: 'Create realistic portrait images',
        content: '''Create a portrait image with the following specifications:

Style: [REALISTIC/PHOTOREALISTIC/ARTISTIC]
Subject: [DESCRIBE YOUR SUBJECT]
Lighting: [NATURAL/STUDIO/DRAMATIC]
Mood: [SERIOUS/HAPPY/MYSTICAL]
Additional details: [ANY OTHER DETAILS]

Use high quality, 8k resolution, detailed features.''',
        category: 'images',
        author: 'PromptStore',
        createdAt: now.subtract(const Duration(days: 5)),
        updatedAt: now.subtract(const Duration(days: 5)),
        usageCount: 980,
        tags: ['portrait', 'midjourney', 'AI art'],
        outputPreview: '[Generated portrait image with detailed features]',
      ),
      Prompt(
        id: '3',
        title: 'YouTube Video Script',
        description: 'Generate engaging video scripts',
        content: '''Create a YouTube video script for:

Topic: [YOUR TOPIC]
Duration: [TARGET DURATION]
Tone: [EDUCATIONAL/ENTERTAINING/CASUAL]

Include:
- Hook (first 10 seconds)
- Main content points (3-5 key points)
- Call to action
- End screen suggestions

Target audience: [YOUR AUDIENCE]''',
        category: 'videos',
        author: 'PromptStore',
        createdAt: now.subtract(const Duration(days: 10)),
        updatedAt: now.subtract(const Duration(days: 10)),
        usageCount: 756,
        tags: ['youtube', 'script', 'video'],
      ),
      Prompt(
        id: '4',
        title: 'Blog Post Generator',
        description: 'Write SEO-friendly blog posts',
        content: '''Write a comprehensive blog post on:

Title: [YOUR TITLE]
Target keywords: [KEYWORD 1, KEYWORD 2, KEYWORD 3]
Word count: [TARGET WORD COUNT]

Structure:
1. Introduction (hook + topic introduction)
2. H2: [SUBHEADING 1]
3. H2: [SUBHEADING 2]
4. H2: [SUBHEADING 3]
5. Conclusion

Include SEO-optimized content with naturally integrated keywords.''',
        category: 'writing',
        author: 'PromptStore',
        createdAt: now.subtract(const Duration(days: 15)),
        updatedAt: now.subtract(const Duration(days: 15)),
        usageCount: 654,
        tags: ['blog', 'SEO', 'writing'],
      ),
      Prompt(
        id: '5',
        title: 'Code Review Assistant',
        description: 'Get comprehensive code reviews',
        content: '''Review the following code and provide feedback on:

[PASTE YOUR CODE HERE]

Focus on:
- Code quality and best practices
- Potential bugs or errors
- Performance optimization
- Security concerns
- Readability and maintainability

Provide a detailed analysis with specific suggestions for improvement.''',
        category: 'coding',
        author: 'PromptStore',
        createdAt: now.subtract(const Duration(days: 20)),
        updatedAt: now.subtract(const Duration(days: 20)),
        usageCount: 432,
        tags: ['code review', 'programming', 'development'],
      ),
      Prompt(
        id: '6',
        title: 'Quiz Generator',
        description: 'Create educational quizzes',
        content: '''Generate a quiz on:

Topic: [YOUR TOPIC]
Number of questions: [NUMBER]
Difficulty: [EASY/MEDIUM/HARD]
Format: [MCQ/TRUE-FILL/BOTH]

Include:
- Clear question statements
- 4 options for MCQ (A, B, C, D)
- Correct answers
- Brief explanations''',
        category: 'education',
        author: 'PromptStore',
        createdAt: now.subtract(const Duration(days: 25)),
        updatedAt: now.subtract(const Duration(days: 25)),
        usageCount: 521,
        tags: ['quiz', 'education', 'learning'],
      ),
      Prompt(
        id: '7',
        title: 'Stable Diffusion Landscape',
        description: 'Create stunning landscape images',
        content: '''Generate a breathtaking landscape image:

Setting: [MOUNTAINS/BEACH/FOREST/CITYSCAPE]
Time of day: [DAWN/NOON/SUNSET/NIGHT]
Weather: [CLEAR/CLOUDY/FOGGY/RAINY]
Style: [REALISTIC/PAINTING/DIGITAL ART]

Include:
- Detailed environment
- Proper lighting and shadows
- Atmospheric effects
- 8K resolution, photorealistic quality''',
        category: 'images',
        author: 'PromptStore',
        createdAt: now.subtract(const Duration(days: 30)),
        updatedAt: now.subtract(const Duration(days: 30)),
        usageCount: 887,
        tags: ['landscape', 'stable diffusion', 'art'],
      ),
      Prompt(
        id: '8',
        title: 'Meeting Summary',
        description: 'Summarize meeting notes effectively',
        content: '''Summarize the following meeting notes:

[PASTE MEETING NOTES]

Provide:
- Key discussion points
- Decisions made
- Action items with owners
- Next steps
- Follow-up timeline''',
        category: 'tasks',
        author: 'PromptStore',
        createdAt: now.subtract(const Duration(days: 35)),
        updatedAt: now.subtract(const Duration(days: 35)),
        usageCount: 445,
        tags: ['meeting', 'summary', 'productivity'],
      ),
      Prompt(
        id: '9',
        title: 'Social Media Caption',
        description: 'Write engaging social media posts',
        content: '''Create a social media caption for:

Platform: [INSTAGRAM/TWITTER/LINKEDIN]
Content type: [POST/STORY/REELS]
Topic: [YOUR TOPIC]

Include:
- Catchy headline
- Engaging body text (150-300 words for post)
- 5-10 relevant hashtags
- Call to action''',
        category: 'writing',
        author: 'PromptStore',
        createdAt: now.subtract(const Duration(days: 40)),
        updatedAt: now.subtract(const Duration(days: 40)),
        usageCount: 678,
        tags: ['social media', 'caption', 'marketing'],
      ),
      Prompt(
        id: '10',
        title: 'Video Tutorial Outline',
        description: 'Plan educational video tutorials',
        content: '''Create an outline for a video tutorial on:

Topic: [YOUR TOPIC]
Duration: [TARGET DURATION]
Skill level: [BEGINNER/INTERMEDIATE/ADVANCED]

Include:
- Learning objectives
- Section breakdown with timestamps
- Key points for each section
- Practice exercises
- Summary and next steps''',
        category: 'videos',
        author: 'PromptStore',
        createdAt: now.subtract(const Duration(days: 45)),
        updatedAt: now.subtract(const Duration(days: 45)),
        usageCount: 334,
        tags: ['tutorial', 'video', 'education'],
      ),
    ];
  }
}
