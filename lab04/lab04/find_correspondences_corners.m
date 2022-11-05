function pair_proj = find_correspondences_corners(p1,p2,H,height,width)
   
    pairnum=0;
    for i=(1:size(p1,2))
        p_base=[p1(1,i);p1(2,i)];
        p_tmp=homography_transform(p_base,H);
        if(p_tmp(1)>0 && p_tmp(1)<width && p_tmp(2)>0 && p_tmp(2)<height)
            dismin=100;
            for j=(1:size(p2,2))
                p_compare=[p2(1,j);p2(2,j)];
                dis=sqrt((p_tmp(1)-p_compare(1))^2+(p_tmp(2)-p_compare(2))^2);
                if(dis<dismin)
                    dismin=dis;
                end
                
            end
            if(dismin<=10)
                pairnum=pairnum+1;
                pair_proj(1:2,pairnum)=p_tmp;
                pair_proj(3,pairnum)=p1(3,i);
%                     pindexnew(:,pairnum)=pindex(find(p_org));
%                         corners_org(:,pairnum)=
            end
        end
    end
% pindex=pindexnew;
end


