import 'package:DevQuiz/challenge/challenge_controller.dart';
import 'package:DevQuiz/challenge/widgets/next_button/next_button_widget.dart';
import 'package:DevQuiz/challenge/widgets/question_indicator/question_indicator_widget.dart';
import 'package:DevQuiz/challenge/widgets/quiz/quiz_widget.dart';
import 'package:DevQuiz/result/result_page.dart';
import 'package:DevQuiz/shared/models/question_model.dart';
import 'package:flutter/material.dart';

class ChallengePage extends StatefulWidget {
  final List<QuestionModel> questions;
  final String title;

  ChallengePage({
    Key? key,
    required this.questions,
    required this.title,
  }) : super(key: key);

  @override
  _ChallengePageState createState() => _ChallengePageState();

  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _ChallengePageState extends State<ChallengePage> {
  final controller = ChallengeController();
  final pageController = PageController();

  void nextPage() {
    if (controller.currentPage < widget.questions.length)
      pageController.nextPage(
          duration: Duration(milliseconds: 500), curve: Curves.decelerate);
  }

  void onSelected(bool value) {
    if (value) {
      controller.numCorrectAnswers++;
    }
    nextPage();
  }

  @override
  void initState() {
    pageController.addListener(() {
      controller.currentPage = pageController.page!.toInt() + 1;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(86),
        child: SafeArea(
          top: true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BackButton(),
              ValueListenableBuilder<int>(
                valueListenable: controller.currentPageNotifier,
                builder: (context, value, _) => QuestIndicatorWidget(
                  currentPage: value,
                  length: widget.questions.length,
                ),
              ),
            ],
          ),
        ),
      ),
      body: PageView(
          physics: NeverScrollableScrollPhysics(),
          controller: pageController,
          children: widget.questions
              .map((e) => QuizWidget(
                    question: e,
                    onSelected: onSelected,
                  ))
              .toList()),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: ValueListenableBuilder<int>(
            valueListenable: controller.currentPageNotifier,
            builder: (context, value, _) => Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                if (value < widget.questions.length)
                  Expanded(
                      child: NextButtonWidget.white(
                    label: "Pular",
                    onTap: nextPage,
                  )),
                if (value == widget.questions.length)
                  Expanded(
                      child: NextButtonWidget.green(
                    label: "Confirmar",
                    onTap: () {
                      Future.delayed(Duration(milliseconds: 400))
                          .then((_) => Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ResultPage(
                                        title: widget.title,
                                        numCorrectAnwsers:
                                            controller.numCorrectAnswers,
                                        lengthQuiz: widget.questions.length,
                                      ))));
                    },
                  )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// TODO: (BUG) ADICIONAR UM FUTURE.DELAYED NO NAVIGATOR PUSH DO CONFIRMAR PARA
// RECEBER O VALOR DAS RESPOSTAS CERTAS
