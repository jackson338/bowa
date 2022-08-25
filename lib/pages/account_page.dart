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
    return BlocProvider(
      create: (_) => AccountBloc(button: 'Account Page Baby!', accountInfo: accountInfo),
      child: BlocBuilder<AccountBloc, AccountState>(
        builder: (context, state) {
          final accountBloc = context.read<AccountBloc>();
          return Scaffold(
            appBar: AppBar(
              title: Text(state.title),
              backgroundColor: Theme.of(context).primaryColor,
            ),
            body: Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: Column(
                children: [
                  Center(
                    child: Container(
                      width: MediaQuery.of(context).size.width / 3,
                      decoration: BoxDecoration(
                          color: Theme.of(context).hoverColor, shape: BoxShape.circle),
                      child: Image.asset('lib/images/Untitled_Artwork.png'),
                    ),
                  ),
                  // SizedBox(
                  //   width: MediaQuery.of(context).size.width / 2,
                  //   child: Center(
                  //     child: GestureDetector(
                  //       onTap: () {
                  //         controller.text = state.accountInfo[0];
                  //         accountBloc.nameEdit(true);
                  //       },
                  //       child: state.nameEdit
                  //           ? TextField(
                  //               controller: controller,
                  //               autofocus: true,
                  //               onSubmitted: (_) {
                  //                 FocusManager.instance.primaryFocus?.unfocus();
                  //                 accountBloc.changeName(controller.text);
                  //                 accountBloc.nameEdit(false);
                  //               },
                  //             )
                  //           : FittedBox(
                  //               child: Text(
                  //                 'Name: ${state.accountInfo[0]}',
                  //                 style: const TextStyle(fontSize: 30),
                  //               ),
                  //             ),
                  //     ),
                  //   ),
                  // ),
                  // SizedBox(
                  //   width: MediaQuery.of(context).size.width / 2,
                  //   child: Center(
                  //     child: GestureDetector(
                  //       onTap: () {
                  //         authorNameCont.text = state.accountInfo[1];
                  //         accountBloc.nameEdit(true);
                  //       },
                  //       child: state.nameEdit
                  //           ? TextField(
                  //               controller: authorNameCont,
                  //               autofocus: true,
                  //               onSubmitted: (_) {
                  //                 FocusManager.instance.primaryFocus?.unfocus();
                  //                 accountBloc.changeName(controller.text);
                  //                 accountBloc.nameEdit(false);
                  //               },
                  //             )
                  //           : FittedBox(
                  //               child: Text(
                  //                 'Author Name: ${state.accountInfo[1]}',
                  //                 style: const TextStyle(fontSize: 30),
                  //               ),
                  //             ),
                  //     ),
                  //   ),
                  // ),
                  // Row(o
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     const Text('Auto Login'),
                  //     Switch(
                  //       value: state.autoLogin,
                  //       onChanged: (val) => accountBloc.switchAutoLogin(val),
                  //     ),
                  //   ],
                  // ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
