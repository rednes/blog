
お仕事やら趣味やらでAWS Lambdaを使っています。

そんなLambdaを使っている現場で見つけた、ちょっとわかりにくかったLambdaの仕様をクイズ形式でご紹介いたします。


## Q1. 何故か動かないLambda

次の画面の様に、CloudWatch Eventsのcronスケジュール式がトリガーになっています。
しかし、該当の時間になってもLambdaが動いていません。なぜでしょう？

![lambda1](https://raw.githubusercontent.com/rednes/blog/master/items/201810_LambdaQuiz/image/lambda1.png)


（※回答は下へスクロールしていってください）

↓

↓

↓

↓

↓

↓

↓

↓

↓

↓

↓

↓

↓

↓

↓


**A1. CloudWatch Eventsの状態が無効だから**

正解はCloudWatch Eventsの状態が無効だからです。
これはLambdaの画面からわかりません。
CloudWatch Eventsの状態は、CloudWatch Eventsの画面で確認しましょう。

![lambda1](https://raw.githubusercontent.com/rednes/blog/master/items/201810_LambdaQuiz/image/cwe.png)


## Q2. 何故か動くLambda

次の画面の様に、トリガーがセットされていないLambdaがあります。

![lambda1](https://raw.githubusercontent.com/rednes/blog/master/items/201810_LambdaQuiz/image/lambda2.png)

しかし、CloudWatch Logsを見るとこのLambdaが定期的に動いているように見えます。なぜでしょう？

![lambda1](https://raw.githubusercontent.com/rednes/blog/master/items/201810_LambdaQuiz/image/cwl.png)

（※回答は下へスクロールしていってください）

↓

↓

↓

↓

↓

↓

↓

↓

↓

↓

↓

↓

↓

↓

↓

**A2. StepFunctionsが使っているから**

正解はStepFunctionsが使っているからです。

StepFunctionsでLambdaを動かす場合、Lambdaのトリガーに何も表示されないので、誰がLambdaを実行しているのかLambdaの画面からわからなくなります。注意しましょう。

![lambda1](https://raw.githubusercontent.com/rednes/blog/master/items/201810_LambdaQuiz/image/stepfunctions.png)


「いやいや、こういう場合もLambdaのトリガーに表示されないよ！」といった、他の答えを知っている方は教えていただけると嬉しいです！

