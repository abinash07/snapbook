import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class HomeController extends GetxController {
  final storage = GetStorage();
  var reminders = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadReminders();
  }

  void loadReminders() {
    final stored = storage.read('reminders') ?? [];
    reminders.value = List<Map<String, dynamic>>.from(stored);
  }
}
