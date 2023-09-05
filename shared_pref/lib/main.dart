import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: SharedPrefExample(),
    );
  }
}

class SharedPrefExample extends StatefulWidget {
  @override
  _SharedPrefExampleState createState() => _SharedPrefExampleState();
}

class _SharedPrefExampleState extends State<SharedPrefExample> {
  late SharedPreferences _prefs;
  static const String kNumberPrefKey = 'number_pref';
  static const String kBoolPrefKey = 'bool_pref';
  int _numberPref = 0;
  bool _boolPref = false;

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((prefs) {
      setState(() => this._prefs = prefs);
      _loadNumberPref();
      _loadBoolPref();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shared Preference'),
      ),
      body: Column(
        children: <Widget>[
          Table(
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: <TableRow>[
              TableRow(children: <Widget>[
                const Text('Number Preference'),
                Text('${this._numberPref}'),
                ElevatedButton(
                  child: const Text('Increment'),
                  onPressed: () => this._setNumberPref(this._numberPref + 1),
                ),
              ]),
              TableRow(children: <Widget>[
                const Text('Boolean Preference'),
                Text('${this._boolPref}'),
                ElevatedButton(
                  child: const Text('Toogle'),
                  onPressed: () => this._setBoolPref(!this._boolPref),
                ),
              ]),
            ],
          ),
          ElevatedButton(
            child: const Text('Reset Data'),
            onPressed: () => this._resetDataPref(),
          ),
        ],
      ),
    );
  }

  // methods for setting data

  Future<Null> _setNumberPref(int value) async {
    await this._prefs.setInt(kNumberPrefKey, value);
    _loadNumberPref();
  }

  Future<Null> _setBoolPref(bool value) async {
    await this._prefs.setBool(kBoolPrefKey, value);
    _loadBoolPref();
  }

  // methods for reading data from shared preference

  void _loadNumberPref() {
    setState(() {
      this._numberPref = this._prefs.getInt(kNumberPrefKey) ?? 0;
    });
  }

  void _loadBoolPref() {
    setState(() {
      this._boolPref = this._prefs.getBool(kBoolPrefKey) ?? false;
    });
  }

  // method for clearing data from shared preference storage
  Future<Null> _resetDataPref() async {
    await this._prefs.remove(kNumberPrefKey);
    await this._prefs.remove(kBoolPrefKey);
    _loadNumberPref();
    _loadBoolPref();
  }
}
