import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/job_provider.dart';
import '../widgets/job_card.dart';
import '../widgets/custom_search_bar.dart';
import '../widgets/skeleton_job_list.dart';
import 'job_details_screen.dart';

class ActiveJobsScreen extends StatefulWidget {
  const ActiveJobsScreen({super.key});

  @override
  State<ActiveJobsScreen> createState() => _ActiveJobsScreenState();
}

class _ActiveJobsScreenState extends State<ActiveJobsScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<JobProvider>().fetchActiveJobs();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<JobProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const SkeletonJobList();
        }

        if (provider.error != null) {
          return Center(
            child: Text(provider.error!),
          );
        }


        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: CustomSearchBar(
                hintText: 'Search active jobs...',
                onChanged: provider.searchActiveJobs,
              ),
            ),
            Expanded(
              child: provider.filteredActiveJobs.isEmpty
                  ? const Center(
                      child: Text('No jobs found'),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      itemCount: provider.filteredActiveJobs.length,
                      itemBuilder: (context, index) {
                        final job = provider.filteredActiveJobs[index];

                        return JobCard(
                          job: job,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => JobDetailsScreen(job: job),
                              ),
                            );
                          },
                        );
                      },
                    ),
            ),
          ],
        );
      },
    );
  }
}