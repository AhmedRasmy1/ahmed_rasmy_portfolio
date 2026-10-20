import 'dart:math' as math;

import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// One shared ticker for all idle micro-animations (float, twinkle, wiggle).
final idleTickerProvider = Provider<IdleTicker>((ref) {
  final ticker = IdleTicker();
  ref.onDispose(ticker.dispose);
  return ticker;
});

class IdleTicker extends ChangeNotifier {
  IdleTicker() {
    _ticker = Ticker(_onTick)..start();
  }

  late final Ticker _ticker;
  Duration _elapsed = Duration.zero;
  bool reducedMotion = false;

  Duration get elapsed => _elapsed;

  /// 0..1 looping over [period].
  double cycle(Duration period) {
    if (reducedMotion || period.inMicroseconds == 0) return 0;
    final t = _elapsed.inMicroseconds / period.inMicroseconds;
    return t - t.floorToDouble();
  }

  /// -1..1 sine wave for gentle float/sway.
  double wave(Duration period) {
    return math.sin(cycle(period) * math.pi * 2);
  }

  void _onTick(Duration elapsed) {
    if (reducedMotion) return;
    _elapsed = elapsed;
    notifyListeners();
  }

  void setReducedMotion(bool value) {
    if (reducedMotion == value) return;
    reducedMotion = value;
    if (value) {
      _elapsed = Duration.zero;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }
}

/// GPU-friendly idle transform driven by [IdleTicker].
class IdleFloat extends StatelessWidget {
  const IdleFloat({
    super.key,
    required this.ticker,
    required this.child,
    this.amplitude = 2.5,
    this.rotationAmp = 0.012,
    this.period = const Duration(milliseconds: 3200),
    this.phase = 0,
  });

  final IdleTicker ticker;
  final Widget child;
  final double amplitude;
  final double rotationAmp;
  final Duration period;
  final double phase;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ticker,
      child: child,
      builder: (context, child) {
        if (ticker.reducedMotion) return child!;
        final w = math.sin((ticker.cycle(period) + phase) * math.pi * 2);
        return Transform.translate(
          offset: Offset(0, w * amplitude),
          child: Transform.rotate(
            angle: w * rotationAmp,
            child: child,
          ),
        );
      },
    );
  }
}
