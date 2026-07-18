import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/job_provider.dart';
import '../widgets/job_card.dart';
import '../widgets/custom_search_bar.dart';
import '../widgets/skeleton_job_list.dart';
import 'job_details_screen.dart';

class ArchivedJobsScreen extends StatefulWidget {
  const ArchivedJobsScreen({super.key});

  @override
  State<ArchivedJobsScreen> createState() => _ArchivedJobsScreenState();
}

class _ArchivedJobsScreenState extends State<ArchivedJobsScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<JobProvider>().fetchArchivedJobs();
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
                hintText: 'Search archived jobs...',
                onChanged: provider.searchArchivedJobs,
              ),
            ),
            Expanded(
              child: provider.filteredArchivedJobs.isEmpty
                  ? const Center(
                      child: Text('No jobs found'),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      itemCount: provider.filteredArchivedJobs.length,
                      itemBuilder: (context, index) {
                        final job = provider.filteredArchivedJobs[index];
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