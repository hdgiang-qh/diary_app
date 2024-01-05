class ChartMonthModel {
  final String month;
  final List<List<dynamic>> data;

  ChartMonthModel(this.month, this.data);

  factory ChartMonthModel.fromJson(Map<String, dynamic> json) {
    return ChartMonthModel(
      json['month'],
      (json['data'] as List).cast<List<dynamic>>(),
    );
  }
}