class Validators {
  static String? validateBloodPressure(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter blood pressure';
    }
    
    // Check format: 120/80
    final parts = value.split('/');
    if (parts.length != 2) {
      return 'Please use format: 120/80';
    }
    
    try {
      final systolic = int.parse(parts[0]);
      final diastolic = int.parse(parts[1]);
      
      if (systolic < 60 || systolic > 250) {
        return 'Systolic pressure should be between 60-250';
      }
      if (diastolic < 40 || diastolic > 150) {
        return 'Diastolic pressure should be between 40-150';
      }
    } catch (e) {
      return 'Please enter valid numbers';
    }
    
    return null;
  }

  static String? validatePulse(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter pulse rate';
    }
    
    try {
      final pulse = int.parse(value);
      if (pulse < 40 || pulse > 200) {
        return 'Pulse should be between 40-200 bpm';
      }
    } catch (e) {
      return 'Please enter a valid number';
    }
    
    return null;
  }

  static String? validateBloodSugar(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter blood sugar level';
    }
    
    try {
      final sugar = int.parse(value);
      if (sugar < 70 || sugar > 300) {
        return 'Blood sugar should be between 70-300 mg/dL';
      }
    } catch (e) {
      return 'Please enter a valid number';
    }
    
    return null;
  }

  static String? validateWeight(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter weight';
    }
    
    try {
      final weight = double.parse(value);
      if (weight < 20 || weight > 300) {
        return 'Weight should be between 20-300 kg';
      }
    } catch (e) {
      return 'Please enter a valid number';
    }
    
    return null;
  }

  static String? validateCholesterol(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter cholesterol level';
    }
    
    try {
      final cholesterol = int.parse(value);
      if (cholesterol < 100 || cholesterol > 400) {
        return 'Cholesterol should be between 100-400 mg/dL';
      }
    } catch (e) {
      return 'Please enter a valid number';
    }
    
    return null;
  }
} 