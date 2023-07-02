# tp_form

An example of customizing and encapsulating my tp_form

## Getting Started

1. Download
2. Run "example" project inside the folder "example" in iOS or Android


## Objectives

1. Make form input logic consistent and reuseable
2. Make form input decoration / style more consistent
3. Make the implementation code clean and easy to use


## Main TPForm code structure

![image](https://github.com/VansonLeung/flutter_tp_form/assets/1129695/0d5412d0-d753-4d5e-8dc0-5c833e2c9d5c)


## Demo video

https://github.com/VansonLeung/flutter_tp_form/assets/1129695/47d9f8cd-753c-4b99-9fa4-65e011ccf074


## Simple usage

```

import 'package:flutter/material.dart';
import 'package:tp_form_example/fragments/sections/SampleForm1QuestionnaireSection.dart';

import '../../components/TPForm/TPForm.dart';
import '../apis/models/UIModels.dart';

class SampleForm1Page extends StatefulWidget {
  @override
  _SampleForm1PageState createState() => _SampleForm1PageState();
}

class _SampleForm1PageState extends State<SampleForm1Page> {
  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  final fse_phoneNumber = FormPhoneNumberElement();
  final fse_password = FormStringElement();
  final fse_password_confirm = FormStringElement();
  final fse_nickname = FormStringElement();
  final fse_email = FormStringElement();
  final fse_age_range = FormSimpleSelectElement();
  final fse_gender = FormSimpleSelectElement();

  final ScrollController scrollController = ScrollController();

  List<FormItemElement> formItemList1 = [];
  List<FormItemElement> formItemList2 = [];

  SampleForm1QuestionnaireSectionState? authRegisterQuestionnaireSectionState;

  bool isBusy = false;

  @override
  void initState() {
    super.initState();

    fse_phoneNumber.tv_phoneCountry.value = "852";

    Future.delayed(Duration.zero,() {
      setState(() {
        fse_age_range.choices = [
          UIListItemModel("< 18", "0-17"),
          UIListItemModel("18 - 24", "18-24"),
          UIListItemModel("25 - 34", "25-34"),
          UIListItemModel("35 - 44", "35-44"),
          UIListItemModel("45 - 54", "45-54"),
          UIListItemModel("55 - 64", "55-64"),
          UIListItemModel("> 65", "65-100"),
        ];
        fse_age_range.title = "profile_select_age_range";


        fse_gender.choices = [
          UIListItemModel("profile_male"??"", "male"),
          UIListItemModel("profile_female"??"", "female"),
          UIListItemModel("profile_unspecified"??"", ""),
        ];
        fse_gender.title = "profile_gender";

        formItemList1 = [
          FormItemElement(fse: fse_nickname, hintText: "profile_nickname", isRequired: true),
          FormItemElement(fse: fse_phoneNumber, hintText: "profile_phone", isPhone: true, isRequired: true),
          FormItemElement(fse: fse_password, hintText: "profile_password", isRequired: true, obscureText: true),
          FormItemElement(fse: fse_password_confirm, hintText: "profile_confirm_password", isRequired: true, obscureText: true),
          FormItemElement(fse: fse_email, hintText: "profile_email", isEmail: true),
        ];

        formItemList2 = [
          FormItemElement(fse: fse_age_range, hintText: "profile_age_range"),
          FormItemElement(fse: fse_gender, hintText: "profile_gender"),
        ];
      });
    });

    fse_nickname.te.addListener(() {
      fse_nickname.err = fse_nickname.text.isEmpty ? "profile_required" : null;
    });
  }

  @override
  void dispose() {
    fse_phoneNumber.dispose();
    fse_password.dispose();
    fse_password_confirm.dispose();
    fse_nickname.dispose();
    fse_age_range.dispose();
    fse_gender.dispose();
    fse_email.dispose();
    super.dispose();
  }


  void doRegister() async {
    try {
      if (isBusy) {
        return;
      }

      var isValid = true;

      fse_nickname.te_err.value = "";
      fse_phoneNumber.te_err.value = "";
      fse_password.te_err.value = "";
      fse_password_confirm.te_err.value = "";

      if (fse_nickname.text.trim().isEmpty) {
        isValid = false;
        setState(() {
          fse_nickname.te_err.value = "profile_required_asterisk";
        });
      }

      if (fse_phoneNumber.text.trim().isEmpty
          || fse_phoneNumber.tv_phoneCountry.value.isEmpty) {
        isValid = false;
        setState(() {
          fse_phoneNumber.te_err.value = "profile_required_asterisk";
        });
      }

      if (fse_password.text.isEmpty
          || fse_password.text.length < 6) {
        isValid = false;
        setState(() {
          fse_password.te_err.value = "profile_password_input_error_1";
        });
      }

      if (fse_password_confirm.text.isEmpty
          || fse_password_confirm.text != fse_password.text) {
        isValid = false;
        setState(() {
          fse_password_confirm.te_err.value = "profile_confirm_password_input_error";
        });
      }

      if (!isValid) {
        scrollController.animateTo(0, duration: Duration(milliseconds: 500), curve: Curves.ease);
        return;
      }

      setState(() {
        isBusy = true;
      });


      var questionnaireDict = {};
      if (authRegisterQuestionnaireSectionState != null) {
        questionnaireDict = authRegisterQuestionnaireSectionState?.doSummarizeQuestionnaire() ?? {};
      }

      print({
        "phone_country": fse_phoneNumber.tv_phoneCountry.value,
        "phone_number": fse_phoneNumber.text.trim(),
        "password": fse_password.text,
        "nickName": fse_nickname.text,
        "age_range": fse_age_range.tv_any.value,
        "gender": fse_gender.tv_any.value,
        "email": fse_email.text.trim(),
        "q1": (questionnaireDict.containsKey("q1") ? questionnaireDict["q1"] : ""),
        "q2": (questionnaireDict.containsKey("q2") ? questionnaireDict["q2"] : ""),
        "q3": (questionnaireDict.containsKey("q3") ? questionnaireDict["q3"] : ""),
        "q4": (questionnaireDict.containsKey("q4") ? questionnaireDict["q4"] : ""),
        "q5": (questionnaireDict.containsKey("q5") ? questionnaireDict["q5"] : ""),
      });

      Future.delayed(Duration(milliseconds: 1000), () {
        setState(() {
          isBusy = false;
        });
      });

    } catch (e) {
      var msg = e.toString();
      print(msg);

      setState(() {
        isBusy = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          controller: scrollController,
          child: Form(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            key: formkey,
            child: Column(
              children: <Widget>[

                ...formItemList1.asMap().entries.map((entry) {
                  return entry.value.render(formItemList1, entry.key);
                }).toList(),

                SizedBox(height: 40),

                ...formItemList2.asMap().entries.map((entry) {
                  return entry.value.render(formItemList2, entry.key);
                }).toList(),

                SizedBox(height: 40),


                SampleForm1QuestionnaireSection(
                    onInit: (state) {
                      setState(() {
                        authRegisterQuestionnaireSectionState = state;
                      });
                    }
                ),


                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (formkey.currentState?.validate() == true) {

                          print("Validated");
                        } else {

                          print("Not Validated");
                        }

                        doRegister();
                      },
                      child: Text(
                        "profile_register"??"",
                      ),
                    ),
                  ),
                ),


                const SizedBox(
                  height: 100,
                ),
              ],
            ),
          ),
        ),

        if (isBusy)
          Container(
            width: double.infinity,
            height: double.infinity,
            color: Color(0x99000000),
            child: Center(child: CircularProgressIndicator(color: Color(0xFFFFFFFF))),
          )
      ],
    );
  }
}
```


