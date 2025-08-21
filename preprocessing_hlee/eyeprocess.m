function [pupil_area, taxis] = eyeprocess(eyearray)

% input: [y,x,t] 

% this script is to measure the pupil size based on thresholding method, to
% 1. choose roi
% 2. mask image
% 3. get top 10% and bottom 10% values for each slice
% 4. cut the threshold at various range 1%~5% and sum it
% 5. median filter and gauss filter (2d) for stable thresholding
% 6. summation of logical array

% 1. choose roi
figure()
sliceViewer(eyearray)
freehandobj = drawfreehand();
mask = freehandobj.createMask;

% 2. make mask
masked_eye = roi_applymask(eyearray, mask);
% 3. normalize the image
norm_eye = zeros(size(masked_eye));
N = size(norm_eye,3);
for k = 1:N
    sli = masked_eye(:,:,k);
    v = sli(~isnan(sli));        
    if isempty(v), continue; end
    pr = prctile(v, [1 99]);  
    norm_eye(:,:,k) = mat2gray(sli ,[pr(1) pr(2)]);
end

bweye = uint8(norm_eye<0.05);
for thr = 0.01:0.01:0.05
    bweye = bweye + uint8(norm_eye<thr);
end

bweye_med = medfilt3(bweye,[5 5 11]);
bweye_gauss = imgaussfilt(bweye_med,1);
thr_bweyemed = bweye_gauss>1;
pupil_area = squeeze(sum(thr_bweyemed,[1,2]));
taxis = linspace(0,1800,N);