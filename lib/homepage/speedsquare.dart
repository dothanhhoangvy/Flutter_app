import 'package:flutter/material.dart';

class CardValue extends StatelessWidget {
  CardValue({
    super.key,
    required this.iconVar,
    required this.textVar,
    required this.valuVar,
    required this.unitVar,
  });
  final String iconVar;
  final String textVar;
  final String valuVar;
  final String unitVar;
  @override
  Widget build(BuildContext context) {
    return
        // Container(
        //   decoration: BoxDecoration(
        //       // gradient: const LinearGradient(colors: [
        //       //   Color.fromARGB(255, 148, 35, 49),
        //       //   Color.fromARGB(255, 177, 38, 56),
        //       //   Color.fromARGB(255, 175, 25, 23),
        //       //   Color.fromARGB(255, 213, 19, 23),
        //       //   Color.fromARGB(255, 92, 58, 141),
        //       //   Color.fromARGB(255, 46, 56, 128),
        //       //   Color.fromARGB(255, 14, 65, 139),
        //       //   Color.fromARGB(255, 35, 92, 163),
        //       //   Color.fromARGB(255, 44, 124, 180),
        //       //   Color.fromARGB(255, 42, 164, 202),
        //       //   Color.fromARGB(255, 0, 160, 198),
        //       //   Color.fromARGB(255, 0, 154, 99),
        //       //   Color.fromARGB(255, 139, 187, 102),
        //       //   Color.fromARGB(255, 65, 147, 76),
        //       // ])),
        //       ),
        //   child:
        Card(
      color: Colors.white10,
      margin: const EdgeInsets.all(5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          ListTile(
            leading: Image.asset(
              iconVar,
            ),
            title: Text(textVar,
                style: const TextStyle(
                  fontSize: 40,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                )),
          ),
          Text(valuVar,
              style: const TextStyle(
                fontSize: 60,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              )),
          Text(unitVar,
              style: const TextStyle(
                fontSize: 25,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              )),
        ],
      ),
      // ),
    );
  }
}
