# Mixed Models {#mixed}

*Chris Berry*
\
*2025*



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

* **Slides** from the lecture part of the session: [Download](slides/PSYC761_L8_MixedModels.pptx)
* **R Studio online** [Access here using University log-in](https://psyrstudio.plymouth.ac.uk/)

\

The use of mixed models is becoming more and more popular in the analysis of psychological experiments. This session is introductory, and for more detailed overviews, students should consult the Reference list.

\

:::{.tip}
**Mixed effects models** or **mixed models** are an extension of multiple regression that allow the _dependencies_ among groups of data points to be explicitly accounted for via additional random effects parameters. Dependency can arise because responses come from the same participant, stimulus set, or cluster (e.g., classroom or hospital).

This can also be useful in experiments where researchers measure responses across a set of **items**. Rather than deriving a single score across all items or trials (e.g., an accuracy measure, or a mean), all the responses can be entered into the analysis and the variance associated with the responses to each item across participants explicitly modelled. 

This technique can also circumvent the need to discard participants or trials with missing responses from the analysis (provided data are missing at random).

:::

\

## Types of mixed model

When the outcome variable is **continuous** (e.g., response time) the model is called a **Linear Mixed Model (LMM)**. 

If the outcome is **binary** (e.g., correct vs. incorrect), the model is called a  **Generalised Linear Mixed Model (GLMM)** and a different approach must be used to the one in this worksheet. (See the References for more detail.)



\

## `lme4`

Mixed models can be run using the `lme4` package (Bates et al., 2015).


```r
# load lme4
library(lme4)
```

We will use data from [Brown (2021)](https://journals.sagepub.com/doi/10.1177/2515245920960351):

- The data are from a response time (RT) experiment in which 53 participants were presented with a word on each trial. 
- Each word was presented either auditorily (audio-only condition), or both auditorily and visually (they saw each word spoken in a video clip) (audiovisual condition). There were 543 words in total.
- The participant's task was to listen to and repeat back each word while simultaneously performing a response time task. 
- Each participant was presented with words in both conditions.

\

The data is publicly avaialble via the Open Science Framework at https://osf.io/download/53wc4/. 

\

Load the data and store it in `rt_data`.


```r
# load data from Brown (2021), located on OSF
rt_data <- read_csv("https://osf.io/download/53wc4/")
```
\

Take a look at the first six rows of the data:


```r
# preview the data using head()
rt_data %>% head()
```

<div class="kable-table">

| PID|   RT|modality   |stim  |
|---:|----:|:----------|:-----|
| 301| 1024|Audio-only |gown  |
| 301|  838|Audio-only |might |
| 301| 1060|Audio-only |fern  |
| 301|  882|Audio-only |vane  |
| 301|  971|Audio-only |pup   |
| 301| 1064|Audio-only |rise  |

</div>

About the data in each column:

- `PID` contains the unique identifier for each participant.
- `RT` contains the response time for each trial.
- `modality` contains the label for each condition (`Audio-only` or `Audiovisual`)
- `stim` contains the word that was presented on each trial

\

:::{.exercise}
**Design Check**

* What is the name of the dependent variable? <select class='webex-select'><option value='blank'></option><option value=''>PID</option><option value='answer'>RT</option><option value=''>modality</option><option value=''>stim</option></select>

* Is `modality` of presentation manipulated within- or between-subjects? <select class='webex-select'><option value='blank'></option><option value=''>between</option><option value='answer'>within</option></select>

* How many levels does `modality` have? <select class='webex-select'><option value='blank'></option><option value=''>1</option><option value='answer'>2</option><option value=''>4</option></select>

* How many participants were there? <select class='webex-select'><option value='blank'></option><option value=''>21,679</option><option value='answer'>53</option><option value=''>543</option><option value=''>4</option></select>

* How many unique stimuli (words) were there? <select class='webex-select'><option value='blank'></option><option value=''>21,679</option><option value=''>53</option><option value='answer'>543</option><option value=''>4</option></select>

* What format is the data in `rt_data` in? <select class='webex-select'><option value='blank'></option><option value=''>wide format</option><option value='answer'>long format</option></select>




<div class='webex-solution'><button>Hint: count()</button>


A simple way to obtain the number of participants in long format data is as follows:


```r
# n ppts
# take rt_data, group_by ppt, then look at number of rows in tibble
rt_data %>% 
  group_by(PID) %>% 
  count()
```

\
 
Likewise, for the number of items:

```r
# n items
# take rt_data, group_by item, then look at number of rows in tibble
rt_data %>% 
  group_by(stim) %>% 
  count()
```



</div>


:::

\

## Fixed and Random effects

:::{.tip}

Mixed models comprise fixed and random effects.

**Fixed effect**: A population-level effect, assumed to persist across experiments with different participants or items. They are used to model average trends. Typically the independent variable is the fixed effect, for example, levels of difficulty in an experiment, manipulated by an experimenter.

**Random effect**: Represents the extent to which the fixed effect randomly varies across a grouping variable (e.g., participants, or items). For example, the behaviour of individual participants or items may differ from the average trend (some may do better than others). The random effects are always _categorical variables_. They should have at least 5 or 6 levels.

:::

\

:::{.exercise}

For the Brown (2021) dataset:

* What would be the fixed effect? <select class='webex-select'><option value='blank'></option><option value=''>PID</option><option value=''>RT</option><option value='answer'>modality</option><option value=''>stim</option></select>

* What would be one random effect? <select class='webex-select'><option value='blank'></option><option value='answer'>PID</option><option value=''>RT</option><option value=''>modality</option><option value='answer'>stim</option></select>

* What would be a second random effect? <select class='webex-select'><option value='blank'></option><option value='answer'>PID</option><option value=''>RT</option><option value=''>modality</option><option value='answer'>stim</option></select>

:::

\

In this design, we are justified in including both `participants` and `items` as random effects because you can think of modality as having been manipulated both within-subjects **and** within-items:

* **Within-subjects**: The participants provided responses in _both_ conditions.

* **Within-items**: Each item was also presented in _both_ conditions. That is, for some participants a word was presented in the `Audio-only` condition and for other participants it appeared in the `Audiovisual` condition.

In other words, we have scores for each participant in each condition, and also scores for each item in each condition. If the items in each condition were different, it wouldn't make sense to include item as a random effect.




\
 
## Specifying the model

:::{.tip}

A mixed model approach allows for the variability across items and participants to be modelled via **random intercepts** and **random slopes**. For each, you can have by-participant and by-item effects.

* **Random intercepts**: 
  * by-participant: accounts for individual differences in participants' RTs.
  * by-item: accounts for differences in RTs to particular words.
  
* **Random slopes**:
  * by-participant: accounts for individual differences in the effect of modality on RT.
  * by-item: accounts for differences in the effect of modality on particular words.

Note that if random slopes and intercepts are included, correlations between them will also be estimated. A correlation could occur, for example, if slower participants show larger effects of modality.
:::




\

Models with different combinations of random effects can be specified and compared to test whether there's evidence for particular components or not.

\


### Fixed effect model with random intercepts

The simplest random effects model has random intercepts only.

\

The general formula is:


`lmer(outcome ~ predictor + (1|participant) + (1|item), data = data)`

\

Note that fixed effects are specified **outside** parentheses:

* `predictor` means include the fixed effect of predictor

\

Random effects are specified **inside** parentheses:
Things to the left of `|` vary according to things on the right.

* `(1|participant)` means the intercept (represented with '1') varies according to `participant.`
* `(1|item)` means the intercept (1) varies according to `item.`

\

So, in words, the formula means "model the `outcome` variable as a function of the fixed effect of the `predictor`, with random intercepts for `participant` and `item`."

\

### Fixed effect model with random intercepts AND slopes

The effect of modality can be allowed to differ across participants and items by including **random slopes**.

\

The general formula is:

`lmer(outcome ~ predictor + (1 + predictor|participant) + (1 + predictor|item), data = data)`

\

Where: 

* `(1 + predictor|participant)` means the intercept (`1`) _and_ fixed effect (`predictor`) varies according to `participant`.
* `(1 + predictor|item)` means the intercept (`1`) and fixed effect (`predictor`) varies according to `item`.

\

### Multiple fixed effects, random intercepts AND slopes

For multiple fixed effects, e.g., `predictor1` and `predictor2`, an example of the formula used could be:


`lmer(outcome ~ predictor1 + predictor2 + (1 + predictor1 + predictor2|participant) + (1 + predictor1|item), data = data)`

\

Where:

* `predictor1` means include the fixed effect of `predictor1`.
* `predictor2` means include the fixed effect of `predictor2`.
* `(1 + predictor1 + predictor2|participant)` means include random intercepts (1) for `participant` and also by-participant random slopes for `predictor1` and `predictor2`.
* `(1 + predictor1|item)` means include random intercepts for `item` and by-item random slopes for `predictor1`.

\


## The analysis: Do RTs differ across modality conditions?

The researchers wanted to know whether RTs differ according to the `modality` condition.

As covered in the lecture, the first step is to specify the maximal (full) model permitted by the design. Here, it's one that includes random intercepts and slopes for participant and stimulus.



```r
# Specify the full model and store in rt_full_model
rt_full_model <- 
  lmer(RT ~ 1 + modality + (1 + modality|PID) + (1 + modality|stim), data = rt_data)
```


This "maximal" model for the data includes:

* The **fixed effect** of `modality`
* By-participant and by-item **random intercepts**
* By-participant and by-item **random slopes**

\

For comparison, we need to specify the _reduced_ model, which is identical except it does not contain the fixed effect.  


```r
# Specify the reduced model and store in rt_reduced_model
rt_reduced_model <- lmer(RT ~ 1 + (1 + modality|PID) + (1 + modality|stim), data = rt_data)
```


To compare the full and reduced models use `anova(model_1, model_2)`, that is,


```r
# compare the reduced and full models
anova(rt_reduced_model, rt_full_model)
```

 ![](images\8_anova_lmm.png)  

- This tests a null hypothesis that the full and reduced models are statistically equivalent.
- Specifically, a **likelihood ratio test** is performed, which involves obtaining the likelihood of each model and then comparing the likelihoods.
- The _p_-value is the probability of obtaining a test statistic at least as extreme as the one observed, if the null hypothesis is true.
- If the _p_-value for the test is less than 0.05, then, by convention, we say the test is statistically significant. 
- The _p_-value is shown in the `Pr(>ChiSq)` column and is a very small number (e.g., 1.26e-08), being clearly less than 0.05.
- This means that the full model fits the data significantly better than the reduced model, and we have evidence for the fixed effect.

\

## Inspecting the model

Now we know that we have evidence for the full model containing the fixed effect, we can look at it in detail:


```r
# display results from the full model
summary(rt_full_model)
```

```
## Linear mixed model fit by REML. t-tests use Satterthwaite's method [
## lmerModLmerTest]
## Formula: RT ~ 1 + modality + (1 + modality | PID) + (1 + modality | stim)
##    Data: rt_data
## 
## REML criterion at convergence: 302385.7
## 
## Scaled residuals: 
##     Min      1Q  Median      3Q     Max 
## -3.3646 -0.6964 -0.0141  0.5886  5.0003 
## 
## Random effects:
##  Groups   Name                Variance Std.Dev. Corr 
##  stim     (Intercept)           304.0   17.44        
##           modalityAudiovisual   216.9   14.73   0.16 
##  PID      (Intercept)         28559.0  168.99        
##           modalityAudiovisual  7709.0   87.80   -0.17
##  Residual                     65258.8  255.46        
## Number of obs: 21679, groups:  stim, 543; PID, 53
## 
## Fixed effects:
##                     Estimate Std. Error      df t value Pr(>|t|)    
## (Intercept)          1044.14      23.36   52.12  44.700  < 2e-16 ***
## modalityAudiovisual    83.18      12.57   52.10   6.615 2.02e-08 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Correlation of Fixed Effects:
##             (Intr)
## modltyAdvsl -0.178
```

In the output:

 - REML stands for **Restricted Maximum Likelihood**. This is the method that was used to fit the model to the data. 
 - The formula entered for the mixed model is given again.
 - Information about the variance in the residuals is given.
 
 
**Random effects:**

- The values in `Std. Dev` are the estimates of the variance in the random intercepts and slopes in participants (`PID`) and items (`stim`). 
- The values in `Corr` are the estimates of the correlation between the random intercept and random slopes (by-participant and by-item).
  - The correlation of 0.16 means that the effect was larger for items that took longer to respond to.
  - The correlation of -0.17 means that the effect of modality was smaller in participants who took longer to respond.
 
 
To interpret the fixed effects, we need to consider how the levels of modality were coded.

- R uses dummy coding (0s and 1s) to code the levels of a factor (or a character variable).
- modality has levels `Audio-only` and `Audiovisual`
- R assigns the 0s and 1s in dummy coding alphabetically.
- `Audio-only` is therefore coded with 0s.
- `Audiovisual` is therefore coded with 1s.
 
 
**Fixed effects:**

- The estimate of the intercept is given as 1044.14. This represents the average RT in the `Audio-only` group (the condition coded with zeros).
- The estimate of the fixed effect of modality is given as **83.18**. This represents how much greater the mean is in the `Audiovisual` condition (coded with 1s), _once participant and items have been taken into account_. 
 
 
The researchers in this experiment thought RTs would be slower in Audio-visual condition than the audio-only condition. Seeing a word in addition to hearing it may be associated with greater cognitive effort.

Are the researchers correct or not? <select class='webex-select'><option value='blank'></option><option value=''>No</option><option value='answer'>Yes</option></select>


<div class='webex-solution'><button>Explain</button>

Because the fixed effect of modality is 83.18, and because `Audio-visual` was (dummy) coded with 1s and `Audio-only` was coded with 0s, this means that the mean of the `Audiovisual` condition is 83.18 _greater_ than that of the `Audiovisual` condition. The outcome variable is RT, which means that **responses in the Audiovisual condition were 83 ms slower, on average, as expected by the researchers.**

</div>


\

### Convergence issues

:::{.tip}
It is common when running LMMs for the model to not **converge** successfully, meaning that R was unable to estimate all the parameters of the model.

This is especially common with more complex models, such as those with multiple fixed and random effects and their interactions.

If you receive a warning saying that the model did not converge, or that the fit is singular, you should not report the results from the model. 

One solution is to explore all the fitting options in `lmer()` that do allow for convergence. 

Handily, this can be done for you automatically using the `allFit()` function in the `afex` package:
:::
 
 \


```r
allFit(rt_full_model)
```

```
## bobyqa : [OK]
## Nelder_Mead : [OK]
## nlminbwrap : [OK]
## optimx.L-BFGS-B : [OK]
## nloptwrap.NLOPT_LN_NELDERMEAD : [OK]
## nloptwrap.NLOPT_LN_BOBYQA : [OK]
## original model:
## RT ~ 1 + modality + (1 + modality | PID) + (1 + modality | stim) 
## data:  rt_data 
## optimizers (6): bobyqa, Nelder_Mead, nlminbwrap, optimx.L-BFGS-B,nloptwrap.NLOPT_LN_NELDERME...
## differences in negative log-likelihoods:
## max= 0.00015 ; std dev= 6.08e-05
```

This will provide a list of the optimisers (e.g., `bobyqa`, `Nelder_Mead`) in `lmer()` that produce convergence warnings or singular fits or do successfully converge `[OK]`. 

\

An optimiser from this list can then be manually specified using `lmerControl` when running the model:


```r
rt_full_model <- lmer(RT ~ 1 + modality + (1 + modality|PID) + (1 + modality|stim), 
                      data = rt_data,
                      control = lmerControl(optimizer = "bobyqa"))
```


Other things that may improve convergence are:

* increase the number of iterations the optimisation routine performs (with `control = lmerControl(optCtr = list(maxfun = 1e9))`)
* remove the derivative calculations that occur after the model has reached a solution (via. `control = lmerControl(calc.derivs = FALSE)` )

\

If the model still does not converge, then the complexity of the model should be systematically reduced. For example, remove a component such as a random slope term and re-run it, repeating the process of removing more and more components until it converges. 

Ideally, the random effects you include in the model should be psychologically principled and guided by theory.

\

### Coefficients  

For learning purposes only, let's see for ourselves that each participant in the final model has their own estimate of the intercept and slope, using `coef()`


```r
# get the random intercept and slope for each participant
coef(rt_full_model)$PID %>% head()
```

<div class="kable-table">

|    | (Intercept)| modalityAudiovisual|
|:---|-----------:|-------------------:|
|301 |   1024.0672|          -16.936244|
|302 |   1044.1377|            1.843072|
|303 |    882.8292|           57.790549|
|304 |   1232.7548|          -27.919783|
|306 |   1042.3427|           33.886178|
|307 |   1111.3621|           -9.938361|

</div>

\

See also the random intercepts and slopes for each item:


```r
# get random intercept and slope for each stimulus
coef(rt_full_model)$stim %>% head()
```

<div class="kable-table">

|     | (Intercept)| modalityAudiovisual|
|:----|-----------:|-------------------:|
|babe |    1038.919|            82.11841|
|back |    1050.914|            86.52439|
|bad  |    1041.122|            81.12280|
|bag  |    1042.892|            86.41081|
|bake |    1039.394|            81.75528|
|balk |    1042.558|            84.17974|

</div>

You wouldn't report these, but looking at them helps to make it concrete that each participant and stimulus has its own intercept and effect of modality (slope) in this model.

\

### Graph

The `emmeans()` package can be used to obtain the means from the model for a figure. 

:::{.tip}
**EMM** stands for Estimated Marginal Means. These are means for conditions or contrasts, estimated by the model that was fit to the data.
:::

\

Obtain the estimates of mean RT in the two modality conditions:


```r
# load emmeans package
library(emmeans)

# obtain the emms from the model, for each level of modality
emms <- emmeans(rt_full_model, ~ modality)
```
If you get a warning that tells us that it can't calculate the degrees of freedom, then don't worry since we don't need these right now.

\


To see the EMMs:


```r
emms
```

```
##  modality    emmean   SE  df asymp.LCL asymp.UCL
##  Audio-only    1044 23.4 Inf       998      1090
##  Audiovisual   1127 24.5 Inf      1079      1175
## 
## Degrees-of-freedom method: asymptotic 
## Confidence level used: 0.95
```

- The EMMs are in the `emmean` column.
- Associated standard errors are in `SE`. 
- The values in the `asymp.LCL` column are the lower 95% confidence interval limits of the means. 
- The values in the `asymp.UCL` column are the upper 95% confidence interval limits of the means. 

\

 - The estimated mean of the `Audio-only` condition is <select class='webex-select'><option value='blank'></option><option value='answer'>1044</option><option value=''>23.4</option><option value=''>1127</option></select>
 - The estimated mean of the `Audiovisual` condition is <select class='webex-select'><option value='blank'></option><option value=''>1079</option><option value='answer'>1127</option><option value=''>23.4</option><option value=''>1044</option></select>

\

To create a figure showing these means in `ggplot()`:


```r
# use emms, convert to tibble for ggplot, 
# plot means and errorbars

as_tibble(emms) %>% 
  ggplot(aes(x = modality, y = emmean)) +
  geom_point(group = 1, size = 3) +
  geom_errorbar(aes(ymin = asymp.LCL, ymax = asymp.UCL, width = 0.2)) +
  ylab("Estimated marginal mean RT") +
  xlab("Condition")
```

<div class="figure" style="text-align: center">
<img src="08_mixed_models_files/figure-html/unnamed-chunk-17-1.png" alt="Estimated marginal mean RT in each modality condition, controlling for participant and stimulus. Error bars denote the 95% confidence interval." width="75%" />
<p class="caption">(\#fig:unnamed-chunk-17)Estimated marginal mean RT in each modality condition, controlling for participant and stimulus. Error bars denote the 95% confidence interval.</p>
</div>

\

These means in the figure are technically based on estimates of parameters from the model. That is, they are the mean of the levels of the fixed effect after accounting for the random effects, and so won't necessarily be the same as the means you may calculate directly from the data. 

\


<div class='webex-solution'><button>Traditional analysis</button>

For learning purposes only, let's compare what the means would have been when calculated in the traditional way (without accounting for the random effects).


```r
# average RTs across participants in each condition
# then work out the mean across participants
rt_data %>% 
  group_by(PID, modality) %>% 
  summarise(M = mean(RT)) %>% 
  ungroup() %>% 
  group_by(modality) %>% 
  summarise(M_RT = mean(M))
```

In this case, the means come out the same. 

\

Now see if the modality effect would be significant in a traditional paired _t_-test. Again, this is for learning purposes only - most LMMs would be more complex than only having a fixed factor with two levels!


```r
Ms <- 
  rt_data %>% 
    group_by(PID, modality) %>% 
    summarise(M = mean(RT)) %>% 
  pivot_wider(names_from=modality,values_from=M)

t.test(Ms$`Audio-only`, Ms$Audiovisual, paired = TRUE)
```

The pattern of significance is the same in the t-test and LMM (there's a significant effect of condition). 


</div>


\

## Going further: Multiple factors

:::{.tip}
The analysis above was for a very simple scenario where the fixed factor had two levels. It can be extended to include an additional fixed factor and interaction between the factors. 
:::

\

Load the extended data from Brown (2021) at "https://osf.io/download/vkfzn/" and store in `rt_data_interaction`.


```r
# load data with additional fixed factor
rt_data_interaction <- read_csv("https://osf.io/download/vkfzn/") 
```

```
## Rows: 21679 Columns: 5
## ── Column specification ────────────────────────────────────────────────────────
## Delimiter: ","
## chr (3): SNR, modality, stim
## dbl (2): PID, RT
## 
## ℹ Use `spec()` to retrieve the full column specification for this data.
## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.
```

:::{.exercise}

* The name of the column containing the new fixed factor is <select class='webex-select'><option value='blank'></option><option value=''>modality</option><option value=''>stim</option><option value='answer'>SNR</option><option value=''>PID</option><option value=''>RT</option></select>
* The levels of the new factor are <select class='webex-select'><option value='blank'></option><option value='answer'>Easy/Hard</option><option value=''>Audio-only/Audiovisual</option></select>

:::

\

SNR stands for _Signal to Noise Ratio_. This manipulation involved changing the background noise to affect how difficult it was to hear the word on each trial.

* In the `Easy` condition, it was easy to hear the word against background noise. 
* In the `Hard` condition, it was difficult to hear the word against the background noise.

</div>


\

To specify the full model with the interaction between the two fixed factors:  



```r
# Specify the LMM with an interaction term
rt_int.mod <- lmer(RT ~ 1 + modality + SNR + modality*SNR +
                     (1 + modality + SNR|stim) + (1 + modality + SNR|PID), 
                   data = rt_data_interaction)
```

```
## boundary (singular) fit: see help('isSingular')
```

* Notice that the interaction was specified by adding `modality:SNR`.
* We could have alternatively used `modality*SNR` to add the interaction.
* Notice that the model includes random intercepts and slopes for each factor (by participant and by-item).
* Random effects for the interaction term have *not* been included. Doing so often leads to an oversaturated model and/or convergence issues. The researcher didn't include them. 

The model failed to converge and is singular.

\

Use `allFit()` from the `afex` package to see if another optimizer will work. 


```r
# This code will take a while to run
# as allFit() tries each different optimizer!
allFit(rt_int.mod)
```
\
 
To help convergence, Brown (2021) removed components of the model relating to the random effects of items. Specifically:

* The by-item random slopes associated with each fixed factor were removed. The component `(1 + modality + SNR| stim)` becomes `(1|stim)`.
* The correlation between the random intercept for `stim` and the by-stimulus random slope for `modality` was also removed using ` + (0 + modality|stim)`. They weren't interested in that correlation.
* The `allFit()` function indicated that the bobyqa optimizer led to convergence. 

 
Thus, their final model is:


```r
rt_int.mod <- lmer(RT ~ 1 + modality + SNR + modality:SNR +
                     (0 + modality|stim) + (1|stim) + (1 + modality + SNR|PID), 
                   data = rt_data_interaction,
                   control = lmerControl(optimizer = 'bobyqa'))
```

```
## boundary (singular) fit: see help('isSingular')
```
This model still doesn't converge here for us though! 

\

To help convergence, we'll try removing the ` + (0 + modality|stim)` term:


```r
rt_int.mod <- lmer(RT ~ 1 + modality + SNR + modality:SNR +
                      (1|stim) + (1 + modality + SNR|PID), 
                   data = rt_data_interaction,
                   control = lmerControl(optimizer = 'bobyqa'))
```

This model now contains random intercepts (by-item and by-participant), and also by-participant random slopes for the effects of modality and SNR.

The model converges!

\

Now we can look at the model results using `summary()`:


```r
summary(rt_int.mod)
```

```
## Linear mixed model fit by REML. t-tests use Satterthwaite's method [
## lmerModLmerTest]
## Formula: RT ~ 1 + modality + SNR + modality:SNR + (1 | stim) + (1 + modality +  
##     SNR | PID)
##    Data: rt_data_interaction
## Control: lmerControl(optimizer = "bobyqa")
## 
## REML criterion at convergence: 301138.6
## 
## Scaled residuals: 
##     Min      1Q  Median      3Q     Max 
## -3.5317 -0.6951 -0.0044  0.5970  4.8640 
## 
## Random effects:
##  Groups   Name                Variance Std.Dev. Corr       
##  stim     (Intercept)           395     19.88              
##  PID      (Intercept)         25527    159.77              
##           modalityAudiovisual  8046     89.70   -0.03      
##           SNRHard             10357    101.77    0.02 -0.47
##  Residual                     61269    247.53              
## Number of obs: 21679, groups:  stim, 543; PID, 53
## 
## Fixed effects:
##                              Estimate Std. Error        df t value Pr(>|t|)    
## (Intercept)                   998.829     22.218    52.745  44.957  < 2e-16 ***
## modalityAudiovisual            98.510     13.190    58.894   7.469 4.39e-10 ***
## SNRHard                        92.346     14.792    58.015   6.243 5.39e-08 ***
## modalityAudiovisual:SNRHard   -29.556      6.756 21346.939  -4.374 1.22e-05 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Correlation of Fixed Effects:
##             (Intr) mdltyA SNRHrd
## modltyAdvsl -0.063              
## SNRHard     -0.015 -0.354       
## mdltyA:SNRH  0.074 -0.247 -0.233
```

* Significance tests on the main effects and interaction are conducted using **Satterthwaite's method**, which is a way of estimating degrees of freedom to enable a hypothesis test to be conducted. 
* There are significant main effects of modality, _t_(58.89) = 44.96, _p_ < .001, and SNR, _t_(58.01) = 6.24, _p_ < .001, and there's also a significant interaction between the factors, _t_(21346.94) = -4.37, _p_ < .001.
 
  
It is possible to interpret the main effects and interaction by looking at the values of the coefficients (see Brown, 2021, p.14). An alternative way, however, is to obtain and then plot the EMMs of each condition:


```r
# obtain the EMMs for each condition
emms_interaction <- emmeans(rt_int.mod, ~modality*SNR)

# look at the emms
emms_interaction
```

```
##  modality    SNR  emmean   SE  df asymp.LCL asymp.UCL
##  Audio-only  Easy    999 22.2 Inf       955      1042
##  Audiovisual Easy   1097 25.1 Inf      1048      1147
##  Audio-only  Hard   1091 26.5 Inf      1039      1143
##  Audiovisual Hard   1160 26.1 Inf      1109      1211
## 
## Degrees-of-freedom method: asymptotic 
## Confidence level used: 0.95
```
\

Now plot the means using `ggplot()`:


```r
# use ggplot to plot the emms as points, with line connectors, and errorbars
as_tibble(emms_interaction) %>% 
  ggplot(aes(x = modality, y = emmean, color = SNR)) +
  geom_point(size = 2) +
  geom_line(aes(group = SNR)) +
  geom_errorbar(aes(ymin = asymp.LCL, ymax = asymp.UCL, width = 0.1)) +
  ylab("Estimated marginal mean RT") +
  xlab("SNR condition") +
  ylim(0,1300)
```

<div class="figure" style="text-align: center">
<img src="08_mixed_models_files/figure-html/unnamed-chunk-27-1.png" alt="Estimated marginal mean RT in each condition, controlling for participant and stimulus. Error bars denote the 95% confidence interval." width="75%" />
<p class="caption">(\#fig:unnamed-chunk-27)Estimated marginal mean RT in each condition, controlling for participant and stimulus. Error bars denote the 95% confidence interval.</p>
</div>
 
 
* This figure reveals the nature of the significant interaction. The effect of modality is greater in the `Easy` vs. `Hard` SNR condition (98 ms vs. 69 ms, calculated from the EMMs in `emms_interaction`). 

\

## Summary

- Mixed models provide a way of estimating **fixed effects**, while accounting for **random effects** of participants and items. 

- They are becoming increasingly common in the psychological literature.

- Models can be more complex by having fixed effects with more than two levels, multiple fixed effects, and additional random effects. 

- Random effects structures often need to be simplified to allow the model to be fit successfully. 

- See **Brown (2021)** for an example with a binary response variable (e.g., accuracy = correct vs. incorrect); this analysis is called a generalised linear mixed model (GLMM). Jaeger (2008) also provides a tutorial.

- For more guidance on reporting mixed models, see Meteyard and Davies (2020).
 
 \
 
Interested students should consult the articles below.


\

## References

**Recommended introductory texts:**

Brown, V. A. (2021). An introduction to linear mixed-effects modeling in R. _Advances in Methods and Practices in Psychological Science_, _4_(1), Article 2515245920960351. https://doi.org/10.1177/2515245920960351

Singmann, H., & Kellen, D.(2019). An Introduction to Mixed Models for Experimental Psychology. In D.H. Spieler & E. Schumacher(Eds.), _New Methods in Cognitive Psychology_ (pp.4–31).Psychology Press. [[PDF link]](http://singmann.org/download/publications/singmann_kellen-introduction-mixed-models.pdf)

\

**Going further:**

Bates, D., Mächler, M., Bolker, B., & Walker, S. (2015). Fitting Linear Mixed-Effects Models Using lme4. _Journal of Statistical Software_, _67_, 1-48. [[PDF link]](https://www.jstatsoft.org/index.php/jss/article/view/v067i01/946)

Bolker, B. M. (2015). Linear and generalized linear mixed models. _Ecological statistics: contemporary theory and application_, 309-333. [[PDF link]](https://ms.mcmaster.ca/~bolker/R/misc/foxchapter/14-Fox-Chap13.pdf)

Bono, R., Alarcón R., & Blanca M.J. (2021). Report quality of generalized linear mixed models in psychology: a systematic review. _Frontiers in Psychology_. 12:666182 [[Article]](https://doi.org/10.3389/fpsyg.2021.666182) 

Meteyard, L., & Davies, R. A. (2020). Best practice guidance for linear mixed-effects models in psychological science. _Journal of Memory and Language_, _112_, 104092. [[Article]](https://doi.org/10.1016/j.jml.2020.104092)

Jaeger, T. F. (2008). Categorical data analysis: Away from ANOVAs (transformation or not) and towards logit mixed models. _Journal of Memory and Language_, _59_(4), 434–446. [[Article]](https://doi.org/10.1016/j.jml.2007.11.007)
