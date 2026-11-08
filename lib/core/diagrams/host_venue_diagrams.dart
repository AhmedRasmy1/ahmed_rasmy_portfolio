import 'package:flutter/material.dart';

import 'package:ahmed_rasmy_portfolio/core/diagrams/diagram_models.dart';

/// Host / Venue case-study diagram specs (EN + AR labels ≤ 4 words).
abstract final class HostVenueDiagrams {
  static const modeSwitching = DiagramSpec(
    id: 'mode_switching',
    titleEn: 'Mode switching',
    titleAr: 'تبديل الوضع',
    kind: DiagramKind.flow,
    nodes: [
      DiagramNode(
        id: 'member_home',
        labelEn: 'Member Home',
        labelAr: 'رئيسية العضو',
        preferred: Offset(0.08, 0.5),
      ),
      DiagramNode(
        id: 'capabilities',
        labelEn: 'Capabilities',
        labelAr: 'القدرات',
        shape: DiagramNodeShape.diamond,
        preferred: Offset(0.28, 0.5),
      ),
      DiagramNode(
        id: 'chooser',
        labelEn: 'Chooser',
        labelAr: 'الاختيار',
        preferred: Offset(0.48, 0.5),
      ),
      DiagramNode(
        id: 'enter_host',
        labelEn: 'Enter Host',
        labelAr: 'دخول المضيف',
        preferred: Offset(0.68, 0.22),
      ),
      DiagramNode(
        id: 'host_shell',
        labelEn: 'Host shell',
        labelAr: 'واجهة المضيف',
        preferred: Offset(0.88, 0.22),
      ),
      DiagramNode(
        id: 'enter_venue',
        labelEn: 'Enter Venue',
        labelAr: 'دخول المكان',
        preferred: Offset(0.68, 0.78),
      ),
      DiagramNode(
        id: 'venue_shell',
        labelEn: 'Venue shell',
        labelAr: 'واجهة المكان',
        preferred: Offset(0.88, 0.78),
      ),
      DiagramNode(
        id: 'back_member',
        labelEn: 'Back to Member',
        labelAr: 'عودة للعضو',
        preferred: Offset(0.48, 0.92),
      ),
    ],
    edges: [
      DiagramEdge(from: 'member_home', to: 'capabilities'),
      DiagramEdge(
        from: 'capabilities',
        to: 'enter_host',
        labelEn: 'host only',
        labelAr: 'مضيف فقط',
      ),
      DiagramEdge(from: 'enter_host', to: 'host_shell'),
      DiagramEdge(
        from: 'capabilities',
        to: 'enter_venue',
        labelEn: 'venue only',
        labelAr: 'مكان فقط',
      ),
      DiagramEdge(from: 'enter_venue', to: 'venue_shell'),
      DiagramEdge(
        from: 'capabilities',
        to: 'chooser',
        labelEn: 'both',
        labelAr: 'كلاهما',
      ),
      DiagramEdge(from: 'chooser', to: 'enter_host'),
      DiagramEdge(from: 'chooser', to: 'enter_venue'),
      DiagramEdge(from: 'host_shell', to: 'back_member'),
      DiagramEdge(from: 'venue_shell', to: 'back_member'),
      DiagramEdge(from: 'back_member', to: 'member_home'),
    ],
  );

  static const sessionLifecycle = DiagramSpec(
    id: 'session_lifecycle',
    titleEn: 'Session lifecycle',
    titleAr: 'دورة الجلسة',
    kind: DiagramKind.flow,
    nodes: [
      DiagramNode(
        id: 'create',
        labelEn: 'Create session',
        labelAr: 'إنشاء جلسة',
      ),
      DiagramNode(
        id: 'location',
        labelEn: 'Pick location',
        labelAr: 'اختيار الموقع',
      ),
      DiagramNode(
        id: 'pricing',
        labelEn: 'Set pricing',
        labelAr: 'تحديد السعر',
      ),
      DiagramNode(
        id: 'publish',
        labelEn: 'Publish',
        labelAr: 'نشر',
      ),
      DiagramNode(
        id: 'manage',
        labelEn: 'Manage',
        labelAr: 'إدارة',
      ),
      DiagramNode(
        id: 'cancel',
        labelEn: 'Cancel',
        labelAr: 'إلغاء',
      ),
      DiagramNode(
        id: 'door',
        labelEn: 'Door',
        labelAr: 'الباب',
      ),
    ],
    edges: [
      DiagramEdge(from: 'create', to: 'location'),
      DiagramEdge(from: 'location', to: 'pricing'),
      DiagramEdge(from: 'pricing', to: 'publish'),
      DiagramEdge(from: 'publish', to: 'manage'),
      DiagramEdge(from: 'manage', to: 'cancel'),
      DiagramEdge(from: 'manage', to: 'door'),
    ],
  );

