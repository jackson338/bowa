part of 'theme.dart';

class ThemeBloc extends Cubit<ThemeState> {
  ThemeBloc() : super(const ThemeState()) {
    init();
  }

  void init() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('theme') != null) {
      if (prefs.getString('theme') == 'dark') {
        darkTheme();
      } else {
        lightTheme();
      }
    }
  }

  void darkTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('theme', 'dark');
    emit(state.copyWith(
      background: Colors.black,
      bodyText: Colors.white,
      card: Colors.blueGrey,
      hover: Colors.blueGrey,
      icon: Colors.cyan,
      headline: Colors.cyan,
      headline6: Colors.white,
    ));
  }

  void lightTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('theme', 'light');
    emit(state.copyWith(
      background: Colors.white,
      bodyText: Colors.black,
      card: Colors.white,
      hover: Colors.blueGrey,
      icon: Colors.cyan,
      headline: Colors.cyan,
      headline6: Colors.black,
    ));
  }
}
