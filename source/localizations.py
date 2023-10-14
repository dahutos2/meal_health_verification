import json
import csv
import os
from googletrans import Translator, LANGUAGES
import sys


def load_file(filename):
    if os.path.exists(filename):
        with open(filename, "r") as json_file:
            return json.load(json_file)
    return {}


def merge_translations(existing_data, new_data, target):
    for key, value in new_data.items():
        if (
            key not in existing_data
            or "失敗しました!:" in existing_data[key]
            or key in target
        ):
            existing_data[key] = value
    return existing_data


def main():
    # オプション
    # -o 引数として指定した 変数を上書きする
    print(f"引数: {sys.argv}")
    target = []
    if len(sys.argv) > 2 and sys.argv[1] == "-o":
        for arg in sys.argv[2:]:
            target.append(arg)

    print(f"オプション -o: {target}")

    current_directory = os.getcwd()

    print(f"pythonでの現在のディレクトリ: {current_directory}")

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

    max_len = len(locales)
    count = 0
    print("翻訳を開始します。")

    # トランスレータの初期化
    translator = Translator()

    # 出力先ディレクトリを指定
    output_directory = "lib/l10n/"

    # 基本とするファイルを読み込み
    base_code = "ja"
    base_data = load_file(f"{output_directory}/{base_code}.arb")

    print(f"{base_code}.arbファイルの読み込みが完了しました。")

    for code, language in locales.items():
        if code == base_code:
            continue
        output_path = f"{output_directory}/{code}.arb"

        # すでに存在するデータを取得する
        existing_data = load_file(output_path)

        translated_data = {}
        for key, value in base_data.items():
            if (
                key in existing_data
                and "失敗しました!:" not in existing_data[key]
                and key not in target
            ):
                translated_data[key] = existing_data[key]
            elif isinstance(value, dict) and "description" in value:
                try:
                    translated_description = translator.translate(
                        value["description"],
                        src=base_code,
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
                        src=base_code,
                        dest=code,
                    ).text
                except Exception as e:
                    print(f"{key}の{code}での翻訳中に例外が発生しました。: {e}")
                    translated_data[key] = f"失敗しました!: {e}"

        translated_data["@@locale"] = code

        merged_data = merge_translations(existing_data, translated_data, target)

        ordered_data = {
            key: merged_data[key] for key in base_data if key in merged_data
        }

        with open(output_path, "w") as file:
            json.dump(ordered_data, file, indent=4, ensure_ascii=False)

        print(f"{code}.arb: {language}の作成が完了しました。")
        count += 1
        print(f"現在 {count}/{max_len}")

    print("翻訳が完了しました。")


if __name__ == "__main__":
    main()
