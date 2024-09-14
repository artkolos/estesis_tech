import 'package:estesis_tech/data/source/locale/hive_source.dart';
import 'package:estesis_tech/data/source/remote/rest_source.dart';
import 'package:estesis_tech/domain/model/tag/tag.dart';
import 'package:estesis_tech/domain/repository/tags_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

@LazySingleton(as: TagsRepository)
class TagsRepositoryImpl implements TagsRepository {
  final RestSource restSource;
  final HiveSource hiveSource;

  TagsRepositoryImpl(
    this.restSource,
    this.hiveSource,
  );

  @override
  Future<List<Tag>> getTags() async {
    final bool isConnect =
        await InternetConnectionChecker.createInstance().hasConnection;
    if (isConnect) {
      return await restSource.getTags();
    } else {
      return hiveSource.getTags();
    }
  }
}
