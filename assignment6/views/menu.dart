import 'package:flutter/material.dart';
import 'package:cs442_mp6/views/favorites_page.dart';
import 'package:cs442_mp6/views/home.dart';
import 'package:cs442_mp6/views/search_history.dart';
import 'package:cs442_mp6/views/search.dart';

class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      key: const Key("Drawer"),
      child: Column(
        children: [
          // Drawer Header
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue, Colors.blueAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.person,
                    size: 40,
                    color: Colors.blueAccent,
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Welcome!',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'user@example.com',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Menu Items
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildMenuItem(
                  context,
                  icon: Icons.home,
                  title: 'Home',
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<String>(
                        builder: (context) {
                          return const Home();
                        },
                      ),
                    );
                  },
                ),
                const Divider(thickness: 1, height: 1),
                _buildMenuItem(
                  context,
                  icon: Icons.star,
                  title: 'Favorites',
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<String>(
                        builder: (context) {
                          return const FavoritesPage();
                        },
                      ),
                    );
                  },
                  key: const Key("FavoriteKey"),
                ),
                const Divider(thickness: 1, height: 1),
                _buildMenuItem(
                  context,
                  icon: Icons.history,
                  title: 'Search History',
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<String>(
                        builder: (context) {
                          return const SearchHistory();
                        },
                      ),
                    );
                  },
                ),
                const Divider(thickness: 1, height: 1),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to build menu items
  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Key? key,
  }) {
    return ListTile(
      key: key,
      leading: Icon(icon, color: Colors.blueAccent),
      title: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      onTap: onTap,
      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.blueAccent),
    );
  }
}
