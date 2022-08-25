part of 'account.dart';

class AccountBloc extends Cubit<AccountState> {
  final String button;
  final List<String> accountInfo;
  AccountBloc({required this.button, required this.accountInfo})
      : super(const AccountState()) {
    init();
  }

  void init() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool autoLogin = false;
    if (prefs.getStringList('auto login') != null) {
      if (prefs.getStringList('auto login')!.isNotEmpty) {
        autoLogin = true;
      }
    }
    emit(state.copyWith(autoLogin: autoLogin, accountInfo: accountInfo));
  }

  void switchAutoLogin(bool val) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (val == true) {
      prefs.setStringList('auto login', accountInfo);
    } else {
      prefs.setStringList('auto login', []);
    }
    emit(state.copyWith(autoLogin: val));
  }

  void nameEdit(editing) {
    emit(state.copyWith(nameEdit: editing));
  }

  void changeName(newName) {
    List<String> newInfo = [];
    newInfo.addAll(state.accountInfo);
    newInfo[0] = newName;
    emit(state.copyWith(accountInfo: newName));
  }
}
