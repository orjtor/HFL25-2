import 'package:v03/models/hero_model.dart';

class ApiResponse {
  final String response;
  final String? error;
  final HeroModel? hero;

  const ApiResponse({required this.response, this.error, this.hero});

  bool get isSuccess => response == 'success';

  factory ApiResponse.fromMap(Map<String, dynamic> map) {
    return ApiResponse(
      response: map['response'] as String,
      error: map['error'] as String?,
      hero: map['response'] == 'success' ? HeroModel.fromMap(map) : null,
    );
  }
}
