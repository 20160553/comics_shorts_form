import 'package:comic_short_forms/features/comics/domain/i_comics_repository.dart';
import 'package:comic_short_forms/features/comics/infrastructure/mock_comics_repository.dart';
import 'package:get_it/get_it.dart';

final locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton<IComicsRepository>(
    () => MockComicsRepositoryImpl()
  );
}