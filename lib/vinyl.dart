import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:vinyl_rental/globals.dart';

class Vinyl{
  String id;
  VinylInfo info;
  VinylState state;
  VinylReserveInfo reserveInfo;

  Vinyl(this.id, this.info, this.state, this.reserveInfo);

  factory Vinyl.fromJson(String id, dynamic json){
    VinylInfo info = VinylInfo.fromJson(json['vinyl_info']);
    VinylState state = VinylState.fromJson(json['vinyl_state']);
    VinylReserveInfo reserveInfo = VinylReserveInfo.fromJson(json['vinyl_reserve_info']);
    return Vinyl(id, info, state, reserveInfo);
  }
}

class VinylInfo{
  String title;
  String artist;
  String genre;
  int year;

  VinylInfo(this.title, this.artist, this.genre, this.year);

  factory VinylInfo.fromJson(dynamic json){
    String title = json['title'];
    String artist = json['artist'];
    String genre = json['genre'];
    int year = int.parse(json['year']);
    return VinylInfo(title, artist, genre, year);
  }
}

class VinylState{
  String state;
  String rating;

  VinylState(this.state, this.rating);

  factory VinylState.fromJson(dynamic json){
    String state = json['state'];

    double jsonRating = json['rating'];
    NumberFormat numberFormat = NumberFormat('0.00');
    String rating = numberFormat.format(jsonRating);

    return VinylState(state, rating);
  }
}

class VinylReserveInfo{
  double basePrice;
  DateTime reservationEnd;
  String status;
  String reservedBy;

  int actualDays;
  double actualPrice;

  VinylReserveInfo(this.basePrice, this.reservationEnd, this.status, this.reservedBy): actualDays = 1, actualPrice = basePrice;

  factory VinylReserveInfo.fromJson(dynamic json){
    double basePrice = json['base_price'];

    String jsonReservationEnd = json['reservation_end'];
    DateTime reservationEnd =  jsonReservationEnd == "" ? DateTime.now() : DateTime.parse(jsonReservationEnd);

    String status = json['status'];
    String reservedBy = json['reserved_by'];
    return VinylReserveInfo(basePrice, reservationEnd, status, reservedBy);
  }
}

class VinylAdditionalInfo{
  String description;
  List<Comment> comments;

  VinylAdditionalInfo(this.description, this.comments);

  factory VinylAdditionalInfo.fromJson(dynamic json) {
    String description = json['description'];

    var commentsJson = json['comments'] as Map;
    List<Comment> comments = [];
    if(commentsJson!=null) {
      comments = commentsJson.entries.map((e) => Comment.fromJson(e.value)).toList();
    }

    return VinylAdditionalInfo(description, comments);
  }
}

class Comment{
  String user;
  String description;
  String posted;
  int rating;

  Comment(this.user, this.description, this.posted, this.rating);

  factory Comment.fromJson(dynamic json){
    String user = json['user'];
    String description = json['description'];
    String posted = formatterTime.format(DateTime.parse(json['posted']));
    int rating = (json['rating'] as double).toInt();

    return Comment(user,description,posted,rating);
  }
}