import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';

class ChatController extends GetxController {
  final storage = GetStorage();
  var searchResults = [].obs;
  var isLoading = false.obs;
  var query = ''.obs;

  Future<void> search() async {
    String? token = storage.read("token");
    if (token == null) {
      Get.snackbar("Error", "No authentication token found");
      return;
    }

    final url = Uri.parse('http://snapkar.com/api/chat.php');
    final headers = {'Content-Type': 'application/json'};
    final payload = {
      "auth_key": token,
      "query": query.value,
      "skip": 0,
      "top": 10,
    };

    try {
      isLoading(true);
      final response = await http.post(
        url,
        headers: headers,
        body: json.encode(payload),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 1) {
          searchResults.value = data['result'];
        } else {
          searchResults.clear();
          Get.snackbar("No Results", "No record found");
        }
      } else {
        Get.snackbar(
          "Error",
          "Server responded with status: ${response.statusCode}",
        );
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong: $e");
    } finally {
      isLoading(false);
    }
  }
}
