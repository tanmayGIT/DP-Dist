function [sortedDist,rigtIndexes] = LB_Keogh_KNN_v1(Q,prunnedtargetFeatures,rad,K)
% calculating the LB at the beginning
bestElementsArr = Inf(1,2);
tic;
storeLBAll = Inf(1,1);
for i = 1:1:length(prunnedtargetFeatures)
    Ci = prunnedtargetFeatures{i,1}; % getting each sequence
    LB_dist = lowerBoundingMeasure(Q,rad,Ci);
    storeLBAll(i,1) = LB_dist;
end
[sortedVal,indexSort] = sort(storeLBAll);
bestElementsArr(1:K,1) = sortedVal(1:K,1);
bestElementsArr(1:K,2) = indexSort(1:K,1);
[worst_so_far,index_of_worst_match] = max(bestElementsArr(:,1));

for i = k+1:1:length(indexSort)
    LB_dist = sortedVal(i,1);
    Ci = prunnedtargetFeatures{indexSort(i,1),1}; % getting each sequence
    if (LB_dist < worst_so_far) % if it is less than the best then calculate dtw dist
        [true_dist,~,~] = DynamicTimeWarping(Q,Ci,1);
        if (true_dist < worst_so_far)
            bestElementsArr(index_of_worst_match,1) = true_dist;
            bestElementsArr(index_of_worst_match,2) = indexSort(i,1);
            [worst_so_far,index_of_worst_match] = max(bestElementsArr(:,1)); % the worst distance untill now, and should be removed
        end
    end
end
[sortedDist,IndexSorted] = sort(bestElementsArr(:,1));
rigtIndexes = bestElementsArr(IndexSorted,2);
toc;
end
function totDist = lowerBoundingMeasure(queryseries, rad,targetSeries)
[nRw,~] = size(queryseries);
U = Inf(size(queryseries));
L = Inf(size(queryseries));
for ii = 1:1:nRw % number of rows i.e. length of the time series i.e. number of columns present in the image
    U(ii,:) = max(queryseries(   (  max  (1,   (ii-rad)  )  ) :  ( min  (nRw,  (ii+rad) )),:  ));
    L(ii,:) = min(queryseries(   (  max  (1,   (ii-rad)  )  ) :  ( min  (nRw,  (ii+rad) )),:  ));
end
totDist = calculate_LB_KeoghDistSame(U,L,targetSeries);
return;
end
function totDist = calculate_LB_KeoghDistSame(U,L,targetSeries)
% in this function, we consider that the length of the query and target sequnce are same
% it is assumed that the length of U,L,targetSeries are same
totDist = 0;
for ii = 1:1:size(U,1)
    tempDist = 0;
    for pp = 1:1:size(U,2)
        if(targetSeries(ii,pp) > U(ii,pp))
            dist = (targetSeries(ii,pp) - U(ii,pp))^2;
            tempDist = tempDist + dist;
        elseif(targetSeries(ii,pp) < L(ii,pp))
            dist = (targetSeries(ii,pp) - L(ii,pp))^2;
            tempDist = tempDist + dist;
        else
            dist = 0;
            tempDist = tempDist + dist;
        end
    end
    totDist = totDist + tempDist;
end
totDist = totDist /size(U,1);
return;
end
% function calculate_LB_KeoghDist(U,L,targetSeries)
% applying the sub-sequence matching approach
% for cw = 1:avgCharWidth:(noOfSamplesInTestSample)% running for finding out the corresponding window
%     if((cw+noOfSamplesInRefSample-1) < noOfSamplesInTestSample)
%         DistNeed = Dist(:,cw:(cw+noOfSamplesInRefSample-1));
%         [DistanceVal,indxCol,indxRw] = Chota_DTW(DistNeed);
%
%         if(DistanceVal <= optimumDist)
%             ultiRw = indxRw;
%             ultiCol = indxCol;
%             optimumDist = DistanceVal;
%         end
%     end
% end
% if((cw+noOfSamplesInRefSample-1) ~= noOfSamplesInTestSample)% means in the previous for loop we have not considered upto last block and still some column remains
%     DistNeed = Dist(:,(noOfSamplesInTestSample -(noOfSamplesInRefSample-1) ):noOfSamplesInTestSample);
%     [DistanceVal,indxCol,indxRw] = Chota_DTW(DistNeed);
%     if(DistanceVal <= optimumDist)
%         ultiRw = indxRw;
%         ultiCol = indxCol;
%         optimumDist = DistanceVal;
%     end
% end
% end