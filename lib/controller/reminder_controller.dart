// controller/reminder_controller.dart
import 'package:get/get.dart';
import 'package:snapbook/helper/notification_helper.dart';
import '../database/database_helper.dart';
import '../models/reminder.dart';

class ReminderController extends GetxController {
  final _dbHelper = DatabaseHelper.instance;
  var reminders = <Reminder>[].obs;
  var isLoading = true.obs;
  final searchQuery = ''.obs;
  final showSearch = false.obs;

  @override
  void onInit() {
    fetchReminders();
    super.onInit();
  }

  Future<void> fetchReminders() async {
    try {
      isLoading(true);
      final result = await _dbHelper.getAllReminders();
      reminders.assignAll(result);
    } finally {
      isLoading(false);
    }
  }

  Future<void> deleteReminder(String id) async {
    try {
      // Cancel notification before deleting
      await NotificationHelper.cancelScheduledNotification(id.hashCode);
      await _dbHelper.deleteReminder(id);
      await fetchReminders();
      Get.snackbar('Success', 'Reminder deleted successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete reminder: $e');
    }
  }

  List<Reminder> get filteredReminders {
    if (searchQuery.isEmpty) return reminders;
    return reminders.where((reminder) {
      return reminder.name.toLowerCase().contains(
        searchQuery.value.toLowerCase(),
      );
    }).toList();
  }

  void toggleSearch() => showSearch.toggle();

  Future<Reminder> getReminderById(String id) {
    return _dbHelper.getReminderById(id);
  }
}
