


import 'package:flutter/material.dart';
import 'package:tp_form_example/apis/models/Country.dart';

import '../../fragments/generic/GenericCountryPickerPage.dart';
import 'TPFormElementContainer.dart';





class TPCountryCodeInputBar extends StatefulWidget {
  final String? title;
  final String? hintText;
  final FocusNode? focusNode;
  final bool? autofocus;
  final ValueNotifier<String> countryCode;
  final bool? grouped;
  final bool? firstInGroup;
  final bool? lastInGroup;
  final bool? isSupportClearText;
  final String? errorText;

  const TPCountryCodeInputBar({Key? key, this.title, this.hintText,
    this.focusNode, this.autofocus,
    required this.countryCode,
    this.grouped, this.firstInGroup, this.lastInGroup, this.isSupportClearText, this.errorText, }) : super(key: key);
  @override
  _TPCountryCodeInputBarState createState() => _TPCountryCodeInputBarState();
}

class _TPCountryCodeInputBarState extends State<TPCountryCodeInputBar> with SingleTickerProviderStateMixin {

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

  onTextChange() {
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

        TextButton(
          onPressed: () {

            FocusScope.of(context).unfocus();
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => GenericCountryPickerPage(
                    title: widget.title,
                    countryCode: widget.countryCode.value,
                    isDismissAfterSelect: true,
                    onSelectCountryCode: (countryCode) {
                      if (countryCode != null) {
                        widget.countryCode.value = countryCode;
                      }
                    },
                  )),
            );

          },
          child: ValueListenableBuilder(
              valueListenable: widget.countryCode,
              builder: (_, value, __) {
                var label = "";
                var choice = Country.countryDictByCountryCode?[widget.countryCode.value];
                label = choice?.getName(context) ?? "";
                return Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("${label}", style: TextStyle(
                        fontSize: 18,
                      )),
                      Icon(Icons.arrow_drop_down),
                    ]
                );
              }
          ),
        ),

        ),

      ],
    );
  }
}