  static const door = DiagramSpec(
    id: 'door',
    titleEn: 'Door',
    titleAr: 'الباب',
    kind: DiagramKind.flow,
    nodes: [
      DiagramNode(
        id: 'roster',
        labelEn: 'Open roster',
        labelAr: 'فتح القائمة',
      ),
      DiagramNode(
        id: 'refresh',
        labelEn: 'Refresh guests',
        labelAr: 'تحديث الضيوف',
      ),
      DiagramNode(
        id: 'attended',
        labelEn: 'Mark attended',
        labelAr: 'تسجيل حضور',
      ),
      DiagramNode(
        id: 'no_show',
        labelEn: 'Mark no-show',
        labelAr: 'تسجيل غياب',
      ),
      DiagramNode(
        id: 'promote',
        labelEn: 'Promote waitlist',
        labelAr: 'ترقية الانتظار',
      ),
      DiagramNode(
        id: 'walk_in',
        labelEn: 'Add walk-in',
        labelAr: 'إضافة زائر',
      ),
    ],
    edges: [
      DiagramEdge(from: 'roster', to: 'refresh'),
      DiagramEdge(from: 'refresh', to: 'attended'),
      DiagramEdge(from: 'refresh', to: 'no_show'),
      DiagramEdge(from: 'refresh', to: 'promote'),
      DiagramEdge(from: 'refresh', to: 'walk_in'),
    ],
  );

  static const venueView = DiagramSpec(
    id: 'venue_view',
    titleEn: 'Venue view',
    titleAr: 'عرض المكان',
    kind: DiagramKind.flow,
    nodes: [
      DiagramNode(
        id: 'venue_home',
        labelEn: 'Venue Home',
        labelAr: 'رئيسية المكان',
      ),
      DiagramNode(
        id: 'schedule',
        labelEn: 'Schedule',
        labelAr: 'الجدول',
      ),
      DiagramNode(
        id: 'gathering',
        labelEn: 'Open gathering',
        labelAr: 'فتح التجمع',
      ),
      DiagramNode(
        id: 'circles',
        labelEn: 'View circles',
        labelAr: 'عرض الحلقات',
      ),
      DiagramNode(
        id: 'guests',
        labelEn: 'View guests',
        labelAr: 'عرض الضيوف',
      ),
    ],
    edges: [
      DiagramEdge(from: 'venue_home', to: 'schedule'),
      DiagramEdge(from: 'schedule', to: 'gathering'),
      DiagramEdge(from: 'gathering', to: 'circles'),
      DiagramEdge(from: 'gathering', to: 'guests'),
    ],
  );

  static const statusMachine = DiagramSpec(
    id: 'status_machine',
    titleEn: 'Status machine',
    titleAr: 'آلة الحالات',
    kind: DiagramKind.stateMachine,
    footnoteEn:
        'Venue Mode shows statuses only. Venues cannot trigger transitions.',
    footnoteAr:
        'وضع المكان يعرض الحالات فقط. الأماكن لا تطلق الانتقالات.',
    nodes: [
      DiagramNode(
        id: 'start',
        labelEn: 'start',
        labelAr: 'بداية',
        shape: DiagramNodeShape.startDot,
        preferred: Offset(0.5, 0.08),
      ),
      DiagramNode(
        id: 'waitlisted',
        labelEn: 'waitlisted',
        labelAr: 'قائمة الانتظار',
        preferred: Offset(0.18, 0.38),
      ),
      DiagramNode(
        id: 'pending',
        labelEn: 'pending',
        labelAr: 'قيد الانتظار',
        preferred: Offset(0.5, 0.38),
      ),
      DiagramNode(
        id: 'confirmed',
        labelEn: 'confirmed',
        labelAr: 'مؤكد',
        preferred: Offset(0.82, 0.38),
      ),
      DiagramNode(
        id: 'cancelled',
        labelEn: 'cancelled',
        labelAr: 'ملغى',
        preferred: Offset(0.32, 0.78),
      ),
      DiagramNode(
        id: 'attended',
        labelEn: 'attended',
        labelAr: 'حضر',
        preferred: Offset(0.68, 0.72),
      ),
      DiagramNode(
        id: 'no_show',
        labelEn: 'noShow',
        labelAr: 'لم يحضر',
        preferred: Offset(0.88, 0.78),
      ),
    ],
    edges: [
      DiagramEdge(from: 'start', to: 'waitlisted'),
      DiagramEdge(from: 'start', to: 'pending'),
      DiagramEdge(from: 'start', to: 'confirmed'),
      DiagramEdge(
        from: 'waitlisted',
        to: 'confirmed',
        highlightActorEn: 'host promote',
        highlightActorAr: 'ترقية المضيف',
      ),
      DiagramEdge(
        from: 'pending',
        to: 'confirmed',
        highlightActorEn: 'host',
        highlightActorAr: 'المضيف',
      ),
      DiagramEdge(
        from: 'pending',
        to: 'cancelled',
        highlightActorEn: 'host cancels session',
        highlightActorAr: 'إلغاء الجلسة',
      ),
      DiagramEdge(
        from: 'confirmed',
        to: 'cancelled',
        highlightActorEn: 'host cancels session',
        highlightActorAr: 'إلغاء الجلسة',
      ),
      DiagramEdge(
        from: 'confirmed',
        to: 'attended',
        highlightActorEn: 'host door',
        highlightActorAr: 'باب المضيف',
      ),
      DiagramEdge(
        from: 'confirmed',
        to: 'no_show',
        highlightActorEn: 'host door',
        highlightActorAr: 'باب المضيف',
      ),
    ],
  );

