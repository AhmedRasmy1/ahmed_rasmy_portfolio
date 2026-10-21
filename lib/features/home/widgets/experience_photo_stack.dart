import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:ahmed_rasmy_portfolio/app/theme/app_colors.dart';
import 'package:ahmed_rasmy_portfolio/core/cursor/custom_cursor_overlay.dart';
import 'package:ahmed_rasmy_portfolio/core/painters/tape_painter.dart';
import 'package:ahmed_rasmy_portfolio/core/utils/asset_checker.dart';
import 'package:ahmed_rasmy_portfolio/core/widgets/safe_asset_image.dart';

/// Stacked taped polaroids. Fans on hover; opens lightbox on tap.
class ExperiencePhotoStack extends StatefulWidget {
  const ExperiencePhotoStack({
    super.key,
    required this.photos,
    this.customCursor = false,
    this.reduceMotion = false,
  });

  final List<String> photos;
  final bool customCursor;
  final bool reduceMotion;

  @override
  State<ExperiencePhotoStack> createState() => _ExperiencePhotoStackState();
}

class _ExperiencePhotoStackState extends State<ExperiencePhotoStack> {
  bool _hover = false;

  static const _tilts = [-0.06, 0.045, -0.03];
  static const _tapes = [
    Color(0xE613B9FD),
    Color(0xE6E8C96A),
    Color(0xE6A8C8E0),
  ];

  List<String> get _visible =>
      AssetChecker.existing(widget.photos).take(3).toList();

  void _openLightbox(int index) {
    final photos = _visible;
    if (photos.isEmpty) return;
    showGeneralDialog<void>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Close',
      barrierColor: Colors.black.withValues(alpha: 0.88),
      transitionDuration: const Duration(milliseconds: 280),
      pageBuilder: (context, anim, _) {
        return _PhotoLightbox(
          photos: photos,
          initialIndex: index.clamp(0, photos.length - 1),
        );
      },
      transitionBuilder: (context, anim, _, child) {
        final curved = CurvedAnimation(parent: anim, curve: Curves.easeOutCubic);
        return FadeTransition(
          opacity: curved,
          child: ScaleTransition(
            scale: Tween(begin: 0.94, end: 1.0).animate(curved),
            child: child,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final show = _visible;
    if (show.isEmpty) return const SizedBox.shrink();

    final dpr = MediaQuery.devicePixelRatioOf(context);
    final cacheW = (140 * dpr * 2).round().clamp(280, 800);

    return CursorTarget(
      enabled: widget.customCursor,
      label: 'VIEW',
      child: MouseRegion(
        onEnter: (_) => setState(() => _hover = true),
        onExit: (_) => setState(() => _hover = false),
        child: GestureDetector(
          onTap: () => _openLightbox(0),
          child: SizedBox(
            width: 150,
            height: 170,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                for (var i = 0; i < show.length; i++)
                  AnimatedPositioned(
                    duration: Duration(
                      milliseconds: widget.reduceMotion ? 0 : 280,
                    ),
                    curve: Curves.easeOutCubic,
                    left: _hover ? i * 28.0 : i * 10.0,
                    top: _hover ? i * 8.0 : i * 12.0,
                    child: Transform.rotate(
                      angle: _hover ? _tilts[i] * 1.6 : _tilts[i],
                      child: _MiniPolaroid(
                        path: show[i],
                        tape: _tapes[i % _tapes.length],
                        cacheWidth: cacheW,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MiniPolaroid extends StatelessWidget {
  const _MiniPolaroid({
    required this.path,
    required this.tape,
    required this.cacheWidth,
  });

  final String path;
  final Color tape;
  final int cacheWidth;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 112,
          padding: const EdgeInsets.fromLTRB(6, 8, 6, 10),
          decoration: BoxDecoration(
            color: AppColors.offWhite,
            boxShadow: [
              BoxShadow(
                color: AppColors.navyInk.withValues(alpha: 0.2),
                blurRadius: 10,
                offset: const Offset(1, 4),
              ),
            ],
          ),
          child: AspectRatio(
            aspectRatio: 1,
            child: SafeAssetImage(
              assetPath: path,
              fit: BoxFit.cover,
              filterQuality: FilterQuality.high,
              cacheWidth: cacheWidth,
              showDebugPlaceholder: false,
            ),
          ),
        ),
        Positioned(
          top: -7,
          left: 0,
          right: 0,
          child: Center(
            child: TapeStrip(color: tape, width: 44, height: 12),
          ),
        ),
      ],
    );
  }
}

class _PhotoLightbox extends StatefulWidget {
  const _PhotoLightbox({
    required this.photos,
    required this.initialIndex,
  });

  final List<String> photos;
  final int initialIndex;

  @override
  State<_PhotoLightbox> createState() => _PhotoLightboxState();
}

class _PhotoLightboxState extends State<_PhotoLightbox> {
  late final PageController _page;
  late int _index;
  final _focus = FocusNode();

  @override
  void initState() {
    super.initState();
    _index = widget.initialIndex;
    _page = PageController(initialPage: _index);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focus.requestFocus();
    });
  }

  @override
  void dispose() {
    _focus.dispose();
    _page.dispose();
    super.dispose();
  }

  void _go(int delta) {
    final next = (_index + delta).clamp(0, widget.photos.length - 1);
    if (next == _index) return;
    _page.animateToPage(
      next,
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: _focus,
      autofocus: true,
      onKeyEvent: (event) {
        if (event is! KeyDownEvent) return;
        if (event.logicalKey == LogicalKeyboardKey.escape) {
          Navigator.of(context).maybePop();
        } else if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
          _go(-1);
        } else if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
          _go(1);
        }
      },
      child: GestureDetector(
        onTap: () => Navigator.of(context).maybePop(),
        child: Material(
          color: Colors.transparent,
          child: SafeArea(
            child: Stack(
              children: [
                PageView.builder(
                  controller: _page,
                  itemCount: widget.photos.length,
                  onPageChanged: (i) => setState(() => _index = i),
                  itemBuilder: (context, i) {
                    return Center(
                      child: GestureDetector(
                        onTap: () {}, // absorb
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth: MediaQuery.sizeOf(context).width * 0.92,
                              maxHeight:
                                  MediaQuery.sizeOf(context).height * 0.85,
                            ),
                            child: InteractiveViewer(
                              minScale: 0.8,
                              maxScale: 4,
                              child: SafeAssetImage(
                                assetPath: widget.photos[i],
                                fit: BoxFit.contain,
                                filterQuality: FilterQuality.high,
                                showDebugPlaceholder: false,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                if (widget.photos.length > 1) ...[
                  Positioned(
                    left: 8,
                    top: 0,
                    bottom: 0,
                    child: Center(
                      child: IconButton(
                        onPressed: () => _go(-1),
                        icon: const Icon(Icons.chevron_left, size: 36),
                        color: AppColors.offWhite,
                      ),
                    ),
                  ),
                  Positioned(
                    right: 8,
                    top: 0,
                    bottom: 0,
                    child: Center(
                      child: IconButton(
                        onPressed: () => _go(1),
                        icon: const Icon(Icons.chevron_right, size: 36),
                        color: AppColors.offWhite,
                      ),
                    ),
                  ),
                ],
                Positioned(
                  top: 8,
                  right: 8,
                  child: IconButton(
                    onPressed: () => Navigator.of(context).maybePop(),
                    icon: const Icon(Icons.close),
                    color: AppColors.offWhite,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
