import 'package:bowa/bloc/theme_bloc/theme.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  final ThemeBloc themeBloc;
  const SettingsPage({Key? key, required this.themeBloc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () => themeBloc.lightTheme(),
                child: SizedBox(
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
                          'Light Theme',
                          style: Theme.of(context).textTheme.bodyText1,
                        ))),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height / 6,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.white,
                            boxShadow: const [
                              BoxShadow(color: Colors.black),
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
                                  color: Colors.black,
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
                                  color: Colors.black,
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
                                  color: Colors.black,
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
            ),
            //dark theme
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () => themeBloc.darkTheme(),
                child: SizedBox(
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
                          'Dark Theme',
                          style: Theme.of(context).textTheme.bodyText1,
                        ))),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height / 6,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.black,
                            boxShadow: const [
                              BoxShadow(color: Colors.black),
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
                                  color: Colors.white,
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
                                  color: Colors.white,
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
                                  color: Colors.white,
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
            ),
          ],
        ),
      ),
    );
  }
}
