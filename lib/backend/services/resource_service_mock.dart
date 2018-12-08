import 'dart:math' show Random;

import 'package:flutter/services.dart';
import 'package:inf/backend/services/resource_service_.dart';
import 'package:inf/domain/category.dart';
import 'package:rxdart/rxdart.dart';

class ResourceServiceMock implements ResourceService {
  List<String> displayedImageUrls = <String>[
    // Column 1
    'https://firebasestorage.googleapis.com/v0/b/inf-development.appspot.com/o/mock_data%2Fwelcome_screen_images%2F1.jpg?alt=media&token=d82436ae-7466-464b-a047-41e4473632c1',
    'https://firebasestorage.googleapis.com/v0/b/inf-development.appspot.com/o/mock_data%2Fwelcome_screen_images%2F17.jpg?alt=media&token=702503d5-2c57-48a0-af11-5809fcbbd42e',
    'https://firebasestorage.googleapis.com/v0/b/inf-development.appspot.com/o/mock_data%2Fwelcome_screen_images%2F3.jpg?alt=media&token=9ab752aa-ac5a-4474-9cc2-317bf435eddd',
    // Column 2
    'https://firebasestorage.googleapis.com/v0/b/inf-development.appspot.com/o/mock_data%2Fwelcome_screen_images%2F6.jpg?alt=media&token=358e4893-e127-4271-a67b-2b24cf78f6ae',
    'https://firebasestorage.googleapis.com/v0/b/inf-development.appspot.com/o/mock_data%2Fwelcome_screen_images%2F5.jpg?alt=media&token=e636d72b-c7d4-4d7e-b883-d6f0c2f8cb3c',
    'https://firebasestorage.googleapis.com/v0/b/inf-development.appspot.com/o/mock_data%2Fwelcome_screen_images%2F4.jpg?alt=media&token=97019eb3-f4f1-4937-b0c7-0fcf7e746170',
    // Column 3
    'https://firebasestorage.googleapis.com/v0/b/inf-development.appspot.com/o/mock_data%2Fwelcome_screen_images%2F16.jpg?alt=media&token=c8c1e5d8-85c3-4c1d-9ae2-8dfdfb14c1c0',
    'https://firebasestorage.googleapis.com/v0/b/inf-development.appspot.com/o/mock_data%2Fwelcome_screen_images%2F2.jpg?alt=media&token=332345af-e679-4ac4-a02b-e8f78e4654ff',
    'https://firebasestorage.googleapis.com/v0/b/inf-development.appspot.com/o/mock_data%2Fwelcome_screen_images%2F14.jpg?alt=media&token=d213ff40-04a8-43e2-9f4e-a00bcfc32e2b',
    // Column 4
    'https://firebasestorage.googleapis.com/v0/b/inf-development.appspot.com/o/mock_data%2Fwelcome_screen_images%2F11.jpg?alt=media&token=ac995705-f9ff-4c72-8b51-b4dfa690e03b',
    'https://firebasestorage.googleapis.com/v0/b/inf-development.appspot.com/o/mock_data%2Fwelcome_screen_images%2F10.jpg?alt=media&token=17cf55be-2daa-4664-80cd-c65ba300ef39',
    'https://firebasestorage.googleapis.com/v0/b/inf-development.appspot.com/o/mock_data%2Fwelcome_screen_images%2F12.jpg?alt=media&token=982b09b4-4862-4ae4-9b6d-f243c7cc56fb',
    // Column 5
    'https://firebasestorage.googleapis.com/v0/b/inf-development.appspot.com/o/mock_data%2Fwelcome_screen_images%2F7.jpg?alt=media&token=52ce575e-eb6b-4d31-abe1-ee5620ef8c3b',
    'https://firebasestorage.googleapis.com/v0/b/inf-development.appspot.com/o/mock_data%2Fwelcome_screen_images%2F18.jpg?alt=media&token=7b4eeee9-22c5-41df-a5c4-5d224a024a06',
    'https://firebasestorage.googleapis.com/v0/b/inf-development.appspot.com/o/mock_data%2Fwelcome_screen_images%2F8.jpg?alt=media&token=0862ad5a-f1dc-4017-85b6-61c707e8a37c',
  ];

