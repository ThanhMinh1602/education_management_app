import 'package:blooket/app/data/enum/media_type.dart';
import 'package:blooket/app/data/enum/question_type.dart';
import 'package:blooket/app/data/model/request/content/question_content_request.dart';

class UpdateQuestionRequest {
  final QuestionType? type;
  final QuestionContentRequest? content;
  final int? point;
  final String? mediaUrl;
  final String? mediaPublicId;
  final MediaType? mediaType;
  final String? explanation;

  UpdateQuestionRequest({
    this.type,
    this.content,
    this.point,
    this.mediaUrl,
    this.mediaPublicId,
    this.mediaType,
    this.explanation,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    if (type != null) data['type'] = type!.toJson();
    if (content != null) data['content'] = content!.toJson();
    if (point != null) data['point'] = point;
    if (mediaUrl != null) data['mediaUrl'] = mediaUrl;
    if (mediaPublicId != null) data['mediaPublicId'] = mediaPublicId;
    if (mediaType != null) data['mediaType'] = mediaType!.toJson();
    if (explanation != null) data['explanation'] = explanation;

    return data;
  }
}
