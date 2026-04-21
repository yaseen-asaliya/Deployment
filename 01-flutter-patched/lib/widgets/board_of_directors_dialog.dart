import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/app_localizations.dart';
import '../utils/responsive.dart';

String _translateMonth(String text, bool isArabic) {
  if (!isArabic) {
    // For English, replace م with G
    text = text.replaceAll('م', 'G').replaceAll('هـ', 'H');
  }
  
  final monthMap = {
    'January': 'يناير',
    'February': 'فبراير',
    'March': 'مارس',
    'April': 'أبريل',
    'May': 'مايو',
    'June': 'يونيو',
    'July': 'يوليو',
    'August': 'أغسطس',
    'September': 'سبتمبر',
    'October': 'أكتوبر',
    'November': 'نوفمبر',
    'December': 'ديسمبر',
  };
  
  if (isArabic) {
    // Translate "Ongoing" to "مستمر"
    text = text.replaceAll('Ongoing', 'مستمر');
    
    monthMap.forEach((en, ar) {
      text = text.replaceAll(en, ar);
    });
  }
  
  return text;
}

String _formatDateForTable(String from, String to, bool isArabic) {
  if (!isArabic) return '$from — $to';
  
  // For Arabic, reverse: newer date on right, older on left
  // "2009م — 2012م" becomes "2012م — 2019م"
  // Use RLM to maintain RTL context
  return '\u200F${_translateMonth(to, isArabic)} — ${_translateMonth(from, isArabic)}\u200F';
}

String _formatAppointmentDate(String date, bool isArabic) {
  // For English, replace م with G and هـ with H first
  if (!isArabic) {
    date = date.replaceAll('م', 'G').replaceAll('هـ', 'H');
    return date;
  }
  
  // For Arabic: keep original format (DD/MM/YYYY)
  return date;
}

Widget _buildArabicAppointmentDate(String date) {
  // Remove any directional marks that might interfere
  date = date.replaceAll('\u200F', '').replaceAll('\u200E', '').replaceAll('\u202A', '').replaceAll('\u202C', '');
  
  // Parse date like "12/09/1435هـ (09/07/2014م)"
  // Build each number separately to avoid BiDi issues
  
  final regex = RegExp(r'(\d+)/(\d+)/(\d+)(هـ)\s*\((\d+)/(\d+)/(\d+)(م)\)');
  final match = regex.firstMatch(date);
  
  if (match != null) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Hijri date: DD/MM/YYYY
        Text(match.group(1)!, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: Color(0xFF6B7280))),
        const Text('/', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: Color(0xFF6B7280))),
        Text(match.group(2)!, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: Color(0xFF6B7280))),
        const Text('/', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: Color(0xFF6B7280))),
        Text(match.group(3)!, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: Color(0xFF6B7280))),
        const Text('هـ (', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: Color(0xFF6B7280))),
        // Gregorian date: DD/MM/YYYY
        Text(match.group(5)!, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: Color(0xFF6B7280))),
        const Text('/', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: Color(0xFF6B7280))),
        Text(match.group(6)!, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: Color(0xFF6B7280))),
        const Text('/', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: Color(0xFF6B7280))),
        Text(match.group(7)!, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: Color(0xFF6B7280))),
        const Text('م)', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: Color(0xFF6B7280))),
      ],
    );
  }
  
  // Fallback: return as text
  return Text(date, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: Color(0xFF6B7280)));
}


class BoardOfDirectorsDialog extends StatelessWidget {
  const BoardOfDirectorsDialog({super.key});

  static void show(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (context) => const BoardOfDirectorsDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final isMobile = Responsive.isMobile(context);
    final size = MediaQuery.of(context).size;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(
        horizontal: isMobile ? 16 : size.width * 0.1,
        vertical: isMobile ? 20 : 40,
      ),
      child: Container(
        constraints: BoxConstraints(
          maxWidth: isMobile ? double.infinity : 1200,
        ),
        height: size.height * 0.9,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: SelectionArea(
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        l.isArabic ? 'مجلس الإدارة' : 'Board of Directors',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SelectionContainer.disabled(
                      child: IconButton(
                        icon: const Icon(Icons.close, color: Colors.white),
                        onPressed: () => Navigator.of(context).pop(),
                        tooltip: 'Close',
                      ),
                    ),
                  ],
                ),
              ),
              // Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _BoardCompositionSection(l: l),
                      const SizedBox(height: 48),
                      _BoardMembersSection(l: l),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BoardCompositionSection extends StatelessWidget {
  final AppLocalizations l;

  const _BoardCompositionSection({required this.l});

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l.isArabic
                ? 'تكوين المجلس وتصنيف الأعضاء'
                : 'Board Composition and Member Classification',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 16),
          Text.rich(
            TextSpan(
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: Color(0xFF6B7280),
                height: 1.5,
              ),
              children: [
                TextSpan(
                  text: l.isArabic ? 'ملاحظة: ' : 'Note: ',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1F2937),
                  ),
                ),
                TextSpan(
                  text: l.isArabic
                      ? 'رفض أحمد بن سليمان السيف وأحمد بن صالح السلطان الترشح لإعادة الانتخاب في الدورة الحالية. تم تخصيص مقعدين ضمن هيكل المجلس لإكمال النصاب القانوني، والإجراءات المطلوبة قيد التنفيذ.'
                      : 'Ahmad bin Suleiman Al-Saif and Ahmad bin Saleh Al-Sultan both declined to stand for re-election in the current term. Two seats have been allocated within the Board structure to complete the statutory quorum, and the required procedures are in progress.',
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
        isMobile
            ? Column(
                children: [
                  _RatioCard(
                    label: l.isArabic ? 'نسبة الأعضاء المستقلين' : 'Independent Members Ratio',
                    value: l.isArabic ? '2 من أصل 6 = 33.3%' : '2 out of 6 = 33.3%',
                    isArabic: l.isArabic,
                  ),
                  const SizedBox(height: 16),
                  _RatioCard(
                    label: l.isArabic ? 'نسبة الأعضاء غير التنفيذيين' : 'Non-Executive Members Ratio',
                    value: l.isArabic ? '4 من أصل 6 = 66.7%' : '4 out of 6 = 66.7%',
                    isArabic: l.isArabic,
                  ),
                ],
              )
            : Row(
                children: [
                  Expanded(
                    child: _RatioCard(
                      label: l.isArabic ? 'نسبة الأعضاء المستقلين' : 'Independent Members Ratio',
                      value: l.isArabic ? '2 من أصل 6 = 33.3%' : '2 out of 6 = 33.3%',
                      isArabic: l.isArabic,
                    ),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: _RatioCard(
                      label: l.isArabic ? 'نسبة الأعضاء غير التنفيذيين' : 'Non-Executive Members Ratio',
                      value: l.isArabic ? '4 من أصل 6 = 66.7%' : '4 out of 6 = 66.7%',
                      isArabic: l.isArabic,
                    ),
                  ),
                ],
              ),
        ],
      ),
    );
  }
}

