% Probability Map of Colors
% Md. Iftekhar Tanveer (tanveer1@umbc.edu)
clear;clc;

Select_a_color = 'blue';
Picture = 'E:\Github\Colored_image_set\2013-06-12 14.52.43.jpg';

% Color Table
% Color_Name  Hue_Cntr  Hue_BW  Sat_Cntr Sat_BW  Val_Cntr  Val_BW
ColorTable = {
    'White'     0   50  0   50  255 110 
    'Silver'    0   50  0   50  191 110
    'Gray'      0   50  0   50  128 110
    'Black'     128 300 128 300 0   50
    'Red'       0   30  255 120 230 150
    'Maroon'    0   30  245 120 100 100
    'Yellow'    43  25  245 120 230 150
    'Olive'     43  25  245 120 100 75
    'Lime'      84  25  245 120 230 150
    'Green'     90  50  210 180 50  120
    'Aqua'      127 10  185 200 170 120
    'Teal'      127 10  245 80  85  75
    'Blue'      170 30  160 200 150 220
    'Navy'      170 30  70  220 70  180
    'Magenta'   213 50  200 175 220 100
    'Purple'    212 260 100 220 70  180
    'Orange'    22  25  160 200 150 220
};

% Filter TF Builder. X = domain; C = center; BW = bandwidth
% Cutoff points will be C + BW/2 and C - BW/2
G = @(x,c,BW)  sqrt(1./(1+exp(-(1/2)*(x-(c-BW/2))))) + ...
    sqrt(1./(1+exp((1/2)*(x-(c+BW/2))))) - 1;

% load image and create filters for the HSV channels
img = imread(Picture);
img_HSV = uint8(rgb2hsv(img)*255);
x = 0:256;
clrIdx = find(strcmpi(ColorTable(:,1),Select_a_color));
if (isempty(clrIdx))
    disp('Color Not Recognized');
    return;
end
H_hue = G(x,ColorTable{clrIdx,2},ColorTable{clrIdx,3});
H_sat = G(x,ColorTable{clrIdx,4},ColorTable{clrIdx,5}); 
H_val = G(x,ColorTable{clrIdx,6},ColorTable{clrIdx,7});

% Calculate Saliency
H_sal = computeLiSaliency(img_HSV(:,:,1));
S_sal = computeLiSaliency(img_HSV(:,:,2));
V_sal = computeLiSaliency(img_HSV(:,:,3));
combined_sal = (H_sal + S_sal + V_sal)/3;

% Show the filters
figure(1);
subplot(311);plot(x,H_hue);title('Hue Filter');
subplot(312);plot(x,H_sat);title('Saturation Filter');
subplot(313);plot(x,H_val);title('Value Filter');

% apply filter and show the filtered images
img_Hue_filtered = H_hue(img_HSV(:,:,1)+1);
img_Sat_filtered = H_sat(img_HSV(:,:,2)+1);
img_Val_filtered = H_val(img_HSV(:,:,3)+1);
Combined = img_Hue_filtered.*img_Sat_filtered.*img_Val_filtered;

% Display all the color filters
figure(2);
subplot(221);imshow(img);title('Original');
subplot(222);imshow(img_HSV(:,:,1));title('Hue');
subplot(223);imshow(img_HSV(:,:,2));title('Saturation');
subplot(224);imshow(img_HSV(:,:,3));title('Value');

% Display the color map
figure(3);
subplot(221);imshow(img_Hue_filtered);title('Filtered Hue')
subplot(222);imshow(img_Sat_filtered);title('Filtered Saturation')
subplot(223);imshow(img_Val_filtered);title('Filtered Value')
subplot(224);imshow(Combined);title(['Map for ',Select_a_color])

% Display Saliency map
figure(4);
subplot(221);imagesc(H_sal);colormap(jet);axis image;
colorbar;title('Saliency map for hue');
subplot(222);imagesc(S_sal);colormap(jet);axis image;
colorbar;title('Saliency map for Saturation');
subplot(223);imagesc(V_sal);colormap(jet);axis image;
colorbar;title('Saliency map for Value');
subplot(224);imagesc(combined_sal);colormap(jet);axis image;
colorbar;title('Average of Saliencies');