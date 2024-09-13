part of 'tags_bloc.dart';

@freezed
class TagsState with _$TagsState {
  const factory TagsState.initial() = _Initial;

  const factory TagsState.loading() = _Loading;

  const factory TagsState.success({@Default([]) List<Tag> tags}) = _Success;
}
