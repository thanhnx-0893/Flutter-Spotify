import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'tracks.dart';
import 'utils/utils.dart';
import 'models/artist.dart';
import 'models/error.dart';
import 'api/api.dart';

class Artists extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ArtistsState();
  }
}

class _ArtistsState extends State<Artists> {
  final _artists = <Artist>[];
  var _isLoading = true;

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
            : Container(
                child: ListView.builder(
                  itemCount: _artists.length,
                  itemBuilder: (context, i) {
                    final artist = _artists[i];
                    const nameStyle = TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    );
                    return FlatButton(
                      padding: EdgeInsets.all(0.0),
                      child: Container(
                        padding: EdgeInsets.fromLTRB(16.0, 8.0, 0.0, 0.0),
                        child: Column(
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(80.0),
                                  child: Image.network(
                                    artist.imageURL,
                                    width: 160.0,
                                    height: 160.0,
                                    alignment: Alignment.center,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        artist.name,
                                        style: nameStyle,
                                        textAlign: TextAlign.center,
                                      ),
                                      Text(
                                        '${Utils.convertLargeNumber(artist.followerCount)} followers',
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.centerRight,
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.navigate_next,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      _artistCellTapped(artist);
                                    },
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                      onPressed: () {
                        _artistCellTapped(artist);
                      },
                    );
                  },
                ),
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
    Navigator.push(
      context,
      new MaterialPageRoute(
        builder: (context) => new Tracks(
              artist: artist,
            ),
      ),
    );
  }

  void _fetchArtists() async {
    final response = await http.get(
      API.followingArtistsURL,
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
    final artistsJson = jsonString['artists']['items'] as List;
    _artists.clear();
    for (var artistJson in artistsJson) {
      var artist = Artist.fromJson(artistJson);
      _artists.add(artist);
    }
  }
}
