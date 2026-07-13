import 'package:flutter/material.dart';
import 'package:student_management_system/database/database_helper.dart';
import 'package:student_management_system/models/student.dart';
import 'package:student_management_system/services/pdf_service.dart';

class ViewStudentsScreen extends StatefulWidget {
  const ViewStudentsScreen({super.key});

  @override
  State<ViewStudentsScreen> createState() => _ViewStudentsScreenState();
}

class _ViewStudentsScreenState extends State<ViewStudentsScreen> {
  List<Student> _students = [];
  List<Student> _filteredStudents = [];
  final TextEditingController _searchController = TextEditingController();
  final DatabaseHelper _dbHelper = DatabaseHelper();
  final PdfService _pdfService = PdfService();

  @override
  void initState() {
    super.initState();
    _loadStudents();
  }

  Future<void> _loadStudents() async {
    final students = await _dbHelper.getStudents();
    setState(() {
      _students = students;
      _filteredStudents = students;
    });
  }

  void _filterStudents(String query) {
    setState(() {
      _filteredStudents = _students.where((student) {
        final nameLower = student.name.toLowerCase();
        final idNumberLower = student.idNumber.toLowerCase();
        final searchLower = query.toLowerCase();
        return nameLower.contains(searchLower) || idNumberLower.contains(searchLower);
      }).toList();
    });
  }

  Future<void> _generateAndSharePdf() async {
    try {
      final pdfBytes = await _pdfService.generateStudentReport(_filteredStudents);
      final filePath = await _pdfService.savePdf(pdfBytes, 'Students_Report.pdf');
      await _pdfService.sharePdf(filePath);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم إنشاء ومشاركة ملف PDF بنجاح')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('فشل إنشاء أو مشاركة ملف PDF: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('عرض جميع الطلاب'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            onPressed: _generateAndSharePdf,
            tooltip: 'توليد ومشاركة PDF',
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'البحث بالاسم أو رقم الهوية',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    _filterStudents('');
                  },
                ),
                border: const OutlineInputBorder(),
              ),
              onChanged: _filterStudents,
            ),
          ),
          Expanded(
            child: _filteredStudents.isEmpty
                ? const Center(child: Text('لا يوجد طلاب لعرضهم'))
                : ListView.builder(
                    itemCount: _filteredStudents.length,
                    itemBuilder: (context, index) {
                      final student = _filteredStudents[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('الرقم: ${student.id}', style: const TextStyle(fontWeight: FontWeight.bold)),
                              Text('الاسم: ${student.name}'),
                              Text('رقم الهوية: ${student.idNumber}'),
                              Text('المحافظة: ${student.governorate ?? 'غير محدد'}'),
                              Text('التخصص: ${student.specialization ?? 'غير محدد'}'),
                              Text('المستوى: ${student.level ?? 'غير محدد'}'),
                              Text('الهاتف: ${student.phone ?? 'غير محدد'}'),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
