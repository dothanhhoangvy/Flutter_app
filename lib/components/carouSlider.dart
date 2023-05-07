// ignore_for_file: file_names

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';


class CarouSlider extends StatefulWidget {
  const CarouSlider({super.key});

  @override
  State<CarouSlider> createState() => _CarouSliderState();
}

class _CarouSliderState extends State<CarouSlider> {
  int activeIndex = 0;
  final List<String> imgList = [
    'assets/truck.png',
    'assets/car.png',
    'assets/car1.png',
  ];
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        CarouselSlider.builder(
          itemCount: imgList.length,
          itemBuilder: (context, index, realIndex) {
            final imagelist = imgList[index];
            return buildImage(imagelist, index);
          },
          options: CarouselOptions(
            autoPlay: true,
            aspectRatio: 2.0,
            enlargeCenterPage: true,
            onPageChanged: (index, reason) {
              setState(() {
                activeIndex = index;
              });
            },
          ),
        ),
        SizedBox(height: 32.h),
        buildIndicator(),
      ],
    );
  }

  Widget buildImage(String imagelist, int index) => Image.asset(
        imagelist,
        fit: BoxFit.cover,
        width: double.infinity,
      );
  Widget buildIndicator() => AnimatedSmoothIndicator(
        activeIndex: activeIndex,
        count: imgList.length,
        effect: JumpingDotEffect(
          dotWidth: 7.w,
          dotHeight: 7.h,
          activeDotColor: Colors.blue,
          dotColor: Colors.black,
        ),
      );
}
