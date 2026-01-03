// section_details_screen.dart - UPDATED & POLISHED VERSION (Matches NotesScreen UI/UX) - FIXED 'asMap' ERROR
import 'package:flutter/material.dart';
import 'package:flutter_guide/models/section.dart';

class SectionDetailsScreen extends StatelessWidget {
  final Section section;
  final bool isInterview; // True if this section comes from Interview tab

  const SectionDetailsScreen({
    Key? key,
    required this.section,
    this.isInterview = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFEFF),
      appBar: AppBar(
        title: Text(
          section.title,
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: const Color(0xFF1F2937),
        actions: [
          IconButton(icon: const Icon(Icons.bookmark_border_rounded), onPressed: () {}),
          IconButton(icon: const Icon(Icons.share_rounded), onPressed: () {}),
        ],
      ),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(child: _buildHeroContent(context)),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 140), // Extra bottom for FAB overlap
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => _buildSubsectionCard(
                  context,
                  section.subsections[index],
                  index,
                ),
                childCount: section.subsections.length,
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        backgroundColor: const Color(0xFF667EEA),
        foregroundColor: Colors.white,
        elevation: 12,
        icon: const Icon(Icons.check_circle_rounded),
        label: const Text('Mark as Complete', style: TextStyle(fontWeight: FontWeight.w600)),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildHeroContent(BuildContext context) {
    final totalItems = isInterview
        ? section.subsections.fold<int>(0, (sum, sub) => sum + (sub.qa?.length ?? 0))
        : section.subsections.length;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(24),
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF667EEA).withOpacity(0.08),
            const Color(0xFF764BA2).withOpacity(0.05)
          ],
        ),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: const Color(0xFF667EEA).withOpacity(0.15)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF667EEA).withOpacity(0.1),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Color(0xFF667EEA), Color(0xFF764BA2)]),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF667EEA).withOpacity(0.4),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Icon(
                  isInterview ? Icons.question_answer_rounded : Icons.article_rounded,
                  color: Colors.white,
                  size: 32,
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      section.title,
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '$totalItems ${isInterview ? "Questions" : "Topics"} • ${totalItems * 4} min',
                      style: const TextStyle(fontSize: 15, color: Color(0xFF6B7280)),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          if (section.content.isNotEmpty)
            Text(
              section.content,
              style: const TextStyle(fontSize: 16, height: 1.7, color: Color(0xFF374151)),
            ),
        ],
      ),
    );
  }

  Widget _buildSubsectionCard(BuildContext context, Subsection subsection, int index) {
    final hasContent = subsection.points != null ||
        subsection.code != null ||
        subsection.desc != null ||
        subsection.steps != null ||
        subsection.widgets != null ||
        (isInterview && subsection.qa != null);

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(28),
          onTap: () => _showSubsectionModal(context, subsection),
          splashColor: const Color(0xFF667EEA).withOpacity(0.15),
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
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFF667EEA),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Center(
                        child: Text(
                          '${index + 1}',
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        subsection.title ?? (isInterview ? "Question ${index + 1}" : "Topic ${index + 1}"),
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Color(0xFF1F2937)),
                      ),
                    ),
                    const Icon(Icons.chevron_right_rounded, color: Color(0xFF9CA3AF), size: 28),
                  ],
                ),
                const SizedBox(height: 20),

                // Preview based on type
                if (isInterview && subsection.qa != null && subsection.qa!.isNotEmpty)
                  _buildQAPreview(subsection.qa!)
                else if (subsection.points != null && subsection.points!.isNotEmpty)
                  _buildPointsPreview(subsection.points!)
                else if (subsection.code != null)
                  _buildCodePreview(subsection.code!)
                else if (subsection.desc != null)
                  _buildDescriptionPreview(subsection.desc!)
                else if (subsection.steps != null && subsection.steps!.isNotEmpty)
                  _buildStepsPreview(subsection.steps!)
                else if (subsection.widgets != null && subsection.widgets!.isNotEmpty)
                  _buildWidgetsPreview(subsection.widgets!),

                if (hasContent) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Tap to expand',
                      style: TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Preview Widgets
  Widget _buildQAPreview(List<QA> qaList) {
    final first = qaList.first;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Q: ${first.question}', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF1F2937))),
        const SizedBox(height: 8),
        Text(
          first.answer.length > 120 ? '${first.answer.substring(0, 120)}...' : first.answer,
          style: const TextStyle(fontSize: 14, color: Color(0xFF4B5563), height: 1.5),
        ),
        if (qaList.length > 1)
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Text('+ ${qaList.length - 1} more questions', style: TextStyle(color: Color(0xFF667EEA), fontWeight: FontWeight.w600)),
          ),
      ],
    );
  }

  Widget _buildPointsPreview(List<String> points) => Column(children: points.take(3).map((p) => Padding(padding: const EdgeInsets.only(bottom: 8), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Container(width: 6, height: 6, margin: const EdgeInsets.only(top: 7), decoration: const BoxDecoration(color: Color(0xFF667EEA), shape: BoxShape.circle)), const SizedBox(width: 12), Expanded(child: Text(p, style: TextStyle(color: Color(0xFF374151), height: 1.5)))]))).toList());

  Widget _buildCodePreview(String code) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(12)),
      child: Text(
        code.length > 150 ? '${code.substring(0, 150)}...' : code,
        style: const TextStyle(fontFamily: 'monospace', fontSize: 13, color: Color(0xFF1E293B)),
        maxLines: 5,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildDescriptionPreview(String desc) => Text(desc, style: const TextStyle(fontSize: 15, color: Color(0xFF374151), height: 1.6), maxLines: 4, overflow: TextOverflow.ellipsis);

  Widget _buildStepsPreview(List<String> steps) => Column(children: steps.take(2).toList().asMap().entries.map((e) => Padding(padding: const EdgeInsets.symmetric(vertical: 6), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Container(width: 28, height: 28, decoration: BoxDecoration(color: const Color(0xFF667EEA), borderRadius: BorderRadius.circular(14)), child: Center(child: Text('${e.key + 1}', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)))), const SizedBox(width: 12), Expanded(child: Text(e.value, style: TextStyle(color: Color(0xFF374151), height: 1.5)))]))).toList());

  Widget _buildWidgetsPreview(List<WidgetInfo> widgets) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: widgets.take(2).map((w) => Padding(padding: const EdgeInsets.only(bottom: 8), child: Row(children: [Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5), decoration: BoxDecoration(color: const Color(0xFFF3F4F6), borderRadius: BorderRadius.circular(8)), child: Text(w.name, style: const TextStyle(fontFamily: 'monospace', fontSize: 13, fontWeight: FontWeight.w600))), const SizedBox(width: 12), Expanded(child: Text(w.desc ?? '', style: TextStyle(fontSize: 13, color: Color(0xFF6B7280))))]))).toList());

  // Modal Full Content
  void _showSubsectionModal(BuildContext context, Subsection subsection) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.8,
        minChildSize: 0.6,
        maxChildSize: 0.95,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 12),
              Container(width: 48, height: 5, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(3))),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  subsection.title ?? "Details",
                  style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: Color(0xFF1F2937)),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: _buildFullSubsectionContent(subsection),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFullSubsectionContent(Subsection subsection) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isInterview && subsection.qa != null && subsection.qa!.isNotEmpty)
          _buildFullQAList(subsection.qa!),

        if (subsection.points != null && subsection.points!.isNotEmpty)
          _buildFullPointsList(subsection.points!),

        if (subsection.code != null)
          _buildFullCodeBlock(subsection.code!),

        if (subsection.desc != null)
          _buildFullDescription(subsection.desc!),

        if (subsection.steps != null && subsection.steps!.isNotEmpty)
          _buildFullStepsList(subsection.steps!),

        if (subsection.widgets != null && subsection.widgets!.isNotEmpty)
          _buildFullWidgetsTable(subsection.widgets!),

        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildFullQAList(List<QA> qaList) {
    return Column(
      children: qaList.asMap().entries.map((entry) {
        final qa = entry.value;
        return Container(
          margin: const EdgeInsets.only(bottom: 32),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: const Color(0xFF667EEA), borderRadius: BorderRadius.circular(12)),
                    child: Text('${entry.key + 1}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(child: Text('Question', style: TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF667EEA)))),
                ],
              ),
              const SizedBox(height: 12),
              Text(qa.question, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
              const SizedBox(height: 20),
              const Text('Answer', style: TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF667EEA))),
              const SizedBox(height: 12),
              Text(qa.answer, style: const TextStyle(fontSize: 16, height: 1.7, color: Color(0xFF374151))),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildFullPointsList(List<String> points) => Column(children: points.map((p) => Padding(padding: const EdgeInsets.symmetric(vertical: 10), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Container(width: 8, height: 8, margin: const EdgeInsets.only(top: 8), decoration: const BoxDecoration(color: Color(0xFF667EEA), shape: BoxShape.circle)), const SizedBox(width: 16), Expanded(child: Text(p, style: TextStyle(fontSize: 16, height: 1.6, color: Color(0xFF374151))))]))).toList());

  Widget _buildFullCodeBlock(String code) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('Code Example', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Color(0xFF1F2937))), const SizedBox(height: 16), Container(width: double.infinity, padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(16), border: Border.all(color: Color(0xFFE2E8F0))), child: SelectableText(code, style: const TextStyle(fontFamily: 'monospace', fontSize: 14, height: 1.6, color: Color(0xFF1E293B))))]);

  Widget _buildFullDescription(String desc) => Text(desc, style: const TextStyle(fontSize: 16, height: 1.7, color: Color(0xFF374151)));

  Widget _buildFullStepsList(List<String> steps) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('Steps', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)), const SizedBox(height: 16), ...steps.asMap().entries.map((e) => Padding(padding: const EdgeInsets.symmetric(vertical: 12), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Container(width: 36, height: 36, decoration: BoxDecoration(color: const Color(0xFF667EEA), borderRadius: BorderRadius.circular(18)), child: Center(child: Text('${e.key + 1}', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)))), const SizedBox(width: 16), Expanded(child: Text(e.value, style: TextStyle(fontSize: 16, height: 1.6, color: Color(0xFF374151))))])))]);

  Widget _buildFullWidgetsTable(List<WidgetInfo> widgets) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Key Widgets', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
        const SizedBox(height: 16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            headingRowHeight: 48,
            dataRowHeight: 64,
            columnSpacing: 32,
            headingRowColor: MaterialStateProperty.all(const Color(0xFFF8FAFC)),
            border: TableBorder.all(color: const Color(0xFFE2E8F0), width: 1, borderRadius: BorderRadius.circular(12)),
            columns: const [
              DataColumn(label: Text('Widget', style: TextStyle(fontWeight: FontWeight.w700))),
              DataColumn(label: Text('Description', style: TextStyle(fontWeight: FontWeight.w700))),
            ],
            rows: widgets.map((w) => DataRow(cells: [
              DataCell(Text(w.name, style: const TextStyle(fontFamily: 'monospace', fontWeight: FontWeight.w600))),
              DataCell(Text(w.desc ?? '-', style: TextStyle(color: Color(0xFF4B5563)))),
            ])).toList(),
          ),
        ),
      ],
    );
  }
}