import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';

class PlanItem extends StatelessWidget {
  const PlanItem({
    super.key,
    required this.planName,
    required this.image,
    required this.date,
  });

  final String planName;
  final String image;
  final DateTime date;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.secondary,
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
      child: Row(
        children: [
          // image
          Container(
            height: MediaQuery.of(context).size.width * 0.27,
            width: MediaQuery.of(context).size.width * 0.27,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                image: AssetImage('assets/images/$image'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(
            width: 8,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // planname
              Text(
                planName,
                style: Theme.of(context).textTheme.labelMedium!.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(
                height: 12,
              ),

              // plan dated
              Text(
                formatDate(date, [yyyy, '/', M, '/', dd]),
                style: Theme.of(context).textTheme.labelSmall!.copyWith(
                      fontWeight: FontWeight.w300,
                    ),
              )
            ],
          )
        ],
      ),
    );
  }
}
