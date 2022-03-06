# FAQs {#faqs}


*Chris Berry*
\
*2022*






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

If R prints "1.4e-4", in the output this actually means "$1.4 \times 10^{-4}$", or "0.00014". It is a way of printing out very small (or very large) numbers.

"e-4" means "move the decimal point 4 places to the left". Run the code below -- it should return "0.00014".



```r
1.4e-4
```

So:

- "e-5" means move the decimal point 5 places to the left (e.g., `2.5e-5` is "$2.5 \times 10^{-5}$", or 0.000025)
- "e-10" means move the decimal point 10 places to the left (e.g., `2.5e-10` is "$2.5 \times 10^{-10}$", or 0.00000000025).
- "e5" means move the decimal point 5 places to the **right** (e.g., `2.5e5` is "$2.5 \times 10^{5}$", 250000).


\

---

\

## How should I write up the report?

My guidance is to write this up in a similar style to that of a results section in an article, but you will obviously want to provide a bit of context to your analysis so you can explain what you’ve done. In the worksheets I’ve provided examples of interpretation of analyses, and reporting of statistics and you can use this to give you an idea of the kinds of things that could be mentioned when reporting the results. 

In the [Rmd support lecture](slides/PSYC753_Rmd_Support.pptx) I provided guidance on how the knitted html document should look.

\

---

\

## How can I find out more about a particular function, so I can explore its settings etc.?

For any function in R, if you run `?function_name` in your code or at the console, then R will load a help file with details of the function with all its options and examples. Try, for example, running `?geom_point` 

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


---

\


## How do I apply for extenuating circumstances?

All requests for extensions to the deadline are dealt with by the Faculty office, and need to applied for via the extenuating circumstances procedure detailed at the link below:

https://liveplymouthac.sharepoint.com/sites/x70/SitePages/Extenuating-circumstances.aspx


\

---

\

## Can a book a slot in your office hours?

If you're still stuck after going through the materials in the workbook and these FAQs and want to make an appointment to speak to me, then you can book a slot during my office hours using the online booking system link below:

https://dle.plymouth.ac.uk/mod/scheduler/view.php?id=1181545


