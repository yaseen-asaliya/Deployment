// ignore_for_file: avoid_web_libraries_in_flutter

import 'dart:async';
import 'dart:html' as html;
import 'dart:js_util' as js_util;
import 'dart:ui_web' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../main.dart';
import '../utils/app_colors.dart';

// ── Global load queue ──────────────────────────────────────────────────────
final List<VoidCallback> _loadQueue = [];
bool _queueRunning = false;

// فحص إذا المستخدم على iOS
bool _isIOS() {
  if (!kIsWeb) return false;
  final userAgent = html.window.navigator.userAgent.toLowerCase();
  return userAgent.contains('iphone') || userAgent.contains('ipad') || userAgent.contains('ipod');
}

void _enqueueLoad(VoidCallback load, {bool priority = false}) {
  if (priority) {
    load();
  } else {
    _loadQueue.add(load);
    if (!_queueRunning) _processQueue();
  }
}

void _processQueue() {
  if (_loadQueue.isEmpty) { _queueRunning = false; return; }
  
  _queueRunning = true;
  final next = _loadQueue.removeAt(0);
  next();
  
  // على iOS: تأخير 3 ثواني، على الباقي: فوري
  final delay = _isIOS() ? 3000 : 0;
  Future.delayed(Duration(milliseconds: delay), _processQueue);
}

/// Interface عام عشان نقدر نستدعي loadNow من ملفات ثانية
abstract class LazyLoadable {
  void loadNow();
}

/// تعطيل/تفعيل pointer events على كل الـ iframes في الصفحة
void setAllIframesPointerEvents(bool enabled) {
  final iframes = html.document.querySelectorAll('iframe');
  for (final el in iframes) {
    (el as html.HtmlElement).style.pointerEvents = enabled ? 'auto' : 'none';
  }
}

/// حذف كل الـ iframes القديمة من الـ DOM
void removeAllOldIframes() {
  final iframes = html.document.querySelectorAll('iframe');
  for (final el in iframes) {
    // احذف الـ iframes اللي pointer-events تبعها auto (يعني كانت مفعّلة)
    if ((el as html.HtmlElement).style.pointerEvents == 'auto') {
      el.remove();
    }
  }
}
// ────────────────────────────────────────────────────────────────────────────

/// Smart wrapper: على iOS يستخدم lazy loading، على Desktop/Android يحمل مباشرة
class LazyExternalScriptWidget extends StatelessWidget {
  final String viewId;
  final String widgetType;
  final double fallbackHeight;
  final String lang;
  final bool priority;
  final Widget? customPlaceholder;
  final bool showBorder;

  const LazyExternalScriptWidget({
    super.key,
    required this.viewId,
    required this.widgetType,
    this.fallbackHeight = 200,
    this.lang = 'en',
    this.priority = false,
    this.customPlaceholder,
    this.showBorder = true,
  });

  @override
  Widget build(BuildContext context) {
    // على iOS: استخدم lazy loading
    if (_isIOS()) {
      return _LazyExternalScriptWidgetIOS(
        viewId: viewId,
        widgetType: widgetType,
        fallbackHeight: fallbackHeight,
        lang: lang,
        priority: priority,
        customPlaceholder: customPlaceholder,
        showBorder: showBorder,
      );
    }
    
    // على Desktop/Android: حمّل مباشرة بدون lazy loading
    return ExternalScriptWidget(
      viewId: viewId,
      widgetType: widgetType,
      fallbackHeight: fallbackHeight,
      lang: lang,
      priority: priority,
      showBorder: showBorder,
    );
  }
}

/// النسخة الـ lazy loading للـ iOS فقط
class _LazyExternalScriptWidgetIOS extends StatefulWidget {
  final String viewId;
  final String widgetType;
  final double fallbackHeight;
  final String lang;
  final bool priority;
  final Widget? customPlaceholder;
  final bool showBorder;

  const _LazyExternalScriptWidgetIOS({
    super.key,
    required this.viewId,
    required this.widgetType,
    this.fallbackHeight = 200,
    this.lang = 'en',
    this.priority = false,
    this.customPlaceholder,
    this.showBorder = true,
  });

  @override
  State<_LazyExternalScriptWidgetIOS> createState() => _LazyExternalScriptWidgetIOSState();
}

class _LazyExternalScriptWidgetIOSState extends State<_LazyExternalScriptWidgetIOS> implements LazyLoadable {
  bool _visible = false;
  bool _queued = false;
  final _key = GlobalKey();
  Timer? _visibilityChecker;
  Timer? _disposeChecker;

