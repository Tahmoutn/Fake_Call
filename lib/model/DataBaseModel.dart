
class DataBaseModel {
  int _id;
  String _name;
  String _number;
  String _time;

  DataBaseModel(this._id,this._name,this._number,this._time);

  int get id => _id;
  String get name => _name;
  String get number => _number;
  String get time => _time;

  DataBaseModel.map(dynamic ob){
    this._id = ob['id'];
    this._name = ob['name'];
    this._number = ob['number'];
    this._time = ob['time'];
  }

  Map<String , dynamic> toMap(){
    var map = Map<String , dynamic>();
    map['id'] = _id;
    map['contact_name'] = _name;
    map['phone_number'] = _number;
    map['time'] = _time;

    return map;
  }

  void setCallId(int id){
    this._id = id;
  }

}