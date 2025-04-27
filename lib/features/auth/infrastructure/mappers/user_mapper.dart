import 'package:teslo_shop/features/auth/domain/entities/user.dart';

class UserMapper {
  const UserMapper._();

  static User fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        token: json["token"],
      );

  static Map<String, dynamic> toJson(User user) => {
        "id": user.id,
        "name": user.name,
        "email": user.email,
        "token": user.token,
      };
}
