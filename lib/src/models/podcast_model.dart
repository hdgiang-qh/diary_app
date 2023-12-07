///
/// Code generated by jsonToDartModel https://ashamp.github.io/jsonToDartModel/
///
class PodcastModel {
/*
{
  "id": 1,
  "poster": "https://i.imgur.com/AepZ7lK.jpg",
  "track": "https://www.dropbox.com/scl/fi/ehctq59mjt8jcmh9gdygs/EmIu-WxrdieBinhGold2PillzAndree-7199754.mp3?rlkey=o7dkxwvgdw1z9svxxvawsqql1&dl=0",
  "cate": null,
  "title": "Em iu",
  "author": "Andree Right Hand",
  "moodSound": "Vui",
  "images": [
    null
  ],
  "createdAt": "2023-12-07T17:33:16.671007",
  "createdBy": 1
}
*/

  int? id;
  String? poster;
  String? track;
  String? cate;
  String? title;
  String? author;
  String? moodSound;
  //List<PodcastModelImages?>? images;
  String? createdAt;
  int? createdBy;

  PodcastModel({
    this.id,
    this.poster,
    this.track,
    this.cate,
    this.title,
    this.author,
    this.moodSound,
   // this.images,
    this.createdAt,
    this.createdBy,
  });
  PodcastModel.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toInt();
    poster = json['poster']?.toString();
    track = json['track']?.toString();
    cate = json['cate']?.toString();
    title = json['title']?.toString();
    author = json['author']?.toString();
    moodSound = json['moodSound']?.toString();
    createdAt = json['createdAt']?.toString();
    createdBy = json['createdBy']?.toInt();
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['poster'] = poster;
    data['track'] = track;
    data['cate'] = cate;
    data['title'] = title;
    data['author'] = author;
    data['moodSound'] = moodSound;
    data['createdAt'] = createdAt;
    data['createdBy'] = createdBy;
    return data;
  }
}