  static const architecture = DiagramSpec(
    id: 'architecture',
    titleEn: 'Architecture',
    titleAr: 'الهندسة',
    kind: DiagramKind.architecture,
    nodes: [
      DiagramNode(
        id: 'ui',
        labelEn: 'UI shells',
        labelAr: 'أغلفة الواجهة',
        preferred: Offset(0.5, 0.08),
      ),
      DiagramNode(
        id: 'providers',
        labelEn: 'App Host Venue',
        labelAr: 'التطبيق والمضيف',
        preferred: Offset(0.5, 0.28),
      ),
      DiagramNode(
        id: 'repos',
        labelEn: 'Repositories',
        labelAr: 'المستودعات',
        preferred: Offset(0.5, 0.48),
      ),
      DiagramNode(
        id: 'services',
        labelEn: 'Services',
        labelAr: 'الخدمات',
        preferred: Offset(0.5, 0.68),
      ),
      DiagramNode(
        id: 'http',
        labelEn: 'HTTP client',
        labelAr: 'عميل HTTP',
        preferred: Offset(0.35, 0.88),
      ),
      DiagramNode(
        id: 'prefs',
        labelEn: 'Mode store',
        labelAr: 'مخزن الوضع',
        preferred: Offset(0.7, 0.88),
      ),
    ],
    edges: [
      DiagramEdge(from: 'ui', to: 'providers'),
      DiagramEdge(from: 'providers', to: 'repos'),
      DiagramEdge(from: 'repos', to: 'services'),
      DiagramEdge(from: 'services', to: 'http'),
      DiagramEdge(from: 'providers', to: 'prefs'),
    ],
  );

  static const erd = DiagramSpec(
    id: 'erd',
    titleEn: 'Data model',
    titleAr: 'نموذج البيانات',
    kind: DiagramKind.erd,
    nodes: [
      DiagramNode(
        id: 'user',
        labelEn: 'UserProfile',
        labelAr: 'ملف المستخدم',
      ),
      DiagramNode(
        id: 'hbm',
        labelEn: 'Host membership',
        labelAr: 'عضوية المضيف',
      ),
      DiagramNode(
        id: 'vm',
        labelEn: 'Venue membership',
        labelAr: 'عضوية المكان',
      ),
      DiagramNode(
        id: 'event',
        labelEn: 'MeetupEvent',
        labelAr: 'فعالية',
      ),
      DiagramNode(
        id: 'guest',
        labelEn: 'Session guest',
        labelAr: 'ضيف الجلسة',
      ),
      DiagramNode(
        id: 'manual',
        labelEn: 'Manual attendee',
        labelAr: 'حضور يدوي',
      ),
      DiagramNode(
        id: 'vg',
        labelEn: 'Venue gathering',
        labelAr: 'لقاء المكان',
      ),
      DiagramNode(
        id: 'vguest',
        labelEn: 'Guest list',
        labelAr: 'قائمة الضيوف',
      ),
      DiagramNode(
        id: 'circle',
        labelEn: 'Venue circle',
        labelAr: 'حلقة المكان',
      ),
    ],
    edges: [
      DiagramEdge(from: 'user', to: 'hbm'),
      DiagramEdge(from: 'user', to: 'vm'),
      DiagramEdge(from: 'hbm', to: 'event'),
      DiagramEdge(from: 'event', to: 'guest'),
      DiagramEdge(from: 'event', to: 'manual'),
      DiagramEdge(from: 'vm', to: 'vg'),
      DiagramEdge(from: 'vg', to: 'vguest'),
      DiagramEdge(from: 'vg', to: 'circle'),
    ],
  );

  /// Narrative flow / state-machine tabs.
  static const List<DiagramSpec> all = [
    modeSwitching,
    sessionLifecycle,
    door,
    venueView,
    statusMachine,
  ];

  static const List<DiagramSpec> flowTabs = all;
}
