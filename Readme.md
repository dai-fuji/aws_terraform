# Railsアプリケーションの実行環境構築
<br>

## 構成図
<br>

![構成図](/infrastructure_diagram.jpg)
<br>
<br>

## リソース一覧
<br>

- VPC
- パブリックサブネット
- プライベートサブネット
- インターネットゲートウェイ
- ルートテーブル
- セキュリティーグループ
- ALB
- EC2
- RDS
- S3
<br>
<br>

## リソース作成手順
<br>

0. terraformのインストール、git clone（詳細は割愛）

1. IAMユーザーをアクセスキーありで作成し、認証情報を取得する

2. 認証情報をAWS CLIに登録する
```
$ aws config --profile 任意の名前
AWS Access Key ID [None]: XXXXXXXXXXXXXXXX
AWS Secret Access Key [None]: XXXXXXXXXXXXXXXX
Default region name [None]: ap-northeast-1
Default output format [None]: json
```
<br>

3. main.tfのproviderに2で登録したプロファイル名を入力
```
provider "aws" {
  profile = "プロファイル名"
}
```
<br>

4. DBのユーザーとパスワードを格納する.tfファイルを作成し、以下を記述
```
variable "db_user" {
  default = "xxxxxxxx"
}

variable "db_password" {
  default = "xxxxxxxx"
}

#ファイル名は「xxxxxxxsecret.tf」とする
```

5. gitignoreを編集して特定のファイルを管理対象外にする
```
#監視不要
/.terraform
*.state #認証情報を含みます
*.backup #認証情報を含みます
*.hcl

#認証情報
*secret.tf #手順5で作成したファイル名
```

<br>

6. terraformコマンドを実行

```
$ terraform init #初期化

$ terraform plan #差分出力

$ terraform apply #リソースを作成

$ terraform destroy #リソースを削除
```