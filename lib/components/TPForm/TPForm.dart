
import 'package:flutter/cupertino.dart';

import '../../apis/models/UIModels.dart';
import '../../fragments/generic/GenericCountryPickerPage.dart';
import '../../fragments/generic/GenericMultiplePickerPage.dart';
import '../../fragments/generic/GenericPhoneCodePickerPage.dart';
import '../../fragments/generic/GenericSimplePickerPage.dart';
import 'components/TPFormCountryCodeInputBar.dart';
import 'components/TPFormMultipleSelectInputBar.dart';
import 'components/TPFormPhoneNumberInputBar.dart';
import 'components/TPFormSimpleSelectInputBar.dart';
import 'components/TPFormTextInputBar.dart';

/// `FormBaseElement` contains base form element data binding
///
///  - `teErr` is `ValueNotifier<String?>` for providing error string value of the current form element
class FormBaseElement {
  final ValueNotifier<String?> teErr = ValueNotifier<String?>(null);

  String? get err {
    return teErr.value;
  }

  set err(String? val) {
    teErr.value = val ?? "";
  }

  void dispose() {
    teErr.dispose();
  }
}


/// `FormStringElement` is a kind of form element which supports string input
///
///  - It supports any text input via `TextEditingController te`
class FormStringElement extends FormBaseElement {
  final te = TextEditingController();

  String get text {
    return te.text;
  }

  set text(String? val) {
    te.text = val ?? "";
  }

  @override
  void dispose() {
    super.dispose();
    te.dispose();
  }
}


/// `FormPhoneNumberElement` is a kind of form element which supports phone number input
///
///  - It supports:
///    - phone country code selection `ValueNotifier<String> tvPhoneCountryInput`
///    - phone number string input (FormStringElement)
class FormPhoneNumberElement extends FormStringElement {
  ValueNotifier<String> tvPhoneCountryInput = ValueNotifier<String>("");

  @override
  void dispose() {
    super.dispose();
    tvPhoneCountryInput.dispose();
  }
}


/// `FormSimpleSelectElement` is a kind of form element which supports single selection input
///
///  - `tvAny` -> notifies selection result as `String` value changes
///  - `choices` -> field list of choices
///  - `title` -> field title
class FormSimpleSelectElement extends FormBaseElement {
  final ValueNotifier<String> tvAny = ValueNotifier<String>("");
  List<UIListItemModel>? choices;
  String? title;

  FormSimpleSelectElement({this.choices, this.title});

  @override
  void dispose() {
    super.dispose();
    tvAny.dispose();
  }
}


/// `FormMultipleSelectElement` is a kind of form element which supports multiple selection input
///
///  - `tvAny` -> notifies selection results as `List<String>` value changes
///  - `choices` -> field list of choices
///  - `title` -> field title
class FormMultipleSelectElement extends FormBaseElement {
  final ValueNotifier<List<String>> tvAny = ValueNotifier<List<String>>([]);
  List<UIListItemModel>? choices;
  String? title;
  bool? isForceSingleSelect;

  FormMultipleSelectElement({this.choices, this.title, this.isForceSingleSelect});

  @override
  void dispose() {
    super.dispose();
    tvAny.dispose();
  }
}


/// `FormCountryCodeElement` is a kind of form element which supports country code selection list
///
///  - `tvCountryCode` -> notifies selection result as `String` value changes
///  - `title` -> field title
class FormCountryCodeElement extends FormBaseElement {
  ValueNotifier<String> tvCountryCode = ValueNotifier<String>("");
  String? title;

  @override
  void dispose() {
    super.dispose();
    tvCountryCode.dispose();
  }
}




