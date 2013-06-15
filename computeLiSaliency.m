function saliencyMap = computeLiSaliency(singleChannel)
%% Read image from file 
inImg = im2double(singleChannel);
m = size(inImg, 2);
inImg = imresize(inImg, 32/m);

%% Spectral Residual
myFFT = fft2(inImg); 
myLogAmplitude = log(abs(myFFT));
myPhase = angle(myFFT);
mySpectralResidual = imfilter(myLogAmplitude, fspecial('average', 5), 'replicate'); 
saliencyMap = abs(ifft2(exp(mySpectralResidual + 1i*myPhase))).^2;

%% After Effect
saliencyMap = imfilter(saliencyMap, fspecial('average', 5),'replicate');
saliencyMap = imresize(saliencyMap, m/32);