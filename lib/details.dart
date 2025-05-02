import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:snapbook/controller/reminder_controller.dart';
import 'package:snapbook/models/reminder.dart';

class DetailsScreen extends StatelessWidget {
  final ReminderController controller = Get.find<ReminderController>();
  DetailsScreen({super.key});

  String formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} – ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  String formatDate(DateTime date) {
    return DateFormat('MMM dd, yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final String id = Get.arguments;

    return FutureBuilder<Reminder?>(
      future: controller.getReminderById(id),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(title: Text('Reminder Details')),
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (!snapshot.hasData || snapshot.data == null) {
          return Scaffold(
            appBar: AppBar(title: Text('Reminder Details')),
            body: Center(child: Text('Reminder not found.')),
          );
        }

        final reminder = snapshot.data!;
        return Scaffold(
          appBar: AppBar(
            title: Text('Reminder Details'),
            backgroundColor: Colors.white,
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 24.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildField('👤 Name', reminder.name),
                  _buildField('📱 Mobile', reminder.mobile),
                  _buildField('📍 Location', reminder.location),
                  _buildField(
                    '📅 Call Time',
                    formatDateTime(reminder.callTime),
                  ),
                  _buildField('🎂 DOB', formatDate(reminder.dob)),
                  _buildField('📝 Remark', reminder.comment),
                  _buildField(
                    '💍 Anniversary',
                    formatDate(reminder.anniversary),
                  ),
                  _buildField('🤝 How We Met', reminder.howWeMet),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 6),
          Text(value, style: TextStyle(fontSize: 18, color: Colors.black)),
          Divider(thickness: 0.6, color: Colors.grey[300]),
        ],
      ),
    );
  }
}
