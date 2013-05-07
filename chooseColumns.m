function chosenColumns = chooseColumns(data)

    % 1) we find the PCA from data
    [pc,score,latent] = princomp(data);

    % Choose the number of principal components and number of columns in
    % the component to use
    %--> find principal components that explain 90% of data
    threshold=0.75;
    contrib=cumsum(latent)/sum(latent);
    topNPrincipalComp=find(contrib<0.9,1,'last');
    topNColumns=10;

    
    % 2) Find the topNColumns from the topNPrincipalComp 
    chosenColumns=zeros(topNPrincipalComp,topNColumns);
    for i=1:topNPrincipalComp
        [sortedValues,sortIndex] = sort(pc(:,i),'descend');
        chosenColumns(i,:)=sortIndex(1:topNColumns,1)';
    end

    %3 Remove Repeated
    chosenColumns=reshape(chosenColumns,1,topNPrincipalComp*topNColumns);
    chosenColumns=unique(chosenColumns);
end