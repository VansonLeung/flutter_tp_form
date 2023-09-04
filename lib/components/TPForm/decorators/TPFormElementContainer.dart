import 'package:flutter/material.dart';

/// TPFormElement group border decorator
class TPFormElementContainer extends StatelessWidget {
  final bool? isFocused;
  final bool? grouped;
  final bool? firstInGroup;
  final bool? lastInGroup;
  final bool? isInnerColumn;
  final List<Widget> children;

  const TPFormElementContainer({Key? key,
    required this.children,
    this.isFocused,
    this.grouped, this.firstInGroup, this.lastInGroup, this.isInnerColumn, }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          boxShadow: isFocused == true ? [
            const BoxShadow(
              color: Color(0xff808080),
              spreadRadius: 2,
              blurRadius: 2,
              offset: Offset(0, 0),
            ),
          ] : null,
          color: const Color(0xffe0e0e0),
          borderRadius: BorderRadiusDirectional.only(
            topStart: ( (grouped == true && firstInGroup != true) )
                ? const Radius.circular(0) : const Radius.circular(10),
            topEnd:  ( (grouped == true && firstInGroup != true) )
                ? const Radius.circular(0) : const Radius.circular(10),
            bottomStart: ( (grouped == true && lastInGroup != true) )
                ? const Radius.circular(0) : const Radius.circular(10),
            bottomEnd: ( (grouped == true && lastInGroup != true) )
                ? const Radius.circular(0) : const Radius.circular(10),
          ),
          border: Border.all(
            color: const Color(0xff404040),
            width: 1,
          )
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(15, 0, 15, 0,),
        child: isInnerColumn == true ? Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: children,
        ) : Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: children,
        ),
      ),

    );
  }
}




