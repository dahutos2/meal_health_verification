.PHONY: \
	run l10n localize localize_o ml ml_o assets icon 

# flutterを実行
run:
	flutter run --release

# .arbで定義した文言を使用するためのコードを自動作成
l10n:
	flutter gen-l10n

# arbファイル生成
localize:
	bash sh/localizations.sh

# arbファイル生成（指定キー上書き）
# (例) make localize_o LANG="ja en"
localize_o:
	bash sh/localizations.sh --overwrite $(LANG)

## ML ラベル生成
ml:
	bash sh/ml_labels.sh.sh

## ML ラベル生成（指定キー上書き）
# (例) make ml_o LANG="ja en"
ml_o:
	bash sh/ml_labels.sh.sh --overwrite $(LANG)

# assets内のファイルにアクセスするコードを自動生成
assets:
	flutter pub run build_runner build --delete-conflicting-outputs

# アプリにアイコンを設定する
# ※生成される画像の大きさが誤っている場合があります
icon:
	flutter pub run flutter_launcher_icons