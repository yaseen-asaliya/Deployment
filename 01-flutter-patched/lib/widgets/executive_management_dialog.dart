import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/app_localizations.dart';
import '../utils/responsive.dart';

String _formatDateRange(String dateRange, bool isArabic) {
  // For English, replace م with G and هـ with H
  if (!isArabic) {
    return dateRange.replaceAll('م', 'G').replaceAll('هـ', 'H');
  }
  
  // For Arabic: reverse the dates and add LRM marks
  // "2018م — 2024م" becomes "2024م — 2018م"
  final parts = dateRange.split(RegExp(r'\s*[—–-]\s*'));
  
  if (parts.length == 2) {
    // Add LRM (Left-to-Right Mark) around each part to prevent reordering
    return '\u200E${parts[1].trim()}\u200E — \u200E${parts[0].trim()}\u200E';
  }
  
  return dateRange;
}

String _translateYear(String year, bool isArabic) {
  if (!isArabic) {
    // Replace Arabic text with English
    year = year.replaceAll('حتى تاريخه', 'to date');
    year = year.replaceAll('م', 'G').replaceAll('هـ', 'H');
  }
  return year;
}

class ExecutiveManagementDialog extends StatelessWidget {
  const ExecutiveManagementDialog({super.key});

  static void show(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (context) => const ExecutiveManagementDialog(),
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
                        l.isArabic ? 'الإدارة التنفيذية العليا' : 'Senior Executive Management',
                        style: const TextStyle(
                          fontSize: 21,
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
                      _ExecutiveProfile(
                        nameEn: 'Ahmad bin Saleh bin Mohammed Al-Sultan',
                        nameAr: 'أحمد بن صالح بن محمد السلطان',
                        titleEn: 'Chief Executive Officer (CEO)',
                        titleAr: 'الرئيس التنفيذي',
                        appointedYear: '2024م',
                        nationalityEn: 'Saudi',
                        nationalityAr: 'سعودي',
                        academicQualificationsEn: 'Master of Business Administration, Brunel University, United Kingdom, 2010G\nBachelor\'s in Finance, Qassim University, Kingdom of Saudi Arabia, 2006G',
                        academicQualificationsAr: 'ماجستير في إدارة الأعمال، جامعة برونيل، المملكة المتحدة، 2010م\nبكالوريوس في المالية، جامعة القصيم، المملكة العربية السعودية، 2006م',
                        currentPositions: [
                          _Position(
                            organizationEn: 'Cenomi Retail',
                            organizationAr: 'سينومي ريتيل',
                            positionEn: 'Board Member and Audit Committee Member',
                            positionAr: 'عضو مجلس الإدارة وعضو لجنة المراجعة',
                            since: '2023م',
                            sectorEn: 'Wholesale & Retail of Clothing & Furniture',
                            sectorAr: 'تجارة الجملة والتجزئة للملابس والأثاث',
                          ),
                        ],
                        previousExperience: [
                          _Experience(
                            organizationEn: 'Thob Al-Aseel Company',
                            organizationAr: 'شركة ثوب الأصيل',
                            positionEn: 'Chief Executive Officer',
                            positionAr: 'الرئيس التنفيذي',
                            from: '2018م',
                            to: '2024م',
                            sectorEn: 'Premium Consumer Goods',
                            sectorAr: 'السلع الاستهلاكية الفاخرة',
                          ),
                          _Experience(
                            organizationEn: 'Al-Saif Stores for Development and Investment Company',
                            organizationAr: 'شركة متاجر السيف للتنمية والاستثمار',
                            positionEn: 'Executive Committee Member and Board Member',
                            positionAr: 'عضو اللجنة التنفيذية وعضو مجلس الإدارة',
                            from: '2021م',
                            to: '2024م',
                            sectorEn: 'Household Goods Retail',
                            sectorAr: 'تجزئة السلع المنزلية',
                          ),
                          _Experience(
                            organizationEn: 'Nusk Commercial Projects Company',
                            organizationAr: 'شركة نسك للمشاريع التجارية',
                            positionEn: 'Executive Vice President',
                            positionAr: 'نائب الرئيس التنفيذي',
                            from: '2012م',
                            to: '2018م',
                            sectorEn: 'International Fashion',
                            sectorAr: 'الأزياء العالمية',
                          ),
                          _Experience(
                            organizationEn: 'Nusk Commercial Projects Company',
                            organizationAr: 'شركة نسك للمشاريع التجارية',
                            positionEn: 'Operations Manager',
                            positionAr: 'مدير العمليات',
                            from: '2010م',
                            to: '2012م',
                            sectorEn: 'International Fashion',
                            sectorAr: 'الأزياء العالمية',
                          ),
                        ],
                        isArabic: l.isArabic,
                      ),
                      const SizedBox(height: 32),
                      _ExecutiveProfile(
                        nameEn: 'Mu\'ataz Ali Al-Ashqar',
                        nameAr: 'معتز علي الأشقر',
                        titleEn: 'Chief Financial Officer (CFO)',
                        titleAr: 'المدير المالي التنفيذي',
                        appointedYear: '2025م',
                        nationalityEn: 'Jordanian',
                        nationalityAr: 'أردني',
                        academicQualificationsEn: 'Bachelor\'s in Accounting, Applied Sciences University, Hashemite Kingdom of Jordan, 2001',
                        academicQualificationsAr: 'بكالوريوس في المحاسبة، جامعة العلوم التطبيقية، المملكة الأردنية الهاشمية، 2001م',
                        currentPositions: [
                          _Position(
                            organizationEn: 'Al Saif Gallery',
                            organizationAr: 'السيف غاليري',
                            positionEn: 'Chief Financial Officer',
                            positionAr: 'المدير المالي',
                            since: '2021م — حتى تاريخه',
                            sectorEn: 'Household Goods Retail',
                            sectorAr: 'تجزئة السلع المنزلية',
                          ),
                        ],
                        previousExperience: [
                          _Experience(
                            organizationEn: 'Tri Spectrum Company',
                            organizationAr: 'شركة تراي سبكتروم',
                            positionEn: 'CFO',
                            positionAr: 'المدير المالي',
                            from: '2019م',
                            to: '2021م',
                            sectorEn: 'Specialized in electrical building products',
                            sectorAr: 'متخصصة في بناء المنتجات الكهربائية',
                          ),
                          _Experience(
                            organizationEn: 'Al-Mazraa Dairy Company',
                            organizationAr: 'شركة ألبان المزرعة',
                            positionEn: 'CFO',
                            positionAr: 'المدير المالي',
                            from: '2018م',
                            to: '2019م',
                            sectorEn: 'Specialized in dairy and cheese products',
                            sectorAr: 'متخصصة في منتجات الألبان والأجبان',
                          ),
                          _Experience(
                            organizationEn: 'Abu Quffara Holding Group',
                            organizationAr: 'مجموعة أبو قفرة القابضة',
                            positionEn: 'CFO',
                            positionAr: 'المدير المالي',
                            from: '2016م',
                            to: '2018م',
                            sectorEn: 'Operating in contracting and building materials',
                            sectorAr: 'تعمل في المقاولات ومواد البناء',
                          ),
                          _Experience(
                            organizationEn: 'Freto Lays Pepsi',
                            organizationAr: 'شركة بيبسي',
                            positionEn: 'CFO',
                            positionAr: 'المدير المالي',
                            from: '2014م',
                            to: '2016م',
                            sectorEn: 'Food Products Company',
                            sectorAr: 'شركة منتجات غذائية',
                          ),
                          _Experience(
                            organizationEn: 'National Integrated Industries Complex',
                            organizationAr: 'المجمع الوطني المتكامل للصناعات',
                            positionEn: 'Head of Accounting',
                            positionAr: 'رئيس قسم المحاسبة',
                            from: '2009م',
                            to: '2012م',
                            sectorEn: 'Specialized in manufacturing air conditioners, washing machines, and refrigerators',
                            sectorAr: 'متخصص في تصنيع المكيفات وغسالات الملابس والثلاجات',
                          ),
                          _Experience(
                            organizationEn: 'BASF',
                            organizationAr: 'باسف',
                            positionEn: 'Senior Accountant',
                            positionAr: 'محاسب رئيسي',
                            from: '2001م',
                            to: '2008م',
                            sectorEn: 'Global construction chemicals company',
                            sectorAr: 'شركة عالمية في كيماويات البناء',
                          ),
                        ],
                        isArabic: l.isArabic,
                      ),
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

class _ExecutiveProfile extends StatelessWidget {
  final String nameEn;
  final String nameAr;
  final String titleEn;
  final String titleAr;
  final String appointedYear;
  final String nationalityEn;
  final String nationalityAr;
  final String academicQualificationsEn;
  final String academicQualificationsAr;
  final List<_Position> currentPositions;
  final List<_Experience> previousExperience;
  final bool isArabic;

  const _ExecutiveProfile({
    required this.nameEn,
    required this.nameAr,
    required this.titleEn,
    required this.titleAr,
    required this.appointedYear,
    required this.nationalityEn,
    required this.nationalityAr,
    required this.academicQualificationsEn,
    required this.academicQualificationsAr,
    required this.currentPositions,
    required this.previousExperience,
    required this.isArabic,
  });

  @override
  Widget build(BuildContext context) {
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
              fontSize: 19,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 12),
          // Title and Appointed Year
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFDC2626).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  isArabic ? titleAr : titleEn,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFDC2626),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '${isArabic ? 'تم التعيين' : 'Appointed'}: ${_translateYear(appointedYear, isArabic)}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Nationality
          Text(
            '${isArabic ? 'الجنسية' : 'Nationality'}: ${isArabic ? nationalityAr : nationalityEn}',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Color(0xFF6B7280),
            ),
          ),
          const SizedBox(height: 24),
          // Academic Qualifications
          Text(
            isArabic ? 'المؤهلات الأكاديمية:' : 'Academic Qualifications:',
            style: const TextStyle(
              fontSize: 15,
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
                fontSize: 14,
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
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 12),
          ...currentPositions.map((position) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _PositionItem(position: position, isArabic: isArabic),
              )),
          const SizedBox(height: 12),
          // Previous Experience
          Text(
            isArabic ? 'الخبرات المهنية السابقة:' : 'Key Previous Professional Experience:',
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 12),
          ...previousExperience.map((exp) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _ExperienceItem(experience: exp, isArabic: isArabic),
              )),
        ],
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

