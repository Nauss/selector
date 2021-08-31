import 'dart:convert';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:http/http.dart' as http;
import 'package:selector/data/enums.dart';
import 'package:selector/data/record.dart';
import 'package:selector/data/record_info.dart';
import 'package:selector/data/track.dart';

class Discogs {
  static const apiUrl = 'api.discogs.com';
  static const token = 'uodMqxJulsGXDhfjykBLzpXZcObclMGLWmTusxbY';
  static const headers = {"Accept": "application/json"};

  static RecordList currentResults = [];

  static Future<RecordList> getRecords(String query) async {
    currentResults = [];
    if (query.isEmpty) return currentResults;
    var uri = Uri.https(
      apiUrl,
      "/database/search",
      {
        "q": "$query",
        "token": token,
        "type": "release",
        "format": "vinyl",
      },
    );
    var res = await http.get(uri, headers: headers);
    var jsonData = json.decode(res.body);
    if (jsonData["results"] != null) {
      jsonData["results"].forEach(
        (result) => currentResults.add(
          Record(info: Discogs._fromSearch(result)),
        ),
      );
    }
    return currentResults;
  }

  static Future<Record> updateRecord(Record record) async {
    final id = record.info.id;
    var uri = Uri.https(
      apiUrl,
      "/releases/${id.toString()}",
      {
        "token": token,
      },
    );
    var res = await http.get(uri, headers: headers);
    var jsonData = json.decode(res.body);
    if (jsonData == null) {
      throw "getRecord with id '$id' failed";
    }
    record.info = Discogs._fromRelease(jsonData, record.info);
    return record;
  }

  static RecordInfo _fromSearch(dynamic json) {
    final splitted = (json["title"] as String).split(" - ");
    final label = (json["label"] as List<dynamic>).join(", ");
    final format = (json["format"] as List<dynamic>).join(", ");
    RecordInfo recordInfo = RecordInfo(
      id: json["id"],
      title: splitted[1],
      artist: splitted[0],
      image: json["cover_image"],
      country: json["country"],
      year: int.parse(json["year"] ?? "0"),
      format: format,
      label: label,
      tracks: [],
    );
    return recordInfo;
  }

  static RecordInfo _fromRelease(dynamic json, RecordInfo fromSearch) {
    var image = Discogs._convertImages(json["images"]);
    if (image.isEmpty) image = fromSearch.image;
    RecordInfo recordInfo = RecordInfo(
      id: json["id"],
      title: json["title"],
      artist: Discogs._convertArtists(json["artists"]),
      image: image,
      country: json["country"],
      year: json["year"],
      format: Discogs._convertFormats(json["formats"]),
      label: Discogs._convertLabels(json["labels"]),
      tracks: Discogs._convertTracks(json["tracklist"]),
      fullyLoaded: true,
    );
    return recordInfo;
  }

  // Concat the artists
  static String _convertArtists(dynamic artists) {
    String result = "";
    if (artists != null && artists.length > 0) {
      for (var artist in artists) {
        if (result.isNotEmpty) {
          result += ", ";
        }
        result += artist["name"];
      }
    }
    return result;
  }

  // Get the first "vinyl" format
  // Should this be user selectable ?
  static String _convertFormats(dynamic formats) {
    String result = "";
    if (formats != null && formats.length > 0) {
      for (var format in formats) {
        final name = format["name"] as String;
        final descriptions = (format["descriptions"] as List<dynamic>)
            .map(
              (description) => description as String,
            )
            .toList();
        if (name == "Vinyl") {
          result = "$name, ${descriptions.join(", ")}";
          break;
        }
      }
    }
    return result;
  }

  // Get the primary image
  static String _convertImages(dynamic images) {
    String result = "";
    if (images != null && images.length > 0) {
      for (var image in images) {
        if (image["type"] == "primary") {
          result = image["uri"];
          break;
        }
      }
    }
    return result;
  }

  // Concat the labels
  static String _convertLabels(dynamic labels) {
    String result = "";
    if (labels != null && labels.length > 0) {
      for (var label in labels) {
        if (result.isNotEmpty) {
          result += " - ";
        }
        result += "${label["name"]}, ${label["catno"]}";
      }
    }
    return result;
  }

  // Concat the labels
  static TrackList _convertTracks(dynamic tracklist) {
    TrackList result = [];
    if (tracklist != null && tracklist.length > 0) {
      for (var track in tracklist) {
        result.add(Track(
          title: track["title"],
          duration: track["duration"],
          side: EnumToString.fromString(
                  Side.values, (track["position"] as String)[0]) ??
              Side.A,
        ));
      }
    }
    return result;
  }
}
