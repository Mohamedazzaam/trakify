import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';

Future<MultipartFile> uploadImageToAPI(XFile image) async {
  final mimeType = lookupMimeType(image.path) ?? 'application/octet-stream';
  final mediaType = MediaType.parse(mimeType);

  return MultipartFile.fromFile(
    image.path,
    filename: image.path.split('/').last,
    contentType: mediaType,
  );
}
