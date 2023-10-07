import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:get/get.dart';

class PaymentPaystackController extends GetxController {
  final plugin = PaystackPlugin();
  final firestore = FirebaseFirestore.instance;

  final livePubKey = 'pk_live_ee81a641614b7d183e3487a35aaeaed2e2c5d315';

  @override
  void onInit() {
    // var publicKey = app.remoteConfig.getString('paystack_public_key');
    plugin.initialize(publicKey: livePubKey);
    super.onInit();
  }

  Future<CheckoutResponse?> checkout({
    required String email,
    required double amount,
    required String uid,
  }) async {
    try {
      Charge charge = Charge();

      charge
        ..amount = (amount * 100).ceil()
        ..email = email
        ..bearer = Bearer.Account;

      charge.reference = 'ZAP${DateTime.now().millisecondsSinceEpoch.abs()}';

      String reference = charge.reference!;
      var transactionData = {
        'uid': uid,
        'reference': reference,
        'amount': amount,
        'status': "pending",
        'createdAt': Timestamp.now(),
        'updatedAt': Timestamp.now()
      };

      EasyLoading.show(status: 'processing transaction record');
      await firestore.collection('payment').doc(reference).set(transactionData);
      // testing sesssion

      // end testing session

      EasyLoading.dismiss();
      CheckoutResponse response = await plugin.checkout(
        Get.context!,
        charge: charge,
        method: CheckoutMethod.card,
        logo: CircleAvatar(
          backgroundImage: Image.asset(
            'assets/bus-stop.png',
            fit: BoxFit.contain,
          ).image,
        ),
      );

      EasyLoading.showSuccess('payment processed successful');
      return response;
    } on Exception catch (e) {
      e.printError();
    }
    return null;
  }
}
