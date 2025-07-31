# generate_sample_data.R - サンプルデータ生成スクリプト
# Created: 2025-07-31

library(here)
library(readr)
library(dplyr)

# 住宅価格サンプルデータの生成
generate_housing_sample_data <- function(n_samples = 100, seed = 42) {
  cat("🏠 住宅価格サンプルデータを生成中...\n")
  
  # 再現可能性のためのシード設定
  set.seed(seed)
  
  # 基本変数の生成
  物件ID <- 1:n_samples
  
  # 広さ（58-102㎡の範囲）
  広さ <- round(runif(n_samples, 58, 102), 1)
  
  # 駅距離（1-17分の範囲）
  駅距離 <- sample(1:17, n_samples, replace = TRUE)
  
  # 築年数（1-30年の範囲）
  築年数 <- sample(1:30, n_samples, replace = TRUE)
  
  # 部屋数（2-4部屋の範囲）
  部屋数 <- sample(2:4, n_samples, replace = TRUE, prob = c(0.5, 0.4, 0.1))
  
  # 緑地面積（3-22㎡の範囲）
  緑地面積 <- round(runif(n_samples, 3, 22), 1)
  
  # 二重窓（約70%が設置済み）
  二重窓 <- sample(c(0, 1), n_samples, replace = TRUE, prob = c(0.3, 0.7))
  
  # 家賃の計算（現実的な価格設定）
  # 基本価格 = 広さ × 係数 + 設備・立地調整
  base_rent <- 広さ * 1200  # 基本単価: 1200円/㎡
  
  # 立地調整（駅距離による減額）
  location_adj <- -駅距離 * 2500
  
  # 築年数調整（古いほど減額）
  age_adj <- -築年数 * 1800
  
  # 設備調整（二重窓による加算）
  equipment_adj <- 二重窓 * 15000
  
  # 部屋数と緑地面積は統計的に有意でないように小さな影響に設定
  rooms_adj <- (部屋数 - 2.5) * rnorm(n_samples, 0, 2000)  # ランダムノイズ
  green_adj <- (緑地面積 - 12.5) * rnorm(n_samples, 0, 300)  # ランダムノイズ
  
  # 最終家賃計算（ランダムノイズも追加）
  noise <- rnorm(n_samples, 0, 3000)
  家賃 <- round(base_rent + location_adj + age_adj + equipment_adj + 
                rooms_adj + green_adj + noise)
  
  # 家賃の下限を設定（現実的な範囲に調整）
  家賃 <- pmax(家賃, 70000)
  
  # データフレームの作成
  housing_data <- data.frame(
    物件ID = 物件ID,
    家賃 = 家賃,
    広さ = 広さ,
    駅距離 = 駅距離,
    築年数 = 築年数,
    部屋数 = 部屋数,
    緑地面積 = 緑地面積,
    二重窓 = 二重窓
  )
  
  # データの概要を表示
  cat("\n📊 生成されたデータの概要:\n")
  cat("- サンプル数:", n_samples, "件\n")
  cat("- 家賃範囲:", format(min(housing_data$家賃), big.mark = ","), "円 〜", 
      format(max(housing_data$家賃), big.mark = ","), "円\n")
  cat("- 平均家賃:", format(round(mean(housing_data$家賃)), big.mark = ","), "円\n")
  cat("- 二重窓設置率:", round(100 * mean(housing_data$二重窓), 1), "%\n")
  
  # 統計的関係の確認
  model_check <- lm(家賃 ~ 広さ + 駅距離 + 築年数 + 部屋数 + 緑地面積 + 二重窓, 
                    data = housing_data)
  p_values <- summary(model_check)$coefficients[, 4]
  
  cat("\n🔍 変数の統計的有意性（p値）:\n")
  cat("- 広さ:", round(p_values["広さ"], 4), 
      ifelse(p_values["広さ"] < 0.05, " *有意*", "\n"))
  cat("- 駅距離:", round(p_values["駅距離"], 4), 
      ifelse(p_values["駅距離"] < 0.05, " *有意*", "\n"))
  cat("- 築年数:", round(p_values["築年数"], 4), 
      ifelse(p_values["築年数"] < 0.05, " *有意*", "\n"))
  cat("- 二重窓:", round(p_values["二重窓"], 4), 
      ifelse(p_values["二重窓"] < 0.05, " *有意*", "\n"))
  cat("- 部屋数:", round(p_values["部屋数"], 4), 
      ifelse(p_values["部屋数"] < 0.05, " *有意*", " (非有意)\n"))
  cat("- 緑地面積:", round(p_values["緑地面積"], 4), 
      ifelse(p_values["緑地面積"] < 0.05, " *有意*", " (非有意)\n"))
  
  return(housing_data)
}

# データ保存関数
save_housing_data <- function(housing_data, output_path = NULL) {
  if (is.null(output_path)) {
    output_path <- here("data", "raw", "housing_data.csv")
  }
  
  # ディレクトリの作成
  output_dir <- dirname(output_path)
  if (!dir.exists(output_dir)) {
    dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)
  }
  
  # データの保存
  write_csv(housing_data, output_path)
  cat("💾 データを保存しました:", output_path, "\n")
  
  return(output_path)
}

# メイン実行関数
generate_and_save_housing_data <- function(n_samples = 100, seed = 42, 
                                          output_path = NULL) {
  cat("🚀 住宅価格サンプルデータの生成を開始...\n\n")
  
  # データ生成
  housing_data <- generate_housing_sample_data(n_samples = n_samples, seed = seed)
  
  # データ保存
  saved_path <- save_housing_data(housing_data, output_path)
  
  cat("\n✅ サンプルデータの生成・保存が完了しました！\n")
  cat("📄 保存先:", saved_path, "\n")
  
  return(housing_data)
}

# スクリプトが直接実行された場合の処理
if (!interactive()) {
  # デフォルト設定でデータ生成・保存
  generate_and_save_housing_data()
}

# 使用例:
# source(here("R", "utils", "generate_sample_data.R"))
# housing_data <- generate_and_save_housing_data(n_samples = 150, seed = 123)