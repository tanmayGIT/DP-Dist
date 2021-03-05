function [DistanceVal,indxCol,indxRw] = OnlineDTW(refSample,testSample,straight)
% not yet done, should be written again
[noOfSamplesInRefSample,N]=size(refSample);
[noOfSamplesInTestSample,M]=size(testSample);

if(N == M)
    Dist = zeros(noOfSamplesInRefSample,noOfSamplesInTestSample); % Initializing the array
    for i=1:noOfSamplesInRefSample % xSize
        for j=1:noOfSamplesInTestSample %ySize
            total = zeros(N,1);
            for goFeature=1:N %or M as N & M are same
                total(goFeature,1) = (double((refSample(i,goFeature)-testSample(j,goFeature))^2));
            end
            Dist(i,j) =  sqrt(sum(total));
        end
    end
    
    D=Inf(size(Dist));
    D(1,1)=Dist(1,1);
    
    for n=2:noOfSamplesInRefSample
        D(n,1)=Dist(n,1)+D(n-1,1);
    end
    for m=2:noOfSamplesInTestSample
        D(1,m)=Dist(1,m)+D(1,m-1);
    end
    for n=2:noOfSamplesInRefSample
        for m=2:noOfSamplesInTestSample
            D(n,m)=Dist(n,m)+min([D(n-1,m-1),D(n,m-1),D(n-1,m)]);
        end
    end
    
    X = noOfSamplesInRefSample;
    Y = noOfSamplesInTestSample;
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
    DistanceVal = (D(noOfSamplesInRefSample,noOfSamplesInTestSample))/ k ;
    
else
    return;
end
end
