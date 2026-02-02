// import 'package:blooket/app/data/model/question_model.dart';
// import 'package:blooket/app/data/model/set_model.dart';

// class SetDetailModel extends SetModel {
//   final List<QuestionModel> questions;

//   SetDetailModel({
//     required super.id,
//     super.setName,
//     super.questionCount,
//     super.createdAt,
//     super.updatedAt,
//     required this.questions,
//   });

//   factory SetDetailModel.fromJson(Map<String, dynamic> json) {
//     var list = json['questions'] as List? ?? [];
//     List<QuestionModel> questionsList = list
//         .map((i) => QuestionModel.fromJson(i))
//         .toList();
//     return SetDetailModel(
//       id: json['id']?.toString() ?? '',
//       setName: json['setName'],
//       questionCount: json['questionCount'] is int
//           ? json['questionCount']
//           : int.tryParse(json['questionCount']?.toString() ?? '0'),
//       createdAt: json['createdAt'] != null
//           ? DateTime.tryParse(json['createdAt'])
//           : null,
//       updatedAt: json['updatedAt'] != null
//           ? DateTime.tryParse(json['updatedAt'])
//           : null,
//       questions: questionsList,
//     );
//   }

//   @override
//   Map<String, dynamic> toJson() {
//     final data = super.toJson();
//     data['questions'] = questions.map((v) => v.toJson()).toList();
//     return data;
//   }
// }
