import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:progress2/Helper/loader_helper.dart';

CarouselSlider ShowSliderFromUrl(List<String> list,
    {Axis scrollDirection = Axis.horizontal}) {
  return CarouselSlider(
    items: list.map((e) {
      return SizedBox(
        width: double.infinity,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(0),
          child: Image.network(
            e,
            color: Colors.grey,
            colorBlendMode: BlendMode.modulate,
            fit: BoxFit.cover,
            height: double.infinity,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) {
                return child;
              }
              return const Loader();
            },
          ),
        ),
      );
    }).toList(),
    options: CarouselOptions(
      height: double.infinity,
      initialPage: 0,
      enableInfiniteScroll: true,
      reverse: false,
      autoPlay: false,
      autoPlayInterval: const Duration(seconds: 1),
      autoPlayAnimationDuration: const Duration(milliseconds: 1000),
      autoPlayCurve: Curves.fastOutSlowIn,
      enlargeCenterPage: false,
      // onPageChanged: callbackFunction,
      scrollDirection: scrollDirection,
      viewportFraction: 1,
    ),
  );
}
