part of 'account.dart';

class AccountBloc extends Cubit<AccountState> {
  final List<String> accountInfo;
  AccountBloc({required this.accountInfo}) : super(const AccountState()) {
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
    state.accountInfo.isEmpty
        ? emit(state.copyWith(autoLogin: autoLogin, accountInfo: accountInfo))
        : emit(state.copyWith(autoLogin: autoLogin));
  }

  void switchAutoLogin(bool val) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (val) {
      prefs.setStringList('auto login', accountInfo);
    } else {
      prefs.setStringList('auto login', []);
    }
    emit(state.copyWith(autoLogin: val));
  }

  void nameEdit(editing) {
    emit(state.copyWith(nameEdit: editing));
  }

  void authorEdit(editing) {
    emit(state.copyWith(authorEdit: editing));
  }

  void changeName(newName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> newInfo = [];
    newInfo.addAll(state.accountInfo);
    newInfo[0] = newName;
    prefs.setStringList('${accountInfo[1]} Account Info', newInfo);
    prefs.setStringList('auto login', newInfo);
    emit(state.copyWith(accountInfo: newInfo));
  }

  void changeAuthor(newAuthor) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> newInfo = [];
    newInfo.addAll(state.accountInfo);
    newInfo[1] = newAuthor;
    prefs.remove('${accountInfo[1]} Account Info');
    prefs.setStringList('${newInfo[1]} Account Info', newInfo);
    prefs.setStringList('auto login', newInfo);
    emit(state.copyWith(accountInfo: newInfo));
  }
}
