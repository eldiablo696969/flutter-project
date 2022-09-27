import 'package:flutter/material.dart';
import 'package:ireview/utilities/dialogs/generic_dialog.dart';

Future<void> showCannotShareEmptyNoteDialog(BuildContext context) {
  return showGenericDialog<void>(
    context: context,
    title: 'sharing',
    content: 'You cannot share an empty note',
    optionsBuilder: () => {
      'OK': null,
    },
  );
}
