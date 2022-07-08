import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/account_page/account.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String name = 'Name';
    return BlocProvider(
      create: (_) => AccountBloc(button: 'Account Page Baby!'),
      child: BlocBuilder<AccountBloc, AccountState>(
        builder: (context, state) {
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
                      width: MediaQuery.of(context).size.width / 2,
                      decoration: BoxDecoration(
                          color: Theme.of(context).hoverColor, shape: BoxShape.circle),
                      child: Image.asset('lib/images/Untitled_Artwork.png'),
                    ),
                  ),
                  Center(
                    child: GestureDetector(
                      onTap: () {

                      },
                      child: Text(
                        name,
                        style: const TextStyle(fontSize: 30),
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
