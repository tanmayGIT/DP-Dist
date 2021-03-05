function [DistanceVal,indxCol,indxRw] = SparseDTW(Data_Ref,Data_Target,Res)
quantizedData_Ref = quantizeSequence(Data_Ref);
quantizedData_Target = quantizeSequence(Data_Target);

[noOfSamplesInRefSample,N] = size(quantizedData_Ref);
[noOfSamplesInTestSample,M] = size(quantizedData_Target);
SMTemp = zeros(noOfSamplesInTestSample,noOfSamplesInRefSample);
% SMLinerIndex = Inf(noOfSamplesInTestSample,noOfSamplesInRefSample);

% % putting the linear indexes
% cntMe = 1;
% for ji = 1:1:size(SMTemp,2)
%     for ui = 1:1:size(SMTemp,1)
%         SMLinerIndex(ui,ji) = cntMe;
%         cntMe = cntMe + 1;
%     end
% end

LowerBound = 0;
UpperBound = Res;
% please note that here that both the signal quantizedData_Ref and
% quantizedData_Target have the same numbers of columns but different numbers of rows
if(N == M)
    for jj = 1:1:N
        while ( (LowerBound >= 0) && (LowerBound <= (1-(Res/2))) )
            % apply intersection of find operation here
            IdxS = findMyIndexes(quantizedData_Target(:,jj),LowerBound, UpperBound);
            IdxQ = findMyIndexes(quantizedData_Ref(:,jj),LowerBound, UpperBound);
            LowerBound = LowerBound + (Res/2);
            UpperBound = LowerBound + Res;
            for id1 = 1:1:length(IdxS)
                for id2 = 1:1:length(IdxQ)
                    dis =  (( Data_Target(IdxS(id1),jj) - Data_Ref(IdxQ(id2),jj) ) ^2);  % ******
                    SMTemp(IdxS(id1),IdxQ(id2)) = dis;
                    if(dis == 0)
                        SMTemp(IdxS(id1),IdxQ(id2)) = -1;
                    end
                end
            end
        end
    end
    for ii = 1:1:size(SMTemp,1)
        for jj = 1:1:size(SMTemp,2)       
            if((ii == 1) && (jj>1))
                if(SMTemp(ii,jj-1) ~= 0) % not a blocked cell
                    SMTemp(ii,jj) = SMTemp(ii,jj) + SMTemp(ii,jj-1);
                end
            end
            if((jj == 1)&& (ii>1) )
                if(SMTemp(ii-1,jj) ~= 0) % not a blocked cell
                    SMTemp(ii,jj) = SMTemp(ii,jj) + SMTemp(ii-1,jj);
                end
            end
            
            if((ii > 1) && (jj >1) )
                cntgo = 1;
                if(SMTemp(ii,jj-1) ~= 0)
                    minarr(cntgo,1) = SMTemp(ii,jj-1);
                    cntgo = cntgo +1;
                end
                if(SMTemp(ii-1,jj) ~= 0)
                    minarr(cntgo,1) = SMTemp(ii-1,jj);
                    cntgo = cntgo +1;
                end
                if(SMTemp(ii-1,jj-1) ~= 0)
                    minarr(cntgo,1) = SMTemp(ii-1,jj-1);
                    cntgo = cntgo +1;
                end
                if(exist('minarr','var')) % if minarr exists
                    if(min(minarr) == -1)
                        SMTemp(ii,jj) = SMTemp(ii,jj) + 0; % just to maintain the given psedo code in the paper
                    else
                        SMTemp(ii,jj) = SMTemp(ii,jj) + min(minarr);
                    end
                end
            end
            if ( (ii < size(SMTemp,1)) && (jj < size(SMTemp,2)) )
                % upper neighbors
                if(SMTemp(ii,jj+1) == 0)
                    SMTemp(ii,jj+1) = sum((Data_Target(ii,:) - Data_Ref(jj+1,:))^2); % *****
                end
                if(SMTemp(ii+1,jj) == 0)
                    SMTemp(ii+1,jj) = sum((Data_Target(ii+1,:) - Data_Ref(jj,:))^2); % *****
                end
                if(SMTemp(ii+1,jj+1) == 0)
                    SMTemp(ii+1,jj+1) = sum((Data_Target(ii+1,:) - Data_Ref(jj+1,:))^2); % *****
                end
            end
            if ( (ii == size(SMTemp,1)) && (jj ~= size(SMTemp,2)) )
                % upper neighbors
                if(SMTemp(ii,jj+1) == 0)
                    SMTemp(ii,jj+1) = sum((Data_Target(ii,:) - Data_Ref(jj+1,:))^2); % *****
                end
            end
            if ( (ii ~= size(SMTemp,1)) && (jj == size(SMTemp,2)) )
                % upper neighbors
                if(SMTemp(ii+1,jj) == 0)
                    SMTemp(ii+1,jj) = sum((Data_Target(ii+1,:) - Data_Ref(jj,:))^2); % *****
                end
            end
        end
    end
    X = noOfSamplesInTestSample;
    Y = noOfSamplesInRefSample;
    k=1;
    Wrapped(1,:)=[X,Y];
    while ((X>1)||(Y>1))
        if ((X-1)==0)
            Y = Y-1;
        elseif ((Y-1)==0)
            X = X-1;
        else
            vect = [SMTemp(X-1,Y-1),SMTemp(X,Y-1),SMTemp(X-1,Y)];
            [minVal,place] = min(vect);
            errorCnt = 0;
            while (minVal == 0)
                vect(place) = Inf;
                [minVal,place] = min(vect);
                errorCnt = errorCnt +1;
            end
            if(errorCnt == 2)
                error('you have problem with block cells')
            end
            switch place
                case 1
                    X = X-1;
                    Y = Y-1;
                case 2
                    Y = Y-1;
                case 3
                    X = X-1;
            end
        end
        k=k+1;
        Wrapped = cat(1,[X,Y],Wrapped);
    end
    indxRw =  Wrapped(:,1);
    indxCol = Wrapped(:,2);
    DistanceVal = (SMTemp(noOfSamplesInTestSample,noOfSamplesInRefSample))/ k ;
    
    
