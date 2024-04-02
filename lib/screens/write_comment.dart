import 'package:flutter/material.dart';

class WriteComment extends StatefulWidget {
  const WriteComment({
    super.key,
    this.comment,
    this.score,
    required this.updateFirebaseFunc,
  });

  final String? comment;
  final int? score;
  final Function(String newComment, int newScore) updateFirebaseFunc;

  @override
  State<WriteComment> createState() => _WriteCommentState();
}

class _WriteCommentState extends State<WriteComment> {
  late int _scored;
  final TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scored = widget.score ?? 0;
    _commentController.text = widget.comment ?? '';
  }

  @override
  Widget build(BuildContext context) {
    int ratedScore = _scored;

    return AlertDialog(
      title: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            // star rated
            Row(
              children: List.generate(
                5,
                (index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _scored = index + 1;
                      });
                    },
                    child: ((ratedScore--) > 0)
                        ? const Icon(
                            Icons.star_rate_rounded,
                            color: Colors.orange,
                          )
                        : Icon(
                            Icons.star_rate_outlined,
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                  );
                },
              ),
            ),

            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Theme.of(context).colorScheme.primary,
              ),
              margin: const EdgeInsets.only(top: 10),
              padding: const EdgeInsets.all(8),
              child: TextField(
                controller: _commentController,
                decoration: const InputDecoration(
                  hintText: 'What do you think?',
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        // cancle button
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            'Cancle',
            style: Theme.of(context)
                .textTheme
                .labelSmall!
                .copyWith(color: Colors.red),
          ),
        ),
        TextButton(
          onPressed: () {
            widget.updateFirebaseFunc(_commentController.text, _scored);
            Navigator.pop(context);
          },
          child: Text(
            'Save',
            style: Theme.of(context)
                .textTheme
                .labelSmall!
                .copyWith(color: Colors.green[800]),
          ),
        ),
      ],
    );
  }
}
