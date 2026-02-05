import 'package:blooket/app/data/enum/media_type.dart';
import 'package:blooket/app/data/enum/question_type.dart';
import 'package:blooket/app/data/model/request/content/question_content_request.dart';

class CreateQuestionRequest {
  final String packId;
  final QuestionType type;
  final int point;
  final String? explanation;
  final String? mediaUrl;
  final String? mediaPublicId;
  final MediaType mediaType;
  final QuestionContentRequest content;

  CreateQuestionRequest({
    required this.packId,
    required this.type,
    this.point = 1,
    this.explanation,
    this.mediaUrl,
    this.mediaPublicId,
    this.mediaType = MediaType.none,
    required this.content,
  });

  Map<String, dynamic> toJson() {
    return {
      'packId': packId,
      'type': type.toJson(),
      'point': point,
      'explanation': explanation ?? '',
      'mediaUrl': mediaUrl ?? '',
      'mediaPublicId': mediaPublicId ?? '',
      'mediaType': mediaType.toJson(),
      'content': content.toJson(),
    };
  }
}
