import 'package:flutter/material.dart';

class Feature {
  final IconData icon;
  final String title;
  final String routePath;
  final String requiredPlan;
  bool isActive;
  bool isInitiallyLocked;

  Feature({
    required this.icon,
    required this.title,
    required this.routePath,
    required this.requiredPlan,
    this.isActive = false,
    this.isInitiallyLocked = false,
  });
}
