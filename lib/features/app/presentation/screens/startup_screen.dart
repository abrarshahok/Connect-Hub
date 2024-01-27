import 'package:connecthub/features/app/presentation/widgets/curved_painter.dart';
import 'package:connecthub/features/auth/presentation/screens/auth_screen.dart';
import 'package:flutter/material.dart';
import 'package:connecthub/components/custom_elevated_button.dart';
import 'package:connecthub/constants/constants.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class StartupScreen extends StatelessWidget {
  StartupScreen({super.key});
  final _controller = PageController();

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
            top: 0,
            child: ColoredBox(
              color: MyColors.primaryColor,
              child: SizedBox(
                height: deviceSize.height * 0.6,
                width: deviceSize.width,
                child: Image.asset(
                  MyImages.startupImage,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            child: SizedBox(
              height: deviceSize.height * 0.9,
              width: deviceSize.width,
              child: CustomPaint(
                painter: CurvedPainter(),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 340.0, left: 20, right: 20, bottom: 20),
                    child: Column(
                      children: [
                        const Spacer(),
                        Expanded(
                          flex: 1,
                          child: PageView(
                            controller: _controller,
                            children: [
                              _buildTextWidget(title: "Your Digital Community"),
                              _buildTextWidget(
                                  title: "Uniting People, Inspiring Moments"),
                              _buildTextWidget(
                                  title: "Connecting You to the World"),
                            ],
                          ),
                        ),
                        SmoothPageIndicator(
                          controller: _controller,
                          count: 3,
                          effect: ExpandingDotsEffect(
                            dotColor: MyColors.primaryColor,
                            activeDotColor: MyColors.buttonColor2,
                            dotHeight: 5,
                          ),
                        ),
                        const SizedBox(height: 30),
                        CustomElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              AuthScreen.routeName,
                            );
                          },
                          title: 'Get Started',
                          width: 200,
                          height: 50,
                          color: MyColors.buttonColor2,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextWidget({required String title}) {
    return Text(
      title,
      textAlign: TextAlign.center,
      style: MyFonts.headingFont(
        fontColor: MyColors.primaryColor,
        fontSize: 35,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
