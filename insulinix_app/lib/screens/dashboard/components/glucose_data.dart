import 'dart:math';

class GlucoseDataService {
  static double calculateInsulinDose({
    required double currentGlucose,
    required double targetGlucose,
    required double correctionFactor,
    required double carbsEaten,
    required double carbRatio,
  }) {
    double correctionUnits = (currentGlucose - targetGlucose) / correctionFactor;
    double mealUnits = carbsEaten / carbRatio;
    return (correctionUnits + mealUnits).clamp(0, 25);
  }

  static List<Map<String, dynamic>> generateCGMData() {
    List<Map<String, dynamic>> data = [];
    DateTime now = DateTime.now();
    double glucose = 110;
    final random = Random();

    for (int i = 0; i < 576; i++) {
      glucose += random.nextDouble() * 6 - 3;
      glucose = glucose.clamp(70, 200);
      data.add({
        'time': now.subtract(Duration(minutes: 5 * (576 - i))),
        'glucose': glucose,
      });
    }

    return data;
  }
}