  // public method للاستدعاء من الخارج
  // ignore: library_private_types_in_public_api
  void loadNow() {
    if (_queued || _visible) return;
    _queued = true;
    _enqueueLoad(() {
      if (mounted) setState(() => _visible = true);
    });
  }

  @override
  void initState() {
    super.initState();
    
    // إذا كان priority (مثل Stock Ticker)، حمّل بعد تأخير بسيط
    if (widget.priority) {
      _queued = true;
      Future.delayed(const Duration(milliseconds: 600), () {
        _enqueueLoad(() {
          if (mounted) setState(() => _visible = true);
        }, priority: true);
      });
      return;
    }
    
    // على iOS: lazy load مع disposal قوي
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startVisibilityCheck();
      _startDisposeCheck();
    });
  }
  
  void _startVisibilityCheck() {
    _checkVisibility();
    _visibilityChecker = Timer.periodic(const Duration(milliseconds: 1500), (_) {
      if (!_queued && !_visible) {
        _checkVisibility();
      }
    });
  }
  
  void _startDisposeCheck() {
    // على iOS: فحص كل 200ms - حذف سريع جداً
    _disposeChecker = Timer.periodic(const Duration(milliseconds: 250), (_) {
      if (_visible && mounted) {
        _checkIfShouldDispose();
      }
    });
  }
  
  void _checkIfShouldDispose() {
    final ctx = _key.currentContext;
    if (ctx == null) return;
    
    final box = ctx.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize) return;
    
    final pos = box.localToGlobal(Offset.zero);
    final screenH = MediaQuery.of(ctx).size.height;
    
    // حذف فوري جداً: بمجرد ما يطلع من الشاشة بـ 50 pixels
    if (pos.dy < -50 || pos.dy > screenH + 50) {
      setState(() {
        _visible = false;
        _queued = false;
      });
    }
  }
  
  @override
  void dispose() {
    _visibilityChecker?.cancel();
    _disposeChecker?.cancel();
    super.dispose();
  }

  void _checkVisibility() {
    if (!mounted || _queued) return;
    final ctx = _key.currentContext;
    if (ctx == null) {
      Future.delayed(const Duration(milliseconds: 250), _checkVisibility);
      return;
    }
    final box = ctx.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize) {
      Future.delayed(const Duration(milliseconds: 250), _checkVisibility);
      return;
    }
    final pos = box.localToGlobal(Offset.zero);
    final screenH = MediaQuery.of(ctx).size.height;
    
    // على iOS: نطاق ضيق جداً - فقط لما يكون على الشاشة
    if (pos.dy >= -50 && pos.dy < screenH * 0.5) {
      _queued = true;
      _enqueueLoad(() {
        if (mounted) setState(() => _visible = true);
      });
    } else {
      Future.delayed(const Duration(milliseconds: 500), _checkVisibility);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_visible) {
      return ExternalScriptWidget(
        viewId: widget.viewId,
        widgetType: widget.widgetType,
        fallbackHeight: widget.fallbackHeight,
        lang: widget.lang,
        showBorder: widget.showBorder,
      );
    }
    // استخدم placeholder مخصص إذا كان موجود
    if (widget.customPlaceholder != null) {
      return Container(
        key: _key,
        child: widget.customPlaceholder!,
      );
    }
    // على iOS: placeholder شفاف تماماً (بدون رمشة)
    return Container(
      key: _key,
      width: double.infinity,
      height: widget.fallbackHeight,
      color: Colors.transparent,
    );
  }
}

class _SkeletonPlaceholder extends StatefulWidget {
  final double height;
  const _SkeletonPlaceholder({super.key, required this.height});

  @override
  State<_SkeletonPlaceholder> createState() => _SkeletonPlaceholderState();
}

class _SkeletonPlaceholderState extends State<_SkeletonPlaceholder>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200))
      ..repeat(reverse: true);
    _anim = Tween<double>(begin: 0.3, end: 0.7).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) => Container(
        width: double.infinity,
        height: widget.height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Color.lerp(const Color(0xFFE5E7EB), const Color(0xFFF3F4F6), _anim.value),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _bar(0.4),
            const SizedBox(height: 12),
            _bar(0.7),
            const SizedBox(height: 8),
            _bar(0.6),
            const SizedBox(height: 8),
            _bar(0.5),
          ],
        ),
      ),
    );
  }

  Widget _bar(double widthFactor) => FractionallySizedBox(
        widthFactor: widthFactor,
        child: Container(
          height: 12,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.6),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      );
}

