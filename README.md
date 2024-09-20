# HSI-denoiser-GLF
An HSI denoiser: Global Local Factorization (GLF)

The code and data herein distributed reproduce the results published in
 the paper 

 Lina Zhuang and Jose M. Bioucas-Dias, "Hyperspectral image denoising 
 based on global and non-local low-rank factorizations", 
 IEEE Transactions on Geoscience and Remote Sensing, 2021.
 URL: https://ieeexplore.ieee.org/document/9318519
 
 Lina Zhuang and Jose M. Bioucas-Dias, "Hyperspectral image denoising 
 based on global and non-local low-rank factorizations",  IEEE 
 International Conference on Image Processing, Sep. 2017.
 URL: https://www.it.pt/Publications/DownloadPaperConference/30727



% Description:

main.m                                   ---- main script reproducing the denoising results published in GLF paper
MPSNR.m                                  ---- Performance criteria: mean peak signal-to-noise per band
MSSIM.m & ssim_index                     ---- Performance criteria: mean structural similarity per band
img_clean_dc.mat & img_clean_pavia.mat   ---- Simulated clean datasets
GLF_denoiser.m                           ---- denoising algorithm GLF
NonlocalPatch_local_LR.m                 ---- Nonlocal patch-based denoising of subsapce coefficients
LowRank_tensor.m                         ---- Low-rank approximation based filtering for  similar groups of patches
LowRankRecovery3.m                       ---- Low rank matrix recovery
hysime.m                                 ---- Subsapce identification 



%  Notes:

  1) Package instalation: unzip the files to a directory and run the
  scripts of "main.m", which reproduces the denoising results
  reported in the above paper.


  2) The script  GLF_denoiser.m use the functions (e.g., tensor()) from
     Tensor Toolbox (version 2.6 (February 6, 2015)). 

     The MATLAB Tensor Toolbox Version 2.6 is available at the 
     web page:  http://www.sandia.gov/~tgkolda/TensorToolbox/index-2.6.html

     Download this toolbox and install it in the folder /tensor_toolbox


   3) GLF_denoiser.m is the core funtion. It is a state-of-the-art denoiser
      designed for hyperspectral images corrupted with additive Gaussian noise.
     
 
  
% ACKNOWLEDGMENTS

The authors acknowledge the following individuals and organisations:


  - Prof. Paolo Gamba from Pavia university, 
    for making the Pavia University data set available to the community.

  - Prof. David Landgrebe and Larry Biehl from Purdue University, 
    for making the Washington DC Mall data set available to the community.

  - Authors of the MATLAB Tensor Toolbox (Brett W. Bader, Tamara G. Kolda, 
    Jimeng Sun, Evrim Acar, Daniel M. Dunlavy, Eric C. Chi, Jackson Mayo, 
    et al.) from Sandia National Laboratories, for making the Tensor 
    Toolbox available to the community.
 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Author: Lina Zhuang and Jose M. Bioucas Dias, Nov. 2017
