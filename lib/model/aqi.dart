
class Aqi {
  final int aqi;
  final String cityname;
  final double pm25;
  final String time;
  final double temperature;

  Aqi(this.aqi, this.cityname, this.pm25, this.time, this.temperature);

  factory Aqi.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    return Aqi(
      data['aqi'] as int,
      data['city']['name'] as String,
      (data['iaqi']['pm25']['v'] as num).toDouble(),
      data['time']['s'] as String,
      (data['iaqi']['t']['v'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'aqi': aqi, 'cityname': cityname, 'pm25': pm25, 'time': time,'temperature': temperature,};
  }
}