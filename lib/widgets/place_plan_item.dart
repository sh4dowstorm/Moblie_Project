import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class PlanPlace extends StatelessWidget {
  const PlanPlace({
    super.key,
    required this.image,
    required this.name,
    required this.located,
    required this.removeFunc,
  });

  final String image;
  final String name;
  final String located;
  final Function() removeFunc;

  @override
  Widget build(BuildContext context) {
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
            Ionicons.ellipsis_vertical_outline,
          ),
          const SizedBox(
            width: 10,
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                image: NetworkImage(
                  image,
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
                width: MediaQuery.of(context).size.width * 0.41,
                child: Text(
                  name,
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
                width: MediaQuery.of(context).size.width * 0.41,
                child: Row(
                  children: [
                    const Icon(
                      Icons.location_on_rounded,
                      color: Colors.red,
                      size: 15,
                    ),
                    Text(
                      located,
                      style: Theme.of(context).textTheme.labelSmall!.copyWith(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          IconButton(
            onPressed: removeFunc,
            icon: Icon(
              Icons.delete_rounded,
              color: Colors.orange[900],
            ),
          ),
        ],
      ),
    );
  }
}
