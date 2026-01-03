import 'package:flutter/material.dart';

// New: No Results Widget
class NoResultsWidget extends StatelessWidget {
  const NoResultsWidget();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.search_off_rounded, size: 80, color: Colors.grey[400]),
            const SizedBox(height: 24),
            Text(
              'No results found',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: Colors.grey[800]),
            ),
            const SizedBox(height: 12),
            Text(
              'Try searching with different keywords',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }
}