%% GUI for the software 
% Last updated date: 2015. 12. 28
% Copyright (C) 2015 Zhaoxiong Yang & Yao Xie
% All rights reserved.

% Course project for Software Engineering and Computer Graphics.
% Done by Jiajun Jin, Zhaoxiong Yang, Yupeng Zhang and Yao Xie.
% Thank the author for providing the algorithm.
%%

function detecting()
global status;
status = 5;

%% Parameters
global num_of_frames;    % Number of images
%global img_path;
%directory = img_path;
directory = '.\Sequences\source\';   % Directory of images

%% Initialization
load('.\detector\models\AcfCaltech+Detector.mat');
disp('Detecting');

%%
detections(1,num_of_frames)=struct('x',[],'y',[],'w',[],'h',[]);
global detect_cur;
for i = 1: num_of_frames
    detect_cur = i;
    filename = [directory, num2str(i,'%04d'), '.png'];
    disp(filename);
    bbs = acfDetect(filename, detector);
    [row col] = size(bbs);
    t = struct('x',[round(bbs(1:row,1))+round(bbs(1:row,3)/2)],'y',[round(bbs(1:row,2))+round(bbs(1:row,4)/2)],'w',[round(bbs(1:row,3))],'h',[round(bbs(1:row,4))]);
    detections(1,i) = t;
end
save('.\Det\Test.mat','detections');
    