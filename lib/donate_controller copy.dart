import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class Donate extends ChangeNotifier {
  bool _isLoading = false;
  List<ItemModel> _itemlist = [];
  String _dropdownvalue = 'Free';
  String? selectedvalue;
  String _email = '';
  String _editname = '';

  bool get isLoading => _isLoading;
  List<ItemModel> get itemlist => _itemlist;
  String get dropdownvalue => _dropdownvalue;
  String get email => _email;
  String get eeditname => _editname;

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  final picker = ImagePicker();
  XFile? image;
  File? savedimage;
  String? imageurl;

  List<String> dropdowmitems = [
    'Bca', 'Bcom CA', 'Bcom TT', 'Bse Electronics', 'Multi Media', 'Psychology', 'Ba English'
  ];

  List<String> freeornot = ['Free', 'Price'];
  String? currentvalue;

  void coursecontroll(value) {
    selectedvalue = value;
    notifyListeners();
  }

  void freeornotcontroll(nvalue) {
    currentvalue = nvalue;
    notifyListeners();
  }

  Future<void> imagepickcamera() async {
    setLoading(true);
    XFile? file = await picker.pickImage(source: ImageSource.camera);
    if (file != null) {
      savedimage = File(file.path);
      imageurl = file.path; // Storing local file path
    }
    setLoading(false);
  }

  Future<void> imagepickgallery() async {
    setLoading(true);
    XFile? file = await picker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      savedimage = File(file.path);
      imageurl = file.path; // Storing local file path
    }
    setLoading(false);
  }

  void addtile(ItemModel itemmodel) {
    _itemlist.add(itemmodel);
    notifyListeners();
  }

  void deleteitem(int index) {
    if (index >= 0 && index < _itemlist.length) {
      _itemlist.removeAt(index);
      notifyListeners();
    }
  }

  set selectedCourse(String? course) {
    selectedvalue = course;
    notifyListeners();
  }

  void reset() {
    currentvalue = null;
    notifyListeners();
  }

  void setfreeorprice(String option) {
    _dropdownvalue = option;
    notifyListeners();
  }

  void clearImageCache() {
    imageurl = null;
    notifyListeners();
  }

  void editprofile({required String name, required String email, required File image}) {
    _email = email;
    _editname = name;
    savedimage = image;
    notifyListeners();
  }
}

class ItemModel {
  final String image;
  final String category;
  final String foodname;
  final String description;
  final DateTime date;
  final String lname;
  final String fname;
  final String course;
  final String cntctbo;
  final String option;
  final String donationId;
  final String quantity;

  ItemModel({
    required this.image,
    required this.category,
    required this.foodname,
    required this.description,
    required this.date,
    required this.lname,
    required this.fname,
    required this.course,
    required this.cntctbo,
    required this.option,
    required this.donationId,
    required this.quantity,
  });

  final now = DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'image': image,
      'category': category,
      'foodname': foodname,
      'description': description,
      'date': DateFormat.jm().format(now),
      'lname': lname,
      'fname': fname,
      'course': course,
      'cntctbo': cntctbo,
      'option': option,
      'donationid': donationId,
    };
  }

  factory ItemModel.fromMap(Map<String, dynamic> map) {
    return ItemModel(
      image: map['image'],
      category: map['category'],
      foodname: map['foodname'],
      description: map['description'],
      date: DateTime.parse(map['date']),
      lname: map['lname'],
      fname: map['fname'],
      course: map['course'],
      cntctbo: map['cntctbo'],
      option: map['option'],
      donationId: map['donationid'],
      quantity: map['quantity'],
    );
  }
}
