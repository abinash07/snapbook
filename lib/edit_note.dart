import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:snapbook/controller/editnote_controller.dart';

import 'package:snapbook/utils/constants/sizes.dart';

class EditNoteScreen extends StatelessWidget {
  final EditNoteController controller = Get.put(EditNoteController());

  EditNoteScreen({super.key}) {
    final String reminderId = Get.arguments;
    controller.loadReminder(reminderId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Reminder')),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return Form(
          key: controller.formKey,
          child: Padding(
            padding: const EdgeInsets.all(TSizes.defaultSpace),
            child: ListView(
              children: [
                TextFormField(
                  controller: controller.nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                  validator: (val) => val!.isEmpty ? 'Enter name' : null,
                ),
                const SizedBox(height: TSizes.spaceBtwInputFields),
                TextFormField(
                  controller: controller.emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                  validator: (val) => val!.isEmpty ? 'Enter email' : null,
                ),
                const SizedBox(height: TSizes.spaceBtwInputFields),
                TextFormField(
                  controller: controller.phoneController,
                  decoration: const InputDecoration(labelText: 'Phone'),
                  keyboardType: TextInputType.phone,
                  validator: (val) => val!.isEmpty ? 'Enter phone' : null,
                ),
                const SizedBox(height: TSizes.spaceBtwInputFields),
                TextFormField(
                  controller: controller.freeTimeController,
                  decoration: const InputDecoration(labelText: 'Free Time'),
                ),
                const SizedBox(height: TSizes.spaceBtwInputFields),
                Obx(
                  () => ListTile(
                    title: Text(
                      'Current Call Time: ${DateFormat('MMM dd, yyyy - hh:mm a').format(controller.callTime.value)}',
                    ),
                    trailing: const Icon(Icons.edit_calendar),
                    onTap: () async {
                      final picked = await showDateTimePicker(context);
                      if (picked != null) controller.setCallTime(picked);
                    },
                  ),
                ),
                const SizedBox(height: TSizes.spaceBtwSections),
                ElevatedButton(
                  onPressed: controller.updateReminder,
                  child: const Text('Update Reminder'),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Future<DateTime?> showDateTimePicker(BuildContext context) async {
    final DateTime currentDate = controller.callTime.value;

    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (date != null) {
      final TimeOfDay? time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(currentDate),
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
