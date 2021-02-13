% SGN-26006 Advanced signal processing laboratory (2020)
clear all
close all
%% Initialization and Acquisition of the Point Cloud

filename = 'S:\81201_IMSIM\POINT_CLOUDS\AdvSPLab\loot_vox10_1001.ply';
filename = 'loot_vox10_1001.ply'
URL = 'http://www.cs.tut.fi/~tabus/course/AdvSP/loot_vox10_1001.ply'
A = urlread(URL);
fid = fopen(filename,'w')
fwrite(fid,A,'char');
fclose(fid);
ptCloud = pcread(filename);
figure(1),PC1_img = pcshow(ptCloud);

%% Orientation and Manipulation of the Point Cloud

% Use the figure toolbar (open it from Figure 1 Menu --> View -->
% Figure Toolbar, if it's not open already)
% Pick the Rotate 3D button and rotate as much as you think is
% necessary to understand the structure of the point cloud
% Extract the 3 major projections (Front, Top and 1 Side Projection of
% your choice [L/R]), show them, save them to your hard drive and include
% them in the report.
PC1_img.View = [0 90]; %First Projection (Front)
% Inspect the structure of the point cloud and then, subsequentially,
% save the geometry and the colors in 2 indipendent variables:
BB = ptCloud.Location(:,1:3); %Geometry
CC = ptCloud.Color(:,1:3);

%%  Task 2 Extract the Assigned Projection
% If your Student Number's last digit is odd --> Left/Right Projection
% If your Student Number's last digit is even --> Top/Bottom Projection
% 29320
% For both cases you also have to display them and save them to your hard 
% drive and include them in the report.
% Example for the extraction of the front/back projection
FP_BB1 = BB(:,1);
FP_BB2 = BB(:,3);
FP_BB3 = BB(:,2);
MaskFP_1 = zeros(length(FP_BB1),1);
MaskFP_2 = zeros(length(FP_BB1),1);
MaskFP_3 = zeros(length(FP_BB1),1);
FP_ImRepMax = zeros(max(FP_BB2(:)),max(FP_BB1(:)));
FP_ImRepMin = 10^10*ones(max(FP_BB2(:)),max(FP_BB1(:)));
FP_ImRepCell = cell(max(FP_BB2(:)),max(FP_BB1(:)));
FP_ImRepCard = zeros(max(FP_BB2(:)),max(FP_BB1(:)));
FP_ImColForgr = zeros(max(FP_BB2(:)),max(FP_BB1(:)),3);
FP_ImColBackgr = zeros(max(FP_BB2(:)),max(FP_BB1(:)),3);
for i4 = 1:length(FP_BB1)
if( FP_ImRepMax( FP_BB2(i4),FP_BB1(i4) ) < FP_BB3(i4) )
 FP_ImRepMax( FP_BB2(i4),FP_BB1(i4) ) = FP_BB3(i4);
 FP_ImColForgr( FP_BB2(i4),FP_BB1(i4),1:3) = CC(i4,:);
end
if( FP_ImRepMin( FP_BB2(i4),FP_BB1(i4) ) > FP_BB3(i4) )
 FP_ImRepMin( FP_BB2(i4),FP_BB1(i4) ) = FP_BB3(i4);
 FP_ImColBackgr( FP_BB2(i4),FP_BB1(i4),1:3) = CC(i4,:);
end
 FP_ImRepCell{FP_BB2(i4),FP_BB1(i4)} = [FP_ImRepCell{FP_BB2(i4),FP_BB1(i4)} FP_BB3(i4)];
 FP_ImRepCard(FP_BB2(i4),FP_BB1(i4)) = length( FP_ImRepCell{FP_BB2(i4),FP_BB1(i4)} );
end
% Mark the used points
for i4 = 1:length(FP_BB1)
if( FP_ImRepMax( FP_BB2(i4),FP_BB1(i4) ) == FP_BB3(i4) )
 MaskFP_1(i4) = 1;
end
if( FP_ImRepMin( FP_BB2(i4),FP_BB1(i4) ) == FP_BB3(i4) )
 MaskFP_1(i4) = 2;
end
end
FP_ImRepCard = FP_ImRepCard(end:-1:1,:);
FP_ImRepMax= FP_ImRepMax(end:-1:1,:);
FP_ImRepMin = FP_ImRepMin(end:-1:1,:); FP_ImRepMin( FP_ImRepMin == 10^10) = 0;
FP_ImColForgr = FP_ImColForgr(end:-1:1,:,:);
FP_ImColBackgr = FP_ImColBackgr(end:-1:1,:,:);
% Saving and Displaying Images
U8ver_FP_ImColForgr = uint8(FP_ImColForgr);
U8ver_FP_ImColBackgr = uint8(FP_ImColBackgr);
figure(14), imagesc(FP_ImRepMax), colormap(gray), axis equal
figure(15), imagesc(FP_ImRepMin), colormap(gray), axis equal
figure(18), imshow(U8ver_FP_ImColForgr), colormap(gray)
figure(19), imshow(U8ver_FP_ImColBackgr), colormap(gray)
vv = [sum(FP_ImRepMax(:)>0) sum(FP_ImRepMin(:)>0)
 sum(FP_ImRepMax(:)>0)+sum(FP_ImRepMin(:)>0) length(FP_BB1)];
imwrite(U8ver_FP_ImColForgr, 'U8ver_FP_ImColForgr.png');
imwrite(U8ver_FP_ImColBackgr, 'U8ver_FP_ImColBackgr.png');
% At the end of this taks, you'll need to work with only one projection 
% until the end of the assignment:
% Top/Bottom has to work with only the Top Projection
% Left/Right has to work with only the Left Projection