import 'dart:convert';

import 'package:flutter/services.dart';

import 'package:ahmed_rasmy_portfolio/data/models/project.dart';

/// Loads portfolio projects from static JSON (content-as-data).
Future<List<Project>> loadProjects() async {
  final raw = await rootBundle.loadString('assets/content/projects.json');
  final list = jsonDecode(raw) as List<dynamic>;
  return list
      .map((e) => Project.fromJson(e as Map<String, dynamic>))
      .toList();
}

Future<Project?> loadProjectById(String id) async {
  final projects = await loadProjects();
  for (final project in projects) {
    if (project.id == id) return project;
  }
  return null;
}
