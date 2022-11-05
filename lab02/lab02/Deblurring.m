img=imread("Circuit_Board_degraded.png");
psf_struct=load("psf_circuit_board.mat");
psf=psf_struct.psf_circuit_board;

% img=imread("eyechart_degraded.jpg");
% psf_struct=load("psf_eye_chart.mat");
% psf=psf_struct.psf_eye_chart;
f(:,:,1)=img;
% img_med=Med_Filter(img,3);
% n=11;
% img_med=medfilt2(img,[n,n]);
% figure;
% imshow(uint8(img_med));
iteration=10;
for(i=1:iteration)
%     tmp1=conv2(f(:,:,i),psf,"same");
%     tmp2=double(f(:,:,1))./double(tmp1);
%     tmp3=filter2(psf,tmp2);
%     f(:,:,i+1)=double(f(:,:,i)).*tmp3;

%-----------------Using PSF--------------------------------
%     f(:,:,i+1)=double(f(:,:,i)).*filter2(psf,(double(f(:,:,1))./double(conv2(f(:,:,i),psf,"same"))));

%-----------------Using Med Filter-------------------------
    f(:,:,i+1)=double(f(:,:,i)).*filter2(psf,(double(f(:,:,1))./double(Med_Filter(f(:,:,i),3))));
end
figure;
imshow(img);
figure;
imshow(uint8(f(:,:,iteration+1)));

Lucy=deconvlucy(img,psf,iteration);
% figure;
% imshow(Lucy);

imwrite(uint8(Lucy),"restored_Lucy_Circuit_10.jpg");
% imwrite(uint8(f(:,:,iteration+1)),"restored_Med_eye_chart_30.jpg");
