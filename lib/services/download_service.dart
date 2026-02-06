import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:deepaknote/Db_Helper/Dbhelper.dart';

class DownloadService {
  static Future<String?> downloadNote({
    required String name,
    required String description,
    required String imageUrl,
    required String pdfUrl,
  }) async {
    try {
      Directory directory = await getApplicationDocumentsDirectory();
      
      String imageName = "${name.replaceAll(' ', '_')}_image.jpg";
      String fileName = "${name.replaceAll(' ', '_')}.pdf";

      // Full path for image
      String imagePath = '${directory.path}/$imageName';
      Dio dio = Dio();
      await dio.download(imageUrl, imagePath);

      // Full path for file
      String filePath = '${directory.path}/$fileName';
      await dio.download(pdfUrl, filePath);

      // Store full file paths in database
      await DBHelper.instance.insertFile(name, description, filePath, imagePath);

      return filePath;
    } catch (e) {
      print("Error downloading file: $e");
      return null;
    }
  }
}
