##
## Kanazawa.R #3 初心者向けチュートリアル
## 2025年5月10日
##

# 電卓としてつかう

1 + 2
3 - 4
5 * 6
7 / 8

# べき乗

2^3
2 ** 3

# 関数

sqrt(4)    # sqrt()は平方根を返す関数

?sqrt      # sqrt()のヘルプを表示
help(sqrt) # これでも同じ

log(100)            # log()は自然対数を返す関数
log10(100)          # log10()は常用対数を返す関数
log(100, base = 10) # これでも同じ
?log                # log()のヘルプを表示
log(100, 10)        # 順番どおりなら、引数名は省略できる
log(base = 10, 100) # これでもよい
log(b = 10, 100)    # 引数名はほかと重ならなければ、途中まででもよい
                    # といっても、あとでわかりにくくなるので、
                    # なるべく順番どおりにするか、省略しないほうがよい

# 演算子も実は関数

`+`(1, 2)

# ベクトル

c(1, 2, 3) # c()はベクトルを作る関数

1:10       # コロン(:)で連続する整数のベクトルをつくれる

# 代入

X <- c("AB", "CD", "EF") # 文字列のベクトル
                         # Xというオブジェクトに代入

# オブジェクトの内容を表示

X
print(X) # 明示的に表示

# 代入は"="でもよい

X = c("GH", "IJ", "KL")
X

# 逆向きの代入

c("abc", "def", "ghi") -> X
X

# カッコで囲むと代入と表示を同時にできる

(X <- c(1, 2, 3))

# 因子型(factor)
# カテゴリカルデータ（名義尺度変数）を扱うための型
# 細かいことを言うと型(type)ではなくクラス(class)

Y <- factor(c("リンゴ", "ミカン", "ブドウ", "リンゴ")) # 因子型を作る関数
Y

# 順序つきの因子型
# 順序尺度変数をを扱うための型

answer <- ordered(c("普通", "良い", "悪い", "普通", "良い", "普通"),
                  levels = c("悪い", "普通", "良い"))
answer

# 集計して表にする

table(answer)

# 行列

matrix(1:6, nrow = 2, ncol = 3) # 行列を作る関数

# byrow = TRUE という引数をつけると行優先になる

matrix(1:6, 2, 3, byrow = TRUE) # 行優先

# TRUE/FALSEは論理型(logical)

typeof(TRUE)

# matrix関数のヘルプを確認

?matrix

# 行列演算

(A <- matrix(c(1, 2, 3, 4), nrow = 2, ncol = 2)) # 行列をAというオブジェクトに代入
(B <- matrix(c(2, 0, 0, 2), nrow = 2, ncol = 2)) # 行列をBというオブジェクトに代入

A + B # 行列の足し算

A - B # 行列の引き算

A %*% B # 行列の掛け算

A * B # "*"だと要素ごとの掛け算になる

?`%*%` # 行列の掛け算のヘルプを表示

# リスト型

list(a = 1, b = 2, b = 3) # リストを作る関数

# リストにはなんでも入れられる

L <- list(a = c(1, 2), b = "abc", c = matrix(1:4, nrow = 2))
L

L[["a"]] # リストの要素を取り出す
L[["b"]]
L[["c"]]

L$a # 簡単な書き方

# リスト構造を解く

unlist(L)

# データフレーム型
# リストで、要素の数がそろっていて、行列のようにあつかえる

member <- data.frame(name = c("鈴木", "佐藤", "田中"),
                     age = c(20, 30, 40),
                     height = c(170, 160, 180))
member

member$name      # name列を取り出す
member[, 1]      # これでも同じ（Rの添え字は1から始まります）
member[, "name"] # これでも同じ

member[2, ]                     # 2行目を取り出す
member[member$name == "佐藤", ] # nameが佐藤の行を取り出す
                                # tidyverseだとよりわかりやすい書き方（あとで）

member[2, "name"] # 2行目のname列を取り出す
member[2, 1]      # これでも同じ
member$name[2]    # これでも同じ


# 記述統計

X <- 0:100 # 0から100までの整数のベクトル

mean(X)     # 平均
var(X)      # 不偏分散
sd(X)       # 標準偏差
quantile(X) # 四分位数



#
# パッケージ利用とTidy data
#

# tidyverseパッケージをインストールする（依存パッケージもまとめてインストールする）

install.packages("tidyverse", dependencies = TRUE)

# tidyverseパッケージを読み込む

library(tidyverse)

# データの読み込み

# スライド資料の気温データをファイルにしておきました

