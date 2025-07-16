# R環境セットアップスクリプト
# 作成日: 2025-07-16

# このスクリプトは一度だけ実行してください
# プロジェクトの初期設定を行います

# 必要パッケージのインストール ----
required_packages <- c(
  "tidyverse",    # データ操作・可視化
  "here",         # パス管理
  "renv",         # パッケージ管理
  "janitor",      # データクリーニング
  "skimr",        # データ概要
  "conflicted",   # パッケージ競合回避
  "rmarkdown",    # レポート作成
  "knitr",        # 文書作成
  "DT",           # インタラクティブテーブル
  "plotly",       # インタラクティブグラフ
  "corrplot",     # 相関行列の可視化
  "GGally",       # 多変量可視化
  "broom",        # モデル結果の整理
  "glue"          # 文字列操作
)

# パッケージがインストールされていなければインストール
new_packages <- required_packages[!(required_packages %in% installed.packages()[,"Package"])]
if(length(new_packages)) install.packages(new_packages)

# renvの初期化
if (!file.exists("renv.lock")) {
  options(renv.consent = TRUE)
  renv::init()
  cat("renv環境を初期化しました\n")
}

# プロジェクト設定の確認
cat("プロジェクト設定の確認:\n")
cat("- 作業ディレクトリ:", getwd(), "\n")
cat("- Rバージョン:", R.version.string, "\n")
cat("- 主要パッケージ:\n")
for (pkg in required_packages) {
  if (requireNamespace(pkg, quietly = TRUE)) {
    cat("  ✓", pkg, "\n")
  } else {
    cat("  ✗", pkg, "(not installed)\n")
  }
}

# データセット情報の表示
cat("\nデータセット情報:\n")
datasets <- c("mydata")
for (dataset in datasets) {
  path <- here::here("data", "raw", dataset)
  if (dir.exists(path)) {
    cat("  ✓", dataset, "フォルダが存在します\n")
  } else {
    cat("  !", dataset, "フォルダにデータを配置してください\n")
  }
}

cat("\nセットアップが完了しました！\n")
cat("次のステップ：\n")
cat("1. data/raw/ フォルダに生データを配置\n")
cat("2. notebooks/exploratory/ でデータ探索を開始\n")
cat("3. R/analysis/ で本格的な分析を実施\n")
