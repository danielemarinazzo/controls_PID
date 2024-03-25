%% controller Z, X source, Y target

n = 1e4;
%% Model 1 - Good control
z = randn(n,1);
x = z + randn(n,1);
y = x + z + randn(n,1);
data_01=[x z y];

%% Model 2 - good control
j = randn(n,1);
z = j + randn(n,1);
x = z + randn(n,1);
y = x + j + randn(n,1);
data_02=[x z y];

%% Model 3 - good control
j = randn(n,1);
z = j + randn(n,1);
x = j + randn(n,1);
y = x + z + randn(n,1);
data_03=[x z y];

%% Model 4 - good control
z = randn(n,1);
x = z + randn(n,1);
m = x + z + randn(n,1);
y = m + randn(n,1);
data_04=[x z y];

%% Model 5 - good control
j = randn(n,1);
z = j + randn(n,1);
x = z + randn(n,1);
m = x + j + randn(n,1);
y = m + randn(n,1);
data_05=[x z y];

%% Model 6 - good control
j = randn(n,1);
z = j + randn(n,1);
x = j + randn(n,1);
m = x + z + randn(n,1);
y = m + randn(n,1);
data_06=[x z y];

%% Model 7 - M-Bias - Bad control
j1 = randn(n,1);
j2 = randn(n,1);
z = j1 + j2 + randn(n,1);
x = j1 + randn(n,1);
y = x - 4*j2 + randn(n,1);
ya = x - 4*j2 + randn(n,1) + z;
yb = x - 4*j2 + randn(n,1) - z;
data_07=[x z y];

%% Model 8 - Neutral Control (possibly good for precision)
z = randn(n,1);
x = randn(n,1);
y = x + 2*z + randn(n,1);
data_08=[x z y];

%% Model 9 - Neutral Control (possibly bad for precision)
z = randn(n,1);
x = 2*z + randn(n,1);
y = x + 2*randn(n,1);
data_09=[x z y];

%% Model 10 - Bad Control (bias amplification)
z = randn(n,1);
j = randn(n,1);
x = 2*z + j + randn(n,1);
y = x + 2*j + randn(n,1);
data_10=[x z y];

%% Model 11 - Bad Control (overcontrol bias)
x = randn(n,1);
z = x + randn(n,1);
y = z + randn(n,1);
data_11=[x z y];

%% Variation of Model 11 - Bad Control (overcontrol bias)
x = randn(n,1);
j = randn(n,1);
z = x + j + randn(n,1);
y = z + j + randn(n,1);
data_11a=[x z y];

%% Model 12 - Bad Control (overcontrol bias)
x = randn(n,1);
m = x + randn(n,1);
z = m + randn(n,1);
y = m + randn(n,1);
data_12=[x z y];

%% Model 13 - Neutral Control (possibly good for precision)
z = randn(n,1);
x = randn(n,1);
m = 2*z + randn(n,1);
y = x + 2*m + randn(n,1);
data_13=[x z y];

%% Model 14 - Neutral Control (possibly bad for precision)
x = randn(n,1);
z = 2*x + randn(n,1);
y = x + 2*randn(n,1);
data_14=[x z y];

%% Model 15 - Neutral Control (possibly good in the case of selection bias)
x = randn(n,1);
j = randn(n,1);
z = x + randn(n,1);
w = z + j + randn(n,1);
y = x - 2*j + randn(n,1);
data_15=[x z y];

%% Model 16 - Bad Control (selection bias)
x = randn(n,1);
u = randn(n,1);
z = x + u +  randn(n,1);
y = x + 2*u + randn(n,1);
data_16=[x z y];

%% Model 17 - Bad Control (selection bias)
x = randn(n,1);
y = x + randn(n,1);
z = x + y + randn(n,1);
data_17=[x z y];

%% Model 18 - Bad Control (case-control bias)
x = randn(n,1);
y = x + randn(n,1);
z = y + randn(n,1);
data_18=[x z y];

%%
models_all=who('data_*');
nmodels=length(models_all);
addpath(genpath('C:\Users\daniele\Dropbox\code\partial-info-decomp\')); % change directory
res_tot=zeros(nmodels,11);
vs = [1 1 1];
lat = lattice2d();
PC_tot=zeros(nmodels,3);
for imodel=1:nmodels
    eval(strcat('output = sPID(',...
        models_all{imodel},',1,3,2);'));

    res_tot(imodel,1) = output(1); % RED
    res_tot(imodel,2) = output(6); % UNQ1
    res_tot(imodel,3) = output(7); % UNQ2
    res_tot(imodel,4) = output(2); % SYN
    res_tot(imodel,5) = output(3); %
    res_tot(imodel,6) = output(4); %
    res_tot(imodel,7) = output(5); %
    res_tot(imodel,8) = output(8); %
    res_tot(imodel,9) = output(9); %
    res_tot(imodel,10) = output(10); %
    eval(strcat('X=',models_all{imodel},';'));
    PC=partialcorr(X);
    PC_tot(imodel,1)=PC(1,2); % x,z|y
    PC_tot(imodel,2)=PC(1,3); % x,y|z
    PC_tot(imodel,3)=PC(2,3); % y,z|x
end
%subplot = @(m,n,p) subtightplot(m,n,p,[0.001 0.001], [0.1 0.1], [0.1 0.051]);
figure;ax(1)=subplot(1,30,1:28);
PID_MI=res_tot(:,[1:4 6:11]);
PID_MI(PID_MI<0)=0; %put to zero small negative values
imagesc(PID_MI)
colormap(ax(1),brewermap([],'Greens'));colorbar
set(gca,'YTick',1:nmodels);set(gca,'XTick',1:10,'FontSize',16);
set(gca,'XTickLabel',{'RED','U(X)','U(Z)','SYN','I(X;Z)','I(X;Y)'...
    ,'I(Z;Y)','I(X;Z|Y)','I(X;Y|Z)','I(Y;Z|X)'})
set(gca,'YTickLabel',{'1-G','2-G','3-G','4-G','5-G','6-G','7-B','8-N'...
    ,'9-N','10-B','11-B','11a-B','12-B','13-N','14-N','15-N','16-B','17-B','18-B'})
ylabel('Model number - Role of Control Z (Good, Bad, Neutral)')
ax(2)=subplot(1,30,29:30);
imagesc(res_tot(:,5));colormap bluewhitered; colorbar;
set(gca,'XTick',1,'XTickLabel','II','YTickLabel',{},'FontSize',16);
colormap(ax(1),brewermap([],'Greens'));
set(gcf,'Position',[10 10 1300 680]);
suptitle('X source; Y target; Z control, MMI')
figure;clear subplot;
subplot(3,1,1);scatter(PC_tot(:,1),res_tot(:,9));
ylabel('I(X;Z|Y)');xlabel('\rho(X,Z|Y)');xlim([-1 1])
subplot(3,1,2);scatter(PC_tot(:,2),res_tot(:,10));
ylabel('I(X;Y|Z)');xlabel('\rho(X,Y|Z)');xlim([-1 1])
subplot(3,1,3);scatter(PC_tot(:,3),res_tot(:,11));
ylabel('I(Y;Z|X)');xlabel('\rho(Y,Z|X)');xlim([-1 1])
