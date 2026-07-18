import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/job_model.dart';

class JobService {
  static const String activeUrl =
      'https://api.wraeglobal.com/roleRouter/getActiveRoles';

  static const String archivedUrl =
      'https://api.wraeglobal.com/roleRouter/getArchivedRoles';

  Future<List<JobModel>> getActiveJobs() async {
    final response = await http.get(Uri.parse(activeUrl));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      final List jobs = data['roles'];

      return jobs
          .map((job) => JobModel.fromJson(job))
          .where((job) =>
      job.name.trim().isNotEmpty &&
          job.companyName.trim().isNotEmpty)
          .toList();
    }

    throw Exception('Failed to load active jobs');
  }

  Future<List<JobModel>> getArchivedJobs() async {
    final response = await http.get(Uri.parse(archivedUrl));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      final List jobs = data['roles'];

      return jobs
          .map((job) => JobModel.fromJson(job))
          .where((job) =>
      job.name.trim().isNotEmpty &&
          job.companyName.trim().isNotEmpty)
          .toList();
    }

    throw Exception('Failed to load archived jobs');
  }
}
