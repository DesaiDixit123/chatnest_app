class ParticipantInfo {
  final int uid;
  final String? userId;
  final String? userName;
  final String? userImage;
  bool isAudioEnabled;

  ParticipantInfo({
    required this.uid,
    this.userId,
    this.userName,
    this.userImage,
    this.isAudioEnabled = true,
  });
}
