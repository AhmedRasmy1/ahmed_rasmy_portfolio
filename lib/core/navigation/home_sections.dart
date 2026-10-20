import 'package:flutter/material.dart';

/// Home scroll sections (sticky nav + SCROLL TO VIEW targets).
enum HomeSection {
  work,
  about,
  experience,
  skills,
  education,
  contact,
}

extension HomeSectionX on HomeSection {
  String get id => name;

  String get numberLabel => switch (this) {
        HomeSection.work => '01',
        HomeSection.about => '02',
        HomeSection.experience => '03',
        HomeSection.skills => '04',
        HomeSection.education => '05',
        HomeSection.contact => '06',
      };
}

abstract final class HomeSectionKeys {
  static final Map<HomeSection, GlobalKey> keys = {
    for (final s in HomeSection.values) s: GlobalKey(debugLabel: s.id),
  };

  static GlobalKey key(HomeSection section) => keys[section]!;

  static Future<void> scrollTo(
    HomeSection section, {
    Duration duration = const Duration(milliseconds: 800),
  }) async {
    final ctx = keys[section]?.currentContext;
    if (ctx == null) return;
    await Scrollable.ensureVisible(
      ctx,
      duration: duration,
      curve: Curves.easeInOutCubic,
      alignment: 0.08,
    );
  }

  /// Section whose top is nearest just under the sticky nav band.
  static HomeSection? activeFromScroll(BuildContext context) {
    final viewH = MediaQuery.sizeOf(context).height;
    HomeSection? best;
    var bestScore = double.infinity;
    for (final section in HomeSection.values) {
      final ctx = keys[section]?.currentContext;
      if (ctx == null) continue;
      final box = ctx.findRenderObject() as RenderBox?;
      if (box == null || !box.hasSize) continue;
      final dy = box.localToGlobal(Offset.zero).dy;
      if (dy > viewH * 0.55) continue;
      final score = (dy - 96).abs();
      if (score < bestScore) {
        bestScore = score;
        best = section;
      }
    }
    return best;
  }
}
