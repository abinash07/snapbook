import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:get_storage/get_storage.dart';
import 'package:snapbook/home.dart';

class LoginController extends GetxController {
  var isLoading = false.obs;
  final storage = GetStorage(); // Alternative to SharedPreferences

  Future<void> loginUser(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      Get.snackbar(
        "Error",
        "Please enter both email and password",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isLoading(true);
    final String apiUrl = 'http://snapkar.com/api/login.php';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: jsonEncode({'username': email, 'password': password}),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
      );

      var responseData = json.decode(response.body.toString());

      if (response.statusCode == 200 && responseData['status'] == 1) {
        var result = responseData['result'];

        // Save user data
        storage.write("Login", true);
        storage.write("name", result['name']);
        storage.write("username", result['username']);
        storage.write("bio", result['bio']);
        storage.write("email", result['email']);
        storage.write("token", result['auth_key']);

        // Download and save profile image
        await _saveProfileImage(result['image']);

        // Navigate to home page
        Get.offAll(() => HomeScreen());
      } else {
        Get.snackbar("Login Failed", "Invalid email or password");
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong. Please try again.");
    } finally {
      isLoading(false);
    }
  }

  Future<void> _saveProfileImage(String imageUrl) async {
    if (imageUrl.isEmpty) return;

    try {
      var response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode == 200) {
        Directory appDocDir = await getApplicationDocumentsDirectory();
        String localImagePath = '${appDocDir.path}/profile_image.jpg';

        File imageFile = File(localImagePath);
        await imageFile.writeAsBytes(response.bodyBytes);

        storage.write("image", localImagePath);
      }
    } catch (e) {
      print("Error downloading image: $e");
    }
  }
}
