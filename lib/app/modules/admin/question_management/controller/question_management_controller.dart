import 'package:blooket/app/data/model/assignment_model.dart';
import 'package:blooket/app/data/model/class_model.dart';
import 'package:blooket/app/data/model/question_pack_model.dart';
import 'package:blooket/app/data/model/request/content/question_pack_request.dart';
import 'package:blooket/app/data/service/question_pack_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:blooket/app/core/base/base_controller.dart';

class QuestionManagementController extends BaseController {
  final QuestionPackService _questionPackService;
  QuestionManagementController(this._questionPackService);

  final questionSets = <QuestionPackModel>[].obs;

  final primaryColor = const Color(0xFF909CC2);
  final actionColor = const Color(0xFFEDBBC6);

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  Future<void> fetchData() async {
    showLoading();
    try {
      final response = await _questionPackService.getPacks();
      if (response.success) {
        questionSets.assignAll(response.data ?? []);
      } else {
        showError(response.message);
      }
    } catch (e) {
      showError("Không thể tải dữ liệu");
    } finally {
      hideLoading();
    }
  }

  Future<bool> deleteSet(String id) async {
    showLoading();

    final response = await _questionPackService.deletePack(id);
    hideLoading();

    if (response.success) {
      showSuccess("Đã xóa bộ đề");
      questionSets.removeWhere((element) => element.id == id);
      return true;
    } else {
      showError(response.message);
      return false;
    }
  }

  Future<void> openDetail(String id, String name) async {
    final result = await Get.toNamed('${Get.currentRoute}/$id');
    if (result == true) {
      await Future.delayed(const Duration(milliseconds: 300));
      await fetchData();
    }
  }

  Future<bool> createQuestionSet(QuestionPackRequest request) async {
    showLoading();
    final response = await _questionPackService.createPack(request);
    hideLoading();

    if (response.success) {
      showSuccess("Đã tạo bộ đề mới");
      if (response.data != null) {
        questionSets.insert(0, response.data!);
      }
      return true;
    } else {
      showError(response.message);
      return false;
    }
  }
}
