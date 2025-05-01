import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snapbook/controller/addnote_controller.dart';
import 'package:snapbook/utils/constants/sizes.dart';

class AddNoteScreen extends StatelessWidget {
  final controller = Get.put(AddNoteController());
  AddNoteScreen({super.key});

  final howWeMetOptions = [
    'Physical Invitation',
    'Social Media',
    'Reference',
    'Wellness Evaluation',
  ];

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
                controller: controller.nameController,
                decoration: InputDecoration(labelText: 'Name'),
                validator: (val) => val!.isEmpty ? 'Enter name' : null,
              ),
              const SizedBox(height: TSizes.spaceBtwInputFields),
              TextFormField(
                controller: controller.mobileController,
                decoration: InputDecoration(labelText: 'Mobile Number'),
                keyboardType: TextInputType.phone,
                validator: (val) {
                  if (val!.isEmpty) return 'Enter mobile number';
                  if (!RegExp(r'^[0-9]{10}$').hasMatch(val))
                    return 'Enter valid 10-digit number';
                  return null;
                },
              ),
              SizedBox(height: TSizes.spaceBtwInputFields),
              TextFormField(
                controller: controller.locationController,
                decoration: InputDecoration(labelText: 'Location'),
                validator: (val) => val!.isEmpty ? 'Enter location' : null,
              ),
              SizedBox(height: TSizes.spaceBtwInputFields),
              Obx(
                () => ListTile(
                  title: Text(
                    'D.O.B: ${controller.dob.value.year == 1900 ? "Not Set" : '${controller.dob.value.day}-${controller.dob.value.month}-${controller.dob.value.year}'}',
                  ),
                  trailing: Icon(Icons.calendar_today),
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
                        return DropdownMenuItem(value: item, child: Text(item));
                      }).toList(),
                  onChanged: (val) => controller.howWeMet.value = val ?? '',
                  decoration: InputDecoration(labelText: 'How we Meet'),
                  validator:
                      (val) =>
                          val == null || val.isEmpty
                              ? 'Select how you met'
                              : null,
                ),
              ),
              SizedBox(height: TSizes.spaceBtwInputFields),
              Obx(
                () => ListTile(
                  title: Text(
                    'Anniversary: ${controller.anniversary.value.year == 1900 ? "Not Set" : '${controller.anniversary.value.day}-${controller.anniversary.value.month}-${controller.anniversary.value.year}'}',
                  ),
                  trailing: Icon(Icons.calendar_today),
                  onTap: () => controller.pickAnniversary(context),
                ),
              ),
              SizedBox(height: TSizes.spaceBtwInputFields),
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
