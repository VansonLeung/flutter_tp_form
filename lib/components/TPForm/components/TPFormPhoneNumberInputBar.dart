


import 'package:flutter/material.dart';

import '../decorators/TPFormElementContainer.dart';




typedef TPPhoneNumberInputBarPickerPageBuilder = Widget Function(BuildContext context, TPPhoneNumberInputBar widget);

class TPPhoneNumberInputBar extends StatefulWidget {
  final String? titleText;
  final String? hintText;
  final Function? onFieldSubmitted;
  final Function? onFieldCleared;
  final FocusNode? focusNode;
  final bool? autofocus;
  final TextEditingController controller;
  final ValueNotifier<String> phoneCode;
  final bool? grouped;
  final bool? firstInGroup;
  final bool? lastInGroup;
  final bool? isSupportClearText;
  final String? errorText;
  final TPPhoneNumberInputBarPickerPageBuilder? pickerPageBuilder;

  const TPPhoneNumberInputBar({Key? key, required this.controller, this.titleText, this.hintText, this.onFieldSubmitted,
    this.focusNode, this.autofocus, this.onFieldCleared,
    required this.phoneCode,
    this.grouped, this.firstInGroup, this.lastInGroup, this.isSupportClearText, this.errorText, this.pickerPageBuilder, }) : super(key: key);
  @override
  _TPPhoneNumberInputBarState createState() => _TPPhoneNumberInputBarState();
}

class _TPPhoneNumberInputBarState extends State<TPPhoneNumberInputBar> with SingleTickerProviderStateMixin {

  String runtimeText = "";
  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(onTextChange);
    focusNode = widget.focusNode ?? FocusNode();
    focusNode.addListener(() {
      setState(() {});
    });
    runtimeText = widget.controller.text;
  }

  onTextChange() {
    setState(() {
      runtimeText = widget.controller.text;
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
        if (widget.titleText != null)
          Padding(padding: EdgeInsets.symmetric(vertical: 17), child:
          SizedBox(width: 80, child:
          Text(
            widget.titleText ?? "",
            textAlign: TextAlign.end,
          ),
          ),
          ),



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
              valueListenable: widget.phoneCode,
              builder: (_, value, __) {
                return Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("+${widget.phoneCode.value}", style: TextStyle(
                        fontSize: 18,
                      )),
                      const Icon(Icons.arrow_drop_down),
                    ]
                );
              }
          ),
        ),

        Expanded(child:
        AnimatedSize(
          duration: Duration(milliseconds: 150),
          curve: Curves.fastOutSlowIn,
          child:
          TextField(
            keyboardType: TextInputType.phone,
            onSubmitted: (str) {
              widget.onFieldSubmitted!();
            },
            autofocus: widget.autofocus ?? false,
            focusNode: focusNode,
            textAlignVertical: TextAlignVertical.center,
            style: TextStyle(
              color: Color(0xFF0000dd),
            ),
            cursorColor: Color(0xFF0000dd),
            controller: widget.controller,
            decoration: InputDecoration(
              suffixIcon: Stack(
                children: [
                  if (widget.isSupportClearText == true
                      && !(runtimeText == null || runtimeText == ""))
                    IconButton(
                      onPressed: () {
                        widget.onFieldCleared!();
                      },
                      icon: Icon(Icons.clear, color: Color(0xFF0000dd),),
                    ),
                ],
              ),


              // errorBorder: OutlineInputBorder(
              //   borderSide: BorderSide(
              //       width: 3, color: Colors.redAccent),
              // ),


              errorText: widget.errorText?.isEmpty == true ? null : widget.errorText,
              errorStyle: TextStyle(
                color: Colors.redAccent,
              ),
              contentPadding: EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 15.0),



              hintText: widget.hintText,
              hintStyle: TextStyle(
                color: Color(0xff888888),
              ),
            ),
          ),
        ),
        ),

      ],
    );
  }
}




