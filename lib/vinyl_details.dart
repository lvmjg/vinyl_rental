import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vinyl_rental/globals.dart';
import 'package:vinyl_rental/vinyl.dart';
import 'package:vinyl_rental/vinyl_list.dart';

class VinylDetails extends StatefulWidget {
  VinylDetails({Key? key, required this.vinyl}) : super(key: key);

  final Vinyl vinyl;
  int inputRating = 5;
  String inputDescription = "";

  @override
  State<VinylDetails> createState() => _VinylDetailsState();
}

class _VinylDetailsState extends State<VinylDetails> {
  late VinylAdditionalInfo additionalInfo;

  bool second = true, third = true, fourth = true, fifth = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Więcej o ${widget.vinyl.info.title}'),
        backgroundColor: Colors.grey[800],
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Flexible(
                flex: 1,
                child: InkWell(
                  onTap: () => Navigator.pop(context),
                  child: Hero(
                    tag: widget.vinyl.info.title,
                    child: Padding(
                      padding: EdgeInsets.all(32.0),
                      child: Image(
                        image:
                            AssetImage('assets/${widget.vinyl.info.title}.jpg'),
                      ),
                    ),
                  ),
                ),
              ),
              Flexible(
                  flex: 1,
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Column(
                      children: [
                        Align(
                          child: Text(
                            'Lista utworów',
                            style: normal,
                          ),
                        ),
                        SizedBox(height: space),
                        Text(
                          additionalInfo.description,
                          style: small,
                        ),
                      ],
                    ),
                  )),
              Flexible(
                flex: 1,
                child: Column(
                  children: [
                    Text(
                      'Komentarz',
                      textAlign: TextAlign.left,
                      style: normal,
                    ),
                    SizedBox(
                      height: space,
                    ),
                    TextField(
                      controller: TextEditingController(text: widget.inputDescription),
                      onChanged: (value) => widget.inputDescription = value,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 3, color: Colors.blueGrey.shade300), //<-- SEE HERE
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 3, color: Colors.blueGrey.shade500), //<-- SEE HERE
                          ),
                          labelStyle: MaterialStateTextStyle.resolveWith((states) => TextStyle(color: getColor(states))),
                          labelText: 'Napisz co myślisz...',
                        hintStyle: MaterialStateTextStyle.resolveWith((states) => TextStyle(color: getColor(states))),

                      ),


                      minLines: 3,
                      maxLines: 3,
                    ),
                    SizedBox(
                      height: space,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          'Twoja ocena',
                          style: normal,
                        ),
                        Wrap(
                          children: [
                            InkWell(
                                child: Icon(
                                  Icons.star_border_outlined,
                                  color: Colors.black,
                                  size: space * 3,
                                ),
                                onTap: (){},
                                onHover: (hovered) {
                                  if (hovered) selectRating(1);
                                }),
                            InkWell(
                                child: Visibility(
                                  maintainState: true,
                                  maintainSize: true,
                                  maintainAnimation: true,
                                  visible: second,
                                  child: Icon(
                                    Icons.star_border_outlined,
                                    color: Colors.black,
                                    size: space * 3,
                                  ),
                                ),
                                onTap: (){},
                                onHover: (hovered) {
                                  if (hovered) selectRating(2);
                                }),
                            InkWell(
                                child: Visibility(
                                  maintainState: true,
                                  maintainSize: true,
                                  maintainAnimation: true,
                                  visible: third,
                                  child: Icon(
                                    Icons.star_border_outlined,
                                    color: Colors.black,
                                    size: space * 3,
                                  ),
                                ),
                                onTap: (){},
                                onHover: (hovered) {
                                  if (hovered) selectRating(3);
                                }),
                            InkWell(
                                child: Visibility(
                                  maintainState: true,
                                  maintainAnimation: true,
                                  maintainSize: true,
                                  visible: fourth,
                                  child: Icon(
                                    Icons.star_border_outlined,
                                    color: Colors.black,
                                    size: space * 3,
                                  ),
                                ),
                                onTap: (){},
                                onHover: (hovered) {
                                  if (hovered) selectRating(4);
                                }),
                            InkWell(
                                child: Visibility(
                                  maintainState: true,
                                  maintainAnimation: true,
                                  maintainSize: true,
                                  visible: fifth,
                                  child: Icon(
                                    Icons.star_border_outlined,
                                    color: Colors.black,
                                    size: space * 3,
                                  ),
                                ),
                                onTap: (){},
                                onHover: (hovered) {
                                  if (hovered) selectRating(5);
                                } ////,
                                ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: space,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.resolveWith(getColor),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          )),
                        ),
                        onPressed: () {
                          String posted = DateTime.now().toString();

                          DatabaseReference ref = database.ref(
                              '/vinyls_comments/${widget.vinyl.id}/comments');
                          DatabaseReference newPost = ref.push();
                          newPost.set({
                            'user': currentUser,
                            'posted': posted,
                            "rating": widget.inputRating,
                            "description": widget.inputDescription
                          }).then((value) {

                            List<int> ratings = additionalInfo.comments.map((e) => e.rating).toList();

                            double average = ratings.reduce((a, b) => a + b) / ratings.length;

                            DatabaseReference refRating = database.ref('/vinyls/${widget.vinyl.id}/vinyl_state/rating');
                            refRating.set(average);
                          });



                        },
                        child: Text('Dodaj komentarz'),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          Expanded(
              child: ListView.builder(
                  itemCount: additionalInfo.comments.length,
                  itemBuilder: (context, index) {
                    return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                            child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          additionalInfo
                                              .comments[index].description,
                                          style: normal,
                                        ),
                                        Expanded(
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children:
                                              List.generate(additionalInfo.comments[index].rating.toInt(), (index) => Icon(
                                                Icons.star_border_outlined,
                                                color: Colors.black,
                                                size: space * 3,
                                              ))
                                          )

                                          )
                                      ],
                                    ),
                                    SizedBox(
                                      height: space,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          additionalInfo.comments[index].user,
                                          style: normalGrey,
                                        ),
                                        Expanded(
                                            child: Text(
                                          additionalInfo.comments[index].posted,
                                          style: normalGrey,
                                          textAlign: TextAlign.right,
                                        ))
                                      ],
                                    )
                                  ],
                                ))));
                  }))
        ],
      ),
    );
  }

  void selectRating(int rating) {
    widget.inputRating = rating;

    if (rating == 1) {
      second = false;
      third = false;
      fourth = false;
      fifth = false;
    }
    if (rating == 2) {
      second = true;
      third = false;
      fourth = false;
      fifth = false;
    }
    if (rating == 3) {
      second = true;
      third = true;
      fourth = false;
      fifth = false;
    }
    if (rating == 4) {
      second = true;
      third = true;
      fourth = true;
      fifth = false;
    }

    if (rating == 5) {
      second = true;
      third = true;
      fourth = true;
      fifth = true;
    }

    setState(() {

    });
  }

  late FirebaseDatabase database;

  @override
  void initState() {
    additionalInfo = VinylAdditionalInfo("", []);
    database = FirebaseDatabase.instance;
    database.useDatabaseEmulator("localhost", 9000);

    /*DatabaseReference ref = database.ref('/vinyls_comments');
    ref.get().then((snapshot) {
      var vinylsCommentsJson = snapshot.child('${widget.vinyl.id}').value;
      VinylAdditionalInfo tempAdditionalInfo = VinylAdditionalInfo.fromJson(vinylsCommentsJson);
      setState(() {
        additionalInfo = tempAdditionalInfo;
      });
    }).catchError((){
      print('Błąd!');
    });*/


    database
        .ref('/vinyls_comments/${widget.vinyl.id}/description')
        .once()
        .then((event) {
          String description = event.snapshot.value as String;

          setState(() {
            additionalInfo.description = description;
          });


    }).catchError(
            (onError) => print(onError)
    );

    List<Comment> tempComments = [];
    database
        .ref('/vinyls_comments/${widget.vinyl.id}/comments')
        .orderByKey()
        .onChildAdded
        .listen((event) {
      var data = event.snapshot.value;

      tempComments.add(Comment.fromJson(data));

      tempComments.sort((a, b) => a.posted.compareTo(b.posted) * -1);

      setState(() {
      additionalInfo.comments = tempComments;
      });
    });

    super.initState();
  }

  @override
  void dispose() {

  }
}
