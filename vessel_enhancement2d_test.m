%% clear
clc; clear all; close all;

%% path
addpath('./lib')

%% load image
im = imread('./im/retina.tif');
im = rgb2gray(im);

%% normalize
im = double(im); im = (im - min(im(:))) / (max(im(:)) - min(im(:)));
im = imcomplement(im);

%% opening by reconstruction
sl = 10; % line size = diameter of the biggest vessels
no = 12; % number of orientation
sigma = 3; % LoG sigma

[imres,immax,imsum] = vessel_enhancement2d(im,sl,no,sigma);

%% plot
figure; imagesc(im); colormap gray; 
set(gca,'ytick',[]); set(gca,'xtick',[]); axis image; axis tight;

figure; imagesc(imsum); colormap gray; 
set(gca,'ytick',[]); set(gca,'xtick',[]); axis image; axis tight;

figure; imagesc(immax); colormap gray; 
set(gca,'ytick',[]); set(gca,'xtick',[]); axis image; axis tight;

figure; imagesc(imres); colormap gray; 
set(gca,'ytick',[]); set(gca,'xtick',[]); axis image; axis tight;
