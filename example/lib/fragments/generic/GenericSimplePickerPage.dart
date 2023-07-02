import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../apis/models/Country.dart';
import '../../apis/models/UIModels.dart';
import 'GenericDecorationBackground.dart';
import 'GenericScaffold.dart';
import 'GenericSelectionCellHorizontal.dart';

class GenericSimplePickerPage extends StatefulWidget {
  final String title;
  final String value;
  final List<UIListItemModel> choices;
  final Function(String?)? onSelectValue;
  final bool isDismissAfterSelect;

  const GenericSimplePickerPage({super.key, required this.title, required this.value, required this.choices,
    required this.onSelectValue, this.isDismissAfterSelect = false});

  @override
  _GenericSimplePickerPageState createState() => _GenericSimplePickerPageState();
}

class _GenericSimplePickerPageState extends State<GenericSimplePickerPage> with SingleTickerProviderStateMixin {

  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener = ItemPositionsListener.create();

  bool isLoading = true;
  UIListItemModel? runtimeValue;

  @override
  void initState() {
    super.initState();
    for (var k in widget.choices) {
      if (k.value == widget.value) {
        runtimeValue = k;
        break;
      }
    }
    refresh();
  }


  void refresh() async {
    Future.delayed(Duration(milliseconds: 250), () {
      int si = getSelectedIndex();
      if (si! > -1) {
        itemScrollController.jumpTo(index: si, alignment: 0);
      }
      setState(() {
        isLoading = false;
      });
    });
  }


  int getSelectedIndex() {
    if (runtimeValue != null) {
      int v = widget.choices.indexOf(runtimeValue!);
      return v;
    }
    return -1;
  }




  @override
  Widget build(BuildContext context) {

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final selectedIndex = getSelectedIndex();

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
                              color: selectedIndex == index ? Color(0xaa000000) : null,
                              child: GenericSelectionCellHorizontal(
                                index: index,
                                title: widget.choices[index].label,
                                onPressed: () {
                                  widget.onSelectValue!(widget.choices[index].value);

                                  setState(() {
                                    runtimeValue = widget.choices[index];
                                  });

                                  if (widget.isDismissAfterSelect) {
                                    Navigator.of(context).pop();
                                  }
                                },
                                isSelected: selectedIndex == index,
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



