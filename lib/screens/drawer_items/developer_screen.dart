import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show debugPrint, Clipboard, ClipboardData;
import 'package:url_launcher/url_launcher.dart';

class DeveloperScreen extends StatelessWidget {
  const DeveloperScreen({super.key});

  Future<void> _launchUrl(BuildContext context, String url) async {
    final Uri uri = Uri.parse(url);
    
    try {
      // Universal approach - works on all url_launcher versions
      if (await canLaunchUrl(uri)) {
        await launchUrl(
          uri,
          mode: LaunchMode.platformDefault,  // Safe default
        );
      } else {
        _showError(context, url);
      }
    } catch (e) {
      debugPrint('Launch failed: $e');
      _showError(context, url);
    }
  }

  void _showError(BuildContext context, String url) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Cannot open $url'),
          backgroundColor: Colors.red.shade100,
          action: SnackBarAction(
            label: 'Copy Link',
            textColor: Colors.red.shade700,
            onPressed: () => Clipboard.setData(ClipboardData(text: url)),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFEFF),
      appBar: AppBar(
        title: const Text('Meet the Developer'),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: const Color(0xFF1F2937),
        shadowColor: Colors.black.withOpacity(0.05),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _buildHeroSection()),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: _buildBioCard(),
            ),
          ),
          SliverToBoxAdapter(child: _buildSocialLinks(context)),
          const SliverFillRemaining(),
        ],
      ),
    );
  }

  Widget _buildHeroSection() {
    return Container(
      height: 200,
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(24, 20, 24, 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF667EEA),
            const Color(0xFF764BA2),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: const [
          BoxShadow(
            color: Color(0x40636BFF),
            blurRadius: 32,
            offset: Offset(0, 16),
          ),
        ],
      ),
      child: const Padding(
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.white,
              child: Icon(
                Icons.developer_mode_rounded,
                size: 28,
                color: Color(0xFF6366F1),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Nihal Shaikh',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                height: 1.2,
              ),
            ),
            Text(
              'Flutter Developer',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white70,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBioCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F000000),
            blurRadius: 24,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: const Column(
        children: [
          Text(
            'Passionate about building beautiful mobile experiences with Flutter. Creating tools that help developers grow!',
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF4B5563),
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8),
          Text(
            '📍 Mumbai, India',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF9CA3AF),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialLinks(BuildContext context) {
    final links = [
      _SocialLink(
        icon: Icons.web_rounded,
        label: 'Portfolio',
        fullUrl: 'https://shaikhnihal.vercel.app',
        preferApp: false,  // Website → Browser
      ),
      _SocialLink(
        icon: Icons.business_rounded,
        label: 'LinkedIn',
        fullUrl: 'https://www.linkedin.com/in/nihal-shaikh-892755379/',
        preferApp: true,   // App preferred
      ),
      _SocialLink(
        icon: Icons.code_rounded,
        label: 'GitHub',
        fullUrl: 'https://github.com/shaikhxnihal',
        preferApp: false,  // Website → Browser
      ),
      _SocialLink(
        icon: Icons.camera_alt_rounded,
        label: 'Instagram',
        fullUrl: 'https://www.instagram.com/shaikh.nhl',
        preferApp: true,   // App preferred
      ),
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 40),
      child: Column(
        children: links.map((link) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _buildSocialButton(context, link),
        )).toList(),
      ),
    );
  }

  Widget _buildSocialButton(BuildContext context, _SocialLink link) {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A6366F1),
            blurRadius: 16,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => _launchUrl(context, link.fullUrl),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFEEF2FF), Color(0xFFE0E7FF)],
                    ),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(link.icon, color: const Color(0xFF6366F1), size: 20),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    link.label,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: Color(0xFF6366F1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: Colors.white,
                        size: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SocialLink {
  final IconData icon;
  final String label;
  final String fullUrl;
  final bool preferApp;

  _SocialLink({
    required this.icon,
    required this.label,
    required this.fullUrl,
    this.preferApp = false,
  });
}
