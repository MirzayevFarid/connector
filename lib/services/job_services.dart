import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connector/models/job_model.dart';
import 'package:connector/models/profile_model.dart';
import 'package:connector/utils/globals.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

Future<Job> addJob(Job job) async {
  final TransactionHandler addJobTransaction = (Transaction tx) async {
    final DocumentSnapshot jobDocumentSnapshot =
        await tx.get(db.collection('jobs').doc());

    job.id = jobDocumentSnapshot.id;
    tx.set(jobDocumentSnapshot.reference, job.toPostJson());

    return job.toJson();
  };
  try {
    var res =
        await FirebaseFirestore.instance.runTransaction(addJobTransaction);
    return Job.fromJson(res);
  } catch (error) {
    print('error: $error');
    return null;
  }
}

Future<Job> addProfile(ProfileModel profile) async {
  final TransactionHandler addProfileTransaction = (Transaction tx) async {
    final DocumentSnapshot profileDocumentSnapshot = await tx.get(
        db.collection('users').doc(globalUid).collection('profiles').doc());

    profile.id = profileDocumentSnapshot.id;
    tx.set(profileDocumentSnapshot.reference, profile.toPostJson());

    return profile.toJson();
  };
  try {
    var res =
        await FirebaseFirestore.instance.runTransaction(addProfileTransaction);
    return Job.fromJson(res);
  } catch (error) {
    print('error: $error');
    return null;
  }
}

Future<bool> addApplicant(Job job, ProfileModel profileModel) async {
  DocumentReference jobReference =
      FirebaseFirestore.instance.collection('jobs').doc(job.id);

  job.applicants.add(profileModel.toJson());

  print(jobReference.get().then((value) {
    print(value['applicants'].runtimeType);
    Timer(Duration(seconds: 1), () async {
      try {
        await jobReference
            .set({'applicants': job.applicants}, SetOptions(merge: true));
        return true;
      } catch (e) {
        print(e);
        return false;
      }
    }).tick;
  }));
}
