import 'package:flutter/material.dart';

/// Visual / layout strategy for a diagram.
enum DiagramKind { flow, architecture, erd, stateMachine }

/// Node outline style for the hand-drawn painter.
enum DiagramNodeShape { rect, rounded, diamond, circle, startDot }

@immutable
class DiagramNode {
  const DiagramNode({
    required this.id,
    required this.labelEn,
    required this.labelAr,
    this.preferred,
    this.shape = DiagramNodeShape.rounded,
  });

  final String id;
  final String labelEn;
  final String labelAr;

  /// Optional normalized layout hint in 0–1 space (x, y).
  final Offset? preferred;
  final DiagramNodeShape shape;

  String label(bool arabic) => arabic ? labelAr : labelEn;
}

@immutable
class DiagramEdge {
  const DiagramEdge({
    required this.from,
    required this.to,
    this.labelEn,
    this.labelAr,
    this.highlightActorEn,
    this.highlightActorAr,
  });

  final String from;
  final String to;
  final String? labelEn;
  final String? labelAr;

  /// Who can trigger this transition (e.g. "host") — shown on highlight.
  final String? highlightActorEn;
  final String? highlightActorAr;

  String? label(bool arabic) {
    final value = arabic ? labelAr : labelEn;
    if (value == null || value.isEmpty) return null;
    return value;
  }

  String? highlightActor(bool arabic) {
    final value = arabic ? highlightActorAr : highlightActorEn;
    if (value == null || value.isEmpty) return null;
    return value;
  }
}

@immutable
class DiagramSpec {
  const DiagramSpec({
    required this.id,
    required this.titleEn,
    required this.titleAr,
    required this.kind,
    required this.nodes,
    required this.edges,
    this.footnoteEn,
    this.footnoteAr,
  });

  final String id;
  final String titleEn;
  final String titleAr;
  final DiagramKind kind;
  final List<DiagramNode> nodes;
  final List<DiagramEdge> edges;
  final String? footnoteEn;
  final String? footnoteAr;

  String title(bool arabic) => arabic ? titleAr : titleEn;

  String? footnote(bool arabic) {
    final value = arabic ? footnoteAr : footnoteEn;
    if (value == null || value.isEmpty) return null;
    return value;
  }

  DiagramNode? nodeById(String id) {
    for (final n in nodes) {
      if (n.id == id) return n;
    }
    return null;
  }
}
