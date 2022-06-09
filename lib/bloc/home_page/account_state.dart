part of 'account.dart';

class AccountState {
  final String title;

  const AccountState({this.title = 'Account State'});

  AccountState copyWith({
    final String? title,
  }) {
    return AccountState(title: title ?? this.title);
  }
}
