import 'package:flutter/material.dart';
import 'package:student_management_system/database/database_helper.dart';
import 'package:student_management_system/models/student.dart';

class SearchEditDeleteStudentScreen extends StatefulWidget {
  const SearchEditDeleteStudentScreen({super.key});

  @override
  State<SearchEditDeleteStudentScreen> createState() => _SearchEditDeleteStudentScreenState();
}

class _SearchEditDeleteStudentScreenState extends State<SearchEditDeleteStudentScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Student> _searchResults = [];
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Student? _selectedStudent;
  final _editFormKey = GlobalKey<FormState>();
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

  @override
  void dispose() {
    _searchController.dispose();
    _nameController.dispose();
    _idTypeController.dispose();
    _idNumberController.dispose();
    _governorateController.dispose();
    _districtController.dispose();
    _villageController.dispose();
    _isolationController.dispose();
    _specializationController.dispose();
    _levelController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _searchStudents(String query) async {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
      });
      return;
    }
    final results = await _dbHelper.searchStudents(query);
    setState(() {
      _searchResults = results;
    });
  }

  void _editStudent(Student student) {
    setState(() {
      _selectedStudent = student;
      _nameController.text = student.name;
      _idTypeController.text = student.idType;
      _idNumberController.text = student.idNumber;
      _governorateController.text = student.governorate ?? "";
      _districtController.text = student.district ?? "";
      _villageController.text = student.village ?? "";
      _isolationController.text = student.isolation ?? "";
      _specializationController.text = student.specialization ?? "";
      _levelController.text = student.level ?? "";
      _phoneController.text = student.phone ?? "";
    });
    _showEditDialog(student);
  }

  void _showEditDialog(Student student) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("تعديل بيانات الطالب"),
          content: SingleChildScrollView(
            child: Form(
              key: _editFormKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
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
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text("إلغاء"),
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  _selectedStudent = null;
                });
              },
            ),
            ElevatedButton(
              child: const Text("حفظ التعديلات"),
              onPressed: () async {
                if (_editFormKey.currentState!.validate()) {
                  final updatedStudent = Student(
                    id: student.id,
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
                  await _dbHelper.updateStudent(updatedStudent);
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('تم تعديل بيانات الطالب بنجاح')),
                  );
                  _searchStudents(_searchController.text); // Refresh search results
                  setState(() {
                    _selectedStudent = null;
                  });
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _deleteStudent(int id) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("تأكيد الحذف"),
          content: const Text("هل أنت متأكد أنك تريد حذف هذا الطالب؟"),
          actions: <Widget>[
            TextButton(
              child: const Text("إلغاء"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: const Text("حذف"),
              onPressed: () async {
                await _dbHelper.deleteStudent(id);
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('تم حذف الطالب بنجاح')),
                );
                _searchStudents(_searchController.text); // Refresh search results
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("بحث وتعديل وحذف طالب"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: "البحث بالاسم أو رقم الهوية",
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () => _searchStudents(_searchController.text),
                ),
              ),
              onChanged: _searchStudents,
            ),
            const SizedBox(height: 20),
            Expanded(
              child: _searchResults.isEmpty
                  ? const Center(child: Text("لا توجد نتائج بحث"))
                  : ListView.builder(
                      itemCount: _searchResults.length,
                      itemBuilder: (context, index) {
                        final student = _searchResults[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          child: ListTile(
                            title: Text(student.name),
                            subtitle: Text(
                                'رقم الهوية: \${student.idNumber} | التخصص: \${student.specialization ?? 'غير محدد'}'),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit, color: Colors.blue),
                                  onPressed: () => _editStudent(student),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => _deleteStudent(student.id!),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
