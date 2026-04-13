import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/core/session_controller.dart';
import 'package:flutter_application_1/src/pages/catalog_page.dart';
import 'package:flutter_application_1/src/pages/home_page.dart';
import 'package:flutter_application_1/src/pages/library_page.dart';
import 'package:flutter_application_1/src/pages/profile_page.dart';

class ShellPage extends StatefulWidget {
  const ShellPage({required this.sessionController, super.key});

  final SessionController sessionController;

  @override
  State<ShellPage> createState() => _ShellPageState();
}

class _ShellPageState extends State<ShellPage> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomePage(sessionController: widget.sessionController),
      CatalogPage(sessionController: widget.sessionController),
      LibraryPage(sessionController: widget.sessionController),
      ProfilePage(sessionController: widget.sessionController),
    ];

    return Scaffold(
      body: pages[_index],
      bottomNavigationBar: NavigationBar(
        height: 74,
        selectedIndex: _index,
        onDestinationSelected: (value) {
          setState(() {
            _index = value;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Accueil',
          ),
          NavigationDestination(
            icon: Icon(Icons.explore_outlined),
            selectedIcon: Icon(Icons.explore),
            label: 'Catalogue',
          ),
          NavigationDestination(
            icon: Icon(Icons.bookmark_outline),
            selectedIcon: Icon(Icons.bookmark),
            label: 'Bibliothèque',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}
