class Track {
  final String id;
  final String name;
  final int duration;
  final String albumImageURL;

  Track(this.id, this.name, this.duration, this.albumImageURL);

  factory Track.fromJson(Map<String, dynamic> json) {
    return Track(
      json['id'],
      json['name'],
      json['duration_ms'],
      json['album']['images'][0]['url'],
    );
  }
}