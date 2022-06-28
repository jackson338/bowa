part of 'writing.dart';

class WritingState {
  final String title;
  final List<String> titleList;
  final List<String> idList;
  final List<Image>? coverArtList;
  final List<String> imagePaths;
  final bool imageSelected;
  final bool titlesUpdated;

  const WritingState({
    this.idList = const [],
    this.title = 'Writing State',
    this.titleList = const [],
    this.coverArtList = const [],
    this.imageSelected = false,
    this.titlesUpdated = false,
    this.imagePaths = const [],
  });

  WritingState copyWith({
    final String? title,
    final List<String>? idList,
    final List<String>? titleList,
    final List<Image>? coverArtList,
    final bool? imageSelected,
    final List<String>? imagePaths,
    final bool? titlesUpdated,
  }) {
    return WritingState(
      idList: idList ?? this.idList,
      title: title ?? this.title,
      titleList: titleList ?? this.titleList,
      coverArtList: coverArtList ?? this.coverArtList,
      imageSelected: imageSelected ?? this.imageSelected,
      imagePaths: imagePaths ?? this.imagePaths,
      titlesUpdated: titlesUpdated ?? this.titlesUpdated,
    );
  }
}
