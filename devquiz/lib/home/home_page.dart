import 'package:DevQuiz/challenge/challenge_page.dart';
import 'package:DevQuiz/core/core.dart';
import 'package:DevQuiz/home/home_controller.dart';
import 'package:DevQuiz/home/home_state.dart';
import 'package:DevQuiz/home/widgets/appbar/appbar_widget.dart';
import 'package:DevQuiz/home/widgets/level_button/level_button_widget.dart';
import 'package:DevQuiz/home/widgets/quiz_card/quiz_card_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// TODO: [done] Receber o level do QuizCard e filtar com os botões LevelButtonWidget

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final controller = HomeController();

  @override
  void initState() {
    super.initState();
    controller.getUser();
    controller.getQuizzes();

    controller.stateNotifier.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    if (controller.state == HomeState.loading) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.darkGreen),
          ),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBarWidget(
          user: controller.user!,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              SizedBox(
                height: 24,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  LevelButtonWidget(
                    label: "Fácil",
                    quizzers: controller.quizzes!,
                  ),
                  LevelButtonWidget(
                    label: "Médio",
                    quizzers: controller.quizzes!,
                  ),
                  LevelButtonWidget(
                    label: "Difícil",
                    quizzers: controller.quizzes!,
                  ),
                  LevelButtonWidget(
                    label: "Perito",
                    quizzers: controller.quizzes!,
                  ),
                ],
              ),
              SizedBox(
                height: 24,
              ),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 4,
                  mainAxisSpacing: 3,
                  children: controller.quizzes!
                      .map((e) => QuizCardWidget(
                            title: e.title,
                            level: e.level,
                            progress:
                                "${e.questionAnswered}/${e.questions.length}",
                            image: e.image,
                            percent: e.questionAnswered / e.questions.length,
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ChallengePage(
                                      questions: e.questions,
                                      title: e.title,
                                    ),
                                  ));
                            },
                          ))
                      .toList(),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}
