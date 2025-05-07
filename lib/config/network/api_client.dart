abstract class ApiClient {
  Future<Map<String, dynamic>> get(String endpoint,
      {Map<String, dynamic>? queryParams, Map<String, dynamic>? data});

  Future<Map<String, dynamic>> post(String endpoint,
      {Map<String, dynamic>? data, bool isMultipart = false});

  Future<Map<String, dynamic>> put(String endpoint,
      {Map<String, dynamic>? data});

  Future<Map<String, dynamic>> delete(String endpoint,
      {Map<String, dynamic>? data});
}
