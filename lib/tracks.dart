import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sprintf/sprintf.dart';
import 'dart:convert';
import 'dart:io';
import 'utils/utils.dart';
import 'models/artist.dart';
import 'models/error.dart';
import 'models/track.dart';
import 'api/api.dart';

class Tracks extends StatefulWidget {
  final Artist artist;

  const Tracks({Key key, this.artist}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _TracksState(artist);
  }
}

class _TracksState extends State<Tracks> {
  final Artist _artist;
  final _tracks = <Track>[];
  var _isLoading = true;

  _TracksState(this._artist);

  @override
  void initState() {
    super.initState();
    _fetchTopTracks();
  }

  @override
  Widget build(BuildContext context) {
    final title =
        '${_artist.name}${_artist.name.endsWith('s') ? '\'' : '\'s'} Top Tracks';
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.green[300],
      ),
      body: Center(
        child: _isLoading
            ? CircularProgressIndicator()
            : Container(
                child: ListView.builder(
                  itemCount: _tracks.length,
                  itemBuilder: (context, i) {
                    final track = _tracks[i];
                    return Column(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 0.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: <Widget>[
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(4.0),
                                      child: Image.network(
                                        track.albumImageURL,
                                        width: 64.0,
                                        height: 64.0,
                                        alignment: Alignment.center,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      width: 16.0,
                                    ),
                                    Text(
                                      track.name,
                                      textAlign: TextAlign.start,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(4.0),
                                child: Container(
                                  padding:
                                      EdgeInsets.fromLTRB(4.0, 1.0, 4.0, 1.0),
                                  alignment: Alignment.centerRight,
                                  color: Colors.green,
                                  child: Text(
                                    Utils.convertDuration(track.duration),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
      ),
    );
  }

  _fetchTopTracks() async {
    final response = await http.get(
      sprintf(API.topTracksURL, [_artist.id]),
      headers: {
        HttpHeaders.authorizationHeader: API.accessToken,
      },
    );
    final jsonString = json.decode(response.body);
    setState(() {
      _isLoading = false;
    });
    if (response.statusCode != 200) {
      final error = Error.fromJson(jsonString);
      Utils.showMessage(context, error.message);
      return;
    }
    final tracksJson = jsonString['tracks'] as List;
    _tracks.clear();
    for (var trackJson in tracksJson) {
      var track = Track.fromJson(trackJson);
      _tracks.add(track);
    }
  }
}
