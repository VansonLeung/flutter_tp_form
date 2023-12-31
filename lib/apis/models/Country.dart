
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

/// a model class wrapper to feed from 'assets/misc/countries.json'.
///
///  - `countryList` -> the primitive country list array
///  - `countryDictByPhoneCode` -> the country list dictionary mapped by `code` as phone code
///  - `countryDictByCountryCode` -> the country list dictionary mapped by `abbr` as country code

class Country {
  String? abbr;
  String? chinese;
  String? code;
  String? english;
  String? spell;
  String? state;
  String? french;
  String? italian;
  String? spanish;
  String? japanese;
  String? russian;
  String? germen;

  String? getName(context) {
    return english;
  }

  String? getCode() {
    return code;
  }

  String? getAbbr() {
    return abbr;
  }

  String getNameRepresentation(BuildContext context) {
    return "${getName(context) ?? ""} +(${getCode() ?? ""})";
  }

  String getNameAbbrRepresentation(BuildContext context) {
    return "${getName(context) ?? ""} +(${getAbbr() ?? ""})";
  }

  Country({this.abbr, this.chinese, this.code, this.english, this.spell,
    this.state, this.french, this.italian, this.spanish, this.japanese,
    this.russian, this.germen});

  factory Country.fromJson(Map<String, dynamic> json) {
    var country = Country(
      abbr: json["abbr"],
      chinese: json["chinese"],
      code: json["code"],
      english: json["english"],
      spell: json["spell"],
      state: json["state"],
      french: json["french"],
      italian: json["italian"],
      spanish: json["spanish"],
      japanese: json["japanese"],
      russian: json["russian"],
      germen: json["germen"],
    );
    return country;
  }

  static List<Country>? countryList;
  static Map<String, Country>? countryDictByPhoneCode;
  static Map<String, Country>? countryDictByCountryCode;

  static Future<bool> loadCountryList() async {
    if (countryList == null) {
      var str = await rootBundle.loadString('assets/misc/countries.json');
      var array = (jsonDecode(str) as List)?.map((it) {
        return Country.fromJson(it);
      }) ?? [];
      countryList = array.toList();
      countryDictByPhoneCode = countryDictByPhoneCode ?? {};
      countryDictByCountryCode = countryDictByCountryCode ?? {};
      countryList?.forEach((it) {
        countryDictByPhoneCode?[it.code!] = it;
        countryDictByCountryCode?[it.abbr!] = it;
      });
      return true;
    }
    return false;
  }
}
