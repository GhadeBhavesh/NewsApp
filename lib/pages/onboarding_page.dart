import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:news_app/pages/welcome.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OnboardingPagePresenter(pages: [
        OnboardingPageModel(
          title: 'Fast And Secure',
          description:
              'Enjoy the best News of the world in the palm of your hands.',
          imageUrl: 'https://media.tenor.com/PqpfXhwGjd8AAAAi/tv-news.gif',
          bgColor: Colors.indigo,
        ),
        OnboardingPageModel(
          title: 'Share with your friends. ',
          description: 'Share with your friends anytime anywhere.',
          imageUrl: 'https://i.ibb.co/LvmZypG/storefront-illustration-2.png',
          bgColor: const Color(0xff1eb090),
        ),
        OnboardingPageModel(
          title: 'Bookmark your favourites',
          description:
              'Bookmark your favourite news to read at a leisure time.',
          imageUrl: 'https://i.ibb.co/420D7VP/building.png',
          bgColor: const Color(0xfffeae4f),
        ),
      ]),
    );
  }
}

class OnboardingPagePresenter extends StatefulWidget {
  final List<OnboardingPageModel> pages;
  final VoidCallback? onSkip;
  final VoidCallback? onFinish;

  const OnboardingPagePresenter(
      {Key? key, required this.pages, this.onSkip, this.onFinish})
      : super(key: key);

  @override
  State<OnboardingPagePresenter> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPagePresenter> {
  // Store the currently visible page
  int _currentPage = 0;
  // Define a controller for the pageview
  final PageController _pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            color: widget.pages[_currentPage].bgColor,
            child: SafeArea(
              child: Column(children: [
                Expanded(
                  // Pageview to render each page
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: widget.pages.length,
                    onPageChanged: (idx) {
                      // Change current page when pageview changes
                      setState(() {
                        _currentPage = idx;
                      });
                    },
                    itemBuilder: (context, idx) {
                      final item = widget.pages[idx];
                      return Column(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Padding(
                              padding: const EdgeInsets.all(32.0),
                              child: Image.network(
                                item.imageUrl,
                              ),
                            ),
                          ),
                          Expanded(
                              flex: 1,
                              child: Column(children: [
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Text(item.title,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: item.textColor,
                                          )),
                                ),
                                Container(
                                  constraints:
                                      const BoxConstraints(maxWidth: 280),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 24.0, vertical: 8.0),
                                  child: Text(item.description,
                                      textAlign: TextAlign.center,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            color: item.textColor,
                                          )),
                                )
                              ]))
                        ],
                      );
                    },
                  ),
                ),

                // Current page indicator
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: widget.pages
                      .map((item) => AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            width: _currentPage == widget.pages.indexOf(item)
                                ? 30
                                : 8,
                            height: 8,
                            margin: const EdgeInsets.all(2.0),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10.0)),
                          ))
                      .toList(),
                ),

                // Bottom buttons
                SizedBox(
                  height: 100,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                          style: TextButton.styleFrom(
                              visualDensity: VisualDensity.comfortable,
                              foregroundColor: Colors.white,
                              textStyle: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                          onPressed: () {
                            Get.to(WelcomeScreen());
                          },
                          child: const Text("Skip")),
                      TextButton(
                        style: TextButton.styleFrom(
                            visualDensity: VisualDensity.comfortable,
                            foregroundColor: Colors.white,
                            textStyle: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                        onPressed: () {
                          if (_currentPage == widget.pages.length - 1) {
                            widget.onFinish?.call();
                          } else {
                            _pageController.animateToPage(_currentPage + 1,
                                curve: Curves.easeInOutCubic,
                                duration: const Duration(milliseconds: 250));
                          }
                        },
                        child: Row(
                          children: [
                            TextButton(
                              onPressed: () {
                                if (_currentPage == widget.pages.length - 1) {
                                  Get.to(WelcomeScreen());
                                } else {
                                  _currentPage++;
                                  _pageController.animateToPage(_currentPage,
                                      curve: Curves.easeInOutCubic,
                                      duration:
                                          const Duration(milliseconds: 250));
                                }
                              },
                              child: Row(
                                children: [
                                  Text(
                                    _currentPage == widget.pages.length - 1
                                        ? "Finish"
                                        : "Next",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(width: 8),
                                  Icon(
                                    _currentPage == widget.pages.length - 1
                                        ? Icons.done
                                        : Icons.arrow_forward,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ]),
            )));
  }
}

class OnboardingPageModel {
  final String title;
  final String description;
  final String imageUrl;
  final Color bgColor;
  final Color textColor;

  OnboardingPageModel(
      {required this.title,
      required this.description,
      required this.imageUrl,
      this.bgColor = Colors.blue,
      this.textColor = Colors.white});
}
