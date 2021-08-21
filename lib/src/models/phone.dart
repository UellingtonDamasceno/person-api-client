class Phone {
  int _id;
  String _type;
  String _number;

  Phone.comercial(this._number)
      : _id = 0,
        _type = "COMERCIAL";

  Phone.mobile(this._number)
      : _id = 0,
        _type = "MOBILE";
  Phone(this._id, this._type, this._number);

  int get id => this._id;
  String get type => this._type;
  String get number => this._number;
}
