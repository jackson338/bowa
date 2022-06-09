
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/home_page/account.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AccountBloc(button: 'Account Page Baby!'),
      child: BlocBuilder<AccountBloc, AccountState>(
        builder: (context, state) {
          return Scaffold(
              appBar: AppBar(
                title: Text(state.title),
                backgroundColor: Theme.of(context).primaryColor,
              ),
              body: const Text('account'));
        },
      ),
    );
  }
}
