# RStudioAnalysis

## プロジェクト概要
日本語での統計分析・レポート作成に特化したRStudio分析テンプレートプロジェクトです。住宅価格分析のサンプルデータとスクリプトを含み、LaTeX日本語PDF出力に対応しています。

## 特徴
- 🇯🇵 **日本語対応**: データ変数名、レポート、全て日本語で記述可能
- 📊 **統計分析**: 記述統計、重回帰分析、相関分析のテンプレート
- 📄 **PDF出力**: LuaLaTeX + jlreqクラスによる美しい日本語PDF
- 🔄 **自動化**: データ生成から前処理まで自動化スクリプト
- 📦 **環境管理**: renvによるパッケージ管理とTinyTeX対応

## サンプルデータ
**住宅価格データ**（100件）
- 家賃（目的変数）
- 広さ、駅距離、築年数、二重窓（有意な説明変数）
- 部屋数、緑地面積（非有意な説明変数）

## フォルダ構成
```
RStudioAnalysis/
├── README.md              # このファイル
├── CLAUDE.md              # Claude AI との対話記録
├── setup.R                # 環境セットアップスクリプト
├── RStudioAnalysis.Rproj   # RStudioプロジェクトファイル
├── renv.lock              # パッケージ依存関係
├── data/                  # データファイル
│   ├── raw/               # 生データ
│   │   └── housing_data.csv      # 住宅価格サンプルデータ
│   └── processed/         # 前処理済みデータ
├── R/                     # Rスクリプト
│   ├── functions/         # 自作関数
│   ├── analysis/          # 分析スクリプト
│   └── utils/             # ユーティリティ
│       ├── generate_sample_data.R # サンプルデータ生成
│       └── preprocess_data.R      # データ前処理
├── notebooks/             # 分析レポート
│   └── housing_analysis.Rmd       # 住宅価格分析レポート
├── outputs/               # 出力ファイル
├── manuscript/            # 論文
│   └── template.Rmd       # 日本語論文テンプレート
├── latex/                 # LaTeX設定
│   └── preamble.tex       # 日本語LaTeX設定
└── docs/                  # ドキュメント
    └── analysis_log.md    # 分析プロセス記録
```

## 使用方法

### 1. 初期セットアップ
```r
# セットアップスクリプトを実行（初回のみ）
source("setup.R")
```

### 2. サンプルデータ生成（オプション）
```r
# 新しいサンプルデータを生成
source(here::here("R", "utils", "generate_sample_data.R"))
housing_data <- generate_and_save_housing_data(n_samples = 100, seed = 42)
```

### 3. データ前処理
```r
# データ前処理を実行
source(here::here("R", "utils", "preprocess_data.R"))
processed_data <- preprocess_housing_data()
```

### 4. 分析レポート作成
```r
# 日本語分析レポートのPDF生成
rmarkdown::render("notebooks/housing_analysis.Rmd")
```

### 5. 論文執筆
```r
# 日本語論文テンプレートのPDF生成
rmarkdown::render("manuscript/template.Rmd")
```

## 主要ファイルの説明

### 分析関連
- `notebooks/housing_analysis.Rmd`: 住宅価格分析の完全なレポート
  - 記述統計量の表
  - 家賃と駅距離の散布図
  - 重回帰分析結果と解釈

### ユーティリティ
- `R/utils/generate_sample_data.R`: 統計的に設計されたサンプルデータ生成
- `R/utils/preprocess_data.R`: データ前処理（現在は単純コピー）
- `setup.R`: 環境セットアップと日本語LaTeXパッケージ管理

### 設定ファイル
- `latex/preamble.tex`: 日本語LaTeX環境設定
- `manuscript/template.Rmd`: jlreqクラス対応論文テンプレート

## 依存パッケージ
主要パッケージ（`renv.lock`で管理）:
```r
# データ操作・可視化
tidyverse, here, janitor, skimr

# レポート作成
rmarkdown, knitr, tinytex

# 統計分析・可視化
broom, corrplot, GGally, plotly

# その他
conflicted, DT, glue
```

## LaTeX環境
- **LuaLaTeX**: 日本語対応LaTeXエンジン
- **jlreq**: 日本語組版クラス
- **TinyTeX**: 軽量LaTeX環境（推奨）

## トラブルシューティング

### LaTeX関連
- `setup.R`実行でTinyTeXと日本語パッケージを自動インストール
- `tlmgr info --only-installed`による高速パッケージチェック

### 文字化け対応
- CSVファイルはUTF-8エンコーディング
- `locale_jp <- locale(encoding = "UTF-8")`で日本語列名対応

## ライセンス
MIT License

## 更新履歴
- **2025-07-31**: 日本語サンプルデータと分析レポート追加
- **2025-07-16**: 初期バージョン作成

## 著者
[著者名]