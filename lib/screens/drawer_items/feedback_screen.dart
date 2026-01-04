import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

// Feedback Screen with WebView (updated for webview_flutter ^4.4.4+)
class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();

    // Create and configure the WebViewController
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted) // Enable JS if your form needs it
      ..setBackgroundColor(const Color(0x00000000))    // Transparent background (optional)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Optional: Show a progress indicator
            debugPrint('Loading: $progress%');
            
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {
            debugPrint('WebView error: ${error.description}');
          },
        ),
      )
      ..loadRequest(Uri.parse('https://shaikhnihal.vercel.app/fp-feedback.html')); // ← Replace with your actual URL
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Feedback'),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: const Color(0xFF1F2937),
      ),
      body: WebViewWidget(
        controller: _controller, // ← Required parameter
      ),
    );
  }
}