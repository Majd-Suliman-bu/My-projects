class PhotoModel {
  int photoId;
  String picture;

  PhotoModel({
    required this.photoId,
    required this.picture,
  });

  factory PhotoModel.fromMap(Map<String, dynamic> map) {
    return PhotoModel(
      photoId: map['photo_id'] ?? 0,
      picture: map['picture'] ?? '',
    );
  }
}
