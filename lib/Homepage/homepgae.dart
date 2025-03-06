import 'package:animate_do/animate_do.dart';
import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Carousal%20Slider/imagecontroller.dart';
import 'package:flutter_application_1/Carousal%20Slider/imagemovingmodel.dart';
import 'package:flutter_application_1/Category/category_page.dart';
import 'package:flutter_application_1/Homepage/donate_card.dart';
import 'package:flutter_application_1/drawer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class Homepage extends StatefulWidget {
  Homepage({
    super.key,
  });

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  bool isFirstVisit = true;

  @override
  Widget build(BuildContext context) {
    // final getdata = GetData();
    List<imagemovingmodel> imagelist = [
      imagemovingmodel(
        image: 'lib/images/makeup.jpg',
      ),
      imagemovingmodel(
        image: 'lib/images/photo.jpg',
      ),
      imagemovingmodel(
        image: 'lib/images/immage.jpg',
      ),
    ];
    return Scaffold(
      drawer: MyDrawer(),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        // leading: Drawer(
        //   child: Icon(Icons.menu),
        // ),
        title: Text(
          "Evently",
          style: GoogleFonts.aBeeZee(
              color: Colors.pinkAccent.shade200, fontWeight: FontWeight.bold),
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            top: 20.h,
          ),
          child: Column(
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15.r),
                    child: Container(
                      height: 180.h,
                      width: 320.w,
                      decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.secondary,
                          borderRadius: BorderRadius.circular(18.r)),
                      child: CarouselSlider(
                        options: CarouselOptions(
                            autoPlayCurve: Easing.standard,
                            pauseAutoPlayOnTouch: true,
                            aspectRatio: 100.r,
                            enlargeFactor: 0,
                            initialPage: 0,
                            enlargeCenterPage: true,
                            viewportFraction: 1.10.r,
                            onPageChanged: (index, reason) {
                              Provider.of<SlideImageController>(
                                      listen: false, context)
                                  .updateindex(index);
                            },
                            height: 178.h,
                            autoPlay: true,
                            autoPlayAnimationDuration: Duration(seconds: 1)),
                        items: imagelist.map((i) {
                          return Builder(
                            builder: (BuildContext context) {
                              return Column(
                                children: [
                                  isFirstVisit
                                      ? FadeInRightBig(
                                          duration: Duration(milliseconds: 700),
                                          delay: Duration(milliseconds: 500),
                                          child: Container(
                                            height: 178.h,
                                            width: 375.w,
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(18),
                                              child: Image.asset(
                                                height: 100.h,
                                                i.image,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        )
                                      : Container(
                                          height: 178.h,
                                          width: 375.w,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(18),
                                            child: Image.asset(
                                              height: 100.h,
                                              i.image,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                ],
                              );
                            },
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 10.h,
                    left: 150.w,
                    child: Container(
                      height: 5,
                      width: 5,
                      child: isFirstVisit
                          ? FadeInRightBig(
                              duration: Duration(milliseconds: 600),
                              delay: Duration(milliseconds: 400),
                              child: Consumer<SlideImageController>(
                                builder: (context, value, child) =>
                                    AnimatedSmoothIndicator(
                                        effect: ExpandingDotsEffect(
                                          dotHeight: 8.h,
                                          dotWidth: 9.w,
                                          activeDotColor: Color(0xff247D7F),
                                        ),
                                        activeIndex: value.selectedindex,
                                        count: 3),
                              ),
                            )
                          : Consumer<SlideImageController>(
                              builder: (context, value, child) =>
                                  AnimatedSmoothIndicator(
                                      effect: ExpandingDotsEffect(
                                        dotHeight: 8.h,
                                        dotWidth: 9.w,
                                        activeDotColor: Color(0xff247D7F),
                                      ),
                                      activeIndex: value.selectedindex,
                                      count: 3),
                            ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10.h,
              ),
              isFirstVisit
                  ? FadeInDown(
                      duration: Duration(milliseconds: 700),
                      delay: Duration(milliseconds: 500),
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: 22.w,
                        ),
                        child: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Choose Your Role',
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w600,
                                      fontSize: 18.sp, color: Colors.pinkAccent)),
                              SizedBox(
                                height: 8.h,
                              ),
                              Row(
                                children: [
                                  DonateCard(
                                      height: 150,
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  CategorySelectionPage(
                                                      isHoster: true)),
                                        );
                                      },
                                      text: "Host",
                                      imageurl: 'lib/images/support.png'),
                                  SizedBox(
                                    width: 10.w,
                                  ),
                                  DonateCard(
                                      height: 150,
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  CategorySelectionPage(
                                                      isHoster: false)),
                                        );
                                      },
                                      text: "Guest",
                                      imageurl: 'lib/images/find.png'),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  : Padding(
                      padding: EdgeInsets.only(
                        left: 22.w,
                      ),
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Choose Your Role',
                                style: GoogleFonts.poppins(
                                    fontSize: 18.sp,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.w600)),
                            SizedBox(
                              height: 8.h,
                            ),
                            Row(
                              children: [
                                DonateCard(
                                    height: 150,
                                    onTap: () {
                                      // Navigator.push(
                                      //   context,
                                      //   MaterialPageRoute(
                                      //     builder: (context) => CategoryDonate(
                                      //       cheight: true,
                                      //     ),
                                      //   ),
                                      // );
                                    },
                                    text: "Donate",
                                    imageurl: 'lib/images/foodelivary.png'),
                                SizedBox(
                                  width: 10.w,
                                ),
                                DonateCard(
                                    height: 100,
                                    onTap: () {
                                      // Navigator.push(
                                      //   context,
                                      //   MaterialPageRoute(
                                      //     builder: (context) => Donatepage(
                                      //       showbackbutton: true,
                                      //       onpressed: () {
                                      //         Navigator.maybePop(context);
                                      //       },
                                      //       onSearchFocusChange:
                                      //           updateNavigationBarVisibility, // Pass callback
                                      //     ),
                                      //   ),
                                      // );
                                    },
                                    text: "Find Food",
                                    imageurl: 'lib/images/search.png'),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
              SizedBox(
                height: 20.h,
              ),
              isFirstVisit
                  ? FadeInDown(
                      duration: Duration(milliseconds: 800),
                      delay: Duration(milliseconds: 600),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 25.w),
                            child: Text("Top Rated Avenue",
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16.sp,
                                    color: Colors.pinkAccent)),
                          ),
                        ],
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 25.w),
                          child: Text("What People Feel About us",
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16.sp,
                                  color: Color(0xff247D7F))),
                        ),
                      ],
                    ),
              SizedBox(
                height: 5.h,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
