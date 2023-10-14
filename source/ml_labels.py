import json
import sys
import csv
import os
from googletrans import Translator, LANGUAGES


def load_text_file(filename):
    with open(filename, "r", encoding="utf-8") as file:
        return file.read().splitlines()


def load_existing_json_file(input_path, output_path, base_text):
    if os.path.exists(input_path):
        with open(input_path, "r") as json_file:
            return json.load(json_file)

    if not os.path.exists(output_path):
        return {}

    # データがない場合は、textをもとに作成する
    text_data = load_text_file(output_path)
    return {base: text for base, text in zip(base_text, text_data)}


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
    with open("source/localizations.csv", mode="r", encoding="utf-8") as arb_file:
        reader = csv.reader(arb_file, delimiter="\t")
        for rows in reader:
            # LANGUAGES に含まれているか確認
            if rows[0] in LANGUAGES:
                locales[rows[0]] = rows[1]
            else:
                print(f"{rows[0]}: {rows[1]}は翻訳できません。")

    print("localizations.csvファイルの読み込みが完了しました。")

    # 出力先ディレクトリを指定
    output_dir = "assets/ml/"

    # 基本とするファイルを読み込み
    base_code = "en"
    base_text_data = load_text_file(f"{output_dir}/{base_code}.txt")

    # Json形式のデータに変換
    base_json_data = {item: item for item in base_text_data}

    # Jsonファイルのディレクトリ
    input_dir = "source/label_keys/"
    with open(f"{input_dir}/{base_code}.json", "w") as json_file:
        json.dump(base_json_data, json_file, indent=4, ensure_ascii=False)

    print(f"ml/{base_code}.txtファイルの読み込みが完了しました。")

    max_len = len(locales)
    count = 0
    print("翻訳を開始します。")

    # トランスレータの初期化
    translator = Translator()

    # 各言語で翻訳
    for code, language in locales.items():
        if code == base_code:
            continue
        input_path = f"{input_dir}/{code}.json"
        output_path = f"{output_dir}/{code}.txt"

        # すでに存在するデータを取得する
        existing_data = load_existing_json_file(
            input_path,
            output_path,
            base_text_data,
        )

        translated_data = {}
        for key, value in base_json_data.items():
            if (
                key in existing_data
                and "失敗しました!:" not in existing_data[key]
                and key not in target
            ):
                translated_data[key] = existing_data[key]
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

        merged_data = merge_translations(existing_data, translated_data, target)

        ordered_data = {
            key: merged_data[key] for key in base_json_data if key in merged_data
        }

        # Jsonデータを更新する
        with open(input_path, "w") as file:
            json.dump(ordered_data, file, indent=4, ensure_ascii=False)

        # ファイルに書き込む
        text_data = [value for _, value in ordered_data.items()]
        with open(output_path, "w", encoding="utf-8") as out_file:
            for value in text_data:
                out_file.write(f"{value}\n")

        print(f"{code}.text: {language}の作成が完了しました。")
        count += 1
        print(f"現在 {count}/{max_len}")

    print("翻訳が完了しました。")


if __name__ == "__main__":
    main()
