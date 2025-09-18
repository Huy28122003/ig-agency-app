import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

class LogRecentLoginEntity extends Equatable {
  const LogRecentLoginEntity({this.address, this.date});

  final String? address;
  final DateTime? date;

  LogRecentLoginEntity copyWith({ValueGetter<String?>? address, ValueGetter<DateTime?>? date}) {
    return LogRecentLoginEntity(
      address: address != null ? address() : this.address,
      date: date != null ? date() : this.date,
    );
  }

  @override
  List<Object?> get props => [address, date];
}
