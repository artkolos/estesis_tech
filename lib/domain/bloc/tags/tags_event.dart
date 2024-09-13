part of 'tags_bloc.dart';

@freezed
class TagsEvent with _$TagsEvent {
  const factory TagsEvent.getTags() = _GetTags;
}
