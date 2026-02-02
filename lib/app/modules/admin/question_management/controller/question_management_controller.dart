import 'package:blooket/app/data/model/assignment_model.dart';
import 'package:blooket/app/data/model/class_model.dart';
import 'package:blooket/app/data/model/request/set_request.dart';
import 'package:blooket/app/data/model/set_model.dart';
import 'package:blooket/app/data/service/set_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:blooket/app/core/base/base_controller.dart';

class QuestionManagementController extends BaseController {
  final SetService _setService;

  QuestionManagementController(this._setService);

  final questionSets = <SetModel>[].obs;

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
      final response = await _setService.listSets();
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

    final response = await _setService.deleteSet(id);
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

  Future<bool> createQuestionSet(String name) async {
    showLoading();

    final request = SetRequest(name: name.trim());
    final response = await _setService.createSet(request);
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
