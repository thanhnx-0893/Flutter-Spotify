class Artist {
  final String id;
  final String name;
  final String imageURL;
  final int followerCount;
  final List<dynamic> genres;

  Artist(this.id, this.name, this.imageURL, this.followerCount, this.genres);

  factory Artist.fromJson(Map<String, dynamic> json) {
    return Artist(
      json['id'],
      json['name'],
      json['images'][0]['url'],
      json['followers']['total'],
      json['genres'],
    );
  }
}