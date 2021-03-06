#' AutoCatBoostHurdleModel for generalized hurdle modeling
#' 
#' AutoCatBoostHurdleModel for generalized hurdle modeling. Check out the Readme.Rd on github for more background.
#'
#' @author Adrian Antico
#' @family Automated Regression
#' @param data Source training data. Do not include a column that has the class labels for the buckets as they are created internally.
#' @param TrainOnFull Set to TRUE to use all data
#' @param ValidationData Source validation data. Do not include a column that has the class labels for the buckets as they are created internally.
#' @param TestData Souce test data. Do not include a column that has the class labels for the buckets as they are created internally.
#' @param Buckets A numeric vector of the buckets used for subsetting the data. NOTE: the final Bucket value will first create a subset of data that is less than the value and a second one thereafter for data greater than the bucket value.
#' @param TargetColumnName Supply the column name or number for the target variable
#' @param FeatureColNames Supply the column names or number of the features (not included the PrimaryDateColumn)
#' @param PrimaryDateColumn Supply a date column if the data is functionally related to it
#' @param IDcols Includes PrimaryDateColumn and any other columns you want returned in the validation data with predictions
#' @param TransformNumericColumns Transform numeric column inside the AutoCatBoostRegression() function
#' @param ClassWeights Utilize these for the classifier model
#' @param SplitRatios Supply vector of partition ratios. For example, c(0.70,0.20,0,10).
#' @param task_type Set to "GPU" or "CPU"
#' @param ModelID Define a character name for your models
#' @param Paths The path to your folder where you want your model information saved
#' @param MetaDataPaths TA character string of your path file to where you want your model evaluation output saved. If left NULL, all output will be saved to Paths.
#' @param SaveModelObjects Set to TRUE to save the model objects to file in the folders listed in Paths
#' @param GridTune Set to TRUE if you want to grid tune the models
#' @param MaxModelsInGrid Set to a numeric value for the number of models to try in grid tune
#' @param NumOfParDepPlots Set to pull back N number of partial dependence calibration plots.
#' @param PassInGrid Pass in a grid for changing up the parameter settings for catboost
#' @param BaselineComparison = "default",
#' @param MaxModelsInGrid = 1L,
#' @param MaxRunsWithoutNewWinner = 20L,
#' @param MaxRunMinutes = 60L*60L,
#' @param Shuffles = 2L,
#' @param MetricPeriods = 25L,
#' @param Trees = seq(1000L, 5000L, 500L),
#' @param Depth = seq(4L, 8L, 1L),
#' @param LearningRate = seq(0.01,0.10,0.01),
#' @param L2_Leaf_Reg = seq(1.0, 10.0, 1.0),
#' @param RSM = c(0.80, 0.85, 0.90, 0.95, 1.0),
#' @param BootStrapType = c("Bayesian", "Bernoulli", "Poisson", "MVS", "No"),
#' @param GrowPolicy = c("SymmetricTree", "Depthwise", "Lossguide")
#' @return Returns AutoCatBoostRegression() model objects: VariableImportance.csv, Model, ValidationData.csv, EvalutionPlot.png, EvalutionBoxPlot.png, EvaluationMetrics.csv, ParDepPlots.R a named list of features with partial dependence calibration plots, ParDepBoxPlots.R, GridCollect, and catboostgrid
#' @examples
#' \donttest{
#' Output <- RemixAutoML::AutoCatBoostHurdleModel( 
#' 
#'   # Operationalization
#'   task_type = "GPU",
#'   ModelID = "ModelTest",
#'   SaveModelObjects = FALSE,
#'   ReturnModelObjects = TRUE,
#'   
#'   # Data related args
#'   data = data,
#'   TrainOnFull = FALSE,
#'   ValidationData = NULL,
#'   TestData = NULL,
#'   Buckets = 0L,
#'   TargetColumnName = NULL,
#'   FeatureColNames = NULL,
#'   PrimaryDateColumn = NULL,
#'   IDcols = NULL,
#'   
#'   # Metadata args
#'   Paths = normalizePath("./"),
#'   MetaDataPaths = NULL,
#'   TransformNumericColumns = NULL,
#'   Methods = c("BoxCox", "Asinh", "Asin", "Log", "LogPlus1", "Logit", "YeoJohnson"),
#'   ClassWeights = NULL,
#'   SplitRatios = c(0.70, 0.20, 0.10),
#'   NumOfParDepPlots = 10L,
#'   
#'   # Grid tuning setup
#'   PassInGrid = NULL,
#'   GridTune = FALSE,
#'   BaselineComparison = "default",
#'   MaxModelsInGrid = 1L,
#'   MaxRunsWithoutNewWinner = 20L,
#'   MaxRunMinutes = 60L*60L,
#'   Shuffles = 2L,
#'   MetricPeriods = 25L,
#'   
#'   # Bandit grid args
#'   Trees = seq(1000L, 5000L, 500L),
#'   Depth = seq(4L, 8L, 1L),
#'   LearningRate = seq(0.01,0.10,0.01),
#'   L2_Leaf_Reg = seq(1.0, 10.0, 1.0),
#'   RSM = c(0.80, 0.85, 0.90, 0.95, 1.0),
#'   BootStrapType = c("Bayesian", "Bernoulli", "Poisson", "MVS", "No"),
#'   GrowPolicy = c("SymmetricTree", "Depthwise", "Lossguide"))
#' }
#' @export
AutoCatBoostHurdleModel <- function(data = NULL,
                                    TrainOnFull = FALSE,
                                    ValidationData = NULL,
                                    TestData = NULL,
                                    Buckets = 0L,
                                    TargetColumnName = NULL,
                                    FeatureColNames = NULL,
                                    PrimaryDateColumn = NULL,
                                    IDcols = NULL,
                                    TransformNumericColumns = NULL,
                                    Methods = c("BoxCox", "Asinh", "Asin", "Log", "LogPlus1", "Logit", "YeoJohnson"),
                                    ClassWeights = NULL,
                                    SplitRatios = c(0.70, 0.20, 0.10),
                                    task_type = "GPU",
                                    ModelID = "ModelTest",
                                    Paths = NULL,
                                    MetaDataPaths = NULL,
                                    SaveModelObjects = FALSE,
                                    ReturnModelObjects = TRUE,
                                    NumOfParDepPlots = 10L,
                                    PassInGrid = NULL,
                                    GridTune = FALSE,
                                    BaselineComparison = "default",
                                    MaxModelsInGrid = 1L,
                                    MaxRunsWithoutNewWinner = 20L,
                                    MaxRunMinutes = 60L*60L,
                                    Shuffles = 2L,
                                    MetricPeriods = 25L,
                                    Trees = seq(1000L, 5000L, 500L),
                                    Depth = seq(4L, 8L, 1L),
                                    LearningRate = seq(0.01,0.10,0.01),
                                    L2_Leaf_Reg = seq(1.0, 10.0, 1.0),
                                    RSM = c(0.80, 0.85, 0.90, 0.95, 1.0),
                                    BootStrapType = c("Bayesian", "Bernoulli", "Poisson", "MVS", "No"),
                                    GrowPolicy = c("SymmetricTree", "Depthwise", "Lossguide")) {
  
  # Store args----
  ArgsList <- list()
  ArgsList[["Buckets"]] <- Buckets
  ArgsList[["TargetColumnName"]] <- TargetColumnName
  ArgsList[["FeatureColNames"]] <- FeatureColNames
  ArgsList[["PrimaryDateColumn"]] <- PrimaryDateColumn
  ArgsList[["IDcols"]] <- IDcols
  ArgsList[["TransformNumericColumns"]] <- TransformNumericColumns
  ArgsList[["ClassWeights"]] <- ClassWeights
  ArgsList[["SplitRatios"]] <- SplitRatios
  ArgsList[["task_type"]] <- task_type
  ArgsList[["ModelID"]] <- ModelID
  ArgsList[["Paths"]] <- Paths
  ArgsList[["MetaDataPaths"]] <- MetaDataPaths
  ArgsList[["SaveModelObjects"]] <- SaveModelObjects
  
  # Check args----
  if(is.character(Buckets) | is.factor(Buckets) | is.logical(Buckets)) return("Buckets needs to be a numeric scalar or vector")
  if(!is.logical(SaveModelObjects)) return("SaveModelOutput needs to be set to either TRUE or FALSE")
  if(!is.logical(GridTune)) return("GridTune needs to be either TRUE or FALSE")
  if(!GridTune & length(Trees) > 1L) Trees <- Trees[length(Trees)]

  # Turn on full speed ahead----
  if(parallel::detectCores() > 10) data.table::setDTthreads(threads = max(1L, parallel::detectCores() - 2L)) else data.table::setDTthreads(threads = max(1L, parallel::detectCores()))
  
  # Ensure Paths and metadata_path exists----
  if(!is.null(Paths)) if(!dir.exists(normalizePath(Paths))) dir.create(normalizePath(Paths))
  if(is.null(MetaDataPaths)) MetaDataPaths <- Paths else if(!dir.exists(normalizePath(MetaDataPaths))) dir.create(normalizePath(MetaDataPaths))

  # Data.table check----
  if(!data.table::is.data.table(data)) data.table::setDT(data)
  if(!is.null(ValidationData)) if(!data.table::is.data.table(ValidationData)) data.table::setDT(ValidationData)
  if(!is.null(TestData)) if(!data.table::is.data.table(TestData)) data.table::setDT(TestData)
  
  # IDcols to Names----
  if(!is.null(IDcols)) if(is.numeric(IDcols) | is.integer(IDcols)) IDcols <- names(data)[IDcols]
  
  # Primary Date Column----
  if(is.numeric(PrimaryDateColumn) | is.integer(PrimaryDateColumn)) PrimaryDateColumn <- names(data)[PrimaryDateColumn]
  
  # FeatureColumnNames----
  if(is.numeric(FeatureColNames) | is.integer(FeatureColNames)) FeatureNames <- names(data)[FeatureColNames] else FeatureNames <- FeatureColNames
  
  # Add target bucket column----
  if(length(Buckets) == 1L) {
    data.table::set(data, i = which(data[[eval(TargetColumnName)]] <= Buckets[1L]), j = "Target_Buckets", value = 0L)
    data.table::set(data, i = which(data[[eval(TargetColumnName)]] > Buckets[1L]), j = "Target_Buckets", value = 1L)
  } else {
    for(i in seq_len(length(Buckets) + 1L)) {
      if(i == 1L) {
        data.table::set(data, i = which(data[[eval(TargetColumnName)]] <= Buckets[i]), j = "Target_Buckets", value = as.factor(Buckets[i]))
      } else if(i == length(Buckets) + 1L) {
        data.table::set(data, i = which(data[[eval(TargetColumnName)]] > Buckets[i - 1]), j = "Target_Buckets", value = as.factor(paste0(Buckets[i - 1], "+")))
      } else {
        data.table::set(data, i = which(data[[eval(TargetColumnName)]] <= Buckets[i] & data[[eval(TargetColumnName)]] > Buckets[i - 1]), j = "Target_Buckets", value = as.factor(Buckets[i]))
      }      
    }
  }
  
  # Add target bucket column----
  if(!is.null(ValidationData)) {
    ValidationData[, Target_Buckets := as.factor(Buckets[1L])]
    for(i in seq_len(length(Buckets) + 1L)) {
      if(i == 1) {
        data.table::set(ValidationData, i = which(ValidationData[[eval(TargetColumnName)]] <= Buckets[i]), j = "Target_Buckets", value = as.factor(Buckets[i]))
      } else if(i == length(Buckets) + 1L) {
        data.table::set(ValidationData, i = which(ValidationData[[eval(TargetColumnName)]] > Buckets[i - 1]), j = "Target_Buckets", value = as.factor(paste0(Buckets[i - 1], "+")))
      } else {
        data.table::set(ValidationData, i = which(ValidationData[[eval(TargetColumnName)]] <= Buckets[i] & ValidationData[[eval(TargetColumnName)]] > Buckets[i - 1]), j = "Target_Buckets",value = as.factor(Buckets[i]))
      }
    }
  }
  
  # Add target bucket column----
  if(!is.null(TestData)) {
    TestData[, Target_Buckets := as.factor(Buckets[1])]
    for(i in seq_len(length(Buckets) + 1L)) {
      if(i == 1) {
        data.table::set(TestData, i = which(TestData[[eval(TargetColumnName)]] <= Buckets[i]), j = "Target_Buckets", value = as.factor(Buckets[i]))
      } else if(i == length(Buckets) + 1L) {
        data.table::set(TestData, i = which(TestData[[eval(TargetColumnName)]] > Buckets[i - 1]), j = "Target_Buckets", value = as.factor(paste0(Buckets[i - 1L], "+")))
      } else {
        data.table::set(TestData, i = which(TestData[[eval(TargetColumnName)]] <= Buckets[i] & TestData[[eval(TargetColumnName)]] > Buckets[i - 1L]), j = "Target_Buckets", value = as.factor(Buckets[i]))
      }
    }
  }
  
  # AutoDataPartition if Validation and TestData are NULL----
  if(is.null(ValidationData) & is.null(TestData)) {
    DataSets <- AutoDataPartition(
      data = data,
      NumDataSets = 3L,
      Ratios = SplitRatios,
      PartitionType = "random",
      StratifyColumnNames = "Target_Buckets",
      TimeColumnName = NULL)
    data <- DataSets$TrainData
    ValidationData <- DataSets$ValidationData
    TestData <- DataSets$TestData
    rm(DataSets)
  }
  
  # Begin classification model building----
  if(length(Buckets) == 1L) {
    ClassifierModel <- AutoCatBoostClassifier(

      # GPU or CPU
      task_type = task_type,
      
      # Metadata arguments
      ModelID = ModelID,
      model_path = Paths,
      metadata_path = MetaDataPaths,
      SaveModelObjects = SaveModelObjects,
      ReturnModelObjects = ReturnModelObjects,
      
      # Data arguments
      data = data,
      TrainOnFull = TrainOnFull,
      ValidationData = ValidationData,
      TestData = TestData,
      TargetColumnName = "Target_Buckets",
      FeatureColNames = FeatureNames,
      PrimaryDateColumn = PrimaryDateColumn,
      ClassWeights = ClassWeights,
      IDcols = IDcols,
      
      # Model evaluation
      eval_metric = "AUC",
      MetricPeriods = MetricPeriods,
      NumOfParDepPlots = NumOfParDepPlots,
      
      # Grid tuning arguments - PassInGrid is the best of GridMetrics
      PassInGrid = PassInGrid,
      GridTune = GridTune,
      MaxModelsInGrid = MaxModelsInGrid,
      MaxRunsWithoutNewWinner = MaxRunsWithoutNewWinner,
      MaxRunMinutes = MaxRunMinutes,
      Shuffles = Shuffles,
      BaselineComparison = BaselineComparison,
      
      # Trees, Depth, and LearningRate used in the bandit grid tuning
      Trees = Trees,
      Depth = Depth,
      LearningRate = LearningRate,
      L2_Leaf_Reg = L2_Leaf_Reg,
      RSM = RSM,
      BootStrapType = BootStrapType,
      GrowPolicy = GrowPolicy)
    
  } else {
    
    ClassifierModel <- AutoCatBoostMultiClass(
      
      # GPU or CPU
      task_type = task_type,

      # Metadata arguments
      ModelID = ModelID,
      model_path = Paths,
      metadata_path = MetaDataPaths,
      SaveModelObjects = SaveModelObjects,
      ReturnModelObjects = ReturnModelObjects,
      
      # Data arguments
      data = data,
      TrainOnFull = TrainOnFull,
      ValidationData = ValidationData,
      TestData = TestData,
      TargetColumnName = "Target_Buckets",
      FeatureColNames = FeatureNames,
      PrimaryDateColumn = PrimaryDateColumn,
      ClassWeights = ClassWeights,
      IDcols = IDcols,
      
      # Model evaluation
      eval_metric = "MultiClass",
      MetricPeriods = MetricPeriods,
      grid_eval_metric = "accuracy",
      
      # Grid tuning arguments - PassInGrid is the best of GridMetrics
      PassInGrid = PassInGrid,
      GridTune = GridTune,
      MaxModelsInGrid = MaxModelsInGrid,
      MaxRunsWithoutNewWinner = MaxRunsWithoutNewWinner,
      MaxRunMinutes = MaxRunMinutes,
      Shuffles = Shuffles,
      BaselineComparison = BaselineComparison,
      
      # Trees, Depth, and LearningRate used in the bandit grid tuning
      Trees = Trees,
      Depth = Depth,
      LearningRate = LearningRate,
      L2_Leaf_Reg = L2_Leaf_Reg,
      RSM = RSM,
      BootStrapType = BootStrapType,
      GrowPolicy = GrowPolicy)
  }
  
  # Store metadata----
  ModelList <- list()
  ClassModel <- ClassifierModel$Model
  ClassEvaluationMetrics <- ClassifierModel$EvaluationMetrics
  VariableImportance <- ClassifierModel$VariableImportance
  if(length(Buckets) > 1L) {
    TargetLevels <- ClassifierModel$TargetLevels
    ArgsList[["TargetLevels"]] <- TargetLevels
  } else {
    TargetLevels <- NULL
    ArgsList[["TargetLevels"]] <- NULL
  }
  
  # Store model----
  if(SaveModelObjects) ModelList[["Classifier"]] <- ClassModel
  
  # Add Target to IDcols----
  IDcols <- c(IDcols, TargetColumnName)
  
  # Score Classification Model----
  if(length(Buckets) == 1L) TargetType <- "Classification" else TargetType <- "Multiclass"
   
  # Model Scoring----
  TestData <- AutoCatBoostScoring(
    RemoveModel = TRUE,
    TargetType = TargetType,
    ScoringData = TestData,
    FeatureColumnNames = FeatureNames,
    IDcols = IDcols,
    ModelObject = ClassModel,
    ModelPath = Paths,
    ModelID = ModelID,
    ReturnFeatures = TRUE,
    MultiClassTargetLevels = TargetLevels,
    TransformNumeric = FALSE, 
    BackTransNumeric = FALSE, 
    TargetColumnName = NULL, 
    TransformationObject = NULL, 
    TransID = NULL, 
    TransPath = Paths,
    MDP_Impute = FALSE,
    MDP_CharToFactor = TRUE,
    MDP_RemoveDates = FALSE, 
    MDP_MissFactor = "0",
    MDP_MissNum = -1)
  
  # Change name for classification----
  if(TargetType == "Classification") {
    data.table::setnames(TestData, "p1", "Predictions_C1")
    TestData[, Predictions_C0 := 1 - Predictions_C1]
    data.table::setcolorder(TestData, c(ncol(TestData), 1L, 2L:(ncol(TestData) - 1L)))
  }

  # Remove Model Object----
  rm(ClassModel)
  
  # Remove Target_Buckets----
  data.table::set(data, j = "Target_Buckets", value = NULL)
  data.table::set(ValidationData, j = "Target_Buckets", value = NULL)
  
  # Remove Target From IDcols----
  IDcols <- IDcols[!(IDcols %chin% TargetColumnName)]
  
  # Change Name of Predicted MultiClass Column----
  if(length(Buckets) != 1L) data.table::setnames(TestData, "Predictions", "Predictions_MultiClass")
  counter <- max(rev(seq_len(length(Buckets) + 1L))) + 1L
  Degenerate <- 0L
  
  # Begin regression model building----
  for(bucket in rev(seq_len(length(Buckets) + 1L))) {
    
    # Define data sets----
    if(bucket == max(seq_len(length(Buckets) + 1L))) {
      if(!is.null(TestData)) {
        trainBucket <- data[get(TargetColumnName) > eval(Buckets[bucket - 1L])]
        validBucket <- ValidationData[get(TargetColumnName) > eval(Buckets[bucket - 1L])]
        testBucket <- TestData[get(TargetColumnName) > eval(Buckets[bucket - 1L])]
        data.table::set(testBucket, j = setdiff(names(testBucket), names(data)), value = NULL)
      } else {
        trainBucket <- data[get(TargetColumnName) > eval(Buckets[bucket - 1L])]
        validBucket <- ValidationData[get(TargetColumnName) > eval(Buckets[bucket - 1L])]
        testBucket <- NULL
      }
    } else if(bucket == 1L) {
      if(!is.null(TestData)) {
        trainBucket <- data[get(TargetColumnName) <= eval(Buckets[bucket])]
        validBucket <- ValidationData[get(TargetColumnName) <= eval(Buckets[bucket])]
        testBucket <- TestData[get(TargetColumnName) <= eval(Buckets[bucket])]
        data.table::set(testBucket, j = setdiff(names(testBucket), names(data)), value = NULL)
      } else {
        trainBucket <- data[get(TargetColumnName) <= eval(Buckets[bucket])]
        validBucket <- ValidationData[get(TargetColumnName) <= eval(Buckets[bucket])]
        testBucket <- NULL
      }
    } else {
      if(!is.null(TestData)) {
        trainBucket <- data[get(TargetColumnName) <= eval(Buckets[bucket]) & get(TargetColumnName) > eval(Buckets[bucket - 1L])]
        validBucket <- ValidationData[get(TargetColumnName) <= eval(Buckets[bucket]) & get(TargetColumnName) > eval(Buckets[bucket - 1L])]
        testBucket <- TestData[get(TargetColumnName) <= eval(Buckets[bucket]) & get(TargetColumnName) > eval(Buckets[bucket - 1L])]
        data.table::set(testBucket, j = setdiff(names(testBucket), names(data)), value = NULL)
      } else {
        trainBucket <- data[get(TargetColumnName) <= eval(Buckets[bucket]) & get(TargetColumnName) > eval(Buckets[bucket - 1L])]
        validBucket <- ValidationData[get(TargetColumnName) <= eval(Buckets[bucket]) & get(TargetColumnName) > eval(Buckets[bucket - 1L])]
        testBucket <- NULL
      }
    }
    
    # Create Modified IDcols----
    IDcolsModified <- c(IDcols, setdiff(names(TestData), names(trainBucket)), TargetColumnName)
    
    # AutoCatBoostRegression()----
    if(trainBucket[, .N] != 0L) {
      
      # If there is some variance then build model
      if(var(trainBucket[[eval(TargetColumnName)]]) > 0L) {
        
        # Increment----
        counter <- counter - 1L
        
        # Modify filepath and file name----
        if(bucket == max(seq_len(length(Buckets) + 1L))) ModelIDD <- paste0(ModelID,"_",bucket,"+") else ModelIDD <- paste0(ModelID, "_", bucket)

        # Build model----
        RegModel <- AutoCatBoostRegression(

            # GPU or CPU
            task_type = task_type,

            # Metadata arguments
            ModelID = ModelIDD,
            model_path = Paths,
            metadata_path = MetaDataPaths,
            SaveModelObjects = SaveModelObjects,
            ReturnModelObjects = ReturnModelObjects,

            # Data arguments
            data = trainBucket,
            TrainOnFull = TrainOnFull,
            ValidationData = validBucket,
            TestData = testBucket,
            TargetColumnName = TargetColumnName,
            FeatureColNames = FeatureNames,
            PrimaryDateColumn = PrimaryDateColumn,
            IDcols = IDcols,
            TransformNumericColumns = TransformNumericColumns,

            # Model evaluation
            eval_metric = "RMSE",
            MetricPeriods = MetricPeriods,
            NumOfParDepPlots = NumOfParDepPlots,

            # Grid tuning arguments - PassInGrid is the best of GridMetrics
            PassInGrid = PassInGrid,
            GridTune = GridTune,
            MaxModelsInGrid = MaxModelsInGrid,
            MaxRunsWithoutNewWinner = MaxRunsWithoutNewWinner,
            MaxRunMinutes = MaxRunMinutes,
            Shuffles = Shuffles,
            BaselineComparison = BaselineComparison,

            # Trees, Depth, and LearningRate used in the bandit grid tuning
            Trees = Trees,
            Depth = Depth,
            LearningRate = LearningRate,
            L2_Leaf_Reg = L2_Leaf_Reg,
            RSM = RSM,
            BootStrapType = BootStrapType,
            GrowPolicy = GrowPolicy,
            Methods = Methods)
        
        # Store Model----
        RegressionModel <- RegModel$Model
        if(ReturnModelObjects | SaveModelObjects) ModelList[[ModelIDD]] <- RegressionModel
        if(!is.null(TransformNumericColumns)) {
          ArgsList[[paste0("TransformationResults_", ModelIDD)]] <- RegModel$TransformationResults
        } else {
          ArgsList[[paste0("TransformationResults_", ModelIDD)]] <- NULL
        }
          
        # Score models----
        TestData <- AutoCatBoostScoring(
          TargetType = "regression",
          ScoringData = TestData,
          FeatureColumnNames = FeatureNames,
          IDcols = IDcolsModified,
          ModelObject = RegressionModel,
          ModelPath = Paths,
          ModelID = ModelIDD,
          ReturnFeatures = TRUE,
          TransformationObject = ArgsList[[paste0("TransformationResults_", ModelIDD)]],
          TargetColumnName = eval(TargetColumnName),
          TransformNumeric = if(is.null(ArgsList[[paste0("TransformationResults_", ModelIDD)]])) FALSE else TRUE,
          BackTransNumeric = if(is.null(ArgsList[[paste0("TransformationResults_", ModelIDD)]])) FALSE else TRUE,
          TransID = NULL,
          TransPath = NULL,
          MDP_Impute = TRUE,
          MDP_CharToFactor = TRUE,
          MDP_RemoveDates = FALSE,
          MDP_MissFactor = "0",
          MDP_MissNum = -1)
        
        # Clear TestModel From Memory----
        rm(RegModel)
        gc()
        
        # Change prediction name to prevent duplicates----
        if(bucket == max(seq_len(length(Buckets) + 1L))) Val <- paste0("Predictions_", bucket - 1L, "+") else Val <- paste0("Predictions_", bucket)
        data.table::setnames(TestData, "Predictions", Val)

      } else {
        
        # Account for degenerate distributions----
        ArgsList[["constant"]] <- c(ArgsList[["constant"]], bucket)
        
        # Use single value for predictions in the case of zero variance----
        if(bucket == max(seq_len(length(Buckets) + 1L))) {
          Degenerate <- Degenerate + 1L
          data.table::set(TestData, j = paste0("Predictions", Buckets[bucket - 1L], "+"), value = Buckets[bucket])
          data.table::setcolorder(TestData, c(ncol(TestData), 1L:(ncol(TestData) - 1L)))
        } else {
          Degenerate <- Degenerate + 1L
          data.table::set(TestData, j = paste0("Predictions", Buckets[bucket]), value = Buckets[bucket])
          data.table::setcolorder(TestData, c(ncol(TestData), 1L:(ncol(TestData) - 1L)))
        }
      }
    } else {
      
      # Account for degenerate distributions----
      ArgsList[["degenerate"]] <- c(ArgsList[["degenerate"]], bucket)
    }
  }
  
  # Rearrange Column order----
  counter <- length(Buckets)
  if(counter > 2L) {
    if(length(IDcols) != 0L) {
      if(Degenerate == 0L) {
        data.table::setcolorder(TestData, c(2L:(1L + length(IDcols)), 1L, (2L + length(IDcols)):ncol(TestData)))
        data.table::setcolorder(TestData, c(1L:length(IDcols), (length(IDcols) + counter + 1L), (length(IDcols) + counter + 1L + counter +1L):ncol(TestData), (length(IDcols) + 1L):(length(IDcols) + counter), (length(IDcols) + counter + 2L):(length(IDcols)+counter + 1L + counter)))
      } else {
        data.table::setcolorder(TestData, c(3L:(2L + length(IDcols)), 1L:2L, (3L + length(IDcols)):ncol(TestData)))
        data.table::setcolorder(TestData, c(1L:length(IDcols), (length(IDcols) + counter + 1L + Degenerate), (length(IDcols) + counter + 3L + counter + Degenerate):ncol(TestData), (length(IDcols) + 1L):(length(IDcols) + counter + Degenerate), (length(IDcols) + counter + 2L + Degenerate):(length(IDcols)+counter+counter+Degenerate + 2L)))
      }
    } else {
      data.table::setcolorder(TestData, c(1L:(counter + Degenerate), (2L + counter + Degenerate):(1L + 2L * (counter + Degenerate)), (1L + counter + Degenerate), (2L + 2L * (counter + Degenerate)):ncol(TestData)))
      data.table::setcolorder(TestData, c((2L * (counter + Degenerate) + 1L):ncol(TestData), 1L:(2L * (counter + Degenerate))))
    }
  } else if(counter == 2L & length(Buckets) == 1L) {
    if(length(IDcols) != 0L) data.table::setcolorder(TestData, c(1L,2L, (2L + length(IDcols) + 1L):ncol(TestData), 3L:(2L + length(IDcols))))
  } else if(counter == 2L & length(Buckets) != 1L) {
    if(length(IDcols) != 0L) {
      data.table::setcolorder(TestData, c(1L:counter, (counter + length(IDcols) + 1L):(counter + length(IDcols) + 2L + length(Buckets) + 1L), which(names(TestData) %in% c(setdiff(names(TestData), names(TestData)[c(1L:counter, (counter + length(IDcols) + 1L):(counter + length(IDcols) + 2L + length(Buckets) + 1L))])))))
      data.table::setcolorder(TestData, c(1L:(counter + 1L), (counter + 1L + 2L):(counter + 1L + 2L + counter), which(names(TestData) %in% setdiff(names(TestData), names(TestData)[c(1L:(counter + 1L), (counter + 1L + 2L):(counter + 1L + 2L + counter))]))))
    } else {
      data.table::setcolorder(TestData, c(1L:(counter + 1L), (counter + 3L):(3L + 2 * counter), (counter + 2L), which(!names(TestData) %in% names(TestData)[c(1L:(counter + 1L), (counter + 3L):(3L + 2 * counter), (counter + 2L))])))
    }
  } else {
    if(length(IDcols) != 0L) {
      data.table::setcolorder(TestData, c(1L:2L, (3L + length(IDcols)):((3L + length(IDcols)) + 1L), 3L:(2L + length(IDcols)), (((3L + length(IDcols)) + 2L):ncol(TestData))))
    }
  }

  # Final Combination of Predictions----
  if(counter > 2L | (counter == 2L & length(Buckets) != 1L)) {
    for(i in seq_len(length(Buckets) + 1L)) {
      if(i == 1L) {
        TestData[, UpdatedPrediction := TestData[[i]] * TestData[[i + (length(Buckets) + 1L)]]]
      } else {
        TestData[, UpdatedPrediction := UpdatedPrediction + TestData[[i]] * TestData[[i + (length(Buckets) + 1L)]]]
      }
    }
  } else {
    TestData[, UpdatedPrediction := TestData[[1L]] * TestData[[3L]] + TestData[[2L]] * TestData[[4L]]]
  }
  
  # Regression r2 via sqrt of correlation----
  r_squared <- (TestData[, stats::cor(get(TargetColumnName), UpdatedPrediction)]) ^ 2L
  
  # Regression Save Validation Data to File----
  if(SaveModelObjects) {
    if(!is.null(MetaDataPaths)) {
      data.table::fwrite(TestData, file = file.path(normalizePath(MetaDataPaths), paste0(ModelID,"_ValidationData.csv")))
    } else {
      data.table::fwrite(TestData, file = file.path(normalizePath(Paths), paste0(ModelID,"_ValidationData.csv")))
    }
  }
  
  # Regression Evaluation Calibration Plot----
  EvaluationPlot <- EvalPlot(
    data = TestData,
    PredictionColName = "UpdatedPrediction",
    TargetColName = eval(TargetColumnName),
    GraphType = "calibration",
    PercentileBucket = 0.05,
    aggrfun = function(x) mean(x, na.rm = TRUE))
  
  # Add Number of Trees to Title----
  EvaluationPlot <- EvaluationPlot + ggplot2::ggtitle(paste0("Calibration Evaluation Plot: R2 = ",round(r_squared, 3L)))
  
  # Save plot to file----
  if(SaveModelObjects) {
    if(!is.null(MetaDataPaths)) {
      ggplot2::ggsave(file.path(normalizePath(MetaDataPaths), paste0(ModelID, "_EvaluationPlot.png")))
    } else {
      ggplot2::ggsave(file.path(normalizePath(Paths), paste0(ModelID, "_EvaluationPlot.png")))
    }
  }
  
  # Regression Evaluation Calibration Plot----
  EvaluationBoxPlot <- EvalPlot(
    data = TestData,
    PredictionColName = "UpdatedPrediction",
    TargetColName = eval(TargetColumnName),
    GraphType = "boxplot",
    PercentileBucket = 0.05,
    aggrfun = function(x) mean(x, na.rm = TRUE))
  
  # Add Number of Trees to Title----
  EvaluationBoxPlot <- EvaluationBoxPlot + ggplot2::ggtitle(paste0("Calibration Evaluation Plot: R2 = ",round(r_squared, 3L)))
  
  # Save plot to file----
  if(SaveModelObjects) {
    if(!is.null(MetaDataPaths)) {
      ggplot2::ggsave(file.path(normalizePath(MetaDataPaths), paste0(ModelID,"_EvaluationBoxPlot.png")))
    } else {
      ggplot2::ggsave(file.path(normalizePath(Paths), paste0(ModelID,"_EvaluationBoxPlot.png")))
    }
  }
  
  # Regression Evaluation Metrics----
  EvaluationMetrics <- data.table::data.table(Metric = c("MAE","MAPE","MSE","R2"),MetricValue = rep(999999, 4L))
  i <- 0L
  MinVal <- min(TestData[, min(get(TargetColumnName))], TestData[, min(UpdatedPrediction)])
  for(metric in c("mae","mape","mse","r2")) {
    i <- i + 1L
    tryCatch({
      if(tolower(metric) == "mae") {
        TestData[, Metric := abs(get(TargetColumnName) - UpdatedPrediction)]
        Metric <- TestData[, mean(Metric, na.rm = TRUE)]
      } else if(tolower(metric) == "mape") {
        TestData[, Metric := abs((get(TargetColumnName) - UpdatedPrediction) / (get(TargetColumnName) + 1L))]
        Metric <- TestData[, mean(Metric, na.rm = TRUE)]
      } else if(tolower(metric) == "mse") {
        TestData[, Metric := (get(TargetColumnName) - UpdatedPrediction) ^ 2L]
        Metric <- TestData[, mean(Metric, na.rm = TRUE)]
      } else if(tolower(metric) == "r2") {
        TestData[, ':=' (
          Metric1 = (get(TargetColumnName) - mean(get(TargetColumnName))) ^ 2L,
          Metric2 = (get(TargetColumnName) - UpdatedPrediction) ^ 2L)]
        Metric <- 1 - TestData[, sum(Metric2, na.rm = TRUE)] / TestData[, sum(Metric1, na.rm = TRUE)]
      }
      data.table::set(EvaluationMetrics, i = i, j = 2L, value = round(Metric, 4L))
      data.table::set(EvaluationMetrics, i = i, j = 3L, value = NA)
    }, error = function(x) "skip")
  }
  
  # Remove Cols----
  TestData[, ':=' (Metric = NULL, Metric1 = NULL, Metric2 = NULL)]
  
  # Save EvaluationMetrics to File----
  EvaluationMetrics <- EvaluationMetrics[MetricValue != 999999]
  if(SaveModelObjects) {
    if(!is.null(MetaDataPaths)) {
      data.table::fwrite(EvaluationMetrics, file = file.path(normalizePath(MetaDataPaths), paste0(ModelID, "_EvaluationMetrics.csv")))
    } else {
      data.table::fwrite(EvaluationMetrics, file = file.path(normalizePath(Paths), paste0(ModelID, "_EvaluationMetrics.csv")))
    }
  }
  
  # Regression Partial Dependence----
  ParDepPlots <- list()
  j <- 0L
  ParDepBoxPlots <- list()
  k <- 0L
  for(i in seq_len(min(length(FeatureColNames), NumOfParDepPlots, VariableImportance[,.N]))) {
    tryCatch({
      Out <- ParDepCalPlots(
        data = TestData,
        PredictionColName = "UpdatedPrediction",
        TargetColName = eval(TargetColumnName),
        IndepVar = VariableImportance[i, Variable],
        GraphType = "calibration",
        PercentileBucket = 0.05,
        FactLevels = 10L,
        Function = function(x) mean(x, na.rm = TRUE))
      j <- j + 1L
      ParDepPlots[[paste0(VariableImportance[j, Variable])]] <- Out
    }, error = function(x) "skip")
    tryCatch({
      Out1 <- ParDepCalPlots(
        data = TestData,
        PredictionColName = "UpdatedPrediction",
        TargetColName = eval(TargetColumnName),
        IndepVar = VariableImportance[i, Variable],
        GraphType = "boxplot",
        PercentileBucket = 0.05,
        FactLevels = 10,
        Function = function(x) mean(x, na.rm = TRUE))
      k <- k + 1L
      ParDepBoxPlots[[paste0(VariableImportance[k, Variable])]] <- Out1
    }, error = function(x) "skip")
  }
  
  # Regression Save ParDepBoxPlots to file----
  if(SaveModelObjects) {
    if(!is.null(MetaDataPaths)) {
      save(ParDepBoxPlots, file = file.path(normalizePath(MetaDataPaths), paste0(ModelID, "_ParDepBoxPlots.R")))
    } else {
      save(ParDepBoxPlots, file = file.path(normalizePath(Paths), paste0(ModelID, "_ParDepBoxPlots.R")))
    }
  }
  
  # Save args list to file----
  if(SaveModelObjects) save(ArgsList, file = file.path(normalizePath(Paths), paste0(ModelID, "_HurdleArgList.Rdata")))
  
  # Return Output----
  return(list(
    ArgsList = ArgsList,
    ModelList = ModelList,
    ClassificationMetrics = ClassEvaluationMetrics,
    FinalTestData = TestData,
    EvaluationPlot = EvaluationPlot,
    EvaluationBoxPlot = EvaluationBoxPlot,
    EvaluationMetrics = EvaluationMetrics,
    PartialDependencePlots = ParDepPlots,
    PartialDependenceBoxPlots = ParDepBoxPlots))
}
