enum UnMuteTimeEnum {
  m15("unmute_time_15"),
  h1("unmute_time_1"),
  h8("unmute_time_8"),
  h24("unmute_time_24"),
  life("unmute_time_life");

  final String title;

  const UnMuteTimeEnum(this.title);

  String get code{
    switch(this){
      case UnMuteTimeEnum.m15:
        return "15m";
      case UnMuteTimeEnum.h1:
        return "1h";
      case UnMuteTimeEnum.h8:
        return "8h";
      case UnMuteTimeEnum.h24:
        return "24h";
      case UnMuteTimeEnum.life:
        return "until_opened";
    }
  }

}
