enum MuteDurationOption {
  m15("15m"),
  h1("1h"),
  h8("8h"),
  h24("24h"),
  life("until_opened");

  final String code;

  const MuteDurationOption(this.code);

  String get title {
    switch (this) {
      case MuteDurationOption.m15:
        return "unmute_time_15";
      case MuteDurationOption.h1:
        return "unmute_time_1";
      case MuteDurationOption.h8:
        return "unmute_time_8";
      case MuteDurationOption.h24:
        return "unmute_time_24";
      case MuteDurationOption.life:
        return "unmute_time_life";
    }
  }
}
