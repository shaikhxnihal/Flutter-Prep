import 'package:flutter/material.dart';
import 'package:flutter_guide/models/section.dart';

// Updated _NeumorphicCard with accurate Q&A count and better visuals
class NeumorphicCard extends StatelessWidget {
  final Section section;
  final VoidCallback onTap;
  final bool isInterview;

  const NeumorphicCard({
    required this.section,
    required this.onTap,
    this.isInterview = false,
  });

  int get _totalItems {
    if (!isInterview) return section.subsections.length;

    int total = 0;
    for (final sub in section.subsections) {
      total += sub.qa?.length ?? 0;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    final subtitle = isInterview
        ? 'Curated interview questions with detailed answers'
        : (section.content.length > 100 ? '${section.content.substring(0, 100)}...' : section.content);

    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(28),
          onTap: onTap,
          splashColor: const Color(0xFF667EEA).withOpacity(0.15),
          highlightColor: const Color(0xFF667EEA).withOpacity(0.08),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
              boxShadow: const [
                BoxShadow(color: Color(0x1A667EEA), blurRadius: 40, offset: Offset(0, 20)),
                BoxShadow(color: Color(0x0A000000), blurRadius: 20, offset: Offset(0, 8)),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(colors: [Color(0xFF667EEA), Color(0xFF764BA2)]),
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: const [
                          BoxShadow(color: Color(0x4D667EEA), blurRadius: 24, offset: Offset(0, 10)),
                        ],
                      ),
                      child: Icon(
                        isInterview ? Icons.question_answer_rounded : Icons.article_rounded,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 18),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            section.title,
                            style: const TextStyle(
                              fontSize: 21,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF1F2937),
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            subtitle,
                            style: const TextStyle(
                              fontSize: 15,
                              color: Color(0xFF6B7280),
                              height: 1.5,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right_rounded, color: Color(0xFF9CA3AF), size: 28),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F4F6),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            isInterview ? Icons.quiz_rounded : Icons.layers_rounded,
                            size: 18,
                            color: const Color(0xFF667EEA),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '$_totalItems',
                            style: const TextStyle(
                              color: Color(0xFF667EEA),
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            isInterview ? 'Questions' : 'Topics',
                            style: const TextStyle(
                              color: Color(0xFF667EEA),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF667EEA).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: const Icon(Icons.play_arrow_rounded, color: Color(0xFF667EEA), size: 28),
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