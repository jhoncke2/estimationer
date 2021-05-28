import 'package:estimationer/features/task_group/presentation/pages/tasks_page.dart';
import 'package:flutter/material.dart';
const TASKS_PAGE_ROUTE = 'tasks';
final Map<String, Widget Function(BuildContext)> navRoutes = {
  TASKS_PAGE_ROUTE : (_)=>TasksPage(),
};
const initialNavRoute = TASKS_PAGE_ROUTE;