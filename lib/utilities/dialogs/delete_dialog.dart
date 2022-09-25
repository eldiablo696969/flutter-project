import 'package:flutter/material.dart';
import 'package:ireview/utilities/dialogs/generic_dialog.dart';

Future<bool> showDeleteDialog(BuildContext context) {
  return showGenericDialog(
    context: context,
    title: 'Delete',
    content: 'Are you sure want to Delete this note?',
    optionsBuilder: () => {
      'cancel': false,
      'Delete': true,
    },
  ).then(
    (value) => value ?? false,
  );
}
