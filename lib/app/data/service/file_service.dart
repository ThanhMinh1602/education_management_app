import 'dart:typed_data';
import 'package:blooket/app/data/service/base/base_service.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http_parser/http_parser.dart';

class FileService extends BaseService {
  FileService(super.apiClient);

  /// Upload 1 file (ảnh hoặc audio) theo Swagger: POST /upload (form-data, key = "file")
  /// Trả về Map (vd: {url, publicId, ...} tùy BE)
  Future<Map<String, dynamic>> uploadPlatformFile(PlatformFile file) async {
    final formData = FormData();

    if (file.bytes != null) {
      formData.files.add(
        MapEntry(
          'file',
          MultipartFile.fromBytes(
            file.bytes as Uint8List,
            filename: file.name,
            contentType: _guessContentType(file.extension),
          ),
        ),
      );
    } else if (file.path != null) {
      formData.files.add(
        MapEntry(
          'file',
          await MultipartFile.fromFile(
            file.path!,
            filename: file.name,
            contentType: _guessContentType(file.extension),
          ),
        ),
      );
    } else {
      throw 'Không lấy được bytes/path của file';
    }

    // ✅ Override header sang multipart để không bị application/json
    final res = await apiClient.post(
      '/upload',
      data: formData,
      options: Options(
        contentType: 'multipart/form-data',
        headers: {
          // Dio sẽ tự set boundary; để trống cũng ok
          'Content-Type': 'multipart/form-data',
        },
      ),
    );

    // tùy backend: có thể res.data là {data: {...}} hoặc trực tiếp {...}
    final data = res.data;
    if (data is Map<String, dynamic>) return data;
    return {'data': data};
  }

  /// Upload từ bytes (ảnh đang có sẵn trong memory)
  Future<Map<String, dynamic>> uploadBytes({
    required Uint8List bytes,
    required String filename,
    String? extension,
  }) async {
    final formData = FormData.fromMap({
      'file': MultipartFile.fromBytes(
        bytes,
        filename: filename,
        contentType: _guessContentType(extension),
      ),
    });

    final res = await apiClient.post(
      '/upload',
      data: formData,
      options: Options(contentType: 'multipart/form-data'),
    );

    final data = res.data;
    if (data is Map<String, dynamic>) return data;
    return {'data': data};
  }

  MediaType? _guessContentType(String? ext) {
    final e = (ext ?? '').toLowerCase();
    if (e == 'png') return MediaType('image', 'png');
    if (e == 'jpg' || e == 'jpeg') return MediaType('image', 'jpeg');
    if (e == 'webp') return MediaType('image', 'webp');

    if (e == 'mp3') return MediaType('audio', 'mpeg');
    if (e == 'wav') return MediaType('audio', 'wav');
    if (e == 'm4a') return MediaType('audio', 'mp4');

    return null;
  }
}
