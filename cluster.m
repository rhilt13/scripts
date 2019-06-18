%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% Reading in the data tables
%% Read in a correlation matrix
T = readtable('p.txt');
%%
A = table2array(T);
%% Read in a table of features
% T=readtable('GT_Mechanism_Feature_NoNA.csv');
% T=readtable('GTA_Mechanism_FullSeq_Features_NoNA.csv');
T=readtable('features_gt6.csv');
%%
T1=T;
T1.GTFam=[];
T1.Mechanism=[];
T1.OmcSet=[];
T1.SeqID=[];
T1.Phylum=[];
T1.Kingdom=[];
A=table2array(T1);
GroupID=ones(length(T.Mechanism),1);
%%
for k=1:length(T.Mechanism)
    if strcmp(T.Mechanism{k},'Inverting')
        GroupID(k)=2;
    end
end

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% Correlation
%%
[R,P]=corrcoef(A);
R(R==1)=0;
Rlim=0.1;
Head=T1.Properties.VariableNames;
%%
fid = fopen('columns_pos');
Names = textscan(fid,'%s');
fclose(fid);
Names=Names{1,1};
%%
Vals=R(R>Rlim);
[RowNrs,ColNrs] = find(R>Rlim);
%%
Sel=cell(numel(1,5));
for idx = 1:numel(RowNrs)
    s1 = Names(RowNrs(idx));
    s2 = Names(ColNrs(idx));
    if strcmp(s1,s2)
        continue
    else    
        Sel{end+1,1} = RowNrs(idx);
        Sel{end,2} = s1;
        Sel{end,3} = ColNrs(idx);
        Sel{end,4} = s2;
        Sel{end,5} = Vals(idx);
    end
end
Sel=Sel(2:end,1:5);

% Sorting numerically
% Extract column 5 and convert to doubles.
col5 = str2double(Sel(:,5));
% Sort numerically.
[sortedValues, sortOrder] = sort(col5);
% Apply the sort order to the original cell array, creating a new cell array, ca2.
Sel2 = Sel(sortOrder, :);
%%
size(Sel2,1)
%%
writetable(cell2table(Sel2),'features_corr.txt');
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% Clustering
%%
Z = linkage(A,'average','chebychev');
%%
C = cluster(Z,'maxclust',20);
%%
cutoff = median([Z(end-2,3) Z(end-1,3)]);
dendrogram(Z,'ColorThreshold',cutoff)

%%
[~,n]=size(A);
Cols=[1:1:n];
%%
%%%%%%%%%%
%%%%% Normalize
normcheck(A);
%%
AN=normalize(A,Cols,'PQN');
%%
normcheck(AN);
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% PCA analysis 
%%
PCA=nipalsPCA(AN,5);
%% This command makes the scores plot. 
% Change the dimensions to see the PCA components of interest. 3 numbers
% (e.g. [1 2 3]) will make a 3D plot. 2 numbers will make an x-y plot.
%
figure;
hold
VisScores(AN,PCA,[1 2],'Y',GroupID,'conf_ellipse',true);
%
%% Loadings plots: PC-1
% These show what data cause the separation along a particular PCA
% component. Notice that the data are aligned and normalized but not
% scaled. The scaling makes the loadings plots difficult to interpret.
%
VisLoadings1D(A,PCA.loadings(1,:),Cols)
%
%% PC-2
%
VisLoadings1D(XALN,PCA.loadings(2,:),Cols)
%
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% PLS-DA analysis
%% PLS-DA UNDER CONSTRUCTION.
% 7 is for 7 fold cross validation,10 is the  number of permutations to test cross-validation
PLS=plsCV(GroupID,A,7,'da',10)

%% 
VisScoresLabel(A,PLS,[1 2],GroupID);
%%
VisLoadings1D(A,PLS.loadings(1,:),Cols)
%%
VisLoadings1D(A,PLS.loadings(2,:),Cols)