class _RatioCard extends StatelessWidget {
  final String label;
  final String value;
  final bool isArabic;

  const _RatioCard({
    required this.label,
    required this.value,
    required this.isArabic,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: isArabic ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: double.infinity,
            child: Text(
              label,
              textAlign: isArabic ? TextAlign.right : TextAlign.left,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Color(0xFF6B7280),
              ),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: Directionality(
              textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
              child: Text(
                value,
                textAlign: isArabic ? TextAlign.right : TextAlign.left,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BoardMembersSection extends StatelessWidget {
  final AppLocalizations l;

  const _BoardMembersSection({required this.l});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _BoardMemberProfile(
          nameEn: 'Suleiman bin Mohammed Al-Saif',
          nameAr: 'سليمان بن محمد السيف',
          roles: [
            _MemberRole(
              labelEn: 'Chairman of the Board',
              labelAr: 'رئيس مجلس الإدارة',
              color: const Color(0xFFDC2626),
            ),
            _MemberRole(
              labelEn: 'Non-Executive',
              labelAr: 'غير تنفيذي',
              color: const Color(0xFF6B7280),
            ),
            _MemberRole(
              labelEn: 'Non-Independent',
              labelAr: 'غير مستقل',
              color: const Color(0xFF6B7280),
            ),
          ],
          nationalityEn: 'Saudi',
          nationalityAr: 'سعودي',
          appointmentDate: '12/09/1435هـ (09/07/2014م)',
          academicQualificationsEn: 'Certificate in Islamic Sciences, Scientific Institute, Riyadh, Kingdom of Saudi Arabia, 1974G',
          academicQualificationsAr: 'شهادة في العلوم الإسلامية، المعهد العلمي، الرياض، المملكة العربية السعودية، 1974م',
          currentPositions: [
            _Position(
              organizationEn: 'Al-Saif Stores for Development and Investment Company',
              organizationAr: 'شركة متاجر السيف للتنمية والاستثمار',
              positionEn: 'Chairman of the Board',
              positionAr: 'رئيس مجلس الإدارة',
              since: '2006م',
              sectorEn: 'Household Goods Retail',
              sectorAr: 'تجزئة السلع المنزلية',
            ),
            _Position(
              organizationEn: 'Nuwaa Real Estate Investment Company',
              organizationAr: 'شركة نواة للاستثمار العقاري',
              positionEn: 'Chairman of the Board',
              positionAr: 'رئيس مجلس الإدارة',
              since: '2017م',
              sectorEn: 'Real Estate Development',
              sectorAr: 'التطوير العقاري',
            ),
            _Position(
              organizationEn: 'Bait Al-Tasne\'a Al-Blastikia Company',
              organizationAr: 'شركة بيت التصنيع البلاستيكي',
              positionEn: 'Chairman of the Board',
              positionAr: 'رئيس مجلس الإدارة',
              since: '2015م',
              sectorEn: 'Plastic Manufacturing',
              sectorAr: 'تصنيع البلاستيك',
            ),
          ],
          previousExperience: [
            _Experience(
              organizationEn: 'Al-Saif Commercial Agencies Company',
              organizationAr: 'شركة السيف للوكالات التجارية',
              positionEn: 'Vice Chairman of the Board',
              positionAr: 'نائب رئيس مجلس الإدارة',
              from: '2018م',
              to: '2022م',
              sectorEn: 'Wholesale of Household Goods',
              sectorAr: 'تجارة الجملة للسلع المنزلية',
            ),
            _Experience(
              organizationEn: 'Al-Saif Commercial Agencies Company',
              organizationAr: 'شركة السيف للتوكيلات التجارية',
              positionEn: 'General Manager',
              positionAr: 'المدير العام',
              from: '1982م',
              to: '2017م',
              sectorEn: 'Wholesale of Household Goods',
              sectorAr: 'تجارة الجملة للسلع المنزلية',
            ),
            _Experience(
              organizationEn: 'International Trade',
              organizationAr: 'التجارة الدولية',
              positionEn: '—',
              positionAr: '—',
              from: '1975م',
              to: 'Ongoing',
              sectorEn: 'General Trade (Asia / Europe)',
              sectorAr: 'التجارة العامة (آسيا / أوروبا)',
            ),
          ],
          isArabic: l.isArabic,
        ),
        const SizedBox(height: 32),
        _BoardMemberProfile(
          nameEn: 'Mohammed bin Suleiman Al-Saif',
          nameAr: 'محمد بن سليمان السيف',
          roles: [
            _MemberRole(
              labelEn: 'Vice Chairman / Managing Director',
              labelAr: 'نائب الرئيس / العضو المنتدب',
              color: const Color(0xFFDC2626),
            ),
            _MemberRole(
              labelEn: 'Executive',
              labelAr: 'تنفيذي',
              color: const Color(0xFF6B7280),
            ),
            _MemberRole(
              labelEn: 'Non-Independent',
              labelAr: 'غير مستقل',
              color: const Color(0xFF6B7280),
            ),
          ],
          nationalityEn: 'Saudi',
          nationalityAr: 'سعودي',
          appointmentDate: '12/09/1435هـ (09/07/2014م)',
          academicQualificationsEn: 'Master of Science in Finance, University of Tampa, Florida, United States of America, 2011G\nBachelor\'s in Financial Management, King Saud University, Kingdom of Saudi Arabia, 2006G',
          academicQualificationsAr: 'ماجستير في العلوم المالية، جامعة تامبا، فلوريدا، الولايات المتحدة الأمريكية، 2011م\nبكالوريوس في الإدارة المالية، جامعة الملك سعود، المملكة العربية السعودية، 2006م',
          currentPositions: [
            _Position(
              organizationEn: 'Al-Saif Stores for Development and Investment Company',
              organizationAr: 'شركة متاجر السيف للتنمية والاستثمار',
              positionEn: 'Managing Director',
              positionAr: 'العضو المنتدب',
              since: '2014م',
              sectorEn: 'Household Goods Retail',
              sectorAr: 'تجزئة السلع المنزلية',
            ),
            _Position(
              organizationEn: 'Nuwaa Real Estate Investment Company',
              organizationAr: 'شركة نواة للاستثمار العقاري',
              positionEn: 'Co-Founder and Board Member',
              positionAr: 'شريك مؤسس وعضو مجلس إدارة',
              since: '2017م',
              sectorEn: 'Real Estate Development',
              sectorAr: 'التطوير العقاري',
            ),
          ],
          previousExperience: [
            _Experience(
              organizationEn: 'Al-Saif Stores for Development and Investment Company',
              organizationAr: 'شركة متاجر السيف للتنمية والاستثمار',
              positionEn: 'Chief Executive Officer',
              positionAr: 'الرئيس التنفيذي',
              from: '2012م',
              to: '2024م',
              sectorEn: 'Household Goods Retail',
              sectorAr: 'تجزئة السلع المنزلية',
            ),
            _Experience(
              organizationEn: 'Capital Market Authority (CMA)',
              organizationAr: 'هيئة السوق المالية',
              positionEn: 'Trainee',
              positionAr: 'متدرب',
              from: '2008م',
              to: '2011م',
              sectorEn: 'Capital Market Regulation',
              sectorAr: 'تنظيم السوق المالية',
            ),
            _Experience(
              organizationEn: 'Yaqeen Financial Services Company',
              organizationAr: 'شركة يقين للخدمات المالية',
              positionEn: 'Financial Analyst',
              positionAr: 'محلل مالي',
              from: '2006م',
              to: '2007م',
              sectorEn: 'Investment Banking Services',
              sectorAr: 'خدمات الاستثمار المصرفي',
            ),
          ],
          isArabic: l.isArabic,
        ),
        const SizedBox(height: 32),
        _BoardMemberProfile(
          nameEn: 'Haytham bin Suleiman Al-Saif',
          nameAr: 'هيثم بن سليمان السيف',
          roles: [
            _MemberRole(
              labelEn: 'Executive Vice Chairman and Member',
              labelAr: 'نائب الرئيس التنفيذي وعضو',
              color: const Color(0xFFDC2626),
            ),
            _MemberRole(
              labelEn: 'Executive',
              labelAr: 'تنفيذي',
              color: const Color(0xFF6B7280),
            ),
            _MemberRole(
              labelEn: 'Non-Independent',
              labelAr: 'غير مستقل',
              color: const Color(0xFF6B7280),
            ),
          ],
          nationalityEn: 'Saudi',
          nationalityAr: 'سعودي',
          appointmentDate: '12/09/1435هـ (09/07/2014م)',
          academicQualificationsEn: 'Master\'s in Islamic Policy, Higher Institute for the Judiciary, Kingdom of Saudi Arabia, 2012G\nBachelor\'s in Sharia, Imam Mohammed bin Saud Islamic University, Kingdom of Saudi Arabia, 2008G',
          academicQualificationsAr: 'ماجستير في السياسة الشرعية، المعهد العالي للقضاء، المملكة العربية السعودية، 2012م\nبكالوريوس في الشريعة، جامعة الإمام محمد بن سعود الإسلامية، المملكة العربية السعودية، 2008م',
          currentPositions: [
            _Position(
              organizationEn: 'Al-Saif Stores for Development and Investment Company',
              organizationAr: 'شركة متاجر السيف للتنمية والاستثمار',
              positionEn: 'Executive Vice Chairman and Board Member',
              positionAr: 'نائب الرئيس التنفيذي وعضو مجلس الإدارة',
              since: '2014م',
              sectorEn: 'Household Goods Retail',
              sectorAr: 'تجزئة السلع المنزلية',
            ),
            _Position(
              organizationEn: 'Nuwaa Real Estate Investment Company',
              organizationAr: 'شركة نواة للاستثمار العقاري',
              positionEn: 'Co-Founder and Board Member',
              positionAr: 'شريك مؤسس وعضو مجلس الإدارة',
              since: '2017م',
              sectorEn: 'Real Estate Development',
              sectorAr: 'التطوير العقاري',
            ),
            _Position(
              organizationEn: 'Thakaa Al-Yawm Medical Company (Wixana)',
              organizationAr: 'شركة ذكاء اليوم الطبية (ويكسانا)',
              positionEn: 'Co-Founder',
              positionAr: 'شريك مؤسس',
              since: '2019م',
              sectorEn: 'Medical Equipment & Supplies',
              sectorAr: 'المعدات والمستلزمات الطبية',
            ),
            _Position(
              organizationEn: 'Rushouf Trading Company',
              organizationAr: 'شركة رشوف للتجارة',
              positionEn: 'Co-Founder and Board Member',
              positionAr: 'شريك مؤسس وعضو مجلس الإدارة',
              since: '2019م',
              sectorEn: 'Honey Retail',
              sectorAr: 'تجزئة العسل',
            ),
            _Position(
              organizationEn: 'Naseelah Trading Company (Clara)',
              organizationAr: 'شركة نسيلة للتجارة (كلارا)',
              positionEn: 'Co-Founder',
              positionAr: 'شريك مؤسس',
              since: '2019م',
              sectorEn: 'Beauty & Home Appliances',
              sectorAr: 'أجهزة التجميل والعناية المنزلية',
            ),
          ],
          previousExperience: [
            _Experience(
              organizationEn: 'Al-Saif Stores for Development and Investment Company',
              organizationAr: 'شركة متاجر السيف للتنمية والاستثمار',
              positionEn: 'Marketing Director',
              positionAr: 'مدير التسويق',
              from: '2014م',
              to: '2023م',
              sectorEn: 'Household Goods Retail',
              sectorAr: 'تجزئة السلع المنزلية',
            ),
          ],
          isArabic: l.isArabic,
        ),
        const SizedBox(height: 32),
        _BoardMemberProfile(
          nameEn: 'Muhannad bin Suleiman Al-Saif',
          nameAr: 'مهند بن سليمان السيف',
          roles: [
            _MemberRole(
              labelEn: 'Member',
              labelAr: 'عضو',
              color: const Color(0xFFDC2626),
            ),
            _MemberRole(
              labelEn: 'Non-Executive',
              labelAr: 'غير تنفيذي',
              color: const Color(0xFF6B7280),
            ),
            _MemberRole(
              labelEn: 'Non-Independent',
              labelAr: 'غير مستقل',
              color: const Color(0xFF6B7280),
            ),
          ],
          nationalityEn: 'Saudi',
          nationalityAr: 'سعودي',
          appointmentDate: '12/09/1435هـ (09/07/2014م)',
          academicQualificationsEn: 'Bachelor\'s in Sharia, Imam Mohammed bin Saud Islamic University, Kingdom of Saudi Arabia, 2012G\nBusiness Administration Course Certificate, Indiana University, United States of America, 2012G',
          academicQualificationsAr: 'بكالوريوس في الشريعة، جامعة الإمام محمد بن سعود الإسلامية، المملكة العربية السعودية، 2012م\nشهادة دورة في إدارة الأعمال، جامعة إنديانا، الولايات المتحدة الأمريكية، 2012م',
          currentPositions: [
            _Position(
              organizationEn: 'Al-Saif Stores for Development and Investment Company',
              organizationAr: 'شركة متاجر السيف للتنمية والاستثمار',
              positionEn: 'Board Member and Audit Committee Member',
              positionAr: 'عضو مجلس الإدارة وعضو لجنة المراجعة',
              since: '2014م / 2021م',
              sectorEn: 'Household Goods Retail',
              sectorAr: 'تجزئة السلع المنزلية',
            ),
            _Position(
              organizationEn: 'Nuwaa Real Estate Investment Company',
              organizationAr: 'شركة نواة للاستثمار العقاري',
              positionEn: 'CEO and Board Member',
              positionAr: 'الرئيس التنفيذي وعضو مجلس الإدارة',
              since: '2017م',
              sectorEn: 'Real Estate Development',
              sectorAr: 'التطوير العقاري',
            ),
            _Position(
              organizationEn: 'Mishkati Lighting Company',
              organizationAr: 'شركة مشكاتي للإنارة',
              positionEn: 'Board Member',
              positionAr: 'عضو مجلس الإدارة',
              since: '2023م',
              sectorEn: 'Wholesale & Retail Lighting',
              sectorAr: 'تجارة الجملة والتجزئة للإنارة',
            ),
            _Position(
              organizationEn: 'Isnad Company',
              organizationAr: 'شركة إسناد',
              positionEn: 'Co-Founder and General Manager',
              positionAr: 'شريك مؤسس ومدير عام',
              since: '2019م',
              sectorEn: 'Transport & Logistics',
              sectorAr: 'النقل واللوجستيات',
            ),
          ],
          previousExperience: [
            _Experience(
              organizationEn: 'Al-Saif Stores for Development and Investment Company',
              organizationAr: 'شركة متاجر السيف للتنمية والاستثمار',
              positionEn: 'Development Manager',
              positionAr: 'مدير التطوير',
              from: '2014م',
              to: '2017م',
              sectorEn: 'Household Goods Retail',
              sectorAr: 'تجزئة السلع المنزلية',
            ),
            _Experience(
              organizationEn: 'Nuwaa Real Estate Investment Company',
              organizationAr: 'شركة نواة للاستثمار العقاري',
              positionEn: 'Deputy CEO',
              positionAr: 'نائب الرئيس التنفيذي',
              from: '2017م',
              to: '2023م',
              sectorEn: 'Real Estate Development',
              sectorAr: 'التطوير العقاري',
            ),
          ],
          isArabic: l.isArabic,
        ),
        const SizedBox(height: 32),
        _BoardMemberProfile(
          nameEn: 'Mohammed bin Saud Al-Zamil',
          nameAr: 'محمد بن سعود الزامل',
          roles: [
            _MemberRole(
              labelEn: 'Member',
              labelAr: 'عضو',
              color: const Color(0xFFDC2626),
            ),
            _MemberRole(
              labelEn: 'Non-Executive',
              labelAr: 'غير تنفيذي',
              color: const Color(0xFF6B7280),
            ),
            _MemberRole(
              labelEn: 'Independent',
              labelAr: 'مستقل',
              color: const Color(0xFF6B7280),
            ),
          ],
          nationalityEn: 'Saudi',
          nationalityAr: 'سعودي',
          appointmentDate: '23/05/1443هـ \u200F(27/12/2021م)\u200F',
          academicQualificationsEn: 'Certificate in International Wealth & Investment Management (CME4), 2024G\nCertified in Strategy and Competitive Analysis (CSCA), Institute of Management Accountants, USA, 2021G\nCertified Management Accountant (CMA), Institute of Management Accountants, USA, 2020G\nProject Management Professional (PMP), Project Management Institute, USA, 2017G\nExecutive Venture Investment Program License, UC Berkeley, USA, 2016G\nManagement Acceleration Program (MAP), INSEAD Business School, France, 2015G\nMaster\'s in Manufacturing Systems Engineering and Management, University of Warwick, United Kingdom, 2011G\nBachelor\'s in Chemical Engineering, King Saud University, Kingdom of Saudi Arabia, 2009G',
          academicQualificationsAr: '• الشهادة الدولية لإدارة الثروات والاستثمار CME4، عام 2024م\n• رخصة التحليل الاستراتيجي والمقارن CSCA، معهد المحاسبين الإداريين، الولايات المتحدة الأمريكية، عام 2021م\n• رخصة المحاسب الإداري المعتمد CMA، معهد المحاسبين الإداريين، الولايات المتحدة الأمريكية، عام 2020م\n• شهادة مدير المشاريع المحترف PMP، معهد إدارة المشاريع، الولايات المتحدة الأمريكية، عام 2017م\n• رخصة برنامج الاستثمار الجريء التنفيذي، جامعة كاليفورنيا بيركلي، الولايات المتحدة الأمريكية، عام 2016م\n• رخصة برنامج تسريع الإدارة MAP، كلية إنسياد للأعمال، فرنسا، عام 2015م\n• ماجستير في هندسة وإدارة نظم التصنيع، جامعة واروك، المملكة المتحدة، عام 2011م\n• بكالوريوس في الهندسة الكيميائية، جامعة الملك سعود، المملكة العربية السعودية، عام 2009م',
          currentPositions: [
            _Position(
              organizationEn: 'Al-Saif Stores for Development and Investment Company',
              organizationAr: 'شركة متاجر السيف للتنمية والاستثمار',
              positionEn: 'Independent Board Member, Chairman of N&R Committee, Audit Committee Member',
              positionAr: 'عضو مجلس إدارة مستقل، رئيس لجنة الترشيحات والمكافآت، عضو لجنة المراجعة',
              since: '2021م',
              sectorEn: 'Household Goods Retail',
              sectorAr: 'تجزئة السلع المنزلية',
            ),
            _Position(
              organizationEn: 'Al Arabiya Lil Oud Company',
              organizationAr: 'الشركة العربية للعود',
              positionEn: 'Audit Committee Member',
              positionAr: 'عضو لجنة المراجعة',
              since: '2024م',
              sectorEn: 'Oriental Perfumes & Designware',
              sectorAr: 'العطور الشرقية والتصاميم',
            ),
            _Position(
              organizationEn: 'Amnco Security & Safety Solutions Company',
              organizationAr: 'شركة أمنكو للحلول الأمنية والسلامة',
              positionEn: 'Chairman of the Board',
              positionAr: 'رئيس مجلس الإدارة',
              since: '2020م',
              sectorEn: 'Security & Safety Solutions',
              sectorAr: 'حلول الأمن والسلامة',
            ),
            _Position(
              organizationEn: 'Saudi Transport and Logistics Company (Mabrad)',
              organizationAr: 'الشركة السعودية للنقل والخدمات اللوجستية (مبرد)',
              positionEn: 'Chairman of the Board',
              positionAr: 'رئيس مجلس الإدارة',
              since: '2021م',
              sectorEn: 'Land Transport & Logistics',
              sectorAr: 'النقل البري واللوجستيات',
            ),
            _Position(
              organizationEn: 'BATC Real Estate Company',
              organizationAr: 'شركة باتك العقارية',
              positionEn: 'Board Member',
              positionAr: 'عضو مجلس الإدارة',
              since: '2020م',
              sectorEn: 'Real Estate Investment',
              sectorAr: 'الاستثمار العقاري',
            ),
            _Position(
              organizationEn: 'BATC Investment and Business Logistics Company',
              organizationAr: 'شركة باتك للاستثمار والاعمال اللوجستية',
              positionEn: 'Board Member and Managing Director',
              positionAr: 'عضو مجلس الإدارة والعضو المنتدب',
              since: '2020م',
              sectorEn: 'Investment, Security & Transport',
              sectorAr: 'الاستثمار والأمن والنقل',
            ),
            _Position(
              organizationEn: 'Amnco Facilities Management Company',
              organizationAr: 'شركة أمنكو لإدارة المرافق',
              positionEn: 'Chairman of the Board',
              positionAr: 'رئيس مجلس الإدارة',
              since: '2020م',
              sectorEn: 'Facilities Management',
              sectorAr: 'إدارة المرافق',
            ),
            _Position(
              organizationEn: 'Ibrahim Mohammed Al-Mana and Brothers Company',
              organizationAr: 'شركة إبراهيم محمد المانع وإخوانه',
              positionEn: 'Board Member and Audit Committee Member',
              positionAr: 'عضو مجلس الإدارة وعضو لجنة المراجعة',
              since: '2025م',
              sectorEn: 'Healthcare Sector',
              sectorAr: 'القطاع الصحي',
            ),
            _Position(
              organizationEn: 'King Saud University — Chemical Engineering Dept.',
              organizationAr: 'جامعة الملك سعود — قسم الهندسة الكيميائية',
              positionEn: 'Advisory Council Member',
              positionAr: 'عضو المجلس الاستشاري',
              since: '2020م',
              sectorEn: 'Higher Education',
              sectorAr: 'التعليم العالي',
            ),
            _Position(
              organizationEn: 'Sawatir Shade Structures Manufacturing Company',
              organizationAr: 'شركة سواتر لأعمال المظلات للصناعة',
              positionEn: 'Board Member',
              positionAr: 'عضو مجلس الإدارة',
              since: '2025م',
              sectorEn: 'Construction & Shading',
              sectorAr: 'الإنشاءات والتظليل',
            ),
          ],
          previousExperience: [
            _Experience(
              organizationEn: 'Jazal Investment Company',
              organizationAr: 'شركة جازل للاستثمار',
              positionEn: 'Chief Executive Officer',
              positionAr: 'الرئيس التنفيذي',
              from: '2019م',
              to: '2021م',
              sectorEn: 'Energy Manufacturing & Services',
              sectorAr: 'تصنيع وخدمات الطاقة',
            ),
            _Experience(
              organizationEn: 'Al-Wafa Industries Company',
              organizationAr: 'شركة الوفاء للصناعات',
              positionEn: 'Chief Executive Officer',
              positionAr: 'الرئيس التنفيذي',
              from: '2017م',
              to: '2019م',
              sectorEn: 'Automotive Parts Manufacturing',
              sectorAr: 'تصنيع قطع غيار السيارات',
            ),
            _Experience(
              organizationEn: 'Saudi Industrial Development Fund (SIDF)',
              organizationAr: 'صندوق التنمية الصناعية السعودي',
              positionEn: 'Senior Advisor and Deputy General Manager',
              positionAr: 'مستشار أول ومساعد المدير العام',
              from: '2009م',
              to: '2017م',
              sectorEn: 'Industrial Development & Support',
              sectorAr: 'التنمية والدعم الصناعي',
            ),
          ],
          isArabic: l.isArabic,
        ),
        const SizedBox(height: 32),
        _BoardMemberProfile(
          nameEn: 'Abdulmajeed bin Suleiman Al-Dakheel',
          nameAr: 'عبدالمجيد بن سليمان الدخيل',
          roles: [
            _MemberRole(
              labelEn: 'Member',
              labelAr: 'عضو',
              color: const Color(0xFFDC2626),
            ),
            _MemberRole(
              labelEn: 'Non-Executive',
              labelAr: 'غير تنفيذي',
              color: const Color(0xFF6B7280),
            ),
            _MemberRole(
              labelEn: 'Independent',
              labelAr: 'مستقل',
              color: const Color(0xFF6B7280),
            ),
          ],
          nationalityEn: 'Saudi',
          nationalityAr: 'سعودي',
          appointmentDate: '23/05/1443هـ \u200F(27/12/2021م)\u200F',
          academicQualificationsEn: 'Bachelor\'s in Accounting Sciences, Southern Utah University, United States of America, 2012G',
          academicQualificationsAr: 'بكالوريوس في علوم المحاسبة، جامعة جنوب يوتا، الولايات المتحدة الأمريكية، 2012م',
          currentPositions: [
            _Position(
              organizationEn: 'Al-Saif Stores for Development and Investment Company',
              organizationAr: 'شركة متاجر السيف للتنمية والاستثمار',
              positionEn: 'Independent Board Member and Audit Committee Chairman',
              positionAr: 'عضو مجلس إدارة مستقل ورئيس لجنة المراجعة',
              since: '2022م',
              sectorEn: 'Household Goods Retail',
              sectorAr: 'تجزئة السلع المنزلية',
            ),
            _Position(
              organizationEn: 'Al-Qahwa Al-Khashbiya Trading Company',
              organizationAr: 'شركة القهوة الخضراء التجارية',
              positionEn: 'Audit Committee Member',
              positionAr: 'عضو لجنة المراجعة',
              since: '2024م',
              sectorEn: 'Coffee Production',
              sectorAr: 'إنتاج القهوة',
            ),
            _Position(
              organizationEn: 'Asasiyyat Al-Tanmia for Agriculture and Trade Company',
              organizationAr: 'شركة أساسيات التنمية للزراعة والتجارة',
              positionEn: 'Audit Committee Chairman and Board Member',
              positionAr: 'رئيس لجنة المراجعة وعضو مجلس الإدارة',
              since: '2023م',
              sectorEn: 'Agriculture & Trade',
              sectorAr: 'الزراعة والتجارة',
            ),
            _Position(
              organizationEn: 'Jazan Development and Investment Companyy',
              organizationAr: 'شركة جازان للتطوير والاستثمار',
              positionEn: 'Audit Committee Member',
              positionAr: 'عضو لجنة المراجعة',
              since: '2022م',
              sectorEn: 'Agriculture',
              sectorAr: 'الزراعة',
            ),
            _Position(
              organizationEn: 'Saudi Venture Investment Company',
              organizationAr: 'الشركة السعودية للاستثمار الجريء',
              positionEn: 'Audit Committee Member',
              positionAr: 'عضو لجنة المراجعة',
              since: '2021م',
              sectorEn: 'Venture Investment',
              sectorAr: 'الاستثمار الجريء',
            ),
            _Position(
              organizationEn: 'ValuHub',
              organizationAr: 'شركة فالو هوب',
              positionEn: 'Partner',
              positionAr: 'شريك',
              since: '2020م',
              sectorEn: 'Technical Services',
              sectorAr: 'الخدمات التقنية',
            ),
          ],
          previousExperience: [
            _Experience(
              organizationEn: 'Al-Saif Stores for Development and Investment Company',
              organizationAr: 'شركة متاجر السيف للتنمية والاستثمار',
              positionEn: 'Nominations & Remuneration Committee Member',
              positionAr: 'عضو لجنة الترشيحات والمكافآت',
              from: 'March 2022م',
              to: 'September 2025م',
              sectorEn: 'Household Goods Retail',
              sectorAr: 'تجزئة السلع المنزلية',
            ),
            _Experience(
              organizationEn: 'BKF Al-Bassam & Partners Company',
              organizationAr: 'شركة بي كي إف البسام وشركاه',
              positionEn: 'Partner',
              positionAr: 'شريك',
              from: '2018م',
              to: '2020م',
              sectorEn: 'Legal Accounting',
              sectorAr: 'المحاسبة القانونية',
            ),
            _Experience(
              organizationEn: 'Ernst & Young and Partners',
              organizationAr: 'إرنست ويونغ وشركاهم',
              positionEn: 'Financial Advisor',
              positionAr: 'مستشار مالي',
              from: '2014م',
              to: '2018م',
              sectorEn: 'Audit & Assurance',
              sectorAr: 'مراجعة الحسابات',
            ),
            _Experience(
              organizationEn: 'Saudi Aramco Refinery (Jubail)',
              organizationAr: 'مصفاة أرامكو السعودية (الجبيل)',
              positionEn: 'Financial Accountant',
              positionAr: 'محاسب مالي',
              from: '2013م',
              to: '2014م',
              sectorEn: 'Crude Oil Refining',
              sectorAr: 'تكرير النفط الخام',
            ),
          ],
          isArabic: l.isArabic,
        ),
      ],
    );
  }
}

class _BoardMemberProfile extends StatelessWidget {
  final String nameEn;
  final String nameAr;
  final List<_MemberRole> roles;
  final String nationalityEn;
  final String nationalityAr;
  final String appointmentDate;
  final String academicQualificationsEn;
  final String academicQualificationsAr;
  final List<_Position> currentPositions;
  final List<_Experience> previousExperience;
  final bool isArabic;

  const _BoardMemberProfile({
    required this.nameEn,
    required this.nameAr,
    required this.roles,
    required this.nationalityEn,
    required this.nationalityAr,
    required this.appointmentDate,
    required this.academicQualificationsEn,
    required this.academicQualificationsAr,
    required this.currentPositions,
    required this.previousExperience,
    required this.isArabic,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Name
          Text(
            isArabic ? nameAr : nameEn,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 12),
          // Roles badges
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: roles.map((role) => _RoleBadge(role: role, isArabic: isArabic)).toList(),
          ),
          const SizedBox(height: 16),
          // Nationality and Date
          RichText(
            text: TextSpan(
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: Color(0xFF6B7280),
              ),
              children: [
                TextSpan(text: isArabic ? 'الجنسية: ' : 'Nationality: '),
                TextSpan(text: isArabic ? nationalityAr : nationalityEn),
                const TextSpan(text: ' | '),
                TextSpan(text: isArabic ? 'تاريخ التعيين: ' : 'Date of Appointment: '),
                if (isArabic)
                  WidgetSpan(child: _buildArabicAppointmentDate(appointmentDate))
                else
                  TextSpan(text: _formatAppointmentDate(appointmentDate, false)),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // Academic Qualifications
          Text(
            isArabic ? 'المؤهلات الأكاديمية:' : 'Academic Qualifications:',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: Text(
              isArabic ? academicQualificationsAr : academicQualificationsEn,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: Color(0xFF4B5563),
                height: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 24),
          // Current Positions
          Text(
            isArabic ? 'المناصب الحالية:' : 'Current Positions:',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 12),
          _PositionsTable(positions: currentPositions, isArabic: isArabic),
          const SizedBox(height: 24),
          // Previous Experience
          Text(
            isArabic ? 'الخبرات المهنية السابقة:' : 'Key Previous Professional Experience:',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 12),
          _ExperienceTable(experiences: previousExperience, isArabic: isArabic),
        ],
      ),
    );
  }
}

class _MemberRole {
  final String labelEn;
  final String labelAr;
  final Color color;

  const _MemberRole({
    required this.labelEn,
    required this.labelAr,
    required this.color,
  });
}

class _RoleBadge extends StatelessWidget {
  final _MemberRole role;
  final bool isArabic;

  const _RoleBadge({required this.role, required this.isArabic});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: role.color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        isArabic ? role.labelAr : role.labelEn,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: role.color,
        ),
      ),
    );
  }
}

