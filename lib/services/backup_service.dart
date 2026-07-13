import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:file_picker/file_picker.dart';
import 'package:share_plus/share_plus.dart';

class BackupService {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<String> get _dbPath async {
    return join(await getDatabasesPath(), 'Students.db');
  }

  Future<String> backupDatabase() async {
    try {
      final dbPath = await _dbPath;
      final localPath = await _localPath;
      final backupDir = Directory(join(localPath, 'backups'));
      if (!await backupDir.exists()) {
        await backupDir.create(recursive: true);
      }
      final backupFileName = 'Students_backup_${DateTime.now().millisecondsSinceEpoch}.db';
      final backupFilePath = join(backupDir.path, backupFileName);
      final dbFile = File(dbPath);

      if (await dbFile.exists()) {
        await dbFile.copy(backupFilePath);
        return backupFilePath;
      } else {
        throw Exception('Database file not found.');
      }
    } catch (e) {
      print('Error backing up database: $e');
      rethrow;
    }
  }

  Future<void> restoreDatabase() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['db'],
      );

      if (result != null && result.files.single.path != null) {
        final backupFilePath = result.files.single.path!;
        final dbPath = await _dbPath;
        final backupFile = File(backupFilePath);

        if (await backupFile.exists()) {
          // Close existing database connection before restoring
          final database = await openDatabase(dbPath);
          await database.close();

          await backupFile.copy(dbPath);
          print('Database restored successfully from: $backupFilePath');
        } else {
          throw Exception('Backup file not found.');
        }
      } else {
        print('No backup file selected.');
      }
    } catch (e) {
      print('Error restoring database: $e');
      rethrow;
    }
  }

  Future<void> shareBackupFile(String filePath) async {
    await Share.shareXFiles([XFile(filePath)], text: 'ملف النسخ الاحتياطي لقاعدة بيانات الطلاب');
  }
}
