function [warpedImage, leftTopUnwarpX, leftTopUnwarpY, warpImgWeight] = getNewImg(transform, img1, img2)

%> Code Description: 
%     Given two original images and a homography transformation matrix, 
%     generate a warped image with warped weights as well as the top left 
%     coordinate of the unwarped image.
%
%> Inputs: 
%     transform:      The 3x3 homography matrix, transforming from img1 
%                     to img2
%     img1:           The first original image
%     img2:           The second original image
%
%> Outputs:
%     warpedImage:    The warped image that warps img2 to img1 based on the
%                     homography matrix
%     leftTopUnwarpX: The left top x coordinate of the unwarped image
%     leftTopUnwarpY: The left top y coordinate of the unwarped image
%     warpImgWeight:  The interpolation weights after warping the image
%
%> (c) LEMS, Brown University
%> Chiang-Heng Chien (chiang-heng_chien@brown.edu)
%> Oct. 5th, 2020

    %> Fetch input image size and channel
    [rows1, cols1, channel1] = size(img1);
    [rows2, cols2, channel2] = size(img2);
    
    warpImgH = rows2;
    warpImgW = cols2;
    unwarpImgH = rows1;
    unwarpImgW = cols1;
    
    %> Define the type of the input image
    if ((channel1 > 1) || (channel2 > 1))
        imgType = 'color';
    else
        imgType = 'gray';
    end

    %> Create a matrix representation (size: 3ximgSize) of pix coordinates 
    %  of unwarped imgs (vectorize the img)
    [X, Y] = meshgrid(1:warpImgW, 1:warpImgH);
    pixCoorMat = ones(3, warpImgH*warpImgW);
    pixCoorMat(1,:) = reshape(X, 1, warpImgH*warpImgW);
    pixCoorMat(2,:) = reshape(Y, 1, warpImgH*warpImgW);

    %> Transform the warpped img via homography matrix
    %  Because pixCoorMat is 3ximgSize, homography must take a transpose
    newpixCoorMat = transform\pixCoorMat;
    newpixCoorMat(1,:) = newpixCoorMat(1,:)./newpixCoorMat(3,:);
    newpixCoorMat(2,:) = newpixCoorMat(2,:)./newpixCoorMat(3,:);

    %> Derive locations of 4 corners on the canvas using homography matrix
    new_left = fix(min([1, min(newpixCoorMat(1,:))]));
    new_right = fix(max([unwarpImgW, max(newpixCoorMat(1,:))]));
    new_top = fix(min([1, min(newpixCoorMat(2,:))]));
    new_bottom = fix(max([unwarpImgH, max(newpixCoorMat(2,:))]));

    %> Compute the boundaries of the paneroma
    rowsP = new_bottom - new_top + 1;
    colsP = new_right - new_left + 1;
    leftTopPx = new_left;
    leftTopPy = new_top;
    leftTopUnwarpX = 2 - new_left;
    leftTopUnwarpY = 2 - new_top;
    
    %> Create a matrix representation (size: 3ximgSize) of img coordinates 
    %  of the mosaic img (vectorize the mosaic img)
    [mX, mY] = meshgrid(leftTopPx:leftTopPx+colsP-1, leftTopPy:leftTopPy+rowsP-1);
    mosaic = ones(3, rowsP*colsP);
    mosaic(1,:) = reshape(mX, 1, rowsP*colsP);
    mosaic(2,:) = reshape(mY, 1, rowsP*colsP);

    %> Inversly transform the mosaic via homography matrix
    %  Because the mosaic img is 3ximgSize, homography matrix must take a 
    %  transpose
    mosaic = transform * mosaic;
    mX = reshape(mosaic(1,:)./mosaic(3,:), rowsP, colsP);
    mY = reshape(mosaic(2,:)./mosaic(3,:), rowsP, colsP);

    %> Construct a weight image for img2
    img2TopDist = repmat(reshape(1:warpImgH, warpImgH, 1), [1, warpImgW]);
    img2LeftDist = repmat(reshape(1:warpImgW, 1, warpImgW), [warpImgH, 1]);
    img2RightDist = repmat(reshape(warpImgW:-1:1, 1, warpImgW), [warpImgH, 1]);
    img2BottomDist = repmat(reshape(warpImgH:-1:1, warpImgH, 1), [1, warpImgW]);
    img2Dist_LR = min(img2LeftDist, img2RightDist);
    imgDist_TB = min(img2TopDist, img2BottomDist);
    img2Dist = min(img2Dist_LR, imgDist_TB);
    
    %> Linear interpolation of each channel, warping one img to a new img
    class_of_I = class(img2);
    warpImgWeight = interp2(X, Y, double(img2Dist), mX, mY, 'nearest');

    %> Finally, generate the warped image according to the image type
    switch imgType
        case 'color'
            warpedImage(:,:,1) = cast(interp2(X, Y, double(img2(:,:,1)), mX, mY, 'linear'), class_of_I);
            warpedImage(:,:,2) = cast(interp2(X, Y, double(img2(:,:,2)), mX, mY, 'linear'), class_of_I);
            warpedImage(:,:,3) = cast(interp2(X, Y, double(img2(:,:,3)), mX, mY, 'linear'), class_of_I);
        case 'gray'
            warpedImage = cast(interp2(X, Y, double(img2), mX, mY, 'linear'), class_of_I);
    end
end
