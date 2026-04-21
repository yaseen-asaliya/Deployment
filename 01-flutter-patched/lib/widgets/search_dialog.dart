import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../utils/search_data.dart';
import '../utils/app_colors.dart';
import '../utils/scroll_keys.dart';
import '../main.dart';

class SearchDialog extends StatefulWidget {
  const SearchDialog({super.key});

  @override
  State<SearchDialog> createState() => _SearchDialogState();
}

class _SearchDialogState extends State<SearchDialog> {
  final TextEditingController _controller = TextEditingController();
  List<SearchResult> _results = [];
  bool _loading = false;
  bool _searchedAsArabic = false;

  void _onChanged(String value) {
    if (value.trim().isEmpty) {
      setState(() { _results = []; _loading = false; });
      return;
    }
    setState(() => _loading = true);
    Future.delayed(const Duration(milliseconds: 400), () {
      if (!mounted) return;
      // Auto-detect language from input text
      final hasArabic = RegExp(r'[\u0600-\u06FF]').hasMatch(value);
      final searchAsArabic = hasArabic || localeProvider.isArabic;
      setState(() {
        _searchedAsArabic = searchAsArabic;
        _results = SearchData.search(value, searchAsArabic);
        _loading = false;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = localeProvider.isArabic;
    final dir = isArabic ? TextDirection.rtl : TextDirection.ltr;

    return Directionality(
      textDirection: dir,
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600, minHeight: 420, maxHeight: 520),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Row(
                  children: [
                    const Icon(Icons.search, color: AppColors.primary, size: 20),
                    const SizedBox(width: 10),
                    Text(
                      isArabic ? 'البحث' : 'Search',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.close, size: 18),
                      onPressed: () => Navigator.pop(context),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              // Search field
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  controller: _controller,
                  autofocus: true,
                  textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
                  textAlign: isArabic ? TextAlign.right : TextAlign.left,
                  onChanged: _onChanged,
                  decoration: InputDecoration(
                    hintText: isArabic ? 'ابحث عن صفحة أو موضوع...' : 'Search pages, topics...',
                    prefixIcon: const Icon(Icons.search, size: 18, color: AppColors.textSecondary),
                    suffixIcon: _loading
                        ? const Padding(
                            padding: EdgeInsets.all(12),
                            child: SizedBox(
                              width: 16, height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary),
                            ),
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    filled: true,
                    fillColor: const Color(0xFFF9FAFB),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              // Results
              Flexible(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  transitionBuilder: (child, animation) => FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 0.05),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    ),
                  ),
                  child: _controller.text.isEmpty
                      ? _buildEmptyState(isArabic)
                      : _loading
                          ? const SizedBox(key: ValueKey('loading'))
                          : _results.isEmpty
                              ? _buildNoResults(isArabic)
                              : _buildResults(_searchedAsArabic),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(bool isArabic) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.search, size: 40, color: Colors.grey.shade300),
          const SizedBox(height: 8),
          Text(
            isArabic ? 'اكتب للبحث في الموقع' : 'Type to search the site',
            style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _buildNoResults(bool isArabic) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.search_off, size: 40, color: Colors.grey.shade300),
          const SizedBox(height: 8),
          Text(
            isArabic ? 'لا توجد نتائج' : 'No results found',
            style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _buildResults(bool isArabic) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      itemCount: _results.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, i) {
        final r = _results[i];
        return _AnimatedResultItem(
          index: i,
          child: SelectionContainer.disabled(
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: () {
                  Navigator.pop(context);
                  context.go(r.route);
                  if (r.fragment != null) {
                    Future.delayed(const Duration(milliseconds: 600), () {
                      ScrollKeys.scrollTo(r.fragment!);
                    });
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                  child: Row(
                    children: [
                      Container(
                        width: 36, height: 36,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Icon(Icons.article_outlined, size: 18, color: AppColors.primary),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isArabic ? r.titleAr : r.titleEn,
                              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF111827)),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              isArabic ? r.descAr : r.descEn,
                              style: const TextStyle(fontSize: 11, color: Color(0xFF6B7280)),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3F4F6),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          isArabic ? r.categoryAr : r.categoryEn,
                          style: const TextStyle(fontSize: 10, color: Color(0xFF6B7280)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _AnimatedResultItem extends StatefulWidget {
  final int index;
  final Widget child;
  const _AnimatedResultItem({required this.index, required this.child});

  @override
  State<_AnimatedResultItem> createState() => _AnimatedResultItemState();
}

class _AnimatedResultItemState extends State<_AnimatedResultItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fade;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    Future.delayed(Duration(milliseconds: widget.index * 50), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(position: _slide, child: widget.child),
    );
  }
}
