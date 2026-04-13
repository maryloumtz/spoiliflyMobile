import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_application_1/src/app.dart';

void main() {
  testWidgets('shows spoilifly auth screen', (tester) async {
    await tester.pumpWidget(const SpoiliflyMobileApp());

    expect(find.text('Spoilifly Mobile'), findsOneWidget);
    expect(find.text('Connexion'), findsWidgets);
  });
}
