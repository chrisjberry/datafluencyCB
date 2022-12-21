# FAQs {#faqs}


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

\

---


\

## What does it mean if RStudio prints out "e-" next to a number? {#e-meaning}

It is a way of expressing very small numbers (when it's "e-") or very large numbers (when it's just "e").

If R prints "1.4e-4", in the output this actually means "$1.4 \times 10^{-4}$", or "0.00014". 

"e-4" means "move the decimal point 4 places to the left". Run the code below -- it should return "0.00014".



```r
1.4e-4
```

So:

- "e-5" means move the decimal point 5 places to the left (e.g., `2.5e-5` is "$2.5 \times 10^{-5}$", or 0.000025)
- "e-10" means move the decimal point 10 places to the left (e.g., `2.5e-10` is "$2.5 \times 10^{-10}$", or 0.00000000025).
- "e5" means move the decimal point 5 places to the **right** (e.g., `2.5e5` is "$2.5 \times 10^{5}$", 250000).
- "e10" means move the decimal point 10 places to the **right** (e.g., `2.5e10` is "$2.5 \times 10^{10}$", 25000000000).

\

---

\

## How can I find out more about a particular function, so I can explore its settings etc.?

For any function in R, if you run `?function_name` in your code or at the console, then R will load a help file with details of the function with all its options and examples. Try, for example, running `?geom_point` or `?mean`.

\

---

<!--

\

## How should I write up the report?

My guidance is to write this up in a similar style to that of a results section in an article, but you will obviously want to provide a bit of context to your analysis so you can explain what you’ve done. In the worksheets I’ve provided examples of interpretation of analyses, and reporting of statistics and you can use this to give you an idea of the kinds of things that could be mentioned when reporting the results. 

In the [Rmd support lecture](slides/PSYC753_Rmd_Support.pptx) I provided guidance on how the knitted html document should look.

\

---

\

## After downloading my .Rmd file to my computer, how do I open it again in RStudio?

To open an .Rmd file that you’ve downloaded from RStudio, you must first upload it *back* to RStudio using the following steps:

- In the Files panel of RStudio (lower-right of the screen), click the **Upload** button.

- Then click “Choose File” and locate your .Rmd file on your computer.

- Once uploaded to RStudio, you can open it as normal from within the Files panel.

*Note*. The reason why .Rmd files will not open when you try to open them once downloaded to your PC is because RStudio runs from a web browser. You must take the steps above to open a .Rmd file in RStudio. Alternatively, it is possible to open a .Rmd file downloaded to your PC if you have RStudio installed locally on your machine.


\

---

\

## On the word count, are figure captions included?

If the text falls within the figure image or table, then it won’t be counted, otherwise it would be.  

\

---

\

## Should I make code visible in my html report?

There's no need to include code in your report. (If you do choose to though, the code won't count towards the word limit.) Please also see the [Rmd support lecture](slides/PSYC753_Rmd_Support.pptx) for guidance on how the report should look (e.g., slide 16). 

\

---

\

## Do I need to include references?

It's not expected that you'd need to include references, but if you do cite something in your report, then it’s good practice to include the reference to the article in a References section. 

There’s no expectation for you to consult the psychological literature concerning the topic of the questionnaire. Remember, this is primarily an assignment concerning data analysis and, as such, you aren’t expected to delve into the psychological literature, either in the formulation of your question or in the interpretation of your findings. Your analyses can be guided by what's said in assessment instructions and the Tips section of it. You may, of course, consult the psychological literature if you want to. Please also see the “How should I write up the report?” FAQ above.

\

---

\

## Can there be overlap in the variables used in each question?

Yes, there may end up being overlap in the variables. There is no requirement in the assessment instructions for the variables in each question to be non-overlapping. There is also no requirement for Questions 1 and 2 to be explicitly linked or to follow on from one another.

\

---

\

## Do we have to include a certain number of variables to achieve a good grade?

\

As stated in the instructions (p.2), for Question 1, you must include at least one continuous predictor variable, and for Question 2, you must include at least one categorical variable. The instructions say that you may include more variables. If including more, then you will of course have to ensure that you report and interpret the results appropriately. 

\

--- 

\

## Can I include more than one figure?

You can include more than one figure for each answer if you feel it is necessary, but it is not a requirement (please see assignment instructions, p.2).

\

---

\

## Can I include categorical predictor variables in a hierarchical regression?

Yes, this is possible. Please see the examples in Session 5 (slide 14 onwards, and worksheet section 5.4 onwards). 

\

---

---

\

## How do I apply for extenuating circumstances?

All requests for extensions to the deadline are dealt with by the Faculty office, and need to applied for via the extenuating circumstances procedure detailed at the link below:

https://liveplymouthac.sharepoint.com/sites/x70/SitePages/Extenuating-circumstances.aspx


\

---

\

## Can a book a slot in your office hours?

If you're still stuck after going through the materials in the workbook, the assessment instructions, and these FAQs and want to make an appointment to speak to me, then you can book a slot during my office hours using the online booking system link below:

https://dle.plymouth.ac.uk/mod/scheduler/view.php?id=1181545


-->
