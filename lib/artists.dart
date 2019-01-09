import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

class Artists extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ArtistsState();
  }
}

class _ArtistsState extends State<Artists> {
  final _artists = <Artist>[];
  var _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchArtists();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Artists'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              _refreshButtonTapped();
            },
          )
        ],
      ),
      body: Center(
        child: _isLoading
            ? CircularProgressIndicator()
            : ListView.builder(
                itemCount: _artists.length,
                itemBuilder: (context, i) {
                  final artist = _artists[i];
                  const nameStyle = TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                  );
                  return FlatButton(
                    padding: EdgeInsets.all(0.0),
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            ClipRRect(
                              borderRadius: BorderRadius.circular(100.0),
                              child: Image.network(
                                artist.imageURL,
                                width: 200.0,
                                height: 200.0,
                                alignment: Alignment.center,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  artist.name,
                                  style: nameStyle,
                                  textAlign: TextAlign.center,
                                ),
                                Text('Followers: ${artist.followerCount}'),
                              ],
                            ),
                          ],
                        ),
                        Divider(),
                      ],
                    ),
                    onPressed: () {
                      _artistCellTapped(artist);
                    },
                  );
                },
              ),
      ),
    );
  }

  void _refreshButtonTapped() async {
    _fetchArtists();
    setState(() {
      _isLoading = true;
    });
  }

  void _artistCellTapped(Artist artist) {
    final title =
        '${artist.name}${artist.name.endsWith('s') ? '\'' : '\'s'} tracks';
    Navigator.push(
      context,
      new MaterialPageRoute(
        builder: (context) => new Scaffold(
              appBar: AppBar(
                title: Text(title),
              ),
              body: Center(
                child: Text('List tracks'),
              ),
            ),
      ),
    );
  }

  void _fetchArtists() async {
    final artistsURL =
        'https://api.spotify.com/v1/me/following?type=artist&limit=29';
    final accessToken =
        'Bearer BQDXirU_E1mN7c-zNnufUXHEt75KQGfG4Nw31dR612Z7LYEPIH_C8tFccjoknCOqwfeADuF4A7NWRk8eDaJHxb4ciiAKm1a_X5q0Wug_3BEn_DilaQHqazECA7suTqWsxQatYAjpfx_Gb5sv4KdcO155fTOcaOAE1TwoKD8XqkuOz8XnKxmCfWGVV_Hw-hylE-OW5FD4FmbGNFSc_ExBi2Q1OcDfi6ptDlj2QL99O01M5ErOm1blZZwHJz-M76PUzoM4lH4JKNqiBJL2ezoW';
    final response = await http.get(
      artistsURL,
      headers: {
        HttpHeaders.authorizationHeader: accessToken,
      },
    );
    final jsonString = json.decode(response.body);
    print(jsonString);
    setState(() {
      _isLoading = false;
    });
    if (response.statusCode != 200) {
      final error = Error.fromJson(jsonString);
      _showDialog(context, error.errorMessage);
      return;
    }
    final artistsJson = jsonString['artists']['items'] as List;
    _artists.clear();
    for (var artistJson in artistsJson) {
      var artist = Artist.fromJson(artistJson);
      _artists.add(artist);
      print(artist.name);
    }
  }
}

class Error {
  final int statusCode;
  final String errorMessage;

  Error(this.statusCode, this.errorMessage);
  factory Error.fromJson(Map<String, dynamic> json) {
    return Error(
      json['error']['status'],
      json['error']['message'],
    );
  }
}

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

void _showDialog(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: Text(message),
        actions: <Widget>[
          FlatButton(
            child: Text("OK"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
