// notes_screen.dart - FINAL POLISHED VERSION: MAX PERFORMANCE + FLAWLESS UI/UX
import 'package:flutter/material.dart';
import 'package:flutter_guide/core/filters/notes_filters.dart';
import 'package:flutter_guide/core/loads/notes_loaders.dart';
import 'package:flutter_guide/screens/flutter_quiz_screen.dart';
import 'package:flutter_guide/utils/show_methods.dart';
import 'package:flutter_guide/widgets/app_drawer.dart';
import 'package:flutter_guide/widgets/error_widget.dart';
import 'package:flutter_guide/widgets/home_header.dart';
import 'package:flutter_guide/widgets/loading_widget.dart';
import 'package:flutter_guide/widgets/no_result_widget.dart';
import '../models/flutter_interview_model.dart';
import '../models/flutter_notes.dart';
import '../widgets/neumorphic_card.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  Future<FlutterNotes>? _notesFuture;
  Future<FlutterInterview>? _interviewFuture;

  // Search-related state
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  final FocusNode _searchFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _notesFuture = NotesLoaders().loadNotes();
    _interviewFuture = NotesLoaders().loadInterview();

    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.trim().toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFEFF),
      drawer: const AppDrawer(),
     appBar: AppBar(
  backgroundColor: Colors.white,
  elevation: 0,
  toolbarHeight: 90,
  // Remove this line: automaticallyImplyLeading: false,
  title: const Padding(
    padding: EdgeInsets.only(top: 20),
    child: HeaderTitle(),
  ),
  centerTitle: false, // Optional: align title to left if needed
),
      body: Column(
        children: [
          // TabBar
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
              child: Container(
                height: 52,
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: TabBar(
                  controller: _tabController,
                  dividerColor: Colors.transparent,
                  labelColor: Colors.white,
                  unselectedLabelColor: const Color(0xFF4B5563),
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    gradient: const LinearGradient(colors: [Color(0xFF667EEA), Color(0xFF764BA2)]),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF667EEA).withOpacity(0.4),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  labelStyle: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
                  unselectedLabelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  tabs: const [
                    Tab(text: 'Notes'),
                    Tab(text: 'Interview Q&A'),
                  ],
                ),
              ),
            ),
          ),

          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: TextField(
              controller: _searchController,
              focusNode: _searchFocus,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                hintText: 'Search notes & questions...',
                hintStyle: const TextStyle(color: Color(0xFF9CA3AF), fontSize: 16),
                prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFF9CA3AF)),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded),
                        onPressed: () {
                          _searchController.clear();
                          _searchFocus.unfocus();
                        },
                      )
                    : null,
                filled: true,
                fillColor: const Color(0xFFF3F4F6),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 18),
              ),
            ),
          ),

          // TabBarView
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildNotesTab(),
                _buildInterviewTab(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'new_note',
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (ctx)=> FlutterQuizScreen()));
        },
        backgroundColor: const Color(0xFF667EEA),
        foregroundColor: Colors.white,
        elevation: 12,
        hoverElevation: 16,
        icon: const Icon(Icons.play_circle_outlined, size: 28),
        label: const Text('Play Quiz', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildNotesTab() {
    return FutureBuilder<FlutterNotes>(
      future: _notesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CenteredLoadingWidget(message: 'Loading notes...');
        }
        if (snapshot.hasError || !snapshot.hasData) {
          return CenteredErrorWidget(onRetry: () => setState(() => _notesFuture = NotesLoaders().loadNotes()));
        }

        final filteredSections = NotesFilters().filterNotes(snapshot.data!.sections, _searchQuery);

        if (filteredSections.isEmpty && _searchQuery.isNotEmpty) {
          return const NoResultsWidget();
        }

        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 140),
          itemCount: filteredSections.length,
          itemBuilder: (context, index) => NeumorphicCard(
            section: filteredSections[index],
            onTap: () => ShowMethods().showSectionDetails(context, filteredSections[index]),
          ),
        );
      },
    );
  }

  Widget _buildInterviewTab() {
    return FutureBuilder<FlutterInterview>(
      future: _interviewFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CenteredLoadingWidget(message: 'Loading interview questions...');
        }
        if (snapshot.hasError || !snapshot.hasData) {
          return CenteredErrorWidget(onRetry: () => setState(() => _interviewFuture = NotesLoaders().loadInterview()));
        }

        final filteredSections = NotesFilters().filterInterview(snapshot.data!.sections, _searchQuery);

        if (filteredSections.isEmpty && _searchQuery.isNotEmpty) {
          return const NoResultsWidget();
        }

        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 140),
          itemCount: filteredSections.length,
          itemBuilder: (context, index) => NeumorphicCard(
            section: filteredSections[index],
            onTap: () => ShowMethods().showSectionDetails(context, filteredSections[index], isInterview: true),
            isInterview: true,
          ),
        );
      },
    );
  }

  
}