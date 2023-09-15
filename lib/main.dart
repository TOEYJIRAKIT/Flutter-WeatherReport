import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';
import 'dart:io';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: WeatherReportHomePage(),
    );
  }
}

class WeatherReportHomePage extends StatefulWidget {
  const WeatherReportHomePage({super.key});

  @override
  State<WeatherReportHomePage> createState() => _WeatherReportHomePageState();
}

class _WeatherReportHomePageState extends State<WeatherReportHomePage> {
  String latestDate = "";
  String latitude = "";
  String longitude = "";
  String maximumTemperature = "";
  String minimumTemperature = "";
  String averageHumidity = "";
  String dailyTotalRainfall = "";
  String maximumWindSpeed = "";
  String generalWeatherCondition = "";

  @override
  void initState() {
    super.initState();
    weatherDataInfo();
  }

  String getgeneralWeatherCondition(int conditionData) {
    if (conditionData == 1) {
      generalWeatherCondition = "ท้องฟ้าแจ่มใส (Clear)";
    } else if (conditionData == 2) {
      generalWeatherCondition = "มีเมฆบางส่วน (Partly cloudy)";
    } else if (conditionData == 3) {
      generalWeatherCondition = "เมฆเป็นส่วนมาก (Cloudy)";
    } else if (conditionData == 4) {
      generalWeatherCondition = "มีเมฆมาก (Overcast)";
    } else if (conditionData == 5) {
      generalWeatherCondition = "ฝนตกเล็กน้อย (Light rain)";
    } else if (conditionData == 6) {
      generalWeatherCondition = "ฝนปานกลาง (Moderate rain)";
    } else if (conditionData == 7) {
      generalWeatherCondition = "ฝนตกหนัก (Heavy rain)";
    } else if (conditionData == 8) {
      generalWeatherCondition = "ฝนฟ้าคะนอง (Thunderstorm)";
    } else if (conditionData == 9) {
      generalWeatherCondition = "อากาศหนาวจัด (Very cold)";
    } else if (conditionData == 10) {
      generalWeatherCondition = "อากาศหนาว (Cold)";
    } else if (conditionData == 11) {
      generalWeatherCondition = "อากาศเย็น (Cool)";
    } else if (conditionData == 12) {
      generalWeatherCondition = "อากาศร้อนจัด (Very hot)";
    } else {
      generalWeatherCondition = "ระบุไม่ได้";
    }

    return generalWeatherCondition;
  }

  Future <void> weatherDataInfo() async {
    double lat = 7.21;
    double long = 100.59;
    String date = DateFormat("yyyy-MM-dd").format(DateTime.now());
    String fields = "tc_max,tc_min,rh,rain,ws10m,wd10m,cond";
    String apiStr = "/nwpapi/v1/forecast/location/daily/at?";
    apiStr += "lat=$lat&lon=$long&date=$date&fields=$fields";
    var url = Uri.https("data.tmd.go.th", apiStr);
    var response = await http.get(url, headers: {
      HttpHeaders.acceptHeader: 'application/json',
      HttpHeaders.authorizationHeader:
          'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImp0aSI6Ijg3NDNmMTZmMzkzYjczOWRhODg5N2JhNWFkZWE1NzNmZjc2YjUwZGRhMjBmYmZiODM2YjczOTY2ZWNhZTk4M2ZhNDI0OTQ4ODBlOGZhYWVkIn0.eyJhdWQiOiIyIiwianRpIjoiODc0M2YxNmYzOTNiNzM5ZGE4ODk3YmE1YWRlYTU3M2ZmNzZiNTBkZGEyMGZiZmI4MzZiNzM5NjZlY2FlOTgzZmE0MjQ5NDg4MGU4ZmFhZWQiLCJpYXQiOjE2OTEyMzkwNTQsIm5iZiI6MTY5MTIzOTA1NCwiZXhwIjoxNzIyODYxNDU0LCJzdWIiOiIyNjYyIiwic2NvcGVzIjpbXX0.o2OZGjLhMZJBTnTWJSH-KGSWl6wFVGFdxrsdDd387pv_ktoo0QWWjIkvatachoC-9goOWBnHsaK1BdBT-knGBy4GGOwxWZV5SFGgZc54OY9nG1Y-LchA9UKU_JyXEA5L_wBoi0uj6wAdTnQQgCya5IZEuo8t2AOnTvzX0TRq35BeUsJpJNSbeJPhGVQaIMY3J-5u7pSpozTG_kXkvOWuCzZ88FuKi9oR9PNBRoRJ0Wi0tuI50rFZownp80GeavNPV9vjzTc02L7PmkFRkOKnfdkbEdZJ3_bmqp0b9BUCcSwwlk_2bO0Ms75xu8r1wx7cI8bfqS_F2sBU-Aj0NkzyAn9lLkZyiid-pXTyPI8IB_43U8qWfSr5dCavw9KysH0LbMQgDOKnOrDisdwzYgsq53RX381Oh3EyYQ4l1gRFI7KpGf60xnnEmtkip6rsCD3zG9jt5VhApIH6InLQu0R0c3OAh36o5X7fVig89oEJ2ImbNwa6V0jM1sVbWFz4nWjrJIb8itM2ulle_iOo-6xM9d1GHtMnK2qQ21DaZvC3iGwpuTMBIhmsabFShfdycmAcpsoZj0m6R0PzEH93ACJTzALOh5QmnWUHclx48gpKl6XWTUVUQCG6wsTf05_DEPgHgB81oUK-REPDV6gELrcaQW5k5BtbYjHlYWB53kQXuoo'
    });

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);

