import 'package:teslo_shop/core/data/models/errors_model.dart';

class ApiResponse {
  final bool success;
  final String message;
  final dynamic data;
  final String? error;
  final Errors? errors;

  ApiResponse({
    required this.success,
    required this.message,
    this.data,
    this.error,
    this.errors,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json) => ApiResponse(
        success: json["success"],
        message: json["message"],
        data: json["data"],
        error: json["error"],
        errors: json["errors"] != null ? Errors.fromJson(json["errors"]) : null,
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        if (data != null) "data": data,
        if (error != null) "error": error,
        if (errors != null) "errors": errors!.toJson(),
      };
}
