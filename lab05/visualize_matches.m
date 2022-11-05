function visualize_matches(img1, img2, matches1, matches2, N)

%> Code Description: 
%     Given two images and the coordinates of feature correspondences, 
%     plot the top N matches on the appended images.
%
%> Inputs: 
%     img1:     The first image
%     img2:     The second image
%     matches1: A Mx2 ordered feature coorespondences coordinates. M is 
%               the number of matches.
%     matches2: Another MX2 ordered feature correspondences.
%     N:        Number of feature matches to be plotted
%
%> Outputs:
%     None
%
%> (c) LEMS, Brown University
%> Chiang-Heng Chien (chiang-heng_chien@brown.edu)
%> Oct. 16th, 2020
    
    [~, cols1] = size(img1);

    %> Append both images side-by-side
    figure, img3 = [img1, img2];  
    colormap('gray');
    imagesc(img3);

    %> Show a figure with lines joining the feature matches
    hold on;
    for i = 1 : N
        line([matches1(i,1), matches2(i,1)+cols1], ...
             [matches1(i,2), matches2(i,2)], 'Color', 'c');
        plot(matches1(i,1), matches1(i,2), 'y+');
        plot(matches2(i,1)+cols1, matches2(i,2), 'y+');
    end
    axis off;
    hold off;
    set(gcf,'color','w');
    
end