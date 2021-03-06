function[ACC,LABEL,C] = SLEP_sgLeastR_SparseClassify_Multime_Evan(Train_data,Train_label,Test_data,Test_label,lambda)

Train_data = double(Train_data);
Test_data = double(Test_data);

N1 = length(find(Train_label==1));
N2 = length(Train_label);
ind = [0,N1,N2];
q = 2;
k = length(ind)-1;

D = Train_data;
C = zeros(size(Train_data,2),size(Test_data,2));

% %----------------------- Set optional items -----------------------
opts = [];
% % Starting point
opts.init=2;        % starting from a zero point
% 
% % Termination 
opts.tFlag=5;       % run till abs( funVal(i)- funVal(i-1) ) �� .tol.
opts.tol = 1E-4;
opts.maxIter=1000;   % maximum number of iterations
% % regularization
opts.rFlag = 0;       % use the input lambda
% % Normalization
opts.nFlag=0;       % without normalization
% 
% Group Property
%  The group information is contained in
%  opts.ind, which is a 3 x nodes matrix, where nodes denotes the number of
%  nodes of the tree.
%  opts.ind(1,:) contains the starting index
%  opts.ind(2,:) contains the ending index
%  opts.ind(3,:) contains the corresponding weight (w_j)
opts.ind=[ [1, N1, 1]', [N1+1, N2, 0.85]'];

% opts.ind =ind;       % set the group indices
% opts.q=q;              % set the value for q
% % opts.sWeight=[1,1]; % set the weight for positive and negative samples
% opts.gWeight=[0.85;1] ;% set the weight for the group, a cloumn vector

% opts.G = [1:1:size(Train_dat,2)];

for i = 1:length(Test_label)
    [C(:,i), funVal, ValueL]=sgLeastR(D, Test_data(:,i), lambda, opts);
end

label = zeros(1,length(Test_label)/5);
Lt1 = (Train_label+1)/2;
Lt2 = (-(Train_label-1))/2;
    
for i = 1:length(Test_label)/5
    DIf1 = (norm((Test_data(:,5*(i-1)+1)-D*(C(:,5*(i-1)+1).*Lt1')),2))^2;
    DIf2 = (norm((Test_data(:,5*(i-1)+2)-D*(C(:,5*(i-1)+2).*Lt1')),2))^2;
    DIf3 = (norm((Test_data(:,5*(i-1)+3)-D*(C(:,5*(i-1)+3).*Lt1')),2))^2;
    DIf4 = (norm((Test_data(:,5*(i-1)+4)-D*(C(:,5*(i-1)+4).*Lt1')),2))^2;
    DIf5 = (norm((Test_data(:,5*(i-1)+5)-D*(C(:,5*(i-1)+5).*Lt1')),2))^2;
    
    DIf6 = (norm((Test_data(:,5*(i-1)+1)-D*(C(:,5*(i-1)+1).*Lt2')),2))^2;
    DIf7 = (norm((Test_data(:,5*(i-1)+2)-D*(C(:,5*(i-1)+2).*Lt2')),2))^2;
    DIf8 = (norm((Test_data(:,5*(i-1)+3)-D*(C(:,5*(i-1)+3).*Lt2')),2))^2;
    DIf9 = (norm((Test_data(:,5*(i-1)+4)-D*(C(:,5*(i-1)+4).*Lt2')),2))^2;
    DIf10 = (norm((Test_data(:,5*(i-1)+5)-D*(C(:,5*(i-1)+5).*Lt2')),2))^2;
       
            if DIf1+DIf2+DIf3+DIf4+DIf5<DIf6+DIf7+DIf8+DIf9+DIf10
                label(i) = 1;
            else
                label(i) = -1;
            end         
end

LABEL = label;
ACC = (length(find((LABEL - Test_label(1:5:size(Test_label,2)) == 0))))/length(Test_label(1:5:size(Test_label,2)));

