import 'package:file_picker/file_picker.dart';

abstract class FileManager {
  Future<List<PlatformFile>?> pickFiles({
    FileType type = FileType.any,
    List<String>? allowedExtensions,
    bool allowMultiple = true,
  });
}
