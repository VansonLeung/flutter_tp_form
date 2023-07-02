import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../apis/models/Country.dart';
import '../../apis/models/UIModels.dart';
import 'GenericDecorationBackground.dart';
import 'GenericScaffold.dart';
import 'GenericSelectionCellHorizontal.dart';

class GenericMultiplePickerPage extends StatefulWidget {
  final String title;
  final List<String> values;
  final List<UIListItemModel> choices;
  final Function(String?, List<UIListItemModel>)? onSelectValue;
  final bool isDismissAfterSelect;
  final bool isForceSingleSelect;

  const GenericMultiplePickerPage({super.key, required this.title, required this.values, required this.choices,
    required this.onSelectValue, this.isDismissAfterSelect = false, required this.isForceSingleSelect});

  @override
  _GenericMultiplePickerPageState createState() => _GenericMultiplePickerPageState();
}

class _GenericMultiplePickerPageState extends State<GenericMultiplePickerPage> with SingleTickerProviderStateMixin {

  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener = ItemPositionsListener.create();

  bool isLoading = true;
  List<UIListItemModel> runtimeValue = [];

  @override
  void initState() {
    super.initState();
    runtimeValue.clear();
    for (var k in widget.choices) {
      if (widget.values.contains(k.value)) {
        runtimeValue.add(k);
      }
    }
    refresh();
  }


  void refresh() async {
    Future.delayed(Duration(milliseconds: 250), () {
      setState(() {
        isLoading = false;
      });
    });
  }


  bool isSelected(int index) {
    if (runtimeValue != null) {
      if (runtimeValue.contains(widget.choices[index])) {
        return true;
      }
    }
    return false;
  }




  @override
  Widget build(BuildContext context) {

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return GenericScaffold(
        titleString: widget.title,
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
                    child: ScrollablePositionedList.builder(
                      itemCount: widget.choices.length,
                      itemBuilder: (context, index) => Column(
                        children: [
                          if (index > 0)
                            const Divider(
                              height: 4,
                              color: Color(0xFFFFFFFF),
                            ),

                          Container(
                              color: isSelected(index) ? Color(0xaa000000) : null,
                              child: GenericSelectionCellHorizontal(
                                index: index,
                                title: widget.choices[index].label,
                                onPressed: () {
                                  setState(() {
                                    if (widget.isForceSingleSelect) {
                                      runtimeValue.clear();
                                      runtimeValue.add(widget.choices[index]);
                                    } else {
                                      if (runtimeValue.contains(widget.choices[index])) {
                                        runtimeValue.removeAt(runtimeValue.indexOf(widget.choices[index]));
                                      } else {
                                        runtimeValue.add(widget.choices[index]);
                                      }
                                    }
                                    widget.onSelectValue!(widget.choices[index].value, runtimeValue);
                                  });

                                  if (widget.isDismissAfterSelect) {
                                    Navigator.of(context).pop();
                                  }
                                },
                                isSelected: isSelected(index),
                              )
                          ),
                        ],
                      ),
                      itemScrollController: itemScrollController,
                      itemPositionsListener: itemPositionsListener,
                    ),
                  ),
                ),

                if (isLoading)
                  const Center( child:
                    CircularProgressIndicator(color: Color(0xFFFFFFFF)),
                  ),

              ]
            ),

        )
    );
  }

}



