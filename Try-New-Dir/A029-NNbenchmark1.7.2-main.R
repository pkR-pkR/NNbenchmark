    
    
    ## =======================================
    ##   Main Runner Script - NNbenchmark1.7.2
    ## =======================================
    library(NNbenchmark)
    library(csv)
    
    rm(list=ls(all=TRUE))
    setwd("./Try-New-Dir") ; getwd()
    options(scipen = 9999)
    options("digits.secs" = 2)
    
    ## ============
    ## ALL DATASETS
    ## ============
    # ht(NNdatasets, n = 2, l = 6)
    # names(NNdatasets)
    
    ## [1] "mDette"    "mFriedman" "mIshigami" "mRef153"   "uDmod1"    "uDmod2"   
    ## [7] "uDreyfus1" "uDreyfus2" "uGauss1"   "uGauss2"   "uGauss3"   "uNeuroOne"
    
    
    
    ## =================================================
    ## NO LOOP OR LOOP ON DATASETS + ATTACH THE DATASET
    ## SEE AT THE END OF THIS PAGE THE detach() FUNCTION
    ## =================================================
    ## NO LOOP OR LOOP => QUOTE OR UNQUOTE THE 3 LINES BELOW
    ## THE { IS CLOSED AT THE THE END OF THIS PAGE!
    ## HENCE, A VERY LARGE LOOP OVER THE 70 PACKAGES.
    
    dsets <- names(NNdatasets)
    for (dset in dsets) {
        
        ds    <- NNdatasets[[dset]]$ds
        Z     <- NNdatasets[[dset]]$Z
        neur  <- NNdatasets[[dset]]$neur
        
        TF    <- TRUE
        nrep  <- 10
        timer <- createTimer()
        
        donotremove  <- c("dset", "dsets", "ds", "Z", "neur", "TF", "nrep", "timer",
                          "donotremove", "donotremove2")
        donotremove2 <- c("dset", "dsets") 
        
        
        
        
        ## ==============
        ## PACKAGE AMORE
        ## ==============
        #source("A030-NNbenchmark1.7.2-package-amore.R")
        
        ## =============
        ## PACKAGE ANN2
        ## =============
        #source("A032-NNbenchmark1.7.2-package-ann2.R")
        
        
        ## =====================
        ## PACKAGE automl
        ## =====================
        #source("A034-NNbenchmark1.7.2-package-automl.R")
        
    
        ## =============
        ## PACKAGE BRNN
        ## =============
        source("A036-NNbenchmark1.7.2-package-brnn.R")
        
        
        ## ================
        ## PACKAGE CaDENCE 
        ## ================
        #source("A038-NNbenchmark1.7.2-package-cadence.R")
        
        
        
        ## =====================
        ## PACKAGE deepnet
        ## =====================
        #source("A042-NNbenchmark1.7.2-package-deepnet.R")
        
        
        ## ===============
        ## PACKAGE deepNN
        ## ===============
        # source("A044-NNbenchmark1.7.2-package-deepnn.R")
        
        
        ## ==================
        ## PACKAGE elmNNRcpp
        ## ==================
       # source("A046-NNbenchmark1.7.2-package-elmnnrcpp.R")
        
        
        
        ## =============
        ## PACKAGE ELMR
        ## =============
        # source("A048-NNbenchmark1.7.2-package-elmr.R")
        
        
    
        ## ============
        ## PACKAGE h2o - NOT WORKING IN A LOOP
        ## ============
        # source("A052-NNbenchmark1.7.2-package-h2o.R")
        
        
        ## ==============
        ## PACKAGE keras
        ## ==============
        # source("A054-NNbenchmark1.7.2-package-keras.R")
        
        
        
        ###########################################################################
                    # Untested Packages Below
        ###########################################################################
        
        
        ## =============
        ## PACKAGE grnn
        ## =============
        # source("A019-NNbenchmark1.5-package-grnn.R")
        
    
        
        ## =====================
        ## PACKAGE kerasformula
        ## =====================
        # source("A021-NNbenchmark1.5-package-kerasformula.R") 
        
        
        ## =====================
        ## PACKAGE gamlss
        ## =====================
        # source("A027-NNbenchmark1.5-package-gamlss.R")
        
    
        
        ## ===========================================================
        ## SAVE THE timer DATA.FRAME WITH THE RESULTS FOR ALL PACKAGES
        ## IT CAN BE LATER MANIPULATED WITH dplyr
        ## ===========================================================
        dfr <- getTimer(timer) ; dfr
        csv::as.csv(dfr, paste0("./output/", dset, "-timer.csv"))
        
        
        remove(list= ls()[!(ls() %in% donotremove2)])
        gc();gc()
        
        ## ===========
        ## END OF LOOP
        ## =========== 
    }
    
    
    ## END
    ## END
    
    
