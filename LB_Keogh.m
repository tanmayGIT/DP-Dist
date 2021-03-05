function LB_Keogh(Q,prunnedtargetFeatures,rad)
best_so_far = Inf;
for i = 1:1:length(prunnedtargetFeatures)
    Ci = prunnedtargetFeatures{i,1}; % getting each sequence
    LB_dist = lowerBoundingMeasure(Q,rad,Ci);% finding the quick distance between query and the particular sequence 
    if (LB_dist < best_so_far) % if it is less than the best then calculate dtw dist
        true_dist = DTW(Ci,Q); %
        if (true_dist < best_so_far)
            best_so_far = true_dist;
            index_of_best_match = i;
        end
    end
end
end
function totDist = lowerBoundingMeasure(queryseries, rad,targetSeries)
[nRw,~] = size(queryseries);
U = Inf(size(queryseries));
L = Inf(size(queryseries));
for ii = 1:1:nRw % number of rows i.e. length of the time series i.e. number of columns present in the image
    if(ii < rad) % for the initial portion
        U(ii,:) = max(queryseries(1:(ii+rad),:));
        L(ii,:) = min(queryseries(1:(ii+rad),:));
    elseif(ii > (nRw -rad))
        U(ii,:) = max(queryseries((ii-rad):nRw,:));
        L(ii,:) = min(queryseries(1:(ii+rad),:));
    else
        U(ii,:) = max(queryseries((ii-rad):(ii+rad),:));
        L(ii,:) = min(queryseries(1:(ii+rad),:));
    end
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