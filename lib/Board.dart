import 'package:flutter/material.dart';
import 'package:last_chance/MyPostsPage.dart';
import 'NewPostPage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import 'user_provider.dart';



class PostOffer {
  final int id;
  final String title;
  final String description;
  final String DateTime;
  final int studentID;
  final String first_name;
  final String last_name;
  final String car;
  final String model;
  final String color;
  final String platesNumber;
  final int seats;
  // Add other necessary fields

  PostOffer({
    required this.id,
    required this.title,
    required this.description,
    required this.DateTime,
    required this.studentID,
    required this.first_name,
    required this.last_name,
    required this.car,
    required this.model,
    required this.color,
    required this.platesNumber,
    required this.seats,

    // Initialize other fields in the constructor
  });
}

class Post {
  final int id;
  final String title;
  final String description;
  final String DateTime;
  final int studentID;
  final String first_name;
  final String last_name;


  Post({
    required this.id,
    required this.title,
    required this.description,
    required this.DateTime,
    required this.studentID,
    required this.first_name,
    required this.last_name,


    // Initialize other fields in the constructor
  });
}
class BoardData {
  final List<PostOffer> postOffers;
  final List<Post> posts;

  BoardData({required this.postOffers, required this.posts});
}

class Board extends StatefulWidget {
  @override
  _BoardState createState() => _BoardState();
}

class _BoardState extends State<Board> {
  bool _isFilterApplied = false;
  bool? _offerSelected;
  bool? _toMeuSelected;
  bool? _genderSelected;
  bool _isSmokerSelected = false;
  bool _isNonSmokerSelected = false;
  bool _isSuvSelected = false;
  bool _isSedanSelected = false;



