// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const [
      'username',
      'authorName',
      'email',
      'password',
      'id',
      'autoLogin'
    ],
  );
  return User(
    username: json['username'] as String,
    authorName: json['authorName'] as String,
    email: json['email'] as String,
    password: json['password'] as String,
    id: json['id'] as String,
    autoLogin: json['autoLogin'] as bool,
    library: (json['library'] as List<dynamic>?)
        ?.map((e) => Book.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'username': instance.username,
      'authorName': instance.authorName,
      'email': instance.email,
      'password': instance.password,
      'id': instance.id,
      'autoLogin': instance.autoLogin,
      'library': instance.library,
    };
