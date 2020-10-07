import 'package:flutter/material.dart';
import 'package:sentiment_analysis/api.dart';
import 'package:flutter_svg/svg.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool _loading = true;
  final myController = TextEditingController();

  APIService apiService = APIService();
  Future<SentAna> analysis;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: ListView(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [
                    0.004,
                    1
                  ],
                  colors: [
                    Color(0xffe100ff),
                    Color(0xff360096),
                  ]),
            ),
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height / 4.5,
                ),
                Text(
                  "Sentiment Analysis",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 28),
                ),
                Text(
                  "Type a sentence and i would tell you how you feel",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 14),
                ),
                SizedBox(
                  height: 40,
                ),
                Container(
                  padding: EdgeInsets.all(40),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7)
                      ]),
                  child: Column(
                    children: [
                      Container(
                        child: Center(
                            child: _loading
                                ? Container(
                                    width: 300,
                                    child: Column(
                                      children: [
                                        TextField(
                                          controller: myController,
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          decoration: InputDecoration(
                                              labelStyle: TextStyle(
                                                  fontSize: 21,
                                                  color: Colors.black),
                                              labelText:
                                                  "Enter a search term: "),
                                        ),
                                        SizedBox(
                                          height: 30,
                                        ),
                                      ],
                                    ),
                                  )
                                : Container()),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          children: [
                            InkWell(
                              highlightColor: Colors.black.withOpacity(0.5),
                              focusColor: Colors.red,
                              onTap: () {

                                _scaffoldKey.currentState.showSnackBar(
                       SnackBar(backgroundColor: Color(0xffe100ff),
                         duration:  Duration(seconds: 4), content:
                       Row(
                        children: <Widget>[
                          new CircularProgressIndicator(),
                          new Text("  Searching for sentiments...")
                        ],
                      ),
                      ));
                               
                                setState(() {
                                  print(myController.text);
                                  analysis = apiService
                                      .post(query: {'text': myController.text});
                                });
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width - 180,
                                alignment: Alignment.center,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 24, vertical: 17),
                                decoration: BoxDecoration(
                                    color: Color(0xff56ab2f),
                                    borderRadius: BorderRadius.circular(6)),
                                child: _loading
                                    ? Text(
                                        "Find Emotions",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 18),
                                      )
                                    : CircularProgressIndicator(),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            FutureBuilder<SentAna>(
                                future: analysis,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return Column(
                                      children: [
                                        Text(
                                          "Prediction is ${snapshot.data.emotions}",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 29,
                                          ),
                                        ),
                                        snapshot.data.emotions == 'joy'
                                            ? SvgPicture.asset(
                                                'assets/015-smile.svg',
                                                height: 120,
                                              )
                                            : snapshot.data.emotions == 'fear'
                                                ? SvgPicture.asset(
                                                    'assets/012-shock.svg',
                                                    height: 120,
                                                  )
                                                : snapshot.data.emotions ==
                                                        'surpise'
                                                    ? SvgPicture.asset(
                                                        'assets/045-shock.svg',
                                                        height: 120,
                                                      )
                                                    : snapshot.data.emotions ==
                                                            'sadness'
                                                        ? SvgPicture.asset(
                                                            'assets/018-sad.svg',
                                                            height: 120,
                                                          )
                                                        : snapshot.data
                                                                    .emotions ==
                                                                'anger'
                                                            ? SvgPicture.asset(
                                                                'assets/013-angry.svg',
                                                                height: 120,
                                                              )
                                                            : SvgPicture.asset(
                                                                'assets/039-ill.svg',
                                                                height: 120,
                                                              )
                                      ],
                                    );
                                  } else if (snapshot.hasError) {
                                    return Column(
                                      children: [
                                        Text(
                                          "Prediction not found try statements between Anger, happiness, sadness, fear, disgust...",
                                          textAlign: TextAlign.justify,
                                          style: TextStyle(
                                            color: Colors.white,
                                            backgroundColor: Colors.red[300],
                                            fontSize: 14,
                                          ),
                                        ),
                                        SvgPicture.asset(
                                          'assets/041-thinking.svg',
                                          height: 120,
                                        )
                                      ],
                                    );
                                  }
                                  return CircularProgressIndicator();
                                })
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
