import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController searchControlller = TextEditingController();
  // int page = 1;
  var data;
  Future<Map> getMovieList() async {
    final response = await http.get(
        Uri.parse(
            "https://api.themoviedb.org/3/movie/popular?api_key=a3eb0112a7911c1ce12e6a6b41db4cdd&language=en-US&page=1"),
        headers: <String, String>{
          'Content-Type': 'application/json',
        });

    if (response.statusCode == 200) {
      data = jsonDecode(response.body);
      print('Data from MovieList: ' + data["results"].toString());
      print(data["results"].length);

      return data;
    } else {
      throw Exception("Unable to load Images");
    }
  }

  Future? movies;

  var searchData;
  Future<Map> getSearchMovies(String text) async {
    final response = await http.get(
        Uri.parse(
            "https://api.themoviedb.org/3/search/movie?api_key=a3eb0112a7911c1ce12e6a6b41db4cdd&language=en-US&page=1&include_adult=false&query=" +
                text.toString()),
        headers: <String, String>{
          'Content-Type': 'application/json',
        });

    if (response.statusCode == 200) {
      searchData = jsonDecode(response.body);
      print('Data from SearchMovieList: ' + searchData["results"].toString());
      print(searchData["results"].length);
      isSearched = true;
      return searchData;
    } else {
      throw Exception("Unable to load data");
    }
  }

  Future? searchMovies;

  @override
  void initState() {
    movies = getMovieList();
    super.initState();
  }

  bool isSearched = false;

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    final deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: Text(
          'Home',
          style: TextStyle(
            color: Colors.black,
            fontSize: 23,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        // padding: EdgeInsets.all(deviceWidth * .05),
        height: deviceHeight,
        width: deviceWidth,
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: deviceWidth * .05),
              // padding: EdgeInsets.only(bottom: deviceWidth * .025),
              // height: 30,
              width: deviceWidth,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
              ),
              child: TextFormField(
                controller: searchControlller,
                onFieldSubmitted: (_) {
                  setState(() {
                    getSearchMovies(searchControlller.text);
                  });
                },
                onChanged: (_) {
                  setState(() {
                    getSearchMovies(searchControlller.text);
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Search for movies',
                  hintStyle: TextStyle(
                    color: Colors.black,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      Icons.search,
                      color: Colors.black,
                    ),
                    onPressed: searchControlller.text.isEmpty
                        ? () {
                            print("Please Enter Movie Name");

                            isSearched = false;
                            // getMovieList();
                          }
                        : () {
                            searchMovies =
                                getSearchMovies(searchControlller.text);
                            getSearchMovies(searchControlller.text);
                          },
                  ),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: deviceWidth * .035,
                    vertical: deviceWidth * .035,
                  ),
                ),
              ),
            ),
            isSearched == false
                ? FutureBuilder(
                    future: movies,
                    builder: (ctx, snapshot) => snapshot.connectionState ==
                            ConnectionState.waiting
                        ? Expanded(
                            child: Center(
                              child: CircularProgressIndicator(
                                backgroundColor: Colors.white,
                                valueColor: new AlwaysStoppedAnimation<Color>(
                                    Colors.blueGrey),
                              ),
                            ),
                          )
                        : Expanded(
                            child: ListView.builder(
                              itemCount: data["results"].length,
                              physics: BouncingScrollPhysics(),
                              padding: EdgeInsets.symmetric(
                                  vertical: deviceWidth * 0.05),
                              itemBuilder: (context, index) {
                                return Card(
                                  margin: EdgeInsets.symmetric(
                                      vertical: deviceWidth * .025,
                                      horizontal: deviceWidth * .05),
                                  shadowColor: Colors.grey,
                                  elevation: 5,
                                  child: Row(
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(
                                          right: deviceWidth * 0.035,
                                        ),
                                        width: deviceWidth * 0.35,
                                        height: deviceWidth * 0.5,
                                        decoration: BoxDecoration(
                                            image: DecorationImage(
                                                image: NetworkImage(
                                                    "https://images-na.ssl-images-amazon.com/images/I/71niXI3lxlL._AC_SY679_.jpg"
                                                    // data["results"][index]
                                                    //         ["poster_path"]
                                                    //     .toString(),
                                                    ),
                                                fit: BoxFit.cover),
                                            // color: Colors.black,
                                            borderRadius:
                                                BorderRadius.circular(4)),
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: deviceWidth * .5,
                                            child: Text(
                                              data["results"][index]["title"]
                                                  .toString(),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: deviceWidth * .025,
                                          ),
                                          Text(
                                            "Action|Adventure|Science ",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w300),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(
                                                top: deviceWidth * .03),
                                            height: deviceWidth * 0.06,
                                            width: deviceWidth * 0.25,
                                            decoration: BoxDecoration(
                                              color: data["results"][index]
                                                          ["vote_average"] >=
                                                      7
                                                  ? Colors.green
                                                  : data["results"][index][
                                                              "vote_average"] <=
                                                          5
                                                      ? Colors.red
                                                      : Colors.blue,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Center(
                                              child: Text(
                                                data["results"][index]
                                                            ["vote_average"]
                                                        .toString() +
                                                    ' IMDB',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                  )
                : FutureBuilder(
                    future: searchMovies,
                    builder: (ctx, snapshot) => snapshot.connectionState ==
                            ConnectionState.waiting
                        ? Expanded(
                            child: Center(
                              child: CircularProgressIndicator(
                                backgroundColor: Colors.white,
                                valueColor: new AlwaysStoppedAnimation<Color>(
                                    Colors.blueGrey),
                              ),
                            ),
                          )
                        : searchData["results"].length == 0
                            ? Expanded(
                                child: Center(
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                              color: Colors.grey, blurRadius: 5)
                                        ]),
                                    width: deviceWidth * .8,
                                    height: 75,
                                    padding: EdgeInsets.all(deviceWidth * .025),
                                    child: Center(
                                      child: Text(
                                        "No Movie Found!",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : Expanded(
                                child: ListView.builder(
                                  itemCount: searchData["results"].length,
                                  physics: BouncingScrollPhysics(),
                                  padding: EdgeInsets.symmetric(
                                      vertical: deviceWidth * 0.05),
                                  itemBuilder: (context, index) {
                                    return Card(
                                      margin: EdgeInsets.symmetric(
                                          vertical: deviceWidth * .025,
                                          horizontal: deviceWidth * .05),
                                      shadowColor: Colors.grey,
                                      elevation: 5,
                                      child: Row(
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(
                                              right: deviceWidth * 0.035,
                                            ),
                                            width: deviceWidth * 0.35,
                                            height: deviceWidth * 0.5,
                                            decoration: BoxDecoration(
                                                image: DecorationImage(
                                                    image: NetworkImage(
                                                        "https://images-na.ssl-images-amazon.com/images/I/71niXI3lxlL._AC_SY679_.jpg"
                                                        // data["results"][index]
                                                        //         ["poster_path"]
                                                        //     .toString(),
                                                        ),
                                                    fit: BoxFit.cover),
                                                // color: Colors.black,
                                                borderRadius:
                                                    BorderRadius.circular(4)),
                                          ),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                width: deviceWidth * .5,
                                                child: Text(
                                                  searchData["results"][index]
                                                          ["title"]
                                                      .toString(),
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: deviceWidth * .025,
                                              ),
                                              Text(
                                                "Action|Adventure|Science ",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.w300),
                                              ),
                                              Container(
                                                margin: EdgeInsets.only(
                                                    top: deviceWidth * .03),
                                                height: deviceWidth * 0.06,
                                                width: deviceWidth * 0.25,
                                                decoration: BoxDecoration(
                                                  color: searchData["results"]
                                                                  [index][
                                                              "vote_average"] >=
                                                          7
                                                      ? Colors.green
                                                      : searchData["results"]
                                                                      [index][
                                                                  "vote_average"] <=
                                                              5
                                                          ? Colors.red
                                                          : Colors.blue,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    searchData["results"][index]
                                                                ["vote_average"]
                                                            .toString() +
                                                        ' IMDB',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                  ),
          ],
        ),
      ),
    );
  }
}
