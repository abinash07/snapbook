import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snapbook/controller/addnote_controller.dart';
import 'package:snapbook/utils/constants/sizes.dart';

class AddNoteScreen extends StatelessWidget {
  final controller = Get.put(AddNoteController());
  AddNoteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Reminder')),
      body: Form(
        key: controller.formKey,
        child: Padding(
          padding: EdgeInsets.all(16),
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Name'),
                onSaved: (val) => controller.name.value = val ?? '',
                validator: (val) => val!.isEmpty ? 'Enter name' : null,
              ),
              const SizedBox(height: TSizes.spaceBtwInputFields),
              TextFormField(
                decoration: InputDecoration(labelText: 'Email'),
                onSaved: (val) => controller.email.value = val ?? '',
                validator: (val) => val!.isEmpty ? 'Enter email' : null,
              ),
              const SizedBox(height: TSizes.spaceBtwInputFields),
              TextFormField(
                decoration: InputDecoration(labelText: 'Phone'),
                keyboardType: TextInputType.phone,
                onSaved: (val) => controller.phone.value = val ?? '',
                validator: (val) => val!.isEmpty ? 'Enter phone' : null,
              ),
              const SizedBox(height: TSizes.spaceBtwInputFields),
              TextFormField(
                decoration: InputDecoration(labelText: 'Free Time'),
                onSaved: (val) => controller.freeTime.value = val ?? '',
              ),
              Obx(
                () => ListTile(
                  title: Text('When to Call: ${controller.callTime.value}'),
                  trailing: Icon(Icons.calendar_today),
                  onTap: () async {
                    final picked = await showDateTimePicker(context);
                    if (picked != null) controller.setCallTime(picked);
                  },
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwInputFields),
              ElevatedButton(
                onPressed: controller.saveReminder,
                child: Text('Save Reminder'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<DateTime?> showDateTimePicker(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(Duration(minutes: 10)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );
    if (date != null) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (time != null) {
        return DateTime(
          date.year,
          date.month,
          date.day,
          time.hour,
          time.minute,
        );
      }
    }
    return null;
  }
}
