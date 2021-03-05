function UCR_time_series_test %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% (C) Eamonn Keogh %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear;
clc;
close all;
addpath('dst_idst/') 
dataFolderPath = 'UCR_TS_Archive_2015/';
resultSavingPath = 'Result_UCR/';
% allAlgoLists = {'MVM','LDTW_Itekura','LDTW', 'CDP2','DTW','DDTW','Value_Derivative','Weighted_Hybrid_DTW','Itekura',...
%                             'Sin_Transform','Cos_Transform','Hilbert_Transform','Euclidean'};

allAlgoLists = {'Cos_Transform'};
dirData = dir(dataFolderPath);      %# Get the data for the current directory
dirIndex = [dirData.isdir];  %# Find the index for directories
fileList = {dirData(~dirIndex).name}';  %'# Get a list of the files
if ~isempty(fileList)
    fileList = cellfun(@(x) fullfile(dataFolderPath,x),...  %# Prepend path to files
        fileList,'UniformOutput',false);
end
subDirs = {dirData(dirIndex).name};  %# Get a list of the subdirectories
validIndex = ~ismember(subDirs,{'.','..'});  %# Find index of subdirectories
%#   that are not '.' or '..'
validIndex(1,18:32) = 1;
validIndex(1,1:18) = 0;
validIndex(1,32:end) = 0;
for iDir = find(validIndex)                  %# Loop over valid subdirectories
    nextDir = fullfile(dataFolderPath,subDirs{iDir});    %# Get the subdirectory path
    resultFolder = fullfile(resultSavingPath,subDirs{iDir});
    if (~exist(resultFolder, 'dir')) % If the folder does not exist then create folder
       mkdir(resultFolder)
    end

    
    % The idea is apply all the algos for each dataset. Then in the
    % "Result" folder, we will create sub-folders by the name of the
    % algorithms and then saving .mat file for al the algos inside it.
    
    getAllFiles = dir(nextDir);
    %     for k = 1:1:size(getAllFiles,1)
    %         validFileIndex = ~ismember(getAllFiles(k,1).name,{'.','..'});
    %         if(validFileIndex)
    %             filePathComplete = fullfile(nextDir,getAllFiles(k,1).name);
    %             % fprintf('The Complete File Path: %s\n', filePathComplete);
    %         end
    %     end
    testFileName = strcat(subDirs{iDir},'_TEST');
    trainFileName = strcat(subDirs{iDir},'_TRAIN');
    testPathComplete = fullfile(nextDir,testFileName);
    trainPathComplete = fullfile(nextDir,trainFileName);
    storeAllAlgosResult = [];
    if (exist(testPathComplete, 'file') && exist(trainPathComplete, 'file'))
        % Run through all the algos 
        for algo = 1:1:length(allAlgoLists)
            algoNm = allAlgoLists{1,algo};
            [keepAllInfo,errorRate,returnArg1,returnArg2_1,returnArg2_2,returnArg3] = ...
                                    LoadUCRData(trainPathComplete, testPathComplete,algoNm);
            storeAllAlgosResult(algo).Algo_Name = algoNm;
            storeAllAlgosResult(algo).Result = keepAllInfo;
            storeAllAlgosResult(algo).ErrorRate = errorRate;
        end
    else
        error('we are not happy becuase the training or testing file does not exist in the directory');
    end
    fileNam = strcat(subDirs{iDir},'.mat');
    completeFilePath = fullfile(resultFolder,fileNam);
    save(completeFilePath, 'storeAllAlgosResult');
    
    % Need to send email when we complete all the algos for each dataset 
    msg0 = ['The dataset name is: ', subDirs{iDir}];
    msg1 = ['The dataset you tested has ', returnArg1, ' classes'];
    msg2 = ['The training set is of size ', returnArg2_1,', and the test set is of size ',returnArg2_2,'.'];
    msg3 = ['The time series are of length ', returnArg3];
    
    fullMsg = {msg0, msg1, msg2, msg3};
    tk = 4;
    for algoErr = 1:1:length(storeAllAlgosResult)
%         strMsg = strcat(msg,num2str(algoErr));
        strMsg = ['The error rate of algo ', storeAllAlgosResult(algoErr).Algo_Name, ...
                        ' was ', num2str(storeAllAlgosResult(algoErr).ErrorRate)];
        fullMsg{1,tk} = strMsg;
        tk = tk + 1;
    end
%     msg4 = ['The error rate was ',returnArg4];
   
    e_mail('tanmoy.besu@gmail.com', 'gmail', 'tanmoy.besu', '24010039ranada',...
                            'The Results of UCR Dataset', fullMsg);
end
end


function [keepAllInfo,errorRate,returnArg1,returnArg2_1,returnArg2_2,returnArg3] = LoadUCRData(trainData, testData,algoNm)

TRAIN = load(trainData); % Only these two lines need to be changed to test a different dataset %
TEST  = load(testData); % Only these two lines need to be changed to test a different dataset %


TRAIN_class_labels = TRAIN(:,1);    % Pull out the class labels.
TRAIN(:,1) = [];                    % Remove class labels from training set.
TEST_class_labels = TEST(:,1);      % Pull out the class labels.
TEST(:,1) = [];                     % Remove class labels from testing set.
correct = 0; % Initialize the number we got correct

