import 'package:flutter/material.dart';

/// A [MaterialApp] with two subviews, one for each screen.
/// Each subview has its own [Navigator] and [MediaQuery],
/// but they share other globals such as [ThemeData], [Localizations],
/// and [WidgetsBinding].
class DualScreenApp extends StatelessWidget {
  /*
   *  General app stuff
   */
  final ThemeData? theme;
  final ThemeMode? themeMode;
  final Locale? locale;
  final Iterable<LocalizationsDelegate<dynamic>>? localizationDelegates;
  final Iterable<Locale> supportedLocales;

  /*
   *  Dual-screen stuff
   */
  /// Whether to align the screens vertically or horizontally.
  final Axis orientation;

  /// Screen alignment on the cross axis.
  final CrossAxisAlignment crossAxisAlignment;

  /// Gap between the two screens.
  final double spacing;

  /// First screen's [SubscreenData].
  final SubscreenData firstScreen;

  /// First screen's [WidgetBuilder].
  final WidgetBuilder firstScreenBuilder;

  /// Second screen's [SubscreenData].
  final SubscreenData secondScreen;

  /// Second screen's [WidgetBuilder].
  final WidgetBuilder secondScreenBuilder;

  const DualScreenApp({
    super.key,
    this.theme,
    this.themeMode,
    this.locale,
    this.localizationDelegates,
    this.supportedLocales = const <Locale>[Locale('en', 'US')],
    // Dual-screen stuff
    this.orientation = Axis.vertical,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.spacing = 0.0,
    required this.firstScreen,
    required this.firstScreenBuilder,
    required this.secondScreen,
    required this.secondScreenBuilder,
  }) : super();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: theme,
      themeMode: themeMode,
      locale: locale,
      localizationsDelegates: localizationDelegates,
      supportedLocales: supportedLocales,
      // builder
      builder: (context, _) => SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Flex(
          direction: orientation,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: crossAxisAlignment,
          spacing: spacing,
          children: [
            Subscreen(data: firstScreen, builder: firstScreenBuilder),
            Subscreen(data: secondScreen, builder: secondScreenBuilder),
          ],
        ),
      ),
    );
  }
}

class SubscreenData {
  final double width;
  final double height;
  // final Offset offset;
  final double scale;

  SubscreenData({
    required this.width,
    required this.height,
    // required this.offset,
    this.scale = 1.0,
  });
}

class Subscreen extends StatelessWidget {
  final SubscreenData data;
  final WidgetBuilder builder;

  const Subscreen({super.key, required this.data, required this.builder})
    : super();

  @override
  Widget build(BuildContext context) => SizedBox(
    width: data.width,
    height: data.height,
    child: Transform.scale(
      scale: data.scale,
      child: OverflowBox(
        child: RepaintBoundary(
          child: LayoutBuilder(
            builder: (context, constraints) => MediaQuery(
              data: MediaQuery.of(context).copyWith(
                size: Size(data.width, data.height),
                // factor in the scale to maintain the correct pixel density
                devicePixelRatio: 1.0 / data.scale,
              ),
              // TODO(kerberjg): add separate ScaffoldMessenger for each screen
              // to allow for independent snackbars.
              child: HeroControllerScope(
                controller: MaterialApp.createMaterialHeroController(),
                child: Navigator(
                  onGenerateRoute: (settings) =>
                      MaterialPageRoute(builder: (context) => builder(context)),
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
