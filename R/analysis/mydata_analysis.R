# mydata データセットの分析
# 作成日: 2025-07-16

# パッケージの読み込み ----
library(tidyverse)
library(here)
library(janitor)
library(skimr)

# 設定 ----
options(dplyr.summarise.inform = FALSE)
conflicted::conflict_prefer("filter", "dplyr")

# データの読み込み ----
mydata_data <- read_csv(here("data", "raw", "mydata", "data.csv"))

# データの概要確認 ----
glimpse(mydata_data)
skim(mydata_data)

# データクリーニング ----
mydata_clean <- mydata_data %>%
  clean_names() %>%
  # 必要に応じて前処理を追加
  identity()

# 基本統計量 ----
mydata_clean %>%
  summary()

# 探索的データ分析 ----
# TODO: 具体的な分析を追加

# 結果の保存 ----
mydata_clean %>%
  write_csv(here("data", "processed", "mydata_processed.csv"))

# 図の保存例 ----
# p1 <- mydata_clean %>%
#   ggplot(aes(x = variable1, y = variable2)) +
#   geom_point() +
#   theme_minimal()
# 
# ggsave(here("outputs", "figures", "mydata_plot.png"), p1, 
#        width = 8, height = 6, dpi = 300)
