


import 'package:flutter/material.dart';
import 'package:tp_form_example/apis/models/Country.dart';

import '../decorators/TPFormElementContainer.dart';

typedef TPCountryCodeInputBarPickerPageBuilder = Widget Function(BuildContext context, TPCountryCodeInputBar widget);

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
  final TPCountryCodeInputBarPickerPageBuilder? pickerPageBuilder;

  const TPCountryCodeInputBar({Key? key, this.title, this.hintText,
    this.focusNode, this.autofocus,
    required this.countryCode,
    this.grouped, this.firstInGroup, this.lastInGroup, this.isSupportClearText, this.errorText, this.pickerPageBuilder, }) : super(key: key);
  @override
  _TPCountryCodeInputBarState createState() => _TPCountryCodeInputBarState();
}

class _TPCountryCodeInputBarState extends State<TPCountryCodeInputBar> with SingleTickerProviderStateMixin {

  bool isReady = false;
  String runtimeText = "";
  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    focusNode = widget.focusNode ?? FocusNode();
    focusNode.addListener(() {
      setState(() {});
    });
    refresh();
  }

  void refresh() async {
    await Country.loadCountryList();
    setState(() {
      isReady = true;
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
          Padding(padding: const EdgeInsets.symmetric(vertical: 17), child:
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

            if (widget.pickerPageBuilder != null) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => widget.pickerPageBuilder!(context, widget)
                  ),
              );

            }


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
                      Text("${label}", style: const TextStyle(
                        fontSize: 18,
                      )),
                      const Icon(Icons.arrow_drop_down),
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




