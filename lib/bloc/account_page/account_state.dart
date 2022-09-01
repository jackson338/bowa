part of 'account.dart';

class AccountState {
  final String title;
  final String name;
  final List<String> accountInfo;
  final bool nameEdit;
  final bool authorEdit;
  final bool autoLogin;

  const AccountState({
    this.title = 'Account',
    this.name = 'Name',
    this.accountInfo = const [],
    this.nameEdit = false,
    this.authorEdit = false,
    this.autoLogin = false,
  });

  AccountState copyWith({
    final String? title,
    final String? name,
    final List<String>? accountInfo,
    final bool? nameEdit,
    final bool? authorEdit,
    final bool? autoLogin,
  }) {
    return AccountState(
      title: title ?? this.title,
      name: name ?? this.name,
      accountInfo: accountInfo ?? this.accountInfo,
      nameEdit: nameEdit ?? this.nameEdit,
      authorEdit: authorEdit ?? this.authorEdit,
      autoLogin: autoLogin ?? this.autoLogin,
    );
  }
}
