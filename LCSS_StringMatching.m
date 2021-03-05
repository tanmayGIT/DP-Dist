function [DistanceVal,indxCol,indxRw] = LCSS_StringMatching(refSample,testSample)

refMean = sum(refSample,1) ./ sum(refSample~=0,1);
targetMean = sum(testSample,1) ./ sum(testSample~=0,1);

 
epsilon = min(refDif,targetDif);

[noOfSamplesInRefSample,~] = size(refSample);
[noOfSamplesInTestSample,~] = size(testSample);
Dist = zeros(noOfSamplesInRefSample,noOfSamplesInTestSample);


delta = abs(noOfSamplesInTestSample - noOfSamplesInRefSample);

L = zeros(noOfSamplesInRefSample+1,noOfSamplesInTestSample+1);
L(1,:) = 0;
L(:,1) = 0;
b = zeros(noOfSamplesInRefSample+1,noOfSamplesInTestSample+1);
b(:,1) = 1;%%% Up
b(1,:) = 2;%%% Left

if(N == M)
    for i = 2:noOfSamplesInRefSample+1
        for j = 2:noOfSamplesInTestSample+1
            if ( ( Dist(i-1,j-1) < epsilon) && (abs(j-i) < delta) )
                L(i,j) = L(i-1,j-1) + 1;
                b(i,j) = 3;%%% Up and left
            else
                L(i,j) = L(i-1,j-1);
            end
            if(L(i-1,j) >= L(i,j))
                L(i,j) = L(i-1,j);
                b(i,j) = 1;%Up
            end
            if(L(i,j-1) >= L(i,j))
                L(i,j) = L(i,j-1);
                b(i,j) = 2;%Left
            end
        end
    end
    % removing the first col, first row, last col, last row
    L(:,1) = [];
    L(1,:) = [];
    b(:,1) = [];
    b(1,:) = [];
    dist = L(noOfSamplesInRefSample,noOfSamplesInTestSample);
    
    DistanceVal = (dist / min(noOfSamplesInTestSample,noOfSamplesInRefSample));
    %     if(dist == 0)
    %         aLongestString = '';
    %     else
    %%%now backtrack to find the longest subsequence
    i = noOfSamplesInRefSample;
    j = noOfSamplesInTestSample;
    Wrapped(1,:)=[i,j];
    p = dist;
    aLongestString = {};
    while(i>1 && j>1)
        if(b(i,j) == 3)
            aLongestString{p} = refSample(i);
            p = p-1;
            i = i-1;
            j = j-1;
        elseif(b(i,j) == 1)
            i = i-1;
        elseif(b(i,j) == 2)
            j = j-1;
        end
        Wrapped = cat(1,Wrapped,[i,j]);
    end
    indxRw =  Wrapped(:,1);%1:(size(refSample,1));
    %  indxRw = indxRw';
    indxCol = Wrapped(:,2);%1:(size(testSample,1));
    %  indxCol = indxCol';
    %         if ischar(aLongestString{1})
    %             aLongestString = char(aLongestString)';
    %         else
    %             aLongestString = cell2mat(aLongestString);
    %         end
    %     end
    
end
end
