part of 'account.dart';

class AccountState {
  final String title;
  final String name;
  final bool nameEdit;

  const AccountState({
    this.title = 'Account',
    this.name = 'Name',
    this.nameEdit = false,
  });

  AccountState copyWith({
    final String? title,
    final String? name,
    final bool? nameEdit,
  }) {
    return AccountState(
      title: title ?? this.title,
      name: name ?? this.name,
      nameEdit: nameEdit ?? this.nameEdit,
    );
  }
}
