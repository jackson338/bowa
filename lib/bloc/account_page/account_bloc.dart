part of 'account.dart';

class AccountBloc extends Cubit<AccountState> {
  final String button;
  AccountBloc({
    required this.button,
  }) : super(const AccountState());

  void nameEdit(editing) {
    emit(state.copyWith(nameEdit: editing));
  }

  void changeName(newName) {
    emit(state.copyWith(name: newName));
  }
}
