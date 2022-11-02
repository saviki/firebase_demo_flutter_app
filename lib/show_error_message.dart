import 'package:flutter/material.dart';

class ShowErrorMsg{

  static showErrorMessage(BuildContext context,String errorMsg) {
    TextButton okBtn = TextButton(onPressed: (){Navigator.pop(context);}, child: const Text('ok'));
    AlertDialog errorAlert = AlertDialog(
      title: const Text('Error'),
      content: Text(errorMsg),
      actions: [
        okBtn
      ],
    );

    showDialog(context: context, builder:(BuildContext context) => errorAlert);
  }
}