import 'package:flutter/material.dart';
import '../widgets/external_script_widget.dart';

class IRSectionKeys {
  static final companySnapshot   = GlobalKey();
  static final announcements     = GlobalKey();
  static final factSheet         = GlobalKey();
  static final stockActivity     = GlobalKey();
  static final corporateActions  = GlobalKey();
  static final companyFinancials = GlobalKey();
  static final sharePrice        = GlobalKey();
  static final performance       = GlobalKey();

  // ترتيب السكشنز من فوق لتحت
  static final List<GlobalKey> orderedKeys = [
    companySnapshot,
    announcements,
    factSheet,
    stockActivity,
    corporateActions,
    companyFinancials,
    sharePrice,
    performance,
  ];

  static void scrollTo(GlobalKey targetKey, ScrollController controller) {
    // حمّل كل الـ widgets اللي فوق الـ target عشان يثبت الـ layout
    _loadAllAbove(targetKey);

    // انتظر ثابت كافي لكل الـ widgets اللي فوق تحمل وتثبت
    Future.delayed(const Duration(milliseconds: 2500), () {
      // حمّل الـ target نفسه
      _triggerLoadInSection(targetKey);
      // سكرول بعد ما يحمل
      Future.delayed(const Duration(milliseconds: 500), () {
        _doScroll(targetKey, controller);
      });
    });
  }

  /// حمّل كل الـ widgets اللي قبل الـ target في الترتيب
  static void _loadAllAbove(GlobalKey targetKey) {
    final idx = orderedKeys.indexOf(targetKey);
    if (idx <= 0) return;
    for (int i = 0; i < idx; i++) {
      _triggerLoadInSection(orderedKeys[i]);
    }
  }

  static void _triggerLoadInSection(GlobalKey key) {
    final ctx = key.currentContext;
    if (ctx == null) return;
    void visitor(Element element) {
      if (element.widget is LazyExternalScriptWidget) {
        final state = (element as StatefulElement).state;
        if (state is LazyLoadable) {
          (state as LazyLoadable).loadNow();
        }
      }
      element.visitChildren(visitor);
    }
    (ctx as Element).visitChildren(visitor);
  }

  static void _doScroll(GlobalKey key, ScrollController controller) {
    final ctx = key.currentContext;
    if (ctx == null) return;
    if (!controller.hasClients) return;
    final box = ctx.findRenderObject() as RenderBox?;
    if (box == null) return;
    final scrollCtx = Scrollable.maybeOf(ctx)?.context;
    if (scrollCtx == null) return;
    final scrollBox = scrollCtx.findRenderObject() as RenderBox?;
    if (scrollBox == null) return;
    final pos = box.localToGlobal(Offset.zero, ancestor: scrollBox);
    final target = (controller.offset + pos.dy)
        .clamp(0.0, controller.position.maxScrollExtent);
    controller.animateTo(
      target,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }
}
