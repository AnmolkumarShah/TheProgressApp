import 'package:flutter/material.dart';
import 'package:progress2/Helper/show_slider_url.dart';

class ImageSlider extends StatelessWidget {
  ImageSlider({Key? key}) : super(key: key);
  final List<String> li = [
    "https://theprogress.in/img/home/slider/slider_image_1.jpg",
    "https://theprogress.in/img/home/slider/slider_image_2.jpg",
    "https://theprogress.in/img/home/slider/slider_image_3.jpg",
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Expanded(child: ShowSliderFromUrl(li)),
    );
  }
}
