import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:ahmed_rasmy_portfolio/app/app.dart';
import 'package:ahmed_rasmy_portfolio/app/settings/settings_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('PortfolioApp boots with home title', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
        ],
        child: const PortfolioApp(),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Ahmed Rasmy'), findsWidgets);
  });
}
