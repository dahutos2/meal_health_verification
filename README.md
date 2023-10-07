# Flutter プロジェクト: 健康度ベースの料理推薦アプリ
## 開発ルール
- `master` ブランチへの直接のプッシュやマージは禁止。
- マージはプルリクエストを通じてのみ許可。
- プルリクエスト作成時には自動テストと静的解析が行われる。
## アーキテクチャ概要
DDD ✖️ オニオンアーキテクチャ
![image](./source/images/onion_architecture.avif)
### DI (Dependency Injection)
- **di_container.dart**: DIコンテナの定義
### Domain Layer
- **exception**: カスタム例外やリソースに関する定義
- **extensions**: カスタム拡張メソッドの集まり
- **model**: ドメインオブジェクトの定義
- **repository**: リポジトリインターフェイスの定義
- **service**: ドメインサービスの定義
### Infrastructure Layer
- **api**: 外部サービスやデータアクセスのヘルパー
- **repository_sql**: SQLベースのリポジトリの実装
### L10n (Localization)
- **arb files**: 多言語対応のためのARBファイル
### Presentation Layer
- **view**: UIの実装
  - **extensions**: UIの拡張メソッド
  - **page**: 画面のコンポーネント
  - **share**: 共有されるUIリソース
  - **widget**: 再利用可能なUIコンポーネント
- **view_model**: UIのロジックや状態を管理する層
  - **data**: 画面に表示するデータクラスの定義
  - **notifier**: 状態管理のためのNotifierの定義

### Use Case Layer
- **dto**: Data Transfer Objectsの定義。
- **use_cases**: ビジネスロジックの定義。

### 補足
`index.dart`ファイルは各ディレクトリの内容を統合的にインポートするためのファイルです。

## 機能概要
### おすすめ料理機能
- ユーザーの健康状態を考慮して、3つのおすすめ料理を表示。
- 適切な時間に注意表示と、撮影ページへの遷移オプション。
### 料理撮影と健康度算出
- 料理の撮影と、画像認識技術を利用した健康度算出。
- 非同期処理を使用してユーザーエクスペリエンスを向上。
#### 健康度算出ロジック
画像認識のモデルを用いて料理の画像を特定のラベルに分類します。<br>
この分類に関する詳細や計算方法は以下のとおりです：

<details>
  <summary>詳細を見る</summary>

  1. **度数の算出**: <br>
  画像認識モデルが料理の画像を特定のラベルに分類し、それに基づいて度数を算出します。<br>
  数式として表すと以下のようになります。
     \[
     D = \frac{\text{分類のindex番号}}{\text{分類数} - 1}
     \]
     ここで、\( D \) は料理の度数を表します。

  2. **栄養価の配置**: <br>
  栄養価が近い料理は、index番号が近くなるように配置されています。

  3. **健康度の算出**: <br>
  一週間の度数の記録のばらつきが大きいほど、健康度は高くなります。<br>
  健康度 \( H \) は度数の標準偏差 \( \sigma(D) \) を使用して以下のように計算されます。
     \[
     H = CDF(\sigma(D))
     \]
     ここで、\( CDF \) は累積分布関数を表し、結果は0 ~ 1の範囲でスケールされます。

</details>

### 健康度グラフ表示
- 過去一週間の健康度をグラフ形式で表示。
- 過去のデータとの比較が可能。
- 各日の食事内容と時刻も併記。
### 健康度算出ロジック
- 料理の種類や栄養バランスを基に度数計算。
- 度数の標準偏差を基に健康度を0〜100の範囲で正規化。
## 技術領域
- **`camera`**: アプリ内でのカメラ操作をサポート。
- **`google_mlkit_object_detection`**: 料理の画像認識技術の実装に使用。
- **`fl_chart`**: 健康度のグラフ表示に利用。
- **`tflite_flutter`**: TensorFlow LiteをFlutterで利用するためのサポート。
## 追加情報
- 10カ国語に対応
- 多言語対応ツールとしてPythonを利用。
## コマンド一覧
- [sh](./sh/)フォルダのコマンド
- アプリアイコン設定
- コードの自動生成
- 多言語の変更の適応
- アプリ内の文言の多言語化
- 画像のラベルの多言語化
## バージョン管理
### バージョン
- flutter 3.13.4
- dart 3.1.2
### 管理方法
**[`asdf`](https://asdf-vm.com/)を使用する**

`asdf`はプログラミング言語やツールのバージョン管理を行うためのツールであり、<br>
複数の言語やツールのバージョンを1つのフレームワークで管理することができます。`asdf`を使用すると、<br>
プロジェクトごとに異なるバージョンの言語やツールを使うことが容易になります。

Flutterのバージョン管理に`asdf`を使用する場合、以下の手順でセットアップすることができます。
#### 1. `asdf`のインストール
まず、`asdf`自体をインストールします。多くの場合、Homebrewを使用してMacにインストールします。
```bash
brew install asdf
```
#### 2. シェルの設定
使用しているシェル（bash, zshなど）の設定ファイル（`.bashrc`, `.zshrc`など）に以下を追加します。
```bash
. $(brew --prefix asdf)/libexec/asdf.sh
```
#### 3. Flutter/Dartプラグインの追加
`asdf`でFlutterのバージョン管理を行うために、Flutterプラグインを追加します。
```bash
asdf plugin-add flutter
asdf plugin-add dart
```
#### 4. jqコマンドの追加
jqコマンドは、JSONデータから目的の情報を抽出するのに便利な機能を提供しています。なのでjqを追加します。
```bash
brew install jq
```
#### 5. Flutter/Dartのバージョンのインストール
必要なバージョンのFlutterとDartをインストールします。
```bash
asdf install flutter 3.13.4
asdf install dart 3.1.2
```
#### 6. グローバルまたはローカルでのバージョンの設定
インストールしたFlutterとDartのバージョンを、グローバルまたはプロジェクトごとにローカルで設定します。
- グローバルでの設定：
```bash
asdf global flutter 3.13.4
asdf global dart 3.1.2
```
- ローカル（プロジェクトごと）での設定：
```bash
asdf local flutter 3.13.4
asdf local dart 3.1.2
```
ローカルでの設定を行うと、そのディレクトリに`.tool-versions`というファイルが作成され、<br>
そのプロジェクトで使用するFlutterのバージョンが指定されます。
#### 7. 他のバージョンのインストールと切り替え
必要に応じて他のバージョンのFlutterをインストールし、<br>
`asdf global`や`asdf local`コマンドを使用してバージョンを切り替えることができます。
#### 8. IDEの設定
##### VS Code
Code -> Preferences -> Settingsに移動する<br>
Dart: Flutter Sdk Pathsの箇所で「Add Item」ボタンをクリックして、以下を追加する<br>
`/Users/{ユーザー名}/.asdf/installs/flutter/{flutterバージョン}`
##### Android Studio
Settings > Languages & Frameworks > Flutter > Flutter SDK Pathに以下を設定する
Settings > Languages & Frameworks > Dart > Dart SDK Pathに以下を設定する<br>
```
/Users/{ユーザー名}/.asdf/installs/flutter/{flutterバージョン}
/Users/{ユーザー名}/.asdf/installs/dart/{dartバージョン}
```