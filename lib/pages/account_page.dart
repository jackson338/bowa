import 'package:bowa/bloc/login_bloc/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/account_page/account.dart';

class AccountPage extends StatelessWidget {
  final String authorName;
  final List<String> accountInfo;
  final LoginBloc loginBloc;
  const AccountPage({
    Key? key,
    required this.authorName,
    required this.accountInfo,
    required this.loginBloc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController();
    final authorNameCont = TextEditingController();
    final emailCont = TextEditingController();
    final passwordCont = TextEditingController();
    return BlocProvider(
      create: (_) => AccountBloc(accountInfo: accountInfo),
      child: BlocBuilder<AccountBloc, AccountState>(
        builder: (context, state) {
          final accountBloc = context.read<AccountBloc>();
          return state.accountInfo.isEmpty
              ? const Center(
                  child: CircularProgressIndicator(
                  strokeWidth: 10,
                ))
              : Scaffold(
                  appBar: AppBar(
                    elevation: 0,
                    title: Text(
                      state.title,
                      style: Theme.of(context).textTheme.headline1,
                    ),
                    backgroundColor: Theme.of(context).backgroundColor,
                  ),
                  body: Container(
                    color: Theme.of(context).backgroundColor,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: Column(
                        children: [
                          Center(
                            child: Container(
                              width: MediaQuery.of(context).size.width / 6,
                              decoration: BoxDecoration(
                                  color: Theme.of(context).hoverColor,
                                  shape: BoxShape.circle),
                              child: Image.asset('lib/images/Untitled_Artwork.png'),
                            ),
                          ),
                          // name text and editor
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width / 2,
                              child: Center(
                                child: GestureDetector(
                                  onTap: () {
                                    controller.text = loginBloc.state.user!.username;
                                    accountBloc.nameEdit(true);
                                  },
                                  child: state.nameEdit
                                      ? TextField(
                                          style: Theme.of(context).textTheme.bodyText1,
                                          controller: controller,
                                          autofocus: true,
                                          keyboardAppearance: Brightness.dark,
                                          onSubmitted: (_) {
                                            FocusManager.instance.primaryFocus?.unfocus();
                                            // accountBloc.changeName(controller.text);
                                            loginBloc.updateUsername(controller.text);
                                            accountBloc.nameEdit(false);
                                          },
                                        )
                                      : FittedBox(
                                          child: Text(
                                            'Name: ${loginBloc.state.user!.username}',
                                            style: TextStyle(
                                                fontSize: 30,
                                                color: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1!
                                                    .color),
                                          ),
                                        ),
                                ),
                              ),
                            ),
                          ),
                          // author name text and editor
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width / 2,
                              child: Center(
                                child: GestureDetector(
                                  onTap: () {
                                    authorNameCont.text = loginBloc.state.user!.authorName;
                                    accountBloc.authorEdit(true);
                                  },
                                  child: state.authorEdit
                                      ? TextField(
                                          style: Theme.of(context).textTheme.bodyText1,
                                          controller: authorNameCont,
                                          autofocus: true,
                                          keyboardAppearance: Brightness.dark,
                                          onSubmitted: (_) {
                                            FocusManager.instance.primaryFocus?.unfocus();
                                            loginBloc.updateAuthor(authorNameCont.text);
                                            accountBloc.authorEdit(false);
                                          },
                                        )
                                      : FittedBox(
                                          child: Text(
                                            'Author Name: ${loginBloc.state.user!.authorName}',
                                            style: TextStyle(
                                                fontSize: 30,
                                                color: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1!
                                                    .color),
                                          ),
                                        ),
                                ),
                              ),
                            ),
                          ),
                          // email text and editor
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width / 2,
                              child: Center(
                                child: GestureDetector(
                                  onTap: () {
                                    emailCont.text = loginBloc.state.user!.email;
                                    accountBloc.emailEdit(true);
                                  },
                                  child: state.emailEdit
                                      ? TextField(
                                          style: Theme.of(context).textTheme.bodyText1,
                                          controller: emailCont,
                                          autofocus: true,
                                          keyboardAppearance: Brightness.dark,
                                          onSubmitted: (_) {
                                            FocusManager.instance.primaryFocus?.unfocus();
                                            loginBloc.updateEmail(emailCont.text);
                                            accountBloc.emailEdit(false);
                                          },
                                        )
                                      : FittedBox(
                                          child: Text(
                                            'Email: ${loginBloc.state.user!.email}',
                                            style: TextStyle(
                                                fontSize: 30,
                                                color: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1!
                                                    .color),
                                          ),
                                        ),
                                ),
                              ),
                            ),
                          ),
                          // password text and editor
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width / 2,
                              child: Center(
                                child: GestureDetector(
                                  onTap: () {
                                    passwordCont.text = loginBloc.state.user!.password;
                                    accountBloc.passwordEdit(true);
                                  },
                                  child: state.passwordEdit
                                      ? TextField(
                                          style: Theme.of(context).textTheme.bodyText1,
                                          controller: passwordCont,
                                          autofocus: true,
                                          keyboardAppearance: Brightness.dark,
                                          onSubmitted: (_) {
                                            FocusManager.instance.primaryFocus?.unfocus();
                                            loginBloc.updatePassword(passwordCont.text);
                                            accountBloc.passwordEdit(false);
                                          },
                                        )
                                      : FittedBox(
                                          child: Text(
                                            'Password: ${loginBloc.state.user!.password}',
                                            style: TextStyle(
                                                fontSize: 30,
                                                color: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1!
                                                    .color),
                                          ),
                                        ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Auto Login',
                                  style: Theme.of(context).textTheme.bodyText1,
                                ),
                                Switch(
                                  value: state.autoLogin,
                                  activeColor: Theme.of(context).primaryColor,
                                  activeTrackColor: Theme.of(context).primaryColorLight,
                                  inactiveTrackColor: Theme.of(context).hoverColor,
                                  inactiveThumbColor: Theme.of(context).primaryColor,
                                  onChanged: (val) => accountBloc.switchAutoLogin(val),
                                ),
                              ],
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
