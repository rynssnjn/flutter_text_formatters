import 'dart:math';

import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class CurrencyFormatter extends TextInputFormatter {
  CurrencyFormatter({
    this.locale,
    this.name,
    this.symbol,
    this.turnOffGrouping = false,
  });

  final String locale;
  final String name;
  final String symbol;
  final bool turnOffGrouping;

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final isInsertedCharacter =
        oldValue.text.length + 1 == newValue.text.length && newValue.text.startsWith(oldValue.text);
    final isRemovedCharacter =
        oldValue.text.length - 1 == newValue.text.length && oldValue.text.startsWith(newValue.text);

    if (!isInsertedCharacter && !isRemovedCharacter) {
      return oldValue;
    }

    final format = NumberFormat.currency(
      locale: locale,
      name: name,
      symbol: symbol,
    );
    if (turnOffGrouping) {
      format.turnOffGrouping();
    }
    final isNegative = newValue.text.startsWith('-');
    var newText = newValue.text.replaceAll(RegExp('[^0-9]'), '');

    if (isRemovedCharacter && !_lastCharacterIsDigit(oldValue.text)) {
      final length = newText.length - 1;
      newText = newText.substring(0, length > 0 ? length : 0);
    }

    if (newText.trim() == '') {
      return newValue.copyWith(
        text: isNegative ? '-' : '',
        selection: TextSelection.collapsed(offset: isNegative ? 1 : 0),
      );
    } else if (newText == '00' || newText == '000') {
      return TextEditingValue(
        text: isNegative ? '-' : '',
        selection: TextSelection.collapsed(offset: isNegative ? 1 : 0),
      );
    }

    num newInt = int.parse(newText);
    if (format.decimalDigits > 0) {
      newInt /= pow(10, format.decimalDigits);
    }
    final newString = (isNegative ? '-' : '') + format.format(newInt).trim();
    return TextEditingValue(
      text: newString,
      selection: TextSelection.collapsed(offset: newString.length),
    );
  }

  static bool _lastCharacterIsDigit(String text) {
    final lastChar = text.substring(text.length - 1);
    return RegExp('[0-9]').hasMatch(lastChar);
  }
}
