import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/account_page/account.dart';

class AccountPage extends StatelessWidget {
  final String authorName;
  final List<String> accountInfo;
  const AccountPage({Key? key, required this.authorName, required this.accountInfo})
      : super(key: key);

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
                                    controller.text = state.accountInfo[0];
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
                                            accountBloc.changeName(controller.text);
                                            accountBloc.nameEdit(false);
                                          },
                                        )
                                      : FittedBox(
                                          child: Text(
                                            'Name: ${state.accountInfo[0]}',
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
                                    authorNameCont.text = state.accountInfo[1];
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
                                            accountBloc.changeAuthor(authorNameCont.text);
                                            accountBloc.authorEdit(false);
                                          },
                                        )
                                      : FittedBox(
                                          child: Text(
                                            'Author Name: ${state.accountInfo[1]}',
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
                                    emailCont.text = state.accountInfo[2];
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
                                            accountBloc.changeEmail(emailCont.text);
                                            accountBloc.emailEdit(false);
                                          },
                                        )
                                      : FittedBox(
                                          child: Text(
                                            'Email: ${state.accountInfo[2]}',
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
                                    passwordCont.text = state.accountInfo[3];
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
                                            accountBloc.changePassword(passwordCont.text);
                                            accountBloc.passwordEdit(false);
                                          },
                                        )
                                      : FittedBox(
                                          child: Text(
                                            'Password: ${state.accountInfo[3]}',
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
