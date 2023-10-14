import json
import sys
import csv
import os
import copy
from googletrans import Translator, LANGUAGES


def load_text_file(filename):
    with open(filename, "r", encoding="utf-8") as file:
        return file.read().splitlines()


def load_existing_json_file(input_path, output_path, base_text):
    if os.path.exists(input_path):
        with open(input_path, "r") as json_file:
            loaded_data = json.load(json_file)
            return [
                (list(item.keys())[0], list(item.values())[0]) for item in loaded_data
            ]

    if not os.path.exists(output_path):
        return []

    # データがない場合は、textをもとに作成する
    text_data = load_text_file(output_path)
    return [(base, text) for base, text in zip(base_text, text_data)]


def save_json_data(data, filename):
    # タプルのリストをJsonに保存する形式に変換
    json_data = [{key: value} for key, value in data]
    json_str = (
        "[\n"
        + ",\n".join("    " + json.dumps(d, separators=(",", ": ")) for d in json_data)
        + "\n]"
    )

    with open(filename, "w") as file:
        file.write(json_str)


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
    base_text_data = load_text_file(f"{output_dir}{base_code}.txt")

    # Json形式のデータと探索用のdicを作成
    base_json_data = [(item, item) for item in base_text_data]

    # Jsonファイルのディレクトリ
    input_dir = "source/label_keys/"
    save_json_data(base_json_data, f"{input_dir}{base_code}.json")

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
        input_path = f"{input_dir}{code}.json"
        output_path = f"{output_dir}{code}.txt"

        # すでに存在するデータを取得する
        existing_data = load_existing_json_file(
            input_path,
            output_path,
            base_text_data,
        )

        data_dict = {t[0]: idx for idx, t in enumerate(existing_data)}

        translated_data = copy.deepcopy(base_json_data)
        for idx, value in enumerate(base_text_data):
            if (
                value in data_dict
                and "失敗しました!:" not in existing_data[data_dict[value]][1]
                and value not in target
            ):
                translated_data[idx] = existing_data[data_dict[value]]
            else:
                try:
                    translated_item = translator.translate(
                        value,
                        src=base_code,
                        dest=code,
                    ).text
                    translated_data[idx] = (value, translated_item)
                except Exception as e:
                    print(f"{value}の{code}での翻訳中に例外が発生しました。: {e}")
                    translated_data[idx] = (value, f"失敗しました!: {e}")

        # Jsonデータを更新する
        save_json_data(translated_data, input_path)

        # ファイルに書き込む
        text_data = [value for _, value in translated_data]
        with open(output_path, "w", encoding="utf-8") as out_file:
            for value in text_data:
                out_file.write(f"{value}\n")

        print(f"{code}.text: {language}の作成が完了しました。")
        count += 1
        print(f"現在 {count}/{max_len}")

    print("翻訳が完了しました。")


if __name__ == "__main__":
    main()
