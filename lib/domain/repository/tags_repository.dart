import 'package:estesis_tech/domain/model/tag/tag.dart';

abstract class TagsRepository {
  Future<List<Tag>> getTags();
}
