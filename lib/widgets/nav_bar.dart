import 'package:flutter/material.dart';

late BuildContext mainContext;

class CustomNavigationBar extends StatelessWidget {
  const CustomNavigationBar({
    super.key,
    this.onClick,
    required this.button,
    required this.indexPage,
  });

  final List<IconData> button;
  final int indexPage;
  final Function(int)? onClick;

  GestureDetector _buttonOnNav({
    required IconData icon,
    required int index,
  }) {
    bool isMatchingIndex = indexPage == index;

    return GestureDetector(
      onTap: () {
        (onClick == null) ? onClick : onClick!(index);
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 40,
              color: isMatchingIndex
                  ? Theme.of(mainContext).colorScheme.onPrimary
                  : Theme.of(mainContext).colorScheme.onBackground,
            ),
            SizedBox(
              height: isMatchingIndex ? 2 : 0,
            ),
            Container(
              height: 1,
              width: isMatchingIndex ? 35 : 0,
              decoration: BoxDecoration(
                color: Theme.of(mainContext).colorScheme.onPrimary,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    mainContext = context;

    return Transform.translate(
      offset: const Offset(0, -10),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.onBackground,
              blurStyle: BlurStyle.normal,
              blurRadius: 4,
              offset: const Offset(0, 2),
            )
          ],
        ),
        margin: const EdgeInsets.only(left: 10, right: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(button.length, (int index) {
            return _buttonOnNav(
              icon: button[index],
              index: index,
            );
          }),
        ),
      ),
    );
  }
}
