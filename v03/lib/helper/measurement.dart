class Measurement {
  final double value;
  final MeasurementUnit unit;

  const Measurement({required this.value, required this.unit});

  // Konverteringsmetoder
  double get inMetric {
    switch (unit) {
      case MeasurementUnit.centimeters:
      case MeasurementUnit.kilograms:
        return value;
      case MeasurementUnit.feet:
        return value * 30.48; // feet to cm
      case MeasurementUnit.inches:
        return value * 2.54; // inches to cm
      case MeasurementUnit.pounds:
        return value * 0.453592; // lbs to kg
    }
  }

  double get inImperial {
    switch (unit) {
      case MeasurementUnit.feet:
      case MeasurementUnit.inches:
      case MeasurementUnit.pounds:
        return value;
      case MeasurementUnit.centimeters:
        return value / 30.48; // cm to feet
      case MeasurementUnit.kilograms:
        return value / 0.453592; // kg to lbs
    }
  }

  String get metricDisplay {
    if (unit == MeasurementUnit.centimeters ||
        unit == MeasurementUnit.kilograms) {
      return '$value ${unit == MeasurementUnit.centimeters ? 'cm' : 'kg'}';
    }
    return '${inMetric.toStringAsFixed(0)} ${unit == MeasurementUnit.feet || unit == MeasurementUnit.inches ? 'cm' : 'kg'}';
  }

  String get imperialDisplay {
    if (unit == MeasurementUnit.feet) {
      final feet = value.floor();
      final inches = ((value - feet) * 12).round();
      return "$feet'$inches\"";
    }
    if (unit == MeasurementUnit.pounds) {
      return '${value.toStringAsFixed(0)} lb';
    }
    // Konvertera från metric
    if (unit == MeasurementUnit.centimeters) {
      final totalInches = inImperial * 12;
      final feet = (totalInches / 12).floor();
      final inches = (totalInches % 12).round();
      return "$feet'$inches\"";
    }
    return '${inImperial.toStringAsFixed(0)} lb';
  }

  factory Measurement.fromList(List<dynamic> list, MeasurementType type) {
    if (list.isEmpty) {
      return Measurement(
        value: 0,
        unit: type == MeasurementType.height
            ? MeasurementUnit.centimeters
            : MeasurementUnit.kilograms,
      );
    }

    final firstValue = list[0] as String;

    // Try find metric value first
    for (var item in list) {
      final str = item as String;
      if (str.contains('cm')) {
        return Measurement(
          value: double.parse(str.replaceAll(RegExp(r'[^0-9.]'), '')),
          unit: MeasurementUnit.centimeters,
        );
      }
      if (str.contains('kg')) {
        return Measurement(
          value: double.parse(str.replaceAll(RegExp(r'[^0-9.]'), '')),
          unit: MeasurementUnit.kilograms,
        );
      }
    }

    // Else parse imperial
    if (firstValue.contains("'")) {
      // Format: "6'2"
      final parts = firstValue.split("'");
      final feet = int.parse(parts[0]);
      final inches = parts.length > 1
          ? int.parse(parts[1].replaceAll('"', '').trim())
          : 0;
      return Measurement(
        value: feet + (inches / 12),
        unit: MeasurementUnit.feet,
      );
    }

    if (firstValue.contains('lb')) {
      return Measurement(
        value: double.parse(firstValue.replaceAll(RegExp(r'[^0-9.]'), '')),
        unit: MeasurementUnit.pounds,
      );
    }

    // Fallback
    return Measurement(
      value:
          double.tryParse(firstValue.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0,
      unit: type == MeasurementType.height
          ? MeasurementUnit.centimeters
          : MeasurementUnit.kilograms,
    );
  }

  // Saving
  List<String> toList() {
    return [unit == MeasurementUnit.feet ? imperialDisplay : metricDisplay];
  }

  @override
  String toString() => '$metricDisplay ($imperialDisplay)';
}

enum MeasurementUnit { centimeters, feet, inches, kilograms, pounds }

enum MeasurementType { height, weight }
