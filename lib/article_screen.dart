import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cached_network_image/cached_network_image.dart';

class AricleScreen extends StatefulWidget {
  AricleScreen();

  @override
  AricleScreenState createState() => AricleScreenState();
}

class AricleScreenState extends State<AricleScreen> {
  AricleScreenState();

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: null,
      body: StreamBuilder(
          stream: Firestore.instance.collection('Articles').snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            return ListView(
              children: snapshot.data.documents.map((document) {
                return Padding(
                  padding: EdgeInsets.only(top: 15),
                  child: Container(
                    width: MediaQuery.of(context).size.width / 1.2,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      color: Color(0xff8c52ff),
                    ),
                    child: MaterialButton(
                      onPressed: () {
                        _launchURL(document['url']);
                      },
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Text(document['title'],
                                style: TextStyle(
                                  color: Colors.white,
                                )),
                          ),
                          Padding(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: CachedNetworkImage(
                                imageUrl: document['image'],
                                placeholder: (context, url) =>
                                    CircularProgressIndicator(),
                                errorWidget: (context, url, error) => Icon(
                                  Icons.error,
                                  color: Colors.red,
                                ),
                              )),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            );
          }),
    );
  }
}
