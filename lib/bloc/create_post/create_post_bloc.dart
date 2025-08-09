import 'dart:io';
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
      emit(currentState.copyWith(currentIndex: event.index));
    }
  }

  Future<void> _fetchNewMedia(Emitter<CreatePostState> emit) async {
    try {
      lastPage = currentPage;
      
      // Request permission with more detailed handling
      final PermissionState ps = await PhotoManager.requestPermissionExtend();
      print('Permission state: ${ps.name}');
      
      if (ps.isAuth || ps.hasAccess) {
        // Get asset path list with more options
        List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(
          type: RequestType.image, // Only get images
          hasAll: true,
          onlyAll: false, // Changed to false to get more albums
        );
        
        print('Found ${albums.length} albums');
        
        if (albums.isEmpty) {
          print('No albums found');
          emit(CreatePostEmpty());
          return;
        }
        
        // Use the first album (usually "Recent" or "All Photos")
        AssetPathEntity album = albums.first;
        print('Using album: ${album.name}');
        
        // Get asset count first
        int assetCount = await album.assetCountAsync;
        print('Asset count in album: $assetCount');
        
        if (assetCount == 0) {
          print('No assets in album');
          emit(CreatePostEmpty());
          return;
        }
        
        List<AssetEntity> media = await album.getAssetListPaged(
          page: currentPage,
          size: 60,
        );
        
        print('Fetched ${media.length} media items');

        // Process files
        final List<File> filePaths = [];
        for (var asset in media) {
          if (asset.type == AssetType.image) {
            final file = await asset.file;
            if (file != null) {
              filePaths.add(File(file.path));
            }
          }
        }

        List<Widget> mediaWidgets = [];
        for (var asset in media) {
          if (asset.type == AssetType.image) { // Only add images
            mediaWidgets.add(
              FutureBuilder(
                future: asset.thumbnailDataWithSize(const ThumbnailSize(200, 200)),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasData && snapshot.data != null) {
                      return Container(
                        padding: const EdgeInsets.all(2),
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: Image.memory(
                                snapshot.data!,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                  }
                  return Container(
                    color: Colors.grey[300],
                    child: const Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    ),
                  );
                },
              ),
            );
          }
        }
        
        print('Created ${mediaWidgets.length} widgets');
        
        final selectedFile = filePaths.isNotEmpty ? filePaths[0] : null;
        
        emit(CreatePostLoaded(
          mediaList: mediaWidgets,
          filePaths: filePaths,
          selectedFile: selectedFile,
          currentIndex: 0,
        ));
        
        currentPage++;
        
      } else {
        print('Permission denied: ${ps.name}');
        emit(CreatePostPermissionDenied());
      }
    } catch (e) {
      print('Error fetching media: $e');
      emit(CreatePostError('Failed to load media: ${e.toString()}'));
    }
  }
}