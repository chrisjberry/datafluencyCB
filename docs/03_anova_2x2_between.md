# ANOVA: one-way (and 2x2-between-subjects) {#anova1}

*Chris Berry*
\
*2022*





<style>
div.exercise { background-color:#e6f0ff; border-radius: 5px; padding: 20px;}
</style>

<style>
div.tip { background-color:#D5F5E3; border-radius: 5px; padding: 20px;}
</style>


## Overview

\

* **Slides** from the lecture part of the session: [Download](slides/PSYC753_L2_MultipleRegression1.pptx)

\


So far we have used regression where both the outcome and predictor variables are continuous.

When the predictor variables in a regression are entirely categorical, the analysis usually goes by a different name, **ANOVA**, which stands for Analysis Of Variance. Here we consider two types of ANOVA for between-subjects design: one-way ANOVA and factorial ANOVA (e.g., 2 x 2 ANOVA).


## One-way between subjects ANOVA

:::{.tip}
**A one-way between subjects ANOVA** is used to compare the scores from different groups of individuals. For example, do the wellbeing scores differ between three groups of individuals, where each group undergoes a different type of therapy in each group as treatment? 
:::

\

  * **one-way** means that there is one independent variable, for example, _type of therapy_. 
  * Independent variables are also called *factors* in ANOVA. 
  * A factor can be made up of different *levels*. Type of therapy could have levels: CBT, EMDR, Control.
  * **between subjects** means that each level of the independent variable is a different group of participants. For example, if type of therapy is manipulated between-subjects, one group receives CBT, another group receives EMDR, and another group are the control group. The individuals in each group are not the same.


The ANOVA will tell us whether scores on our dependent variable (e.g., anxiety score) differ according to the levels of the independent variable (e.g., type of treatment). In other words, it will tell us if there's an effect of the treatment or not.

Other types of ANOVA exist (e.g., for within-subjects/repeated measures designs) and will be considered in future sessions. 


### Worked Example

What is the effect of viewing pictures of different aesthetic quality on mood? Meidenbauer et al. (2020) showed three groups of participants pictures of urban environments that were either very low in aesthetic appeal (n = 103), low in aesthetic appeal (n = 103), or high (n = 103). Participants' State Trait Anxiety Inventory (STAI: a measure of negative symptoms such as upset, tense, worried) was measured before and after viewing these images. 

:::{.exercise}

From the description above, answer these questions:

What is the independent variable (or factor) in this design?


<div class='webex-solution'><button>Answer</button>

Aesthetic appeal of the images. 

</div>


How many levels does it have?


<div class='webex-solution'><button>Answer</button>

Aesthetic appeal has three levels: Very low, low, and high

</div>


What is the dependent variable? 


<div class='webex-solution'><button>Answer</button>

Change in STAI score as a result of viewing the images.

</div>


:::

\

#### Read in the data

The `affect` dataset contains the results of this study. Read in the data and preview the data using `head()`. The data are stored at:

https://raw.githubusercontent.com/chrisjberry/Teaching/master/3_affect.csv


<div class='webex-solution'><button>More on the data</button>

Meidenbauer et al. (2020) looked at many things in their study. They were interested in whether the benefits of nature on mood may actually be linked to the aesthetic appeal of nature, rather than nature per se. Hence, they sought to determine if urban images that differ in aesthetic appeal could produce similar effects to those of nature images. The data in `affect` are taken from the Urban condition of their Experiment 1. The variable names have been changed for clarity.

</div>



```r
# Read in the affect data
affect <- read_csv('https://raw.githubusercontent.com/chrisjberry/Teaching/master/3_affect.csv')

# look at the first 6 rows
affect %>% head()
```

<div class="kable-table">

| ppt|group   |     score| age| gender|
|---:|:-------|---------:|---:|------:|
|   1|High    | 0.0000000|  33|      1|
|   5|VeryLow | 0.0000000|  42|      2|
|   6|VeryLow | 0.0000000|  33|      1|
|   8|High    | 0.0000000|  38|      2|
|   9|Low     | 0.3333333|  38|      1|
|  13|High    | 1.3333333|  24|      1|

</div>
\

About the data:

* `ppt`: the participant number
* `group`: the aesthetic appeal group, with levels `VeryLow`, `Low` and `High`
* `score`: the change in STAI score. Higher scores indicate fewer negative symptoms after viewing the images.
* `age`: age in years 
* `gender`: 1 = male, 2 = female.

\
Note that the `group` column is by default read into R as a character variable (that's what `<chr>` means). 

\

#### Convert the independent variable to a factor

To use the `group` column in an ANOVA, we need to tell RStudio that `group` is a _factor_. Use `mutate()` and `factor()` to convert `group` to a factor.


```r
affect <-
  affect %>% 
  mutate(group = factor(group))
```


<div class='webex-solution'><button>Explain the code</button>


* The code `affect <-` means that we'll store whatever whatever comes after it back in `affect`. 
* In other words, we'll change the existing data frame.
* The code `affect %>%` takes `affect` and pipes it to the next line containing `mutate()`
`mutate()` takes `group` and converts it to a factor.

To order the levels of `group`, which can be useful when plotting the data, change the code with `factor(group)` to: 

`factor(group, levels = c("VeryLow","Low","High"))`


</div>


\

#### N of each group

Use `group_by()` and `count()` to obtain the number of participants per group


```r
# group the data by 'group' column, then count number of rows in each group
affect %>% group_by(group) %>% count()
```
* How many participants were there in the `VeryLow` aesthetic appeal group? <input class='webex-solveme nospaces' size='3' data-answer='["102"]'/>
* How many participants were there in the `Low` aesthetic appeal group? <input class='webex-solveme nospaces' size='3' data-answer='["100"]'/>
* How many participants were there in the `High` aesthetic appeal group? <input class='webex-solveme nospaces' size='3' data-answer='["104"]'/>


#### Inspect the data

The way the data are distributed in each group can be inspected with histograms (`geom_histogram()`) or a density plots (`geom_density()`).


```r
affect %>% 
  ggplot(aes(score)) +
  geom_histogram() + 
  facet_wrap(~group)
```

```
## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.
```

<div class="figure" style="text-align: center">
<img src="03_anova_2x2_between_files/figure-html/unnamed-chunk-5-1.png" alt="TRUE" width="100%" />
<p class="caption">(\#fig:unnamed-chunk-5)TRUE</p>
</div>


<div class='webex-solution'><button>Explain the code</button>


* The code takes `affect` and pipes it to `ggplot()`. 
* `geom_histogram()` requests a density plot
* `facet_wrap(~group)` tells `ggplot()` to create separate density plots for each group.

Swap `geom_histogram()` with `geom_density()` to produce density plots.

</div>


\


<div class='webex-solution'><button>Comments on the plots</button>

The spread of scores in each group appears relatively similar, suggesting the assumption of homogeneity of variance, an assumption of ANOVA, may be met. The distributions are reasonably symmetrical, and, aside from the very high number of 0 scores in each group (indicative of no change in STAI score in a large number of individuals), the data are approximately normal. Normality is also an assumption of ANOVA. In practice, ANOVA is considered reasonably robust against violations of these assumptions (e.g., Glass et al. 1972, Schmider et al., 2010).

</div>


#### Plot of the means

It is common to produce a plot of the mean scores in each group when conducting ANOVA. This can help to intepret the results.

The package `ggpubr` can produce high quality plots with ease.


```r
# load the ggpubr package
library(ggpubr)

# plot the mean of each group (with the standard error of the means)
affect %>% 
  ggerrorplot(x = "group" , y = "score") +
  xlab("Aesthetic appeal group") +
  ylab("Change in STAI negative symptoms") 
```

<div class="figure" style="text-align: center">
<img src="03_anova_2x2_between_files/figure-html/unnamed-chunk-6-1.png" alt="TRUE" width="100%" />
<p class="caption">(\#fig:unnamed-chunk-6)TRUE</p>
</div>


<div class='webex-solution'><button>Explain the code</button>


* The data in `affect` is piped to `ggerrorplot()`
* `group` is specified on the x-axis
* `score` is on the y-axis


</div>


\


<div class='webex-solution'><button>Developing the plot</button>

As with plots generate in `ggplot()`, the figure can be enhanced by adding code, e.g., ` + xlab("Aesthetic appeal group")`

Behind the scenes, `ggpubr` uses `ggplot()`, so the plot could, in theory, be built from scratch using techniques you've covered earlier in the module.

Other types of plot are available, see e.g.:

Boxplots: `ggboxplot()`
Violin plots: `ggviolin()`

Read more by running `?ggboxplot()` or `?ggviolin()`


</div>


\

#### One-way between subjects ANOVA
  
To run a one-way between subjects ANOVA in R, use `lmBF()` 


```r
lmBF(score ~ group, data = data.frame(affect))

# follow up ttests
#ttestBF()
```

```
## Bayes factor analysis
## --------------
## [1] group : 66.65842 ±0.04%
## 
## Against denominator:
##   Intercept only 
## ---
## Bayes factor type: BFlinearModel, JZS
```

The BF = 66.66, indicating that the data are 66.66 times more likely than an intercept-only model. 

\

For a one-way between-subjects ANOVA, `lmBF()` can be swapped with `anovaBF()` to produce exactly the same result:


```r
anovaBF(score ~ group, data = data.frame(affect))
```

### R^2^

:::{.tip}
R^2^ can also be reported for ANOVA models as a measure of _effect size_. As with simple and multiple regression, R^2^ is the proportion of variance explained by the model. In ANOVA, our model is that the scores come from distinct groups of individuals (three groups in our example) with different means.
:::

\

To obtain R^2^, use `lm()` to specify the model, then use `glance()` from the `broom` package:


```r
# store the anova
anova_1 <- lm(score ~ group, data=affect)

# make sure broom package is loaded, then
# use glance() with anova_1 
glance(anova_1)
```

<div class="kable-table">

| r.squared| adj.r.squared|  sigma| statistic|   p.value| df|    logLik|      AIC|      BIC| deviance| df.residual| nobs|
|---------:|-------------:|------:|---------:|---------:|--:|---------:|--------:|--------:|--------:|-----------:|----:|
| 0.0523547|     0.0460996| 0.4743|  8.369943| 0.0002896|  2| -204.4377| 416.8754| 431.7697| 68.16302|         303|  306|

</div>
R^2^ (Adjusted) = 4.61%, meaning that 4.61% of the variance in the change in STAI scores is explained by the model.


### Pairwise Comparisons

The BF (66.66) tells us that there's evidence that the means of the three groups differ from one another, but not which groups differ from which. 

With three groups, there are three possible pairwise comparisons that can be made: `VeryLow` vs. `Low`, `VeryLow` vs. `High`, and `Low` vs. `High`. 

To compare the scores of two groups, use `ttestBF()` to perform a Bayesian _t_-test.


```r
# compare scores of groups VeryLow vs. Low
ttestBF(x = affect$score[affect$group=="VeryLow"], 
        y = affect$score[affect$group=="Low"])

# compare scores of groups VeryLow vs. High
ttestBF(x = affect$score[affect$group=="VeryLow"], 
        y = affect$score[affect$group=="High"])

# compare scores of groups Low vs. High
ttestBF(x = affect$score[affect$group=="Low"], 
        y = affect$score[affect$group=="High"])
```

```
## Bayes factor analysis
## --------------
## [1] Alt., r=0.707 : 10.25237 ±0%
## 
## Against denominator:
##   Null, mu1-mu2 = 0 
## ---
## Bayes factor type: BFindepSample, JZS
## 
## Bayes factor analysis
## --------------
## [1] Alt., r=0.707 : 55.43484 ±0%
## 
## Against denominator:
##   Null, mu1-mu2 = 0 
## ---
## Bayes factor type: BFindepSample, JZS
## 
## Bayes factor analysis
## --------------
## [1] Alt., r=0.707 : 0.1774611 ±0%
## 
## Against denominator:
##   Null, mu1-mu2 = 0 
## ---
## Bayes factor type: BFindepSample, JZS
```

The scores in the `VeryLow` group were lower than those of the `Low` (BF = 10.25) and `High` groups (BF = 55.43), but scores in the `Low` and `High` groups did not differ (BF = 0.18). This indicates that STAI scores were lower (i.e., there were more negative symptoms) after viewing images that were very low in aesthetic appeal, compared to images that were low or high in aesthetic appeal.


## Two-way between-subjects ANOVA

:::{.tip}
In a two-way ANOVA, there are two independent variables or factors. When there are multiple factors, the ANOVA is referred to as _factorial_ ANOVA. 

For example, if there are two factors, and each factor has two levels, then we refer to the ANOVA as a 2 x 2 ANOVA. 

Our tw
:::

### Worked example


```r
#lm()

#anovaBF()
```

#### Read in the data

https://raw.githubusercontent.com/chrisjberry/Teaching/master/3_resilience_data.csv


```r
resilience_data <- read_csv('https://raw.githubusercontent.com/chrisjberry/Teaching/master/3_resilience_data.csv')
```

```
## Rows: 2437 Columns: 8
```

```
## -- Column specification --------------------------------------------------------
## Delimiter: ","
## chr (2): resilience, adversity
## dbl (6): distress, sex, partnership, education, income, unemployed
```

```
## 
## i Use `spec()` to retrieve the full column specification for this data.
## i Specify the column types or set `show_col_types = FALSE` to quiet this message.
```

```r
head(resilience_data)
```

<div class="kable-table">

| distress|resilience |adversity | sex| partnership| education| income| unemployed|
|--------:|:----------|:---------|---:|-----------:|---------:|------:|----------:|
|        0|high       |low       |   1|           1|         2|      2|          0|
|        1|low        |low       |   1|           1|         1|      2|          0|
|        0|high       |low       |   1|           2|         1|      1|          0|
|        0|high       |low       |   1|           1|         1|      2|          0|
|        1|low        |low       |   1|           2|         2|      2|          0|
|        1|high       |low       |   1|           1|         1|      2|          0|

</div>


#### Convert the independent variables to factors


```r
resilience_data <- 
  resilience_data %>% 
  mutate(resilience = factor(resilience),
         adversity = factor(adversity))
```


#### N of each group



```r
resilience_data %>% group_by(resilience, adversity) %>% count()
```

<div class="kable-table">

|resilience |adversity |    n|
|:----------|:---------|----:|
|high       |high      |  106|
|high       |low       |  997|
|low        |high      |  284|
|low        |low       | 1050|

</div>

#### Inspect the data

```r
resilience_data %>% 
  ggplot(aes(distress)) + 
  geom_density() +
  facet_wrap(~resilience*adversity)
```

<div class="figure" style="text-align: center">
<img src="03_anova_2x2_between_files/figure-html/unnamed-chunk-15-1.png" alt="TRUE" width="100%" />
<p class="caption">(\#fig:unnamed-chunk-15)TRUE</p>
</div>


#### Plot the means


```r
library(ggpubr)

resilience_data %>% 
  ggbarplot(x="resilience", y="distress", #fill="adversity",
            add="mean_se", color = "adversity", position = position_dodge()) +
  xlab("Resilience") +
  ylab("Distress") 
```

<div class="figure" style="text-align: center">
<img src="03_anova_2x2_between_files/figure-html/unnamed-chunk-16-1.png" alt="TRUE" width="100%" />
<p class="caption">(\#fig:unnamed-chunk-16)TRUE</p>
</div>

```r
#resilience_data %>% 
#  ggerrorplot(x="resilience", y="distress", #fill="adversity",
#            color = "adversity", position = position_dodge()) +
#  xlab("Resilience") +
#  ylab("Distress") 
```


#### Two-way ANOVA


```r
anova2x2 <- lm(distress ~ resilience * adversity, data = resilience_data)

glance(anova2x2)

anova2x2_BF <- anovaBF(distress ~ resilience*adversity, data = resilience_data)
```

```
## Warning: data coerced from tibble to data frame
```

```r
# main effect resilience
anova2x2_BF[1]

# main effect adversity
anova2x2_BF[2]

# interaction 
anova2x2_BF[4] / anova2x2_BF[3]


#frequentist
#resilience_data<-
#  resilience_data %>% mutate(id = c(1:n())) %>% 
#  mutate(id=factor(id))

#anova2way <- afex::aov_ez(id=c("id"),
#                          dv=c("distress"),
#                          between=c("resilience","adversity"), # two factors
#                          data=resilience_data)
```

<div class="kable-table">

| r.squared| adj.r.squared|    sigma| statistic| p.value| df|    logLik|      AIC|      BIC| deviance| df.residual| nobs|
|---------:|-------------:|--------:|---------:|-------:|--:|---------:|--------:|--------:|--------:|-----------:|----:|
| 0.0963021|     0.0951878| 2.142569|  86.42379|       0|  3| -5312.959| 10635.92| 10664.91| 11168.93|        2433| 2437|

</div>

```
## Bayes factor analysis
## --------------
## [1] resilience : 1.822053e+27 ±0%
## 
## Against denominator:
##   Intercept only 
## ---
## Bayes factor type: BFlinearModel, JZS
## 
## Bayes factor analysis
## --------------
## [1] adversity : 7.870878e+25 ±0%
## 
## Against denominator:
##   Intercept only 
## ---
## Bayes factor type: BFlinearModel, JZS
## 
## Bayes factor analysis
## --------------
## [1] resilience + adversity + resilience:adversity : 937.444 ±2.98%
## 
## Against denominator:
##   distress ~ resilience + adversity 
## ---
## Bayes factor type: BFlinearModel, JZS
```


#### Interaction

The concept of an interaction...

## Exercises

:::{.exercise}
one-way
:::


:::{.exercise}
Two-way ANOVA with `affect` data


```r
lm(score ~ group * gender, data = affect)
```

```
## 
## Call:
## lm(formula = score ~ group * gender, data = affect)
## 
## Coefficients:
##         (Intercept)             groupLow         groupVeryLow  
##             0.19674             -0.10646             -0.37008  
##              gender      groupLow:gender  groupVeryLow:gender  
##            -0.05599              0.04698              0.07745
```


:::

### Further



\

## References
Glass G.V., Peckham P.D., Sanders J.R. (1972). Consequences of failure to meet assumptions underlying the fixed effects analyses of variance and covariance. Review of Educational Research. 42:237–288. https://doi.org/10.3102%2F00346543042003237

Meidenbauer, K. L., Stenfors, C. U., Bratman, G. N., Gross, J. J., Schertz, K. E., Choe, K. W., & Berman, M. G. (2020). The affective benefits of nature exposure: What's nature got to do with it?. Journal of Environmental Psychology, 72, 101498. https://doi.org/10.1016/j.jenvp.2020.101498

Schmider E., Ziegler M., Danay E., Beyer L., Bühner M. (2010). Is it really robust? Methodology. 6:147–151. doi: 10.1027/1614-2241/a000016