  Future<BoardData> fetchPosts() async {

    try {
      final OfferResponse = await http.get(
        Uri.parse('http://192.168.1.77:8000/api/PostRideOffer/index'),


        headers: {
          'Content-Type': 'application/json',
        },
      );
      //for request
      final RequestResponse = await http.get(
        Uri.parse('http://192.168.1.77:8000/api/PostRideRequest/index'),


        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (OfferResponse.statusCode == 200 && RequestResponse.statusCode == 200) {
        // Request successful, parse the response data
        final List<dynamic> offerData= jsonDecode(OfferResponse.body);
        final List<dynamic> requestData= jsonDecode(RequestResponse.body);
        print(offerData);
        // Assuming responseData is a list of posts, extract the necessary information
        List<PostOffer> postOffers = [];
        List<Post> posts = [];
        final currentUserID = Provider.of<UserProvider>(context, listen: false).stu_id;

        for (var postJson in offerData) {
          PostOffer postOffer = PostOffer(
            id: postJson['id'],
            title: postJson['title'],
            description: postJson['subtitle'],
            DateTime: postJson['DateTime'],
              studentID:postJson['studentID'],
              first_name:postJson['FName'],
              last_name: postJson['LName'],
            car: postJson['carCompany'],
            color: postJson['color'],
            model: postJson['model'],
            seats: postJson['seats'],
            platesNumber: postJson['platesNumber'],
            // Extract other fields as needed
          );

          if (postOffer.studentID != currentUserID) {
            postOffers.add(postOffer);
          }
        }
        for (var postJson in requestData) {
          Post post = Post(
              id: postJson['id'],
              title: postJson['title'],
              description: postJson['subtitle'],
              DateTime: postJson['DateTime'],
              studentID:postJson['studentID'],
              first_name:postJson['FName'],
              last_name: postJson['LName'],
            // Extract other fields as needed
          );

          if (post.studentID != currentUserID) {
            posts.add(post);
          }
        }
        return BoardData(postOffers: postOffers,posts: posts);

      } else {
        // Request failed, handle the error
        var responseData = jsonDecode(OfferResponse.body);
        // Handle the error response accordingly
        print(responseData);
      }
    } catch (e) {
      // Error occurred, handle the exception
      print('An error occurred. Please try again.');
    }
    // Return an empty list if there was an error or no posts were retrieved
    return BoardData(postOffers: [], posts: []);
  }
  @override
  void initState() {
    super.initState();
    fetchPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Board'),
        actions: [],
      ),
      body: Column(
        children: [
          ListTile(
            title: Text('Filter posts'),
            trailing: IconButton(
              icon: Icon(Icons.filter_list),
              onPressed: () {
                _showFilterDialog();
              },
            ),
          ),
          Divider(),
          Expanded(
            child: FutureBuilder<BoardData>(
              future: fetchPosts(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final boardData = snapshot.data!;
                  final postOffers = boardData.postOffers;
                  final posts = boardData.posts;
                  final List<dynamic> combinedList = [];
                  combinedList.addAll(postOffers.map((Offer)=>Offer as dynamic));
                  combinedList.addAll(posts.map((post)=>post as dynamic));

                  // Use postOffers and posts as needed
                  // ...
                  if (postOffers.isNotEmpty || posts.isNotEmpty) {
                    return ListView.builder(
                      itemCount: combinedList.length,
                      itemBuilder: (context, index) {
                        final item = combinedList[index];

                        if(item is PostOffer ){
                          final postOffer=item;
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    PostOfferDetailsPage(postOffer: item),
                              ),
                            );

                          },
                          child: ListTile(
                            title: Text(postOffer.title),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(postOffer.description),
                                Text('ID: ${postOffer.id}'),
                                Text('DateTime: ${postOffer.DateTime}'),

                                // Add additional Text widgets or other widgets as needed
                              ],
                            ),
                            // Display other post details as needed
                          ),
                        );}else if (item is Post){
                          final post=item;
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      PostDetailsPage(post: item),
                                ),
                              );

                            },
                            child: ListTile(
                              title: Text(post.title),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(post.description),
                                  Text('ID: ${post.id}'),
                                  Text('DateTime: ${post.DateTime}'),

                                  // Add additional Text widgets or other widgets as needed
                                ],
                              ),
                              // Display other post details as needed
                            ),
                          );
                        }
                      },
                    );
                  }


                  // if (posts.isNotEmpty) {
                  //   return ListView.builder(
                  //     itemCount: posts.length,
                  //     itemBuilder: (context, index) {
                  //       final post = posts[index];
                  //       return GestureDetector(
                  //         onTap: () {
                  //           Navigator.push(
                  //             context,
                  //             MaterialPageRoute(
                  //               builder: (context) =>
                  //                   PostDetailsPage(post: post),
                  //             ),
                  //           );
                  //
                  //         },
                  //         child: ListTile(
                  //           title: Text(post.title),
                  //           subtitle: Column(
                  //             crossAxisAlignment: CrossAxisAlignment.start,
                  //             children: [
                  //               Text(post.description),
                  //               Text('ID: ${post.id}'),
                  //               Text('DateTime: ${post.DateTime}'),
                  //
                  //               // Add additional Text widgets or other widgets as needed
                  //             ],
                  //           ),
                  //           // Display other post details as needed
                  //         ),
                  //       );
                  //     },
                  //   );
                  // }
                  else {
                    return Center(
                      child: Text(
                        _isFilterApplied
                            ? 'Filtered Posts'
                            : 'There are no posts here at the moment.\nCreate a new post or go back to the previous page.',
                        textAlign: TextAlign.center,
                      ),
                    );
                  }
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Failed to fetch posts.',
                      textAlign: TextAlign.center,
                    ),
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

              },
            ),
          ),


          Divider(),
          Container(
            padding: EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children:[
                ElevatedButton(
                  child: Text('My Posts'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MyPostsPage()),
                    );
                  },
                ),

                IconButton(
                  icon: Icon(Icons.help_outline),
                  onPressed: () {
                    _showHelpDialog();
                  },
                ),
                SizedBox(width: 16),
                ElevatedButton(
                  child: Text('New Post'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => NewPostPage()),
                    );
                  },
                ),
              ],
            ),

          ),
        ],
      ),
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Filter posts'),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    Text('Type:'),
                    Row(
                      children: [
                        FilterChip(
                          label: Text('Offer'),
                          selected: _offerSelected == true,
                          onSelected: (selected) {
                            setState(() {
                              _offerSelected = true;
                            });
                          },
                        ),
                        SizedBox(width: 16),
                        FilterChip(
                          label: Text('Request'),
                          selected: _offerSelected == false,
                          onSelected: (selected) {
                            setState(() {
                              _offerSelected = false;
                            });
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    if (_offerSelected != null)
                      Column(
                        children: [
                          Text('Direction:'),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                FilterChip(
                                  label: Text('To MEU'),
                                  selected: _toMeuSelected == true,
                                  onSelected: (selected) {
                                    setState(() {
                                      _toMeuSelected = true;
                                    });
                                  },
                                ),
                                SizedBox(width: 16),
                                FilterChip(
                                  label: Text('From MEU'),
                                  selected: _toMeuSelected == false,
                                  onSelected: (selected) {
                                    setState(() {
                                      _toMeuSelected = false;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 16),
                          Text('Gender:'),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                FilterChip(
                                  label: Text('Male'),
                                  selected: _genderSelected == true,
                                  onSelected: (selected) {
                                    setState(() {
                                      _genderSelected = true;
                                    });
                                  },
                                ),
                                SizedBox(width: 16),
                                FilterChip(
                                  label: Text('Female'),
                                  selected: _genderSelected == false,
                                  onSelected: (selected) {
                                    setState(() {
                                      _genderSelected = false;
                                    });
                                  },
                                ),
                                SizedBox(width: 16),
                                FilterChip(
                                  label: Text('No Specific'),
                                  selected: _genderSelected == null,
                                  onSelected: (selected) {
                                    setState(() {
                                      _genderSelected = null;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 16),
                          Text('Rules:'),
                          FilterChip(
                            label: Text('Smoker'),
                            selected: _isSmokerSelected,
                            onSelected: (selected) {
                              setState(() {
                                _isSmokerSelected = selected;
                              });
                            },
                          ),
                          FilterChip(
                            label: Text('Non-smoker'),
                            selected: _isNonSmokerSelected,
                            onSelected: (selected) {
                              setState(() {
                                _isNonSmokerSelected = selected;
                              });
                            },
                          ),
                          FilterChip(
                            label: Text('Eating/Drinking'),
                            selected: _isSuvSelected,
                            onSelected: (selected) {
                              setState(() {
                                _isSuvSelected = selected;
                              });
                            },
                          ),
                          FilterChip(
                            label: Text('No Eating/Drinking'),
                            selected: _isSedanSelected,
                            onSelected: (selected) {
                              setState(() {
                                _isSedanSelected = selected;
                              });
                            },
                          ),
                        ],
                      ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  child: Text('Reset'),
                  onPressed: () {
                    setState(() {
                      _offerSelected = null;
                      _toMeuSelected = null;
                      _genderSelected = null;
                      _isSmokerSelected = false;
                      _isNonSmokerSelected = false;
                      _isSuvSelected = false;
                      _isSedanSelected = false;
                    });
                  },
                ),
                ElevatedButton(
                  child: Text('Search'),
                  onPressed: () {
                    // Add your logic to filter posts based on selected options
                    setState(() {
                      _isFilterApplied = true;
                    });
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Help'),
          content: Text(
              'This page is for creating a later ride. If you wish to get an immediate ride, go back to the previous page. '),
          actions: [
            ElevatedButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
class PostDetailsPage extends StatelessWidget {
  final Post post;


  PostDetailsPage({required this.post});
  Future<void> acceptPost(accessToken, BuildContext context) async {
    try {
      if (post.title == 'Ride Offer') {
        final response = await http.post(
          Uri.parse('http://192.168.1.77:8000/api/PostRideOffer/${post.id}/accept'),
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        );

        if (response.statusCode == 200) {
          // Request successful, handle the response if needed
          var responseData = jsonDecode(response.body);
          print('Ride Offer post accepted successfully');
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Post Accepted'),
                content: Text('$responseData'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );
        } else {
          // Request failed, handle the error
          var responseData = jsonDecode(response.body);
          print('Error accepting Ride Offer post: $responseData');
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Error'),
                content: Text('Error accepting Ride Offer post: $responseData'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );
        }
      } else {
        final response = await http.post(
          Uri.parse('http://192.168.1.77:8000/api/PostRideRequest/${post.id}/accept'),
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        );

        if (response.statusCode == 200) {
          // Request successful, handle the response if needed
          var responseData = jsonDecode(response.body);
          print('Ride Request post accepted successfully');
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Post Accepted'),
                content: Text('$responseData'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );
        } else {
          // Request failed, handle the error
          var responseData = jsonDecode(response.body);
          print('Error accepting Ride Request post: $responseData');
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Error'),
                content: Text('Error accepting Ride Request post: $responseData'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );
        }
      }
    } catch (e) {
      // Error occurred, handle the exception
      print('An error occurred. Please try again.');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('An error occurred. Please try again.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    String accessToken = Provider.of<UserProvider>(context).token;
    return Scaffold(
      appBar: AppBar(
        title: Text('Post Details'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Text(
                  'Post Type:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18, // Increase the font size as desired
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  post.title,
                  style: TextStyle(
                    fontSize: 18, // Increase the font size as desired
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Text(
                  'Direction:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18, // Increase the font size as desired
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  post.description,
                  style: TextStyle(
                    fontSize: 18, // Increase the font size as desired
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Text(
                  'DateTime:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18, // Increase the font size as desired
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  post.DateTime,
                  style: TextStyle(
                    fontSize: 18, // Increase the font size as desired
                  ),
                ),


              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Text(
                  'Student:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18, // Increase the font size as desired
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  post.studentID.toString(),
                  style: TextStyle(
                    fontSize: 18, // Increase the font size as desired
                  ),
                ),

              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Text(
                  'Name:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18, // Increase the font size as desired
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  '${post.first_name} ${post.last_name}',
                  style: TextStyle(
                    fontSize: 18, // Increase the font size as desired
                  ),
                ),


              ],
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: ElevatedButton(
                  onPressed: () {
                    acceptPost(accessToken, context);

                  },
                  child: Text(
                    'Accept',
                    style: TextStyle(
                      fontSize: 18, // Increase the font size as desired
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}






class PostOfferDetailsPage extends StatelessWidget {
  final PostOffer postOffer;


  PostOfferDetailsPage({required this.postOffer});
  Future<void> acceptPost(accessToken, BuildContext context) async {
    try {
      if (postOffer.title == 'Ride Offer') {
        final response = await http.post(
          Uri.parse('http://192.168.1.77:8000/api/PostRideOffer/${postOffer.id}/accept'),
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        );

        if (response.statusCode == 200) {
          // Request successful, handle the response if needed
          var responseData = jsonDecode(response.body);
          print('Ride Offer post accepted successfully');
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Post Accepted'),
                content: Text('$responseData'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );
        } else {
          // Request failed, handle the error
          var responseData = jsonDecode(response.body);
          print('Error accepting Ride Offer post: $responseData');
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Error'),
                content: Text('Error accepting Ride Offer post: $responseData'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );
        }
      } else {
        final response = await http.post(
          Uri.parse('http://192.168.1.77:8000/api/PostRideRequest/${postOffer.id}/accept'),
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        );

        if (response.statusCode == 200) {
          // Request successful, handle the response if needed
          var responseData = jsonDecode(response.body);
          print('Ride Request post accepted successfully');
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Post Accepted'),
                content: Text('$responseData'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );
        } else {
          // Request failed, handle the error
          var responseData = jsonDecode(response.body);
          print('Error accepting Ride Request post: $responseData');
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Error'),
                content: Text('Error accepting Ride Request post: $responseData'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );
        }
      }
    } catch (e) {
      // Error occurred, handle the exception
      print('An error occurred. Please try again.');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('An error occurred. Please try again.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    String accessToken = Provider.of<UserProvider>(context).token;
    return Scaffold(
      appBar: AppBar(
        title: Text('Post Details'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Text(
                  'Post Type:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18, // Increase the font size as desired
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  postOffer.title,
                  style: TextStyle(
                    fontSize: 18, // Increase the font size as desired
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Text(
                  'Direction:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18, // Increase the font size as desired
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  postOffer.description,
                  style: TextStyle(
                    fontSize: 18, // Increase the font size as desired
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Text(
                  'DateTime:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18, // Increase the font size as desired
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  postOffer.DateTime,
                  style: TextStyle(
                    fontSize: 18, // Increase the font size as desired
                  ),
                ),


              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Text(
                  'Student:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18, // Increase the font size as desired
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  postOffer.studentID.toString(),
                  style: TextStyle(
                    fontSize: 18, // Increase the font size as desired
                  ),
                ),

              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Text(
                  'Name:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18, // Increase the font size as desired
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  '${postOffer.first_name} ${postOffer.last_name}',
                  style: TextStyle(
                    fontSize: 18, // Increase the font size as desired
                  ),
                ),


              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Text(
                  'Car:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18, // Increase the font size as desired
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  postOffer.car,
                  style: TextStyle(
                    fontSize: 18, // Increase the font size as desired
                  ),
                ),


              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Text(
                  'Model:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18, // Increase the font size as desired
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  postOffer.model,
                  style: TextStyle(
                    fontSize: 18, // Increase the font size as desired
                  ),
                ),


              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Text(
                  'Color:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18, // Increase the font size as desired
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  postOffer.color,
                  style: TextStyle(
                    fontSize: 18, // Increase the font size as desired
                  ),
                ),


              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Text(
                  'plates Number:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18, // Increase the font size as desired
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  postOffer.platesNumber,
                  style: TextStyle(
                    fontSize: 18, // Increase the font size as desired
                  ),
                ),


              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Text(
                  'seats:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18, // Increase the font size as desired
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  postOffer.seats.toString(),
                  style: TextStyle(
                    fontSize: 18, // Increase the font size as desired
                  ),
                ),


              ],
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: ElevatedButton(
                  onPressed: () {
                    acceptPost(accessToken, context);

                  },
                  child: Text(
                    'Accept',
                    style: TextStyle(
                      fontSize: 18, // Increase the font size as desired
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}




void main() {
  runApp(MaterialApp(
    home: Board(),
  ));
}
