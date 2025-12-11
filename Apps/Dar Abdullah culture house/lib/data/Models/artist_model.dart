class ArtistModel {
  int artistId;
  String artistName;
  String description;

  ArtistModel({
    required this.artistId,
    required this.artistName,
    required this.description,
  });

  factory ArtistModel.fromMap(Map<String, dynamic> map) {
    return ArtistModel(
      artistId: map['artist_id'] ?? 0,
      artistName: map['artist_name'] ?? '',
      description: map['description'] ?? '',
    );
  }
}
