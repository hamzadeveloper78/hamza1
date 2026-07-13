import 'package:flutter/material.dart';
import 'package:student_management_system/database/database_helper.dart';
import 'package:student_management_system/models/student.dart';

class AddStudentScreen extends StatefulWidget {
  const AddStudentScreen({super.key});

  @override
  State<AddStudentScreen> createState() => _AddStudentScreenState();
}

class _AddStudentScreenState extends State<AddStudentScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _idTypeController = TextEditingController();
  final TextEditingController _idNumberController = TextEditingController();
  final TextEditingController _governorateController = TextEditingController();
  final TextEditingController _districtController = TextEditingController();
  final TextEditingController _villageController = TextEditingController();
  final TextEditingController _isolationController = TextEditingController();
  final TextEditingController _specializationController = TextEditingController();
  final TextEditingController _levelController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  void _saveStudent() async {
    if (_formKey.currentState!.validate()) {
      final student = Student(
        name: _nameController.text,
        idType: _idTypeController.text,
        idNumber: _idNumberController.text,
        governorate: _governorateController.text.isEmpty ? null : _governorateController.text,
        district: _districtController.text.isEmpty ? null : _districtController.text,
        village: _villageController.text.isEmpty ? null : _villageController.text,
        isolation: _isolationController.text.isEmpty ? null : _isolationController.text,
        specialization: _specializationController.text.isEmpty ? null : _specializationController.text,
        level: _levelController.text.isEmpty ? null : _levelController.text,
        phone: _phoneController.text.isEmpty ? null : _phoneController.text,
      );

      await DatabaseHelper().insertStudent(student);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم حفظ الطالب بنجاح')),
      );
      _clearFields();
    }
  }

  void _clearFields() {
    _nameController.clear();
    _idTypeController.clear();
    _idNumberController.clear();
    _governorateController.clear();
    _districtController.clear();
    _villageController.clear();
    _isolationController.clear();
    _specializationController.clear();
    _levelController.clear();
    _phoneController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إضافة طالب جديد'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'اسم الطالب'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'الرجاء إدخال اسم الطالب';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _idTypeController,
                decoration: const InputDecoration(labelText: 'نوع الهوية'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'الرجاء إدخال نوع الهوية';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _idNumberController,
                decoration: const InputDecoration(labelText: 'رقم الهوية'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'الرجاء إدخال رقم الهوية';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _governorateController,
                decoration: const InputDecoration(labelText: 'المحافظة'),
              ),
              TextFormField(
                controller: _districtController,
                decoration: const InputDecoration(labelText: 'المديرية'),
              ),
              TextFormField(
                controller: _villageController,
                decoration: const InputDecoration(labelText: 'القرية'),
              ),
              TextFormField(
                controller: _isolationController,
                decoration: const InputDecoration(labelText: 'العزلة'),
              ),
              TextFormField(
                controller: _specializationController,
                decoration: const InputDecoration(labelText: 'التخصص'),
              ),
              TextFormField(
                controller: _levelController,
                decoration: const InputDecoration(labelText: 'المستوى'),
              ),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'رقم الهاتف'),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: _saveStudent,
                    child: const Text('حفظ الطالب'),
                  ),
                  ElevatedButton(
                    onPressed: _clearFields,
                    child: const Text('مسح الحقول'),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('رجوع'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