keepAllInfo(length(TEST_class_labels)).Test_Item_No = length(TEST_class_labels); % just to initialize the size otherwise it was giving warning
for i = 1 :1 % length(TEST_class_labels) % Loop over every instance in the test set ************** Change here
    classify_this_object = TEST(i,:);
    this_objects_actual_class = TEST_class_labels(i);
    [distAgainstAllTrainigData,predicted_class] = Classification_Algorithm(TRAIN,TRAIN_class_labels, classify_this_object,algoNm);
   
    keepAllInfo(i).Test_Item_No = i;
    keepAllInfo(i).Test_Item_Actual_Class = this_objects_actual_class;
    keepAllInfo(i).Test_Item_Predicted_Class = predicted_class;
    keepAllInfo(i).Dist_Against_All_Training_Data = distAgainstAllTrainigData;
    
    
    if predicted_class == this_objects_actual_class
        correct = correct + 1;
    end
%     disp([int2str(i), ' out of ', int2str(length(TEST_class_labels)), ' done']) % Report progress
end;
errorRate = ((length(TEST_class_labels)-correct )/length(TEST_class_labels));
%%%%%%%%%%%%%%%%% Create Report %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
returnArg1 = int2str(length(unique(TRAIN_class_labels)));
returnArg2_1 = int2str(size(TRAIN,1));
returnArg2_2 = int2str(size(TEST,1));
returnArg3 = int2str(size(TRAIN,2));
% returnArg4 = num2str((length(TEST_class_labels)-correct )/length(TEST_class_labels));
% disp(['The dataset you tested has ', int2str(length(unique(TRAIN_class_labels))), ' classes'])
% disp(['The training set is of size ', int2str(size(TRAIN,1)),', and the test set is of size ',int2str(size(TEST,1)),'.'])
% disp(['The time series are of length ', int2str(size(TRAIN,2))])
% disp(['The error rate was ',num2str((length(TEST_class_labels)-correct )/length(TEST_class_labels))])
return;
%%%%%%%%%%%%%%%%% End Report %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Here is a sample classification algorithm (Case: Otherwise), it is the simple (yet very competitive) one-nearest
% neighbor using the Euclidean distance.

% If you are advocating a new distance measure you just need to change the line marked "Euclidean distance"
% Some portion of this code is taken from : https://www.cs.ucr.edu/%7Eeamonn/time_series_data_2018/BriefingDocument2018.pdf
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [distKeepingArr,predicted_class] = Classification_Algorithm(TRAIN,TRAIN_class_labels,unknown_object,Technique)
best_so_far = inf;
distKeepingArr = Inf(length(TRAIN_class_labels),1);
for i = 1 : 1 % length(TRAIN_class_labels)  %  change here ***************
    compare_to_this_object = TRAIN(i,:);
    
    % compare_to_this_object  => testSample
    % unknown_object  => refSample
    switch Technique
        case 'DTW'  % Algo - 1
            [distance] = DynamicTimeWarping(unknown_object,compare_to_this_object);
        case 'DDTW'   % Algo - 2
            [distance] = Derivative_DynamicTimeWarping(unknown_object,compare_to_this_object);
        case 'Value_Derivative'   % Algo - 3
            [distance] = ValueDerivative_DTW(unknown_object,compare_to_this_object);
        case 'Weighted_Hybrid_DTW'   % Algo - 4
            [distance] = WeightedHybrid_DTW(unknown_object,compare_to_this_object);
        case 'Itekura'   % Algo - 5
            [distance] = DynamicTimeWarping_Itakura_Band(unknown_object,compare_to_this_object);
        case 'CDP2'   % Algo - 6
            [~,~,distance] = cdp_2(unknown_object,compare_to_this_object);
        case 'LDTW'   % Algo - 7
            [distance,~,~] = DynamicTimeWarping_VariousWarpingPath(unknown_object,compare_to_this_object,3,'LDTW');
        case 'LDTW_Itekura'   % Algo - 8
            [distance,~,~] = DynamicTimeWarping_VariousWarpingPath(unknown_object,compare_to_this_object,5,'LDTW');
            if(distVal == -5)
                [distance,~,~] = DynamicTimeWarping_VariousWarpingPath(unknown_object,compare_to_this_object,3,'LDTW');
            end
        case 'SSDTW'   % Algo - 9
            [distance,~,~] = subsequenceDynamicTimeWarping(unknown_object,compare_to_this_object);
        case 'Sin_Transform'   % Algo - 10
            [distance] = IsometricTransformDTW(unknown_object,compare_to_this_object,'sine');
        case 'Cos_Transform'   % Algo - 11
            [distance] = IsometricTransformDTW(unknown_object,compare_to_this_object,'cos');
        case 'Hilbert_Transform'   % Algo - 12
            [distance] = IsometricTransformDTW(unknown_object,compare_to_this_object,'hilbert');
        case 'MVM'   % Algo - 13
            [~,~,~,~,distance] = MinimalVarianceMatching(compare_to_this_object,unknown_object);
        otherwise
            distance = sqrt(sum((compare_to_this_object - unknown_object).^2)); % Euclidean distance
    end
    distKeepingArr(i,1) = distance;
    if distance < best_so_far
        predicted_class = TRAIN_class_labels(i);
        best_so_far = distance;
    end
end
end

