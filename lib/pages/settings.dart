import 'package:bowa/bloc/theme_bloc/theme.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  final ThemeBloc themeBloc;
  const SettingsPage({Key? key, required this.themeBloc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).backgroundColor,
        elevation: 0,
        title: Text(
          'Settings',
          style: Theme.of(context).textTheme.headline1,
        ),
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            color: Theme.of(context).iconTheme.color,
          ),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        color: Theme.of(context).backgroundColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //light theme
            themeWidget(context, Colors.black, Colors.white, 'Light Theme', themeBloc),
            //dark theme
            themeWidget(context, Colors.white, Colors.black, 'Dark Theme', themeBloc),
          ],
        ),
      ),
    );
  }

  static Padding themeWidget(BuildContext context, Color themeContrast, Color themeColor,
      String theme, ThemeBloc themeBloc) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () =>
            theme == 'Dark Theme' ? themeBloc.darkTheme() : themeBloc.lightTheme(),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(color: themeContrast),
            ],
            color: themeColor,
          ),
          width: MediaQuery.of(context).size.width / 4,
          height: MediaQuery.of(context).size.height / 4,
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 15,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Theme.of(context).primaryColor,
                ),
                child: Center(
                  child: FittedBox(
                    child: Text(
                      theme,
                      style: TextStyle(color: themeColor),
                    ),
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 5.5,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: themeColor,
                    boxShadow: [
                      BoxShadow(color: themeColor),
                    ]),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width / 4,
                        height: MediaQuery.of(context).size.height / 38,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: themeContrast,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width / 12,
                        height: MediaQuery.of(context).size.height / 38,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: themeContrast,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width / 8,
                        height: MediaQuery.of(context).size.height / 38,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: themeContrast,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
