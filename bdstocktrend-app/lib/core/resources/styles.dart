import 'package:bd_stock_trend/core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Light theme
ThemeData themeLight(BuildContext context) => ThemeData(
      fontFamily: 'Poppins',
      useMaterial3: true,
      primaryColor: Palette.primary,
      disabledColor: Palette.subText.withOpacity(0.5),
      hintColor: Palette.subText,
      cardColor: Palette.card,
      scaffoldBackgroundColor: Palette.background,
      colorScheme: const ColorScheme.light().copyWith(
        primary: Palette.primary,
        secondary: Palette.info,
        surface: Palette.card,
        error: Palette.error,
      ),
      textTheme: TextTheme(
        displayLarge: Theme.of(context).textTheme.displayLarge?.copyWith(
              fontSize: Dimens.displayLarge,
              color: Palette.text,
              fontWeight: FontWeight.bold,
            ),
        displayMedium: Theme.of(context).textTheme.displayMedium?.copyWith(
              fontSize: Dimens.displayMedium,
              color: Palette.text,
              fontWeight: FontWeight.bold,
            ),
        displaySmall: Theme.of(context).textTheme.displaySmall?.copyWith(
              fontSize: Dimens.displaySmall,
              color: Palette.text,
              fontWeight: FontWeight.bold,
            ),
        headlineMedium: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontSize: Dimens.headlineMedium,
              color: Palette.text,
              fontWeight: FontWeight.w600,
            ),
        headlineSmall: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontSize: Dimens.headlineSmall,
              color: Palette.text,
              fontWeight: FontWeight.w600,
            ),
        titleLarge: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontSize: Dimens.titleLarge,
              color: Palette.text,
              fontWeight: FontWeight.w600,
            ),
        titleMedium: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontSize: Dimens.titleMedium,
              color: Palette.text,
              fontWeight: FontWeight.w500,
            ),
        titleSmall: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontSize: Dimens.titleSmall,
              color: Palette.text,
              fontWeight: FontWeight.w500,
            ),
        bodyLarge: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontSize: Dimens.bodyLarge,
              color: Palette.text,
            ),
        bodyMedium: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontSize: Dimens.bodyMedium,
              color: Palette.text,
            ),
        bodySmall: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontSize: Dimens.bodySmall,
              color: Palette.subText,
            ),
        labelLarge: Theme.of(context).textTheme.labelLarge?.copyWith(
              fontSize: Dimens.labelLarge,
              color: Palette.text,
              fontWeight: FontWeight.w600,
            ),
        labelSmall: Theme.of(context).textTheme.labelSmall?.copyWith(
              fontSize: Dimens.labelSmall,
              letterSpacing: 0.25,
              color: Palette.subText,
            ),
      ),
      appBarTheme: const AppBarTheme().copyWith(
        titleTextStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Palette.text,
              fontWeight: FontWeight.bold,
            ),
        color: Palette.card,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Palette.primary),
        systemOverlayStyle: SystemUiOverlayStyle.dark.copyWith(
          statusBarColor: Colors.transparent,
        ),
        surfaceTintColor: Palette.card,
        shadowColor: Palette.shadow,
      ),
      cardTheme: CardThemeData(
        color: Palette.card,
        elevation: Dimens.cardElevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimens.radiusMedium),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Palette.background,
        contentPadding: EdgeInsets.all(Dimens.space16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Dimens.radiusMedium),
          borderSide: BorderSide(color: Palette.divider),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Dimens.radiusMedium),
          borderSide: BorderSide(color: Palette.divider),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Dimens.radiusMedium),
          borderSide: const BorderSide(color: Palette.primary, width: 2),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Palette.primary,
          foregroundColor: Colors.white,
          minimumSize: Size(double.infinity, Dimens.buttonHeight),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Dimens.radiusMedium),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      drawerTheme: const DrawerThemeData().copyWith(
        elevation: 0,
        surfaceTintColor: Palette.card,
        backgroundColor: Palette.card,
      ),
      bottomSheetTheme: const BottomSheetThemeData().copyWith(
        backgroundColor: Palette.card,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(Dimens.cornerRadiusBottomSheet),
          ),
        ),
      ),
      dialogTheme: const DialogThemeData().copyWith(
        backgroundColor: Palette.card,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimens.radiusLarge),
        ),
      ),
      brightness: Brightness.light,
      iconTheme: const IconThemeData(color: Palette.primary),
      visualDensity: VisualDensity.adaptivePlatformDensity,
      extensions: const <ThemeExtension<dynamic>>[
        LzyctColors(
          background: Palette.background,
          card: Palette.card,
          buttonText: Colors.white,
          subtitle: Palette.subText,
          shadow: Palette.shadow,
          green: Palette.success,
          roseWater: Palette.roseWaterLatte,
          flamingo: Palette.flamingoLatte,
          pink: Palette.primary,
          mauve: Palette.mauveLatte,
          maroon: Palette.maroonLatte,
          peach: Palette.warning,
          yellow: Palette.warning,
          teal: Palette.tealLatte,
          sapphire: Palette.sapphireLatte,
          sky: Palette.info,
          blue: Palette.primary,
          lavender: Palette.lavenderLatte,
          red: Palette.error,
        ),
      ],
    );