      double lat = data["WeatherForecasts"][0]["location"]["lat"];
      double lon = data["WeatherForecasts"][0]["location"]["lon"];
      String time = data["WeatherForecasts"][0]["forecasts"][0]["time"];
      double tcMax = data["WeatherForecasts"][0]["forecasts"][0]["data"]["tc_max"];
      double tcMin = data["WeatherForecasts"][0]["forecasts"][0]["data"]["tc_min"];
      double rh = data["WeatherForecasts"][0]["forecasts"][0]["data"]["rh"];
      double rain = data["WeatherForecasts"][0]["forecasts"][0]["data"]["rain"];
      double ws10m = data["WeatherForecasts"][0]["forecasts"][0]["data"]["ws10m"];
      int cond = data["WeatherForecasts"][0]["forecasts"][0]["data"]["cond"];

      setState(() {
        latestDate = DateFormat("dd-MM-yyyy").format(DateTime.parse(time));
        latitude = lat.toStringAsFixed(4);
        longitude = lon.toStringAsFixed(4);
        maximumTemperature = tcMax.toStringAsFixed(2);
        minimumTemperature = tcMin.toStringAsFixed(2);
        averageHumidity = rh.toStringAsFixed(2);
        dailyTotalRainfall = rain.toStringAsFixed(2);
        maximumWindSpeed = ws10m.toStringAsFixed(2);
        generalWeatherCondition = getgeneralWeatherCondition(cond);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Center(child: Text(latestDate)),
        ),
        body: ListView(
          children: [
            Container(
              margin: const EdgeInsets.all(20.0),
              child: Image.network('https://upload.wikimedia.org/wikipedia/commons/thumb/c/c2/Songkhla_mermaid.jpg/1200px-Songkhla_mermaid.jpg',
              fit: BoxFit.cover
              ),
            ),
            ListTile(
              title: const Text('สงขลา',style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('$latitude,$longitude'),
            ),
            ListTile(
              title: const Text('อุณหภูมิสูงสุด',style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('$maximumTemperature C'),
            ),
            ListTile(
              title: const Text('อุณหภูมิต่ำสุด',style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('$minimumTemperature C'),
            ),
            ListTile(
              title: const Text('ความชื้นสัมพันธเฉลี่ย',style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('$averageHumidity %'),
            ),
            ListTile(
              title: const Text('ปริมาณฝนรวม 24 ชม.',style: TextStyle(fontWeight: FontWeight.bold),),
              subtitle: Text('$dailyTotalRainfall mm'),
            ),
            ListTile(
              title: const Text('ความเร็วลมสูงสุด',style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('$maximumWindSpeed m/s'),
            ),
            ListTile(
              title: const Text('สภาพอากาศโดยทั่วไป',style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(generalWeatherCondition),
            ),
          ],
        ),
      ),
    );
  }
}
