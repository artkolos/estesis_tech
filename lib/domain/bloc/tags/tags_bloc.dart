import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:estesis_tech/domain/model/tag/tag.dart';
import 'package:estesis_tech/domain/repository/tags_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'tags_event.dart';

part 'tags_state.dart';

part 'tags_bloc.freezed.dart';

@injectable
class TagsBloc extends Bloc<TagsEvent, TagsState> {
  TagsBloc(this.tagsRepository) : super(const TagsState.initial()) {
    on(_onNap);
  }

  final TagsRepository tagsRepository;

  FutureOr<void> _onNap(TagsEvent mainEvent, Emitter<TagsState> emit) =>
      mainEvent.map(
        getTags: (event) => _getTags(event, emit),
      );

  Future<void> _getTags(_GetTags event, Emitter<TagsState> emit) async {
    emit(const TagsState.loading());
    final tags = await tagsRepository.getTags();
    emit(TagsState.success(tags: tags));
  }
}
