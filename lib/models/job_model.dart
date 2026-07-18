import 'dart:convert';

class JobModel {
  final int id;
  final String name;
  final String companyName;
  final String briefing;

  final int minExperience;
  final int maxExperience;

  final int minSalary;
  final int maxSalary;

  final int noOfPositions;
  final int referralAmount;

  final DateTime createdDate;
  final DateTime endDate;

  const JobModel({
    required this.id,
    required this.name,
    required this.companyName,
    required this.briefing,
    required this.minExperience,
    required this.maxExperience,
    required this.minSalary,
    required this.maxSalary,
    required this.noOfPositions,
    required this.referralAmount,
    required this.createdDate,
    required this.endDate,
  });

  static String _parseBriefing(dynamic raw) {
    if (raw == null) return '';

    var value = raw.toString();

    try {
      value = jsonDecode(value);
    } catch (_) {}

    value = value
        .replaceAll(r'\"', '"')
        .replaceAll(r'\\"', '"')
        .replaceAll(r'\\n', '\n')
        .replaceAll(r'\r\n', '\n')
        .replaceAll(r'\n', '\n');

    value = value
        .replaceAll(RegExp(r'\\u00a0', caseSensitive: false), ' ')
        .replaceAll(RegExp(r'&nbsp;?', caseSensitive: false), ' ')
        .replaceAll('\u00C2', '')
        .replaceAll(
      RegExp(r'[\u00A0\u1680\u2000-\u200B\u202F\u205F\u3000\uFEFF]'),
      ' ',
    );

    value = value.trim();

    value = value.replaceFirst(
      RegExp(r'^[\\\"\[\]\s]+'),
      '',
    );

    value = value.replaceFirst(
      RegExp(r'[\\\"\[\]\s]+$'),
      '',
    );

    final bulletPattern = RegExp(r'^\s*[•·\-]\s+');

    final lines = value.split('\n');

    final buffer = StringBuffer();

    bool inList = false;

    for (var rawLine in lines) {
      var line = rawLine.trim();

      line = line
          .replaceAll(RegExp(r'^[\\"]+'), '')
          .replaceAll(RegExp(r'[\\"]+$'), '')
          .trim();

          if (line.isEmpty ||
          line == '"' ||
          line == "'" ||
          line == r'\"' ||
          line == r'\\"') {
        continue;
      }

      final match = bulletPattern.firstMatch(line);

      if (match != null) {
        if (!inList) {
          buffer.write('<ul>');
          inList = true;
        }

        buffer.write(
          '<li>${line.substring(match.end).trim()}</li>',
        );
      } else {
        if (inList) {
          buffer.write('</ul>');
          inList = false;
        }

        buffer.write('<p>$line</p>');
      }
    }

    if (inList) {
      buffer.write('</ul>');
    }

    return buffer.toString();
  }

  factory JobModel.fromJson(Map<String, dynamic> json) {
    return JobModel(
      id: (json['id'] ?? 0).toInt(),
      name: json['name'] ?? '',
      companyName: json['CompanyName'] ?? '',
      briefing: _parseBriefing(json['briefing']),
      minExperience: (json['min_experience'] ?? 0).toInt(),
      maxExperience: (json['max_experience'] ?? 0).toInt(),
      minSalary: (json['min_salary'] ?? 0).toInt(),
      maxSalary: (json['max_salary'] ?? 0).toInt(),
      noOfPositions: (json['no_of_positions'] ?? 0).toInt(),
      referralAmount: (json['referral_amount'] ?? 0).toInt(),
      createdDate:
      DateTime.tryParse(json['created_date'] ?? '') ?? DateTime.now(),
      endDate:
      DateTime.tryParse(json['end_date'] ?? '') ?? DateTime.now(),
    );
  }
}