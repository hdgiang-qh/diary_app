
import 'bloc_status.dart';

class CubitState<T> {
  BlocStatus status;
  T? data;
  int? count;
  String msg;
  bool hasMore;
  bool maxLength;

  CubitState({
    this.status = BlocStatus.inital,
    this.msg = "Lỗi dữ liệu",
    this.maxLength = false,
    this.hasMore = false,
    this.data,
    this.count,
  });

  CubitState copyWith({
    BlocStatus? status,
    String? msg,
    bool? hasMore,
    bool? maxLength,
    T? data,
    int? count,
  }) {
    return CubitState(
        status: status ?? this.status,
        msg: msg ?? this.msg,
        hasMore: hasMore ?? this.hasMore,
        maxLength: maxLength ?? this.maxLength,
        data: data ?? this.data,
        count: count ?? this.count);
  }
}
