import 'dart:convert';

void main() {
  String jsonStr = '''
  [{
    "id": 0, "title": "Ungrouped", "items": [{
      "id": 8, "alarm": 0, "name": "from main1", "online": "offline", "time": "2026-05-16 06:36:17 AM", "timestamp": 1778902714, "acktimestamp": 1767576219, "lat": 13.466625, "lng": 44.162568, "course": 252, "speed": 0, "altitude": 1261, "icon_type": "arrow", "icon_color": "red"
    }]
  }]
  ''';
  
  var decoded = jsonDecode(jsonStr);
  var rawJson = decoded[0]['items'][0];
  
  final json = rawJson.containsKey('device_data') 
      ? rawJson['device_data'] as Map<String, dynamic> 
      : rawJson;

  print("lat from map: ${json['lat']}");
  var latDouble = double.tryParse(json['lat']?.toString() ?? '0') ?? 0.0;
  print("parsed lat: $latDouble");
}
