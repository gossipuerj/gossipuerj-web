import "dart:typed_data";

import "package:file_picker/file_picker.dart";
import "package:image/image.dart" as img;

Future<Uint8List?> pickCompressedAvatar() async {
  final result = await FilePicker.platform.pickFiles(
    type: FileType.image,
    withData: true,
  );
  if (result == null || result.files.single.bytes == null) {
    return null;
  }

  final bytes = result.files.single.bytes!;
  if (bytes.length > 2 * 1024 * 1024) {
    throw const AvatarTooLargeException();
  }

  final decoded = img.decodeImage(bytes);
  if (decoded == null) {
    return null;
  }

  final resized = img.copyResize(
    decoded,
    width: 400,
    height: 400,
    maintainAspect: true,
  );
  return Uint8List.fromList(img.encodeJpg(resized, quality: 70));
}

class AvatarTooLargeException implements Exception {
  const AvatarTooLargeException();
}
