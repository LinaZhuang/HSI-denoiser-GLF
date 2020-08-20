%% Name: main
%
%  Generate the denoising results of GLF reported in Tabs. 1-2
%  of paper:
%
%  Lina Zhuang and Jose M. Bioucas-Dias, "Hyperspectral image denoising
%  based on global and non-local low-rank factorizations",  IEEE
%  International Conference on Image Processing, Sep. 2017.
%
%  URL: https://www.it.pt/Publications/DownloadPaperConference/30727
%
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Author: Lina Zhuang (lina.zhuang@lx.it.pt)
%         &
%         Jose M. Bioucas-Dias (bioucas@lx.it.pt)
%         Nov., 2017
%%


clear;clc;close all;
% Parameter setting:
%    testdataset          testdataset = 1 - Pavia image;
%                         testdataset = 2 - DC image
%    i_img                Additive Gaussian i.i.d. noise. You may chhose a 
%                         specific noise level:  
%                         i_img \in {1,2,3,4,5} sets different noise
%                         standard deviation corresponding to
%                         0.10, 0.08, 0.06, 0.04, and 0.02, respectively.
% USAGE EXAMPLES:

% %--------------------------
% testdataset = 1;       
% i_img= 2;              
% p_subspace = 10; %Dimenion of subspace
% %--------------------------
testdataset = 2;
i_img=5;
p_subspace = 10;
% %--------------------------


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% Simulate noisy image with different noise level   %%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
noise_type='additive';
%load clean image
if testdataset==1  % testdataset=Pavia
    
    fprintf(['\n','\n','Test dataset: Pavia,  ','i_img = ',num2str(i_img), '\n']);
    load  img_clean_pavia.mat;
    img_clean = img_clean_pavia; % See details about the generation of the
    % clean image in the  code of FastHyDe 
    % (available in http://www.lx.it.pt/~bioucas/publications.html), 
    % namely the function 'gen_data_sets.m'.
    clear img_clean_pavia;
    
else % testdataset= dc
    
    fprintf(['\n','\n','Test dataset: dc,  ','i_img = ',num2str(i_img), '\n']);
    load  img_clean_dc.mat;
    img_clean = img_clean_dc;
    clear img_clean_pavia;
    
end


[row, column, band] = size(img_clean);
N=row*column;


switch i_img
    case 1
        sigma = 0.1;randn('seed',0);
    case 2
        sigma = 0.08;randn('seed',i_img*N);
    case 3
        sigma = 0.06;randn('seed',i_img*N);
    case 4
        sigma = 0.04;randn('seed',i_img*N);
    case 5
        sigma = 0.02;randn('seed',i_img*N);
end

%generate noisy image
noise = sigma.*randn(size(img_clean));
img_noisy=img_clean+noise;



Y_clean = reshape(img_clean, N, band)';
Y_noisy = reshape(img_noisy, N, band)';
%  figure;plot([Y_clean(:,100),Y_noisy(:,100)])


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%           GLF        %%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

t1 = clock;

p_subspace=8;
noise_type = 'additive';
 
 img_GLF = GLF_denoiser(img_noisy,  p_subspace,  noise_type) ;
%  img_GLF = GLF_denoiser(img_noisy,  p_subspace,  noise_type, 'f', 10,'t', 39,'Nstep',3) ;


time_GLF  = etime(clock,t1);
Y_GLF= reshape(img_GLF,N,band)';


% -------------------------------------------------------------------------
%Performance criteria:
%MPSNR: mean peak signal-to-noise per band
%MSSIM: mean structural similarity per band


result_ori_noisy = [MPSNR(Y_noisy,Y_clean); MSSIM(Y_noisy,Y_clean, row, column); 0];
result_GLF = [MPSNR(Y_GLF, Y_clean); MSSIM(Y_GLF,Y_clean,row, column); time_GLF];
%         result_bm4d = [MPSNR(Y_bm4d, Y_clean); MSSIM(Y_bm4d,Y_clean,row, column); time];
%         Results_dif_Img_save = [Results_dif_Img_save;[result_ori_noisy,result_bm4d]];
%         save Results_dif_Img_save_bm4d.mat  Results_dif_Img_save;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%  show original and reconstructed data   %%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure;
set(gcf,'outerposition',get(0,'screensize'))
idx = 10;
subplot(1,3,1);
tmp = img_clean(:,:,idx);
tmp = sort(tmp(:));
minv = tmp(fix(N*0.02));
maxv =  tmp(fix(N*0.98));
imagesc(img_clean(:,:,idx),[minv,maxv]);
colormap('gray');
if testdataset
title({['Runing Pavia data'],['Clean ',num2str(idx),'th band']});
else
    title({['Runing Washinton DC Mall data'],['Clean ',num2str(idx),'th band']});
end

subplot(1,3,2);
imagesc(img_noisy(:,:,idx),[minv,maxv]);
colormap('gray');
title({['Noisy band corrupted by Gaussian i.i.d noise: N( 0, ',num2str(sigma),'^2)'];...
    ['MPSNR = ',num2str(result_ori_noisy(1)),' dB'];['MSSIM = ',...
num2str(result_ori_noisy(2))]});
 
subplot(1,3,3);
imagesc(img_GLF(:,:,idx),[minv,maxv]);
colormap('gray');
title({['Estimated by GLF'];['MPSNR = ',num2str(result_GLF(1)),' dB'];['MSSIM = ',...
num2str(result_GLF(2))]});

figure; 
vec = @(x) x(:);
set(gcf,'outerposition',get(0,'screensize'));
subplot(1,2,1);
idx = 150;
spec_tmp = [vec(img_clean(idx,idx,:)),vec(img_noisy(idx,idx,:)),vec(img_GLF(idx,idx,:))];
plot(spec_tmp(:,[1 2]) );
xlabel('Band');
legend('Clean pixel X(10,10,:)','Noisy');
subplot(1,2,2);
plot( spec_tmp(:,[1 3]));
xlabel('Band');
legend('Clean pixel X(10,10,:)','GLF');
 
 
 
 
 
 
 
 
 
 
