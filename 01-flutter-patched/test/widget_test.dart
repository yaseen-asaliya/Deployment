import 'package:flutter_test/flutter_test.dart';
import 'package:al_saif_gallery/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const AlSaifGalleryApp());
  });
}
