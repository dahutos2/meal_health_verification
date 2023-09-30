echo "現在のディレクトリ: $(pwd)"

# 仮想環境のディレクトリ名
VENV_DIR="myenv"

# 仮想環境が存在しない場合、作成する
if [ ! -d "$VENV_DIR" ]; then
    python3 -m venv $VENV_DIR
    source $VENV_DIR/bin/activate
    pip install -r source/requirements.txt
else
    source $VENV_DIR/bin/activate
fi

echo "仮想環境を活性化しました。"

# Pythonスクリプトを実行
echo "Pythonスクリプトを実行します。"

python3 -u source/localizations.py

# 仮想環境を非アクティブにする
deactivate
