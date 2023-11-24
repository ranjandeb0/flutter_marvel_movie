import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;

const String publicKey = 'b976c04ed24a3d4163bfee3df7092560';
const String privateKey = 'c6af52709acc6bea88a79af6e943f16ca0a84f4f';

class MovieModel {
  int? id;
  String? title;
  String? description;
  String? url;
  int? startYear;
  int? endYear;
  Map<String, String>? thumbnail;
  External? creators;
  External? comics;

  late int watchPercentage = 0;
  late double size = 1.2;
  late bool watchList;

  MovieModel({
    this.id,
    this.title,
    this.description,
    this.url,
    this.startYear,
    this.endYear,
    this.thumbnail,
    this.creators,
    this.comics,
  });

  factory MovieModel.fromJson(Map<String, dynamic> json) => MovieModel(
        id: json["id"],
        title: json["title"],
        description: json["description"],
        url: () {
          var x = json["urls"].firstWhere((map) => map["type"] == "detail");
          return x == null ? x : x["urls"];
        }(),
        startYear: json["startYear"],
        endYear: json["endYear"],
        thumbnail: {
          "path": json["thumbnail"]["path"],
          "extension": json["thumbnail"]["extension"],
        },
        creators: External.fromJson(json["creators"]),
        comics: External.fromJson(json["comics"]),
      );

  static Future<List<MovieModel>> fetchMovies() async {
    String ts = DateTime.now().millisecondsSinceEpoch.toString();
    String hash =
        md5.convert(utf8.encode(ts + privateKey + publicKey)).toString();
    final http.Response response = await http.get(Uri.parse(
        'https://gateway.marvel.com:443/v1/public/series?ts=$ts&apikey=$publicKey&hash=$hash'));
    if (response.statusCode == 200) {
      final random = Random();
      return [
        for (var movie in jsonDecode(response.body)["data"]["results"])
          MovieModel.fromJson(movie)
            ..watchPercentage = random.nextInt(101)
            ..size = (88 + random.nextInt(500)) / 100
            ..watchList = random.nextBool()
        // MovieModel( title: jsonDecode(response.body)["data"]["results"].toString())
      ];
    }
    return [];
  }
}

class External {
  int available;
  String collectionUri;

  External({
    required this.available,
    required this.collectionUri,
  });

  factory External.fromJson(Map<String, dynamic> json) => External(
        available: json["available"],
        collectionUri: json["collectionURI"],
      );
}
