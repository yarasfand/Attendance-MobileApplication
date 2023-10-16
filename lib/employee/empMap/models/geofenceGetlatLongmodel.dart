class getLatLong {
  int? empId;
  String? lat;
  String? lon;
  String? radius;

  getLatLong({this.empId, this.lat, this.lon, this.radius});

  getLatLong.fromJson(Map<String, dynamic> json) {
    empId = json['empId'];
    lat = json['lat'];
    lon = json['lon'];
    radius = json['radius'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['empId'] = this.empId;
    data['lat'] = this.lat;
    data['lon'] = this.lon;
    data['radius'] = this.radius;
    return data;
  }
}