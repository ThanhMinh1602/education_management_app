import 'package:blooket/app/modules/admin/assignment/bindings/assignment_binding.dart';
import 'package:blooket/app/modules/admin/assignment/views/assignment_view.dart';
import 'package:blooket/app/modules/admin/assignment_results/binding/assignment_results_binding.dart';
import 'package:blooket/app/modules/admin/assignment_results/views/assignment_results_view.dart';
import 'package:blooket/app/modules/admin/question_management/binding/level_binding.dart';
import 'package:blooket/app/modules/admin/question_management/views/level_view.dart';
import 'package:blooket/app/modules/user/assignments/binding/assignments_binding.dart';
import 'package:blooket/app/modules/user/assignments/views/assignments_view.dart';
import 'package:blooket/app/modules/user/do_assignment/binding/do_assignment_binding.dart';
import 'package:blooket/app/modules/user/do_assignment/views/do_assignment_view.dart';
import 'package:blooket/app/modules/user/user_dashboard/binding/user_dashboard_binding.dart';
import 'package:blooket/app/modules/user/user_dashboard/views/user_dashboard_view.dart';
import 'package:blooket/app/modules/user/exercises/binding/exercises_binding.dart';
import 'package:blooket/app/modules/user/exercises/views/exercises_view.dart';
import 'package:blooket/app/modules/user/exercises_detail/binding/exercises_detail_binding.dart';
import 'package:blooket/app/modules/user/exercises_detail/views/exercises_detail_view.dart';
import 'package:blooket/app/routes/app_routes.dart';
import 'package:blooket/app/modules/admin/class_management/binding/class_management_binding.dart';
import 'package:blooket/app/modules/admin/class_management/binding/class_management_detail_binding.dart';
import 'package:blooket/app/modules/admin/class_management/views/class_management_view.dart';
import 'package:blooket/app/modules/admin/class_management/views/class_management_detail_view.dart';
import 'package:blooket/app/modules/admin/question_management/binding/question_management_binding.dart';
import 'package:blooket/app/modules/admin/question_management/binding/question_management_detail_binding.dart';
import 'package:blooket/app/modules/admin/question_management/views/question_management_detail_view.dart';
import 'package:blooket/app/modules/admin/question_management/views/question_management_view.dart';
import 'package:blooket/app/modules/admin/student_management/binding/student_management_binding.dart';
import 'package:blooket/app/modules/admin/student_management/views/student_management_view.dart';
import 'package:get/get.dart';

import '../modules/auth/binding/auth_binding.dart';
import '../modules/auth/view/login_view.dart';

class AppPages {
  static const INITIAL = AppRoutes.LOGIN;

  static final routes = [
    GetPage(
      name: AppRoutes.LOGIN,
      page: () => const LoginView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.USER_DASHBOARD,
      page: () => const UserDashboardView(),
      binding: UserDashboardBinding(),
    ),
    GetPage(
      name: AppRoutes.STUDENT_MANAGEMENT,
      page: () => const StudentManagementView(),
      binding: StudentManagementBinding(),
    ),
    GetPage(
      name: AppRoutes.CLASS_MANAGEMENT,
      page: () => const ClassManagementView(),
      binding: ClassManagementBinding(),
      children: [
        GetPage(
          name: AppRoutes.CLASS_MANAGEMENT_DETAIL,
          page: () => const ClassManagementDetailView(),
          transition: Transition.rightToLeft,
          binding: ClassManagementDetailBinding(),
        ),
      ],
    ),
    GetPage(
      name: AppRoutes.LEVEL,
      page: () => const LevelView(),
      binding: LevelBinding(),
      children: [
        GetPage(
          name: AppRoutes.QUESTION_PACKS,
          page: () => const QuestionManagementDetailView(),
          transition: Transition.rightToLeft,
          binding: QuestionManagementDetailBinding(),
          children: [
            GetPage(
              name: AppRoutes.QUESTION_MANAGEMENT_DETAIL,
              page: () => const QuestionManagementDetailView(),
              transition: Transition.rightToLeft,
              binding: QuestionManagementDetailBinding(),
            ),
          ],
        ),
      ],
    ),
    GetPage(
      name: AppRoutes.EXERCISES,
      page: () => const ExercisesView(),
      binding: ExercisesBinding(),
      children: [
        GetPage(
          name: AppRoutes.EXERCISES_DETAIL,
          page: () => const ExercisesDetailView(),
          transition: Transition.rightToLeft,
          binding: ExercisesDetailBinding(),
        ),
      ],
    ),
    GetPage(
      name: AppRoutes.ASSIGNMENT,
      page: () => const AssignmentView(),
      binding: AssignmentBinding(),
    ),
    GetPage(
      name: AppRoutes.ASSIGNMENT_RESULTS,
      page: () => const AssignmentResultsView(),
      binding: AssignmentResultsBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.ASSIGNMENTS,
      page: () => const AssignmentsView(),
      binding: AssignmentsBinding(),
    ),
    GetPage(
      name: AppRoutes.DO_ASSIGNMENT,
      page: () => const DoAssignmentView(),
      binding: DoAssignmentBinding(),
      transition: Transition.rightToLeft,
    ),
  ];
}
