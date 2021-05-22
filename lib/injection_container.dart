import 'package:estimationer/core/platform/database.dart';
import 'package:estimationer/features/task/data/data_source/local_data_source.dart';
import 'package:estimationer/features/task/data/repository/tasks_repository.dart';
import 'package:estimationer/features/task/domain/repository/tasks_repository.dart';
import 'package:estimationer/features/task/domain/use_cases/calculate_estimate.dart';
import 'package:estimationer/features/task/domain/use_cases/get_tasks.dart';
import 'package:estimationer/features/task/domain/use_cases/remove_task.dart';
import 'package:estimationer/features/task/domain/use_cases/set_task.dart';
import 'package:estimationer/features/task/presentation/bloc/tasks_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:sqflite/sqflite.dart';

import 'features/task/domain/use_cases/calculate_uncertainty.dart';

final sl = GetIt.instance;

Future init()async{

  // ************** Features *********************
  //Tasks
  sl.registerLazySingleton<TasksLocalDataSource>(() => TasksLocalDataSourceImpl(dbManager: sl()));

  sl.registerLazySingleton<TasksRepository>(()=>TasksRepositoryImpl(localDataSource: sl()));

  sl.registerLazySingleton(()=>GetTasks(repository: sl()));
  sl.registerLazySingleton(()=>SetTask(repository: sl()));
  sl.registerLazySingleton(()=>RemoveTask(repository: sl()));
  sl.registerLazySingleton(()=>CalculateEstimate());
  sl.registerLazySingleton(() => CalculateUncertainty());

  sl.registerLazySingleton(()=>TasksBloc(
    getTasks: sl(), 
    setTask: sl(), 
    removeTask: sl(), 
    calculateEstimate: sl(), 
    calculateUncertainty: sl()
  ));
  

  // *********************** Core ************************
  sl.registerLazySingleton<DataBaseManager>(() => DataBaseManagerImpl(db: sl()));

  Database db = await CustomDataBaseFactory.dataBase;
  sl.registerLazySingleton<Database>(() => db);
}