// This app was created by Jackson Oaks and he olds all rights to this code. It is not to be copied or used publicly by anyone.

import 'dart:async';

import 'package:bowa/bloc/login_bloc/account_creation/account_creation.dart';
import 'package:bowa/bloc/login_bloc/login.dart';
import 'package:bowa/bloc/theme_bloc/theme.dart';
import 'package:bowa/pages/account_page.dart';
import 'package:bowa/pages/books_page/books_page.dart';
import 'package:bowa/pages/library_page.dart';
import 'package:bowa/widgets/outline_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ThemeBloc(),
      child: BlocBuilder<ThemeBloc, ThemeState>(
        buildWhen: (previous, current) => previous.background != current.background,
        builder: (context, state) {
          final icon = IconThemeData(color: state.icon);
          return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Flutter Demo',
              theme: ThemeData(
                primarySwatch: state.primary,
                primaryColor: state.primary,
                primaryColorLight: state.primaryLight,
                primaryColorDark: state.primaryDark,
                backgroundColor: state.background,
                disabledColor: state.disabled,
                hoverColor: state.hover,
                cardColor: state.card,
                iconTheme: icon,
                textTheme: TextTheme(
                  headline1: TextStyle(
                    color: state.headline,
                    fontSize: 32,
                    fontWeight: FontWeight.w300,
                  ),
                  headline6: TextStyle(
                    color: state.headline6,
                  ),
                  bodyText1: TextStyle(
                    color: state.bodyText,
                  ),
                ),
              ),
              home: LoginPage(themeBloc: context.read<ThemeBloc>()));
        },
      ),
    );
  }
}