/// Dark theme
ThemeData themeDark(BuildContext context) => ThemeData(
      fontFamily: 'Poppins',
      useMaterial3: true,
      primaryColor: Palette.primary,
      disabledColor: Palette.subTextDark.withOpacity(0.5),
      hintColor: Palette.subTextDark,
      cardColor: Palette.cardDark,
      scaffoldBackgroundColor: Palette.backgroundDark,
      colorScheme: const ColorScheme.dark().copyWith(
        primary: Palette.primary,
        secondary: Palette.info,
        surface: Palette.cardDark,
        error: Palette.error,
      ),
      textTheme: TextTheme(
        displayLarge: Theme.of(context).textTheme.displayLarge?.copyWith(
              fontSize: Dimens.displayLarge,
              color: Palette.textDark,
              fontWeight: FontWeight.bold,
            ),
        displayMedium: Theme.of(context).textTheme.displayMedium?.copyWith(
              fontSize: Dimens.displayMedium,
              color: Palette.textDark,
              fontWeight: FontWeight.bold,
            ),
        displaySmall: Theme.of(context).textTheme.displaySmall?.copyWith(
              fontSize: Dimens.displaySmall,
              color: Palette.textDark,
              fontWeight: FontWeight.bold,
            ),
        headlineMedium: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontSize: Dimens.headlineMedium,
              color: Palette.textDark,
              fontWeight: FontWeight.w600,
            ),
        headlineSmall: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontSize: Dimens.headlineSmall,
              color: Palette.textDark,
              fontWeight: FontWeight.w600,
            ),
        titleLarge: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontSize: Dimens.titleLarge,
              color: Palette.textDark,
              fontWeight: FontWeight.w600,
            ),
        titleMedium: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontSize: Dimens.titleMedium,
              color: Palette.textDark,
              fontWeight: FontWeight.w500,
            ),
        titleSmall: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontSize: Dimens.titleSmall,
              color: Palette.textDark,
              fontWeight: FontWeight.w500,
            ),
        bodyLarge: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontSize: Dimens.bodyLarge,
              color: Palette.textDark,
            ),
        bodyMedium: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontSize: Dimens.bodyMedium,
              color: Palette.textDark,
            ),
        bodySmall: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontSize: Dimens.bodySmall,
              color: Palette.subTextDark,
            ),
        labelLarge: Theme.of(context).textTheme.labelLarge?.copyWith(
              fontSize: Dimens.labelLarge,
              color: Palette.textDark,
              fontWeight: FontWeight.w600,
            ),
        labelSmall: Theme.of(context).textTheme.labelSmall?.copyWith(
              fontSize: Dimens.labelSmall,
              letterSpacing: 0.25,
              color: Palette.subTextDark,
            ),
      ),
      appBarTheme: const AppBarTheme().copyWith(
        titleTextStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Palette.textDark,
              fontWeight: FontWeight.bold,
            ),
        iconTheme: const IconThemeData(color: Palette.primary),
        color: Palette.cardDark,
        elevation: 0,
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle.light.copyWith(
          statusBarColor: Colors.transparent,
        ),
        surfaceTintColor: Palette.cardDark,
        shadowColor: Palette.shadowDark,
      ),
      cardTheme: CardThemeData(
        color: Palette.cardDark,
        elevation: Dimens.cardElevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimens.radiusMedium),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Palette.backgroundDark,
        contentPadding: EdgeInsets.all(Dimens.space16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Dimens.radiusMedium),
          borderSide: BorderSide(color: Palette.dividerDark),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Dimens.radiusMedium),
          borderSide: BorderSide(color: Palette.dividerDark),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Dimens.radiusMedium),
          borderSide: const BorderSide(color: Palette.primary, width: 2),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Palette.primary,
          foregroundColor: Colors.white,
          minimumSize: Size(double.infinity, Dimens.buttonHeight),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Dimens.radiusMedium),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      drawerTheme: const DrawerThemeData().copyWith(
        elevation: 0,
        surfaceTintColor: Palette.cardDark,
        backgroundColor: Palette.cardDark,
        shadowColor: Palette.shadowDark,
      ),
      bottomSheetTheme: const BottomSheetThemeData().copyWith(
        backgroundColor: Palette.cardDark,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(Dimens.cornerRadiusBottomSheet),
          ),
        ),
      ),
      dialogTheme: const DialogThemeData().copyWith(
        backgroundColor: Palette.cardDark,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimens.radiusLarge),
        ),
      ),
      brightness: Brightness.dark,
      iconTheme: const IconThemeData(color: Palette.primary),
      visualDensity: VisualDensity.adaptivePlatformDensity,
      extensions: const <ThemeExtension<dynamic>>[
        LzyctColors(
          background: Palette.backgroundDark,
          buttonText: Colors.white,
          card: Palette.cardDark,
          subtitle: Palette.subTextDark,
          shadow: Palette.shadowDark,
          green: Palette.success,
          roseWater: Palette.roseWaterMocha,
          flamingo: Palette.flamingoMocha,
          pink: Palette.primary,
          mauve: Palette.mauveMocha,
          maroon: Palette.maroonMocha,
          peach: Palette.warning,
          yellow: Palette.warning,
          teal: Palette.tealMocha,
          sapphire: Palette.sapphireMocha,
          sky: Palette.info,
          blue: Palette.primary,
          lavender: Palette.lavenderMocha,
          red: Palette.error,
        ),
      ],
    );

