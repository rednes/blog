最近Webフレームワークをちゃんと勉強したくてDjango Girlsチュートリアルをやりました。

https://tutorial.djangogirls.org/ja/


Webシステムを作ったことはあるけど、Webフレームワークを触ったことない自分でもわかりやすくてよいチュートリアルでした。

2018年7月にAWS Fargateが東京リージョンに出てきた影響もあって、
AWSのコンテナサービスもいろいろ触って動かしています。

勉強がてらDjangoをElastic Container Service（ECS）上で動かす環境を構築しました。

AWS環境はCloudFormation（CFn）で作成しており、テンプレートはGitHubで公開しています。

https://github.com/rednes/django-tutorial

## AWS構成図

今回構築するAWSの構成はこんな感じです。
Elastic Load Balancerを前段に置いて、動的ポートマッピングを利用してEC2上で動作しているECSのタスクへアクセスできるようにしています。

![AWS構成図](https://raw.githubusercontent.com/rednes/django-tutorial/img/img/ecs.png)

## Elastic Container Repository（ECR）の作成

CFnテンプレート( [cloudformation/template-for-ecr.yml](https://github.com/rednes/django-tutorial/blob/master/cloudformation/template-for-ecr.yml) )を使用して、CFnスタックを作成してECRを構築します。

CFn動作完了後に、ECRへのpushコマンドがアウトプットされるようになっています。

AWSのデフォルトプロファイルを環境変数に設定したうえで、ECRのプッシュコマンドを実行すると、ECRにDockerイメージが構築できます。

![CFnForECR](https://raw.githubusercontent.com/rednes/django-tutorial/img/img/cfn-for-ecr.png)

```
$ export AWS_DEFAULT_PROFILE=<<YOUR PROFILE>>
$ <<PushCommandsForEcrをコピー＆ペーストして実行>>
```

## Elastic Container Service（ECS）の作成

CFnテンプレート( [cloudformation/template.yml](https://github.com/rednes/django-tutorial/blob/master/cloudformation/template.yml) )を使用して、CFnスタックを作成してECSほか必要な環境を構築します。

CFn動作完了後に、ELBのURLがアウトプットされるようになっています。

URLにアクセスしてDjangoの動作を確認できます。

![CFn](https://raw.githubusercontent.com/rednes/django-tutorial/img/img/cfn.png)

## 動作確認

URLにアクセスするとDjangoが動いていることを確認できます。

![web01](https://raw.githubusercontent.com/rednes/django-tutorial/img/img/web01.png)

URLの後ろに `admin/` を追記してアクセスするとDjango管理サイトが開きます。
ユーザー名とパスワードは以下の通り設定しています。

- USER: test
- PASS: test-password

![](https://raw.githubusercontent.com/rednes/django-tutorial/img/img/web02.png)

ログインしてトップページ右上の `+` ボタンをクリックするとブログの投稿ができます。

![](https://raw.githubusercontent.com/rednes/django-tutorial/img/img/web03.png)

投稿するとトップページに反映されますが、SQLiteで動作しているため、ECSのタスクが止まると投稿したデータはすべて消えてしまいます。

![](https://raw.githubusercontent.com/rednes/django-tutorial/img/img/web04.png)

## 所感

とりあえず、AWS ECSを利用してDjangoを動かすことができました。
ECSの概念は動かして見ないとわからないところが多いなーと感じたので、ガシガシ動かしていきたいです。

本番運用で使うには次のようなことを考えていかないといけませんが、とりあえず動かせるところまでいけたので満足です。

- RDSとの接続
- ログの保存をどうしていくか
- 運用監視
- エラー発生時のハンドリング
