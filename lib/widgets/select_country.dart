import 'dart:convert';

import 'package:chat_app/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SelectCountry extends StatefulWidget {
  const SelectCountry({Key? key}) : super(key: key);

  @override
  State<SelectCountry> createState() => _SelectCountryState();
}

class _SelectCountryState extends State<SelectCountry> {
  List data = [];

  @override
  void initState() {
    readJson();
    super.initState();
  }

  Future<void> readJson() async {
    final String response =
        await rootBundle.loadString('assets/CountryCodes.json');
    final dataJson = await json.decode(response);
    setState(() {
      data = dataJson["items"];
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: SizedBox(
        height: size.height * 0.5,
        child: Column(
          children: [
            ListTile(
              title: Center(
                  child: Text(
                'Select Country',
                style:
                    Styles.buttonTextStyle.copyWith(color: Styles.primaryColor),
              )),
            ),
            data.isNotEmpty
                ? Expanded(
                    child: ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            // print(data[index]["name"]);
                            Navigator.pop(context, data[index]);
                          },
                          child: Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: size.width * 0.05,
                                  vertical: size.width * 0.01),
                              padding: EdgeInsets.symmetric(
                                horizontal: size.width * 0.05,
                                vertical: size.width * 0.015,
                              ),
                              decoration: BoxDecoration(
                                  color: Styles.backgroundSecondary,
                                  borderRadius: BorderRadius.circular(15.0),
                                  boxShadow: Styles.softShadows),
                              child: Card(
                                elevation: 0,
                                color: Colors.transparent,
                                // margin: EdgeInsets.all(5),
                                shape: BeveledRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Expanded(
                                        child: Text(
                                      data[index]["code"],
                                      style: Styles.smallTextStyle,
                                    )),
                                    Expanded(
                                        child: Text(
                                      data[index]['name'],
                                      style: Styles.smallTextStyle,
                                    )),
                                    Expanded(
                                        child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          data[index]["dial_code"],
                                          style: Styles.smallTextStyle.copyWith(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    )),
                                  ],
                                ),
                              )),
                        );
                      },
                    ),
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}
