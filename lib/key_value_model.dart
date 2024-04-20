class KeyValueModel {
  final String key;
  final String value;

  KeyValueModel({
    required this.key,
    required this.value,
  });

  Map<String, Object?> toMap(   ) {
    return {
      "key": key,
      "value": value,
    };
  }
}
