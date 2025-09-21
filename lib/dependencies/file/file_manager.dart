import 'package:file_picker/file_picker.dart';

abstract class FileManager {
  Future<PlatformFile?> pickFile({
    FileType type = FileType.any,
    List<String>? allowedExtensions,
    bool allowMultiple = true,
  });
}
