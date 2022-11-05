function [finalE, inlierIndx] = Ransac4Essential(gamma1,gamma2,K)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
picknum=5;
pair_num=size(gamma1,2);
max_inlier=0;
for i=(1:5000)
    randompick(:)=ceil(pair_num*rand(1,picknum));
    for m=(1:picknum)
%         randompick(m)
        matches1(:,m)=gamma1(:,randompick(m));
        matches2(:,m)=gamma2(:,randompick(m));
    end
    
    matchesInMeters = ones(5, 3, 2);
    for i=(1:5)
        matchesInMeters(i,:,1) = inv(K)*[matches1(:,i);1];
        matchesInMeters(i,:,2) = inv(K)*[matches2(:,i);1];
    end
    Es = fivePointAlgorithmSelf(matchesInMeters);
    possibleES=size(Es,3);
%     for i=(1:possibleES)
%         PossibleMatrix(:,:,i)=Es{1,1,i}(:,:);
%     end
    if(possibleES~=0)
        PossibleMatrix=cell2mat(Es);
        PossibleE=PossibleMatrix;
        for i=(1:possibleES)
            PossibleMatrix(:,:,i)=transpose(inv(K))*PossibleMatrix(:,:,i)*inv(K);
        end
        
        
        A=PossibleMatrix(1,1,:).*gamma1(1,:)+PossibleMatrix(1,2,:).*gamma1(2,:)+PossibleMatrix(1,3,:);
        B=PossibleMatrix(2,1,:).*gamma1(1,:)+PossibleMatrix(2,2,:).*gamma1(2,:)+PossibleMatrix(2,3,:);
        C=PossibleMatrix(3,1,:).*gamma1(1,:)+PossibleMatrix(3,2,:).*gamma1(2,:)+PossibleMatrix(3,3,:);
        Atmp=squeeze(A(1,:,:));
        Btmp=squeeze(B(1,:,:));
        Ctmp=squeeze(C(1,:,:));
    %     Atmp(:,:)=PossibleMatrix(1,1,:).*matchesInMeters(:,1,1)+PossibleMatrix(1,2,:).*matchesInMeters(:,2,1)+PossibleMatrix(1,3,:);
    %     Btmp(:,:)=PossibleMatrix(2,1,:).*matchesInMeters(:,1,1)+PossibleMatrix(2,2,:).*matchesInMeters(:,2,1)+PossibleMatrix(2,3,:);
    %     Ctmp(:,:)=PossibleMatrix(3,1,:).*matchesInMeters(:,1,1)+PossibleMatrix(3,2,:).*matchesInMeters(:,2,1)+PossibleMatrix(3,3,:);

    %     slope=-Atmp./Btmp;
        cut_col=-Ctmp./Btmp;
        cut_row=-Ctmp./Atmp;
        %ax+by+c=0->y=-a/b x-c/b
        max_inlier_tmp=0;
        max_indx_tmp=0;
        for i=(1:possibleES)
            num_inlier=0;
            for j=(1:pair_num)
                v1 = [0,cut_col(j,i)];
                v2 = [cut_row(j,i),0];
                pt=transpose(gamma2(:,j));
                a = v1 - v2;
                b = pt - v2;
                d = abs(det([a;b]))/norm(a);
                if(d<=2)
                    num_inlier=num_inlier+1;
                    if(num_inlier==1)
                        inlierindx_tmp=j;
                    end
                    if(num_inlier>1)
                        inlierindx_tmp=[inlierindx_tmp,j];
                    end
                end
            end
            if(num_inlier>=max_inlier_tmp)
                max_inlier_tmp=num_inlier;
                max_indx_tmp=i;
                inlierindx_Es=inlierindx_tmp;
            end
        end
        if(max_inlier_tmp>max_inlier)
            inlierIndx=inlierindx_Es;
            max_inlier=max_inlier_tmp;
            finalE=PossibleE(:,:,max_indx_tmp);
        end
    end
end
end

