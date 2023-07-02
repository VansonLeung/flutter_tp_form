import 'dart:async';

import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../apis/models/Country.dart';
import 'GenericDecorationBackground.dart';
import 'GenericScaffold.dart';
import 'GenericSelectionCellHorizontal.dart';

class GenericPhoneCodePickerPage extends StatefulWidget {
  final String phoneCode;
  final Function(String?)? onSelectPhoneCode;
  final bool isDismissAfterSelect;

  const GenericPhoneCodePickerPage({super.key, required this.phoneCode, this.onSelectPhoneCode, this.isDismissAfterSelect = false});

  @override
  _GenericPhoneCodePickerPageState createState() => _GenericPhoneCodePickerPageState();
}

class _GenericPhoneCodePickerPageState extends State<GenericPhoneCodePickerPage> with SingleTickerProviderStateMixin {

  List<Country> countryList = Country.countryList ?? [];
  List<Country> countryListFiltered = [];
  Map<String, Country> countryDict = Country.countryDictByPhoneCode ?? {};
  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener = ItemPositionsListener.create();

  bool isLoading = true;
  late String runtimePhoneCode;
  var searchKeywords = "";
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    runtimePhoneCode = widget.phoneCode;
    refresh();
  }


  void refresh() async {
    var isNew = await Country.loadCountryList();
    if (isNew) {
      setState(() {
        countryList = Country.countryList ?? [];
        countryDict = Country.countryDictByPhoneCode ?? {};
      });
    }

    refreshFilter(duration: 0);

    Future.delayed(Duration(milliseconds: 250), () {
      if (context.mounted) {
        int si = getSelectedIndex();
        if (si > -1) {
          itemScrollController.jumpTo(index: si, alignment: 0);
        }
        setState(() {
          isLoading = false;
        });
      }
    });
  }



  void refreshFilter({int duration = 500}) {
    if (_timer != null) {
      _timer?.cancel();
      _timer = null;
    }

    _timer = Timer(Duration(milliseconds: duration), () {
      _timer?.cancel();
      _timer = null;
      setState(() {

        if (context.mounted) {
          countryListFiltered = countryList.where((element) {
            if (searchKeywords.trim() == "") {
              return true;
            }

            return (element.getAbbr() ?? "").toLowerCase().contains(searchKeywords.toLowerCase())
                || (element.getCode() ?? "").toLowerCase().contains(searchKeywords.toLowerCase())
                || (element.chinese ?? "").toLowerCase().contains(searchKeywords.toLowerCase())
                || (element.english ?? "").toLowerCase().contains(searchKeywords.toLowerCase());

          }).toList();

        }

      });
    });

  }



  int getSelectedIndex() {
    var it = countryDict[runtimePhoneCode];
    if (it != null) {
      var index = countryListFiltered.indexOf(it);
      return index;
    }
    return -1;
  }



  @override
  Widget build(BuildContext context) {

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return GenericScaffold(
        titleString: "select_country_code",
        body: Container(
            width: screenWidth,
            height: screenHeight,
            decoration: GenericDecorationBackground.Dark,
            child: Stack(
              children: [
                AnimatedOpacity(
                  opacity: isLoading ? 0 : 1,
                  duration: const Duration(milliseconds: 500),
                  child: Container(
                    padding: EdgeInsets.zero,
                    child: Column(
                      children: [

                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: Row(
                              children: [
                                Icon(Icons.search, color: Color(0xFFFFFFFF)),
                                Expanded(child:
                                TextField(
                                  style: TextStyle(color: Color(0xFFFFFFFF)),
                                  onChanged: (val) {
                                    searchKeywords = val;
                                    refreshFilter();
                                  },
                                ),

                                ),
                              ]
                          )
                        ),


                        Expanded(
                          child: ScrollablePositionedList.builder(
                            itemCount: countryListFiltered.length,
                            itemScrollController: itemScrollController,
                            itemPositionsListener: itemPositionsListener,
                            itemBuilder: (context, index) {

                              bool isSelected = false;

                              Country country = countryListFiltered[index];
                              if (country.code == widget.phoneCode) {
                                isSelected = true;
                              }

                              return Column(
                                children: [
                                  if (index > 0)
                                    const Divider(
                                      height: 4,
                                      color: Color(0xFFFFFFFF),
                                    ),

                                  Container(
                                      color: isSelected
                                          ? Color(0xaa000000)
                                          : null,
                                      child: GenericSelectionCellHorizontal(
                                        index: index,
                                        title: index > -1
                                            ? countryListFiltered[index]
                                            .getNameRepresentation(context)
                                            : "",
                                        onPressed: () {
                                          widget.onSelectPhoneCode!(
                                              countryListFiltered[index].code);
                                          setState(() {
                                            runtimePhoneCode =
                                                countryListFiltered[index]
                                                    .code ?? "";
                                          });

                                          if (widget.isDismissAfterSelect) {
                                            print("XXXX");
                                            Navigator.of(context).pop();
                                          }
                                        },
                                        isSelected: isSelected,
                                      )
                                  ),
                                ],
                              );
                            },
                          ),
                        ),


                      ]
                    )

                  ),
                ),

                if (isLoading)
                  Center( child:
                    CircularProgressIndicator(color: Color(0xFFFFFFFF)),
                  ),

              ]
            ),

        )
    );
  }

}



