
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class GenericSelectionCellHorizontal extends StatelessWidget {
  final int index;
  final String? title;
  final String? subtitle;
  final String? imageUrl;
  final bool isSelected;
  final Function onPressed;

  const GenericSelectionCellHorizontal({Key? key, required this.index, this.isSelected = false, required this.onPressed, this.title, this.subtitle, this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () {
          onPressed();
        },
        child: Container(
          child: Column(
              children: [
                Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      if (imageUrl != null)
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: Color(0xFFFFFFFF),
                                width: 2,
                              )
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: CachedNetworkImage(
                              imageUrl: imageUrl!,
                              fit: BoxFit.cover,
                              height: 75,
                              width: 100,
                              // imageBuilder: (context, imageProvider) => Container(
                              // decoration: BoxDecoration(
                              //   image: DecorationImage(
                              //       image: imageProvider,
                              //       fit: BoxFit.cover,
                              //       colorFilter:
                              //       ColorFilter.mode(Colors.red, BlendMode.colorBurn)),
                              // ),
                              // ),
                              placeholder: (context, url) => const Center(
                                  child: CircularProgressIndicator(
                                    color: Color(0xFFFFFFFF),
                                  )
                              ),
                              errorWidget: (context, url, error) => const Icon(Icons.error),
                            ),
                          ),
                        ),

                      const SizedBox(width: 20, height: 7,),

                      Expanded(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [

                                if (title != null && title!.trim() != "")
                                  Text(
                                      title ?? "",
                                      textAlign: TextAlign.left,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      )
                                  ),

                                const SizedBox(height: 2,),

                                if (subtitle != null && subtitle!.trim() != "")
                                  Text(
                                      subtitle ?? "",
                                      textAlign: TextAlign.left,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: Color(0xFF808080),
                                      )
                                  ),

                              ]
                          )


                      ),

                      const SizedBox(width: 20, height: 7,),

                      AnimatedOpacity(
                        opacity: isSelected ? 1 : 0,
                        duration: const Duration(milliseconds: 250),
                        child: const Icon(Icons.check, size: 32, color: Color(0xffffffff)),
                      )

                    ]
                ),

              ]
          )
        ),
    );
  }

}
