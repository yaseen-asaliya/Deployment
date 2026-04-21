import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/app_localizations.dart';
import '../utils/responsive.dart';

class BrandPortfolioDialog extends StatelessWidget {
  const BrandPortfolioDialog({super.key});

  static void show(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (context) => const BrandPortfolioDialog(),
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
                        l.isArabic ? 'محفظة العلامات التجارية' : 'Brand Portfolio',
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
                      // Introduction
                      Text(
                        l.isArabic
                            ? 'تمتلك الشركة محفظة متنوعة من العلامات التجارية تضم علامات ملكية وعلامات دولية موزعة عبر شبكة صالات العرض. تغطي المحفظة فئات متعددة، بما في ذلك الأجهزة المنزلية وأدوات المطبخ. خلال السنة المالية 2025، أضافت الشركة علامات تجارية رئيسية لمجموعة الأجهزة المنزلية الصغيرة في نطاقها المتميز، مدعومة بالموثوقية والضمان وتوافر قطع الغيار.'
                            : 'The Company holds a diversified portfolio of brands comprising both proprietary and international brands distributed through its showroom network. This portfolio covers multiple categories, including household essentials and kitchen appliances. During the fiscal year 2025, the Company added major kitchen appliances to its product range, supported by delivery, installation, warranty, and spare parts availability services.',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF6B7280),
                          height: 1.6,
                        ),
                      ),
                      const SizedBox(height: 32),
                      // Proprietary Brands
                      Text(
                        l.isArabic ? 'العلامات التجارية الملكية' : 'Proprietary Brands',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFFE7000B),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l.isArabic ? 'الأجهزة المنزلية وأدوات المطبخ' : 'Home Appliances and Kitchen Tools',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                      const SizedBox(height: 20),
                      _BrandGrid(
                        brands: [
                          _BrandCard(
                            nameEn: 'EDISON',
                            nameAr: 'إديسون',
                            descriptionEn: 'Small and large home appliances designed to meet everyday household usage requirements, including products dedicated to traditional cuisine preparation.',
                            descriptionAr: 'أجهزة منزلية صغيرة وكبيرة مصممة لتلبية متطلبات الاستخدام المنزلي اليومي، بما في ذلك منتجات مخصصة لتحضير المأكولات التقليدية.',
                            logoPath: 'assets/images/EDISON.jpeg',
                            backgroundColor: const Color(0xFFF9FAFB),
                          ),
                          _BrandCard(
                            nameEn: 'TORNADO',
                            nameAr: 'تورنادو',
                            descriptionEn: 'A diverse range of kitchen tools designed for daily food preparation and cooking.',
                            descriptionAr: 'مجموعة متنوعة من أدوات المطبخ المصممة لتحضير الطعام والطهي اليومي.',
                            logoPath: 'assets/images/TORNADO.jpeg',
                            backgroundColor: Colors.white,
                          ),
                          _BrandCard(
                            nameEn: 'ROCKY',
                            nameAr: 'روكي',
                            descriptionEn: 'Cookware and preparation tools engineered for safe use, distinguished by their durability.',
                            descriptionAr: 'أدوات الطهي والتحضير المصممة للاستخدام الآمن، وتتميز بمتانتها.',
                            logoPath: 'assets/images/ROCKY.jpeg',
                            backgroundColor: const Color(0xFFF9FAFB),
                          ),
                          _BrandCard(
                            nameEn: 'ROBUST',
                            nameAr: 'روبست',
                            descriptionEn: 'Serving and kitchen tools designed for home use, with an emphasis on durability and practical functionality.',
                            descriptionAr: 'أدوات التقديم والمطبخ المصممة للاستخدام المنزلي، مع التركيز على المتانة والوظائف العملية.',
                            logoPath: 'assets/images/ROBUST.jpeg',
                            backgroundColor: const Color(0xFFF9FAFB),
                          ),
                        ],
                        isArabic: l.isArabic,
                      ),
                      const SizedBox(height: 32),
                      // Two sections side by side
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final isMobile = constraints.maxWidth < 900;
                          if (isMobile) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _StorageBrandsSection(isArabic: l.isArabic),
                                const SizedBox(height: 32),
                                _InternationalBrandsSection(isArabic: l.isArabic),
                              ],
                            );
                          } else {
                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(child: _StorageBrandsSection(isArabic: l.isArabic)),
                                const SizedBox(width: 32),
                                Expanded(child: _InternationalBrandsSection(isArabic: l.isArabic)),
                              ],
                            );
                          }
                        },
                      ),
                      const SizedBox(height: 24),
                      // Note
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Color(0xFFefddcd),
                            border: Border(
                              left: BorderSide(color: Color(0xFFC62030), width: 4),
                            ),
                          ),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            decoration: const BoxDecoration(
                              border: Border(
                                top: BorderSide(color: Color(0xFFefddcd), width: 1),
                                right: BorderSide(color: Color(0xFFefddcd), width: 1),
                                bottom: BorderSide(color: Color(0xFFefddcd), width: 1),
                              ),
                            ),
                            child: Text.rich(
                              TextSpan(
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xFF364153),
                                  height: 1.5,
                                ),
                                children: [
                                  TextSpan(
                                    text: l.isArabic ? 'ملاحظة: ' : 'Note: ',
                                    style: const TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                  TextSpan(
                                    text: l.isArabic
                                        ? 'جميع العلامات التجارية الملكية (إديسون، تورنادو، روكي، روبست) مصممة ومحددة للأسر السعودية، مع ما يقرب من 80٪ من إيراداتنا المتدفقة من خلال العلامات التجارية الملكية والحصرية.'
                                        : 'All proprietary brands (Edison, Tornado, Rocky, Robust) are designed and specified for Saudi households, with approximately 80% of our revenue flowing through brands we own or exclusively distribute.',
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
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

class _BrandCard {
  final String nameEn;
  final String nameAr;
  final String descriptionEn;
  final String descriptionAr;
  final String logoPath;
  final Color backgroundColor;

  const _BrandCard({
    required this.nameEn,
    required this.nameAr,
    required this.descriptionEn,
    required this.descriptionAr,
    required this.logoPath,
    this.backgroundColor = const Color(0xFFF9FAFB),
  });
}

class _BrandGrid extends StatelessWidget {
  final List<_BrandCard> brands;
  final bool isArabic;

  const _BrandGrid({required this.brands, required this.isArabic});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 600;
        
        if (isMobile) {
          return Column(
            children: brands.map((brand) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _buildBrandCard(brand),
              );
            }).toList(),
          );
        } else {
          return Column(
            children: [
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(child: _buildBrandCard(brands[0])),
                    const SizedBox(width: 16),
                    Expanded(child: _buildBrandCard(brands[1])),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(child: _buildBrandCard(brands[2])),
                    const SizedBox(width: 16),
                    Expanded(child: _buildBrandCard(brands[3])),
                  ],
                ),
              ),
            ],
          );
        }
      },
    );
  }

  Widget _buildBrandCard(_BrandCard brand) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: brand.backgroundColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            brand.logoPath,
            height: 40,
            fit: BoxFit.contain,
            alignment: Alignment.centerLeft,
            errorBuilder: (context, error, stackTrace) {
              return Text(
                isArabic ? brand.nameAr : brand.nameEn,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFFE7000B),
                ),
              );
            },
          ),
          const SizedBox(height: 12),
          Text(
            isArabic ? brand.descriptionAr : brand.descriptionEn,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: Color(0xFF6B7280),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _StorageBrandsSection extends StatelessWidget {
  final bool isArabic;

  const _StorageBrandsSection({required this.isArabic});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isArabic ? 'علامات التخزين والتقديم وإكسسوارات الضيافة' : 'Storage, Serving, and Hospitality Accessory Brands',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1A1A1A),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          isArabic
              ? 'تشمل محفظة الشركة عدداً من العلامات التجارية المتخصصة في التخزين والتقديم وإكسسوارات الضيافة المنزلية. وتشمل هذه العلامات:'
              : 'The Company\'s portfolio includes a number of branded lines specialized in vacuum flasks, serving ware, and beverage accessories for domestic hospitality use. These brands include:',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Color(0xFF6B7280),
            height: 1.6,
          ),
        ),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, constraints) {
            final brands = [
              'Everest',
              'Timeless',
              'Elegance',
              'Royal',
              'Lima',
              'Falcon',
              'Rain',
              'Glory',
            ];
            
            return Wrap(
              spacing: 12,
              runSpacing: 12,
              children: brands.map((brand) {
                return SizedBox(
                  width: (constraints.maxWidth - 12) / 2,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF9FAFB),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: const Color(0xFFE5E7EB)),
                    ),
                    child: Text(
                      brand,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF101828),
                      ),
                    ),
                  ),
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }
}

