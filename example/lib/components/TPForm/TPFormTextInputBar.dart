


import 'package:flutter/material.dart';

import 'TPFormElementContainer.dart';

class TPTextInputBar extends StatefulWidget {
  final String? titleText;
  final String? hintText;
  final Function? onFieldSubmitted;
  final Function? onFieldCleared;
  final FocusNode? focusNode;
  final bool? autofocus;
  final TextEditingController controller;
  final bool? grouped;
  final bool? firstInGroup;
  final bool? lastInGroup;
  final bool? obscureText;
  final bool? isSupportClearText;
  final bool? isEmail;
  final String? errorText;

  const TPTextInputBar({Key? key, required this.controller, this.titleText, this.hintText,
    this.onFieldSubmitted, this.focusNode, this.autofocus, this.onFieldCleared,
    this.grouped, this.firstInGroup, this.lastInGroup, this.obscureText, this.isSupportClearText, this.errorText,
    this.isEmail}) : super(key: key);
  @override
  _TPTextInputBarState createState() => _TPTextInputBarState();
}

class _TPTextInputBarState extends State<TPTextInputBar> with SingleTickerProviderStateMixin {

  String runtimeText = "";
  late FocusNode focusNode;
  bool isForceNonObscure = false;

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


  @override
  void dispose() {
    super.dispose();
    focusNode.dispose();
    widget.controller.removeListener(onTextChange);
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

        if (widget.titleText != null)
          SizedBox(width: 15,),

        Expanded(child:
        AnimatedSize(
          duration: Duration(milliseconds: 150),
          curve: Curves.fastOutSlowIn,
          child:
          TextField(
            keyboardType: widget.isEmail == true ? TextInputType.emailAddress : null,
            onSubmitted: (str) {
              widget.onFieldSubmitted!();
            },
            obscureText: widget.obscureText == true ?  !isForceNonObscure : false,
            autofocus: widget.autofocus ?? false,
            focusNode: focusNode,
            style: TextStyle(
              color: Color(0xFF0000dd),
            ),
            cursorColor: Color(0xFF0000dd),
            controller: widget.controller,
            decoration: InputDecoration(
              suffixIcon: Stack(
                children: [
                  if (widget.obscureText == true)
                    IconButton(
                      onPressed: () {
                        setState(() {
                          isForceNonObscure = !isForceNonObscure;
                        });
                      },
                      icon: Icon(isForceNonObscure ? Icons.remove_red_eye_outlined : Icons.remove_red_eye, color: Color(0xFF0000dd),),
                    ),

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

              errorMaxLines: 5,
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