  List<String> extraImageUrls = <String>[
    'https://firebasestorage.googleapis.com/v0/b/inf-development.appspot.com/o/mock_data%2Fwelcome_screen_images%2F13.jpg?alt=media&token=4f054be8-95b5-4bc6-92ef-bb8184631157',
    'https://firebasestorage.googleapis.com/v0/b/inf-development.appspot.com/o/mock_data%2Fwelcome_screen_images%2F9.jpg?alt=media&token=f1d6d22a-8213-4c99-b6f8-f0d528d6179c',
    'https://firebasestorage.googleapis.com/v0/b/inf-development.appspot.com/o/mock_data%2Fwelcome_screen_images%2F15.jpg?alt=media&token=8f89aa79-40cb-4de5-97b0-e44fbf64f3d6',
  ];

  @override
  Observable<WelcomePageImages> getWelcomePageProfileImages() {
    return Observable.periodic(Duration(milliseconds: 3000))
        .map<WelcomePageImages>((_) => getImages())
        .startWith(getImages());
  }

  WelcomePageImages getImages() {
    var rnd = Random();
    int toReplaceIndex = rnd.nextInt(14);
    int fromIndex = rnd.nextInt(2);

    var toReplace = displayedImageUrls[toReplaceIndex];
    displayedImageUrls[toReplaceIndex] = extraImageUrls[fromIndex];
    extraImageUrls[fromIndex] = toReplace;
    return WelcomePageImages(displayedImageUrls);
  }

  @override
  String getMapApiKey() {
    return 'pk.eyJ1IjoibmJzcG91IiwiYSI6ImNqa2pkOThmdzFha2IzcG16aHl4M3drNTcifQ.jtaEoGuiomNgllDjUMCwNQ';
  }

  @override
  String getMapUrlTemplate() {
    return "https://api.tiles.mapbox.com/v4/mapbox.dark/{z}/{x}/{y}@2x.png"
        "?access_token={accessToken}";
  }

  @override
  Future<List<Category>> getCategories() async {
    var categories = <Category>[
      Category(
        name: 'Cars',
        id: 0,
        iconData: (await rootBundle.load(
                'assets/mockdata/category_icons/cars.svg'))
            .buffer
            .asUint8List(),
      ),
      Category(
        name: 'Drinks',
        id: 1,
        iconData: (await rootBundle.load(
                'assets/mockdata/category_icons/drinks.svg'))
            .buffer
            .asUint8List(),
      ),
      Category(
        name: 'Fashion',
        id: 2,
        iconData: (await rootBundle.load(
                'assets/mockdata/category_icons/fashion.svg'))
            .buffer
            .asUint8List(),
      ),
      Category(
        name: 'Food',
        id: 3,
        iconData: (await rootBundle.load(
                'assets/mockdata/category_icons/food.svg'))
            .buffer
            .asUint8List(),
      ),
      Category(
        name: 'Fun',
        id: 4,
        iconData: (await rootBundle.load(
                'assets/mockdata/category_icons/fun.svg'))
            .buffer
            .asUint8List(),
      ),
      Category(
        name: 'Health',
        id: 5,
        iconData: (await rootBundle.load(
                'assets/mockdata/category_icons/health.svg'))
            .buffer
            .asUint8List(),
      ),
      Category(
        name: 'Services',
        id: 6,
        iconData: (await rootBundle.load(
                'assets/mockdata/category_icons/services.svg'))
            .buffer
            .asUint8List(),
      ),
      Category(
        name: 'Travel',
        id: 7,
        iconData: (await rootBundle.load(
                'assets/mockdata/category_icons/travel.svg'))
            .buffer
            .asUint8List(),
      ),
      Category(
        id: 8,
        parentId: 3,
        name: 'Grocery',
      ),
      Category(
        id: 9,
        parentId: 3,
        name: 'Fast Food',
      ),
      Category(
        id: 10,
        parentId: 3,
        name: 'Candy',
      ),
      Category(
        id: 11,
        parentId: 3,
        name: 'Dessert',
      ),
      Category(
        id: 12,
        parentId: 3,
        name: 'Coffee shop',
      ),
      Category(
        id: 13,
        parentId: 3,
        name: 'Bakeries',
      ),
      Category(
        id: 14,
        parentId: 3,
        name: 'other',
      ),
    ];
    return Future.value(categories);
  }
}
