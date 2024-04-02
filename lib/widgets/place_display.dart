import 'package:flutter/material.dart';

class PlaceDisplay extends StatelessWidget {
  const PlaceDisplay({
    super.key,
    required this.place,
    required this.image,
    required this.located,
    required this.score,
  });

  final String place;
  final String image;
  final String located;
  final double score;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Stack(
          children: [
            // image
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: NetworkImage(image),
                  fit: BoxFit.cover,
                ),
              ),
              height: 150,
              width: 150,
            ),

            // place rated
            Transform.translate(
              offset: const Offset(110, 5),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.black,
                ),
                padding: const EdgeInsets.fromLTRB(3, 1, 3, 1),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      score.toStringAsFixed(1),
                      style: TextStyle(
                        color: Colors.amber[400],
                        fontSize: 12,
                      ),
                    ),
                    Icon(
                      Icons.star_rounded,
                      color: Colors.amber[400],
                      size: 12,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
        const SizedBox(
          height: 8,
        ),

        // place name
        Container(
          padding: const EdgeInsets.only(left: 5),
          width: 150,
          child: Text(
            place,
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ),

        // place location
        SizedBox(
          width: 150,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.place,
              ),
              Text(
                located,
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ],
          ),
        )
      ],
    );
  }
}
