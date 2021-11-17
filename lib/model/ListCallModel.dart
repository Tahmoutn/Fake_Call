
class ListCallModel {
  int id;
  String _name;
  String _number;
  String _time;

  ListCallModel(this._name,this._number,this._time);

  String get name => _name;
  String get number => _number;
  String get time => _time;

  ListCallModel.map(dynamic ob){
    this._name = ob['name'];
    this._number = ob['number'];
    this._time = ob['time'];
  }

  Map<String , dynamic> toMap(){
    var map = Map<String , dynamic>();
    map['name'] = _name;
    map['number'] = _number;
    map['time'] = _time;

    return map;
  }

  void setCallId(int id){
    this.id = id;
  }

}