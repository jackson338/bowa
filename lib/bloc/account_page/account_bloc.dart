part of 'account.dart';

class AccountBloc extends Cubit<AccountState> {
  final List<String> accountInfo;
  final LoginBloc loginBloc;
  AccountBloc({
    required this.accountInfo,
    required this.loginBloc,
  }) : super(const AccountState()) {
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
    final newUser = loginBloc.state.user!.copyWith(autoLogin: val);
    loginBloc.updateLibrary(newUser);
    final jsonString = jsonEncode(loginBloc.state.user!.toJson());
    prefs.setString('${loginBloc.state.user!.authorName} user', jsonString);
  }

  void nameEdit(editing) {
    emit(state.copyWith(nameEdit: editing));
  }

  void authorEdit(editing) {
    emit(state.copyWith(authorEdit: editing));
  }

  void emailEdit(editing) {
    emit(state.copyWith(emailEdit: editing));
  }

  void passwordEdit(editing) {
    emit(state.copyWith(passwordEdit: editing));
  }
}
