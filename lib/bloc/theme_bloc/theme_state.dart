part of 'theme.dart';

class ThemeState {
  final MaterialColor primary;
  final MaterialAccentColor primaryLight;
  final MaterialColor primaryDark;
  final Color background;
  final MaterialColor disabled;
  final MaterialColor hover;
  final Color icon;
  final Color headline;
  final Color headline6;
  final Color bodyText;
  final Color card;

  const ThemeState({
    this.primary = Colors.cyan,
    this.primaryLight = Colors.cyanAccent,
    this.primaryDark = Colors.blueGrey,
    this.background = Colors.white,
    this.disabled = Colors.blueGrey,
    this.hover = Colors.blueGrey,
    this.icon = Colors.cyan,
    this.headline = Colors.cyan,
    this.headline6 = Colors.black,
    this.bodyText = Colors.black,
    this.card = Colors.white,
  });

  ThemeState copyWith({
    final MaterialColor? primary,
    final MaterialAccentColor? primaryLight,
    final MaterialColor? primaryDark,
    final Color? background,
    final MaterialColor? disabled,
    final MaterialColor? hover,
    final Color? icon,
    final Color? headline,
    final Color? headline6,
    final Color? bodyText,
    final Color? card,
  }) {
    return ThemeState(
      primary: primary ?? this.primary,
      primaryLight: primaryLight ?? this.primaryLight,
      primaryDark: primaryDark ?? this.primaryDark,
      background: background ?? this.background,
      disabled: disabled ?? this.disabled,
      hover: hover ?? this.hover,
      icon: icon ?? this.icon,
      headline: headline ?? this.headline,
      headline6: headline6 ?? this.headline6,
      bodyText: bodyText ?? this.bodyText,
      card: card ?? this.card,
    );
  }
}
