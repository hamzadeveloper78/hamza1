import 'package:flutter/material.dart';
import 'package:student_management_system/screens/add_student_screen.dart';
import 'package:student_management_system/screens/view_students_screen.dart';
import 'package:student_management_system/screens/search_edit_delete_student_screen.dart';
import 'package:student_management_system/services/backup_service.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('نظام إدارة الطلاب'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          children: <Widget>[
            _buildDashboardCard(
              context,
              icon: Icons.person_add,
              title: 'إضافة طالب جديد',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddStudentScreen()),
                );
              },
            ),
            _buildDashboardCard(
              context,
              icon: Icons.search,
              title: 'بحث وتعديل وحذف طالب',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SearchEditDeleteStudentScreen()),
                );
              },
            ),
            _buildDashboardCard(
              context,
              icon: Icons.people,
              title: 'عرض جميع الطلاب + PDF',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ViewStudentsScreen()),
                );
              },
            ),
            _buildDashboardCard(
              context,
              icon: Icons.backup,
              title: 'النسخ الاحتياطي والاستعادة',
              onTap: () async {
                _showBackupRestoreDialog(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardCard(BuildContext context, {required IconData icon, required String title, required VoidCallback onTap}) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.0),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(icon, size: 50.0, color: Theme.of(context).primaryColor),
                const SizedBox(height: 10.0),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showBackupRestoreDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('النسخ الاحتياطي والاستعادة'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.save),
                title: const Text('إنشاء نسخة احتياطية'),
                onTap: () async {
                  Navigator.pop(context);
                  try {
                    String? filePath = await BackupService().backupDatabase();
                    if (filePath != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('تم إنشاء النسخة الاحتياطية بنجاح في: \n\n\$filePath')),
                      );
                      await BackupService().shareBackupFile(filePath);
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('فشل إنشاء النسخة الاحتياطية: \$e')),
                    );
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.restore),
                title: const Text('استعادة نسخة احتياطية'),
                onTap: () async {
                  Navigator.pop(context);
                  try {
                    await BackupService().restoreDatabase();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('تمت استعادة النسخة الاحتياطية بنجاح')),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('فشل استعادة النسخة الاحتياطية: \$e')),
                    );
                  }
                },
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('إلغاء'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
