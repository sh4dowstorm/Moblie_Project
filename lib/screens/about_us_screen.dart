import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUsScreen extends StatefulWidget {
  const AboutUsScreen({super.key});

  @override
  State<AboutUsScreen> createState() => _AboutUsScreenState();
}

class _AboutUsScreenState extends State<AboutUsScreen>
    with TickerProviderStateMixin {
  late final AnimationController _shiba_inuController;
  late final AnimationController _dinoController;
  late final AnimationController _pikachuController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _shiba_inuController = AnimationController(vsync: this);
    _pikachuController = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _shiba_inuController.dispose();
    _pikachuController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
            ),
          ),
          title: Text(
            'About Us',
            style: Theme.of(context).textTheme.labelMedium,
          ),
        ),
        body: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            _createLayout(
              imageLink:
                  'https://firebasestorage.googleapis.com/v0/b/mobile-project-trang.appspot.com/o/profile_moreINVegg.jpg?alt=media&token=f960ef52-b6ec-4d91-8ce4-c5e89fdf8fad',
              name: 'นาย ไชยภัทร ศรีอำไพ',
              id: '6510450305',
              animationPath: 'assets/animations/shiba_inu.json',
              animationController: _shiba_inuController,
              contact: [
                {
                  'url':
                      'https://www.facebook.com/profile.php?id=100071580306510',
                  'icon': const Icon(
                    LineIcons.facebook,
                    size: 40,
                    color: Color(0xFF0866FF),
                  ),
                },
                {
                  'url': 'https://www.instagram.com/moreinvegg/',
                  'icon': ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [
                        Color(0xFF405de6),
                        Color(0xFF5851db),
                        Color(0xFF833ab4),
                        Color(0xFFc13584),
                        Color(0xFFe1306c),
                        Color(0xFFfd1d1d),
                      ],
                      begin: Alignment.topRight,
                    ).createShader(bounds),
                    child: const Icon(
                      LineIcons.instagram,
                      size: 40,
                      color: Colors.white,
                    ),
                  ),
                },
                {
                  'url': 'https://github.com/MoreINV8',
                  'icon': const Icon(
                    LineIcons.github,
                    size: 40,
                    color: Color(0xFF0A0A0B),
                  ),
                },
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            _createLayout(
              imageLink:
                  'https://firebasestorage.googleapis.com/v0/b/mobile-project-trang.appspot.com/o/profile_shadowstorm.jpg?alt=media&token=d505d0fd-55d2-44e7-ad72-24b5c939c6ec',
              name: 'นาย คณิศร ศรีสว่าง',
              id: '6510450216',
              animationPath: 'assets/animations/pikachu.json',
              animationController: _pikachuController,
              contact: [
                {
                  'url':
                      'https://web.facebook.com/profile.php?id=100010873320754',
                  'icon': const Icon(
                    LineIcons.facebook,
                    size: 40,
                    color: Color(0xFF0866FF),
                  ),
                },
                {
                  'url': 'https://www.instagram.com/tom_khanisorn/',
                  'icon': ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [
                        Color(0xFF405de6),
                        Color(0xFF5851db),
                        Color(0xFF833ab4),
                        Color(0xFFc13584),
                        Color(0xFFe1306c),
                        Color(0xFFfd1d1d),
                      ],
                      begin: Alignment.topRight,
                    ).createShader(bounds),
                    child: const Icon(
                      LineIcons.instagram,
                      size: 40,
                      color: Colors.white,
                    ),
                  ),
                },
                {
                  'url': 'https://github.com/sh4dowstorm',
                  'icon': const Icon(
                    LineIcons.github,
                    size: 40,
                    color: Color(0xFF0A0A0B),
                  ),
                },
              ],
            ),

          ],
        ),
      ),
    );
  }

  Widget _createLayout({
    required String imageLink,
    required String name,
    required String id,
    List<Map<String, dynamic>>? contact,
    String? animationPath,
    AnimationController? animationController,
  }) {
    return Container(
      // background
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.onBackground.withOpacity(0.4),
            blurRadius: 8,
          ),
        ],
      ),
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(left: 20, right: 20),
      child: Column(
        children: [
          Row(
            children: [
              // image
              Container(
                height: MediaQuery.of(context).size.width * 0.3,
                width: MediaQuery.of(context).size.width * 0.3,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    fit: BoxFit.fitWidth,
                    image: NetworkImage(imageLink),
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Column(
                children: [
                  Text.rich(
                    TextSpan(
                      spellOut: true,
                      style: Theme.of(context).textTheme.labelMedium,
                      children: [
                        // name
                        TextSpan(
                          text: name,
                        ),
                        const TextSpan(text: '\n'),
                        // student id
                        TextSpan(
                          text: 'รหัสนิสิต: $id',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.width * 0.25,
                    // animation
                    child:
                        (animationPath != null && animationController != null)
                            ? Lottie.asset(
                                animationPath,
                                controller: animationController,
                                onLoaded: (composition) {
                                  animationController.duration =
                                      composition.duration;
                                  animationController.repeat();
                                },
                              )
                            : Container(),
                  ),
                ],
              ),
            ],
          ),
          // line
          Container(
            height: 1,
            width: MediaQuery.of(context).size.width,
            color: Theme.of(context).colorScheme.onBackground.withOpacity(0.3),
            margin: const EdgeInsets.only(top: 10, bottom: 8),
          ),
          Row(
            children: List.generate(
              contact?.length ?? 0,
              (index) => IconButton(
                onPressed: () async {
                  await _openUrl(contact[index]['url']);
                },
                icon: contact![index]['icon'],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _openUrl(String link) async {
    Uri uri = Uri.parse(link);

    await launchUrl(
      uri,
      mode: LaunchMode.platformDefault,
    );
  }
}