else
    error('There is some problem of dimensions, please see the vector diemension')
end
end
function doDivideConquer(Data_Ref,Data_Target)
global distMat;
distMat = Inf(size(Data_Target,1),size(Data_Ref,1));
quantizedData_Ref = changeIntoStructure(Data_Ref);
quantizedData_Target = changeIntoStructure(Data_Target);

DivideConquerAlignment(quantizedData_Ref,quantizedData_Target);
end
function DivideConquerAlignment(Data_Ref,Data_Target)
[Target_Row, Target_col] = size(Data_Target);
[Ref_Row, Ref_col] = size(Data_Ref);
Mid = round(Ref_Row/2);

if( (Ref_Row < 2) || (Target_Row < 2) )
    [DistanceDTW,~,~] = DynamicTimeWarpingStructured(Data_Ref,Data_Target,1);
else
    Data_RefTemp_1 = cell(1,1);
    for ih = 1:1:Mid
        for jh = 1:1:Ref_col
            Data_RefTemp_1{ih,jh} = Data_Ref{ih,jh};
        end
    end
    f = SpaceEfficientAlign(Data_RefTemp_1,Data_Target); % putting the first part of the reference signal
    Data_RefTemp_2 = cell(1,1);
    suck = 1;
    for ih = Mid:1:Ref_Row
        for jh = 1:1:Ref_col
            Data_RefTemp_2{suck,jh} = Data_Ref{ih,jh};
        end
        suck = suck +1;
    end
    g = SpaceEfficientAlign(Data_RefTemp,Data_Target); % see the different inputs; putting the last part of the reference signal
    summedDistMat = f(:,end) + g(:,1);
    [~,indx] = min(summedDistMat);
    
    Data_TargetTemp_1 = cell(1,1);
    for ih = 1:1:indx
        for jh = 1:1:Target_col
            Data_TargetTemp_1{ih,jh} = Data_Target{ih,jh};
        end
    end
    fuck = 1;
    Data_TargetTemp_2 = cell(1,1);
    for ih = indx:1:Target_Row
        for jh = 1:1:Target_col
            Data_TargetTemp_2{fuck,jh} = Data_Target{ih,jh};
        end
        fuck = fuck +1 ;
    end
    DivideConquerAlignment(Data_RefTemp_1,Data_TargetTemp_1);
    DivideConquerAlignment(Data_RefTemp_2,Data_TargetTemp_2);
    %     colIndex =
