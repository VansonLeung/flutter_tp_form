
import 'package:flutter/material.dart';
import 'package:tp_form_example/fragments/sections/SampleForm1QuestionnaireSection.dart';

import '../../components/TPForm/TPForm.dart';
import '../apis/models/UIModels.dart';
import '../helpers/LogHelper.dart';

class SampleForm1Page extends StatefulWidget {
  const SampleForm1Page({super.key});

  @override
  _SampleForm1PageState createState() => _SampleForm1PageState();
}

class _SampleForm1PageState extends State<SampleForm1Page> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final fsePhoneNumber = FormPhoneNumberElement();
  final fseCountry = FormCountryCodeElement();
  final fsePassword = FormStringElement();
  final fsePasswordConfirm = FormStringElement();
  final fseNickname = FormStringElement();
  final fseEmail = FormStringElement();
  final fseAgeRange = FormSimpleSelectElement();
  final fseGender = FormSimpleSelectElement();

  final ScrollController scrollController = ScrollController();

  List<FormItemElement> formItemList1 = [];
  List<FormItemElement> formItemList2 = [];

  SampleForm1QuestionnaireSectionState? authRegisterQuestionnaireSectionState;

  bool isBusy = false;

  @override
  void initState() {
    super.initState();

    fsePhoneNumber.tvPhoneCountryInput.value = "852";
    fseCountry.tvCountryCode.value = "HK";

    Future.delayed(Duration.zero,() {
      setState(() {
        fseAgeRange.choices = [
          UIListItemModel("< 18", "0-17"),
          UIListItemModel("18 - 24", "18-24"),
          UIListItemModel("25 - 34", "25-34"),
          UIListItemModel("35 - 44", "35-44"),
          UIListItemModel("45 - 54", "45-54"),
          UIListItemModel("55 - 64", "55-64"),
          UIListItemModel("> 65", "65-100"),
        ];
        fseAgeRange.title = "profile_select_age_range";


        fseGender.choices = [
          UIListItemModel("profile_male"??"", "male"),
          UIListItemModel("profile_female"??"", "female"),
          UIListItemModel("profile_unspecified"??"", ""),
        ];
        fseGender.title = "profile_gender";

        formItemList1 = [
          FormItemElement(fse: fseNickname, hintText: "nickname", isRequired: true),
          FormItemElement(fse: fsePhoneNumber, hintText: "phone", isPhone: true, isRequired: true),
          FormItemElement(fse: fsePassword, hintText: "password", isRequired: true, obscureText: true),
          FormItemElement(fse: fsePasswordConfirm, hintText: "confirm_password", isRequired: true, obscureText: true),
          FormItemElement(fse: fseEmail, hintText: "email", isEmail: true),
        ];

        formItemList2 = [
          FormItemElement(fse: fseAgeRange, hintText: "age range"),
          FormItemElement(fse: fseGender, hintText: "gender"),
          FormItemElement(fse: fseCountry, hintText: "country"),
        ];
      });
    });

    fseNickname.te.addListener(() {
      fseNickname.err = fseNickname.text.isEmpty ? "profile_required" : null;
    });
  }

  @override
  void dispose() {
    fsePhoneNumber.dispose();
    fseCountry.dispose();
    fsePassword.dispose();
    fsePasswordConfirm.dispose();
    fseNickname.dispose();
    fseAgeRange.dispose();
    fseGender.dispose();
    fseEmail.dispose();
    super.dispose();
  }


  void doRegister() async {
    try {
      if (isBusy) {
        return;
      }

      var isValid = true;

      fseNickname.teErr.value = "";
      fsePhoneNumber.teErr.value = "";
      fsePassword.teErr.value = "";
      fsePasswordConfirm.teErr.value = "";

      if (fseNickname.text.trim().isEmpty) {
        isValid = false;
        setState(() {
          fseNickname.teErr.value = "profile_required_asterisk";
        });
      }

      if (fsePhoneNumber.text.trim().isEmpty
          || fsePhoneNumber.tvPhoneCountryInput.value.isEmpty) {
        isValid = false;
        setState(() {
          fsePhoneNumber.teErr.value = "profile_required_asterisk";
        });
      }

      if (fsePassword.text.isEmpty
          || fsePassword.text.length < 6) {
        isValid = false;
        setState(() {
          fsePassword.teErr.value = "profile_password_input_error_1";
        });
      }

      if (fsePasswordConfirm.text.isEmpty
          || fsePasswordConfirm.text != fsePassword.text) {
        isValid = false;
        setState(() {
          fsePasswordConfirm.teErr.value = "profile_confirm_password_input_error";
        });
      }

      if (!isValid) {
        scrollController.animateTo(0, duration: const Duration(milliseconds: 500), curve: Curves.ease);
        return;
      }

      setState(() {
        isBusy = true;
      });


      var questionnaireDict = {};
      if (authRegisterQuestionnaireSectionState != null) {
        questionnaireDict = authRegisterQuestionnaireSectionState?.doSummarizeQuestionnaire() ?? {};
      }

      GLog.getInstance().d({
        "phone_country": fsePhoneNumber.tvPhoneCountryInput.value,
        "phone_number": fsePhoneNumber.text.trim(),
        "password": fsePassword.text,
        "nickName": fseNickname.text,
        "age_range": fseAgeRange.tvAny.value,
        "gender": fseGender.tvAny.value,
        "email": fseEmail.text.trim(),
        "q1": (questionnaireDict.containsKey("q1") ? questionnaireDict["q1"] : ""),
        "q2": (questionnaireDict.containsKey("q2") ? questionnaireDict["q2"] : ""),
        "q3": (questionnaireDict.containsKey("q3") ? questionnaireDict["q3"] : ""),
        "q4": (questionnaireDict.containsKey("q4") ? questionnaireDict["q4"] : ""),
        "q5": (questionnaireDict.containsKey("q5") ? questionnaireDict["q5"] : ""),
      });

      Future.delayed(const Duration(milliseconds: 1000), () {
        setState(() {
          isBusy = false;
        });
      });

    } catch (e) {
      var msg = e.toString();
      GLog.getInstance().d(msg);

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
            key: formKey,
            child: Column(
              children: <Widget>[

                FormItemElement.renderList(formItemList1),

                const SizedBox(height: 40),

                FormItemElement.renderList(formItemList2),

                const SizedBox(height: 40),


                SampleForm1QuestionnaireSection(
                    onInit: (state) {
                      setState(() {
                        authRegisterQuestionnaireSectionState = state;
                      });
                    }
                ),


                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState?.validate() == true) {

                          GLog.getInstance().d("Validated");
                        } else {

                          GLog.getInstance().d("Not Validated");
                        }

                        doRegister();
                      },
                      child: const Text(
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
            color: const Color(0x99000000),
            child: const Center(child: CircularProgressIndicator(color: Color(0xFFFFFFFF))),
          )
      ],
    );
  }
}