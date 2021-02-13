%% Advanced signal processing laboratory (2020)
clear all
close all
%% 1 Tasks 1
Acolor = imread('U8ver_FP_ImColForgr.png');
A = rgb2gray(Acolor);
A = double(A);

%% 1 Tasks 2
histogramA = hist(A(:), 0:255);
figure(1); semilogy(histogramA);
axis([0 250 -100000 1200])
[counts,binLocations] = imhist(A);

empirical_entropy=0;
number_pixels=numel(A);
for i=1:256
    f(i,1)=sum(A(:)==(i - 1));
    if (f(i,1)~= 0)
        p=f(i,1)/number_pixels;
        empirical_entropy=empirical_entropy+ p*log(1/p);
    end
end    

    
%% 1 Tasks 3
[rows,columns] = size(A);
E = zeros(rows-1,columns-1 -1);
for j = 2:columns-1
    for i = 2:rows
        n =A(i-1,j);w =A(i,j-1);nw=A(i-1,j-1);ne=A(i-1,j+1);
        E(i,j) = A(i,j) - median([n, w, n+w-nw, w-n+ne, w+(ne-nw)/2]);
    end
end
figure(1)
subplot(2,1,1);
imshow(E)
subplot(2,1,2);
imagesc(E); colormap (gray);


%% 1 Tasks 4,6,8
block_size      =[];
compressed_size =[];
maes = [];
for bs = 32:33
    bs = bs
    filename=sprintf('binary_%d.bin',bs);
    
    BS = lf_compress(A,filename,bs);
    decompressed_image = lf_decompress(filename);
    
    figure()
    
    subplot(1,2,1)
    imshow(uint8(A))
    title('original image')
    
    subplot(1,2,2)
    imshow(decompressed_image)
    mae_value = mae(double(decompressed_image), double(A));
    title(['decompressed image' num2str(mae_value)]);

    block_size = [block_size bs];
    compressed_size =[compressed_size (length(BS))/8/1024];
    maes = [maes mae_value];
end
%% 1 Tasks 7
figure()
plot(block_size,compressed_size)
set(gca,'xtick',block_size,'xticklabel',block_size)
% for k=1:numel(block_size)
%       text(block_size(k),compressed_size(k),['(' num2str(block_size(k)) ',' num2str(compressed_size(k)) ')'])
% end