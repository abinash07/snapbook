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

  final howWeMetOptions = [
    'Physical Invitation',
    'Social Media',
    'Reference',
    'Wellness Evaluation',
  ];

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
                  controller: controller.mobileController,
                  decoration: const InputDecoration(labelText: 'Mobile Number'),
                  keyboardType: TextInputType.phone,
                  validator: (val) {
                    if (val!.isEmpty) return 'Enter mobile number';
                    if (!RegExp(r'^[0-9]{10}$').hasMatch(val))
                      return 'Enter valid 10-digit number';
                    return null;
                  },
                ),
                const SizedBox(height: TSizes.spaceBtwInputFields),
                TextFormField(
                  controller: controller.locationController,
                  decoration: const InputDecoration(labelText: 'Location'),
                  validator: (val) => val!.isEmpty ? 'Enter location' : null,
                ),
                const SizedBox(height: TSizes.spaceBtwInputFields),
                Obx(
                  () => ListTile(
                    title: Text(
                      'D.O.B: ${controller.dob.value.year == 1900 ? "Not Set" : '${controller.dob.value.day}-${controller.dob.value.month}-${controller.dob.value.year}'}',
                    ),
                    trailing: const Icon(Icons.calendar_today),
                    onTap: () => controller.pickDob(context),
                  ),
                ),
                const SizedBox(height: TSizes.spaceBtwInputFields),
                TextFormField(
                  controller: controller.remarkController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    labelText: 'Remark',
                    hintText: 'Enter any notes or remarks...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    alignLabelWithHint: true, // aligns label with top-left
                  ),
                  validator: (val) => val!.isEmpty ? 'Enter remark' : null,
                ),
                SizedBox(height: TSizes.spaceBtwInputFields),
                Obx(
                  () => DropdownButtonFormField<String>(
                    value:
                        controller.howWeMet.value.isEmpty
                            ? null
                            : controller.howWeMet.value,
                    items:
                        howWeMetOptions.map((item) {
                          return DropdownMenuItem(
                            value: item,
                            child: Text(item),
                          );
                        }).toList(),
                    onChanged: (val) => controller.howWeMet.value = val ?? '',
                    decoration: const InputDecoration(labelText: 'How we Meet'),
                    validator:
                        (val) =>
                            val == null || val.isEmpty
                                ? 'Select how you met'
                                : null,
                  ),
                ),
                const SizedBox(height: TSizes.spaceBtwInputFields),

                Obx(
                  () => ListTile(
                    title: Text(
                      'Anniversary: ${controller.anniversary.value.year == 1900 ? "Not Set" : '${controller.anniversary.value.day}-${controller.anniversary.value.month}-${controller.anniversary.value.year}'}',
                    ),
                    trailing: const Icon(Icons.calendar_today),
                    onTap: () => controller.pickAnniversary(context),
                  ),
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
