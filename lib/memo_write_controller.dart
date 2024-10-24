import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'memo_model.dart';

class MemoWriteController extends GetxController {
  late CollectionReference memoCollectionRef;
  MemoWriteController({this.memoModel});
  MemoModel? memoModel;

  String title = '';
  String memo = '';
  DateTime? memoDate;

final TextEditingController titleTextController = TextEditingController();
final TextEditingController memoTextController = TextEditingController();

@override
void onInit() {
  super.onInit();
  memoCollectionRef = FirebaseFirestore.instance.collection('memo');
  if (memoModel != null) {
    title = memoModel!.title;
    memo = memoModel!.memo;
    memoDate = memoModel!.createdAt;
    titleTextController.text = title;
    memoTextController.text = memo;
  } else {
    memoDate = DateTime.now();
  }
}

  void setTitle(String title) {
    this.title = title;
    update();
  }

  void setMemo(String memo) {
    this.memo = memo;
    update();
  }

  void save() async {
    var newMemoModel = MemoModel(
      id: memoModel?.id,
      title: title,
      memo: memo,
      createdAt: DateTime.now(),
    );
    if (memoModel != null) {
      var doc =
          await memoCollectionRef.where('id', isEqualTo: memoModel!.id).get();
      memoCollectionRef.doc(doc.docs.first.id).update(newMemoModel.toMap());
    } else {
      memoCollectionRef.add(newMemoModel.toMap());
    }
    Get.back(result: newMemoModel);
  }

  void delete() async {
    var doc =
        await memoCollectionRef.where('id', isEqualTo: memoModel!.id).get();
    memoCollectionRef.doc(doc.docs.first.id).delete();
    Get.back(result: true);
  }
}
