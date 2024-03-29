import 'package:flutter/material.dart';

class PlanPlace extends StatelessWidget {
  const PlanPlace({
    super.key,
    this.image,
    this.name,
    this.located,
  });

  final String? image;
  final String? name;
  final String? located;

  @override
  Widget build(BuildContext context) {
    if (image != null && name != null && located != null) {
      return Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.only(
          bottom: 10,
        ),
        child: Row(
          children: [
            const Icon(
              Icons.drag_indicator,
            ),
            const SizedBox(
              width: 10,
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: NetworkImage(
                    image ??
                        'https://firebasestorage.googleapis.com/v0/b/mobile-project-trang.appspot.com/o/admin-profile.png?alt=media&token=42a0629a-5de0-4c75-9edd-fa00cbd8328f',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
              height: 80,
              width: 80,
            ),
            const SizedBox(
              width: 20,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: Text(
                    name!,
                    style: Theme.of(context)
                        .textTheme
                        .labelSmall!
                        .copyWith(fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: Row(
                    children: [
                      const Icon(
                        Icons.location_on_rounded,
                        color: Colors.red,
                        size: 15,
                      ),
                      Text(
                        located!,
                        style: Theme.of(context).textTheme.labelSmall!.copyWith(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                      ),
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      );
    } else {
      return Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.only(
          bottom: 10,
        ),
        width: MediaQuery.of(context).size.width,
        child: Center(
          child: Icon(
            Icons.add_rounded,
            size: 35,
            color: Theme.of(context).colorScheme.onBackground,
          ),
        ),
      );
    }
  }
}
