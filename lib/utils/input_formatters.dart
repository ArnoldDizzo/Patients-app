import 'package:flutter/services.dart';

class InputFormatters {
  static TextInputFormatter bloodPressureFormatter() {
    return TextInputFormatter.withFunction((oldValue, newValue) {
      // Allow empty value
      if (newValue.text.isEmpty) {
        return newValue;
      }

      // Only allow numbers and forward slash
      if (!RegExp(r'^[0-9/]*$').hasMatch(newValue.text)) {
        return oldValue;
      }

      // Ensure only one forward slash
      if (newValue.text.split('/').length > 2) {
        return oldValue;
      }

      // Format as user types
      final parts = newValue.text.split('/');
      if (parts.length == 2) {
        // Limit systolic to 3 digits
        if (parts[0].length > 3) {
          return oldValue;
        }
        // Limit diastolic to 3 digits
        if (parts[1].length > 3) {
          return oldValue;
        }
      } else if (parts[0].length > 3) {
        return oldValue;
      }

      return newValue;
    });
  }

  static TextInputFormatter numberFormatter({
    int? maxLength,
    int? maxValue,
    int? minValue,
  }) {
    return TextInputFormatter.withFunction((oldValue, newValue) {
      // Allow empty value
      if (newValue.text.isEmpty) {
        return newValue;
      }

      // Only allow numbers
      if (!RegExp(r'^[0-9]*$').hasMatch(newValue.text)) {
        return oldValue;
      }

      // Check max length
      if (maxLength != null && newValue.text.length > maxLength) {
        return oldValue;
      }

      // Check min/max value
      if (maxValue != null || minValue != null) {
        try {
          final number = int.parse(newValue.text);
          if (maxValue != null && number > maxValue) {
            return oldValue;
          }
          if (minValue != null && number < minValue) {
            return oldValue;
          }
        } catch (e) {
          return oldValue;
        }
      }

      return newValue;
    });
  }

  static TextInputFormatter decimalFormatter({
    int? maxLength,
    double? maxValue,
    double? minValue,
    int decimalPlaces = 1,
  }) {
    return TextInputFormatter.withFunction((oldValue, newValue) {
      // Allow empty value
      if (newValue.text.isEmpty) {
        return newValue;
      }

      // Only allow numbers and one decimal point
      if (!RegExp(r'^[0-9]*\.?[0-9]*$').hasMatch(newValue.text)) {
        return oldValue;
      }

      // Check decimal places
      final parts = newValue.text.split('.');
      if (parts.length > 2) {
        return oldValue;
      }
      if (parts.length == 2 && parts[1].length > decimalPlaces) {
        return oldValue;
      }

      // Check max length
      if (maxLength != null && newValue.text.length > maxLength) {
        return oldValue;
      }

      // Check min/max value
      if (maxValue != null || minValue != null) {
        try {
          final number = double.parse(newValue.text);
          if (maxValue != null && number > maxValue) {
            return oldValue;
          }
          if (minValue != null && number < minValue) {
            return oldValue;
          }
        } catch (e) {
          return oldValue;
        }
      }

      return newValue;
    });
  }
} 