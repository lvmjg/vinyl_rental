import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:vinyl_rental/vinyl.dart';
import 'package:vinyl_rental/vinyl_details.dart';
import 'package:intl/intl.dart';

import 'globals.dart';
import 'login.dart';

class VinylList extends StatefulWidget {
  const VinylList({Key? key}) : super(key: key);

  @override
  State<VinylList> createState() => _VinylListState();
}

class _VinylListState extends State<VinylList> {
  late List<Vinyl> vinyls;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[800],
        flexibleSpace: Align(
            alignment: Alignment.centerRight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  currentUser!,
                  style: normalWhite
                ),
                SizedBox(width: space,),
                InkWell(
                  onTap: () {
                    FirebaseAuth.instance.signOut().then((value) {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => Login()));
                    }).catchError((error) => print(error));
                  },
                  child: Padding(
                    padding: EdgeInsets.all(space),
                    child: Icon(
                      Icons.logout_outlined,
                      size: space * 3,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            )),
        title: Text('Rezerwacja płyt'),
      ),
      body: Container(
        color: Colors.grey[200],
        child: Column(
          children: [
            Expanded(
                child: ListView.builder(
                    itemCount: vinyls.length,
                    itemBuilder: ((context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Flexible(
                                    flex: 2,
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    VinylDetails(
                                                        vinyl: vinyls[index])));
                                      },
                                      child: SizedBox(
                                        width: 250,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: FittedBox(
                                            fit: BoxFit.fitWidth,
                                            child: Hero(
                                              tag: vinyls[index].info.title,
                                              child: Image(
                                                image: AssetImage(
                                                    'assets/${vinyls[index].info.title}.jpg'),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    )),
                                Flexible(
                                  flex: 8,
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Flexible(
                                              flex: 4,
                                              child: Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      Text(
                                                        'O płycie',
                                                        style: small,
                                                      ),
                                                    ],
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                  ),
                                                  SizedBox(height: space),
                                                  Container(
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                          color: Colors.blueGrey
                                                              .shade800,
                                                          width: 1.0,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                    space)),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Column(
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Text(
                                                                vinyls[index]
                                                                    .info
                                                                    .title,
                                                                style: normal,
                                                              )
                                                            ],
                                                          ),
                                                          SizedBox(
                                                              height: space),
                                                          Row(
                                                            children: [
                                                              Text(
                                                                vinyls[index]
                                                                    .info
                                                                    .artist,
                                                                style: normal,
                                                              ),
                                                              Text(
                                                                ' - ',
                                                                style: normal,
                                                              ),
                                                              Text(
                                                                vinyls[index]
                                                                    .info
                                                                    .genre,
                                                                style: normal,
                                                              ),
                                                              Text(
                                                                ' - ',
                                                                style: normal,
                                                              ),
                                                              Text(
                                                                vinyls[index]
                                                                    .info
                                                                    .year
                                                                    .toString(),
                                                                style: normal,
                                                              )
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              )),
                                          SizedBox(
                                            width: space,
                                          ),
                                          Flexible(
                                              flex: 4,
                                              child: Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      Text(
                                                        'Stan',
                                                        style: small,
                                                      ),
                                                    ],
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                  ),
                                                  SizedBox(height: space),
                                                  Container(
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                          color: Colors.blueGrey
                                                              .shade800,
                                                          width: 1.0,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                    space)),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Column(
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Text(
                                                                vinyls[index]
                                                                    .state
                                                                    .state,
                                                                style: isVinylNew(
                                                                        index)
                                                                    ? normalGreen
                                                                    : normalRed,
                                                              )
                                                            ],
                                                          ),
                                                          SizedBox(
                                                              height: space),
                                                          Row(
                                                            children: [
                                                              Text(
                                                                'Ocena: ' +
                                                                    (double.parse(vinyls[index].state.rating) ==
                                                                            0
                                                                        ? '-'
                                                                        : vinyls[index]
                                                                            .state
                                                                            .rating),
                                                                style: normal,
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ))
                                        ],
                                      ),
                                      SizedBox(
                                        height: space,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            'Panel rezerwacji',
                                            style: small,
                                          ),
                                        ],
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                      ),
                                      SizedBox(
                                        height: space,
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.blueGrey.shade800,
                                              width: 1.0,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(space)),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    vinyls[index]
                                                        .reserveInfo
                                                        .status,
                                                    textAlign: TextAlign.left,
                                                    style: isVinylAvailable(index)
                                                        ? normalGreen
                                                        : (isVinylReserved(index)
                                                            ? normalRed
                                                            : normalBlue),
                                                  ),
                                                  Visibility(
                                                    visible: !isVinylAvailable(
                                                        index),
                                                    child: Text(
                                                      ' przez ${vinyls[index].reserveInfo.reservedBy} do ${formatterDate.format(vinyls[index].reserveInfo.reservationEnd)}',
                                                      style: normalRed,
                                                    ),
                                                  )
                                                ],
                                              ),
                                              SizedBox(
                                                height: space,
                                              ),
                                              Row(
                                                children: [
                                                  ElevatedButton(
                                                    style: ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStateProperty
                                                              .resolveWith(
                                                                  getColor),
                                                      shape: MaterialStateProperty.all<
                                                              RoundedRectangleBorder>(
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(18.0),
                                                      )),
                                                    ),
                                                    onPressed: isVinylAvailable(
                                                            index)
                                                        ? () =>
                                                            changeActualPrice(
                                                                index, false)
                                                        : null,
                                                    child: Text('-'),
                                                  ),
                                                  SizedBox(
                                                    width: space,
                                                  ),
                                                  Text(
                                                    '${vinyls[index].reserveInfo.actualDays} ${vinyls[index].reserveInfo.actualDays == 1 ? 'dzień' : 'dni'}',
                                                    style: normal,
                                                  ),
                                                  SizedBox(
                                                    width: space,
                                                  ),
                                                  ElevatedButton(
                                                    style: ButtonStyle(
                                                      elevation:
                                                          MaterialStateProperty
                                                              .all(0.5),
                                                      backgroundColor:
                                                          MaterialStateProperty
                                                              .resolveWith(
                                                                  getColor),
                                                      shape: MaterialStateProperty.all<
                                                              RoundedRectangleBorder>(
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(18.0),
                                                      )),
                                                    ),
                                                    onPressed: isVinylAvailable(
                                                            index)
                                                        ? () =>
                                                            changeActualPrice(
                                                                index, true)
                                                        : null,
                                                    child: Text('+'),
                                                  ),
                                                  SizedBox(
                                                    width: space,
                                                  ),
                                                  Text(
                                                    'Koszt ${vinyls[index].reserveInfo.actualPrice} zł',
                                                    style: normal,
                                                  ),
                                                  SizedBox(
                                                    width: space,
                                                  ),
                                                  ElevatedButton(
                                                    style: ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStateProperty
                                                              .resolveWith(
                                                                  getColor),
                                                      shape: MaterialStateProperty.all<
                                                              RoundedRectangleBorder>(
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(18.0),
                                                      )),
                                                    ),
                                                    onPressed:
                                                        handleReserveButton(
                                                            index),
                                                    child: Text(
                                                        handleReserveButtonText(
                                                            index)),
                                                  ),
                                                  SizedBox(
                                                    width: space,
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: space,
                                      ),
                                      Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            ElevatedButton(
                                              style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty
                                                        .resolveWith(getColor),
                                                shape: MaterialStateProperty.all<
                                                        RoundedRectangleBorder>(
                                                    RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          18.0),
                                                )),
                                              ),
                                              onPressed: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            VinylDetails(
                                                                vinyl: vinyls[
                                                                    index])));
                                              },
                                              child: Text('Więcej informacji'),
                                            ),
                                          ])
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    })))
          ],
        ),
      ),
    );
  }

  void changeActualPrice(int index, bool increase) {
    Vinyl vinyl = vinyls[index];

    int actualDays = vinyl.reserveInfo.actualDays;
    if (!increase && actualDays > 1) {
      actualDays--;
    }

    if (increase) {
      actualDays++;
    }
    vinyl.reserveInfo.actualDays = actualDays;

    double basePrice = vinyl.reserveInfo.basePrice;
    vinyl.reserveInfo.actualPrice = actualDays * basePrice;

    setState(() {});
  }

  void reserveVinyl(int index) {
    Vinyl vinyl = vinyls[index];

    String reservedBy = currentUser!;
    String status = "Zarezerwowana";

    DateTime now = DateTime.now();
    int actualDays = vinyl.reserveInfo.actualDays;
    DateTime reservationEndDateTime = now.add(Duration(days: actualDays));

    String reserveStruing = reservationEndDateTime.toString();

    DatabaseReference ref =
        database.ref("vinyls/${vinyl.id}/vinyl_reserve_info");
    ref.update({
      'reserved_by': reservedBy,
      'status': status,
      'reservation_end': reservationEndDateTime.toString()
    }).then((value) {
      vinyl.reserveInfo.reservedBy = reservedBy;
      vinyl.reserveInfo.status = status;
      vinyl.reserveInfo.reservationEnd = reservationEndDateTime;

      setState(() {});
    }).catchError(() {
      print('błąd');
    });
  }

  void cancelVinyl(int index) {
    Vinyl vinyl = vinyls[index];

    String reservedBy = "";
    String status = "Dostępna";
    DateTime reservationEnd = DateTime.now();

    String stringReserve = reservationEnd.toString();

    DatabaseReference ref =
        database.ref("vinyls/${vinyl.id}/vinyl_reserve_info");
    ref.update({
      'reserved_by': reservedBy,
      'status': status,
      'reservation_end': reservationEnd.toString()
    }).then((value) {
      vinyl.reserveInfo.reservedBy = reservedBy;
      vinyl.reserveInfo.status = status;
      vinyl.reserveInfo.reservationEnd = reservationEnd;

      vinyl.reserveInfo.actualDays = 1;
      vinyl.reserveInfo.actualPrice = vinyl.reserveInfo.basePrice;
      setState(() {});
    }).catchError((error) {
      print('błąd');
    });
  }

  bool isVinylAvailable(int index) {
    Vinyl vinyl = vinyls[index];

    return vinyl.reserveInfo.status == "Dostępna";
  }

  bool isVinylReserved(int index) {
    Vinyl vinyl = vinyls[index];

    return vinyl.reserveInfo.status == "Zarezerwowana";
  }

  bool isVinylNew(int index) {
    Vinyl vinyl = vinyls[index];

    return vinyl.state.state == "Nowa";
  }

  bool isVinylReservedByMe(int index) {
    Vinyl vinyl = vinyls[index];

    return vinyl.reserveInfo.reservedBy == currentUser;
  }

  VoidCallback? handleReserveButton(int index) {
    if (isVinylReservedByMe(index)) {
      return () => cancelVinyl(index);
    } else if (isVinylAvailable(index)) {
      return () => reserveVinyl(index);
    } else {
      return null;
    }
  }

  String handleReserveButtonText(int index) {
    if (isVinylReservedByMe(index)) {
      return "Anuluj";
    } else {
      return "Rezerwuj";
    }
  }

  late FirebaseDatabase database;

  @override
  void initState() {
    vinyls = [];
    database = FirebaseDatabase.instance;
    database.useDatabaseEmulator("localhost", 9000);
    //database.ref('/').set({"vinyls": ""});

    WidgetsFlutterBinding.ensureInitialized()
        .addPostFrameCallback((timeStamp) {});

   DatabaseReference ref = database.ref('/');
 /*   ref.get().then((snapshot) {
      var vinylsJson = snapshot.child('vinyls').value as Map;
      List<Vinyl> tempVinyls = vinylsJson.entries
          .map((e) => Vinyl.fromJson(e.key, e.value))
          .toList();
      setState(() {
        vinyls = tempVinyls;
      });
    }).catchError(() {
      print('Błąd!');
    });*/

    ref.child('vinyls').onValue.listen((event) {
      var vinylsJson = event.snapshot.value as Map;
      List<Vinyl> tempVinyls = vinylsJson.entries
          .map((e) => Vinyl.fromJson(e.key, e.value))
          .toList();
      setState(() {
        vinyls = tempVinyls;
      });
    });


    super.initState();
  }
}