class LoginPage extends StatelessWidget {
  final ThemeBloc themeBloc;
  const LoginPage({
    Key? key,
    required this.themeBloc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController nameCont = TextEditingController();
    TextEditingController authorNameCont = TextEditingController();
    TextEditingController emailCont = TextEditingController();
    TextEditingController passwordCont = TextEditingController();

    List<TextEditingController> conts = [
      nameCont,
      authorNameCont,
      emailCont,
      passwordCont,
    ];
    List<String> texts = ['Full Name', 'Author Name', 'Email', 'Password'];
    return BlocProvider(
      create: (context) => LoginBloc(),
      child: BlocBuilder<LoginBloc, LoginState>(
        buildWhen: (previous, current) => previous.loggedIn != current.loggedIn,
        builder: (context, state) {
          List<Widget> pages = [];
          List<String> accountInfo = [];
          if (state.loggedIn) {
            accountInfo = [
              state.name,
              state.authorName,
              state.email,
              state.password,
            ];
            pages = [
              AccountPage(
                authorName: state.authorName,
                accountInfo: accountInfo,
                loginBloc: context.read<LoginBloc>(),
              ),
              const LibraryPage(),
              BooksPage(
                themeBloc: themeBloc,
                loginBloc: context.read<LoginBloc>(),
              ),
            ];
          }
          return state.loggedIn
              ? Controller(
                  authorName: state.authorName,
                  pages: pages,
                )
              : Scaffold(
                  backgroundColor: Theme.of(context).backgroundColor,
                  appBar: AppBar(
                    title: const Text('Login'),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  body: Padding(
                    padding: const EdgeInsets.only(top: 15.0),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: GestureDetector(
                              onTap: () => login(context, context.read<LoginBloc>()),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.all(15.0),
                                  child: Text(
                                    'Login',
                                    maxLines: 1,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 25.0,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: GestureDetector(
                              onTap: () => createAccount(
                                  context, conts, texts, context.read<LoginBloc>()),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.all(15.0),
                                  child: Text(
                                    'Create Account :)',
                                    maxLines: 1,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 25.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
        },
      ),
    );
  }
}

void login(
  BuildContext context,
  LoginBloc origLoginBloc,
) {
  TextEditingController name = TextEditingController();
  TextEditingController password = TextEditingController();
  showDialog(
    context: context,
    builder: (sheetContext) {
      return GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: BlocProvider(
          create: (context) => LoginBloc(),
          child: BlocBuilder<LoginBloc, LoginState>(
            buildWhen: (previous, current) =>
                previous.name != current.name ||
                previous.password != current.password ||
                previous.autoLogin != current.autoLogin ||
                previous.loading != current.loading,
            builder: (context, state) {
              LoginBloc loginBloc = context.read<LoginBloc>();
              return Scaffold(
                appBar: AppBar(
                  title: const Text('Login'),
                  leading: TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const FittedBox(
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
                body: Center(
                  child: AutofillGroup(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width / 2,
                            child: TextField(
                              autofocus: true,
                              decoration: outlineTextField(
                                context: context,
                                selected: Theme.of(context).primaryColor,
                                stagnant: Theme.of(context).hoverColor,
                                hintText: 'Name',
                              ),
                              controller: name,
                              keyboardType: TextInputType.name,
                              autofillHints: const [AutofillHints.username],
                              keyboardAppearance: Brightness.dark,
                              onChanged: (nameText) => loginBloc.name(nameText),
                              onSubmitted: (_) {},
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width / 2,
                            child: TextField(
                              autofocus: true,
                              decoration: outlineTextField(
                                context: context,
                                selected: Theme.of(context).primaryColor,
                                stagnant: Theme.of(context).hoverColor,
                                hintText: 'Password',
                              ),
                              controller: password,
                              obscureText: true,
                              keyboardAppearance: Brightness.dark,
                              keyboardType: TextInputType.text,
                              autofillHints: const [AutofillHints.password],
                              onChanged: (pass) => loginBloc.password(pass),
                              onSubmitted: (_) {},
                            ),
                          ),
                        ),
                        // : CircularProgressIndicator(
                        //     backgroundColor: Theme.of(context).backgroundColor,
                        //     color: Theme.of(context).primaryColor,
                        //     strokeWidth: 3,
                        //   ),
                  
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Auto Login'),
                            Switch(
                              value: state.autoLogin,
                              onChanged: (val) {
                                origLoginBloc.switchAutoLogin(val);
                                context.read<LoginBloc>().switchAutoLogin(val);
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                floatingActionButton: FloatingActionButton(
                  backgroundColor: name.text.isNotEmpty && password.text.isNotEmpty
                      ? Theme.of(context).primaryColor
                      : Theme.of(context).hoverColor,
                  onPressed: () {
                    FocusManager.instance.primaryFocus?.unfocus();
                    loginBloc.loading(true);
                    Timer(
                      const Duration(seconds: 1),
                      () {
                        loginBloc.loading(false);
                        origLoginBloc.login(name.text, password.text, context);
                      },
                    );
                  },
                  child: state.loading
                      ? CircularProgressIndicator(
                          backgroundColor: Theme.of(context).backgroundColor,
                          color: Theme.of(context).primaryColor,
                          strokeWidth: 3,
                        )
                      : const Text('Login'),
                ),
              );
            },
          ),
        ),
      );
    },
  );
}

void createAccount(BuildContext context, List<TextEditingController> conts,
    List<String> texts, LoginBloc loginBloc) {
  showDialog(
    context: context,
    builder: (sheetContext) {
      return BlocProvider(
        create: (context) => AccountCreationBloc(),
        child: BlocBuilder<AccountCreationBloc, AccountCreationState>(
          buildWhen: (previous, current) =>
              previous.index != current.index || previous != current,
          builder: (context, state) {
            return GestureDetector(
              onTap: () {
                FocusManager.instance.primaryFocus?.unfocus();
              },
              child: Scaffold(
                appBar: AppBar(
                  title: const Text('Login'),
                  leading: TextButton(
                    onPressed: () {
                      for (TextEditingController element in conts) {
                        element.text = '';
                      }
                      context.read<AccountCreationBloc>().cancel();
                      Navigator.of(context).pop();
                    },
                    child: const FittedBox(
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: FloatingActionButton(
                          backgroundColor: state.index > 0 && !state.loading
                              ? Theme.of(context).primaryColor
                              : Theme.of(context).hoverColor,
                          onPressed: () {
                            if (!state.loading) {
                              FocusManager.instance.primaryFocus?.unfocus();
                              context.read<AccountCreationBloc>().back();
                            }
                          },
                          child: const Text('Back'),
                        ),
                      ),
                      if (!state.loading)
                        Text(
                          texts[state.index],
                          style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      !state.loading
                          ? SizedBox(
                              width: MediaQuery.of(context).size.width / 2,
                              child: AutofillGroup(
                                child: TextField(
                                  autofocus: true,
                                  decoration: outlineTextField(
                                    context: context,
                                    selected: Theme.of(context).primaryColor,
                                    stagnant: Theme.of(context).hoverColor,
                                    hintText: texts[state.index],
                                  ),
                                  controller: conts[state.index],
                                  keyboardAppearance: Brightness.dark,
                                  textCapitalization: TextCapitalization.sentences,
                                  onChanged: (change) => context
                                      .read<AccountCreationBloc>()
                                      .changes(change, state.index),
                                  keyboardType: state.index == 2
                                      ? TextInputType.emailAddress
                                      : state.index == 3
                                          ? TextInputType.text
                                          : TextInputType.name,
                                  autofillHints: state.index == 2
                                      ? [AutofillHints.email]
                                      : state.index == 3
                                          ? [AutofillHints.newPassword]
                                          : [AutofillHints.newUsername],
                                  onSubmitted: (_) {
                                    if (conts[state.index].text.isNotEmpty) {
                                      FocusManager.instance.primaryFocus?.unfocus();
                                      context
                                          .read<AccountCreationBloc>()
                                          .next(conts[state.index], context, loginBloc);
                                    }
                                  },
                                ),
                              ),
                            )
                          : CircularProgressIndicator(
                              backgroundColor: Theme.of(context).backgroundColor,
                              color: Theme.of(context).primaryColor,
                              strokeWidth: 3,
                            ),
                    ],
                  ),
                ),
                floatingActionButton: !state.loading
                    ? FloatingActionButton(
                        backgroundColor: conts[state.index].text.isNotEmpty
                            ? Theme.of(context).primaryColor
                            : Theme.of(context).hoverColor,
                        onPressed: () {
                          if (conts[state.index].text.isNotEmpty) {
                            FocusManager.instance.primaryFocus?.unfocus();
                            context
                                .read<AccountCreationBloc>()
                                .next(conts[state.index], context, loginBloc);
                          }
                        },
                        child: state.index < 3 ? const Text('Next') : const Text('done'),
                      )
                    : null,
              ),
            );
          },
        ),
      );
    },
  );
}

class Controller extends StatelessWidget {
  final List<Widget> pages;
  final String authorName;

  const Controller({Key? key, required this.pages, required this.authorName})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: 2,
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: TabBarView(
          children: pages,
        ),
        bottomNavigationBar: OrientationBuilder(builder: (portrait, orientation) {
          Orientation orient = orientation;
          return Container(
            height: MediaQuery.of(context).size.height / 10,
            margin: const EdgeInsets.only(bottom: 20),
            color: Theme.of(context).backgroundColor,
            child: TabBar(
              tabs: [
                Tab(
                  icon: Icon(
                    Icons.person,
                    color: Theme.of(context).primaryColor,
                  ),
                  child: orient == Orientation.portrait
                      ? Text(
                          'Account',
                          style: Theme.of(context).textTheme.bodyText1,
                        )
                      : null,
                ),
                Tab(
                  icon: Icon(
                    Icons.library_books,
                    color: Theme.of(context).primaryColor,
                  ),
                  child: orient == Orientation.portrait
                      ? Text(
                          'Library',
                          style: Theme.of(context).textTheme.bodyText1,
                        )
                      : null,
                ),
                Tab(
                  icon: Icon(
                    Icons.book,
                    color: Theme.of(context).primaryColor,
                  ),
                  child: orient == Orientation.portrait
                      ? Text(
                          'Books',
                          style: Theme.of(context).textTheme.bodyText1,
                        )
                      : null,
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
