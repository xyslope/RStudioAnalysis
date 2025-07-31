# preprocess_data.R - データ前処理スクリプト
# Created: 2025-07-31

library(here)
library(readr)
library(dplyr)

# 日本語列名の読み込み設定
locale_jp <- locale(encoding = "UTF-8")

# データ前処理関数
preprocess_housing_data <- function() {
  cat("🔄 住宅データの前処理を開始...\n")
  
  # 生データの読み込み
  raw_data_path <- here("data", "raw", "housing_data.csv")
  
  if (!file.exists(raw_data_path)) {
    stop("❌ 生データが見つかりません: ", raw_data_path)
  }
  
  # データ読み込み（日本語列名対応）
  housing_data <- read_csv(raw_data_path, locale = locale_jp, show_col_types = FALSE)
  cat("✅ データ読み込み完了: ", nrow(housing_data), "行, ", ncol(housing_data), "列\n")
  
  # 前処理済みディレクトリの作成
  processed_dir <- here("data", "processed")
  if (!dir.exists(processed_dir)) {
    dir.create(processed_dir, recursive = TRUE)
    cat("📁 processedディレクトリを作成\n")
  }
  
  # 今回は単純にコピーするだけ（将来的な拡張のため関数化）
  processed_data <- housing_data
  
  # データの基本情報を出力
  cat("\n📊 データ概要:\n")
  cat("- 家賃: ", min(processed_data$家賃), "円 〜 ", max(processed_data$家賃), "円\n")
  cat("- 広さ: ", round(min(processed_data$広さ), 1), "㎡ 〜 ", round(max(processed_data$広さ), 1), "㎡\n")
  cat("- 駅距離: ", min(processed_data$駅距離), "分 〜 ", max(processed_data$駅距離), "分\n")
  cat("- 築年数: ", min(processed_data$築年数), "年 〜 ", max(processed_data$築年数), "年\n")
  cat("- 部屋数: ", min(processed_data$部屋数), "部屋 〜 ", max(processed_data$部屋数), "部屋\n")
  cat("- 緑地面積: ", round(min(processed_data$緑地面積), 1), "㎡ 〜 ", round(max(processed_data$緑地面積), 1), "㎡\n")
  cat("- 二重窓: ", sum(processed_data$二重窓), "件 (", round(100*mean(processed_data$二重窓), 1), "%)\n")
  
  # 前処理済みデータの保存
  output_path <- here("data", "processed", "housing_data_processed.csv")
  write_csv(processed_data, output_path)
  cat("\n💾 前処理済みデータを保存: ", output_path, "\n")
  
  return(processed_data)
}

# スクリプトが直接実行された場合に前処理を実行
if (!interactive()) {
  preprocess_housing_data()
  cat("✅ 前処理完了\n")
}