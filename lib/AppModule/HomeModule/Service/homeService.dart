import 'dart:convert';
import 'package:game2/AppModule/Controller/controller.dart';
import 'package:game2/AppModule/Network/Apis_call.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../country_model.dart';

Future<CountryModel> HomeService() async {
  AuthController controller = Get.find();
  String country = controller.countryName.value;

  try {
    var response = await API().get(country);
    print("status code is :${response.statusCode}");
    if (response.statusCode == 200) {
      print("success");
      var country = jsonDecode(response.body);
      print(country[0]);
      print(asp["name"]["common"]);
      CountryModel count = CountryModel.fromJson(country[0]);
      print(count.flagPng);
      return count;
    } else {
      print("hard luck bro");
      return null as CountryModel;
    }
  } catch (e) {
    print(e);
    return null as CountryModel;
  }
}

Map asp = {
  "name": {
    "common": "Pakistan",
    "official": "Islamic Republic of Pakistan",
    "nativeName": {
      "eng": {"official": "Islamic Republic of Pakistan", "common": "Pakistan"},
      "urd": {
        "official": "Ø§Ø³ÙØ§ÙÛ Ø¬ÙÛÙØ±ÛÛ Ù¾Ø§ÙØ³ØªØ§Ù",
        "common": "Ù¾Ø§ÙØ³ØªØ§Ù"
      }
    }
  },
  "tld": [".pk"],
  "cca2": "PK",
  "ccn3": "586",
  "cca3": "PAK",
  "cioc": "PAK",
  "independent": true,
  "status": "officially-assigned",
  "unMember": true,
  "currencies": {
    "PKR": {"name": "Pakistani rupee", "symbol": "â¨"}
  },
  "idd": {
    "root": "+9",
    "suffixes": [2]
  },
  "capital": ["Islamabad"],
  "altSpellings": [
    "PK",
    "PÄkistÄn",
    "Islamic Republic of Pakistan",
    "IslÄmÄ« JumhÅ«riya\'eh PÄkistÄn"
  ],
  "region": "Asia",
  "subregion": "Southern Asia",
  "languages": {"eng": "English", "urd": "Urdu"},
  "translations": {
    "ara": {
      "official": "Ø¬ÙÙÙØ±ÙØ© Ø¨Ø§ÙØ³ØªØ§Ù Ø§ÙØ¥Ø³ÙØ§ÙÙØ©",
      "common": "Ø¨Ø§ÙØ³ØªØ§Ù"
    },
    "bre": {"official": "Republik islamek Pakistan", "common": "Pakistan"},
    "ces": {
      "official": "PÃ¡kistÃ¡nskÃ¡" "islÃ¡mskÃ¡ republika",
      "common": "PÃ¡kistÃ¡n"
    }
  }
};
