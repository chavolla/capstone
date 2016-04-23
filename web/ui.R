library(shiny)
shinyUI(pageWithSidebar(
  headerPanel(tags$div(class="well col-md-offset-4 col-md-6", style="text-align:center;", "Wizard Text Editor")),
  sidebarPanel(    
    tags$head(tags$link(href="https://cdnjs.cloudflare.com/ajax/libs/summernote/0.8.1/summernote.css", rel="stylesheet")),
    #tags$head(tags$link(href="https://summernote.org/bower_components/font-awesome/css/font-awesome.css", rel="stylesheet")),    
    tags$head(tags$link(rel="stylesheet", type="text/css", href="https://cdnjs.cloudflare.com/ajax/libs/codemirror/3.20.0/codemirror.min.css")),
    tags$head(tags$link( rel="stylesheet", type="text/css", href="https://cdnjs.cloudflare.com/ajax/libs/codemirror/3.20.0/theme/monokai.min.css")),    
    tags$head(tags$script( src="https://cdnjs.cloudflare.com/ajax/libs/codemirror/3.20.0/codemirror.min.js")),    
    tags$head(tags$script(src="https://cdnjs.cloudflare.com/ajax/libs/summernote/0.8.1/summernote.js")),
    tags$head(tags$script(src="https://cdnjs.cloudflare.com/ajax/libs/codemirror/3.20.0/mode/xml/xml.min.js")),    
    tags$script(HTML('\nvar fisrtT=true;\n var lastText=\'\'; \nvar sn = false;\n $(document).ready(function() {\n $($(\'.container-fluid\').children()[1]).children(\'.col-sm-4\').removeClass(\'col-sm-4\').addClass(\'col-sm-3\').css(\'top\',\'-80px\');   \nsn = $(\'.summernote\').summernote({\n height: 300, \nmaxHeight: 300,\n focus: true,\n placeholder: \'Enter text ...\', \ncallbacks: { \nonKeydown: function(e) { \nif(e.keyCode == 32){\ prepareCall(); \n}\nelse{\ $(\'.real-popover\').hide(); \n} },\ onPaste: function(e) { \nsetTimeout(prepareCall, 100) \n} }, \ntoolbar:[ [\'style\', [\'bold\', \'italic\', \'underline\', \'clear\']], [\'fontsize\', [\'fontsize\']], [\'color\', [\'color\']], [\'para\', [\'ul\', \'ol\', \'paragraph\']], [\'height\', [\'height\']] ] \n}); }); \nfunction prepareCall(){\n $(\'.summernote\').summernote(\'editor.saveRange\'); \nvar $group = $(\'<div class="note-hint-group note-hint-group-0"/>\');\n $group.html(createItemTemplates(0,["a","b","c"]));\n var ok = processLine();\n if(ok){\n r=$(\'.summernote\').summernote(\'editor.createRange\');\n var rect = r.getClientRects()[0];\n if(rect){ \n$(\'.real-popover\').css(\'left\',(rect.left*.30) +\'px\');\n $(\'.real-popover\').css(\'top\',(rect.top*.5+ rect.height) +\'px\');\n mainSel =document.getSelection();\n $(\'.real-popover\').show(); \n}\n };\n console.log($(\'.summernote\').summernote(\'editor.createRange\').toString()) };\n createItemTemplates = function (items) {$(\'.note-hint-group-0\').html(\'\');for(var idx in items){$(\'.note-hint-group-0\').append(\'<div class="note-hint-item" onclick="addText(this)">\'+items[idx]+\'</div>\');};}; \n function processLine(){ var line = getLastLine().trim(); if(lastText == line){var val = $(\'#resultData\').val();createItemTemplates(val.split(\',\'));}else{lastText = line}; $(\'#newLetter\').val(line);$(\'#newLetter\').trigger(\'keyup\'); console.log("#"+line.trim()+"#"); return line.trim() !== ""; }; if (!String.prototype.trim) { (function() { var rtrim = /^[\\s\\uFEFF\\xA0]+|[\\s\\uFEFF\\xA0]+$/g; String.prototype.trim = function() { return this.replace(rtrim, \'\'); }; })(); }; function getLastLine(){ var markupStr = $(\'.summernote\').summernote(\'code\').trim() .replace(/<\\/p>|<\\/div>|<br>/g, "#BR#") .replace(/<\\/?[^>]+(>|$)/g, "") .replace(/&nbsp;/g," ") .replace(/<br><\\/div>|<br><\\/p>/g,""); if(markupStr == \'\'){ return; }; var pieces = markupStr.split(/#BR#/g); var lastLineIdx = pieces.length-1; var lastLine = pieces[lastLineIdx].trim(); while(lastLine == \'\'){ lastLineIdx --; if(lastLineIdx < 0){break;}; lastLine = pieces[lastLineIdx].trim(); }; return lastLine;};\n function addText(source){ var source = $(source); if(source.hasClass(\'note-hint-item\')){$(\'.real-popover\').hide();}; $(\'.summernote\').summernote(\'editor.focus\'); $(\'.summernote\').summernote(\'editor.restoreRange\'); $(".summernote").summernote("pasteHTML"," "+source.text()); }')),
    tags$script("function getLetter(target){$(target).addClass('disabled');$('#newLetter').val($('#newLetter').val()+$(target).text()+',');$('#newLetter').trigger('keyup')}"),    
    tags$div(class="row", style="text-align:center;font-weight:bold;", tags$h3("Instructions")),
    tags$div( style="text-indent:15px;","  The text editor offers you the possibility to have suggestions over the text you are writing."),
    tags$br(),
    tags$div(style="text-indent:15px;", "  In order to obtain the suggestion help just type any text and when a space is detected it will appear 5 possible options."),
    tags$br(),
    tags$div(class="alert alert-danger", role="alert", tags$span(style="font-weight:bold;", "Warning!"),tags$span( style="text-indent:15px;", "  The application will only suggest the following word for the last word from the last non-empty row."), tags$span( style="font-weight:bold; font-size:11px;"," (More information in the Documentation)") ),
    tags$div(class="alert alert-success", role="alert", tags$span(style="font-weight:bold;", "NOTE:"),tags$span( style="text-indent:15px;", "  The application was tested using latest Chrome, IE10 and Opera 36. Other browsers should work as well but there is no warranty.") ),
    
    tags$div(style="visibility:hidden;height:1px;", textInput(inputId = "newLetter",value = "",label = "Selected Characters")),

    #h4("Please click in the buttons to select the desired character"),
    #tags$div(class="bg-success",style="text-align:center;padding:5px;" ),
    #tags$div(id="refreshBtn",class="btn btn-warning",style="display:none;margin-top:20px;",onclick="location.reload()" ,"Try Again!"),
    tags$div(class="header", checked=NA,
             tags$p(style="margin-top:20px;text-indent:15px;","For some documentation about the usage please click below!"),
             tags$div(style="text-align:center;", tags$div(class="btn btn-default", "data-toggle"="modal", "data-target"="#myModal" ,"Documentation")) 
    )#,
    #tags$script("$('#newLetter').attr('disabled','true');$('#word').attr('disabled','true');"),
    #tags$script("$('#word').on('change',function(){val = $(this).val();if(val=='-1'){alert('You Lost');$('#refreshBtn').toggle();$('#lost').toggle();$('.btn-xs').attr('disabled',true);}else if(val.indexOf('%') != -1){alert('Congrats, You Won!!');$('#refreshBtn').toggle();$('#won').toggle();$('.btn-xs').attr('disabled',true);}})")
    
    
  ),
  mainPanel(     
    tags$div(style="text-align:center",  tags$h1(class="center col-md-offset-1", "Enter or paste your text")),
    tags$div(class="row",
             tags$div(class="col-md-offset-1 col-md-10",
                      tags$div( class="summernote",style="height: 100px;") )),
    #textInput(inputId = "word",value = "",label = "Result (so far!)"),                    
    #h3("Secret Word"),
    #verbatimTextOutput("secret"),
    #h3("Processed Characters"),   
    tags$div(class="col-md-offset-1 col-md-10 well",style="text-align:center; visibility:visible;",
    textInput( inputId = "resultData",value = "",label = "Result from server")),
    tags$script("$('#resultData').on('change',function(){if(fisrtT){fisrtT = false; return;}val = $(this).val();createItemTemplates(val.split(','))})"),
    tags$div(style="visibility:hidden;" , verbatimTextOutput("oid1")),       
    
    
    tags$div(class="note-popover popover in note-hint-popover real-popover", style="display: none; left: 595px; top: 42px;",
             tags$div(class="arrow", style="display: none;"),
             tags$div(class="popover-content note-children-container",
                      tags$div( class="note-hint-group note-hint-group-0",
                                tags$div(class="note-hint-item active",onclick="addText(this)","and")
                                )
                      )
             ),
    
    tags$div(class="modal fade", id="myModal", tabindex="-1", role="dialog",tags$div(class="modal-dialog",tags$div(class="modal-content",
                                                                                                                   tags$div(class="modal-header",
                                                                                                                            tags$button( type="button", class="close", "data-dismiss"="modal", "aria-label"="Close",tags$span(class="btn btn-sm btn-danger", "aria-hidden"="true","X")),
                                                                                                                            tags$h4(class="modal-title","Usage Documentation")
                                                                                                                   ),
                                                                                                                   tags$div(class="modal-body",
                                                                                                                            tags$div(h2("Description"),tags$div("This application presents a text editor capable suggest the next possible word. The possible word can be chosen among 5 options that appear in a popup window.")),
                                                                                                                            tags$div(h2("Application Limitation"),tags$div("The application will only suggest the following word for the last word from the last non-empty row. This means that, if a space is entered in the middle of a sentence, the appearing suggestion will correspond to the next word for the last word in the last non-empty row.")),
                                                                                                                            tags$div(h2("User Input"),tags$div("The user can enter information by typing words. Additionally the user can also paste some text  in the editor area.")),
                                                                                                                            tags$div(h2("Triggering The Application"),tags$div("The application is activated after the users types a space character. Also the application is activated after a piece of text is copied. The previous suggestion can be reloaded by presing Ctr+Space")),
                                                                                                                            tags$div(h2("Application Output"), tags$div("The output is seen  as a popup window with the top 5 rated possible entries"),
                                                                                                                                     tags$div(style="text-align:center;", tags$div(class="note-popover in note-hint-popover col-md-offset-5 col-md-3", style="width:100px; border:solid 1px #555; ",
                                                                                                                                              tags$div(class="arrow", style="display: none;"),
                                                                                                                                              tags$div(class="popover-content note-children-container",
                                                                                                                                                       tags$div( class="note-hint-group note-hint-group-2",
                                                                                                                                                                 tags$div(class="note-hint-item active","and"),
                                                                                                                                                                 tags$div(class="note-hint-item ","two"),
                                                                                                                                                                 tags$div(class="note-hint-item ","three"),
                                                                                                                                                                 tags$div(class="note-hint-item ","four"),
                                                                                                                                                                 tags$div(class="note-hint-item ","five")
                                                                                                                                                       )
                                                                                                                                              )
                                                                                                                                     )
                                                                                                                                ),
                                                                                                                                tags$br(),tags$br(),tags$br(),tags$br(),tags$br(),tags$br(),tags$br(),tags$br(),
                                                                                                                                tags$div("The user can click on the desired entry and it will be pasted in the text editor ")
                                                                                                                            )#,
                                                                                                                                                                                                                                                        
                                                                                                                            #tags$div(h2("Restarting the game"),tags$div("Once the user has lost or won the game a 'Try Again' button will be displayed. Additionally the user can refresh the page to start again."))
                                                                                                                   ),
                                                                                                                   tags$div(class="modal-footer", tags$button(type="button", class="btn btn-default", "data-dismiss"="modal","Close") )
    )
    )         
    )
  )
))