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
      appBar: AppBar(
        title: Text('Add Reminder'),
        backgroundColor: Colors.white,
      ),
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
                  if (val!.isEmpty) {
                    return 'Enter mobile number';
                  }
                  if (!RegExp(r'^[0-9]{10}$').hasMatch(val)) {
                    return 'Enter valid 10-digit number';
                  }
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
                () => TextFormField(
                  readOnly: true,
                  controller: TextEditingController(
                    text:
                        controller.dob.value.year == 1900
                            ? ''
                            : '${controller.dob.value.day}-${controller.dob.value.month}-${controller.dob.value.year}',
                  ),
                  decoration: InputDecoration(
                    labelText: 'Date of Birth',
                    suffixIcon: Icon(Icons.calendar_today),
                    hintText: 'Select date of birth',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onTap: () => controller.pickDob(context),
                  validator:
                      (val) =>
                          controller.dob.value.year == 1900
                              ? 'Select DOB'
                              : null,
                ),
              ),

              const SizedBox(height: TSizes.spaceBtwInputFields),
              TextFormField(
                controller: controller.commentController,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: 'Remark',
                  hintText: 'Enter any notes or remarks...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  alignLabelWithHint: true,
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
                () => TextFormField(
                  readOnly: true,
                  controller: TextEditingController(
                    text:
                        controller.anniversary.value.year == 1900
                            ? ''
                            : '${controller.anniversary.value.day}-${controller.anniversary.value.month}-${controller.anniversary.value.year}',
                  ),
                  decoration: InputDecoration(
                    labelText: 'Anniversary',
                    suffixIcon: Icon(Icons.calendar_today),
                    hintText: 'Select anniversary date',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onTap: () => controller.pickAnniversary(context),
                  validator:
                      (val) =>
                          controller.anniversary.value.year == 1900
                              ? 'Select anniversary'
                              : null,
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