end
end
function Dist = SpaceEfficientAlign(refSample,testSample)
[noOfSamplesInRefSample,N]=size(refSample);
[noOfSamplesInTestSample,M]=size(testSample);
Dist = Inf(noOfSamplesInTestSample,noOfSamplesInRefSample); % Initializing the array
for i=1:noOfSamplesInTestSample% xSize
    for j=1:noOfSamplesInRefSample %ySize
        total = zeros(N,1);
        for goFeature=1:N %or M as N & M are same
            total(goFeature,1) = (double((testSample{i,goFeature}.val - refSample{j,goFeature}.val)^2));
        end
        Dist(i,j) =  sqrt(sum(total));
    end
end
end
function structMat = changeIntoStructure(mat)
structMat = cell(size(mat));
for ii = 1:1:size(mat,1)
    for jj = 1:1:size(mat,2)
        structMat{ii,jj}.val = mat(ii,jj);
        structMat{ii,jj}.index = ii;
    end
end
return;
end
function normSeq = quantizeSequence(seq)
normSeq = Inf(size(seq));
for jj = 1:1:size(seq,2)
    normSeq (:,jj) = (seq(:,jj) - min(seq(:,jj))) / (  max(seq(:,jj)) - min(seq(:,jj))  );
end
return
end
function indx = findMyIndexes(arr,LB, UB)
indx = Inf(1,1);
cnt = 1;
for ui = 1:1:length(arr)
    if( (LB <= arr(ui)) && (arr(ui) <= UB) )
        indx(cnt,1) = ui;
        cnt = cnt +1;
    end
end
return;
end
function [DistanceVal,indxCol,indxRw] = DynamicTimeWarpingStructured(refSample,testSample)
[noOfSamplesInRefSample,N]=size(refSample);
[noOfSamplesInTestSample,M]=size(testSample);

if(N == M) % each set containing same no. of feature
    
    Dist = zeros(noOfSamplesInTestSample,noOfSamplesInRefSample); % Initializing the array
    for i = 1:noOfSamplesInTestSample % xSize
        for j = 1:noOfSamplesInRefSample % ySize
            total = zeros(N,1);
            for goFeature = 1:N %or M as N & M are same
                total(goFeature,1) = (double(( testSample{i,goFeature}.val - refSample{j,goFeature}.val)^2));
            end
            Dist(i,j) =  sqrt(sum(total));
        end
    end
    
    D = Inf(size(Dist));
    D(1,1) = Dist(1,1);
    
    for n = 2:noOfSamplesInTestSample
        D(n,1) = Dist(n,1)+D(n-1,1);
    end
    for m = 2:noOfSamplesInRefSample
        D(1,m) = Dist(1,m)+D(1,m-1);
    end
    for n = 2:noOfSamplesInTestSample
        for m = 2:noOfSamplesInRefSample
            D(n,m) = Dist(n,m)+min([D(n-1,m-1),D(n,m-1),D(n-1,m)]); % Thanks for the suggestion by "Sven Mensing" in Matlab Central
        end
    end
    
    X = noOfSamplesInTestSample;
    Y = noOfSamplesInRefSample;
    k=1;
    Wrapped(1,:)=[X,Y];
    while ((X>1)||(Y>1))
        if ((X-1)==0)
            Y = Y-1;
        elseif ((Y-1)==0)
            X = X-1;
        else
            [~,place] = min([D(X-1,Y-1),D(X,Y-1),D(X-1,Y)]);
            switch place
                case 1
                    X = X-1;
                    Y = Y-1;
                case 2
                    Y = Y-1;
                case 3
                    X = X-1;
            end
        end
        k=k+1; % The number of steps it took to come to the place [1,1]
        Wrapped = cat(1,[X,Y],Wrapped);
    end
    indxRw =  Wrapped(:,1);
    indxCol = Wrapped(:,2);
    DistanceVal = (D(noOfSamplesInTestSample,noOfSamplesInRefSample))/ k ;
else
    return;
end
end
