import 'package:flutter/material.dart';

import '../../../apis/models/UIModels.dart';
import '../decorators/TPFormElementContainer.dart';

typedef TPSimpleSelectInputBarPickerPageBuilder = Widget Function(BuildContext context, TPSimpleSelectInputBar widget);

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
  final TPSimpleSelectInputBarPickerPageBuilder? pickerPageBuilder;

  const TPSimpleSelectInputBar({Key? key, this.title, this.hintText,
    this.focusNode, this.autofocus,
    required this.valueNotifier, required this.choices,
    this.grouped, this.firstInGroup, this.lastInGroup, this.isSupportClearText,
    this.errorText, this.pickerPageBuilder, }) : super(key: key);
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
              valueListenable: widget.valueNotifier,
              builder: (_, value, __) {

                UIListItemModel? item;
                for (var k in widget.choices) {
                  if (k.value == widget.valueNotifier.value) {
                    item = k;
                    break;
                  }
                }

                return Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("${item?.label ?? ""}", style: const TextStyle(
                        fontSize: 18,
                      )),
                      const Icon(Icons.arrow_drop_down),
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




