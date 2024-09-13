import 'package:estesis_tech/data/source/remote/rest_source.dart';
import 'package:estesis_tech/domain/model/tag/tag.dart';
import 'package:estesis_tech/domain/repository/tags_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: TagsRepository)
class TagsRepositoryImpl implements TagsRepository {
  final RestSource restSource;

  TagsRepositoryImpl(this.restSource);

  @override
  Future<List<Tag>> getTags() async {
    return await restSource.getTags();
  }
}
