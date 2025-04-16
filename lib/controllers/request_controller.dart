import 'dart:convert';
import 'dart:io';
import 'package:flutter_application/models/form_model.dart';
import 'package:flutter_application/utils/exceptions.dart';
import 'package:flutter_application/config/api_config.dart';
import 'package:http/http.dart' as http;

class RequestController {
  final String baseUrl = ApiConfig.baseUrl;
  final String bearerToken = ApiConfig.bearerToken;

  Future<Map<String, dynamic>> saveData({required FormModel formData}) async {
    try {
      final http.Response response = await http.post(
        Uri.parse("$baseUrl/submit"),
        body: json.encode(formData.toMap()),
        headers: {
          "Content-Type": "application/json",
          'Authorization': "Bearer $bearerToken"
        },
      ).timeout(
        Duration(seconds: ApiConfig.timeoutDuration),
        onTimeout: () {
          throw NetworkException("Request timeout. Please check your internet connection.");
        },
      );

      // Parse response
      final responseData = json.decode(response.body);
      
      // Handle different status codes
      if (response.statusCode == 200 || response.statusCode == 201) {
        return responseData;
      } else if (response.statusCode == 400) {
        throw ApiException("Invalid form data", statusCode: response.statusCode);
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        throw ApiException("Authentication error. Please login again.", statusCode: response.statusCode);
      } else if (response.statusCode == 500) {
        throw ApiException("Server error. Please try again later.", statusCode: response.statusCode);
      } else {
        throw ApiException("Request failed with status: ${response.statusCode}", statusCode: response.statusCode);
      }
    } on SocketException {
      throw NetworkException("No internet connection. Please check your network.");
    } on FormatException {
      throw ApiException("Invalid response format from server.");
    } on HttpException {
      throw ApiException("Couldn't reach the server. Please try again.");
    } catch (e) {
      if (e is ApiException || e is NetworkException) {
        rethrow;
      }
      throw ApiException("An unexpected error occurred: ${e.toString()}");
    }
  }
}