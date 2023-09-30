import json
import csv
import os
from googletrans import Translator, LANGUAGES

current_directory = os.getcwd()
print(f"pythonでの現在のディレクトリ: {current_directory}")

# 出力先ディレクトリを指定
output_directory = "lib/l10n/"


def load_existing_file(filename):
    with open(filename, "r", encoding="utf-8") as file:
        return json.load(file)


def merge_translations(existing_data, new_data):
    for key, value in new_data.items():
        if key not in existing_data or "失敗しました!:" in existing_data[key]:
            existing_data[key] = value
    return existing_data


# ファイルの読み込み
with open("lib/l10n/ja.arb", "r") as file:
    data = json.load(file)

print("ja.arbファイルの読み込みが完了しました。")

# トランスレータの初期化
translator = Translator()

# CSVファイルからlocalesの情報を読み込む
locales = {}
with open("source/localizations.csv", mode="r", encoding="utf-8") as file:
    reader = csv.reader(file, delimiter="\t")
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
for code, language in locales.items():
    output_path = f"{output_directory}/{code}.arb"

    # すでに存在してるかを確認する
    if os.path.exists(output_path):
        existing_data = load_existing_file(output_path)
    else:
        existing_data = {}

    translated_data = {}
    for key, value in data.items():
        if key in existing_data and "失敗しました!:" not in existing_data[key]:
            translated_data[key] = existing_data[key]
        elif isinstance(value, dict) and "description" in value:
            try:
                translated_description = translator.translate(
                    value["description"],
                    src="ja",
                    dest=code,
                ).text
                translated_data[key] = {"description": translated_description}
            except Exception as e:
                print(f"{key}の{code}での翻訳中に例外が発生しました。: {e}")
                translated_data[key] = f"失敗しました!: {e}"
        elif key.startswith("@") or "{" in value and "}" in value:
            translated_data[key] = value
        else:
            try:
                translated_data[key] = translator.translate(
                    value,
                    src="ja",
                    dest=code,
                ).text
            except Exception as e:
                print(f"{key}の{code}での翻訳中に例外が発生しました。: {e}")
                translated_data[key] = f"失敗しました!: {e}"

    translated_data["@@locale"] = code

    merged_data = merge_translations(existing_data, translated_data)

    with open(output_path, "w") as file:
        json.dump(merged_data, file, indent=4, ensure_ascii=False)

    print(f"{code}.arb: {language}の作成が完了しました。")
    count += 1
    print(f"現在 {count}/{max}")

print("翻訳が完了しました。")
