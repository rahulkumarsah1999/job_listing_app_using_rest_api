import 'package:flutter/material.dart';

import 'active_jobs_screen.dart';
import 'archived_jobs_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('BooksApp'),
          centerTitle: true,
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Active Jobs'),
              Tab(text: 'Archived Jobs'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            ActiveJobsScreen(),
            ArchivedJobsScreen(),
          ],
        ),
      ),
    );
  }
}