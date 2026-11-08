import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:ahmed_rasmy_portfolio/app/theme/app_colors.dart';
import 'package:ahmed_rasmy_portfolio/app/theme/app_typography.dart';
import 'package:ahmed_rasmy_portfolio/core/diagrams/diagram_models.dart';
import 'package:ahmed_rasmy_portfolio/features/case_study/widgets/case_layout.dart';

/// Hand-drawn zine diagram: cached layout + scroll draw-in + node highlight.
///
/// Layout is computed in [LayoutBuilder] (never via IntrinsicHeight). Only
/// path draw-progress animates per frame — layout stays cached.
class DiagramView extends StatefulWidget {
  const DiagramView({
    super.key,
    required this.spec,
    this.scrollOffset,
    this.reduceMotion = false,
    this.height = 320,
    this.aspectRatio,
  });

  final DiagramSpec spec;
  final ValueNotifier<double>? scrollOffset;
  final bool reduceMotion;

  /// Fixed height when [aspectRatio] is null.
  final double height;

  /// When set, diagram sizes to width / aspectRatio.
  final double? aspectRatio;

  @override
  State<DiagramView> createState() => _DiagramViewState();
}

class _DiagramViewState extends State<DiagramView> {
  final ValueNotifier<double> _drawProgress = ValueNotifier(0);
  String? _hoverNodeId;
  String? _selectedNodeId;
  _DiagramLayout? _layout;
  Size? _layoutSize;
  bool _rtl = false;
  bool _verticalFlow = false;
  DiagramSpec? _layoutSpec;

