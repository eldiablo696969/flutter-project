import 'package:flutter/material.dart';
import 'package:ireview/utilities/dialogs/generic_dialog.dart';

Future<void> showPasswordResetSentDialog(BuildContext context) {
  return showGenericDialog<void>(
    context: context,
    title: 'Password Reset',
    content:
        'an email has been sent to you please check it for resetting your password',
    optionsBuilder: () => {
      'OK': Null,
    },
  );
}
