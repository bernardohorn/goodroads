import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:goodroads/app.dart';

void main() {
  testWidgets('Aplicativo GoodRoads inicia na tela de login',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: AplicativoGoodRoads(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('GoodRoads'), findsOneWidget);
    expect(find.text('Entrar'), findsOneWidget);
  });
}
