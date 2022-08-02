import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sms_classification/controllers/sms_controller.dart';
import 'package:sms_classification/models/sms_model.dart';
import 'package:sms_classification/routes/app_pages.dart';
import 'package:sms_classification/styles/constant.dart';
import 'package:telephony/telephony.dart';

class ListSms extends StatelessWidget {
  const ListSms({Key? key, required this.sms, required this.index})
      : super(key: key);

  final SmsModel sms;
  final int index;

  @override
  Widget build(BuildContext context) {
    SmsController smsController = Get.find<SmsController>();

    return InkWell(
      onTap: () {
        Get.toNamed(Routes.pesan, arguments: {'index': index});
      },
      highlightColor: Colors.transparent,
      child: ListTile(
        // minLeadingWidth: 50,
        leading: SizedBox(
          width: 45,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              sms.predict.isSpam
                  ? Icon(
                      Icons.warning,
                      color: iconColor[sms.predict.tipe],
                      size: 28,
                    )
                  : const Icon(
                      Icons.chat,
                      color: dangerColor,
                      size: 28,
                    ),
              if (sms.predict.isSpam)
                Text(
                  sms.predict.tipeDecode,
                  style: kHintStyle,
                  textAlign: TextAlign.center,
                ),
            ],
          ),
        ),
        title: Text(
          smsController.encodeContact(smsController.listMessage[index].sender),
        ),
        subtitle: Text(
          (sms.type == SmsType.MESSAGE_TYPE_SENT ? 'Anda: ' : '') + sms.body,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Text(
          smsController.timeAgo(sms.date),
          style: kHintStyle.copyWith(
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
