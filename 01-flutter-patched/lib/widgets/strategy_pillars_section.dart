import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../utils/responsive.dart';
import '../main.dart';

class StrategyPillarsSection extends StatefulWidget {
  const StrategyPillarsSection({super.key});
  @override
  State<StrategyPillarsSection> createState() => _StrategyPillarsSectionState();
}

class _StrategyPillarsSectionState extends State<StrategyPillarsSection> {
  @override
  void initState() { super.initState(); localeProvider.addListener(_rebuild); }
  void _rebuild() { if (mounted) setState(() {}); }
  @override
  void dispose() { localeProvider.removeListener(_rebuild); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final isArabic = localeProvider.isArabic;
    final hPad = Responsive.getHorizontalPadding(context);

    final pillars = [
      _Pillar(
        icon: 'assets/images/brands.svg',
        pillarLabel: isArabic ? 'الركيزة الأولى' : 'Pillar 1',
        title: isArabic ? 'الريادة عبر العلامات التجارية الخاصة' : 'Proprietary Brand Leadership',
        paragraphs: isArabic ? [
          'تأتي نحو \u200E88%\u200F من إيراداتنا من علامات تجارية نملكها أو نوزّعها حصرياً. ليس ذلك نتاج مصادفة تاريخية، بل خيار استراتيجي مقصود حافظنا عليه بانضباط على مدى عقود. علاماتنا المملوكة، إيدسون وتورنادو وروبست وروكي وإيفرست وإيليغانس وليما وراين وتايم ليس ورويال وفالكون وغلوري، تطورت من خلال علاقات مباشرة مع المصنّعين في الصين وكوريا وأسواق التوريد الأخرى. نُحكم المواصفة ونُحكم معايير الجودة ونُحكم شروط الضمان. هذا التحكم يُنتج هوامش ربح على المنتجات الخاصة تتفوق على نموذج البيع بالتجزئة التقليدي، ويخلق ميزة تنافسية يصعب تقليدها.',
          'في عام 2025، وسعنا علامة إيدسون إلى فئة الأجهزة المطبخية الكبيرة، مرسّخةً مكانتها بوصفها العلامة الأكثر شهرة في مجال الأجهزة المنزلية بالمملكة، وصانعةً ولاءً متعدد الفئات. ويركّز مسار الابتكار المستمر لدينا على تطويع مواصفات المنتجات لتقاليد الطبخ السعودي، بما في ذلك المعدات المصمّمة للتجمعات العائلية وموسم رمضان والضيافة الأصيلة.',
        ] : [
          'Approximately 88% of our revenue flows through brands we own or exclusively distribute. This is not an accident of history. It is a deliberate strategic choice, maintained over decades of discipline. Our owned brands (Edison, Tornado, Robust, Thunder, Elegance, Lorena, Növ, Tolmeta, Royal Falcon, and Glory) are designed through direct relationships with manufacturing partners in China, Korea, and other sourcing markets. We control the specification. We control the quality standards. We control the post-sale warranty terms. That control produces gross margins on proprietary products that outperform the standard wholesale retail model and builds a competitive moat that cannot be easily copied.',
          'In 2025, we extended the Edison brand into large kitchen appliances, reinforcing its position as Saudi Arabia\'s most recognized household name and creating cross-category customer loyalty. Our ongoing innovation pipeline focuses on localizing product specifications for Saudi cooking traditions, including equipment designed for large-family gatherings, Ramadan seasonality, and the hospitality customs central to Saudi culture.',
        ],
      ),
      _Pillar(
        icon: 'assets/images/investors.svg',
        pillarLabel: isArabic ? 'الركيزة الثانية' : 'Pillar 2',
        title: isArabic ? 'جودة شبكة الفروع وإنتاجيتها' : 'Store Network Quality and Productivity',
        paragraphs: isArabic ? [
          '\u200E73\u200F صالة عرض هي العمود الفقري المادي لنموذجنا. لا نقيس كل موقع بالإيرادات وحدها، بل بجودة تقديم الخدمة وتوافر المنتجات والتجربة التي يصنعها لعميل يختارنا شريكاً لمنزله. في \u200E2024\u200F و\u200E2025\u200F افتتحنا مواقع جديدة وأعدنا تموضع فروع أخرى، وجدّدنا مواقع مختارة حيث برّر العائد الاستثمار. التوسع انتقائي قائم على العوائد، لا مجرد استهداف عدد فروع.',
          'تدعم هذه الشبكة بنية لوجستية متكاملة: مستودعان مركزيان في الرياض تتجاوز مساحتهما \u200E50,000\u200F متر مربع، ومركز توزيع في جدة، وشركاء لوجستيون مؤهّلون يعملون وفق اتفاقيات مستوى خدمة محددة. انضباط إعادة التزويد يُقلّص نفاد المخزون في مواسم الذروة، وإدارة المخزون المركزية تُعزز معدل دورانه. وهذا هو التميز التشغيلي في خدمة ثقة العميل.',
        ] : [
          '73 showrooms are the physical backbone of our model. We measure each location not just by revenue but by service delivery quality, product availability, and the experience it creates for customers who choose us as their household partner. In 2024 and 2025, we opened new locations, repositioned underperforming branches, and closed selected sites where the return justified the investment. Expansion is selective and return-driven, not a number target.',
          'Our logistics infrastructure supports this network: two central warehouses in Riyadh with a combined area exceeding 50,000 m², a Jeddah fulfillment center, and qualified logistics partners operating to defined service level agreements. Replenishment discipline reduces stockouts in peak seasons; centralized inventory management enables faster turns. This is operational excellence in service of customer trust.',
        ],
      ),
      _Pillar(
        icon: 'assets/images/digital_channel.svg',
        pillarLabel: isArabic ? 'الركيزة الثالثة' : 'Pillar 3',
        title: isArabic ? 'التكامل الرقمي' : 'Digital Channel Integration',
        paragraphs: isArabic ? [
          'في عام 2025 أسهمت قنواتنا الرقمية بـ \u200E94\u200F مليون ريال من الإيرادات، أي \u200E12.4%\u200F من الإجمالي، بنمو \u200E37%\u200F على أساس سنوي. يتمتع تطبيقنا بأكثر من \u200E500,000\u200F تنزيل وتقييم \u200E4.2\u200F نجمة، ويُقدّم أكثر من \u200E15,000\u200F منتج. لكن الرقم الأهم ليس نسبة الإيرادات الرقمية في حد ذاتها، بل عمق التكامل: طلبات الاستلام من المعرض، ومعالجة الإرجاع وطلبات الضمان في المواقع الفعلية، وخيارات دفع موحّدة تشمل التقسيط والدفع الذكي عبر القناتين.',
          'لا نعدّ المسار الرقمي وحدة أعمال منفصلة. فالمعرض والشاشة منصة واحدة متكاملة. واستثماراتنا في سرعة المنصة وجودة البحث ووضوح حالة الطلب خلال 2025 قلصت نقاط التعثر في كل خطوة من رحلة العميل.',
        ] : [
          'In 2025, our digital channels contributed SAR 94 million in revenue, 12.4% of the total, up 37% for the full year. Our app has 500,000+ downloads and a 4.2-star rating, serving over 15,000 products. But the number that matters most is not the digital revenue percentage. It is the integration depth: click-and-collect orders fulfilled from the showroom network; returns and warranty claims processed at physical locations; unified payment options including installment and smart device payment across both channels.',
          'We do not regard digital as a separate business unit. The showroom and the screen are one platform. Our investment in platform speed, search quality, and order status transparency during 2025 reduced friction at every step of the customer journey, particularly during peak seasons where delivery reliability most directly determines customer confidence.',
        ],
      ),
      _Pillar(
        icon: 'assets/images/headphone.svg',
        pillarLabel: isArabic ? 'الركيزة الرابعة' : 'Pillar 4',
        title: isArabic ? 'خدمة ما بعد البيع ميزة تنافسية' : 'After-Sales as Competitive Advantage',
        paragraphs: isArabic ? [
          'لا يقيس عميل الأجهزة المنزلية الجودة عند الشراء، بل يقيسها أول مرة يحتاج فيها خدمة. بنت السيف غاليري معالجة مركزية لخدمة منتجاتها الكهربائية، وضمانات متعددة السنوات، وتحسيناً متواصلاً في توافر قطع الغيار. ليس بوصفها مركز تكلفة للخدمة، بل بوصفها مُميّزاً استراتيجياً حقيقياً. في سوق تُحدّد فيه جودة الخدمة بعد البيع غالباً ولاء العلامة التجارية، تبني استثماراتنا علاقات متينة مع العملاء لا يستطيع المنافسون من دون بنية العلامات الخاصة مجاراتها.',
        ] : [
          'The household appliance customer does not measure quality at the point of purchase. They measure it the first time something needs fixing. Al Saif Gallery has built centralized service processing for its own-brand electrical products, multi-year warranty coverage, and improving spare parts availability. Not as a customer service cost center, but as a strategic differentiator. In a market where service quality after the sale is often the deciding factor in brand loyalty, our investment in after-sales depth builds durable customer relationships that competitors without owned-brand infrastructure cannot match.',
        ],
      ),
      _Pillar(
        icon: 'assets/images/Customer.svg',
        pillarLabel: isArabic ? 'الركيزة الخامسة' : 'Pillar 5',
        title: isArabic ? 'الكوادر والتميز التشغيلي' : 'People and Operational Excellence',
        paragraphs: isArabic ? [
          'يمثّل موظفو صالات العرض والمستودعات ومراكز الخدمة أكثر من \u200E1,280\u200F موظفاً في خمسة أسواق. أداؤهم اليومي هو الذي يُترجم الاستراتيجية إلى تجربة عميل حقيقية. نستثمر في التدريب المنظّم ومعايير الخدمة المحددة وإجراءات السلامة وأنظمة إدارة الأداء المصمّمة لمكافأة الاتساق والاهتمام والمساءلة. التميز التشغيلي ليس وثيقة تُحفظ في أدراج الإدارة، بل ما يحدث فعلياً حين يتبع المدرَّبون عمليات منضبطة في خدمة عملاء مُطالِبين.',
        ] : [
          'Our showroom teams, warehouse operations, and service centers represent over 1,280 employees across Saudi Arabia and 4 GCC countries. Their daily performance is what translates strategy into customer experience. We invest in structured training, defined service standards, safety procedures, and performance management systems designed to reward consistency, care, and accountability. Operational excellence is not a management document. It is what happens when trained people follow disciplined processes in service of demanding customers.',
        ],
      ),
    ];

    return Container(
      width: double.infinity,
      color: const Color(0xFFF8FAFB),
      padding: EdgeInsets.symmetric(horizontal: hPad, vertical: 56),
      child: Directionality(
        textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: double.infinity,
              child: Text(
                isArabic ? 'ركائز استراتيجيتنا' : 'Our Strategic Pillars',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A1A1A),
                ),
              ),
            ),
            const SizedBox(height: 32),
            ...pillars.map((p) => Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: _PillarCard(pillar: p, isArabic: isArabic),
            )),
          ],
        ),
      ),
    );
  }
}

class _Pillar {
  final String icon;
  final String pillarLabel;
  final String title;
  final List<String> paragraphs;
  const _Pillar({required this.icon, required this.pillarLabel, required this.title, required this.paragraphs});
}

class _PillarCard extends StatelessWidget {
  final _Pillar pillar;
  final bool isArabic;
  const _PillarCard({required this.pillar, required this.isArabic});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE8E8E8)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
        children: [
          // Icon
          SvgPicture.asset(pillar.icon, width: 36, height: 36,
              colorFilter: const ColorFilter.mode(Color(0xFFC62030), BlendMode.srcIn)),
          const SizedBox(width: 28),
          // Text content
          Expanded(
            child: Directionality(
              textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(pillar.pillarLabel,
                      style: const TextStyle(fontSize: 12, color: Color(0xFFC62030), fontWeight: FontWeight.w600)),
                  const SizedBox(height: 6),
                  Text(pillar.title,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Color(0xFF1A1A1A))),
                  const SizedBox(height: 14),
                  ...pillar.paragraphs.map((p) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Text(p,
                        style: const TextStyle(fontSize: 13, color: Color(0xFF555555), height: 1.7)),
                  )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}





