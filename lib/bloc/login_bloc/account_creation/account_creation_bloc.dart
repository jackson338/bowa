part of 'account_creation.dart';

class AccountCreationBloc extends Cubit<AccountCreationState> {
  AccountCreationBloc() : super(const AccountCreationState());

  void submit(
    TextEditingController nameCont,
    TextEditingController authorNameCont,
    TextEditingController emailCont,
    TextEditingController passwordCont,
    TextEditingController passwordConfirmCont,
  ) {
    if (nameCont.text.isEmpty ||
        authorNameCont.text.isEmpty ||
        emailCont.text.isEmpty ||
        passwordCont.text.isEmpty ||
        passwordConfirmCont.text.isEmpty) {}
  }

  void cancel() {
    emit(state.copyWith(
      loading: false,
      authorName: '',
      email: '',
      name: '',
      password: '',
      index: 0,
      autoLogin: false,
      loggedIn: false,
    ));
  }

  void changes(String change, int index) {
    if (state.index == 0) {
      emit(state.copyWith(name: change));
    }
    if (state.index == 1) {
      emit(state.copyWith(authorName: change));
    }
    if (state.index == 2) {
      emit(state.copyWith(email: change));
    }
    if (state.index == 3) {
      emit(state.copyWith(password: change));
    }
  }

  void next(TextEditingController cont, BuildContext context, LoginBloc loginBloc) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int newIndex = state.index;
    if (state.index == 3) {
      TextEditingController password = cont;
      emit(state.copyWith(index: newIndex, password: password.text, loading: true));
      List<String> accountInfo = [
        state.name,
        state.authorName,
        state.email,
        state.password
      ];
      prefs.setStringList('${state.authorName} Account Info', accountInfo);
      Duration dur = const Duration(seconds: 1);
      Timer(dur, () {
        emit(state.copyWith(loading: false, loggedIn: true));
        loginBloc.accountCreated();
        Navigator.of(context).pop();
      });
    }
    if (newIndex <= 2) {
      newIndex += 1;
    }
    if (state.index == 0) {
      TextEditingController name = cont;
      emit(state.copyWith(index: newIndex, name: name.text));
    }
    if (state.index == 1) {
      TextEditingController author = cont;
      emit(state.copyWith(index: newIndex, authorName: author.text));
    }
    if (state.index == 2) {
      TextEditingController email = cont;
      emit(state.copyWith(index: newIndex, email: email.text));
    }
  }

  void back() {
    int newIndex = state.index;
    if (!newIndex.isNegative) {
      newIndex -= 1;
      emit(state.copyWith(index: newIndex, loading: false));
    }
  }

  void useName() {
    String newAuthor = state.name;
    emit(state.copyWith(authorName: newAuthor));
  }
}