class LzyctColors extends ThemeExtension<LzyctColors> {
  final Color? background;
  final Color? card;
  final Color? buttonText;
  final Color? subtitle;
  final Color? shadow;
  final Color? green;
  final Color? roseWater;
  final Color? flamingo;
  final Color? pink;
  final Color? mauve;
  final Color? maroon;
  final Color? peach;
  final Color? yellow;
  final Color? teal;
  final Color? sky;
  final Color? sapphire;
  final Color? blue;
  final Color? lavender;
  final Color? red;

  const LzyctColors({
    this.background,
    this.card,
    this.buttonText,
    this.subtitle,
    this.shadow,
    this.green,
    this.roseWater,
    this.flamingo,
    this.pink,
    this.mauve,
    this.maroon,
    this.peach,
    this.yellow,
    this.teal,
    this.sapphire,
    this.sky,
    this.blue,
    this.lavender,
    this.red,
  });

  @override
  ThemeExtension<LzyctColors> copyWith({
    Color? background,
    Color? card,
    Color? buttonText,
    Color? subtitle,
    Color? shadow,
    Color? green,
    Color? roseWater,
    Color? flamingo,
    Color? pink,
    Color? mauve,
    Color? maroon,
    Color? peach,
    Color? yellow,
    Color? teal,
    Color? sky,
    Color? sapphire,
    Color? blue,
    Color? lavender,
    Color? red,
  }) {
    return LzyctColors(
      background: background ?? this.background,
      card: card ?? this.card,
      buttonText: buttonText ?? this.buttonText,
      subtitle: subtitle ?? this.subtitle,
      shadow: shadow ?? this.shadow,
      green: green ?? this.green,
      roseWater: roseWater ?? this.roseWater,
      flamingo: flamingo ?? this.flamingo,
      pink: pink ?? this.pink,
      mauve: mauve ?? this.mauve,
      maroon: maroon ?? this.maroon,
      peach: peach ?? this.peach,
      yellow: yellow ?? this.yellow,
      teal: teal ?? this.teal,
      sky: sky ?? this.sky,
      sapphire: sapphire ?? this.sapphire,
      blue: blue ?? this.blue,
      lavender: lavender ?? this.lavender,
      red: red ?? this.red,
    );
  }

