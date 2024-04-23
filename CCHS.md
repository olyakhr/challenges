---
title: "CCHS"
author: "Olya"
date: "2024-04-05"
output: 
  html_document:
    keep_md: true
---

## Me trying to beat the R 

Needed packages installation:


##### Reading CCHS 2012 csv file, checking if R reads all the variables in the table as numbers

```r
cchs <- read_csv("/Users/olechka/Documents/R/challenges/CCHS_2012.csv")
```

```
## Rows: 124929 Columns: 36
## ── Column specification ────────────────────────────────────────────────────────
## Delimiter: ","
## dbl (36): CASEID, verdate, adm_prx, adm_n09, adm_n10, adm_n11, adm_rno, pmkp...
## 
## ℹ Use `spec()` to retrieve the full column specification for this data.
## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.
```

```r
head(cchs, 10)
```

```
## # A tibble: 10 × 36
##    CASEID  verdate adm_prx adm_n09 adm_n10 adm_n11 adm_rno pmkproxy geogprv
##     <dbl>    <dbl>   <dbl>   <dbl>   <dbl>   <dbl>   <dbl>    <dbl>   <dbl>
##  1      1 20130913       2       1       1       6       1        6      35
##  2      2 20130913       2       6       1       6       2        6      59
##  3      3 20130913       2       6       1       6       3        6      35
##  4      4 20130913       2       6       1       6       4        6      46
##  5      5 20130913       2       6       1       6       5        6      24
##  6      6 20130913       2       2       1       6       6        6      48
##  7      7 20130913       2       2       1       6       7        6      12
##  8      8 20130913       1       1       1       6       8        6      48
##  9      9 20130913       2       6       1       6       9        6      35
## 10     10 20130913       2       2       1       6      10        6      59
## # ℹ 27 more variables: geodpmf <dbl>, geodbcha <dbl>, sdcgcb12 <dbl>,
## #   sdc_5a_1 <dbl>, sdcdfols <dbl>, dhh_own <dbl>, sdcglhm <dbl>,
## #   sdcfimm <dbl>, sdcgres <dbl>, sdcgcgt <dbl>, sdc_8 <dbl>, sdcg9 <dbl>,
## #   dhhgage <dbl>, dhh_sex <dbl>, dhhgms <dbl>, dhhgle5 <dbl>, dhhg611 <dbl>,
## #   dhhgl12 <dbl>, dhhglvg <dbl>, dhhghsz <dbl>, hwt_4 <dbl>, hwtghtm <dbl>,
## #   hwtgwtk <dbl>, hwtgbmi <dbl>, hwtgisw <dbl>, hwtdcol <dbl>, wts_m <dbl>
```

```r
sapply(cchs, class)
```

```
##    CASEID   verdate   adm_prx   adm_n09   adm_n10   adm_n11   adm_rno  pmkproxy 
## "numeric" "numeric" "numeric" "numeric" "numeric" "numeric" "numeric" "numeric" 
##   geogprv   geodpmf  geodbcha  sdcgcb12  sdc_5a_1  sdcdfols   dhh_own   sdcglhm 
## "numeric" "numeric" "numeric" "numeric" "numeric" "numeric" "numeric" "numeric" 
##   sdcfimm   sdcgres   sdcgcgt     sdc_8     sdcg9   dhhgage   dhh_sex    dhhgms 
## "numeric" "numeric" "numeric" "numeric" "numeric" "numeric" "numeric" "numeric" 
##   dhhgle5   dhhg611   dhhgl12   dhhglvg   dhhghsz     hwt_4   hwtghtm   hwtgwtk 
## "numeric" "numeric" "numeric" "numeric" "numeric" "numeric" "numeric" "numeric" 
##   hwtgbmi   hwtgisw   hwtdcol     wts_m 
## "numeric" "numeric" "numeric" "numeric"
```

##### We checked, now creating a basic plot


```r
ggplot(cchs, aes(x = hwtghtm, y = hwtgwtk)) + geom_point()
```

