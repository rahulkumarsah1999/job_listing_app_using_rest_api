import 'package:flutter/material.dart';

import '../models/job_model.dart';
import '../services/job_service.dart';

class JobProvider extends ChangeNotifier {
  final JobService _jobService = JobService();

  bool isLoading = false;
  String? error;

  List<JobModel> activeJobs = [];
  List<JobModel> archivedJobs = [];

  List<JobModel> filteredActiveJobs = [];
  List<JobModel> filteredArchivedJobs = [];

  Future<void> fetchActiveJobs() async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();

      activeJobs = await _jobService.getActiveJobs();
      filteredActiveJobs = List.from(activeJobs);
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchArchivedJobs() async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();

      archivedJobs = await _jobService.getArchivedJobs();
      filteredArchivedJobs = List.from(archivedJobs);
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void searchActiveJobs(String query) {
    final q = query.trim().toLowerCase();

    if (q.isEmpty) {
      filteredActiveJobs = List.from(activeJobs);
    } else {
      filteredActiveJobs = activeJobs.where((job) {
        return job.name.toLowerCase().contains(q) ||
            job.companyName.toLowerCase().contains(q);
      }).toList();
    }

    notifyListeners();
  }

  void searchArchivedJobs(String query) {
    final q = query.trim().toLowerCase();

    if (q.isEmpty) {
      filteredArchivedJobs = List.from(archivedJobs);
    } else {
      filteredArchivedJobs = archivedJobs.where((job) {
        return job.name.toLowerCase().contains(q) ||
            job.companyName.toLowerCase().contains(q);
      }).toList();
    }

    notifyListeners();
  }
}
