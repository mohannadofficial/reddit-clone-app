import 'package:flutter/material.dart';

class AppContants {
  static const logoImagePath = 'assets/images/logo.png';
  static const googleImagePath = 'assets/images/google.png';
  static const emoteImagePath = 'assets/images/loginEmote.png';

  static const bannerDefault =
      'https://thumbs.dreamstime.com/b/abstract-stained-pattern-rectangle-background-blue-sky-over-fiery-red-orange-color-modern-painting-art-watercolor-effe-texture-123047399.jpg';
  static const avatarDefault =
      'https://external-preview.redd.it/5kh5OreeLd85QsqYO1Xz_4XSLYwZntfjqou-8fyBFoE.png?auto=webp&s=dbdabd04c399ce9c761ff899f5d38656d1de87c2';

  static const IconData up =
      IconData(0xe800, fontFamily: 'MyFlutterApp', fontPackage: null);
  static const IconData down =
      IconData(0xe801, fontFamily: 'MyFlutterApp', fontPackage: null);

  static const awardsPath = 'assets/images/awards';

  static const awards = {
    'awesomeAns': '${AppContants.awardsPath}/awesomeanswer.png',
    'gold': '${AppContants.awardsPath}/gold.png',
    'platinum': '${AppContants.awardsPath}/platinum.png',
    'helpful': '${AppContants.awardsPath}/helpful.png',
    'plusone': '${AppContants.awardsPath}/plusone.png',
    'rocket': '${AppContants.awardsPath}/rocket.png',
    'thankyou': '${AppContants.awardsPath}/thankyou.png',
    'til': '${AppContants.awardsPath}/til.png',
  };
}

String uid = '';
