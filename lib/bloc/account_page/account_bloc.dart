


part of 'account.dart';

class AccountBloc extends Cubit<AccountState> {
  final String button;
  AccountBloc({
    required this.button,
  }) : super(const AccountState());
  
}
