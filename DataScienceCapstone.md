<link rel="stylesheet" href="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.min.css">
<style>
 .roundC {
 border-radius: 25px;
 padding:10px !important;
 }
</style>

Wizard Text Editor
========================================================
author: Edgar Chavolla
date: Fri Apr 22 23:36:28 2016
css: http://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.min.css
**Data Science Capstone**

Introducction and Features
========================================================
<hr>
<div class="well roundC" style="margin-left:5px;font-size:25px;" >
 The wizard application uses an English language model in order to get the most probable next-word-suggestion. It lets the user to select among the top most common used word. It offers the following benefits:
</div>
 <div class="bg-info col-md-6 roundC" style="margin-left:5px;font-size:20px;top:px;line-height: 99%;">
 - Uses a robust English language created using **text2vec** high performance library.<br><br>
 - The search structure is created using a hash storage, so a massive amount of data can be retrieved faster than other structures.<br><br>
 - Backoff and Markov Chain approaches to perform the search.<br><br>
 - Popup completion style shows the most probable next word. <br><br>
 - Rich text editor interface. 
 </div>
<div class="bg-warning col-md-5 roundC" style="margin-left:10px;margin-top:50px;">
  <img style="width:100%;" src="img01.png"></img>
</div>

Algorithms in the backend
========================================================
 <div class="bg-info roundC" style="margin-left:25px;font-size:18px;top:px;line-height: 90%;width:99%;z-index:100;">
  The procedure follows several steps in order to perform the next-word suggestion:    
 - Input data clean up. Basically removes extra whitespaces and non-standard characters.   
 
 - Takes a maximum of 3 last character in order to perform the search.
 
 - Most of the cases can be resolved using Markov chains using just the previous state, but if this is insufficient the algorithm start a backoff like process to find the complete result set.
 </div>
<div class="bg-warning  roundC col-md-11 " style="margin-left:60px;text-align:center;z-index:-1;">
  <img style="width:80%;height:60%;margin:0px;" src="img02.png"></img>

</div>


Performance
========================================================
 <div class="bg-info roundC" style="margin-left:25px;font-size:18px;top:px;line-height: 90%;width:99%;padding:20px;">
   <div class="alert alert-info" style="font-size:22px;">Several tests were performed in order to verify the speed and the storage cost. After the test phase was completed, some aspects were clarified and some decisions were made.</div><br><br>
 <div class="well col-md-3 roundC" style="width:20%;"><h3>Language Model Storage</h3></div>The data is better to have it stored as with hashes. In R this is possible using and environment object. Hashes improves not only storage space, but also the data search. The hash structure implemented mimic a tree structure. This tree allows to perform a backoff like procedure. 
 
   A test trying to store 4 million n-grams in the Hash structure were fitted in 44MB, just pruning those n-grams with less than 3 counts from a set of 40 Millions n-grams. A greater pruning rejecting those n-grams with less than 10 counts, created a set of around 950 000 n-grams stored in a 12 MB file.<br><br>
  
  <div class="well col-md-3 roundC" style="width:20%;"><h3>Data Time Retrieval</h3></div> Test speed test using the result 12 MB hash structure, were done using a small R script, a local web server and the shinyapps web.
  - Using the R script the response was with almost no delay.
  - Using the local web server, the response was of just a few milliseconds (around 300 ms)
  - Using the shinyapps web, the browser statistics exhibit a latency of around 1 second.
  
  From the tests can be seen that the final search time has a decent performance. Regarding the shinyapps web, it would be better to have a latency of maximum 500 ms, but around 1 second is acceptable. In the worst scenario seen during the tests, the response took 2 seconds. 
  Using the search time as a base the final hash structure was left with 950 K n-grams, since the relationship between storage size, speed and prediction results was the best observed during the tests.
  
 </div>


Basic Usage
========================================================

 <div class="bg-success roundC" style="margin-left:25px;font-size:18px;top:px;line-height: 90%;width:99%;z-index:100;">

- the application can be accessed in the following link: <a href="https://chavolla.shinyapps.io/TextWizardCourseraCapstone/">https://chavolla.shinyapps.io/TextWizardCourseraCapstone/ </a>

- The user can enter information by typing words. Additionally the user can also paste some text  in the editor area.

- The application is activated after the users types a space character. Also the application is activated after a piece of text is copied. The previous suggestion can be reloaded by presing Ctr+Space (Useful if the suggestion window accidentally closed ).

- The output is seen as a popup window with the top 5 (or less if not matches are found) rated possible entries. The user can click in any of the options and the word will be pasted in the editor.

  <img style="margin:0px;" src="img03.png"></img>
  

</div>






