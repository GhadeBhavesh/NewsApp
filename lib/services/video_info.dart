// To parse this JSON data, do
//
//     final videosList = videosListFromJson(jsonString);

import 'dart:convert';

VideosList videosListFromJson(String str) =>
    VideosList.fromJson(json.decode(str));

String videosListToJson(VideosList data) => json.encode(data.toJson());

class VideosList {
  VideosList({
    required this.kind,
    required this.etag,
    required this.nextPageToken,
    required this.videos,
    // required this.pageInfo,
  });

  String kind;
  String etag;
  String nextPageToken;
  List<VideoItem> videos;
  // PageInfo pageInfo;

  factory VideosList.fromJson(Map<String, dynamic> json) => VideosList(
        kind: json["kind"],
        etag: json["etag"],
        nextPageToken: json["nextPageToken"],
        videos: List<VideoItem>.from(
            json["items"].map((x) => VideoItem.fromJson(x))),
        // pageInfo: PageInfo.fromJson(json["pageInfo"]),
      );

  Map<String, dynamic> toJson() => {
        "kind": kind,
        "etag": etag,
        "nextPageToken": nextPageToken,
        "items": List<dynamic>.from(videos.map((x) => x.toJson())),
        // "pageInfo": pageInfo.toJson(),
      };
}

class VideoItem {
  VideoItem({
    required this.kind,
    required this.etag,
    required this.id,
    required this.video,
  });

  String kind;
  String etag;
  String id;
  Video video;

  factory VideoItem.fromJson(Map<String, dynamic> json) => VideoItem(
        kind: json["kind"],
        etag: json["etag"],
        id: json["id"],
        video: Video.fromJson(json["snippet"]),
      );

  Map<String, dynamic> toJson() => {
        "kind": kind,
        "etag": etag,
        "id": id,
        "snippet": video.toJson(),
      };
}

class Video {
  Video({
    required this.publishedAt,
    required this.channelId,
    required this.title,
    required this.description,
    required this.thumbnails,
    required this.channelTitle,
    required this.playlistId,
    required this.position,
    required this.resourceId,
  });

  DateTime publishedAt;
  String channelId;
  String title;
  String description;
  Thumbnails thumbnails;
  String channelTitle;
  String playlistId;
  int position;
  ResourceId resourceId;

  factory Video.fromJson(Map<String, dynamic> json) => Video(
        publishedAt: DateTime.parse(json["publishedAt"]),
        channelId: json["channelId"],
        title: json["title"],
        description: json["description"],
        thumbnails: Thumbnails.fromJson(json["thumbnails"]),
        channelTitle: json["channelTitle"],
        playlistId: json["playlistId"],
        position: json["position"],
        resourceId: ResourceId.fromJson(json["resourceId"]),
      );

  Map<String, dynamic> toJson() => {
        "publishedAt": publishedAt.toIso8601String(),
        "channelId": channelId,
        "title": title,
        "description": description,
        "thumbnails": thumbnails.toJson(),
        "channelTitle": channelTitle,
        "playlistId": playlistId,
        "position": position,
        "resourceId": resourceId.toJson(),
      };
}

class ResourceId {
  ResourceId({
    required this.kind,
    required this.videoId,
  });

  String kind;
  String videoId;

  factory ResourceId.fromJson(Map<String, dynamic> json) => ResourceId(
        kind: json["kind"],
        videoId: json["videoId"],
      );

  Map<String, dynamic> toJson() => {
        "kind": kind,
        "videoId": videoId,
      };
}

class Thumbnails {
  Thumbnails({
    required this.thumbnailsDefault,
    required this.medium,
    required this.high,
    this.standard,
    this.maxres,
  });

  Default thumbnailsDefault;
  Default medium;
  Default high;
  Default? standard;
  Default? maxres;

  factory Thumbnails.fromJson(Map<String, dynamic> json) => Thumbnails(
        thumbnailsDefault: Default.fromJson(json["default"] ?? {}),
        medium: Default.fromJson(json["medium"] ?? {}),
        high: Default.fromJson(json["high"] ?? {}),
        standard: json["standard"] == null
            ? null
            : Default.fromJson(json["standard"] ?? {}),
        maxres: json["maxres"] == null
            ? null
            : Default.fromJson(json["maxres"] ?? {}),
      );

  Map<String, dynamic> toJson() => {
        "default": thumbnailsDefault.toJson(),
        "medium": medium.toJson(),
        "high": high.toJson(),
        "standard": standard?.toJson(),
        "maxres": maxres?.toJson(),
      };
}

class Default {
  Default({
    required this.url,
    required this.width,
    required this.height,
  });

  String url;
  int width;
  int height;

  factory Default.fromJson(Map<String, dynamic> json) => Default(
        url: json["url"],
        width: json["width"],
        height: json["height"],
      );

  Map<String, dynamic> toJson() => {
        "url": url,
        "width": width,
        "height": height,
      };
}

class PageInfo {
  PageInfo({
    required this.totalResults,
    required this.resultsPerPage,
  });

  int totalResults;
  int resultsPerPage;

  factory PageInfo.fromJson(Map<String, dynamic> json) => PageInfo(
        totalResults: json["totalResults"],
        resultsPerPage: json["resultsPerPage"],
      );

  Map<String, dynamic> toJson() => {
        "totalResults": totalResults,
        "resultsPerPage": resultsPerPage,
      };
}