  @override
  void initState() {
    super.initState();
    widget.scrollOffset?.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) => _onScroll());
  }

  @override
  void didUpdateWidget(covariant DiagramView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.scrollOffset != widget.scrollOffset) {
      oldWidget.scrollOffset?.removeListener(_onScroll);
      widget.scrollOffset?.addListener(_onScroll);
    }
    if (oldWidget.spec.id != widget.spec.id) {
      _layout = null;
      _layoutSize = null;
      _layoutSpec = null;
      _hoverNodeId = null;
      _selectedNodeId = null;
      _drawProgress.value = widget.reduceMotion ? 1 : 0;
      WidgetsBinding.instance.addPostFrameCallback((_) => _onScroll());
    }
  }

  @override
  void dispose() {
    widget.scrollOffset?.removeListener(_onScroll);
    _drawProgress.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!mounted) return;
    if (widget.reduceMotion) {
      if (_drawProgress.value != 1) _drawProgress.value = 1;
      return;
    }
    final box = context.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize) return;
    final top = box.localToGlobal(Offset.zero).dy;
    final viewH = MediaQuery.sizeOf(context).height;
    final p = ((viewH * 0.88 - top) / (viewH * 0.55)).clamp(0.0, 1.0);
    if ((p - _drawProgress.value).abs() > 0.015) {
      _drawProgress.value = p;
    }
  }

  String? get _activeNodeId => _selectedNodeId ?? _hoverNodeId;

  void _ensureLayout({
    required Size size,
    required bool rtl,
    required bool verticalFlow,
  }) {
    final same = _layout != null &&
        _layoutSize == size &&
        _rtl == rtl &&
        _verticalFlow == verticalFlow &&
        identical(_layoutSpec, widget.spec);
    if (same) return;
    _layoutSize = size;
    _rtl = rtl;
    _verticalFlow = verticalFlow;
    _layoutSpec = widget.spec;
    _layout = _DiagramLayout.compute(
      spec: widget.spec,
      size: size,
      rtl: rtl,
      verticalFlow: verticalFlow,
    );
  }

  Set<String> _connectedEdgeKeys(String? nodeId) {
    if (nodeId == null) return {};
    final keys = <String>{};
    for (final e in widget.spec.edges) {
      if (e.from == nodeId || e.to == nodeId) {
        keys.add('${e.from}->${e.to}');
      }
    }
    return keys;
  }

  Set<String> _relatedNodeIds(String? nodeId) {
    if (nodeId == null) return {};
    final ids = <String>{nodeId};
    for (final e in widget.spec.edges) {
      if (e.from == nodeId) ids.add(e.to);
      if (e.to == nodeId) ids.add(e.from);
    }
    return ids;
  }

  @override
  Widget build(BuildContext context) {
    final arabic = AppTypography.isArabic(context);
    final zine = context.zine;
    final title = widget.spec.title(arabic);
    final footnote = widget.spec.footnote(arabic);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          softWrap: true,
          style: AppTypography.brush(
            context,
            fontSize: 22,
            color: AppColors.flutterBlue,
          ),
        ),
        const SizedBox(height: 12),
        LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth.isFinite
                ? constraints.maxWidth
                : MediaQuery.sizeOf(context).width;
            final height = widget.aspectRatio != null
                ? width / widget.aspectRatio!
                : widget.height;
            final size = Size(width, height);
            final rtl = Directionality.of(context) == TextDirection.rtl;
            final narrow = width < CaseLayout.mobileBreakpoint;
            final verticalFlow = narrow &&
                (widget.spec.kind == DiagramKind.flow ||
                    widget.spec.kind == DiagramKind.architecture);

            _ensureLayout(
              size: size,
              rtl: rtl,
              verticalFlow: verticalFlow,
            );
            final layout = _layout!;
            final active = _activeNodeId;
            final related = _relatedNodeIds(active);
            final hotEdges = _connectedEdgeKeys(active);

            Widget canvas = SizedBox(
              width: width,
              height: height,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: AppColors.paper.withValues(alpha: 0.55),
                        border: Border.all(
                          color: AppColors.paperEdge.withValues(alpha: 0.9),
                          width: 1.2,
                        ),
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: RepaintBoundary(
                      child: ListenableBuilder(
                        listenable: _drawProgress,
                        builder: (context, _) {
                          return CustomPaint(
                            painter: _DiagramPainter(
                              layout: layout,
                              progress: _drawProgress.value,
                              activeNodeId: active,
                              relatedNodeIds: related,
                              hotEdgeKeys: hotEdges,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  ..._edgeLabelOverlays(context, layout, arabic, hotEdges),
                  ..._nodeOverlays(context, layout, arabic, related),
                  if (active != null)
                    _ActorHintBanner(
                      layout: layout,
                      activeNodeId: active,
                      arabic: arabic,
                      edges: widget.spec.edges,
                    ),
                ],
              ),
            );

            if (narrow) {
              canvas = InteractiveViewer(
                minScale: 0.7,
                maxScale: 2.4,
                boundaryMargin: const EdgeInsets.all(48),
                child: canvas,
              );
            }

            return canvas;
          },
        ),
        if (footnote != null) ...[
          const SizedBox(height: 10),
          Text(
            footnote,
            softWrap: true,
            style: AppTypography.body(
              context,
              fontSize: 12,
              color: zine.inkMuted,
            ),
          ),
        ],
      ],
    );
  }

  List<Widget> _nodeOverlays(
    BuildContext context,
    _DiagramLayout layout,
    bool arabic,
    Set<String> related,
  ) {
    return [
      for (final placed in layout.nodes)
        ListenableBuilder(
          listenable: _drawProgress,
          builder: (context, _) {
            final local =
                ((_drawProgress.value - placed.appearAt) / 0.18).clamp(0.0, 1.0);
            if (local <= 0) return const SizedBox.shrink();
            final rect = placed.rect;
            final isActive = _activeNodeId == placed.node.id;
            final dimmed =
                _activeNodeId != null && !related.contains(placed.node.id);
            return Positioned(
              left: rect.left,
              top: rect.top,
              width: rect.width,
              height: rect.height,
              child: Opacity(
                opacity: local * (dimmed ? 0.35 : 1),
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  onEnter: (_) => setState(() => _hoverNodeId = placed.node.id),
                  onExit: (_) {
                    if (_hoverNodeId == placed.node.id) {
                      setState(() => _hoverNodeId = null);
                    }
                  },
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      setState(() {
                        _selectedNodeId = _selectedNodeId == placed.node.id
                            ? null
                            : placed.node.id;
                      });
                    },
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal:
                              placed.node.shape == DiagramNodeShape.diamond
                                  ? 10
                                  : 6,
                          vertical: 4,
                        ),
                        child: Text(
                          placed.node.label(arabic),
                          textAlign: TextAlign.center,
                          softWrap: true,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.label(
                            context,
                            fontSize:
                                placed.node.shape == DiagramNodeShape.startDot
                                    ? 9
                                    : 10,
                            color: isActive
                                ? AppColors.flutterBlue
                                : AppColors.navyInk,
                            letterSpacing: arabic ? 0 : 0.6,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
    ];
  }

  List<Widget> _edgeLabelOverlays(
    BuildContext context,
    _DiagramLayout layout,
    bool arabic,
    Set<String> hotEdges,
  ) {
    return [
      for (final edge in layout.edges)
        if (edge.edge.label(arabic) != null)
          ListenableBuilder(
            listenable: _drawProgress,
            builder: (context, _) {
              final local =
                  ((_drawProgress.value - edge.appearAt) / 0.22).clamp(0.0, 1.0);
              if (local < 0.55) return const SizedBox.shrink();
              final key = '${edge.edge.from}->${edge.edge.to}';
              final hot = hotEdges.contains(key);
              final dimmed = _activeNodeId != null && !hot;
              final label = edge.edge.label(arabic)!;
              return Positioned(
                left: (edge.midpoint.dx - 48)
                    .clamp(0.0, layout.size.width - 96)
                    .toDouble(),
                top: (edge.midpoint.dy - 10)
                    .clamp(0.0, layout.size.height - 20)
                    .toDouble(),
                width: 96,
                child: Opacity(
                  opacity: local * (dimmed ? 0.25 : 1),
                  child: Text(
                    label,
                    textAlign: TextAlign.center,
                    softWrap: true,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.label(
                      context,
                      fontSize: 8,
                      color: hot
                          ? AppColors.flutterLightBlue
                          : AppColors.navyInk.withValues(alpha: 0.7),
                      letterSpacing: arabic ? 0 : 0.5,
                    ),
                  ),
                ),
              );
            },
          ),
    ];
  }
}

class _ActorHintBanner extends StatelessWidget {
  const _ActorHintBanner({
    required this.layout,
    required this.activeNodeId,
    required this.arabic,
    required this.edges,
  });

  final _DiagramLayout layout;
  final String activeNodeId;
  final bool arabic;
  final List<DiagramEdge> edges;

  @override
  Widget build(BuildContext context) {
    final actors = <String>{};
    for (final e in edges) {
      if (e.from != activeNodeId && e.to != activeNodeId) continue;
      final actor = e.highlightActor(arabic);
      if (actor != null) actors.add(actor);
    }
    if (actors.isEmpty) return const SizedBox.shrink();

    _PlacedNode? placed;
    for (final n in layout.nodes) {
      if (n.node.id == activeNodeId) {
        placed = n;
        break;
      }
    }
    if (placed == null) return const SizedBox.shrink();

    final text = actors.join(' · ');
    final top =
        (placed.rect.bottom + 6).clamp(0.0, layout.size.height - 28).toDouble();
    final left = placed.rect.left
        .clamp(0.0, math.max(0.0, layout.size.width - 180))
        .toDouble();

    return Positioned(
      left: left,
      top: top,
      width: math.min(220.0, layout.size.width - left),
      child: Text(
        text,
        softWrap: true,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: AppTypography.label(
          context,
          fontSize: 9,
          color: AppColors.flutterLightBlue,
          letterSpacing: arabic ? 0 : 0.8,
        ),
      ),
    );
  }
}

class _PlacedNode {
  const _PlacedNode({
    required this.node,
    required this.center,
    required this.rect,
    required this.appearAt,
  });

  final DiagramNode node;
  final Offset center;
  final Rect rect;
  final double appearAt;
}

class _PlacedEdge {
  const _PlacedEdge({
    required this.edge,
    required this.path,
    required this.midpoint,
    required this.appearAt,
  });

  final DiagramEdge edge;
  final Path path;
  final Offset midpoint;
  final double appearAt;
}

class _DiagramLayout {
  const _DiagramLayout({
    required this.size,
    required this.nodes,
    required this.edges,
  });

  final Size size;
  final List<_PlacedNode> nodes;
  final List<_PlacedEdge> edges;

  static _DiagramLayout compute({
    required DiagramSpec spec,
    required Size size,
    required bool rtl,
    required bool verticalFlow,
  }) {
    final pad = EdgeInsets.fromLTRB(
      size.width * 0.04,
      size.height * 0.06,
      size.width * 0.04,
      size.height * 0.08,
    );
    final area = Rect.fromLTRB(
      pad.left,
      pad.top,
      size.width - pad.right,
      size.height - pad.bottom,
    );

    final centers = switch (spec.kind) {
      DiagramKind.flow => _layoutFlow(
          spec: spec,
          area: area,
          vertical: verticalFlow,
          rtl: rtl,
        ),
      DiagramKind.architecture =>
        _layoutArchitecture(spec: spec, area: area, rtl: rtl),
      DiagramKind.erd => _layoutErd(spec: spec, area: area, rtl: rtl),
      DiagramKind.stateMachine =>
        _layoutStateMachine(spec: spec, area: area, rtl: rtl),
    };

    final nodeById = {for (final n in spec.nodes) n.id: n};
    final orderIndex = <String, int>{};
    for (var i = 0; i < spec.nodes.length; i++) {
      orderIndex[spec.nodes[i].id] = i;
    }

    final placedNodes = <_PlacedNode>[];
    for (final entry in centers.entries) {
      final node = nodeById[entry.key];
      if (node == null) continue;
      final dim = _nodeSize(node, area);
      final rect = Rect.fromCenter(
        center: entry.value,
        width: dim.width,
        height: dim.height,
      );
      final appear = (orderIndex[node.id] ?? 0) /
          math.max(1, spec.nodes.length + spec.edges.length);
      placedNodes.add(
        _PlacedNode(
          node: node,
          center: entry.value,
          rect: rect,
          appearAt: appear * 0.55,
        ),
      );
    }

    final placedById = {for (final p in placedNodes) p.node.id: p};
    final placedEdges = <_PlacedEdge>[];
    for (var i = 0; i < spec.edges.length; i++) {
      final e = spec.edges[i];
      final from = placedById[e.from];
      final to = placedById[e.to];
      if (from == null || to == null) continue;
      final path = _edgePath(from, to);
      Offset mid = Offset.lerp(from.center, to.center, 0.5)!;
      for (final metric in path.computeMetrics()) {
        final t = metric.getTangentForOffset(metric.length * 0.5);
        if (t != null) mid = t.position;
        break;
      }
      placedEdges.add(
        _PlacedEdge(
          edge: e,
          path: path,
          midpoint: mid,
          appearAt: 0.2 + (i / math.max(1, spec.edges.length)) * 0.55,
        ),
      );
    }

    return _DiagramLayout(size: size, nodes: placedNodes, edges: placedEdges);
  }

  static Size _nodeSize(DiagramNode node, Rect area) {
    switch (node.shape) {
      case DiagramNodeShape.startDot:
        return const Size(36, 36);
      case DiagramNodeShape.circle:
        final s = math.min(area.width, area.height) * 0.11;
        return Size(s.clamp(44.0, 72.0), s.clamp(44.0, 72.0));
      case DiagramNodeShape.diamond:
        return Size(
          (area.width * 0.16).clamp(72.0, 120.0),
          (area.height * 0.2).clamp(56.0, 88.0),
        );
      case DiagramNodeShape.rect:
      case DiagramNodeShape.rounded:
        return Size(
          (area.width * 0.18).clamp(78.0, 140.0),
          (area.height * 0.16).clamp(40.0, 64.0),
        );
    }
  }

  static Offset _mirrorX(Offset n, bool rtl) =>
      rtl ? Offset(1 - n.dx, n.dy) : n;

  static Map<String, Offset> _layoutFlow({
    required DiagramSpec spec,
    required Rect area,
    required bool vertical,
    required bool rtl,
  }) {
    final withPreferred = <String, Offset>{};
    var preferredCount = 0;
    for (final n in spec.nodes) {
      if (n.preferred != null) {
        preferredCount++;
        final p = _mirrorX(n.preferred!, rtl);
        withPreferred[n.id] = Offset(
          area.left + p.dx * area.width,
          area.top + p.dy * area.height,
        );
      }
    }
    if (preferredCount == spec.nodes.length && preferredCount > 0) {
      return withPreferred;
    }

    final ids = spec.nodes.map((n) => n.id).toList();
    final outgoing = <String, List<String>>{for (final id in ids) id: []};
    final indegree = <String, int>{for (final id in ids) id: 0};
    for (final e in spec.edges) {
      if (!outgoing.containsKey(e.from) || !indegree.containsKey(e.to)) {
        continue;
      }
      outgoing[e.from]!.add(e.to);
      indegree[e.to] = indegree[e.to]! + 1;
    }

    final layers = <List<String>>[];
    var frontier = ids.where((id) => indegree[id] == 0).toList();
    if (frontier.isEmpty && ids.isNotEmpty) frontier = [ids.first];
    final placed = <String>{};
    while (frontier.isNotEmpty) {
      layers.add(List.of(frontier));
      placed.addAll(frontier);
      final next = <String>[];
      for (final id in frontier) {
        for (final to in outgoing[id]!) {
          if (placed.contains(to) || next.contains(to)) continue;
          final parentsLeft = spec.edges
              .where((e) => e.to == to && !placed.contains(e.from))
              .length;
          if (parentsLeft == 0) next.add(to);
        }
      }
      if (next.isEmpty) {
        final rest = ids.where((id) => !placed.contains(id)).toList();
        if (rest.isEmpty) break;
        layers.add(rest);
        break;
      }
      frontier = next;
    }

    final result = <String, Offset>{...withPreferred};
    final layerCount = math.max(1, layers.length);
    for (var li = 0; li < layers.length; li++) {
      final layer = layers[li];
      final crossCount = math.max(1, layer.length);
      for (var ci = 0; ci < layer.length; ci++) {
        final id = layer[ci];
        if (result.containsKey(id)) continue;
        final nx = vertical ? (ci + 0.5) / crossCount : (li + 0.5) / layerCount;
        final ny = vertical ? (li + 0.5) / layerCount : (ci + 0.5) / crossCount;
        final p = _mirrorX(Offset(nx, ny), rtl);
        result[id] = Offset(
          area.left + p.dx * area.width,
          area.top + p.dy * area.height,
        );
      }
    }
    return result;
  }

  static Map<String, Offset> _layoutArchitecture({
    required DiagramSpec spec,
    required Rect area,
    required bool rtl,
  }) {
    final result = <String, Offset>{};
    final sorted = List<DiagramNode>.of(spec.nodes)
      ..sort((a, b) {
        final ay = a.preferred?.dy ?? spec.nodes.indexOf(a).toDouble();
        final by = b.preferred?.dy ?? spec.nodes.indexOf(b).toDouble();
        return ay.compareTo(by);
      });

    final bands = <int, List<DiagramNode>>{};
    for (var i = 0; i < sorted.length; i++) {
      final n = sorted[i];
      final band = n.preferred != null
          ? (n.preferred!.dy * 6).round().clamp(0, 6)
          : i;
      bands.putIfAbsent(band, () => []).add(n);
    }
    final keys = bands.keys.toList()..sort();
    final bandCount = math.max(1, keys.length);
    for (var bi = 0; bi < keys.length; bi++) {
      final layer = bands[keys[bi]]!;
      for (var ci = 0; ci < layer.length; ci++) {
        final n = layer[ci];
        final nx = n.preferred?.dx ?? ((ci + 0.5) / layer.length);
        final ny = (bi + 0.5) / bandCount;
        final p = _mirrorX(Offset(nx, ny), rtl);
        result[n.id] = Offset(
          area.left + p.dx * area.width,
          area.top + p.dy * area.height,
        );
      }
    }
    return result;
  }

  static Map<String, Offset> _layoutErd({
    required DiagramSpec spec,
    required Rect area,
    required bool rtl,
  }) {
    final result = <String, Offset>{};
    final n = spec.nodes.length;
    final cols = math.max(1, math.sqrt(n.toDouble()).ceil());
    final rows = math.max(1, (n / cols).ceil());
    for (var i = 0; i < n; i++) {
      final node = spec.nodes[i];
      if (node.preferred != null) {
        final p = _mirrorX(node.preferred!, rtl);
        result[node.id] = Offset(
          area.left + p.dx * area.width,
          area.top + p.dy * area.height,
        );
        continue;
      }
      final col = i % cols;
      final row = i ~/ cols;
      final p = _mirrorX(
        Offset((col + 0.5) / cols, (row + 0.5) / rows),
        rtl,
      );
      result[node.id] = Offset(
        area.left + p.dx * area.width,
        area.top + p.dy * area.height,
      );
    }
    return result;
  }

  static Map<String, Offset> _layoutStateMachine({
    required DiagramSpec spec,
    required Rect area,
    required bool rtl,
  }) {
    final result = <String, Offset>{};
    DiagramNode? start;
    for (final n in spec.nodes) {
      if (n.shape == DiagramNodeShape.startDot) {
        start = n;
        break;
      }
    }
    start ??= spec.nodes.isNotEmpty ? spec.nodes.first : null;
    if (start == null) return result;

    var allPreferred = true;
    for (final n in spec.nodes) {
      if (n.preferred == null) {
        allPreferred = false;
        break;
      }
    }
    if (allPreferred) {
      for (final n in spec.nodes) {
        final p = _mirrorX(n.preferred!, rtl);
        result[n.id] = Offset(
          area.left + p.dx * area.width,
          area.top + p.dy * area.height,
        );
      }
      return result;
    }

    final dist = <String, int>{start.id: 0};
    final q = <String>[start.id];
    final out = <String, List<String>>{
      for (final n in spec.nodes) n.id: [],
    };
    for (final e in spec.edges) {
      out[e.from]?.add(e.to);
    }
    while (q.isNotEmpty) {
      final id = q.removeAt(0);
      for (final to in out[id] ?? const <String>[]) {
        if (dist.containsKey(to)) continue;
        dist[to] = dist[id]! + 1;
        q.add(to);
      }
    }
    for (final n in spec.nodes) {
      dist.putIfAbsent(n.id, () => 1);
    }

    final byRing = <int, List<String>>{};
    for (final e in dist.entries) {
      byRing.putIfAbsent(e.value, () => []).add(e.key);
    }

    final cx = area.left + area.width * 0.5;
    final cy = area.top + area.height * 0.12;
    result[start.id] = Offset(cx, cy);

    final maxRing = byRing.keys.fold<int>(0, math.max);
    for (final ring in byRing.keys) {
      if (ring == 0) continue;
      final ids = byRing[ring]!;
      final radius =
          area.shortestSide * (0.22 + 0.28 * (ring / math.max(1, maxRing)));
      for (var i = 0; i < ids.length; i++) {
        final t = (i + 0.5) / ids.length;
        final angle = -math.pi * 0.15 + t * math.pi * 1.3;
        var x = cx + math.cos(angle) * radius * (rtl ? -1 : 1);
        final y = cy + math.sin(angle).abs() * radius + area.height * 0.08;
        x = x.clamp(area.left + 24, area.right - 24);
        result[ids[i]] =
            Offset(x, y.clamp(area.top + 24, area.bottom - 24));
      }
    }
    return result;
  }

  static Path _edgePath(_PlacedNode from, _PlacedNode to) {
    final a = _borderPoint(from, to.center);
    final b = _borderPoint(to, from.center);
    final mid = Offset.lerp(a, b, 0.5)!;
    final dx = b.dx - a.dx;
    final dy = b.dy - a.dy;
    final len = math.sqrt(dx * dx + dy * dy).clamp(1.0, double.infinity);
    final nx = -dy / len;
    final ny = dx / len;
    final bow = (len * 0.08).clamp(6.0, 28.0) *
        (from.node.id.hashCode.isEven ? 1 : -1);
    final ctrl = mid + Offset(nx * bow, ny * bow);
    return Path()
      ..moveTo(a.dx, a.dy)
      ..quadraticBezierTo(ctrl.dx, ctrl.dy, b.dx, b.dy);
  }

  static Offset _borderPoint(_PlacedNode placed, Offset toward) {
    final c = placed.center;
    final v = toward - c;
    final len = v.distance;
    if (len < 0.001) return c;
    final dir = v / len;
    switch (placed.node.shape) {
      case DiagramNodeShape.startDot:
      case DiagramNodeShape.circle:
        return c + dir * (placed.rect.shortestSide * 0.5);
      case DiagramNodeShape.diamond:
        final hw = placed.rect.width * 0.5;
        final hh = placed.rect.height * 0.5;
        final t = 1 /
            (dir.dx.abs() / hw + dir.dy.abs() / hh)
                .clamp(0.001, double.infinity);
        return c + dir * t;
      case DiagramNodeShape.rect:
      case DiagramNodeShape.rounded:
        final hw = placed.rect.width * 0.5;
        final hh = placed.rect.height * 0.5;
        final sx = dir.dx == 0 ? double.infinity : hw / dir.dx.abs();
        final sy = dir.dy == 0 ? double.infinity : hh / dir.dy.abs();
        return c + dir * math.min(sx, sy);
    }
  }
}

class _DiagramPainter extends CustomPainter {
  _DiagramPainter({
    required this.layout,
    required this.progress,
    required this.activeNodeId,
    required this.relatedNodeIds,
    required this.hotEdgeKeys,
  });

  final _DiagramLayout layout;
  final double progress;
  final String? activeNodeId;
  final Set<String> relatedNodeIds;
  final Set<String> hotEdgeKeys;

  @override
  void paint(Canvas canvas, Size size) {
    _paintPaperGrain(canvas, size);
    for (final edge in layout.edges) {
      _paintEdge(canvas, edge);
    }
    for (final node in layout.nodes) {
      _paintNode(canvas, node);
    }
  }

  void _paintPaperGrain(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.flutterBlue.withValues(alpha: 0.03)
      ..strokeWidth = 1;
    for (var i = 0; i < 12; i++) {
      final y = size.height * ((i + 1) / 13);
      canvas.drawLine(Offset(8, y), Offset(size.width - 8, y), paint);
    }
  }

  void _paintEdge(Canvas canvas, _PlacedEdge edge) {
    final local = ((progress - edge.appearAt) / 0.22).clamp(0.0, 1.0);
    if (local <= 0) return;

    final key = '${edge.edge.from}->${edge.edge.to}';
    final hot = hotEdgeKeys.contains(key);
    final dimmed = activeNodeId != null && !hot;

    final paint = Paint()
      ..color = (hot ? AppColors.flutterLightBlue : AppColors.flutterBlue)
          .withValues(alpha: (dimmed ? 0.16 : 0.78) * local)
      ..style = PaintingStyle.stroke
      ..strokeWidth = hot ? 2.4 : 1.6
      ..strokeCap = StrokeCap.round;

    for (final metric in edge.path.computeMetrics()) {
      final extract = metric.extractPath(0, metric.length * local);
      canvas.drawPath(extract, paint);
      if (local > 0.85) {
        final tangent =
            metric.getTangentForOffset(metric.length * local.clamp(0.0, 1.0));
        if (tangent != null) {
          _drawArrowHead(canvas, tangent.position, tangent.vector, paint);
        }
      }
    }

    if (hot && local > 0.5) {
      canvas.drawCircle(
        edge.midpoint,
        2.5,
        Paint()..color = AppColors.flutterLightBlue.withValues(alpha: 0.9),
      );
    }
  }

  void _drawArrowHead(Canvas canvas, Offset tip, Offset direction, Paint paint) {
    final len = direction.distance;
    if (len < 0.001) return;
    final dir = direction / len;
    final left = tip - dir * 9 + Offset(-dir.dy, dir.dx) * 5;
    final right = tip - dir * 9 + Offset(dir.dy, -dir.dx) * 5;
    canvas.drawLine(tip, left, paint);
    canvas.drawLine(tip, right, paint);
  }

  void _paintNode(Canvas canvas, _PlacedNode placed) {
    final local = ((progress - placed.appearAt) / 0.2).clamp(0.0, 1.0);
    if (local <= 0) return;

    final active = activeNodeId == placed.node.id;
    final related =
        activeNodeId == null || relatedNodeIds.contains(placed.node.id);
    final fade = related ? 1.0 : 0.28;

    final fill = Paint()
      ..color = AppColors.paper.withValues(alpha: 0.92 * local * fade)
      ..style = PaintingStyle.fill;
    final outline = Paint()
      ..color = (active ? AppColors.flutterLightBlue : AppColors.flutterBlue)
          .withValues(alpha: 0.9 * local * fade)
      ..style = PaintingStyle.stroke
      ..strokeWidth = active ? 2.2 : 1.5
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = _shapePath(placed);
    canvas.drawPath(path, fill);
    for (final metric in path.computeMetrics()) {
      canvas.drawPath(metric.extractPath(0, metric.length * local), outline);
    }

    if (placed.node.shape == DiagramNodeShape.startDot) {
      canvas.drawCircle(
        placed.center,
        5 * local,
        Paint()
          ..color = AppColors.flutterLightBlue.withValues(alpha: 0.95 * fade),
      );
    }
  }

  Path _shapePath(_PlacedNode placed) {
    final r = placed.rect;
    const wobble = 1.2;
    switch (placed.node.shape) {
      case DiagramNodeShape.startDot:
      case DiagramNodeShape.circle:
        return Path()
          ..addOval(
            Rect.fromCenter(
              center: placed.center,
              width: r.width,
              height: r.height,
            ),
          );
      case DiagramNodeShape.diamond:
        return Path()
          ..moveTo(r.center.dx, r.top + wobble)
          ..lineTo(r.right - wobble, r.center.dy)
          ..lineTo(r.center.dx, r.bottom - wobble)
          ..lineTo(r.left + wobble, r.center.dy)
          ..close();
      case DiagramNodeShape.rect:
        return Path()..addRect(r.deflate(0.5));
      case DiagramNodeShape.rounded:
        return Path()
          ..addRRect(RRect.fromRectAndRadius(r, const Radius.circular(8)));
    }
  }

  @override
  bool shouldRepaint(covariant _DiagramPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.activeNodeId != activeNodeId ||
        oldDelegate.layout != layout ||
        oldDelegate.relatedNodeIds != relatedNodeIds ||
        oldDelegate.hotEdgeKeys != hotEdgeKeys;
  }
}