class ExternalScriptWidget extends StatefulWidget {
  final String viewId;
  final String widgetType;
  final double fallbackHeight;
  final String lang;
  final bool priority;
  final bool showLoadingIndicator; // إظهار loading indicator
  final bool showBorder; // إظهار البوردر

  const ExternalScriptWidget({
    super.key,
    required this.viewId,
    required this.widgetType,
    this.fallbackHeight = 200,
    this.lang = 'en',
    this.priority = false,
    this.showLoadingIndicator = false,
    this.showBorder = true, // البوردر مفعّل افتراضياً
  });

  @override
  State<ExternalScriptWidget> createState() => _ExternalScriptWidgetState();
}

class _ExternalScriptWidgetState extends State<ExternalScriptWidget> {
  html.IFrameElement? _iframe;
  double _height = 0;
  html.EventListener? _messageListener;
  Timer? _debounce;
  double _pendingHeight = 0;
  bool _isLoading = true;
  late String _uniqueViewId;

  @override
  void initState() {
    super.initState();
    if (!kIsWeb) return;

    // اعمل viewId فريد باستخدام timestamp أول شي
    _uniqueViewId = '${widget.viewId}-${DateTime.now().millisecondsSinceEpoch}';

    _height = widget.fallbackHeight;

    // احذف أي iframe قديم بنفس الـ viewId الأساسي
    final oldIframes = html.document.querySelectorAll('iframe');
    for (final el in oldIframes) {
      final iframe = el as html.IFrameElement;
      // احذف الـ iframes اللي في الـ platform view بنفس الـ ID الأساسي
      final parent = iframe.parent;
      if (parent != null && parent.id.contains(widget.viewId)) {
        iframe.remove();
      }
    }

    _iframe = html.IFrameElement()
      ..style.border = 'none'
      ..style.width = '100%'
      ..style.height = '100%'
      ..srcdoc = _buildHtml();

    // أخفي الـ loading بعد 300ms فقط (الويدجتات محملة مسبقاً)
    if (widget.showLoadingIndicator) {
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) setState(() => _isLoading = false);
      });
    } else {
      _isLoading = false;
    }

    _messageListener = (event) {
      final msg = (event as html.MessageEvent).data;
      if (msg is Map && msg['type'] == 'widget-height') {
        if (msg['id'] == _uniqueViewId) {
          final h = (msg['height'] as num).toDouble();
          if (h > 20) {
            _pendingHeight = h;
            _debounce?.cancel();
            _debounce = Timer(const Duration(milliseconds: 200), () {
              // حدّث الارتفاع حتى لو الفرق صغير (1 pixel)
              if (mounted && (_pendingHeight - _height).abs() > 1) {
                setState(() => _height = _pendingHeight);
              }
            });
          }
        }
      }
    };
    html.window.addEventListener('message', _messageListener!);

    try {
      ui.platformViewRegistry.registerViewFactory(
        _uniqueViewId, // استخدم الـ viewId الفريد
        (int id) => _iframe!,
      );
    } catch (e) {
      // إذا فشل التسجيل، حاول مرة ثانية بـ viewId مختلف
      _uniqueViewId = '${widget.viewId}-${DateTime.now().millisecondsSinceEpoch}-retry';
      try {
        ui.platformViewRegistry.registerViewFactory(
          _uniqueViewId,
          (int id) => _iframe!,
        );
      } catch (_) {}
    }
  }

  // Pointer-events are always `auto` (CSS default).
  // The pointer-events nuking / scroll-disable hacks were removed because they
  // broke mobile interaction. Native browser scroll + Flutter's scroll arena
  // handle iframe/parent scroll correctly when srcdoc forwarders are also
  // removed (see _buildHtml() below).

  String _buildHtml() {
    return '''<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<style>
  html, body { 
    overflow: hidden; 
    margin: 0; 
    padding: 0;
    width: 100%;
    height: 100%;
  }
  body::-webkit-scrollbar { display: none; }
  body { -ms-overflow-style: none; scrollbar-width: none; }
</style>
<script src="https://irp.atnmo.com/v3/widget/widget-loader.js"></script>
</head>
<body>
<div id="${widget.widgetType}-widget"></div>
<script>
(function() {
  // wheel / touchmove forwarders removed — the browser handles native scroll
  // propagation across iframes. The old forwarders confused Flutter's scroll
  // arena and required the pointer-events hack to compensate.
  var ID = '$_uniqueViewId';
  var debounceTimer = null;
  var lastSent = 0;
  var updateCount = 0;
  var maxUpdates = 20; // زيادة العدد الأقصى للتحديثات

  function getTrueHeight() {
    // طريقة جديدة: احسب من آخر عنصر مرئي فقط
    var maxBottom = 0;
    
    // احصل على كل العناصر المباشرة في الـ body
    var children = document.body.children;
    for (var i = 0; i < children.length; i++) {
      var rect = children[i].getBoundingClientRect();
      // فقط العناصر المرئية (display != none)
      var style = window.getComputedStyle(children[i]);
      if (style.display !== 'none' && rect.height > 0) {
        maxBottom = Math.max(maxBottom, rect.bottom);
      }
    }
    
    // إذا ما لقينا عناصر، استخدم الطرق التقليدية
    if (maxBottom === 0) {
      maxBottom = Math.max(
        document.body.scrollHeight,
        document.body.offsetHeight,
        document.documentElement.clientHeight
      );
    }
    
    // تحقق من الـ iframes الداخلية
    var frames = document.querySelectorAll('iframe');
    for (var j = 0; j < frames.length; j++) {
      var fRect = frames[j].getBoundingClientRect();
      var fStyle = window.getComputedStyle(frames[j]);
      if (fStyle.display !== 'none') {
        maxBottom = Math.max(maxBottom, fRect.bottom);
        try {
          var fDoc = frames[j].contentDocument || frames[j].contentWindow.document;
          if (fDoc && fDoc.body) {
            maxBottom = Math.max(maxBottom, fDoc.body.scrollHeight + fRect.top);
          }
        } catch(e) {}
      }
    }
    
    return Math.ceil(maxBottom);
  }

  function reportDebounced() {
    // لا تتوقف عن التحديثات - دائماً أبلغ عن التغييرات
    clearTimeout(debounceTimer);
    debounceTimer = setTimeout(function() {
      var h = getTrueHeight();
      // أبلغ حتى لو الارتفاع أقل (لحل مشكلة الفراغ)
      if (h > 20 && Math.abs(h - lastSent) > 3) {
        lastSent = h;
        updateCount++;
        window.parent.postMessage({ type: 'widget-height', id: ID, height: h }, '*');
      }
    }, 100);
  }

  new MutationObserver(function() {
    reportDebounced();
    document.querySelectorAll('iframe').forEach(function(f) {
      if (!f._w) {
        f._w = true;
        f.addEventListener('load', function() {
          setTimeout(reportDebounced, 500);
          setTimeout(reportDebounced, 1500);
          setTimeout(reportDebounced, 3000);
        });
      }
    });
  }).observe(document.body, { childList: true, subtree: true, attributes: true });

  if (window.ResizeObserver) {
    new ResizeObserver(reportDebounced).observe(document.body);
  }

  document.addEventListener('click', function() {
    reportDebounced();
    setTimeout(reportDebounced, 100);
    setTimeout(reportDebounced, 300);
    setTimeout(reportDebounced, 600);
    setTimeout(reportDebounced, 1000);
  });

  // استمع لأي تغيير في الـ DOM - فحص مستمر كل 200ms
  setInterval(function() {
    var currentHeight = getTrueHeight();
    if (currentHeight > 20 && Math.abs(currentHeight - lastSent) > 3) {
      lastSent = currentHeight;
      window.parent.postMessage({ type: 'widget-height', id: ID, height: currentHeight }, '*');
    }
  }, 200); // فحص كل 200ms

  window.addEventListener('load', function() {
    if (typeof loadWidget === 'function') {
      loadWidget(
        '${widget.widgetType}',
        "5be9c146-613e-4141-a351-1f5e13fc5513",
        "${widget.lang}",
        "81a06c05-1a48-4d1b-8dbd-bcf60a76730f",
        "v3"
      );
    }
    [1000, 2000, 4000, 7000, 12000].forEach(function(t) {
      setTimeout(reportDebounced, t);
    });
  });
})();
</script>
</body>
</html>''';
  }

  @override
  void dispose() {
    _debounce?.cancel();
    if (_messageListener != null) {
      html.window.removeEventListener('message', _messageListener!);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!kIsWeb) return const SizedBox.shrink();

    final content = Stack(
          children: [
            SizedBox(
              width: double.infinity,
              height: _height,
              child: HtmlElementView(viewType: _uniqueViewId),
            ),
            // Loading indicator
            if (widget.showLoadingIndicator && _isLoading)
              Positioned.fill(
                child: Container(
                  color: const Color(0xFFF8F9FA),
                  child: Center(
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        );
    
    // إذا البوردر مطلوب، لفّه بـ Container
    if (widget.showBorder) {
      return Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: const Color(0xFFE5E7EB),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: content,
        ),
      );
    }
    
    return content;
  }
}
