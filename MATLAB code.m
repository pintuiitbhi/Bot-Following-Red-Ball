%Red Ball following Bot
%Author: Pintu Kumar
%Arduino Mega is Used for transmission 



clear all;
clc;
warning('OFF')
%Settitng during time
during_time =input('during time [100]? ');
ser=serial ('COM11','BAUD', 2400);
fopen(ser);
tic
url = 'http://192.168.43.1:8080/shot.jpg'; 
if isempty(during_time),
    during_time=100;
end

framesAcquired = 0;

while (framesAcquired ~=-1)
    data = imread(url); 
    framesAcquired = framesAcquired + 1;   
    k1=data(:,:,1);
    k2=data(:,:,3);
    k3=data(:,:,2);
      diff_im = imsubtract(data(:,:,1), rgb2gray(data));
      diff_im = medfilt2(diff_im, [3 3]);
      diff_im = im2bw(diff_im,0.18);                   % convert image to binary image
      stats = regionprops(diff_im, 'BoundingBox', 'Centroid');
            drawnow;
      imshow(data);

     hold on  
      for object = 1:length(stats)
          bb = stats(object).BoundingBox;
          bc = stats(object).Centroid;
          rectangle('Position',bb,'EdgeColor','b','LineWidth',2)
          plot(bc(1),bc(2), '-m+')
      end
   
    k1=data(:,:,1);
    k2=data(:,:,3);
    k3=data(:,:,2);
    
red=k1-k3/2-k3/2;
bw1=red>70; %125 80
bw2=red<125;

a1=k1>145 & k2<85 &k3 >10 &bw1 & bw2;
a2=bwareaopen(a1,10);
se=strel('disk',4);
a3=imclose(a2,se);
a4=imfill(a3,'holes');
s=regionprops(a4,'Centroid','area','Eccentricity');
[m n]=size(s);
imshow(data)
hold on
if m ~=0
    for t=1:m
        r(t)=ceil(sqrt((s(t).Area)/pi));
    end
    pos=find(r==max(r));
    x=s(pos(1)).Centroid(1);
    y=s(pos(1)).Centroid(2);
    plot(s(pos(1)).Centroid(1),s(pos(1)).Centroid(2),'r*');
    DrawCircle(s(pos(1)).Centroid(1),s(pos(1)).Centroid(2),r(pos(1)),1000,'red');
    
    
    if x<=120
        fprintf('\nLeft\n');
        fprintf(ser,'%d',double(4)); 
        pause(0.7);
    elseif x>120 && x<200 && y<=80
        fprintf('\nBackward\n');
        
       % send('B',ser);
       fprintf(ser,'%d',double(8));
      pause(0.7);
     elseif x>=200
        fprintf('\nRight');
       % send('L',ser);
      fprintf(ser,'%d',double(6));
      pause(0.7);
    elseif x>120 && x<200 && y>=160
        fprintf('\nForward\n');
       % send('L',ser);
       fprintf(ser,'%d',double(2));
       pause(0.7);
    else
        fprintf('\nStop\n');
        %fprintf(ser,2);
       % send('L',ser);
      fprintf(ser,'%d',double(a));
     pause(0.7);
      % fwrite(ser,A);
    end
   
end
if m==0
    fprintf('\nStop\n');
   % send('S',ser);
   fprintf(ser,'%d',double(5));
  pause(0.7);
  % fwrite(ser,1,'int16');
end
clearvars r;
clearvars pos;
hold off
drawnow;
end
fprintf('OVER !!!!!\n');
%send('S',ser);
fprintf(ser,'%d',double(5));
%fwrite(ser,1,'int16');
stop(vid);
clear all
hold off
