class ProviderResponse {
  final List<Provider> providers;

  ProviderResponse({
    required this.providers,
  });

  factory ProviderResponse.fromJson(Map<String, dynamic> json) =>
      ProviderResponse(
        providers:
            List<Provider>.from(json["providers"].map((x) => Provider.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "providers": List<dynamic>.from(providers.map((x) => x.toJson())),
      };
}

class Provider {
  final int id;
  final String name;
  final String address;
  final String phone;
  final String email;
  final DateTime createdAt;
  final DateTime updatedAt;

  Provider({
    required this.id,
    required this.name,
    required this.address,
    required this.phone,
    required this.email,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Provider.fromJson(Map<String, dynamic> json) => Provider(
        id: json["id"],
        name: json["name"],
        address: json["address"],
        phone: json["phone"],
        email: json["email"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "address": address,
        "phone": phone,
        "email": email,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
