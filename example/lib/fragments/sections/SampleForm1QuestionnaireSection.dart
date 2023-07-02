
import 'package:flutter/material.dart';

import '../../../apis/models/UIModels.dart';
import '../../../components/TPForm/TPForm.dart';

class SampleForm1QuestionnaireSection extends StatefulWidget {
  final Function(SampleForm1QuestionnaireSectionState) onInit;
  final FocusNode? focusNode;
  const SampleForm1QuestionnaireSection({super.key, required this.onInit, this.focusNode});

  @override
  SampleForm1QuestionnaireSectionState createState() => SampleForm1QuestionnaireSectionState();
}

class SampleForm1QuestionnaireSectionState extends State<SampleForm1QuestionnaireSection> with SingleTickerProviderStateMixin {
  var questionList = [
    {
      "label": "每月大概多少次到酒吧消遣？",
      "label_zh_Hans": "每月大概多少次到酒吧消遣？",
      "label_en": "How often do you go to the bar per month?",
      "options": [
        {
          "label": "極少",
          "label_zh_Hans": "极少",
          "label_en": "Very rarely",
        },
        {
          "label": "1-3次",
          "label_zh_Hans": "1-3次",
          "label_en": "1-3 times",
        },
        {
          "label": "4-10次",
          "label_zh_Hans": "4-10次",
          "label_en": "4-10 times",
        },
        {
          "label": "10次或以上",
          "label_zh_Hans": "10次或以上",
          "label_en": "10 times or more",
        },
      ],
    },


    {
      "label": "你關注哪些酒類？",
      "label_zh_Hans": "你关注哪些酒类？",
      "label_en": "Which types of alcohol are you interested in?",
      "options": [
        {
          "label": "啤酒",
          "label_zh_Hans": "啤酒",
          "label_en": "Beer",
        },
        {
          "label": "葡萄酒",
          "label_zh_Hans": "葡萄酒",
          "label_en": "Wine",
        },
        {
          "label": "清酒",
          "label_zh_Hans": "清酒",
          "label_en": "Sake",
        },
        {
          "label": "威士忌",
          "label_zh_Hans": "威士忌",
          "label_en": "Whiskey",
        },
        {
          "label": "其他",
          "label_zh_Hans": "其他",
          "label_en": "Other",
        },
      ],
    },


    {
      "label": "平時購買酒類飲品的渠道？",
      "label_zh_Hans": "平时购买酒类饮品的渠道？",
      "label_en": "Where do you usually purchase alcoholic beverages?",
      "options": [
        {
          "label": "網店",
          "label_zh_Hans": "网店",
          "label_en": "Online shops",
        },
        {
          "label": "便利店",
          "label_zh_Hans": "便利店",
          "label_en": "Convenience stores",
        },
        {
          "label": "酒類專門店",
          "label_zh_Hans": "酒类专门店",
          "label_en": "Liquor stores",
        },
        {
          "label": "超級市場",
          "label_zh_Hans": "超级市场",
          "label_en": "Supermarkets",
        },
        {
          "label": "其他",
          "label_zh_Hans": "其他",
          "label_en": "Others",
        },
      ],
    },




    {
      "label": "你希望接收哪些資訊？",
      "label_zh_Hans": "你希望接收哪些资讯？",
      "label_en": "What kind of information would you like to receive?",
      "options": [
        {
          "label": "派對",
          "label_zh_Hans": "派对",
          "label_en": "Parties",
        },
        {
          "label": "品酒活動",
          "label_zh_Hans": "品酒活动",
          "label_en": "Wine tasting events",
        },
        {
          "label": "交友活動",
          "label_zh_Hans": "交友活动",
          "label_en": "Social events",
        },
        {
          "label": "酒類知識",
          "label_zh_Hans": "酒类知识",
          "label_en": "Alcohol knowledge",
        },
        {
          "label": "酒吧介紹",
          "label_zh_Hans": "酒吧介绍",
          "label_en": "Bar introductions",
        },
        {
          "label": "其他",
          "label_zh_Hans": "其他",
          "label_en": "Others",
        },
      ],
    },


    {
      "label": "你每月收入大概多少？",
      "label_zh_Hans": "你每月收入大概多少？",
      "label_en": "What is your approximate monthly income?",
      "options": [
        {
          "label": "港元 \$15000以下",
          "label_zh_Hans": "港元 \$15000以下",
          "label_en": "Below HKD \$15,000",
        },
        {
          "label": "港元 \$15000 - \$29999",
          "label_zh_Hans": "港元 \$15000 - \$29999",
          "label_en": "HKD \$15,000 - \$29,999",
        },
        {
          "label": "港元 \$30000 - \$49999",
          "label_zh_Hans": "港元 \$30000 - \$49999",
          "label_en": "HKD \$30,000 - \$49,999",
        },
        {
          "label": "港元 \$50000或以上",
          "label_zh_Hans": "港元 \$50000或以上",
          "label_en": "HKD \$50,000 or above.",
        },
      ],
    },
  ];