class _InternationalBrandsSection extends StatelessWidget {
  final bool isArabic;

  const _InternationalBrandsSection({required this.isArabic});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isArabic ? 'الشراكات والعلامات الدولية' : 'International Partnerships and Brands',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1A1A1A),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          isArabic
              ? 'تشمل محفظة المنتجات بالإضافة إلى ذلك علامات تجارية دولية موزعة من خلال صالات عرض الشركة.'
              : 'The product portfolio additionally includes international brands distributed through the Company\'s showrooms.',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Color(0xFF6B7280),
            height: 1.6,
          ),
        ),
        const SizedBox(height: 16),
        _InternationalBrandsTable(isArabic: isArabic),
      ],
    );
  }
}

class _TwoColumnList extends StatelessWidget {
  final List<String> items;
  final bool isArabic;

  const _TwoColumnList({required this.items, required this.isArabic});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 600;
        final columnCount = isMobile ? 1 : 2;
        final itemsPerColumn = (items.length / columnCount).ceil();

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(columnCount, (columnIndex) {
            final startIndex = columnIndex * itemsPerColumn;
            final endIndex = (startIndex + itemsPerColumn).clamp(0, items.length);
            final columnItems = items.sublist(startIndex, endIndex);

            return Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: columnItems.map((item) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Text(
                      item,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                  );
                }).toList(),
              ),
            );
          }),
        );
      },
    );
  }
}

class _InternationalBrandsTable extends StatelessWidget {
  final bool isArabic;

  const _InternationalBrandsTable({required this.isArabic});

  @override
  Widget build(BuildContext context) {
    final brands = [
      {'brand': 'Markutec', 'country': isArabic ? 'ألمانيا' : 'Germany'},
      {'brand': 'Helios', 'country': isArabic ? 'ألمانيا' : 'Germany'},
      {'brand': 'Hascevher', 'country': isArabic ? 'تركيا' : 'Turkey'},
      {'brand': 'Falez', 'country': isArabic ? 'تركيا' : 'Turkey'},
    ];

    return Column(
      children: [
        // Header
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFE7000B),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  isArabic ? 'العلامة التجارية' : 'Brand',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  isArabic ? 'بلد المنشأ' : 'Country of Origin',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        // Brand rows as separate boxes
        ...brands.map((brand) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFF9FAFB),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      brand['brand']!,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF101828),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      brand['country']!,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF364153),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }
}