/// `FormItemElement` is a renderer class of any TPForm element
///
///  - `fse` -> the main `FormBaseElement` to instruct the class, view type and data source to use
///  - `hintText` -> placeholder text
///  - `obscureText` -> boolean to mask the input if `true`
///  - `isRequired` -> boolean to append an asterisk to the title text if `true`
///  - `focusNode` -> optional variable to provide custom focusNode instance
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


  /// `render` can be used to render a specific list of `FormItemElement` items
  ///
  ///  - usage:
  /// ```dart
  ///
  /// GlobalKey<FormState> formKey = GlobalKey<FormState>();
  ///
  /// final fsePhoneNumber = FormPhoneNumberElement();
  /// final fsePassword = FormStringElement();
  /// final fsePasswordConfirm = FormStringElement();
  /// final fseNickname = FormStringElement();
  /// final fseEmail = FormStringElement();
  /// final fseAgeRange = FormSimpleSelectElement();
  /// final fseGender = FormSimpleSelectElement();
  ///
  /// List<FormItemElement> formItemList1 = [
  ///   FormItemElement(fse: fseNickname, hintText: "profile_nickname", isRequired: true),
  ///   FormItemElement(fse: fsePhoneNumber, hintText: "profile_phone", isPhone: true, isRequired: true),
  ///   FormItemElement(fse: fsePassword, hintText: "profile_password", isRequired: true, obscureText: true),
  ///   FormItemElement(fse: fsePasswordConfirm, hintText: "profile_confirm_password", isRequired: true, obscureText: true),
  ///   FormItemElement(fse: fseEmail, hintText: "profile_email", isEmail: true),
  /// ];
  ///
  /// ...
  /// ...
  ///
  ///
  /// @override
  /// Widget build(BuildContext context) {
  ///   return SingleChildScrollView(
  ///       child: Form(
  ///           autovalidateMode: AutovalidateMode.onUserInteraction,
  ///           key: formKey,
  ///           child: Column(
  ///               children: <Widget>[
  ///
  ///
  ///                   FormItemElement.renderList(formItemList1),
  ///
  /// ...
  ///
  /// ```
  static Widget renderList(List<FormItemElement> formItemList) {
    return Column(
        children: <Widget>[
        ...formItemList.asMap().entries.map((entry) {
          return entry.value.renderFormItemListByIndex(formItemList, entry.key);
        }).toList(),
      ]
    );
  }

  /// `renderFormItemListByIndex` can be used to render a specific list item of `FormItemElement` by array index
  Widget renderFormItemListByIndex(List<FormItemElement> formItemList, int index) {
    if (fse is FormPhoneNumberElement) {
      var fsei = fse as FormPhoneNumberElement;
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: ValueListenableBuilder(
            valueListenable: fsei.teErr,
            builder: (_, value, __) {
              return TPPhoneNumberInputBar(
                grouped: true,
                firstInGroup: index <= 0,
                lastInGroup: index >= formItemList.length - 1,
                controller: fsei.te,
                phoneCode: fsei.tvPhoneCountryInput,
                errorText: fsei.teErr.value,
                titleText: getTitleText(),
                hintText: getHintText(),
                focusNode: focusNode,
                pickerPageBuilder: (context, widget) => GenericPhoneCodePickerPage(
                  phoneCode: widget.phoneCode.value,
                  isDismissAfterSelect: true,
                  onSelectPhoneCode: (phoneCode) {
                    if (phoneCode != null) {
                      widget.phoneCode.value = phoneCode;
                    }
                  },
                ),
              );
            }),
      );
    }

    else if (fse is FormCountryCodeElement) {
      var fsei = fse as FormCountryCodeElement;
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: ValueListenableBuilder(
            valueListenable: fsei.teErr,
            builder: (_, value, __) {
              return TPCountryCodeInputBar(
                title: fsei.title,
                grouped: true,
                firstInGroup: index <= 0,
                lastInGroup: index >= formItemList.length - 1,
                countryCode: fsei.tvCountryCode,
                errorText: fsei.teErr.value,
                hintText: getHintText(),
                focusNode: focusNode,
                pickerPageBuilder: (context, widget) => GenericCountryPickerPage(
                  title: widget.title,
                  countryCode: widget.countryCode.value,
                  isDismissAfterSelect: true,
                  onSelectCountryCode: (countryCode) {
                    if (countryCode != null) {
                      widget.countryCode.value = countryCode;
                    }
                  },
                ),

              );
            }),
      );
    }

    else if (fse is FormSimpleSelectElement) {
      var fsei = fse as FormSimpleSelectElement;
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: ValueListenableBuilder(
            valueListenable: fsei.teErr,
            builder: (_, value, __) {
              return TPSimpleSelectInputBar(
                title: fsei.title,
                grouped: true,
                firstInGroup: index <= 0,
                lastInGroup: index >= formItemList.length - 1,
                valueNotifier: fsei.tvAny,
                choices: fsei.choices ?? [],
                errorText: fsei.teErr.value,
                hintText: getHintText(),
                focusNode: focusNode,
                pickerPageBuilder: (context, widget) => GenericSimplePickerPage(
                  title: widget.title ?? "",
                  value: widget.valueNotifier.value,
                  choices: widget.choices,
                  onSelectValue: (String? val) {
                    widget.valueNotifier.value = val ?? "";
                  },
                  isDismissAfterSelect: true,
                ),
              );
            }),
      );
    }

    else if (fse is FormMultipleSelectElement) {
      var fsei = fse as FormMultipleSelectElement;
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: ValueListenableBuilder(
            valueListenable: fsei.teErr,
            builder: (_, value, __) {
              return TPMultipleSelectInputBar(
                title: fsei.title,
                grouped: true,
                firstInGroup: index <= 0,
                lastInGroup: index >= formItemList.length - 1,
                valueNotifier: fsei.tvAny,
                choices: fsei.choices ?? [],
                errorText: fsei.teErr.value,
                isForceSingleSelect: fsei.isForceSingleSelect ?? false,
                hintText: getHintText(),
                focusNode: focusNode,
                pickerPageBuilder: (context, widget) => GenericMultiplePickerPage(
                  title: widget.title ?? "",
                  values: widget.valueNotifier.value,
                  choices: widget.choices,
                  isForceSingleSelect: widget.isForceSingleSelect ?? false,
                  onSelectValue: (String? val, List<UIListItemModel> valuesList) {
                    widget.valueNotifier.value = valuesList.map((e) => e.value).toList();
                  },
                ),
              );
            }),
      );
    }

    else if (fse is FormStringElement) {
      var fsei = fse as FormStringElement;
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: ValueListenableBuilder(
            valueListenable: fsei.teErr,
            builder: (_, value, __) {
              return TPTextInputBar(
                grouped: true,
                firstInGroup: index <= 0,
                lastInGroup: index >= formItemList.length - 1,
                controller: fsei.te,
                errorText: fsei.teErr.value,
                titleText: getTitleText(),
                hintText: getHintText(),
                obscureText: obscureText,
                isEmail: isEmail,
                focusNode: focusNode,
              );
            }),
      );
    }

    return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 15)
    );


  }
}
