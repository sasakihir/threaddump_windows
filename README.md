# 概要

WindowsでJavaのスレッドダンプを取得する

# フォルダ構成

threaddump
|   README.txt
|   threaddump.bat
|
+---lib
|   \---PSTools
|           PsExec64.exe
|						その他exe
|
\---log

# 仕様

指定した間隔で、指定回数スレッドダンプを取得する。
スレッドダンプの取得にはJDKに含まれるjstack.exeを利用する。
プロセスIDは静的に設定が必要。
Windowsのセキュリティに起因してプロセスにアタッチできない場合は、SysinternalsのPSToolsを利用する (オプション)。

# 準備

- 上記フォルダ一式を適当なフォルダに配置する
- threaddump.batをエディタで開き、以下をセットする

```
set jdk_home=<JDKのインストールディレクトリ> ex. C:\Program Files\Java\jdk1.8.0_222
set waits=<スレッドダンプの取得間隔(秒)>
set times=<スレッドダンプの取得回数>
set pid=<JavaのプロセスID>
```

- 以下についてはオプショナル。jstackだけでスレッドダンプが取れないときに、psexecを利用するときに設定する

```
REM set pstools_dir=<PSToolsのインストールディレクトリ> ex. C:\app:\PSTools
```

# 動作確認1. 手動

- threaddump.batを管理者実行する
- スレッドダンプが正常に出力されたことを確認する
	- log配下にthreaddump.yyyymmddhhmmss.logとthreaddump.yyyymmddhhmmss.err.logが出力される
	- threaddump.yyyymmddhhmmss.logがスレッドダンプを、threaddump.yyyymmddhhmmss.err.logがスレッドダンプ取得時に発生したエラーを記録している
	- threaddump.yyyymmddhhmmss.logを開いてスレッド情報が出力されていればOK (通常、ファイルサイズは20KB以上となる)
	- スレッドダンプが出力されていない場合は、threaddump.yyyymmddhhmmss.err.logを開いて内容を確認する

# 動作確認2. タスクスケジューラから手動実行

- 以下手順でタスクスケジューラ登録をする

- タスクスケジューラ起動 (コントロールパネル > コンピュータの管理などから)
- タスクを作成するフォルダを開く (タスクスケジューラライブラリなど)
- 右ペインからタスクの作成をクリック

```
[全般タブ]
- 名前: 任意 (ex. threaddump)

セキュリティオプション
- タスクの実行時に使うユーザーアカウント: 作業用ユーザが指定されてるか確認
- ユーザーがログオンしているかどうかにかかわらず実行する、にチェック
- 最上位の特権で実行する、にチェック
他はデフォルトのままでOK

[トリガー]タブ
- タスクの開始: スケジュールに従う

設定
- 1回にチェック
- 開始: スレッドダンプ取得開始日時を指定
タイムゾーンにまたがって同期、はチェックしなくて大丈夫
他はデフォルトのままでOK

[操作]タブ
threaddump.batを指定

(登録完了)
OKをクリックして、タスク実行用に指定したユーザのパスワードを入力して閉じる
```

- タスクを実行する
- スレッドダンプが正常に出力されたことを確認する

# 本実行 (タスクスケジューラからスケジュール実行)

- タスクスケジューラで指定した日時を過ぎたあと、スレッドダンプが正常に出力されたことを確認する
