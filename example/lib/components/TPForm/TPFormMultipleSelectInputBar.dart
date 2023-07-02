import 'dart:developer';

import 'package:flutter/material.dart';

import '../../apis/models/UIModels.dart';
import '../../fragments/generic/GenericMultiplePickerPage.dart';
import 'TPFormElementContainer.dart';


class TPMultipleSelectInputBar extends StatefulWidget {
  final String? title;
  final String? hintText;
  final FocusNode? focusNode;
  final bool? autofocus;
  final ValueNotifier<List<String>> valueNotifier;
  final List<UIListItemModel> choices;
  final bool? grouped;
  final bool? firstInGroup;
  final bool? lastInGroup;
  final bool? isSupportClearText;
  final bool? isForceSingleSelect;
  final String? errorText;

  const TPMultipleSelectInputBar({Key? key, this.title, this.hintText,
    this.focusNode, this.autofocus,
    required this.valueNotifier, required this.choices,
    this.grouped, this.firstInGroup, this.lastInGroup, this.isSupportClearText,
    this.errorText, this.isForceSingleSelect, }) : super(key: key);
  @override
  _TPMultipleSelectInputBarState createState() => _TPMultipleSelectInputBarState();
}

class _TPMultipleSelectInputBarState extends State<TPMultipleSelectInputBar> with SingleTickerProviderStateMixin {

  String runtimeText = "";
  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    focusNode = widget.focusNode ?? FocusNode();
    focusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return TPFormElementContainer(
      isInnerColumn: true,
      isFocused: focusNode?.hasFocus == true,
      grouped: widget.grouped,
      firstInGroup: widget.firstInGroup,
      lastInGroup: widget.lastInGroup,
      children: [
        TextButton(
        autofocus: widget.autofocus == true,
          focusNode: focusNode,
          onPressed: () {

            FocusScope.of(context).unfocus();
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => GenericMultiplePickerPage(
                    title: widget.title ?? "",
                    values: widget.valueNotifier.value,
                    choices: widget.choices,
                    isForceSingleSelect: widget.isForceSingleSelect ?? false,
                    onSelectValue: (String? val, List<UIListItemModel> valuesList) {
                      widget.valueNotifier.value = valuesList.map((e) => e.value).toList();
                    },
                  )),
            );

          },

          child:
              Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child:
                        Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child:
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (widget.hintText != null)
                            Text(
                              widget.hintText ?? "",
                              textAlign: TextAlign.end,
                            ),
                          // ),
                          // ),
                          ValueListenableBuilder(
                              valueListenable: widget.valueNotifier,
                              builder: (_, value, __) {

                                List<UIListItemModel> items = [];
                                for (var k in widget.choices) {
                                  if (widget.valueNotifier.value.contains(k.value)) {
                                    items.add(k);
                                  }
                                }

                                return Text("${items.map((e) => e.label).toList().join(", ")}",
                                    style: const TextStyle(
                                        fontSize: 18,
                                      ));

                              }
                          ),

                        ],
                    ),
                    ),
                    ),

                    Icon(Icons.arrow_drop_down, color: Color(0xFF0000dd)),

                  ]
              ),

          ),
      ],
    );
  }
}




