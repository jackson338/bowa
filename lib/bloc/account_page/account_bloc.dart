part of 'account.dart';

class AccountBloc extends Cubit<AccountState> {
  final String button;
  AccountBloc({
    required this.button,
  }) : super(const AccountState()) {
    init();
  }

  void init() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
  }

  void nameEdit(editing) {
    emit(state.copyWith(nameEdit: editing));
  }

  void changeName(newName) {
    emit(state.copyWith(name: newName));
  }
}