class _Position {
  final String organizationEn;
  final String organizationAr;
  final String positionEn;
  final String positionAr;
  final String since;
  final String sectorEn;
  final String sectorAr;

  const _Position({
    required this.organizationEn,
    required this.organizationAr,
    required this.positionEn,
    required this.positionAr,
    required this.since,
    required this.sectorEn,
    required this.sectorAr,
  });
}

class _PositionsTable extends StatelessWidget {
  final List<_Position> positions;
  final bool isArabic;

  const _PositionsTable({required this.positions, required this.isArabic});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFE5E7EB)),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              color: Color(0xFFF3F4F6),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(6),
                topRight: Radius.circular(6),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    isArabic ? 'الجهة' : 'Organization',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF374151),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: Text(
                    isArabic ? 'المنصب' : 'Position',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF374151),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 1,
                  child: Text(
                    isArabic ? 'منذ' : 'Since',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF374151),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: Text(
                    isArabic ? 'القطاع' : 'Sector',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF374151),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Rows
          ...positions.asMap().entries.map((entry) {
            final index = entry.key;
            final position = entry.value;
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: index.isEven ? Colors.white : const Color(0xFFFAFAFA),
                border: Border(
                  bottom: index < positions.length - 1
                      ? const BorderSide(color: Color(0xFFE5E7EB))
                      : BorderSide.none,
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3,
                    child: Text(
                      isArabic ? position.organizationAr : position.organizationEn,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: Text(
                      isArabic ? position.positionAr : position.positionEn,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 1,
                    child: Text(
                      '\u200E${_translateMonth(position.since, isArabic)}\u200E',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: Text(
                      isArabic ? position.sectorAr : position.sectorEn,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _Experience {
  final String organizationEn;
  final String organizationAr;
  final String positionEn;
  final String positionAr;
  final String from;
  final String to;
  final String sectorEn;
  final String sectorAr;

  const _Experience({
    required this.organizationEn,
    required this.organizationAr,
    required this.positionEn,
    required this.positionAr,
    required this.from,
    required this.to,
    required this.sectorEn,
    required this.sectorAr,
  });
}

class _ExperienceTable extends StatelessWidget {
  final List<_Experience> experiences;
  final bool isArabic;

  const _ExperienceTable({required this.experiences, required this.isArabic});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFE5E7EB)),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              color: Color(0xFFF3F4F6),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(6),
                topRight: Radius.circular(6),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 4,
                  child: Text(
                    isArabic ? 'الجهة' : 'Organization',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF374151),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 3,
                  child: Text(
                    isArabic ? 'المنصب' : 'Position',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF374151),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: Text(
                    isArabic ? 'إلى' : 'From',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF374151),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: Text(
                    isArabic ? 'من' : 'To',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF374151),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 3,
                  child: Text(
                    isArabic ? 'القطاع' : 'Sector',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF374151),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Rows
          ...experiences.asMap().entries.map((entry) {
            final index = entry.key;
            final exp = entry.value;
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: index.isEven ? Colors.white : const Color(0xFFFAFAFA),
                border: Border(
                  bottom: index < experiences.length - 1
                      ? const BorderSide(color: Color(0xFFE5E7EB))
                      : BorderSide.none,
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 4,
                    child: Text(
                      isArabic ? exp.organizationAr : exp.organizationEn,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 3,
                    child: Text(
                      isArabic ? exp.positionAr : exp.positionEn,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: Text(
                      _translateMonth(isArabic ? exp.to : exp.from, isArabic),
                      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: Text(
                      _translateMonth(isArabic ? exp.from : exp.to, isArabic),
                      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 3,
                    child: Text(
                      isArabic ? exp.sectorAr : exp.sectorEn,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