![](CCHS_files/figure-html/unnamed-chunk-2-1.png)<!-- -->
*What an ugly plot to be honest...*

##### Making missing data become NA instead of numbers:

```r
cchs <- cchs %>%
  mutate(height = ifelse(hwtghtm == 9.996 | hwtghtm == 9.999, NA, hwtghtm))
cchs <- cchs %>%
  mutate(weight = ifelse(hwtgwtk == 999.96 | hwtgwtk == 999.99, NA, hwtgwtk),
         bmi = weight/height^2)
```

##### Now creating Body Mass Index categories:

```r
cchs <- cchs %>%
	mutate(bmi_category = case_when(
		bmi < 18.5 ~ "underweight",
		bmi >=30 & bmi <999 ~ "obese",
		bmi >=25 & bmi <30 ~ "overweight",
		bmi >=18.5 & bmi <25 ~ "normal weight",
		TRUE ~ "other"
	))
```

##### Identifying provinces' names:

```r
cchs <- cchs %>%
	mutate(province = case_when(
		geogprv == 10 ~ "NFLD & LAB",
		geogprv == 11 ~ "PEI",
		geogprv == 12 ~ "NOVA SCOTIA",
		geogprv == 13 ~ "NEW BRUNSWICK",
		geogprv == 24 ~ "QUEBEC",
		geogprv == 35 ~ "ONTARIO",
		geogprv == 46 ~ "MANITOBA",
		geogprv == 47 ~ "SASKATCHEWAN",
		geogprv == 48 ~ "ALBERTA",
		geogprv == 59 ~ "BRITISH COLUMBIA",
		geogprv == 60 ~ "YUKON/NWT/NUNA",
		geogprv == 96 ~ "NOT APPLICABLE",
		geogprv == 97 ~ "DON'T KNOW",
		geogprv == 98 ~ "REFUSAL",
		TRUE ~ "NOT STATED"
	))
```


Now let's plot our data:

```r
library(ggplot2)
scatter_clean <- ggplot(cchs, aes(x = height, y = weight)) + 
  geom_point() + 
  xlab("Height in Meters") +
  ylab("Weight in Kilograms")
plot(scatter_clean)
```

```
## Warning: Removed 7947 rows containing missing values or values outside the scale range
## (`geom_point()`).
```

![](CCHS_files/figure-html/unnamed-chunk-6-1.png)<!-- -->

```r
my_colors <- c("underweight" = "blue", "normal weight" = "darkgreen", "overweight" = "orange", "obese" = "red")
library(ggplot2)
scatter_cat <- ggplot(cchs, aes(x = height, y = weight)) + 
  geom_point(aes(colour = factor(bmi_category)), alpha = 1/5) + 
  xlab("Height in Meters") +
  ylab("Weight in Kilograms") +
  scale_color_manual(values = my_colors)
plot(scatter_cat)
```

```
## Warning: Removed 7947 rows containing missing values or values outside the scale range
## (`geom_point()`).
```

![](CCHS_files/figure-html/unnamed-chunk-6-2.png)<!-- -->



```r
summarize(
  group_by(cchs, bmi_category), 
  avg_ht = mean(hwtghtm, na.rm = T), 
  sd_ht = sd(hwtghtm, na.rm = T),
  avg_wt = mean(hwtgwtk, na.rm = T), 
  sd_wt = sd(hwtgwtk, na.rm = T)
)
```

```
## # A tibble: 5 × 5
##   bmi_category  avg_ht  sd_ht avg_wt  sd_wt
##   <chr>          <dbl>  <dbl>  <dbl>  <dbl>
## 1 normal weight   1.68 0.0974   63.5   9.44
## 2 obese           1.68 0.105    97.0  14.6 
## 3 other           6.82 4.06    915.  269.  
## 4 overweight      1.70 0.101    79.0  10.3 
## 5 underweight     1.66 0.102    47.6   6.47
```
