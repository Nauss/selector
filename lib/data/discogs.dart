import 'dart:convert';
import 'dart:io';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:network_to_file_image/network_to_file_image.dart';
import 'package:rxdart/rxdart.dart';
import 'package:selector/data/enums.dart';
import 'package:selector/data/record.dart';
import 'package:selector/data/record_info.dart';
import 'package:selector/data/selector.dart';
import 'package:selector/data/track.dart';
import 'package:selector/environment_config.dart';
import 'package:path/path.dart' as p;

import 'constants.dart';

class Discogs {
  static const apiUrl = 'api.discogs.com';
  static const token = EnvironmentConfig.discogsToken;
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
        "q": query,
        "token": token,
        "type": "release",
        "format": "vinyl",
      },
    );
    http.get(uri, headers: headers).then((res) {
      var jsonData = json.decode(res.body);
      if (jsonData["results"] != null) {
        final selector = GetIt.I.get<Selector>();
        jsonData["results"].forEach(
          (result) {
            // For now we check whether the record has tracks on C or D sides
            // to know if its a double
            var info = _fromSearch(result);
            results.add(selector.find(result["id"]) ??
                Record(
                  info: info,
                  double: isDouble(info.tracks),
                ));
          },
        );
      }
      resultsSubject.add(results);
    });
  }

  void loadDetails(Record record) {
    // Always update the current stream with the given record
    recordDetailSubject.add(record);
    if (record.info.fullyLoaded) {
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
      if (!record.isDouble && isDouble(record.info.tracks)) {
        record.isDouble = true;
      }
      recordDetailSubject.add(record);
    });
  }

  void loadImage(Record record) {
    final info = record.info;
    if (info.imageLoaded == true) {
      return;
    }
    if (!Uri.parse(info.image).isAbsolute) {
      info.imageProvider = const AssetImage(
        'assets/missing.png',
      );
      info.imageLoaded = false;
    }

    var fileName = "${info.artist}-${info.title}";
    String pathName = p.join(Globals.images!.path, fileName);
    var file = File(pathName);
    try {
      info.imageProvider = NetworkToFileImage(url: info.image, file: file);
      info.imageLoaded = true;
    } catch (e) {
      info.imageProvider = const AssetImage(
        'assets/missing.png',
      );
      info.imageLoaded = false;
    }
    recordDetailSubject.add(record);
  }

  RecordInfo _fromSearch(dynamic json) {
    final splitted = (json["title"] as String).split(" - ");
    final label = (json["label"] as List<dynamic>).join(", ");
    final format = (json["format"] as List<dynamic>).join(", ");
    RecordInfo recordInfo = RecordInfo(
      id: json["id"],
      title: splitted.isNotEmpty ? splitted[1] : '',
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
      imageLoaded: fromSearch.imageLoaded,
      imageProvider: fromSearch.imageProvider,
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
        if (track["type_"] != "track") {
          // remove headings and maybe others
          continue;
        }
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

bool isDouble(List<Track> tracks) =>
    tracks.any((track) => track.side != Side.A && track.side != Side.B);
