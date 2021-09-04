import 'dart:convert';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';
import 'package:selector/data/enums.dart';
import 'package:selector/data/record.dart';
import 'package:selector/data/record_info.dart';
import 'package:selector/data/track.dart';

class Discogs {
  static const apiUrl = 'api.discogs.com';
  static final token = dotenv.env['DICOGS_TOKEN'];
  static const headers = {"Accept": "application/json"};

  RecordList results = [];
  late BehaviorSubject<RecordList> resultsSubject;
  late BehaviorSubject<Record?> recordDetailSubject;

  Discogs() {
    resultsSubject = BehaviorSubject<RecordList>();
    recordDetailSubject = BehaviorSubject<Record?>();
  }

  ValueStream<RecordList> get resultsStream => resultsSubject.stream;
  ValueStream<Record?> get recordDetailStream => recordDetailSubject.stream;

  void searchRecords(String query) {
    results = [];
    if (query.isEmpty) resultsSubject.add(results);
    final uri = Uri.https(
      apiUrl,
      "/database/search",
      {
        "q": "$query",
        "token": token,
        "type": "release",
        "format": "vinyl",
      },
    );
    http.get(uri, headers: headers).then((res) {
      var jsonData = json.decode(res.body);
      if (jsonData["results"] != null) {
        jsonData["results"].forEach(
          (result) => results.add(
            Record(info: _fromSearch(result)),
          ),
        );
      }
      resultsSubject.add(results);
    });
  }

  void loadDetails(Record record) {
    if (record.info.fullyLoaded) {
      recordDetailSubject.add(record);
      return;
    }
    final id = record.info.id;
    var uri = Uri.https(
      apiUrl,
      "/releases/${id.toString()}",
      {
        "token": token,
      },
    );
    http.get(uri, headers: headers).then((res) {
      var jsonData = json.decode(res.body);
      if (jsonData == null) {
        throw "getRecord with id '$id' failed";
      }
      record.info = _fromRelease(jsonData, record.info);
      recordDetailSubject.add(record);
    });
  }

  RecordInfo _fromSearch(dynamic json) {
    final splitted = (json["title"] as String).split(" - ");
    final label = (json["label"] as List<dynamic>).join(", ");
    final format = (json["format"] as List<dynamic>).join(", ");
    RecordInfo recordInfo = RecordInfo(
      id: json["id"],
      title: splitted.length > 0 ? splitted[1] : '',
      artist: splitted[0],
      image: json["cover_image"],
      country: json["country"],
      year: int.parse(json["year"] ?? "0"),
      format: format,
      label: label,
      tracks: [],
      fullyLoaded: false,
    );
    return recordInfo;
  }

  RecordInfo _fromRelease(dynamic json, RecordInfo fromSearch) {
    var image = _convertImages(json["images"]);
    if (image.isEmpty) image = fromSearch.image;
    RecordInfo recordInfo = RecordInfo(
      id: json["id"],
      title: json["title"],
      artist: _convertArtists(json["artists"]),
      image: image,
      country: json["country"],
      year: json["year"],
      format: _convertFormats(json["formats"]),
      label: _convertLabels(json["labels"]),
      tracks: _convertTracks(json["tracklist"]),
      fullyLoaded: true,
    );
    return recordInfo;
  }

  // Concat the artists
  String _convertArtists(dynamic artists) {
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
  String _convertFormats(dynamic formats) {
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
  String _convertImages(dynamic images) {
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
  String _convertLabels(dynamic labels) {
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
  TrackList _convertTracks(dynamic tracklist) {
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
