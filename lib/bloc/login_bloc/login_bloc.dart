part of 'login.dart';

class LoginBloc extends Cubit<LoginState> {
  LoginBloc() : super(const LoginState()) {
    init();
  }

  void init() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? id = prefs.getString('auto login');
    if (id != null) {
      if (id.isNotEmpty) {
        User? user = await createUserObject(id);
        emit(state.copyWith(
          name: user.username,
          authorName: user.authorName,
          email: user.email,
          password: user.password,
          loggedIn: true,
          user: user,
        ));
      }
    }
  }

  void updateUsername(String username) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final User newUser = state.user!.copyWith(username: username);
    prefs.remove('${state.user!.id} user');
    emit(state.copyWith(user: newUser));
    final jsonString = jsonEncode(state.user!.toJson());
    prefs.setString('${state.user!.id} user', jsonString);
  }

  void updateAuthor(String authorName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final newUser = state.user!.copyWith(authorName: authorName);
    prefs.remove('${state.user!.id} user');
    emit(state.copyWith(user: newUser));
    final jsonString = jsonEncode(state.user!.toJson());
    prefs.setString('${state.user!.id} user', jsonString);
  }

  void updateEmail(String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final newUser = state.user!.copyWith(email: email);
    prefs.remove('${state.user!.id} user');
    emit(state.copyWith(user: newUser));
    final jsonString = jsonEncode(state.user!.toJson());
    prefs.setString('${state.user!.id} user', jsonString);
  }

  void updatePassword(String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final newUser = state.user!.copyWith(password: password);
    prefs.remove('${state.user!.id} user');
    emit(state.copyWith(user: newUser));
    final jsonString = jsonEncode(state.user!.toJson());
    prefs.setString('${state.user!.id} user', jsonString);
  }

  void name(name) {
    emit(state.copyWith(name: name));
  }

  void password(password) async {
    emit(state.copyWith(password: password));
  }

  void login(
    String username,
    String password,
    BuildContext context,
  ) async {
    final nav = Navigator.of(context);
    final contx = ScaffoldMessenger.of(context);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? id = prefs.getString('$username $password id');
    User user = const User.empty();
    if (id != null) {
      User? user = await createUserObject(id);
      if (state.autoLogin == true) {
        prefs.setString('auto login', id);
      } else {
        prefs.setString('auto login', '');
      }
      emit(state.copyWith(loggedIn: true, user: user));
      nav.pop();
    } else {
      contx.showSnackBar(const SnackBar(
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        dismissDirection: DismissDirection.down,
        duration: Duration(seconds: 1),
        margin: EdgeInsets.all(10.0),
        elevation: 3,
        content: Text('Incorrect Login'),
      ));
    }
  }

  void loading(bool loading) {
    emit(state.copyWith(loading: loading));
  }

  void switchAutoLogin(bool val) {
    emit(state.copyWith(autoLogin: val));
  }

  void accountCreated(User user) async {
    emit(state.copyWith(loggedIn: true, user: user));
  }

  void updateLibrary(User newUser) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    emit(state.copyWith(user: newUser));
    final jsonString = jsonEncode(state.user!.toJson());
    prefs.setString('${state.user!.id} user', jsonString);
  }
}
