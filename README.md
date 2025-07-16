# RStudioAnalysis

## プロジェクト概要
[研究の概要を記述]

## データセット
- **mydata**: [データセットの説明]

## フォルダ構成
```
RStudioAnalysis/
├── README.md              # このファイル
├── CLAUDE.md              # Claude AI との対話記録
├── RStudioAnalysis.Rproj   # RStudioプロジェクトファイル
├── renv.lock              # パッケージ依存関係
├── data/                  # データファイル
│   ├── raw/               # 生データ
│   └── processed/         # 前処理済みデータ
├── R/                     # Rスクリプト
│   ├── functions/         # 自作関数
│   ├── analysis/          # 分析スクリプト
│   └── utils/             # ユーティリティ
├── notebooks/             # 探索的分析・メモ
├── outputs/               # 出力ファイル
├── manuscript/            # 論文
└── docs/                  # ドキュメント
```

## 使用方法
1. RStudioでプロジェクトを開く
2. `renv::restore()` でパッケージ環境を復元
3. `notebooks/exploratory/` で初期探索
4. `R/analysis/` で本格的な分析

## 依存パッケージ
主要パッケージは `renv.lock` で管理されています。

## 著者
[著者名]

## 更新日
2025-07-16
