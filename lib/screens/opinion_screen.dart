import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ionicons/ionicons.dart';
import 'package:mobile_project/screens/write_comment.dart';
import 'package:mobile_project/services/firebase_loader.dart';
import 'package:mobile_project/models/user.dart' as app_user;

class OpinionScreen extends StatefulWidget {
  const OpinionScreen({
    super.key,
    required this.placeId,
    required this.user,
  });

  final String placeId;
  final app_user.User user;

  @override
  State<OpinionScreen> createState() => _OpinionScreenState();
}

class _OpinionScreenState extends State<OpinionScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          elevation: 1,
          backgroundColor:
              Theme.of(context).colorScheme.background.withOpacity(0.4),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            'Review',
            style:
                Theme.of(context).textTheme.labelMedium!.copyWith(fontSize: 24),
          ),
        ),
        body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          future: FirebaseLoader.placeRef.doc(widget.placeId).get(),
          builder: (context, snapshot) {
            // place data
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Center(
                child: Text(
                  snapshot.error.toString(),
                ),
              );
            } else {
              Map<String, dynamic> placeData = snapshot.data!.data()!;

              return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream:
                    FirebaseLoader.loadData(reference: FirebaseLoader.userRef),
                builder: (context, userSnapshot) {
                  // users data
                  if (userSnapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (userSnapshot.hasError) {
                    return Text(userSnapshot.error.toString());
                  } else {
                    final usersData = userSnapshot.data!.docs;

                    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                      stream: FirebaseLoader.loadData(
                          reference: FirebaseLoader.placeRef
                              .doc(widget.placeId)
                              .collection('opinion')),
                      builder: (context, opinionSnapshot) {
                        // opinion in each places data
                        if (opinionSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else if (opinionSnapshot.hasError) {
                          return Text(opinionSnapshot.error.toString());
                        } else {
                          final opinionsData = opinionSnapshot.data!.docs;
                          // opinion of other user
                          Map<Map<String, dynamic>, Map<String, dynamic>>
                              userOpinion = {};
                          // opinion of current user
                          Map<String, dynamic>? cuserOpinion;

                          log('run');
                          for (var opinion in opinionsData) {
                            for (var user in usersData) {
                              log('cuserid = ${widget.user.uid}\nopinionid = ${opinion.id}\nuserid = ${user.id}');
                              if (widget.user.uid == user.id &&
                                  user.id == opinion.id) {
                                log('userr');
                                cuserOpinion = opinion.data();
                              } else if (user.id == opinion.id) {
                                log('match');
                                userOpinion.putIfAbsent(
                                    user.data(), () => opinion.data());
                              }
                            }
                          }

                          return CustomScrollView(
                            slivers: [
                              // image
                              SliverToBoxAdapter(
                                child: Stack(
                                  children: [
                                    Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.35,
                                      width: MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: NetworkImage(
                                            placeData['image'],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Transform.translate(
                                      offset: Offset(
                                          0,
                                          MediaQuery.of(context).size.height *
                                              0.30),
                                      child: Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.051,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        decoration: BoxDecoration(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .background,
                                          borderRadius:
                                              const BorderRadius.vertical(
                                            top: Radius.circular(20),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // place name
                              SliverToBoxAdapter(
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onBackground,
                                        width: 1,
                                      ),
                                    ),
                                  ),
                                  margin:
                                      const EdgeInsets.fromLTRB(20, 2, 20, 0),
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: Text(
                                    placeData['name'],
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge!
                                        .copyWith(
                                          fontWeight: FontWeight.w500,
                                        ),
                                  ),
                                ),
                              ),
                              const SliverToBoxAdapter(
                                child: SizedBox(
                                  height: 20,
                                ),
                              ),

                              // write comment
                              SliverToBoxAdapter(
                                child: GestureDetector(
                                  onTap: () {
                                    _createPopup(
                                      context: context,
                                      oldComment: cuserOpinion?['comment'] ?? '',
                                      oldScore: cuserOpinion?['score'] ?? 0,
                                      updateValue: (newComment, newScore) {
                                        // upload data to firebase
                                        FirebaseLoader.updateData(
                                          ref: FirebaseLoader.placeRef
                                              .doc(snapshot.data!.id)
                                              .collection('opinion'),
                                          docId: widget.user.uid,
                                          data: {
                                            'comment': newComment,
                                            'score': newScore ?? 0,
                                          },
                                        );

                                        int oldTotalScore = placeData['score'];
                                        int oldRated =
                                            cuserOpinion?['score'] ?? 0;

                                        int newTotalScore = oldTotalScore -
                                            oldRated +
                                            (newScore ?? 0);

                                        log('newScore = $newScore, oldScore = $oldRated, newTotal = $newTotalScore, oldTotal = $oldTotalScore');

                                        FirebaseLoader.updateData(
                                          ref: FirebaseLoader.placeRef,
                                          docId: widget.placeId,
                                          data: {
                                            'category': placeData['category'],
                                            'description':
                                                placeData['description'],
                                            'image': placeData['image'],
                                            'latitude': placeData['latitude'],
                                            'located': placeData['located'],
                                            'longtitude':
                                                placeData['longtitude'],
                                            'name': placeData['name'],
                                            'score': newTotalScore,
                                          },
                                        );
                                      },
                                    );
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .background,
                                      borderRadius: BorderRadius.circular(8),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onBackground
                                              .withOpacity(0.4),
                                          blurRadius: 8,
                                        ),
                                      ],
                                    ),
                                    margin:
                                        const EdgeInsets.fromLTRB(15, 0, 15, 0),
                                    padding: const EdgeInsets.all(10),
                                    width: MediaQuery.of(context).size.width,
                                    child: Row(
                                      children: [
                                        // profile
                                        Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            image: DecorationImage(
                                              image: NetworkImage(
                                                widget.user.profilePictureUrl,
                                              ),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          height: 70,
                                          width: 70,
                                        ),
                                        const SizedBox(
                                          width: 15,
                                        ),

                                        // comment
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.5,
                                          child: Text(
                                            (cuserOpinion == null)
                                                ? 'What do you think?'
                                                : '" ${cuserOpinion['comment'] as String} "',
                                            overflow: TextOverflow.fade,
                                          ),
                                        ),

                                        // rated
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          padding: const EdgeInsets.fromLTRB(
                                              4, 3, 8, 3),
                                          child: Row(
                                            children: [
                                              const Icon(
                                                Icons.star_rate_rounded,
                                                color: Colors.orange,
                                              ),
                                              Text(
                                                '${(cuserOpinion == null) ? 0 : cuserOpinion['score'] as int}',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .labelSmall!
                                                    .copyWith(
                                                        color: Colors.orange),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),

                              const SliverToBoxAdapter(
                                child: SizedBox(
                                  height: 20,
                                ),
                              ),

                              // comment
                              SliverList.builder(
                                itemBuilder: (context, index) {
                                  final commentKey = userOpinion.keys.toList();
                                  final userData = commentKey[index];
                                  final commentData =
                                      userOpinion[commentKey[index]]!;

                                  return Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                    width: MediaQuery.of(context).size.width,
                                    margin: const EdgeInsets.only(
                                        left: 20, right: 20, bottom: 10),
                                    padding: const EdgeInsets.all(10),
                                    child: Column(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.fromLTRB(
                                              5, 0, 5, 5),
                                          decoration: BoxDecoration(
                                            border: Border(
                                              bottom: BorderSide(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onBackground,
                                                width: 1,
                                              ),
                                            ),
                                          ),
                                          child: Row(
                                            children: [
                                              // profile image
                                              Container(
                                                height: 50,
                                                width: 50,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  image: DecorationImage(
                                                    fit: BoxFit.cover,
                                                    image: NetworkImage(
                                                      userData[
                                                          'profilePictureUrl'],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),

                                              // user name
                                              SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.56,
                                                child: Text(
                                                  userData['username'],
                                                ),
                                              ),

                                              // rated
                                              Container(
                                                decoration: BoxDecoration(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .background,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        4, 3, 8, 3),
                                                child: Row(
                                                  children: [
                                                    const Icon(
                                                      Icons.star_rate_rounded,
                                                      color: Colors.orange,
                                                    ),
                                                    Text(
                                                      '${commentData['score'] as int}',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .labelSmall!
                                                          .copyWith(
                                                              color: Colors
                                                                  .orange),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          padding: const EdgeInsets.all(5),
                                          child: Text(
                                            '" ${commentData['comment']} "',
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                itemCount: userOpinion.length,
                              ),
                            ],
                          );
                        }
                      },
                    );
                  }
                },
              );
            }
          },
        ),
      ),
    );
  }

  Future<void> _createPopup({
    required BuildContext context,
    required String oldComment,
    required int oldScore,
    required Function(String? newComment, int? newScore) updateValue,
  }) async {
    return showDialog(
      context: context,
      builder: (context) => WriteComment(
        updateFirebaseFunc: updateValue,
        comment: oldComment,
        score: oldScore,
      ),
    );
  }
}
