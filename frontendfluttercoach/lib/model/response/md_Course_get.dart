// To parse this JSON data, do
//
//     final modelCourseBuy = modelCourseBuyFromJson(jsonString);

import 'dart:convert';

List<ModelCourseBuy> modelCourseBuyFromJson(String str) => List<ModelCourseBuy>.from(json.decode(str).map((x) => ModelCourseBuy.fromJson(x)));

String modelCourseBuyToJson(List<ModelCourseBuy> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ModelCourseBuy {
    int coId;
    int coachId;
    int buyingId;
    String name;
    String details;
    String level;
    int amount;
    String image;
    int days;
    int price;
    String status;
    String expirationDate;
    Coach coach;
    Buying buying;
    dynamic dayOfCouses;

    ModelCourseBuy({
        required this.coId,
        required this.coachId,
        required this.buyingId,
        required this.name,
        required this.details,
        required this.level,
        required this.amount,
        required this.image,
        required this.days,
        required this.price,
        required this.status,
        required this.expirationDate,
        required this.coach,
        required this.buying,
        required this.dayOfCouses,
    });

    factory ModelCourseBuy.fromJson(Map<String, dynamic> json) => ModelCourseBuy(
        coId: json["CoID"],
        coachId: json["CoachID"],
        buyingId: json["BuyingID"],
        name: json["Name"],
        details: json["Details"],
        level: json["Level"],
        amount: json["Amount"],
        image: json["Image"],
        days: json["Days"],
        price: json["Price"],
        status: json["Status"],
        expirationDate: json["ExpirationDate"],
        coach: Coach.fromJson(json["Coach"]),
        buying: Buying.fromJson(json["Buying"]),
        dayOfCouses: json["DayOfCouses"],
    );

    Map<String, dynamic> toJson() => {
        "CoID": coId,
        "CoachID": coachId,
        "BuyingID": buyingId,
        "Name": name,
        "Details": details,
        "Level": level,
        "Amount": amount,
        "Image": image,
        "Days": days,
        "Price": price,
        "Status": status,
        "ExpirationDate": expirationDate,
        "Coach": coach.toJson(),
        "Buying": buying.toJson(),
        "DayOfCouses": dayOfCouses,
    };
}

class Buying {
    int bid;
    int customerId;
    String buyDateTime;
    Customer customer;
    dynamic courses;

    Buying({
        required this.bid,
        required this.customerId,
        required this.buyDateTime,
        required this.customer,
        required this.courses,
    });

    factory Buying.fromJson(Map<String, dynamic> json) => Buying(
        bid: json["Bid"],
        customerId: json["CustomerID"],
        buyDateTime: json["BuyDateTime"],
        customer: Customer.fromJson(json["Customer"]),
        courses: json["Courses"],
    );

    Map<String, dynamic> toJson() => {
        "Bid": bid,
        "CustomerID": customerId,
        "BuyDateTime": buyDateTime,
        "Customer": customer.toJson(),
        "Courses": courses,
    };
}

class Customer {
    int uid;
    String username;
    String password;
    String email;
    String fullName;
    String birthday;
    String gender;
    String phone;
    String image;
    int weight;
    int height;
    String facebookId;
    int price;
    dynamic chats;
    dynamic buying;

    Customer({
        required this.uid,
        required this.username,
        required this.password,
        required this.email,
        required this.fullName,
        required this.birthday,
        required this.gender,
        required this.phone,
        required this.image,
        required this.weight,
        required this.height,
        required this.facebookId,
        required this.price,
        required this.chats,
        required this.buying,
    });

    factory Customer.fromJson(Map<String, dynamic> json) => Customer(
        uid: json["Uid"],
        username: json["Username"],
        password: json["Password"],
        email: json["Email"],
        fullName: json["FullName"],
        birthday: json["Birthday"],
        gender: json["Gender"],
        phone: json["Phone"],
        image: json["Image"],
        weight: json["Weight"],
        height: json["Height"],
        facebookId: json["FacebookID"],
        price: json["Price"],
        chats: json["Chats"],
        buying: json["Buying"],
    );

    Map<String, dynamic> toJson() => {
        "Uid": uid,
        "Username": username,
        "Password": password,
        "Email": email,
        "FullName": fullName,
        "Birthday": birthday,
        "Gender": gender,
        "Phone": phone,
        "Image": image,
        "Weight": weight,
        "Height": height,
        "FacebookID": facebookId,
        "Price": price,
        "Chats": chats,
        "Buying": buying,
    };
}

class Coach {
    int cid;
    String username;
    String password;
    String email;
    String fullName;
    String birthday;
    String gender;
    String phone;
    String image;
    String qualification;
    String property;
    String facebookId;
    int price;
    dynamic buyings;
    dynamic chats;

    Coach({
        required this.cid,
        required this.username,
        required this.password,
        required this.email,
        required this.fullName,
        required this.birthday,
        required this.gender,
        required this.phone,
        required this.image,
        required this.qualification,
        required this.property,
        required this.facebookId,
        required this.price,
        required this.buyings,
        required this.chats,
    });

    factory Coach.fromJson(Map<String, dynamic> json) => Coach(
        cid: json["Cid"],
        username: json["Username"],
        password: json["Password"],
        email: json["Email"],
        fullName: json["FullName"],
        birthday: json["Birthday"],
        gender: json["Gender"],
        phone: json["Phone"],
        image: json["Image"],
        qualification: json["Qualification"],
        property: json["Property"],
        facebookId: json["FacebookID"],
        price: json["Price"],
        buyings: json["Buyings"],
        chats: json["Chats"],
    );

    Map<String, dynamic> toJson() => {
        "Cid": cid,
        "Username": username,
        "Password": password,
        "Email": email,
        "FullName": fullName,
        "Birthday": birthday,
        "Gender": gender,
        "Phone": phone,
        "Image": image,
        "Qualification": qualification,
        "Property": property,
        "FacebookID": facebookId,
        "Price": price,
        "Buyings": buyings,
        "Chats": chats,
    };
}
