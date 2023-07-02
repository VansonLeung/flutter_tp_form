import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../apis/models/Country.dart';
import 'GenericDecorationBackground.dart';
import 'GenericScaffold.dart';
import 'GenericSelectionCellHorizontal.dart';

class GenericCountryPickerPage extends StatefulWidget {
  final String? title;
  final String countryCode;
  final Function(String?)? onSelectCountryCode;
  final bool isDismissAfterSelect;

  const GenericCountryPickerPage({super.key, this.title, required this.countryCode, this.onSelectCountryCode, this.isDismissAfterSelect = false});

  @override
  _GenericCountryPickerPageState createState() => _GenericCountryPickerPageState();
}

class _GenericCountryPickerPageState extends State<GenericCountryPickerPage> with SingleTickerProviderStateMixin {

  List<Country> countryList = Country.countryList ?? [];
  List<Country> countryListFiltered = [];
  Map<String, Country> countryDict = Country.countryDictByCountryCode ?? {};
  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener = ItemPositionsListener.create();

  bool isLoading = true;
  late String runtimeCountryCode;
  var searchKeywords = "";
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    runtimeCountryCode = widget.countryCode;
    refresh();
  }


  void refresh() async {
    var isNew = await Country.loadCountryList();
    if (isNew) {
      setState(() {
        countryList = Country.countryList ?? [];
        countryDict = Country.countryDictByCountryCode ?? {};
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
    var it = countryDict[runtimeCountryCode];
    if (it != null) {
      var index = countryList.indexOf(it);
      return index;
    }
    return -1;
  }




  @override
  Widget build(BuildContext context) {

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return GenericScaffold(
        titleString: widget.title ?? "",
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
                                if (country.abbr == widget.countryCode) {
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
                                            widget.onSelectCountryCode!(
                                                countryListFiltered[index].abbr);
                                            setState(() {
                                              runtimeCountryCode =
                                                  countryListFiltered[index]
                                                      .abbr ?? "";
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
                    ),






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



