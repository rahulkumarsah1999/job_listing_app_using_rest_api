import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:intl/intl.dart';

import '../models/job_model.dart';

class JobDetailsScreen extends StatelessWidget {
  final JobModel job;

  const JobDetailsScreen({
    super.key,
    required this.job,
  });

  String formatSalary(int salary) {
    return '${(salary / 100000).toStringAsFixed(0)}L';
  }

  @override
  Widget build(BuildContext context) {
    final cleanedDescription = job.briefing
        .replaceAll(RegExp(r'^\s*"+'), '')
        .replaceAll(RegExp(r'"+\s*$'), '')
        .replaceAll('<p>"</p>', '')
        .replaceAll('<p>" "</p>', '')
        .trim();

    // Temporary debug
    // ignore: avoid_print
    print('HTML => $cleanedDescription');
    return Scaffold(
      appBar: AppBar(
        title: const Text("Job Details"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text(
              job.name,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              job.companyName,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade700,
              ),
            ),

            const SizedBox(height: 24),

            _InfoTile(
              title: "Experience",
              value:
              "${job.minExperience} - ${job.maxExperience} Years",
            ),

            _InfoTile(
              title: "Salary",
              value:
              "₹ ${formatSalary(job.minSalary)} - ${formatSalary(job.maxSalary)}",
            ),

            _InfoTile(
              title: "Open Positions",
              value: job.noOfPositions.toString(),
            ),

            _InfoTile(
              title: "Referral Bonus",
              value: "₹ ${job.referralAmount}",
            ),

            _InfoTile(
              title: 'Company',
              value: job.companyName,
            ),

            _InfoTile(
              title: "Posted On",
              value: DateFormat(
                "dd MMM yyyy",
              ).format(job.createdDate),
            ),

            _InfoTile(
              title: 'Closing Date',
              value: DateFormat('dd MMM yyyy').format(job.endDate),
            ),

            _InfoTile(
              title: 'Job ID',
              value: job.id.toString(),
            ),

            const SizedBox(height: 24),

            const SizedBox(height: 8),

            const Text(
              'Additional Information',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            const Text(
              "Job Description",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Html(
                data: cleanedDescription,
                style: {
                  "body": Style(
                    margin: Margins.zero,
                    padding: HtmlPaddings.zero,
                    fontSize: FontSize(15),
                    lineHeight: LineHeight(1.5),
                    color: Colors.black87,
                    fontFamily: 'Roboto',
                  ),
                  "p": Style(
                    margin: Margins.only(bottom: 10),
                    lineHeight: LineHeight(1.6),
                  ),
                  "li": Style(
                    margin: Margins.only(bottom: 8),
                    lineHeight: LineHeight(1.6),
                  ),
                  "h1": Style(fontSize: FontSize(22)),
                  "h2": Style(fontSize: FontSize(20)),
                  "h3": Style(fontSize: FontSize(18)),
                  "ul": Style(
                    margin: Margins.only(top: 8, bottom: 12),
                  ),
                  "ol": Style(
                    margin: Margins.only(top: 8, bottom: 12),
                  ),
                  "table": Style(
                    backgroundColor: Colors.white,
                  ),
                  "strong": Style(
                    fontWeight: FontWeight.w700,
                  ),
                },
                onLinkTap: (url, attributes, element) {},
                extensions: const [],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final String title;
  final String value;

  const _InfoTile({
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Text(value),
          ),
        ],
      ),
    );
  }
}