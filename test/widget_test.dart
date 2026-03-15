import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:prompt_store/providers/app_state.dart';
import 'package:prompt_store/theme/app_theme.dart';
import 'package:prompt_store/screens/home_screen.dart';
import 'package:prompt_store/screens/favorites_screen.dart';
import 'package:prompt_store/screens/settings_screen.dart';
import 'package:prompt_store/screens/create_prompt_screen.dart';
import 'package:prompt_store/services/storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('App renders correctly', (WidgetTester tester) async {
    final prefs = await SharedPreferences.getInstance();
    final storageService = StorageService(prefs);

    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => AppState(storageService),
        child: MaterialApp(
          theme: AppTheme.lightTheme,
          home: const MainNavigation(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Favorites'), findsOneWidget);
    expect(find.text('Settings'), findsOneWidget);
  });
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  void _onItemSelected(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Widget _buildScreen(int index) {
    switch (index) {
      case 0:
        return HomeScreen(
          currentIndex: _currentIndex,
          onNavigate: _onItemSelected,
        );
      case 1:
        return const FavoritesScreen();
      case 2:
        return const SettingsScreen();
      default:
        return HomeScreen(
          currentIndex: _currentIndex,
          onNavigate: _onItemSelected,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: List.generate(3, (index) => _buildScreen(index)),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_outline),
            selectedIcon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CreatePromptScreen()),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Prompt'),
      ),
    );
  }
}
