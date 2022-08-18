import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/account_page/account.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController();
    return BlocProvider(
      create: (_) => AccountBloc(button: 'Account Page Baby!'),
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
                  SizedBox(
                      width: MediaQuery.of(context).size.width / 2,
                      child: Center(
                      child: GestureDetector(
                        onTap: () {
                          controller.text = state.name;
                          accountBloc.nameEdit(true);
                        },
                        child: state.nameEdit
                            ? TextField(
                                controller: controller,
                                autofocus: true,
                                onSubmitted: (_) {
                                  FocusManager.instance.primaryFocus?.unfocus();
                                  accountBloc.changeName(controller.text);
                                  accountBloc.nameEdit(false);
                                },
                              )
                            : FittedBox(
                              child: Text(
                                  state.name,
                                  style: const TextStyle(fontSize: 30),
                                ),
                            ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
