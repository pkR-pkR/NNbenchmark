# NNbenchmark

NNbenchmark was created during the Google Summer of Code, 2019 as a part of The R Project for Statistical Computing, to verify the convergence of the training algorithms provided
in 69 Neural Network R packages available on CRAN to date. Neural networks must be trained with second order algorithms and not with first order algorithms as many packages seem to do. 


The purpose of this project is to verify the quality of the training algorithms in R packages that provide neural network of perceptron type (one input layer, one normalized layer, one hidden layer with nonlinear activation function usually tanh(), 
one normalized layer, one output output layer) for regression purpose i.e. NN(X1, ..., Xn) = E[Y].



# Packages Tested  

This GSoC project will conduct a comprehensive survey of all packages that have the “neural network” keyword in thepackage title or in the package description. There are currently 69 packages on CRAN with this keyword.  


|    []()       |               |               |               |               |               |
|:-------------:|:-------------:|:-------------:|:-------------:|:-------------:|:-------------:| 
|   AMORE       |    ANN2       |  appnn        | autoencoder   | automl        | BNN           |
|   brnn        |    Buddle     |  CaDENCE      |   cld2        | cld3          | condmixt      |
|   DALEX2      |    DamiaNN    |  deepnet      |   deepNN      | DNMF          | elmNNrcpp     |
|   ELMR        | EnsembleBase  |  evclass      | gamlss.add    | gcForest      | GMDH          |
|   GMDH2       |    GMDHreg    |  grnn         |   h2o         | hybridEnsemble|  isingLenzMC  |
|   keras       | kerasformula  |  kerasR       |   leabRa      | learNN        |  LilRhino     |
|   monmlp      | neural        |  neuralnet    |NeuralNetTools | NlinTS        |  nnet         |
| nnetpredint   | nnfor         |  onnx         |OptimClassifier|  OSTSC        |  pnn          |
|   polyreg     | predictoR     |  qrnn         |   QuantumOps  | quarrint      | radiant.model |
|   rasclass    | rcane         |  rminer       |   rmn         | RSNNS         |  ruta         |
| simpleNeural  | snnr          |  softmaxreg   | Sojourn.Data  | spnn          |  TeachNet     |
|  tensorflow   | tfestimators  |  trackdem     | TrafficBDE    | validann      |               |



# Evaluation Criteria
***
The algorithms were tested on 12 regression datasets (both univariate and multivariate) of varying complexity.  

The score for each package was based on the following parameters:  

* Documentation (0-3 stars or a binary value of 0/1)
* UtilFunction (0-3 stars or a binary value of 0/1)
* ConvergenceQuality (0-3 stars based on percentile method)
* ConvergenceTime (0-3 stars based on percentile method)


To obtain the final rating, we take a weighted average of these 4 columns (giving more weight to ConvergenceQuality and ConvergenceTIme).



# Authors  

## Selected Students:

- Akshaj Verma
- Salsabila Mahdi

## Mentors:

- Patrice Kiener  
- Christophe Dutang
- John C. Nash
