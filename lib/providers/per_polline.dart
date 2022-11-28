import 'dart:convert';
import 'dart:io';

import 'package:demo_1/providers/polline.dart';
import 'package:http/http.dart' as http;

class PerPolline {
  late num pARTSEQ;
  late num pARTLEVEL;
  late num pARTID;
  late String pARTNAMEL;
  late String pARTPARENTNAMEL;
  late num rEMACONCENTRATION;
  late String rEMADATE;
  late num sTATID;
  late String sTATCODE;
  late String sTATNAMEI;
  late String sTATNAMED;

  PerPolline(
      {required this.pARTSEQ,
      required this.pARTLEVEL,
      required this.pARTID,
      required this.pARTNAMEL,
      required this.pARTPARENTNAMEL,
      required this.rEMACONCENTRATION,
      required this.rEMADATE,
      required this.sTATID,
      required this.sTATCODE,
      required this.sTATNAMEI,
      required this.sTATNAMED});

  PerPolline.fromJson(Map<String, dynamic> json) {
    pARTSEQ = json['PART_SEQ'];
    pARTLEVEL = json['PART_LEVEL'];
    pARTID = json['PART_ID'];
    pARTNAMEL = json['PART_NAME_L'];
    pARTPARENTNAMEL = json['PART_PARENT_NAME_L'];
    rEMACONCENTRATION = json['REMA_CONCENTRATION'] ?? 0;
    rEMADATE = json['REMA_DATE'];
    sTATID = json['STAT_ID'];
    sTATCODE = json['STAT_CODE'];
    sTATNAMEI = json['STAT_NAME_I'];
    sTATNAMED = json['STAT_NAME_D'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['PART_SEQ'] = pARTSEQ;
    data['PART_LEVEL'] = pARTLEVEL;
    data['PART_ID'] = pARTID;
    data['PART_NAME_L'] = pARTNAMEL;
    data['PART_PARENT_NAME_L'] = pARTPARENTNAMEL;
    data['REMA_CONCENTRATION'] = rEMACONCENTRATION;
    data['REMA_DATE'] = rEMADATE;
    data['STAT_ID'] = sTATID;
    data['STAT_CODE'] = sTATCODE;
    data['STAT_NAME_I'] = sTATNAMEI;
    data['STAT_NAME_D'] = sTATNAMED;
    return data;
  }

  static Future<Map<DateTime, num>> fetch(Stazione s, Polline p) async {
    var urlPolline =
        'http://dati.retecivica.bz.it/services/POLLNET_REMARKS?format=json&PART_ID=${p.partId}&STAT_ID=${s.statId}';
    final response = await http.get(Uri.parse(urlPolline));

    if (response.statusCode == 200) {
      Iterable p = jsonDecode(response.body);
      List<PerPolline> poll =
          List<PerPolline>.from(p.map((model) => PerPolline.fromJson(model)));

      return {
        for (PerPolline p in poll)
          DateTime.parse(p.rEMADATE): p.rEMACONCENTRATION
      };
    } else {
      throw Exception('Failed to load PerPolline');
    }
  }
}

void main(List<String> args) async {
  List<Stazione> staz = await Stazione.fetch();
  List<Polline> poll = await Polline.fetch();
  var out = File('per_polline.txt').openWrite();

  for (Stazione s in staz) {
    out.write("${s.statenameI}  ");
    Map<Polline, Tendenza> tend = await tendenza(s, poll);

    print(tend.length);
    for (Polline p in tend.keys) {
      Stopwatch stopwatch = Stopwatch()..start();

      Map<DateTime, num> per = await PerPolline.fetch(s, p);
      out.write(p.partNameI);
      out.write(": $per ");
      print('doSomething() executed in ${stopwatch.elapsed}');
    }
    out.write("\n");
  }
  out.close();
}
