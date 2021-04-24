import 'dart:math' as math;

import 'package:flutter/services.dart';

/// This [TextInputFormatter] allows only 2 decimal places to be input in a text field.
/// Ignores characters inputted after 2 decimal places.
class DecimalFormatter extends TextInputFormatter {
  DecimalFormatter({this.decimalRange}) : assert(decimalRange == null || decimalRange > 0);

  final int? decimalRange;

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    var newSelection = newValue.selection;
    var truncated = newValue.text;

    if (decimalRange != null) {
      final value = newValue.text;

      if ((value.contains('.') && value.substring(value.indexOf('.') + 1).length > decimalRange!) ||
          (value.contains(',') && value.substring(value.indexOf(',') + 1).length > decimalRange!)) {
        truncated = oldValue.text;
        newSelection = oldValue.selection;
      } else if (value == '.') {
        truncated = '0.';

        newSelection = newValue.selection.copyWith(
          baseOffset: math.min(truncated.length, truncated.length + 1),
          extentOffset: math.min(truncated.length, truncated.length + 1),
        );
      }

      return TextEditingValue(
        text: truncated,
        selection: newSelection,
      );
    }
    return newValue;
  }
}
