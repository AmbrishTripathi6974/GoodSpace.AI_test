import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_manager/photo_manager.dart';

import 'create_post_event.dart';
import 'create_post_state.dart';

class CreatePostBloc extends Bloc<CreatePostEvent, CreatePostState> {
  int currentPage = 0;
  int? lastPage;

  CreatePostBloc() : super(CreatePostInitial()) {
    on<FetchMediaEvent>(_onFetchMedia);
    on<RetryFetchMediaEvent>(_onRetryFetchMedia);
    on<SelectMediaEvent>(_onSelectMedia);
  }

  Future<void> _onFetchMedia(
    FetchMediaEvent event,
    Emitter<CreatePostState> emit,
  ) async {
    emit(CreatePostLoading());
    await _fetchNewMedia(emit);
  }

  Future<void> _onRetryFetchMedia(
    RetryFetchMediaEvent event,
    Emitter<CreatePostState> emit,
  ) async {
    currentPage = 0;
    emit(CreatePostLoading());
    await _fetchNewMedia(emit);
  }

  void _onSelectMedia(
    SelectMediaEvent event,
    Emitter<CreatePostState> emit,
  ) {
    if (state is CreatePostLoaded) {
      final currentState = state as CreatePostLoaded;
      emit(currentState.copyWith(
        currentIndex: event.index,
      ));
    }
  }

  Future<void> _fetchNewMedia(Emitter<CreatePostState> emit) async {
    try {
      lastPage = currentPage;

      final PermissionState ps = await PhotoManager.requestPermissionExtend();

      if (ps.isAuth || ps.hasAccess) {
        final albums = await PhotoManager.getAssetPathList(
          type: RequestType.image,
          hasAll: true,
        );

        if (albums.isEmpty) {
          emit(CreatePostEmpty());
          return;
        }

        final album = albums.first;
        final assetCount = await album.assetCountAsync;

        if (assetCount == 0) {
          emit(CreatePostEmpty());
          return;
        }

        final List<AssetEntity> assets = await album.getAssetListPaged(
          page: currentPage,
          size: 60,
        );

        // Build thumbnail widgets
        final List<Widget> mediaWidgets = assets.map((asset) {
          return FutureBuilder(
            future: asset.thumbnailDataWithSize(const ThumbnailSize(200, 200)),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.hasData) {
                return Container(
                  padding: const EdgeInsets.all(2),
                  child: Image.memory(
                    snapshot.data!,
                    fit: BoxFit.cover,
                  ),
                );
              }
              return Container(
                color: Colors.grey[300],
                child: const Center(
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              );
            },
          );
        }).toList();

        emit(CreatePostLoaded(
          mediaList: mediaWidgets,
          assetList: assets,
          currentIndex: 0,
        ));

        currentPage++;
      } else {
        emit(CreatePostPermissionDenied());
      }
    } catch (e) {
      emit(CreatePostError('Failed to load media: $e'));
    }
  }
}