class _PositionItem extends StatelessWidget {
  final _Position position;
  final bool isArabic;

  const _PositionItem({required this.position, required this.isArabic});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      height: 1.5,
                    ),
                    children: [
                      TextSpan(
                        text: '${isArabic ? 'الجهة' : 'Organization'}: ',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                      TextSpan(
                        text: isArabic ? position.organizationAr : position.organizationEn,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      height: 1.5,
                    ),
                    children: [
                      TextSpan(
                        text: '${isArabic ? 'المنصب' : 'Position'}: ',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                      TextSpan(
                        text: isArabic ? position.positionAr : position.positionEn,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF6B7280),
                      height: 1.5,
                    ),
                    children: [
                      TextSpan(
                        text: '${isArabic ? 'منذ' : 'Since'}: ',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      TextSpan(
                        text: _translateYear(position.since, isArabic),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF6B7280),
                      height: 1.5,
                    ),
                    children: [
                      TextSpan(
                        text: '${isArabic ? 'القطاع' : 'Sector'}: ',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      TextSpan(
                        text: isArabic ? position.sectorAr : position.sectorEn,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
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

class _ExperienceItem extends StatelessWidget {
  final _Experience experience;
  final bool isArabic;

  const _ExperienceItem({required this.experience, required this.isArabic});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  isArabic ? experience.organizationAr : experience.organizationEn,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
              ),
              // Build date range - separate numbers and letters
              Builder(
                builder: (context) {
                  if (!isArabic) {
                    return Text(
                      _formatDateRange('${experience.from} — ${experience.to}', isArabic),
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF6B7280),
                      ),
                    );
                  }
                  
                  // For Arabic: build manually - older on right, newer on left
                  final toNum = experience.to.replaceAll(RegExp(r'[^\d]'), '');
                  final fromNum = experience.from.replaceAll(RegExp(r'[^\d]'), '');
                  
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Older date on right (from)
                      Text(fromNum, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: Color(0xFF6B7280))),
                      const Text('م', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: Color(0xFF6B7280))),
                      const Text(' — ', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: Color(0xFF6B7280))),
                      // Newer date on left (to)
                      Text(toNum, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: Color(0xFF6B7280))),
                      const Text('م', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: Color(0xFF6B7280))),
                    ],
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 8),
          RichText(
            text: TextSpan(
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Color(0xFF4B5563),
                height: 1.5,
              ),
              children: [
                TextSpan(
                  text: '${isArabic ? 'المنصب' : 'Position'}: ',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                TextSpan(
                  text: isArabic ? experience.positionAr : experience.positionEn,
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          RichText(
            text: TextSpan(
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Color(0xFF4B5563),
                height: 1.5,
              ),
              children: [
                TextSpan(
                  text: '${isArabic ? 'القطاع' : 'Sector'}: ',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                TextSpan(
                  text: isArabic ? experience.sectorAr : experience.sectorEn,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