  final fse_q1 = FormMultipleSelectElement(isForceSingleSelect: true);
  final fse_q2 = FormMultipleSelectElement();
  final fse_q3 = FormMultipleSelectElement();
  final fse_q4 = FormMultipleSelectElement();
  final fse_q5 = FormMultipleSelectElement(isForceSingleSelect: true);

  List<FormItemElement> formItemList1 = [];

  bool isBusy = false;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero,() {
      setState(() {
        fse_q1.title = questionList[0]["label_en"] as String?;
        fse_q2.title = questionList[1]["label_en"] as String?;
        fse_q3.title = questionList[2]["label_en"] as String?;
        fse_q4.title = questionList[3]["label_en"] as String?;
        fse_q5.title = questionList[4]["label_en"] as String?;
        fse_q1.choices = (questionList[0]["options"] as List).map((e) {
          return UIListItemModel(e["label_en"], e["label"]);
        }).toList();
        fse_q2.choices = (questionList[1]["options"] as List).map((e) {
          return UIListItemModel(e["label_en"], e["label"]);
        }).toList();
        fse_q3.choices = (questionList[2]["options"] as List).map((e) {
          return UIListItemModel(e["label_en"], e["label"]);
        }).toList();
        fse_q4.choices = (questionList[3]["options"] as List).map((e) {
          return UIListItemModel(e["label_en"], e["label"]);
        }).toList();
        fse_q5.choices = (questionList[4]["options"] as List).map((e) {
          return UIListItemModel(e["label_en"], e["label"]);
        }).toList();



        formItemList1 = [
          FormItemElement(fse: fse_q1, hintText: fse_q1.title, focusNode: widget.focusNode),
          FormItemElement(fse: fse_q2, hintText: fse_q2.title, focusNode: widget.focusNode),
          FormItemElement(fse: fse_q3, hintText: fse_q3.title, focusNode: widget.focusNode),
          FormItemElement(fse: fse_q4, hintText: fse_q4.title, focusNode: widget.focusNode),
          FormItemElement(fse: fse_q5, hintText: fse_q5.title, focusNode: widget.focusNode),
        ];



        widget.onInit(this);

      });
    });

  }

  @override
  void dispose() {
    fse_q1.dispose();
    fse_q2.dispose();
    fse_q3.dispose();
    fse_q4.dispose();
    fse_q5.dispose();
    super.dispose();
  }


  dynamic doSummarizeQuestionnaire() {
    var dict = {};
    dict["q1"] = fse_q1.tv_any.value.join(",");
    dict["q2"] = fse_q2.tv_any.value.join(",");
    dict["q3"] = fse_q3.tv_any.value.join(",");
    dict["q4"] = fse_q4.tv_any.value.join(",");
    dict["q5"] = fse_q5.tv_any.value.join(",");
    return dict;
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[

        ...formItemList1.asMap().entries.map((entry) {
          return entry.value.render(formItemList1, entry.key);
        }).toList(),

        const SizedBox(
          height: 100,
        ),
      ],
    );
  }
}