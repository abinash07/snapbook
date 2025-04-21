import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snapbook/controller/editnote_controller.dart';

class EditNoteScreen extends StatelessWidget {
  EditNoteScreen({super.key});

  final EditNoteController controller = Get.put(EditNoteController());
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Reminder'),
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                controller.submitForm();
                Get.back();
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextField("Name", controller.name),
              _buildTextField(
                "Email",
                controller.email,
                inputType: TextInputType.emailAddress,
              ),
              _buildTextField(
                "Phone",
                controller.phone,
                inputType: TextInputType.phone,
              ),
              _buildTextField("Free Time", controller.freeTime),
              SizedBox(height: 16),
              Text(
                'Call Time',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              SizedBox(height: 8),
              Obx(
                () => InkWell(
                  onTap: () => _pickDateTime(context),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade400),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${controller.callTime.value.day}/${controller.callTime.value.month}/${controller.callTime.value.year} – ${controller.callTime.value.hour}:${controller.callTime.value.minute.toString().padLeft(2, '0')}',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    TextInputType inputType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: inputType,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        validator:
            (value) => value == null || value.isEmpty ? 'Enter $label' : null,
      ),
    );
  }

  Future<void> _pickDateTime(BuildContext context) async {
    final controller = Get.find<EditNoteController>();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: controller.callTime.value,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      final pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(controller.callTime.value),
      );

      if (pickedTime != null) {
        controller.updateCallTime(
          DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          ),
        );
      }
    }
  }
}
