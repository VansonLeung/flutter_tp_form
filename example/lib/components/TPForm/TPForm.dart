
import 'package:flutter/cupertino.dart';

import '../../apis/models/UIModels.dart';
import 'TPFormCountryCodeInputBar.dart';
import 'TPFormMultipleSelectInputBar.dart';
import 'TPFormPhoneNumberInputBar.dart';
import 'TPFormSimpleSelectInputBar.dart';
import 'TPFormTextInputBar.dart';

class FormBaseElement {
  final ValueNotifier<String?> te_err = ValueNotifier<String?>(null);

  String? get err {
    return te_err.value;
  }

  void set err(String? val) {
    te_err.value = val ?? "";
  }

  void dispose() {
    te_err.dispose();
  }
}


class FormStringElement extends FormBaseElement {
  final te = TextEditingController();

  String get text {
    return te.text;
  }

  void set text(String? val) {
    te.text = val ?? "";
  }

  @override
  void dispose() {
    super.dispose();
    te.dispose();
  }
}

class FormPhoneNumberElement extends FormStringElement {
  ValueNotifier<String> tv_phoneCountry = ValueNotifier<String>("");

  void dispose() {
    super.dispose();
    tv_phoneCountry.dispose();
  }
}

class FormSimpleSelectElement extends FormBaseElement {
  final ValueNotifier<String> tv_any = ValueNotifier<String>("");
  List<UIListItemModel>? choices;
  String? title;

  FormSimpleSelectElement({this.choices, this.title});

  void dispose() {
    super.dispose();
    tv_any.dispose();
  }
}

class FormMultipleSelectElement extends FormBaseElement {
  final ValueNotifier<List<String>> tv_any = ValueNotifier<List<String>>([]);
  List<UIListItemModel>? choices;
  String? title;
  bool? isForceSingleSelect;

  FormMultipleSelectElement({this.choices, this.title, this.isForceSingleSelect});

  void dispose() {
    super.dispose();
    tv_any.dispose();
  }
}

class FormCountryCodeElement extends FormBaseElement {
  ValueNotifier<String> tv_countryCode = ValueNotifier<String>("");
  String? title;

  void dispose() {
    super.dispose();
    tv_countryCode.dispose();
  }
}




class FormItemElement {
  final FormBaseElement fse;
  final String? hintText;
  final bool? obscureText;
  final bool? isRequired;
  final bool? isEmail;
  final bool? isPhone;
  final FocusNode? focusNode;

  FormItemElement({required this.fse, required this.hintText, this.obscureText, this.isRequired, this.isEmail, this.isPhone, this.focusNode});

  String? getTitleText() {
    if (hintText != null) {
      if (isRequired == true) {
        return "${hintText ?? ""}*";
      }
    }
    return hintText;
  }

  String? getHintText() {
    return hintText;
  }

  Widget render(List<FormItemElement> formItemList, int index) {
    if (fse is FormPhoneNumberElement) {
      var _fse = fse as FormPhoneNumberElement;
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: ValueListenableBuilder(
            valueListenable: _fse.te_err,
            builder: (_, value, __) {
              return TPPhoneNumberInputBar(
                grouped: true,
                firstInGroup: index <= 0,
                lastInGroup: index >= formItemList.length - 1,
                controller: _fse.te,
                phoneCode: _fse.tv_phoneCountry,
                errorText: _fse.te_err.value,
                titleText: getTitleText(),
                hintText: getHintText(),
                focusNode: focusNode,
              );
            }),
      );
    }

    else if (fse is FormCountryCodeElement) {
      var _fse = fse as FormCountryCodeElement;
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: ValueListenableBuilder(
            valueListenable: _fse.te_err,
            builder: (_, value, __) {
              return TPCountryCodeInputBar(
                title: _fse.title,
                grouped: true,
                firstInGroup: index <= 0,
                lastInGroup: index >= formItemList.length - 1,
                countryCode: _fse.tv_countryCode,
                errorText: _fse.te_err.value,
                hintText: getHintText(),
                focusNode: focusNode,
              );
            }),
      );
    }

    else if (fse is FormSimpleSelectElement) {
      var _fse = fse as FormSimpleSelectElement;
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: ValueListenableBuilder(
            valueListenable: _fse.te_err,
            builder: (_, value, __) {
              return TPSimpleSelectInputBar(
                title: _fse.title,
                grouped: true,
                firstInGroup: index <= 0,
                lastInGroup: index >= formItemList.length - 1,
                valueNotifier: _fse.tv_any,
                choices: _fse.choices ?? [],
                errorText: _fse.te_err.value,
                hintText: getHintText(),
                focusNode: focusNode,
              );
            }),
      );
    }

    else if (fse is FormMultipleSelectElement) {
      var _fse = fse as FormMultipleSelectElement;
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: ValueListenableBuilder(
            valueListenable: _fse.te_err,
            builder: (_, value, __) {
              return TPMultipleSelectInputBar(
                title: _fse.title,
                grouped: true,
                firstInGroup: index <= 0,
                lastInGroup: index >= formItemList.length - 1,
                valueNotifier: _fse.tv_any,
                choices: _fse.choices ?? [],
                errorText: _fse.te_err.value,
                isForceSingleSelect: _fse.isForceSingleSelect ?? false,
                hintText: getHintText(),
                focusNode: focusNode,
              );
            }),
      );
    }

    else if (fse is FormStringElement) {
      var _fse = fse as FormStringElement;
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: ValueListenableBuilder(
            valueListenable: _fse.te_err,
            builder: (_, value, __) {
              return TPTextInputBar(
                grouped: true,
                firstInGroup: index <= 0,
                lastInGroup: index >= formItemList.length - 1,
                controller: _fse.te,
                errorText: _fse.te_err.value,
                titleText: getTitleText(),
                hintText: getHintText(),
                obscureText: obscureText,
                isEmail: isEmail,
                focusNode: focusNode,
              );
            }),
      );
    }

    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 15)
    );


  }
}
