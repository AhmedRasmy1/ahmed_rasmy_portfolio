import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_player/video_player.dart';

import 'package:ahmed_rasmy_portfolio/app/l10n/generated/app_localizations.dart';
import 'package:ahmed_rasmy_portfolio/app/theme/app_colors.dart';
import 'package:ahmed_rasmy_portfolio/core/constants/portfolio_data.dart';
import 'package:ahmed_rasmy_portfolio/core/cursor/custom_cursor_overlay.dart';
import 'package:ahmed_rasmy_portfolio/core/l10n/case_study_copy.dart';

/// Lazy-init muted looping video. Poster until play; dispose when off-screen.
class LazyHoverVideo extends StatefulWidget {
  const LazyHoverVideo({
    super.key,
    required this.card,
    required this.scrollOffset,
    this.phoneFrame = false,
    this.customCursor = false,
    this.aspectRatio = 9 / 16,
  });

  final CaseStudyMediaCard card;
  final ValueNotifier<double> scrollOffset;
  final bool phoneFrame;
  final bool customCursor;
  final double aspectRatio;

  @override
  State<LazyHoverVideo> createState() => _LazyHoverVideoState();
}

class _LazyHoverVideoState extends State<LazyHoverVideo> {
  VideoPlayerController? _controller;
  bool _near = false;
  bool _playing = false;
  bool _failed = false;
  bool _initing = false;

  @override
  void initState() {
    super.initState();
    widget.scrollOffset.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) => _onScroll());
  }

  @override
  void dispose() {
    widget.scrollOffset.removeListener(_onScroll);
    _disposeController();
    super.dispose();
  }

  void _disposeController() {
    _controller?.dispose();
    _controller = null;
    _initing = false;
    _playing = false;
  }

  void _onScroll() {
    if (!mounted) return;
    final box = context.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize) return;
    final top = box.localToGlobal(Offset.zero).dy;
    final bottom = top + box.size.height;
    final viewH = MediaQuery.sizeOf(context).height;
    final near = bottom > -120 && top < viewH + 120;

    if (near == _near) {
      if (near &&
          !_playing &&
          MediaQuery.sizeOf(context).width < 700 &&
          _controller != null &&
          _controller!.value.isInitialized) {
        _play();
      }
      return;
    }

    setState(() => _near = near);
    if (near) {
      _ensureInit();
      if (MediaQuery.sizeOf(context).width < 700) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) _play();
        });
      }
    } else {
      _controller?.pause();
      _disposeController();
      if (mounted) setState(() {});
    }
  }

  Future<void> _ensureInit() async {
    final path = widget.card.videoAsset;
    if (path == null || isTodo(path) || _failed || _initing || _controller != null) {
      return;
    }
    _initing = true;
    try {
      final c = VideoPlayerController.asset(path);
      await c.initialize();
      await c.setLooping(true);
      await c.setVolume(0);
      if (!mounted || !_near) {
        await c.dispose();
        _initing = false;
        return;
      }
      setState(() {
        _controller = c;
        _initing = false;
      });
    } catch (_) {
      _initing = false;
      if (mounted) setState(() => _failed = true);
    }
  }

  Future<void> _play() async {
    await _ensureInit();
    final c = _controller;
    if (c == null || !c.value.isInitialized) return;
    await c.play();
    if (mounted) setState(() => _playing = true);
  }

  Future<void> _pause() async {
    final c = _controller;
    if (c == null) return;
    await c.pause();
    await c.seekTo(Duration.zero);
    if (mounted) setState(() => _playing = false);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final mobile = MediaQuery.sizeOf(context).width < 700;
    final caption = CaseStudyCopy.t(l10n, widget.card.captionKey);
    final poster = widget.card.posterAsset;
    final ready = _controller != null &&
        _controller!.value.isInitialized &&
        !_failed;

    Widget media = Stack(
      fit: StackFit.expand,
      children: [
        if (poster != null && !isTodo(poster))
          Image.asset(
            poster,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => _PosterFallback(label: caption),
          )
        else
          _PosterFallback(label: caption),
        if (ready)
          AnimatedOpacity(
            opacity: _playing ? 1 : 0,
            duration: const Duration(milliseconds: 200),
            child: FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: _controller!.value.size.width,
                height: _controller!.value.size.height,
                child: VideoPlayer(_controller!),
              ),
            ),
          ),
        if (!_playing && !_failed && widget.card.videoAsset != null)
          Positioned(
            left: 8,
            right: 8,
            bottom: 10,
            child: Text(
              mobile ? l10n.caseTapToPlay : l10n.caseHoverToPlay,
              textAlign: TextAlign.center,
              style: GoogleFonts.spaceMono(
                fontSize: 9,
                letterSpacing: 1.4,
                fontWeight: FontWeight.w700,
                color: AppColors.offWhite.withValues(alpha: 0.9),
                decoration: TextDecoration.none,
                shadows: const [
                  Shadow(blurRadius: 6, color: Colors.black54),
                ],
              ),
            ),
          ),
      ],
    );

    media = AspectRatio(
      aspectRatio: widget.aspectRatio,
      child: media,
    );

    if (widget.phoneFrame) {
      media = Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.navyInk,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: AppColors.navy.withValues(alpha: 0.8),
            width: 3,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: media,
        ),
      );
    } else {
      media = ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: media,
      );
    }

    return CursorTarget(
      enabled: widget.customCursor,
      child: MouseRegion(
        onEnter: mobile
            ? null
            : (_) {
                _play();
              },
        onExit: mobile
            ? null
            : (_) {
                _pause();
              },
        child: GestureDetector(
          onTap: mobile
              ? () {
                  if (_playing) {
                    _pause();
                  } else {
                    _play();
                  }
                }
              : null,
          child: Column(
            children: [
              media,
              const SizedBox(height: 10),
              Text(
                caption,
                textAlign: TextAlign.center,
                style: GoogleFonts.spaceMono(
                  fontSize: 11,
                  letterSpacing: 1,
                  fontWeight: FontWeight.w700,
                  color: context.zine.ink,
                  decoration: TextDecoration.none,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PosterFallback extends StatelessWidget {
  const _PosterFallback({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.navy,
      child: Center(
        child: Text(
          label.toUpperCase(),
          textAlign: TextAlign.center,
          style: GoogleFonts.spaceMono(
            fontSize: 11,
            letterSpacing: 1.4,
            fontWeight: FontWeight.w700,
            color: AppColors.flutterLightBlue.withValues(alpha: 0.75),
            decoration: TextDecoration.none,
          ),
        ),
      ),
    );
  }
}
