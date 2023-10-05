import json
import csv
import os
from googletrans import Translator, LANGUAGES

current_directory = os.getcwd()
print(f"pythonでの現在のディレクトリ: {current_directory}")

# 出力先ディレクトリを指定
output_dir = "assets/ml/"

# ファイルの読み込み
with open(f"{output_dir}en.txt", "r") as label_file:
    label_data = label_file.read().splitlines()

print("ml/en.txtファイルの読み込みが完了しました。")

# トランスレータの初期化
translator = Translator()

# CSVファイルからlocalesの情報を読み込む
locales = {}
with open("source/localizations.csv", mode="r", encoding="utf-8") as arb_file:
    reader = csv.reader(arb_file, delimiter="\t")
    for rows in reader:
        # LANGUAGES に含まれているか確認
        if rows[0] in LANGUAGES:
            locales[rows[0]] = rows[1]
        else:
            print(f"{rows[0]}: {rows[1]}は翻訳できません。")

print("localizations.csvファイルの読み込みが完了しました。")


max = len(locales)
count = 0
print("翻訳を開始します。")
# 各言語で翻訳
for code, language in locales.items():
    if code == "en":
        continue
    output_path = f"{output_dir}/{code}.txt"

    translated_data = []
    for value in label_data:
        try:
            translated_value = translator.translate(value, src="en", dest=code).text
            translated_data.append(translated_value)
        except Exception as e:
            print(f"{value}の{code}での翻訳中に例外が発生しました。: {e}")
            translated_data.append(f"失敗しました!: {e}")

    # ファイルに書き込む
    with open(output_path, "w", encoding="utf-8") as out_file:
        for value in translated_data:
            out_file.write(f"{value}\n")

    print(f"{code}.text: {language}の作成が完了しました。")
    count += 1
    print(f"現在 {count}/{max}")

print("翻訳が完了しました。")
