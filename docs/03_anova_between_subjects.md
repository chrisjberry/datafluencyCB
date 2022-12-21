# ANOVA: between-subjects designs {#anova1}

*Chris Berry*
\
*2023*



<!--
commented text
commented text
--> 


<style>
div.exercise { background-color:#e6f0ff; border-radius: 5px; padding: 20px;}
</style>

<style>
div.tip { background-color:#D5F5E3; border-radius: 5px; padding: 20px;}
</style>


## Overview

* **Slides** from the lecture part of the session: [Download](slides/PSYC753_L3_ANOVA_1.pptx)

\


So far we have used regression where both the outcome and predictor are _continuous variables_.

When all the _predictor variables_ in a regression are categorical, the analysis is called **ANOVA**, which stands for Analysis Of VAriance. Here we consider two types of ANOVA for between-subjects designs: one-way ANOVA and two-way ANOVA. We will consider other types in future sessions (e.g., for within-subjects/repeated measures designs).


## One-way between subjects ANOVA

:::{.tip}
**A one-way between subjects ANOVA** is used to compare the scores from a dependent variable across different groups of individuals. For example, do **mood** scores differ between three groups of individuals, where each group undergoes a different type of therapy as treatment? 
:::

\

  * **one-way** means that there is one independent variable, for example, _type of therapy_. 
  * Independent variables are also called **factors** in ANOVA. 
  * A factor is made up of different **levels**. _Type of therapy_ could have three levels: CBT (Cognitive Behavioural Therapy), EMDR (Eye Movement Desensitisation and Reprocessing), and Control.
  * **between subjects** means that a different group of participants gives us mood scores for each level of the independent variable. For example, if type of therapy is manipulated between-subjects, one group receives CBT, another group receives EMDR, and another group are the control group. Each participant provides exactly one score.





### Worked Example

What is the effect of viewing pictures of different aesthetic value on a person's mood? To investigate, Meidenbauer et al. (2020) showed three groups of participants pictures of urban environments that were either very low in aesthetic value (_n_ = 102), low in aesthetic value (_n_ = 100), or high (_n_ = 104). Participants' change in State Trait Anxiety Inventory (STAI: a measure of negative symptoms such as upset, tense, worried) as a result of viewing the pictures was measured.

:::{.exercise}

Design check.

* What is the independent variable (or _factor_) in this design? <select class='webex-select'><option value='blank'></option><option value=''>change in STAI score</option><option value='answer'>aesthetic appeal of the pictures</option></select>

* How many levels does the factor have? <select class='webex-select'><option value='blank'></option><option value=''>1</option><option value=''>2</option><option value='answer'>3</option><option value=''>4</option></select>

* What is the dependent variable? <select class='webex-select'><option value='blank'></option><option value=''>VeryLow, Low, High</option><option value='answer'>change in STAI score</option><option value=''>aesthetic appeal of images</option></select>

* What is the nature of the independent variable? <select class='webex-select'><option value='blank'></option><option value='answer'>categorical</option><option value=''>continuous</option></select>

* Is the independent variable manipulated within- or between-subjects?
<select class='webex-select'><option value='blank'></option><option value='answer'>between-subjects</option><option value=''>within-subjects</option></select>

:::

\

### Read in the data

Read in the data at the link below and store in `affect_data`. Preview the data using `head()`.

  https://raw.githubusercontent.com/chrisjberry/Teaching/master/3_affect.csv

(Note. The data in are taken from the Urban condition of Meidenbauer et al. (2020, Experiment 1). The data are publicly available through the links in their article. The variable names have been changed here for clarity.)



```r
# Read in the data
affect_data <- read_csv('https://raw.githubusercontent.com/chrisjberry/Teaching/master/3_affect.csv')

# look at the first 6 rows
affect_data %>% head()
```
Key variables of interest in `affect_data`:

* `group`: the aesthetic value group, with levels `VeryLow`, `Low` and `High`
* `score`: the change in STAI score. Higher scores indicate _fewer_ negative symptoms after viewing the images (i.e., _improvement_ in mood).


<div class='webex-solution'><button>Variable labels</button>

Notice that the `group` column is by default read into R as a _character variable_ (that's what the label `<chr>` means in the output). This is because the levels of `group` have been recorded in the dataset as words e.g., "VeryLow".

</div>


\

### Convert the independent variable to a factor

To enable us to use the `group` column in an ANOVA, we need to tell R that `group` is a _factor_. Use `mutate()` and `factor()` to convert `group` to a factor.


```r
# use mutate() to convert the group variable to a factor
# store the changes back in affect_data 
# (i.e., overwrite what's already in affect_data)

affect_data <-
  affect_data %>% 
  mutate(group = factor(group))
```


<div class='webex-solution'><button>Remember</button>


`mutate()` can be used to change variables or create new ones.

\

The code `mutate(group = factor(group))` means: 

* `group = `: create a variable called `group`. Because `group` already exists in `affect_data` it will be overwritten.
* `factor(group)`: convert the `group` variable to a factor.


</div>




<div class='webex-solution'><button>Tip</button>


If we'd have used:

`factor(group, levels = c("VeryLow","Low","High"))`

instead of 

`factor(group)`

this would mean that the levels of `group` will additionally be _ordered_ according to the order in `levels`.

This can be useful when plotting the data.


</div>



<div class='webex-solution'><button>Check</button>

Check that the variable label for `group` has now changed from `<chr>` to `<fct>` (i.e., a factor) by looking at the dataset again.

```r
affect_data
```

</div>



\

### n of each group

Use `group_by()` and `count()` to obtain the number of participants in each group:


```r
# use group_by() to group the output by 'group' column, 
# then obtain number of rows in each group with count()

affect_data %>% 
  group_by(group) %>% 
  count()
```
* How many participants were there in the `VeryLow` aesthetic value group? <input class='webex-solveme nospaces' size='3' data-answer='["102"]'/>
* How many participants were there in the `Low` aesthetic value group? <input class='webex-solveme nospaces' size='3' data-answer='["100"]'/>
* How many participants were there in the `High` aesthetic value group? <input class='webex-solveme nospaces' size='3' data-answer='["104"]'/>

\

### Visualise the data

The way the data are distributed in each group can be inspected with histograms or density plots:


```r
# Histogram of scores in each group 
# Use facet_wrap(~group) to create a separate
# panel for each group

affect_data %>% 
  ggplot(aes(score)) +
  geom_histogram() + 
  facet_wrap(~group)
```

<div class="figure" style="text-align: center">
<img src="03_anova_between_subjects_files/figure-html/unnamed-chunk-6-1.png" alt="Histogram of scores in each aesthetic value group" width="75%" />
<p class="caption">(\#fig:unnamed-chunk-6)Histogram of scores in each aesthetic value group</p>
</div>


<div class='webex-solution'><button>Tip</button>


To produce density plots, swap `geom_histogram()` with `geom_density()`.


</div>



<div class='webex-solution'><button>Comments on the histograms</button>

The spread of scores in each group appears relatively similar, suggesting the assumption of homogeneity of variance in ANOVA, may be met. The distributions are reasonably symmetrical, and, aside from the very high number of 0 scores in each group (indicative of zero change in STAI score in a large number of individuals), the data appear approximately normally distributed. In practice, ANOVA is considered reasonably robust against violations of the test's assumptions (see e.g., Glass et al. 1972, Schmider et al., 2010).

</div>


\

### Plot the means

Visualise the data further by obtaining a plot of the mean score in each group.

The package `ggpubr` can produce high quality plots with ease. Using `ggerrorplot()` in `ggpubr`:


```r
# load the ggpubr package
library(ggpubr)

# plot the mean of each group 
# specify desc_stat = "mean_se" to 
# add error bars representing the standard error 

affect_data %>% 
  ggerrorplot(x = "group" , y = "score", desc_stat = "mean_se") +
  xlab("Aesthetic value group") 
```

<div class="figure" style="text-align: center">
<img src="03_anova_between_subjects_files/figure-html/unnamed-chunk-7-1.png" alt="Mean change in STAI score across aesthetic value groups (error bars indicate SE)" width="75%" />
<p class="caption">(\#fig:unnamed-chunk-7)Mean change in STAI score across aesthetic value groups (error bars indicate SE)</p>
</div>
\

From inspection of the means:

* Which aesthetic value group has the greatest improvement in STAI score? <select class='webex-select'><option value='blank'></option><option value='answer'>High</option><option value=''>Low</option><option value=''>VeryLow</option></select>
* Which aesthetic value group has the lowest improvement in STAI score? <select class='webex-select'><option value='blank'></option><option value=''>High</option><option value=''>Low</option><option value='answer'>VeryLow</option></select>
* Did STAI scores appear to worsen (i.e., be below zero) in any group as a result of viewing the images? <select class='webex-select'><option value='blank'></option><option value=''>High group</option><option value=''>Low group</option><option value='answer'>VeryLow group</option></select>



<div class='webex-solution'><button>Developing the plot</button>

As with plots generated in `ggplot()`, the figure can be enhanced by adding further code, e.g., try adding the line:

`+ ylab("Change in STAI (negative symptoms)")`

\

Beneath the surface, `ggpubr` uses `ggplot()` to make graphs.

\

Other types of plot are available in `ggpubr`, see e.g.:

* Errorplots: `?ggerrorplot()`
* Boxplots: `?ggboxplot()`
* Violin plots: `?ggviolin()`

I encourage you to play around to find clear and effective ways to visualise your data!

To see more types of plot: `help(package = ggpubr)`


</div>


\

### Descriptives: Mean of each group

Use `summarise()` and `group_by()` to obtain the mean (_M_) in each group:


```r
affect_data %>% 
  group_by(group) %>% 
  summarise(M = mean(score))
```

* The mean score in the `High` group is (to 2 decimal places) <input class='webex-solveme nospaces' size='4' data-answer='["0.11"]'/>
* The mean score in the `Low` group is (to 2 decimal places) <input class='webex-solveme nospaces' size='4' data-answer='["0.08"]'/>
* The mean score in the `VeryLow` group is (to 2 decimal places) <input class='webex-solveme nospaces' size='5' data-answer='["-0.14"]'/>



<div class='webex-solution'><button>Tip - Standard Error</button>


The formula for the standard error of the mean is $SD / \sqrt{n}$. We can therefore obtain the standard error of the mean for each group as follows:


```r
affect_data %>% 
  group_by(group) %>% 
  summarise(SE = sd(score) / sqrt( n() ))
```


To show the mean and SE in the same output:


```r
affect_data %>% 
  group_by(group) %>% 
  summarise( M = mean(score), 
             SE = sd(score) / sqrt( n() ) )
```


</div>


\


### Bayes factor

:::{.tip}

A Bayes factor can be obtained for the one-way ANOVA model using `anovaBF()`. The model we specify is of `score` on the basis of `group` (i.e., `score ~ group`). The BF will tell us how much more likely the model (with different three groups) is than an intercept-only model, in which all the scores are treated as coming from one large group. In other words, the BF will tell us whether we have evidence for an effect of aesthetic appeal on the STAI scores or not.

:::

\

To obtain the BF for the one-way ANOVA model, use `anovaBF()`:


```r
# ensure BayesFactor package is loaded
# library(BayesFactor)

# obtain the BF for the ANOVA model with lmBF()
anovaBF( score ~ group, data = data.frame(affect_data) )
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

The Bayes Factor for the model is equal to BF = <input class='webex-solveme nospaces' size='5' data-answer='["66.66"]'/>. This indicates that the model is over <select class='webex-select'><option value='blank'></option><option value=''>six</option><option value='answer'>sixty</option><option value=''>six hundred</option></select> times more likely than an intercept-only model. There is therefore substantial evidence for an effect of the aesthetic value of urban images on changes in STAI scores.



<div class='webex-solution'><button>Tip - lmBF()</button>


`lmBF()` in the `BayesFactor` package can be used in place of `lmBF()` to produce exactly the same result:


```r
lmBF( score ~ group, data = data.frame(affect_data) )
```

Remember, this works because ANOVA is a special case of regression.


</div>


\

### R^2^

:::{.tip}
R^2^ can be reported for ANOVA models as a measure of _effect size_. As with simple and multiple regression, R^2^ represents the proportion of variance explained by the model, where our model is that the scores come from distinct groups of individuals (three groups in our example) with different means.
:::

\

To obtain R^2^, first use `lm()` to specify the model, then use `glance()` from the `broom` package:


```r
# specify and store the anova
anova_1 <- lm(score ~ group, data = affect_data)

# make sure broom package is loaded, then
# use glance() with anova_1 
glance(anova_1)
```

<div class="kable-table">

| r.squared| adj.r.squared|  sigma| statistic|   p.value| df|    logLik|      AIC|      BIC| deviance| df.residual| nobs|
|---------:|-------------:|------:|---------:|---------:|--:|---------:|--------:|--------:|--------:|-----------:|----:|
| 0.0523547|     0.0460996| 0.4743|  8.369943| 0.0002896|  2| -204.4377| 416.8754| 431.7697| 68.16302|         303|  306|

</div>
Adjusted R^2^ (as a *percentage*, to two decimal places) = <input class='webex-solveme nospaces' size='4' data-answer='["4.61"]'/> %, which represents the percentage of the variance in the change in STAI scores is explained by the affect value of an image. (Remember, the values given by `glance()` are _proportions_, so need to be multiplied by 100 to get the percentage.)

\

### Follow-up tests

The Bayes factor (66.66) tells us that there's evidence that the means of the three groups differ from one another, but not which groups differ from which. 

With three groups, there are three possible pairwise comparisons that can be made:

* `VeryLow` vs. `Low`
* `VeryLow` vs. `High` 
* `Low` vs. `High`

To compare scores from two groups, we can use `filter()` to filter the `affect_data` so that it contains only the two groups we want to compare. Then use `anovaBF()` again to compare the scores across groups. The BF will tell us how many times more likely it is that there's a difference between means, compared to no difference.


```r
# Compare scores of VeryLow vs. Low groups
#
# Step 1. Filter affect_data for VeryLow and Low groups only
# Store in 'groups_VeryLow_Low'
groups_VeryLow_Low <- 
  affect_data %>% 
  filter(group == "VeryLow" | group == "Low")
#
# Step 2. Obtain BF for VeryLow vs. Low groups
anovaBF(score ~ group, data = data.frame(groups_VeryLow_Low))


# Compare scores of VeryLow vs. High groups
#
# Step 1. Filter affect_data for VeryLow and High groups only
# Store in 'groups_VeryLow_High'
groups_VeryLow_High <- 
  affect_data %>% 
  filter(group == "VeryLow" | group == "High")
#
# Step 2. Obtain BF for VeryLow vs. Low groups
anovaBF(score ~ group, data = data.frame(groups_VeryLow_High))


# Compare scores of Low vs. High groups
#
# Step 1. Filter affect_data to store Low and High groups only
# Store in 'groups_Low_High'
groups_Low_High <- 
  affect_data %>% 
  filter(group == "Low" | group == "High")
#
# Step 2. Obtain BF for VeryLow vs. Low groups
anovaBF(score ~ group, data = data.frame(groups_Low_High))
```

```
## Bayes factor analysis
## --------------
## [1] group : 10.25237 ±0%
## 
## Against denominator:
##   Intercept only 
## ---
## Bayes factor type: BFlinearModel, JZS
## 
## Bayes factor analysis
## --------------
## [1] group : 55.43484 ±0%
## 
## Against denominator:
##   Intercept only 
## ---
## Bayes factor type: BFlinearModel, JZS
## 
## Bayes factor analysis
## --------------
## [1] group : 0.1774611 ±0.06%
## 
## Against denominator:
##   Intercept only 
## ---
## Bayes factor type: BFlinearModel, JZS
```
To two decimal places:

* The BF for the comparison of `VeryLow` vs. `Low` groups = <input class='webex-solveme nospaces' size='5' data-answer='["10.25"]'/>
* The BF for the comparison of `VeryLow` vs. `High` groups = <input class='webex-solveme nospaces' size='5' data-answer='["55.43"]'/>
* The BF for the comparison of `Low` vs. `High` groups = <input class='webex-solveme nospaces' size='4' data-answer='["0.18"]'/>

**Interpretation:** The one-way between subjects ANOVA indicated that there was evidence for an effect of aesthetic value on change in STAI scores (BF = 66.66). The scores in the `VeryLow` group were lower than those of the `Low` (BF = 10.25) and `High` groups (BF = 55.43), but scores in the `Low` and `High` groups did not differ (BF = 0.18). This indicates that STAI scores were lower (i.e., there were more negative symptoms) after viewing images that were very low in aesthetic value, compared to images that were low or high in aesthetic value. Viewing pictures that were low or high in aesthetic value resulted in similar changes in STAI scores.


<div class='webex-solution'><button>Further information on filter()</button>


* The `|` symbol means "or".
* The `==` symbol (an equals sign typed twice) means "is equal to"

So `filter(group == "VeryLow" | group == "Low")` means "filter the rows of `affect_data` when the labels in `group` are equal to `VeryLow` OR the labels in `group` are equal to `Low`


</div>




<div class='webex-solution'><button>An equivalent approach: ttestBF()</button>


`anovaBF()` was used to conduct follow-up tests. Because each test had two groups, this is equivalent to a Bayesian _t_-test, and so the exact same BFs could have been obtained using `ttestBF()`:


```r
# Compare scores of VeryLow vs. Low groups
ttestBF( x = affect_data$score[ affect_data$group=="VeryLow" ], 
         y = affect_data$score[ affect_data$group=="Low" ] )

# compare scores of VeryLow vs. High groups
ttestBF( x = affect_data$score[ affect_data$group=="VeryLow" ], 
         y = affect_data$score[ affect_data$group=="High" ] )

# compare scores of Low vs. High groups
ttestBF( x = affect_data$score[ affect_data$group=="Low" ], 
         y = affect_data$score[ affect_data$group=="High" ] )
```


</div>



\

## Two-way between-subjects ANOVA

:::{.tip}
In a **two-way ANOVA**, there are _two_ categorical independent variables or factors. 

When there are multiple factors, the ANOVA is referred to as _factorial_ ANOVA. 

For example, if the design has two factors, and each factor has two levels, then we refer to the design as a 2 x 2 factorial design. The first number (2) denotes the number of levels of the first factor. The second number (2) denotes the number of levels of the second factor. If, instead, the second factor had three levels, we'd say we have a 2 x 3 factorial design.

:::

### Worked example

What is the role of resilience in the distress experienced from childhood adversities? Beutel et al. (2017) analysed the distress scores from 2,437 individuals who were either low or high in trait resilience and had experienced either low or high levels of childhood adversity.


:::{.exercise}

Design check.

* What is the first independent variable (or _factor_) that is mentioned in this design? <select class='webex-select'><option value='blank'></option><option value=''>distress score</option><option value=''>childhood adversity</option><option value='answer'>resilience</option></select>

* How many levels does the first factor have? <select class='webex-select'><option value='blank'></option><option value=''>1</option><option value='answer'>2</option><option value=''>3</option><option value=''>4</option></select>

* What is the second independent variable (or _factor_)? <select class='webex-select'><option value='blank'></option><option value=''>distress score</option><option value='answer'>childhood adversity</option><option value=''>trait resilience</option></select>

* How many levels does the second factor have? <select class='webex-select'><option value='blank'></option><option value=''>1</option><option value='answer'>2</option><option value=''>3</option><option value=''>4</option></select>

* What is the dependent variable? <select class='webex-select'><option value='blank'></option><option value='answer'>distress score</option><option value=''>childhood adversity</option><option value=''>trait resilience</option></select>

* What is the nature of the independent variables? <select class='webex-select'><option value='blank'></option><option value='answer'>categorical</option><option value=''>continuous</option></select>

* What type of design is this? <select class='webex-select'><option value='blank'></option><option value=''>2 x 2 x 2 between subjects factorial design</option><option value=''>2 x 3 between subjects factorial design</option><option value='answer'>2 x 2 between subjects factorial design</option><option value=''>correlational design</option></select>

:::



### Read in the data

Read in the data at the link below and store in `resilience_data`:

https://raw.githubusercontent.com/chrisjberry/Teaching/master/3_resilience_data.csv



```r
# read in the data
resilience_data <- read_csv('https://raw.githubusercontent.com/chrisjberry/Teaching/master/3_resilience_data.csv')

# preview
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

* `distress` contains the distress scores. Higher scores indicate greater levels of distress.
* `resilience` labels the levels of childhood adversity ( _low_ or _high_)
* `adversity` labels the levels of trait resilience ( _low_ or _high_)

(Note. The data are publicly available, but I have changed some of the variable names for clarity.)

\

### Convert the independent variables to factors

To enable the factors to be used as such in ANOVA, we need to convert them to factors using `factor()`:


```r
# use mutate() and factor() to convert 
# resilience and adversity to factors

resilience_data <- 
  resilience_data %>% 
  mutate(resilience = factor(resilience),
         adversity  = factor(adversity))
```


### n in each group

Obtain the number of participants in each group:


```r
# use count() to obtain the number of rows in the dataset, 
# group_by() both resilience AND adversity
resilience_data %>% 
  group_by(resilience, adversity) %>% 
  count()
```

<div class="kable-table">

|resilience |adversity |    n|
|:----------|:---------|----:|
|high       |high      |  106|
|high       |low       |  997|
|low        |high      |  284|
|low        |low       | 1050|

</div>

In a between-subjects factorial design, participants are assigned to groups by crossing the levels of one variable with those of the second variable. Thus, each row labels the level of resilience and level of adversity for that group.

* The number of participants in the high resilience, high adversity group is <input class='webex-solveme nospaces' size='3' data-answer='["106"]'/>
* The number of participants in the high resilience, low adversity group is <input class='webex-solveme nospaces' size='3' data-answer='["997"]'/>
* The number of participants in the low resilience, high adversity group is <input class='webex-solveme nospaces' size='3' data-answer='["284"]'/>
* The number of participants in the low resilience, low adversity group is <input class='webex-solveme nospaces' size='4' data-answer='["1050"]'/>

\


### Visualise the data

The way the data are distributed in each group can be inspected with histograms or density plots.


```r
# Use `facet_wrap(~ resilience * adversity)`
# to plot scores for all combinations of 
# resilience x adversity levels
# use 'labeller = label_both' to label levels by factor name

resilience_data %>% 
  ggplot(aes(distress)) + 
  geom_density() +
  facet_wrap(~ resilience * adversity, labeller = label_both)
```

<div class="figure" style="text-align: center">
<img src="03_anova_between_subjects_files/figure-html/unnamed-chunk-19-1.png" alt="Density plots showing distress scores in each group)" width="75%" />
<p class="caption">(\#fig:unnamed-chunk-19)Density plots showing distress scores in each group)</p>
</div>
**Interpretation:** The data in each group appear positively skewed - the tail of the distribution goes towards the right (i.e., towards more positive values of distress). Beutel et al. (2017) took no further action and analysed the scores as they were.

\

### Plot the means

Use `ggbarplot()` in the `ggpubr` package:


```r
library(ggpubr)

# plot the mean of each group
# use 'desc_stat = "mean_se" to add SE error bars
# use 'position = position_dodge(0.3)' so that points are spaced
resilience_data %>% 
  ggerrorplot(x = "resilience", y = "distress",  color = "adversity",
              desc_stat = "mean_se", 
              position = position_dodge(0.3)) +
  xlab("Resilience") +
  ylab("Distress") 
```

<div class="figure" style="text-align: center">
<img src="03_anova_between_subjects_files/figure-html/unnamed-chunk-20-1.png" alt="Distress as a function of adversity and resilience (error bars indicate SE of the mean)" width="75%" />
<p class="caption">(\#fig:unnamed-chunk-20)Distress as a function of adversity and resilience (error bars indicate SE of the mean)</p>
</div>

\

:::{.tip}

In a two-way design, researchers look at three things:

* **The main effect of factor 1**: Overall, do scores differ according to the levels of factor 1?
* **The main effect of factor 2**: Overall, do scores differ according to the levels of factor 2?
* **The interaction between the factors**: Is the effect of one factor different at _each level_ of the other factor?

:::

\

We can get some idea of the main effects and interaction by inspecting the plot of the means:

* **The main effect of resilience:** Overall, distress scores in the high resilience groups appear to be <select class='webex-select'><option value='blank'></option><option value='answer'>lower than</option><option value=''>about the same as</option><option value=''>higher than</option></select> those in the low resilience groups.
* **The main effect of adversity**: Overall, distress scores in the low adversity groups appear to be <select class='webex-select'><option value='blank'></option><option value='answer'>lower than</option><option value=''>about the same as</option><option value=''>higher than</option></select> those in the high adversity groups.
* **The interaction between resilience and distress**: When trait resilience is low rather than high, the effect of adversity on distress appears to be <select class='webex-select'><option value='blank'></option><option value=''>lower</option><option value=''>similar</option><option value='answer'>greater</option></select>. (Hint: the effect of adversity is indicated by the difference between the red and blue points.)


\


### Bayes factors

:::{.tip}

Use `anovaBF()` in the `BayesFactor` package to obtain Bayes Factors corresponding to the main effect of factor 1, the main effect of factor 2, and the interaction between factor 1 and factor 2. 

To specify the two-way ANOVA in `anovaBF()`, use `dependent_variable ~ factor1 * factor2`. 

:::

\

For the resilience data:

```r
# Obtain the Bayes Factors for the ANOVA model
anova2x2_BF <- anovaBF( distress ~ resilience * adversity, data = data.frame(resilience_data) )

# look at the output
anova2x2_BF
```

```
## Bayes factor analysis
## --------------
## [1] resilience                                    : 1.822053e+27 ±0%
## [2] adversity                                     : 7.870878e+25 ±0%
## [3] resilience + adversity                        : 3.339074e+46 ±2.16%
## [4] resilience + adversity + resilience:adversity : 3.130195e+49 ±2.06%
## 
## Against denominator:
##   Intercept only 
## ---
## Bayes factor type: BFlinearModel, JZS
```

<div class='webex-solution'><button>What does 1.82e+27 mean?</button>

It means 1.82 x 10^27^. Or 1820000000000000000000000000. A very large number! For more information see:
<a href="https://chrisjberry.github.io/datafluencyCB/faqs#e-meaning" target="_blank">FAQ</a> (Opens a new tab.)

</div>


Each BF in the output compares how likely the model is, compared to an intercept only model:

* `[1] resilience` is the BF for the main effect of resilience. It's how much more likely a model with `resilience` alone is than an intercept-only model.
* `[2] adversity` is the BF for the main effect of adversity. It's how much more likely a model with `adversity` alone is than an intercept-only model.  
* `[3] resilience + adversity` is the BF for the main effects of resilience and adversity. It's how much more likely a model with main effects of `resilience` and `adversity` is than an intercept-only model.  
* `[4] resilience + adversity + resilience:adversity` is the BF for the main effects of resilience and adversity **and** the interaction between them (`resilience:adversity`). It's how much more likely a model with main effects of `resilience` and `adversity` and also the interaction (`resilience:adversity`) is than an intercept-only model.  

`[1]` and `[2]` correspond to the main effects of `resilience` and `adversity`, respectively. To obtain the BF for the interaction,  we need to divide `[4]` by `[3]`:


```r
# BF for the interaction
anova2x2_BF[4] / anova2x2_BF[3]
```

```
## Bayes factor analysis
## --------------
## [1] resilience + adversity + resilience:adversity : 937.444 ±2.98%
## 
## Against denominator:
##   distress ~ resilience + adversity 
## ---
## Bayes factor type: BFlinearModel, JZS
```
This BF then tells us whether there's evidence for the addition of an interaction term to a model containing the main effects of each factor. This is the BF for the interaction.


Record the Bayes factors below:

* The BF for the main effect of `resilience` is BF = <input class='webex-solveme nospaces' size='4' data-answer='["1.82"]'/> x 10^27^.
* The BF for the main effect of `adversity` is BF = <input class='webex-solveme nospaces' size='4' data-answer='["7.87"]'/> x 10^25^.
* The BF for the `resilience` and `adversity` interaction is approximately (to the nearest whole number). _Remember_, this is the BF you calculated by dividing `[4]` by `[3]`. BF = <input class='webex-solveme nospaces' data-tol='10' size='3' data-answer='["939"]'/>.


<div class='webex-solution'><button>Meaning of ±number%</button>

You'll notice that some of BFs had `±1.03%` or similar next to them in the output. This is the error associated with the BF. It's like saying my height is 185 cm, plus or minus a millimeter or so. It can be non-zero because generation of the BFs involves random sampling processes. Larger error values mean that the exact same value of the BF won't necessarily be output each time the line of code containing `anovaBF()` is run, so there's a chance that the BFs in your output differ slightly from those above (particularly for the interaction). This is why I asked you to give your answer to the nearest whole number.

</div>


\

### R^2^

:::{.tip}
Once again, `glance()` can be used to obtain R^2^ for the ANOVA model. The model first needs to be specified with `lm()`. Using  `factor1 * factor2` when specifying the model is a shortcut, which will automatically specify the full model containing the interaction. Thus, we can use `lm(distress ~ resilience * adversity)`, which is equivalent to `lm(distress ~ resilience + adversity + resilience*adversity)`.
:::

\


```r
# specify the ANOVA model using lm()
anova2x2 <- lm(distress ~ resilience * adversity, data = resilience_data)

# R^2^
glance(anova2x2)
```

<div class="kable-table">

| r.squared| adj.r.squared|    sigma| statistic| p.value| df|    logLik|      AIC|      BIC| deviance| df.residual| nobs|
|---------:|-------------:|--------:|---------:|-------:|--:|---------:|--------:|--------:|--------:|-----------:|----:|
| 0.0963021|     0.0951878| 2.142569|  86.42379|       0|  3| -5312.959| 10635.92| 10664.91| 11168.93|        2433| 2437|

</div>

The adjusted R^2^ of the ANOVA model (to two decimal places, as a _percentage_) is <input class='webex-solveme nospaces' size='4' data-answer='["9.52"]'/> %, which is the percentage of variance in distress explained by the model.

\

### Follow-up comparisons

Given that we have evidence for an interaction, `anovaBF()` can be used to conduct follow-up comparisons to explore the nature of the interaction. (Note, we would not do this if the BF did not show evidence for the interaction, i.e., if the BF was less than 3.)

The interaction implies the effect of `adversity` is different in individuals with `high` resilience, and those with `low` resilience.

To determine the evidence for the effect of adversity in individuals with high resilience:

```r
# 1. The effect of adversity in individuals with high resilience

# First use filter() to store only 
# the data from the 'high' resilience groups
resilience_high <- 
  resilience_data %>% 
  filter(resilience == "high")

# Then use `anovaBF()` to look at effect of adversity in resilience_high
anovaBF( distress ~ adversity, data = data.frame(resilience_high) )
```

```
## Bayes factor analysis
## --------------
## [1] adversity : 1.026598 ±0.02%
## 
## Against denominator:
##   Intercept only 
## ---
## Bayes factor type: BFlinearModel, JZS
```

To determine the evidence for the effect of `adversity` in individuals with `low` resilience:


```r
# 2. The effect of adversity in individuals with low resilience

# First use filter() to store only 
# the data from the 'low' resilience groups
resilience_low <- 
  resilience_data %>% 
  filter(resilience == "low")

# Then use `anovaBF()` to look at effect of adversity in resilience_low
anovaBF( distress ~ adversity, data = data.frame(resilience_low) )
```

```
## Bayes factor analysis
## --------------
## [1] adversity : 2.389569e+17 ±0%
## 
## Against denominator:
##   Intercept only 
## ---
## Bayes factor type: BFlinearModel, JZS
```

This confirms the interaction that is apparent in the plot: There's no evidence for an effect of adversity within high resilience individuals (BF = <input class='webex-solveme nospaces' size='4' data-answer='["1.03"]'/>), but there's substantial evidence for an effect of adversity within low resilience individuals (BF = <input class='webex-solveme nospaces' size='4' data-answer='["2.39"]'/>x 10^17^), such that levels of distress are greatest when the level of adversity is highest. Interestingly, this suggests that resilience may have a _buffering effect_ on the distress experienced as a result of childhood adversity (see Beutel et al., 2017, for further discussion).

\

## Exercise: one-way

:::{.exercise}

One-way ANOVA

The data at the link below are from a study by Bobak et al. (2016). They looked at the face matching `performance` of individuals with superior face recognition abilities, so called "super recognisers". Their performance was compared to two control groups. In one control group, payment was linked to performance (labelled "motivated_control"). The individuals in the other control group were not paid (labelled "control"). The column `face_group` contains the labels for each group. 

https://raw.githubusercontent.com/chrisjberry/Teaching/master/3_super_data.csv

Conduct a one-way ANOVA to compare the `performance` across the three groups.

\

**Adapt the code in this worksheet to do the following:**
**Try not to look at the solutions before you've attempted them**

**1. Read in the data and store in `super_data`**


<div class='webex-solution'><button>Hint</button>

Ensure the `tidyverse` package is loaded. See `?read_csv()` 

</div>
 


<div class='webex-solution'><button>Solution</button>


```r
super_data <- read_csv('https://raw.githubusercontent.com/chrisjberry/Teaching/master/3_super_data.csv')

# look at the raw data
super_data
```

</div>
 

\


**2. Convert the independent variable to a factor**


<div class='webex-solution'><button>Hint</button>

See `?mutate()` and `?factor()` 

</div>
 


<div class='webex-solution'><button>Solution</button>


```r
super_data <- 
  super_data %>% 
  mutate( face_group = factor(face_group) )
```

</div>
 

\

**3. Obtain n in each group**


<div class='webex-solution'><button>Hint</button>

Pipe the data to `group_by()` and `count()`

</div>
 


<div class='webex-solution'><button>Solution</button>


```r
super_data %>% 
  group_by(face_group) %>% 
  count()
```

</div>
 

* _n_ super recognisers = <input class='webex-solveme nospaces' size='1' data-answer='["7"]'/>
* _n_ motivated_control = <input class='webex-solveme nospaces' size='2' data-answer='["20"]'/>
* _n_ control = <input class='webex-solveme nospaces' size='2' data-answer='["20"]'/>

\

**4. Produce a histogram of scores in each group**


<div class='webex-solution'><button>Hint</button>

Pipe the data to `ggplot()` and `geom_histogram()` and `facet_wrap()`

</div>
 


<div class='webex-solution'><button>Solution</button>


```r
super_data %>% 
  ggplot(aes(performance)) +
  geom_histogram() +
  facet_wrap(~face_group)
```

</div>


\


**5. Produce a plot of the means (with SEs) in each group**


<div class='webex-solution'><button>Hint</button>

`?ggerrorplot()` in the `ggpubr` package

</div>
 


<div class='webex-solution'><button>Solution</button>


```r
 # produce means plot

super_data %>% 
  ggerrorplot(x = "face_group", y ="performance", desc_stat = "mean_se") +
  xlab("Group") +
  ylab("Face matching performance")
```

</div>


\

**6. Obtain the mean and SE of each group**


<div class='webex-solution'><button>Hint</button>

Use `group_by()` and `summarise()` 

</div>
 


<div class='webex-solution'><button>Solution</button>


```r
super_data %>% 
  group_by(face_group) %>% 
  summarise( M  = mean(performance), 
             SE = sd(performance) / sqrt( n() ) )
```

</div>


* The mean score of the `super_recogniser` group is <input class='webex-solveme nospaces' size='4' data-answer='["4.23"]'/>, SE = <input class='webex-solveme nospaces' size='4' data-answer='["0.28"]'/>
* The mean score of the `motivated_control` group is <input class='webex-solveme nospaces' size='4' data-answer='["3.09"]'/>, SE = <input class='webex-solveme nospaces' size='4' data-answer='["0.14"]'/>
* The mean score of the `control` group is <input class='webex-solveme nospaces' size='4' data-answer='["2.82"]'/>, SE = <input class='webex-solveme nospaces' size='4' data-answer='["0.16"]'/>

\

**7. Obtain the Bayes factor for the ANOVA model**

* The Bayes factor for the model is equal to (to two decimal places) <input class='webex-solveme nospaces' size='6' data-answer='["118.27"]'/>.
* This indicates that there is <select class='webex-select'><option value='blank'></option><option value=''>no evidence</option><option value='answer'>substantial evidence</option></select> for an effect of the face group on matching performance.


<div class='webex-solution'><button>Hint</button>

`?anovaBF()`

</div>
 


<div class='webex-solution'><button>Solution</button>


```r
anovaBF(performance ~ face_group, data = data.frame(super_data))
```

</div>



\

**8. What is R^2^ for the model?**

The adjusted R^2^ for the effect of face group on matching performance is (as a _proportion_, to two decimal places) <input class='webex-solveme nospaces' size='4' data-answer='["0.30"]'/> 


<div class='webex-solution'><button>Hint</button>

obtain the model with `lm()`, then use `glance()`

</div>
 


<div class='webex-solution'><button>Solution</button>


```r
super_anova <- lm(performance ~ face_group, data = super_data)
glance(super_anova)
```

</div>


\

**9. Conduct follow-up tests to compare the mean score of each group**


<div class='webex-solution'><button>Hint</button>


* Use `filter()` to create new variables containing the scores of two groups at a time
* Then use `anovaBF()` to compare the scores of each group.

</div>
 


<div class='webex-solution'><button>Solution using anovaBF()</button>


```r
# super_recognisers vs. motivated_control
super_vs_motivated_controls <- 
  super_data %>%
  filter(face_group == "super_recogniser" | face_group == "motivated_control")

anovaBF(performance ~ face_group, data = data.frame(super_vs_motivated_controls))


# super_recognisers vs. control
super_vs_controls <- 
  super_data %>%
  filter(face_group == "super_recogniser" | face_group == "control")

anovaBF(performance ~ face_group, data = data.frame(super_vs_controls))


# motivated_control vs. control
motivated_control_vs_control <- 
  super_data %>%
  filter(face_group == "motivated_control" | face_group == "control")

anovaBF(performance ~ face_group, data = data.frame(motivated_control_vs_control))
```

</div>




<div class='webex-solution'><button>Solution using ttestBF()</button>


```r
# super_recognisers vs. motivated_control
ttestBF(x = super_data$performance[super_data$face_group == "super_recogniser"],
        y = super_data$performance[super_data$face_group == "motivated_control"])

# super_recognisers vs. control
ttestBF(x = super_data$performance[super_data$face_group == "super_recogniser"],
        y = super_data$performance[super_data$face_group == "control"])

# motivated_control vs. control
ttestBF(x = super_data$performance[super_data$face_group == "motivated_control"],
        y = super_data$performance[super_data$face_group == "control"])
```

</div>



* The Bayes factor comparing the `super_recogniser` and `motivated_control` groups is <input class='webex-solveme nospaces' size='5' data-answer='["47.28"]'/>, indicating <select class='webex-select'><option value='blank'></option><option value='answer'>substantial evidence for</option><option value=''>substantial evidence against there being</option></select> a difference between groups. 
* Face matching performance in the `super_recogniser` group was <select class='webex-select'><option value='blank'></option><option value=''>the same</option><option value=''>lower</option><option value='answer'>higher</option></select> than that of the `motivated_control` group. 
* The Bayes factor comparing the `super_recogniser` and `control` groups is <input class='webex-solveme nospaces' size='6' data-answer='["113.41"]'/>, indicating <select class='webex-select'><option value='blank'></option><option value='answer'>substantial evidence for</option><option value=''>substantial evidence against there being</option></select> a difference between groups. 
* Face matching performance in the `super_recogniser` group was <select class='webex-select'><option value='blank'></option><option value=''>the same</option><option value=''>lower</option><option value='answer'>higher</option></select> than that of the `control` group. 
* The Bayes factor comparing the `motivated_control` and `control` groups is <input class='webex-solveme nospaces' size='4' data-answer='["0.55"]'/>, indicating that there was <select class='webex-select'><option value='blank'></option><option value=''>substantial evidence for a</option><option value='answer'>insufficient evidence for a</option><option value=''>substantial evidence for an absence of a</option></select> difference between the scores of each group.


:::

\


## Exercise: two-way

:::{.exercise}

Two-way ANOVA 

Horstmann et al. (2018) looked at whether the type of `exchange` that people had with a robot would affect how long it would then take for them to switch it off. The type of `exchange` was either 'functional' or 'social'. Additionally, the researchers looked at the effect of the type of `objection` that the robot made during the conversation. The robot either voiced an 'objection' to being switched off, or voiced 'no objection'.

The `robot_data` are located at the link below:

https://raw.githubusercontent.com/chrisjberry/Teaching/master/3_robot_data.csv

\

**Adapt the code in this worksheet to do the following:**

1. **Conduct a two-way ANOVA to compare the effects of `exchange` and `objection` on `time`. Determine whether there's sufficient evidence for the following:**

* The main effect of `objection`: BF (to two decimal places) = <input class='webex-solveme nospaces' size='4' data-answer='["6.29"]'/>
* The main effect of `exchange`: BF (to two decimal places) = <input class='webex-solveme nospaces' size='4' data-answer='["0.74"]'/>
* The interaction between `exchange` and `objection`: BF (nearest whole number) = <input class='webex-solveme nospaces' data-tol='0.4' size='1' data-answer='["3"]'/>

\

2. **Conduct any follow-up tests concerning the interaction (if necessary).**

* The effect of `exchange` when the robot objected: BF (to two decimal places) = <input class='webex-solveme nospaces' size='4' data-answer='["1.55"]'/>
* The effect of `exchange` when the robot did not object: BF (to two decimal places) = <input class='webex-solveme nospaces' size='4' data-answer='["0.47"]'/>

\

3. **Interpret the main effects and interaction. What do they mean?**

\


<div class='webex-solution'><button>Hint - code</button>


* Read in the data to a variable called `robot_data`
* Convert the independent variables to factors using `factor()`
* Examine the distribution of `time` in each group using `geom_histogram()` or `geom_density()` in `ggplot()`
* Obtain summary statistics using `group_by()`, `count()` and `summarise(mean())`
* Use a plot from the `ggpubr` package to create a plot of the means (e.g., `ggerrorplot()`)
* Use `anovaBF()` to obtain the Bayes factors to allow you to assess evidence for the main effects and interaction.
* If there's evidence for an interaction, then conduct follow-up tests using `anovaBF()` or `ttestBF()`


</div>






<div class='webex-solution'><button>Solution - code</button>



```r
# ensure following packages have been loaded
# library(tidyverse)
# library(BayesFactor)
# library(ggpubr)

# read the data
robot_data <- read_csv('https://raw.githubusercontent.com/chrisjberry/Teaching/master/3_robot_data.csv')

# convert IVs to factors
robot_data <-
  robot_data %>% 
  mutate(exchange  = factor(exchange),
         objection = factor(objection)) 

# inspect distributions
robot_data %>% 
  ggplot( aes(time) ) + 
  geom_histogram() +
  facet_wrap(~ exchange*objection)

# obtain M and SE each group
robot_data %>% 
  group_by(exchange, objection) %>% 
  summarise( M = mean(time), SE = sd(time)/sqrt(n()) )

# plot of means
robot_data %>% 
  ggerrorplot(x = "objection", y = "time", color = "exchange",
              desc_stat = "mean_se", 
              position = position_dodge(0.3)) +
  xlab("Type of objection") +
  ylab("Switch off time (seconds)") 

# 2x2 ANOVA
BF_robot <- anovaBF( time ~ exchange*objection, data = data.frame(robot_data) )

# look at BFs
BF_robot

# main effect objection
BF_robot[1]

# main effect exchange
BF_robot[2]

# interaction
BF_robot[4] / BF_robot[3]


# Given the evidence for an interaction, conduct further comparisons

# 1. The effect of exchange when the robot objected (i.e., `objection`)

# use filter() to store only 
# the data from the 'objection' groups
robot_objection <- 
  robot_data %>% 
  filter(objection == "objection")

# use `anovaBF()` to look at effect of exchange in the objection groups
anovaBF( time ~ exchange, data = data.frame(robot_objection) )


# 2. The effect of exchange when the robot did not object

# use filter() to store only 
# the data from the 'no_objection' groups
robot_no_objection <- 
  robot_data %>% 
  filter(objection == "no_objection")

# use `anovaBF()` to look at effect of exchange in the no objection groups
anovaBF( time ~ exchange, data = data.frame(robot_no_objection) )


# For the interpretation of main effects:
#
# Obtain M and SE for the main effect of objection
robot_data %>% 
  group_by(objection) %>% 
  summarise( M = mean(time), 
             SE = sd(time)/sqrt(n()) )

# Obtain M and SE for the main effect of exchange
robot_data %>% 
  group_by(exchange) %>% 
  summarise( M = mean(time), 
             SE = sd(time)/sqrt(n()) )
```


</div>


\



<div class='webex-solution'><button>Hint - interpretation</button>

To aid your interpretation of the main effects and interaction, look at the mean of the scores in each group. In which groups is the `time` taken to switch off the robot longer than others? How does `time` differ according to type of `exchange`? How does `time` differ according to type of `objection`? Does the effect of `exchange` seem to be the same at each level of `objection`?

</div>




<div class='webex-solution'><button>Solution - interpretation</button>


There was substantial evidence for a main effect of objection on the time it took for a participant to switch off a robot (BF = 6.29). Participants took longer when the robot had previously mentioned that it objected to being switched off (_M_ = 10.00 seconds, _SE_ = 2.21), compared to when no objection was mentioned (_M_ = 4.69, _SE_ = 0.37).  

There was insufficient evidence for a main effect of exchange, given that the Bayes factor was inconclusive (BF = 0.74). Thus, there was no evidence to suggest that the time to switch off a robot differed according to whether the type of exchange was functional (_M_ = 8.69, _SE_ = 2.00) or social (_M_ = 5.54, _SE_ = 0.57).

The main effects should be viewed in light of the substantial evidence for an interaction between exchange and objection (BF = 3.28). This indicated that it took people longer to switch the robot off when the exchange had been functional, rather than social, but only if the robot had objected to being switched off (_M_ functional = 14.40, _SE_ = 4.11 vs. _M_ social = 6.19, _SE_ = 1.15). When the robot had not previously objected to being switched off, the times were similar following functional and social exchanges (_M_ functional = 4.28, SE = 0.59, vs. _M_ social = 5.05, SE = 0.48). Follow-up tests indicated insufficient evidence for the effect of exchange at each level of objection (i.e., BFs < 3 and BFs > 0.33): The Bayes factor for the effect of exchange when the robot objected was 1.55, and the Bayes factor for the effect of exchange when the robot did not object was 0.47. Thus, although there was evidence for an interaction, the pattern of differences within objection conditions was not confirmed.


</div>



:::

\

## Summary

* ANOVA is a special case of regression when the predictor variables are entirely categorical.
* A **one-way between-subjects ANOVA** has one independent variable, and separate groups of participants for each level of the independent variable. The test looks at whether the mean scores differ between groups. 
* A **two-way between-subjects ANOVA** has two independent variables (factors). Each factor has levels. Researchers examine evidence for the main effect of each factor and their interaction.
* The interaction examines the effect of one factor at each level of the other factor.
* If there's evidence for an interaction, follow-up comparisons can be performed.
* Use `anovaBF()` to obtain Bayes factors for the main effects and interaction. 

\


## References
Beutel M.E., Tibubos A.N., Klein E.M., Schmutzer G., Reiner I., Kocalevent R-D., et al. (2017) Childhood adversities and distress - The role of resilience in a representative sample. _PLoS ONE_, _12_(3): e0173826. https://doi.org/10.1371/journal.pone.0173826

Glass G.V., Peckham P.D., Sanders J.R. (1972). Consequences of failure to meet assumptions underlying the fixed effects analyses of variance and covariance. _Review of Educational Research_. _42_, 237–288. https://doi.org/10.3102%2F00346543042003237

Horstmann A.C., Bock N., Linhuber E., Szczuka J.M., Straßmann C., Kramer N.C. (2018) Do a
robot’s social skills and its objection discourage interactants from switching the robot off? _PLoS ONE_, _13_(7): e0201581. https://doi.org/10.1371/journal.pone.0201581

Meidenbauer, K. L., Stenfors, C. U., Bratman, G. N., Gross, J. J., Schertz, K. E., Choe, K. W., & Berman, M. G. (2020). The affective benefits of nature exposure: What's nature got to do with it?. _Journal of Environmental Psychology_, _72_, 101498. https://doi.org/10.1016/j.jenvp.2020.101498

Schmider E., Ziegler M., Danay E., Beyer L., Bühner M. (2010). Is it really robust? _Methodology_. _6_, 147–151. https://doi.org/10.1027/1614-2241/a000016
