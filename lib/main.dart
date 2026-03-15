import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/storage_service.dart';
import 'theme/app_theme.dart';
import 'providers/app_state.dart';
import 'screens/home_screen.dart';
import 'screens/categories_screen.dart';
import 'screens/my_prompts_screen.dart';
import 'screens/favorites_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/create_prompt_screen.dart';
import 'screens/drawer_menu.dart';
import 'screens/onboarding_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final storageService = await StorageService.init();
  runApp(MyApp(storageService: storageService));
}

class MyApp extends StatelessWidget {
  final StorageService storageService;

  const MyApp({super.key, required this.storageService});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppState(storageService),
      child: Consumer<AppState>(
        builder: (context, appState, _) {
          if (appState.isLoading) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              home: const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              ),
            );
          }

          if (!appState.isOnboardingComplete) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: appState.isDarkMode ? ThemeMode.dark : ThemeMode.light,
              home: const OnboardingScreen(),
            );
          }

          return MaterialApp(
            title: 'Prompt Store',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: appState.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            home: const MainNavigation(),
          );
        },
      ),
    );
  }
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Widget _buildScreen(int index) {
    switch (index) {
      case 0:
        return HomeScreen(
          currentIndex: _currentIndex,
          onNavigate: _onItemSelected,
          openDrawer: () => _scaffoldKey.currentState?.openDrawer(),
        );
      case 1:
        return CategoriesScreen(
          currentIndex: _currentIndex,
          onNavigate: _onItemSelected,
          openDrawer: () => _scaffoldKey.currentState?.openDrawer(),
        );
      case 2:
        return MyPromptsScreen(
          currentIndex: _currentIndex,
          onNavigate: _onItemSelected,
          openDrawer: () => _scaffoldKey.currentState?.openDrawer(),
        );
      case 3:
        return FavoritesScreen(
          currentIndex: _currentIndex,
          onNavigate: _onItemSelected,
          openDrawer: () => _scaffoldKey.currentState?.openDrawer(),
        );
      case 4:
        return SettingsScreen(
          currentIndex: _currentIndex,
          onNavigate: _onItemSelected,
          openDrawer: () => _scaffoldKey.currentState?.openDrawer(),
        );
      default:
        return HomeScreen(
          currentIndex: 0,
          onNavigate: _onItemSelected,
          openDrawer: () => _scaffoldKey.currentState?.openDrawer(),
        );
    }
  }

  void _onItemSelected(int index) {
    setState(() {
      _currentIndex = index;
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: AppDrawer(
        currentIndex: _currentIndex,
        onItemSelected: _onItemSelected,
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: List.generate(5, (index) => _buildScreen(index)),
      ),
      floatingActionButton: _currentIndex == 4
          ? null
          : FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CreatePromptScreen()),
                );
              },
              child: const Icon(Icons.add),
            ),
    );
  }
}