  @override
  ThemeExtension<LzyctColors> lerp(
    covariant ThemeExtension<LzyctColors>? other,
    double t,
  ) {
    if (other is! LzyctColors) {
      return this;
    }
    return LzyctColors(
      background: Color.lerp(background, other.background, t),
      card: Color.lerp(card, other.card, t),
      buttonText: Color.lerp(buttonText, other.buttonText, t),
      subtitle: Color.lerp(subtitle, other.subtitle, t),
      shadow: Color.lerp(shadow, other.shadow, t),
      green: Color.lerp(green, other.green, t),
      roseWater: Color.lerp(roseWater, other.roseWater, t),
      flamingo: Color.lerp(flamingo, other.flamingo, t),
      pink: Color.lerp(pink, other.pink, t),
      mauve: Color.lerp(mauve, other.mauve, t),
      maroon: Color.lerp(maroon, other.maroon, t),
      peach: Color.lerp(peach, other.peach, t),
      yellow: Color.lerp(yellow, other.yellow, t),
      teal: Color.lerp(teal, other.teal, t),
      sapphire: Color.lerp(sapphire, other.sapphire, t),
      blue: Color.lerp(blue, other.blue, t),
      lavender: Color.lerp(lavender, other.lavender, t),
      sky: Color.lerp(sky, other.sky, t),
      red: Color.lerp(red, other.red, t),
    );
  }
}

class BoxDecorations {
  BoxDecorations(this.context);

  final BuildContext context;

  BoxDecoration get button => BoxDecoration(
        color: Palette.primary,
        borderRadius:
            const BorderRadius.all(Radius.circular(Dimens.cornerRadius)),
        boxShadow: [BoxShadows(context).button],
      );

  BoxDecoration get card => BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius:
            const BorderRadius.all(Radius.circular(Dimens.cornerRadius)),
        boxShadow: [BoxShadows(context).card],
      );
}

class BoxShadows {
  BoxShadows(this.context);

  final BuildContext context;

  BoxShadow get button => BoxShadow(
        color: Theme.of(context)
            .extension<LzyctColors>()!
            .shadow!
            .withOpacity(0.5),
        blurRadius: 16.0,
        spreadRadius: 1.0,
      );

  BoxShadow get card => BoxShadow(
        color: Theme.of(context)
            .extension<LzyctColors>()!
            .shadow!
            .withOpacity(0.5),
        blurRadius: 5.0,
        spreadRadius: 0.5,
      );

  BoxShadow get dialog => BoxShadow(
        color: Theme.of(context).extension<LzyctColors>()!.shadow!,
        offset: const Offset(0, -4),
        blurRadius: 16.0,
      );

  BoxShadow get dialogAlt => BoxShadow(
        color: Theme.of(context).extension<LzyctColors>()!.shadow!,
        offset: const Offset(0, 4),
        blurRadius: 16.0,
      );

  BoxShadow get buttonMenu => BoxShadow(
        color: Theme.of(context).extension<LzyctColors>()!.shadow!,
        blurRadius: 4.0,
      );
}
