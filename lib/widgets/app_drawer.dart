// lib/widgets/app_drawer.dart
import 'package:flutter/material.dart';
import 'package:flutter_guide/screens/drawer_items/about_screen.dart';
import 'package:flutter_guide/screens/drawer_items/developer_screen.dart';
import 'package:flutter_guide/screens/drawer_items/feedback_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';


// Assuming your main notes/quiz screen is NotesScreen
// import '../screens/notes_screen.dart'; // Uncomment and adjust as needed

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFFFDFEFF),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
           DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color.fromARGB(255, 206, 215, 254), Color.fromARGB(255, 137, 139, 254)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                    image: DecorationImage(image: AssetImage("assets/images/Flutter-Prep-AppIcon-Android-Light.png"))
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  'Flutter Prep',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ],
            ),
          ),
          _buildDrawerItem(
            context,
            icon: Icons.home_rounded,
            title: 'Home',
            onTap: () {
              // Navigate to your main notes/quiz screen
              Navigator.pop(context); // Close drawer
              // Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => NotesScreen()));
              // For now, just close drawer assuming we're already on home
            },
          ),
          _buildDrawerItem(
            context,
            icon: Icons.feedback_rounded,
            title: 'Feedback',
            onTap: () {
              Navigator.pop(context); // Close drawer
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const FeedbackScreen(),
                ),
              );
            },
          ),
          _buildDrawerItem(
            context,
            icon: Icons.info_rounded,
            title: 'About',
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const AboutScreen(),
                ),
              );
            },
          ),
          _buildDrawerItem(
            context,
            icon: Icons.person_rounded,
            title: 'Who Made This App',
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const DeveloperScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

 Widget _buildDrawerItem(
  BuildContext context, {
  required IconData icon,
  required String title,
  required VoidCallback onTap,
}) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: const [
        BoxShadow(
          color: Color(0x0F000000),
          blurRadius: 8,
          offset: Offset(0, 1),
        ),
      ],
    ),
    child: Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFEEF2FF),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: const Color(0xFF6366F1), size: 20),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1F2937),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFFDFEFF),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.chevron_right_rounded,
                  color: const Color(0xFF9CA3AF),
                  size: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

}