file_path <- file.path("data", "kion.txt")

Kion <- readr::read_tsv(file_path) # read_tsv()はタブ区切りのデータを読み込む関数
Kion # 読み込んだデータを表示

# Tidy dataに変換

Kion_long <- Kion |>
  tidyr::pivot_longer(cols = starts_with("2025"), # "2025"で始まる列を変換の対象とする
                      names_to = "日付",          # 元の列名を"日付"列に入れる
                      values_to = "最高気温")     # 値の列名を"最高気温"にする
Kion_long # 変換したデータを表示

# "|>"はパイプ演算子と呼ばれ、左側の結果を右側の関数の第1引数として渡すもの
# magrittrパッケージの %>% も同じ

# 平方根の和の自然対数を求めるといった場合

log(sum(sqrt(X)))

# パイプ演算子を使うと

X |>
  sqrt() |>
  sum() |>
  log()

# long -> wide 変換

Kion_long |>
  tidyr::pivot_wider(names_from = "日付",      # "日付"列の内容を新しい列の名前に
                     values_from = "最高気温") # "最高気温"列の内容を新しい列の値に


# setariaviridisパッケージをつかったデータ処理の例

# setariaviridisパッケージをインストールする

install.packages("setariaviridis") # install.packagesはパッケージを
                                   # インストールする関数
# setariaviridis は、エノコログサ(Setaria viridis)の測定データを収めたパッケージ

library(setariaviridis) # library関数でパッケージを読み込む
?setariaviridis # パッケージのヘルプを表示

View(setaria_viridis)    # データを表計算ソフトのように表示

summary(setaria_viridis) # データの要約を表示

# dplyrパッケージを使ったデータの抽出

setaria_viridis |>
  dplyr::pull(culm_length) |>  # culm_length列を抽出
  mean()                       # 平均

# パッケージ名::関数名 と書くと、library()関数でパッケージを読み込んで
# おかなくても関数を使用できる
# ほかのパッケージと関数名がかぶるときに、どのパッケージの関数か明示的に指定できる

setaria_viridis %>%
  dplyr::filter(culm_length > 60) # culm_lengthが60以上のデータを抽出

# さっきのmembersデータフレームであった例

member[member$name == "佐藤", ] # nameが佐藤の行を取り出す

member |>
  dplyr::filter(name == "佐藤") # tidyverseのdplyrの書き方

member |>
  dplyr::filter(name == "佐藤" | name == "鈴木") |>
  dplyr::select(age) # nameが佐藤の行を取り出して、age列を抽出

member |>
  dplyr::filter(name == "佐藤" | name == "鈴木") |>
  dplyr::pull(age) # pull()はベクトルとして抽出



#
# グラフの作成
#

# ggplot2パッケージを使ったグラフの描画

# ggplot2パッケージはtidyverseに含まれている

?ggplot2 # ggplot2のヘルプを表示

# culm_lengthを横軸に、panicle_lengthを縦軸にした散布図を描く

# ggplot関数で、ggplotオブジェクトを作成
# "+"でレイヤーを追加していく

ggplot(data = setaria_viridis,
       mapping = aes(x = culm_length, y = panicle_length)) +
  geom_point() + # 散布図
  labs(title = "Setaria viridis", # タイトル
       x = "Culm length (cm)",    # X軸ラベル
       y = "Panicle length (cm)") # Y軸ラベル

# デフォルトのbaseグラフィックスなら

plot(x = setaria_viridis$culm_length,
     y = setaria_viridis$panicle_length,
     type = "p",
     main = "Setaria viridis",
     xlab = "Culm length (cm)", ylab = "Panicle length (cm)")

# あるいは

plot(panicle_length ~ culm_length, data = setaria_viridis,
     type = "p",
     main = "Setaria viridis",
     xlab = "Culm length (cm)", ylab = "Panicle length (cm)")

# ggplot2に戻ります
# 根株ごとに色を変える
# いったんオブジェクトに保存

p <- ggplot(data = setaria_viridis,
       mapping = aes(x = culm_length, y = panicle_length,
                     colour = factor(root_number))) +
  geom_point(size = 3) +  # 点のサイズを変える
  labs(title = "Setaria viridis",
       x = "Culm length (cm)", y = "Panicle length (cm)") +
  scale_colour_discrete(name = "Root number") # 凡例のタイトルを変更

# オブジェクトに保存しておいたものを表示

plot(p)

# これでもよい

print(p)

# これでも

p

# テーマとフォントを変更

p +
  theme_classic(base_family = "Noto Sans", base_size = 18)

