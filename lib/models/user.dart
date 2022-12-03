import 'package:bowa/models/book.dart';
import 'package:json_annotation/json_annotation.dart';
part 'user.g.dart';


@JsonSerializable()
class User {
  @JsonKey(required: true)
  final String username;
  @JsonKey(required: true)
  final String authorName;
  @JsonKey(required: true)
  final String email;
  @JsonKey(required: true)
  final String password;
  @JsonKey(required: true)
  final String id;
  @JsonKey(required: true)
  final bool autoLogin;
  final List<Book>? library;
  const User({
    required this.username,
    required this.authorName,
    required this.email,
    required this.password,
    required this.id,
    required this.autoLogin,
    this.library,
  });

  const User.empty({
    this.username = '',
    this.authorName = '',
    this.email = '',
    this.password = '',
    this.autoLogin = false,
    this.id = '',
    this.library = const [],
  });

  User copyWith({
    String? username,
    String? authorName,
    String? email,
    String? password,
    String? id,
    bool? autoLogin,
    List<Book>? library,
  }) {
    return User(
      username: username ?? this.username,
      authorName: authorName ?? this.authorName,
      email: email ?? this.email,
      password: password ?? this.password,
      id: id ?? this.id,
      autoLogin: autoLogin ?? this.autoLogin,
      library: library ?? this.library,
    );
  }

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this); 
}

