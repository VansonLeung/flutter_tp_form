import 'dart:developer';

import 'package:flutter/material.dart';

import '../../apis/models/UIModels.dart';
import '../../fragments/generic/GenericSimplePickerPage.dart';
import 'TPFormElementContainer.dart';


class TPSimpleSelectInputBar extends StatefulWidget {
  final String? title;
  final String? hintText;
  final FocusNode? focusNode;
  final bool? autofocus;
  final ValueNotifier<String> valueNotifier;
  final List<UIListItemModel> choices;
  final bool? grouped;
  final bool? firstInGroup;
  final bool? lastInGroup;
  final bool? isSupportClearText;
  final String? errorText;

  const TPSimpleSelectInputBar({Key? key, this.title, this.hintText,
    this.focusNode, this.autofocus,
    required this.valueNotifier, required this.choices,
    this.grouped, this.firstInGroup, this.lastInGroup, this.isSupportClearText,
    this.errorText, }) : super(key: key);
  @override
  _TPSimpleSelectInputBarState createState() => _TPSimpleSelectInputBarState();
}

class _TPSimpleSelectInputBarState extends State<TPSimpleSelectInputBar> with SingleTickerProviderStateMixin {

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
      isFocused: focusNode?.hasFocus == true,
      grouped: widget.grouped,
      firstInGroup: widget.firstInGroup,
      lastInGroup: widget.lastInGroup,
      children: [

        if (widget.hintText != null)
          Padding(padding: EdgeInsets.symmetric(vertical: 17), child:
          SizedBox(width: 80, child:
          Text(
            widget.hintText ?? "",
            textAlign: TextAlign.end,
          ),
          ),
          ),



        Expanded(child:
        SizedBox(width: double.infinity,
        child:
        TextButton(
          autofocus: widget.autofocus == true,
          focusNode: focusNode,
          onPressed: () {

            FocusScope.of(context).unfocus();
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => GenericSimplePickerPage(
                    title: widget.title ?? "",
                    value: widget.valueNotifier.value,
                    choices: widget.choices,
                    onSelectValue: (String? val) {
                      widget.valueNotifier.value = val ?? "";
                    },
                    isDismissAfterSelect: true,
                  )),
            );

          },
          child: ValueListenableBuilder(
              valueListenable: widget.valueNotifier,
              builder: (_, value, __) {

                UIListItemModel? item;
                for (var k in widget.choices) {
                  if (k.value == widget.valueNotifier.value) {
                    item = k;
                    break;
                  }
                }

                log("${item?.label ?? ""}");

                return Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("${item?.label ?? ""}", style: TextStyle(
                        fontSize: 18,
                      )),
                      Icon(Icons.arrow_drop_down),
                    ]
                );
              }
          ),
        ),
        ),

        ),

      ],
    );
  }
}




