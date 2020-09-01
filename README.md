# 概要

WindowsでJavaのスレッドダンプを取得する

# フォルダ構成

```
threaddump_windows  
|   README.md  
|   threaddump.bat  
|  
\---log  
        threaddump_20200901223005.log  
        threaddump_20200901223005.err.log
```

logフォルダ以下は、バッチ実行時に生成される

# 仕様

- 指定した間隔で、指定回数スレッドダンプを取得する。
- スレッドダンプの取得にはJDKに含まれるjstack.exeを利用する。
- プロセスIDは静的に設定が必要。
- Windowsのセキュリティに起因してプロセスにアタッチできない場合は、SysinternalsのPSToolsを利用する (オプション)。

# 前提

- JDKをインストール済み
- PSToolsをインストール済み (オプション)

# 準備

- threaddump.batを適当なフォルダに配置する
- threaddump.batをエディタで開き、以下をセットする

```
set jdk_home=<JDKのインストールディレクトリ> ex. C:\Program Files\Java\jdk1.8.0_222  
set waits=<スレッドダンプの取得間隔(秒)>  
set times=<スレッドダンプの取得回数>  
set pid=<JavaのプロセスID>
```

- PSToolsを利用する場合 (オプション)
```
REM set pstools_dir=<PSToolsのインストールディレクトリ> ex. C:\app:\PSTools
```

# 動作確認1. 手動

- threaddump.batを管理者実行する
- log配下にファイルが2つ出力されたことを確認する
- ファイルの説明
	- threaddump.yyyymmddhhmmss.log: スレッドダンプ
	- threaddump.yyyymmddhhmmss.err.log: スレッドダンプ取得時に発生したエラー
- threaddump.yyyymmddhhmmss.logを開いてスタックトレースが出力されていればOK
	- 通常、ファイルサイズは20KB以上となるため、それ以下では取得できていない可能性が高い
- スタックトレースが出力されていない場合は、threaddump.yyyymmddhhmmss.err.logを開いてエラーを確認する

# 動作確認2. タスクスケジューラから手動実行

- 以下手順でタスクスケジューラ登録をする

- タスクスケジューラ起動 (コントロールパネル > コンピュータの管理などから)
- タスクを作成するフォルダを開く (タスクスケジューラライブラリなど)
- 右ペインからタスクの作成をクリック

```
[全般タブ]  
・名前: 任意 (ex. threaddump)  
  
セキュリティオプション  
・タスクの実行時に使うユーザーアカウント: 作業用ユーザが指定されてるか確認  
・ユーザーがログオンしているかどうかにかかわらず実行する、にチェック  
・最上位の特権で実行する、にチェック  
他はデフォルトのままでOK  
  
[トリガー]タブ  
・タスクの開始: スケジュールに従う  
  
設定  
・1回にチェック  
・開始: スレッドダンプ取得開始日時を指定  
タイムゾーンにまたがって同期、はチェックしなくて大丈夫  
他はデフォルトのままでOK  
  
[操作]タブ  
threaddump.batを指定  
  
(登録完了)  
OKをクリックして、タスク実行用に指定したユーザのパスワードを入力して閉じる  
```

- タスクを手動実行する
- スレッドダンプが出力されたことを確認する

# 本実行 (タスクスケジューラからスケジュール実行)

- タスクスケジューラで指定した日時を過ぎたあと、スレッドダンプが正常に出力されたことを確認する

# PSToolsの利用 (オプション)

- PSToolsをDLし、zipを解凍して適当なフォルダに配置する
	- https://docs.microsoft.com/en-us/sysinternals/downloads/pstools
- threaddump.batの`set pstools_dir`を設定して、コメントアウトを外す
- `REM psexec -accepteula ..`のコメントアウトを外す
- 手動実行, タスクスケジューラでの手動実行で動作確認を行う
