import 'package:bowa/bloc/login_bloc/account_creation/account_creation.dart';
import 'package:bowa/bloc/login_bloc/login.dart';
import 'package:bowa/pages/account_page.dart';
import 'package:bowa/pages/books_page/books_page.dart';
import 'package:bowa/pages/library_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.orange,
          primaryColor: Colors.orange,
          primaryColorLight: Colors.orangeAccent,
          primaryColorDark: Colors.deepOrange,
          backgroundColor: Colors.white,
          disabledColor: Colors.grey[800],
          hoverColor: Colors.grey,
          cardColor: Colors.white,
          // brightness: Brightness.dark,
        ),
        home: LoginPage());
  }
}

class LoginPage extends StatelessWidget {
  const LoginPage({
    Key? key,
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
          if (state.loggedIn) {
            List<String> accountInfo = [
              state.name,
              state.authorName,
              state.email,
              state.password
            ];
            pages = [
              AccountPage(
                authorName: state.authorName,
                accountInfo: accountInfo,
              ),
              const LibraryPage(),
              const BooksPage(),
            ];
          }
          return state.loggedIn
              ? Controller(
                  authorName: state.authorName,
                  pages: pages,
                )
              : Scaffold(
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
                            child: TextButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    Theme.of(context).primaryColor),
                                elevation: MaterialStateProperty.all(5),
                              ),
                              onPressed: () => login(context, context.read<LoginBloc>()),
                              child: const Text(
                                'Login',
                                maxLines: 1,
                                style: TextStyle(color: Colors.black, fontSize: 25.0),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: TextButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    Theme.of(context).primaryColor),
                                elevation: MaterialStateProperty.all(5),
                              ),
                              onPressed: () => createAccount(
                                  context, conts, texts, context.read<LoginBloc>()),
                              child: const Text(
                                'Create Account :)',
                                maxLines: 1,
                                style: TextStyle(color: Colors.black, fontSize: 25.0),
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
                previous.autoLogin != current.autoLogin,
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 1,
                            color: Colors.grey,
                          ),
                        ),
                        width: MediaQuery.of(context).size.width / 2,
                        child: TextField(
                          autofocus: true,
                          decoration: const InputDecoration(hintText: 'Name'),
                          controller: name,
                          keyboardAppearance: Brightness.dark,
                          onChanged: (nameText) => loginBloc.name(nameText),
                          keyboardType: TextInputType.name,
                          onSubmitted: (_) {},
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 1,
                            color: Colors.grey,
                          ),
                        ),
                        width: MediaQuery.of(context).size.width / 2,
                        child: TextField(
                          autofocus: true,
                          decoration: const InputDecoration(hintText: 'Password'),
                          controller: password,
                          obscureText: true,
                          keyboardAppearance: Brightness.dark,
                          onChanged: (pass) => loginBloc.password(pass),
                          onSubmitted: (_) {},
                        ),
                      ),
                      // : CircularProgressIndicator(
                      //     backgroundColor: Theme.of(context).backgroundColor,
                      //     color: Theme.of(context).primaryColor,
                      //     strokeWidth: 3,
                      //   ),

                      Switch(
                        value: state.autoLogin,
                        onChanged: (val) {
                          origLoginBloc.switchAutoLogin(val);
                          context.read<LoginBloc>().switchAutoLogin(val);
                        },
                      ),
                    ],
                  ),
                ),
                floatingActionButton: FloatingActionButton(
                  backgroundColor: name.text.isNotEmpty && password.text.isNotEmpty
                      ? Theme.of(context).primaryColor
                      : Theme.of(context).hoverColor,
                  onPressed: () {
                    FocusManager.instance.primaryFocus?.unfocus();
                    origLoginBloc.login(name.text, password.text, context);
                  },
                  child: const Text('Login'),
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
                      // if (state.index == 1)
                      //   Padding(
                      //     padding: const EdgeInsets.all(8.0),
                      //     child: TextButton(
                      //       onPressed: () {
                      //         // conts[1].text =
                      //       },
                      //       child: const Text('Use Name'),
                      //     ),
                      //   ),
                      !state.loading
                          ? Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 1,
                                  color: Colors.grey,
                                ),
                              ),
                              width: MediaQuery.of(context).size.width / 2,
                              child: TextField(
                                autofocus: true,
                                decoration: InputDecoration(hintText: texts[state.index]),
                                controller: conts[state.index],
                                keyboardAppearance: Brightness.dark,
                                textCapitalization: TextCapitalization.sentences,
                                onChanged: (change) => context
                                    .read<AccountCreationBloc>()
                                    .changes(change, state.index),
                                keyboardType: state.index == 2
                                    ? TextInputType.emailAddress
                                    : state.index == 3
                                        ? TextInputType.visiblePassword
                                        : TextInputType.name,
                                onSubmitted: (_) {
                                  if (conts[state.index].text.isNotEmpty) {
                                    FocusManager.instance.primaryFocus?.unfocus();
                                    context
                                        .read<AccountCreationBloc>()
                                        .next(conts[state.index], context, loginBloc);
                                  }
                                },
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
        body: TabBarView(
          children: pages,
        ),
        bottomNavigationBar: OrientationBuilder(builder: (portrait, orientation) {
          Orientation orient = orientation;
          return Container(
            height: MediaQuery.of(context).size.height / 10,
            margin: const EdgeInsets.only(bottom: 20),
            child: TabBar(
              tabs: [
                Tab(
                  icon: Icon(
                    Icons.person,
                    color: Theme.of(context).primaryColor,
                  ),
                  child: orient == Orientation.portrait
                      ? const Text(
                          'Account',
                        )
                      : null,
                ),
                Tab(
                  icon: Icon(
                    Icons.library_books,
                    color: Theme.of(context).primaryColor,
                  ),
                  child: orient == Orientation.portrait
                      ? const Text(
                          'Library',
                        )
                      : null,
                ),
                Tab(
                  icon: Icon(
                    Icons.book,
                    color: Theme.of(context).primaryColor,
                  ),
                  child: orient == Orientation.portrait
                      ? const Text(
                          'Books',
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
