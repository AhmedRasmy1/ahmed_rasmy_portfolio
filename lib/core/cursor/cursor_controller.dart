import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';

enum CursorHotspot { none, interactive, portrait }

/// Single ticker + notifiers for the custom desktop cursor.
class CursorController extends ChangeNotifier {
  CursorController() {
    _ticker = Ticker(_onTick)..start();
  }

  late final Ticker _ticker;
  final ValueNotifier<Offset> rawPosition = ValueNotifier(Offset.zero);
  final ValueNotifier<Offset> ringPosition = ValueNotifier(Offset.zero);
  final ValueNotifier<CursorHotspot> hotspot =
      ValueNotifier(CursorHotspot.none);
  final ValueNotifier<String?> label = ValueNotifier<String?>(null);
  final ValueNotifier<bool> pressed = ValueNotifier(false);
  final ValueNotifier<bool> visible = ValueNotifier(false);

  bool enabled = true;

  void setEnabled(bool value) {
    if (enabled == value) return;
    enabled = value;
    if (!value) visible.value = false;
    notifyListeners();
  }

  void updatePosition(Offset global) {
    if (!enabled) return;
    rawPosition.value = global;
    visible.value = true;
  }

  void setHotspot(CursorHotspot value, {String? label}) {
    if (hotspot.value != value) hotspot.value = value;
    if (this.label.value != label) this.label.value = label;
  }

  void setPressed(bool value) => pressed.value = value;

  void hide() {
    visible.value = false;
    label.value = null;
  }

  void _onTick(Duration _) {
    if (!enabled || !visible.value) return;
    final cur = ringPosition.value;
    final target = rawPosition.value;
    final next = Offset(
      cur.dx + (target.dx - cur.dx) * 0.15,
      cur.dy + (target.dy - cur.dy) * 0.15,
    );
    if ((next - cur).distance > 0.05) {
      ringPosition.value = next;
    }
  }

  @override
  void dispose() {
    _ticker.dispose();
    rawPosition.dispose();
    ringPosition.dispose();
    hotspot.dispose();
    label.dispose();
    pressed.dispose();
    visible.dispose();
    super.dispose();
  }
}

final cursorController = CursorController();
