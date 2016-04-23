library(shiny)
secretW<-c('APPLE','PINEAPPLE','BANANA','CARROT','POMEGRANATE','ORANGE','RASPBERRY','GRAPEFRUIT','AVOCADO',
           'COCONUT','PEACH','STRAWBERRY','PAPAYA','ELEPHANT','BUTTERFLY','PLATYPUS','HIPPOPOTAMUS','KANGAROO',
           'MERMAID','GRYPHON','CHIMAERA','SPHINX','CENTAURS','CERBERUS','HIPPOCAMP','KITSUNE','MINOTAUR')
load("vocTreeW.RData")
idx<-0
maxRes<-5

shinyServer(
  function(input, output, clientData, session) {    
    
    
    processWord<-function(w,s=''){
      w<-tolower(gsub("\\s+"," ",w))
      data<-unlist(strsplit(x=w,split = " "))
      countT<-length(data)
      if(countT > 2){
        data<- data[(countT-2):countT]
        res<-searchEnv3(data, treeVW)
        resSize<-length(res)
        if(resSize >= maxRes){
          res<-lapply(res[1:maxRes], function(x){unlist(strsplit(x=x, split="\\s"))[2] })
        }else{
          res<-lapply(res, function(x){unlist(strsplit(x=x, split="\\s"))[2] })
          #resMiss<-maxRes-resSize         
          res2<-searchEnv2(data[2:3], treeVW)
          cMax<-min(maxRes, length(res2))
          if(cMax > 0){
            res2<-unlist(lapply(res2[1:cMax], function(x){unlist(strsplit(x=x, split="\\s"))[2] }))
            for(i in 1:cMax){
              if(!containTerm(res2[i], res)){
                res<-append(x = res,values = res2[i])
                if(length(res) >= maxRes){
                  break;
                }
              }
            }
          
            resSize<-length(res)
          }  
          if(resSize < maxRes){
            res3<-searchEnv(data[3], treeVW)
            cMax<-min(maxRes, length(res3))
            if(cMax > 0){
              res3<-unlist(lapply(res3[1:cMax], function(x){unlist(strsplit(x=x, split="\\s"))[2] }))
              for(i in 1:cMax){
                if(!containTerm(res3[i], res)){
                  res<-append(x = res,values = res3[i])
                  if(length(res) >= maxRes){
                    break;
                  }
                }
              }
              resSize<-length(res)
            }
            if(resSize < maxRes){
              if(!containTerm("and",res)){
                res<-append(x = res,values = "and")
              }
            }
          }
        }
        
      }else if(countT == 2){
        res<-searchEnv2(data, treeVW)
        resSize<-length(res)
        if(resSize >= maxRes){
          res<-lapply(res[1:maxRes], function(x){unlist(strsplit(x=x, split="\\s"))[2] })
        }else{ 
          res<-lapply(res, function(x){unlist(strsplit(x=x, split="\\s"))[2] })
          res2<-searchEnv(data[2:2], treeVW)
          cMax<-min(maxRes, length(res2))
          if(cMax > 0){
            res2<-unlist(lapply(res2[1:cMax], function(x){unlist(strsplit(x=x, split="\\s"))[2] }))
            for(i in 1:cMax){
              if(!containTerm(res2[i], res)){
                res<-append(x = res,values = res2[i])
                if(length(res) >= maxRes){
                  break;
                }
              }
            }
            resSize<-length(res)
          }
        }        
        resSize<-length(res)
        if(resSize < maxRes){
          if(!containTerm("and",res)){
            res<-append(x = res,values = "and")
          }
        }
      }else if(countT == 1){
        res<-searchEnv(data, treeVW)        
        resSize<-length(res)        
        if(resSize >= maxRes){
          res<-lapply(res[1:maxRes], function(x){unlist(strsplit(x=x, split="\\s"))[2] })
        }else{          
          res<-lapply(res, function(x){unlist(strsplit(x=x, split="\\s"))[2] })
          if(!containTerm("and",res)){
            res<-append(x = res,values = "and")
          }
        }
      }else{
        res<-list("and")
      } 
      
      #res<-list("and")
      res<-unlist(res)
      updateTextInput( session, "resultData",
                       #label = paste("New", c_label),
                       value = res)
      res
      
    }    
    
    containTerm<-function(s,l){
      return(sum( l == s ) >= 1 )
    }
    
    searchEnv<-function(ss,e){
      fs<-paste0("_",ss);
      if(!exists(x = fs,envir = e)){return(list())}
      res<-get(fs,envir = e)
      return(res)
    }
    
    searchEnv2<-function(ss,e){     
      fs<-paste0("_",ss[1],"_",ss[2]) 
      if(!exists(x = fs,envir = e)){return(list())}
      res<-get(fs,envir = e)
      return(res)
    }
    
    searchEnv3<-function(ss,e){      
      fs<-paste0("_",ss[1],"_",ss[2],"_",ss[3])
      if(!exists(x = fs,envir = e)){return(list())}
      res<-get(fs,envir = e)
      return(res)
    }
    
    searchEnv4<-function(ss,e){      
      fs<-paste0("_",ss[1],"_",ss[2],"_",ss[3],"_",ss[4])
      if(!exists(x = fs,envir = e)){return(NA)}
      res<-get(fs,envir = e)
      return(res)
    }
    
    checkWord<-function(letters,index){
      s<-processWord(secretW[idx])
      cc<-rep("_",length(s))
      l<-processWord(letters,',')      
      err<-0
      ok<-0
      if(length(l) > 0){
        index<-1:length(s)
        index2<-1:length(l)
        for(i in index2){
          cl<-l[i]
          found<-F
          for(j in index){
            if(cl == s[j]){
              found<-T
              cc[j]=cl
            }
          }
          if(found){ok<-ok+1;}
          else{err<-err+1;}
        }
        df<-data.frame(right=ok,wrong=err)
        output$myPlot <- renderPlot({      
          par(mfrow=c(1, 1), mar=c(5, 5, 4, 10))
          barplot(matrix(df),col=c('lightgreen','darkred'), main=paste0("Accuracy ",(ok*100/(ok+err)),"%" ), 
                  legend=names(df) ,args.legend = list(x = "topright", bty = "n", inset=c(-0.15, 0)) )
          
        })        
        resVal <-as.character((ok*100/(ok+err)))
        if(sum(cc == "_") == 0){
          resVal<-paste(resVal,"%")
        }else if(err > 9){
          resVal<-"-1"
        }
        updateTextInput( session, "word",
                        #label = paste("New", c_label),
                        value = resVal
        )
      }
      
      cc
    }  
    
   
    
    output$oid1 = renderPrint( {processWord(input$newLetter,',')})     
    #output$secret = renderPrint({checkWord(input$newLetter,idx)})     
    
  }
)