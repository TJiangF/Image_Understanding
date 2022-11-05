function [pair,feature_org] = find_correspondences(d1,d2,f1,f2,f_org,p,p_org,matches_org,H,img_compare,pair_num)
    [matches, scores] = vl_ubcmatch(d1, d2);
    [dump,scoreindex]=sort(scores,'ascend');
%     pickrate=1;
%     pair_num=fix(pickrate*size(matches,2));
    for i= (1:pair_num)  
        idx = scoreindex(i);
        p_corr(:,i)=[f2(1,matches(2,idx)); f2(2,matches(2,idx))];
    end

    pair=0;
    [height,width]=size(img_compare);
    for i= (1:pair_num)  
        idx = scoreindex(i);
        p_tmp=homography_transform(p(:,i),H);
        if(p_tmp(1)>0 && p_tmp(1)<width && p_tmp(2)>0 && p_tmp(2)<height)
            p_compare=[f2(1,matches(2,1)); f2(2,matches(2,1))];
            dismin=sqrt((p_tmp(1)-p_compare(1))^2+(p_tmp(2)-p_compare(2))^2);
            minindex=1;
            for(j=2:size(matches,2))
                idx2=scoreindex(j);
                p_compare=[f2(1,matches(2,idx2)); f2(2,matches(2,idx2))];
                dis=sqrt((p_tmp(1)-p_compare(1))^2+(p_tmp(2)-p_compare(2))^2);
                if(dis<dismin)
                    minindex2=idx2;
                    minindex1=idx;
                    dismin=dis;
                end
            end
            if(dismin<=10)
                pair=pair+1;
                p_have_corr(1,pair)=p_tmp(1);
                p_have_corr(2,pair)=p_tmp(2);
%                 matches_org(1,idx)
%                 f_org(1,matches_org(1,idx))
                feature_org(:,pair)=[f_org(1,matches_org(1,idx)); f_org(2,matches_org(1,idx))];
%                 feature_org(1,pair)=f_org(1,matches(1,idx));
%                 feature_org(2,pair)=f_org(2,matches(1,idx));
            end
        end
    end
    pair=p_have_corr;
end