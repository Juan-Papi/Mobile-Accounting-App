class Errors {
  final List<String>? email;
  final List<String>? password;

  Errors({
    this.email,
    this.password,
  });

  factory Errors.fromJson(Map<String, dynamic> json) => Errors(
        email: json["email"] != null
            ? List<String>.from(json["email"].map((x) => x))
            : null,
        password: json["password"] != null
            ? List<String>.from(json["password"].map((x) => x))
            : null,
      );

  Map<String, dynamic> toJson() => {
        if (email != null) "email": List<dynamic>.from(email!.map((x) => x)),
        if (password != null)
          "password": List<dynamic>.from(password!.map((x) => x)),
      };
}
