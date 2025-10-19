import 'dart:io';
import 'package:path_provider/path_provider.dart';

class StorageService {
  /// menyimpan file PDF ke folder dokumen aplikasi
  static Future<File?> savePdfFile(String fileName, List<int> bytes) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$fileName');
      await file.writeAsBytes(bytes, flush: true);
      print('File PDF berhasil disimpan di: ${file.path}');
      return file;
    } catch (e) {
      print('Gagal menyimpan file PDF: $e');
      return null;
    }
  }

  /// mengecek file PDF tertentu sudah ada
  static Future<bool> fileExists(String fileName) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/$fileName');
    return await file.exists();
  }

  /// Hapus file PDF 
  static Future<void> deletePdfFile(String fileName) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$fileName');
      if (await file.exists()) {
        await file.delete();
        print('File $fileName berhasil dihapus.');
      }
    } catch (e) {
      print('Gagal menghapus file PDF: $e');
    }
  }
}