%%�������ֱ�ʶ��ѡ����С�в���
close all;
clear;
clc;  
addpath(genpath(pwd));
S=load('Indian_pines_corrected.mat');
Hsi=S.indian_pines_corrected;
S=load('Indian_pines_gt.mat');
GroundTure=S.indian_pines_gt;


TotalLabel = length(unique(GroundTure));
Lab=GroundTure;
[M,N]=size(Lab);
Hsi=double(Hsi)./repmat(sqrt(sum(Hsi.^2,3)),[1,1,size(Hsi,3)]);
Hsi0=mybffilter( Hsi ,10);

hsi0=reshape(Hsi0,[M*N,size(Hsi0,3)]);
lab=reshape(Lab,[M*N,1]);
%% 

new11=myvecdctj( hsi0,9,3 );%new12=myvecdctj( hsi0,5,2 );
hsi10=hsi0;
Hsi10=reshape(hsi10,[M,N,size(hsi10,2)]);
hsi20=new11;
Hsi20=reshape(hsi20,[M,N,size(hsi20,2)]);
Hsi0=Hsi;
hsi0=reshape(Hsi0,[M*N,size(Hsi0,3)]);

K = 1;                              %OMP�㷨���źŵ�ϡ���
loopCnt =50;                       %Ϊ��������Զ�����10�Σ����ȡƽ��ֵ
trnnum=5;                        %ÿһ��ѡȡѵ�������ĸ���

clsCnt = TotalLabel-1;                        %���������
clsNum = zeros(1, clsCnt);          %ÿ���������ݵ�������
trnNum = zeros(1, clsCnt);          %ÿ����������ѡ��ѵ�����ݵ�����
tstNum = zeros(1, clsCnt);          %ÿ����������ѡ���������ݵ�����
conMat = zeros(clsCnt,clsCnt);      %�������󣬱���������ݵ�Ԥ�������ʵ�����Ĺ�ϵ
conMat1 = zeros(clsCnt,clsCnt);
conMat2 = zeros(clsCnt,clsCnt);
 for i = 1 : clsCnt
   index = find(lab == i);                 %�ҵ����Ϊi�����ݵ��±�
   clsNum(i) = size(index,1);                   %���Ϊi�����ݵ�������
   %trnNum(i) = ceil(clsNum(i) * trnPer);        %ѡȡ��Ϊѵ������������
   trnNum(i) = trnnum; 
   tstNum(i) = clsNum(i) - trnNum(i);           %ʣ���Ϊ��������������
 end


%��ʼ����
acc=0;acc1=0;acc2=0;OA=0;OA1=0;OA2=0;
for loop = 1 : loopCnt              %�ظ�10��
    lab0=zeros(M*N,1);lab1=zeros(M*N,1);lab2=zeros(M*N,1);
    trnFet0 = [];                        %����ѵ������
    trnFet10 = [];                        %����ѵ������
    trnFet20 = [];                        %����ѵ������
    trnLab0 = [];                        %����ѵ�����ݶ�Ӧ������
    
    trnFet = [];                        %����������ȡ���ѵ������
    trnFet1 = [];                        %����������ȡ���ѵ������
    trnFet2 = [];                        %����������ȡ���ѵ������
    trnLab = [];                        %����ѵ�����ݶ�Ӧ������
    tstFet = [];                        %����������ȡ��Ĳ�������
    tstFet1 = [];                        %����������ȡ��Ĳ�������
    tstFet2 = [];                        %����������ȡ��Ĳ�������
    tstLab = [];                        %����������ݶ�Ӧ������
    %ÿ��������ѡȡ**��Ϊ��������
    index1=[];
    for i = 1 : clsCnt
       index = find(lab == i);                  %�ҵ����Ϊi�����ݵ��±�
       random_index = index(randperm(length(index)));%���Ϊ����˳�����±�����

       index = random_index(1:trnNum(i));            %��������ȡǰ**��Ϊѵ��������index�������ǵ��±�
       index1(:,i)=index(:);
       trnFet0 = [trnFet0 hsi0(index,:)'];         %��ѵ��������������������trnFet����
       %%%%%%%%%%%%%%%%%%%%%%%%
       trnFet10 = [trnFet10 hsi10(index,:)'];         %��ѵ��������������������trnFet����
       trnFet20 = [trnFet20 hsi20(index,:)'];         %��ѵ��������������������trnFet����
       %%%%%%%%%%%%%%%%%%%%%%%%%%%
       
       trnLab0 = [trnLab0 ones(1,length(index))*i];    %��ѵ�������ı����������trnLab����

    end
    %omp֮ǰ���ݲ�ͬ������������ȡ
    le1=30;le2=45;
    newhsi=NWFE_Hsi(Hsi0,trnFet0,trnLab0,le1);
    hsi=reshape(newhsi,[M*N,size(newhsi,3)]);
    newhsi1=NWFE_Hsi(Hsi10,trnFet10,trnLab0,le1);
    hsi1=reshape(newhsi1,[M*N,size(newhsi1,3)]);
    newhsi2=NWFE_Hsi(Hsi20,trnFet20,trnLab0,le2);
    hsi2=reshape(newhsi2,[M*N,size(newhsi2,3)]);
 
    %
    for i = 1 : clsCnt
        
       index(:) = index1(:,i);
       trnFet = [trnFet hsi(index,:)'];         %��ѵ��������������������trnFet����
       trnFet1 = [trnFet1 hsi1(index,:)'];         %��ѵ��������������������trnFet����
       trnFet2 = [trnFet2 hsi2(index,:)'];         %��ѵ��������������������trnFet����
       trnLab = [trnLab ones(1,length(index))*i];    %��ѵ�������ı����������trnLab����
    end 
    %%�ۺϲв���ܼ���������
   %     %��OMP�㷨Ԥ��ѵ�����ݵķ���

    for i = 1 : size(hsi,1)              %��ÿһ����������i��Ԥ��
       if ( lab(i)>0)
       x = hsi(i,:);                     %��ȡ��ĳ������������200ά����x
       x=x';
       sparse = OMP(trnFet,x,K);            %��OMP�㷨�����ϡ��ϵ������
       residual = zeros(1,clsCnt);          %����������ÿ�������ع�����
       for j = 1:1:clsCnt                   %���ò��������ع���ÿһ�����
           index = find(trnLab == j);       %ѡȡ�ֵ������Ϊj������
           
           D_c = trnFet(:,index);  %�ֵ������Ϊj����
           s_c = sparse(index);             %ϡ������б�ӦΪj���λ�õ�ϵ��
          
           temp = x - D_c*s_c;              %
           residual(j) = norm(temp,2);      %�����ع�����
       end
       %residual
       preLab = find(residual == min(residual));     %�ҳ��ع�������С����𣬼�ΪԤ������
       conMat(preLab(1),lab(i)) = conMat(preLab(1),lab(i)) + 1; %����ʵ�������Ԥ���������»�������
       lab0(i)=preLab(1);
       end
    end
    oa=trace(conMat)/sum(conMat(:))
    for i = 1 : clsCnt
    conMat(:,i) = conMat(:,i) ./ (clsNum(i));
    end
   ave_acc = sum(diag(conMat))/clsCnt
   acc=acc+ave_acc;
   OA=OA+oa;
   
   %%%%%%%%%%%
       %��OMP�㷨Ԥ��ѵ�����ݵķ���1

    for i = 1 : size(hsi1,1)              %��ÿһ����������i��Ԥ��
       if ( lab(i)>0)
       x = hsi1(i,:);                     %��ȡ��ĳ������������200ά����x
       x=x';
       sparse = OMP(trnFet1,x,K);            %��OMP�㷨�����ϡ��ϵ������
       residual = zeros(1,clsCnt);          %����������ÿ�������ع�����
       for j = 1:1:clsCnt                   %���ò��������ع���ÿһ�����
           index = find(trnLab == j);       %ѡȡ�ֵ������Ϊj������
           
           D_c = trnFet1(:,index);  %�ֵ������Ϊj����
           s_c = sparse(index);             %ϡ������б�ӦΪj���λ�õ�ϵ��
          
           temp = x - D_c*s_c;              %
           residual(j) = norm(temp,2);      %�����ع�����
       end
       %residual
       preLab = find(residual == min(residual));     %�ҳ��ع�������С����𣬼�ΪԤ������
       conMat1(preLab(1),lab(i)) = conMat1(preLab(1),lab(i)) + 1; %����ʵ�������Ԥ���������»�������
       lab1(i)=preLab(1);
       end
    end
    oa1=trace(conMat1)/sum(conMat1(:))
    for i = 1 : clsCnt
    conMat1(:,i) = conMat1(:,i) ./ (clsNum(i));
    end
   ave_acc1 = sum(diag(conMat1))/clsCnt
   acc1=acc1+ave_acc1;
   OA1=OA1+oa1;
   %%%%%%%%%%%
       %��OMP�㷨Ԥ��ѵ�����ݵķ���2

    for i = 1 : size(hsi2,1)              %��ÿһ����������i��Ԥ��
       if ( lab(i)>0)
       x = hsi2(i,:);                     %��ȡ��ĳ������������200ά����x
       x=x';
       sparse = OMP(trnFet2,x,K);            %��OMP�㷨�����ϡ��ϵ������
       residual = zeros(1,clsCnt);          %����������ÿ�������ع�����
       for j = 1:1:clsCnt                   %���ò��������ع���ÿһ�����
           index = find(trnLab == j);       %ѡȡ�ֵ������Ϊj������
           
           D_c = trnFet2(:,index);  %�ֵ������Ϊj����
           s_c = sparse(index);             %ϡ������б�ӦΪj���λ�õ�ϵ��
          
           temp = x - D_c*s_c;              %
           residual(j) = norm(temp,2);      %�����ع�����
       end
       %residual
       preLab = find(residual == min(residual));     %�ҳ��ع�������С����𣬼�ΪԤ������
       conMat2(preLab(1),lab(i)) = conMat2(preLab(1),lab(i)) + 1; %����ʵ�������Ԥ���������»�������
       lab2(i)=preLab(1);
       end
    end
    oa2=trace(conMat2)/sum(conMat2(:))
    for i = 1 : clsCnt
    conMat2(:,i) = conMat2(:,i) ./ (clsNum(i));
    end
   
   ave_acc2 = sum(diag(conMat2))/clsCnt
   acc2=acc2+ave_acc2;
   OA2=OA2+oa2;
   loop
Lab0=reshape(lab0,[M,N,size(lab0,2)]);
Lab1=reshape(lab1,[M,N,size(lab1,2)]);
Lab2=reshape(lab2,[M,N,size(lab2,2)]);
%colorMap = rand(TotalLabel,3)
colorMap = [0.0034    0.7655    0.5616
    0.3167    0.7986    0.7129
    0.6999    0.6363    0.9708
    0.2553    0.2556    0.9160
    0.3135    0.0015    0.3834
    0.2940    0.8495    0.2898
    0.5776    0.6748    0.2754
    0.4261    0.0205    0.7786
    0.5287    0.3347    0.3878
    0.9195    0.7659    0.8520
    0.0380    0.5160    0.8518
    0.4288    0.0194    0.2332
    0.1106    0.3200    0.2896
    0.2265    0.4587    0.1553
    0.1646    0.5545    0.9827
    0.4627    0.5080    0.8313
    0.3460    0.6672    0.5999
];
colorMap(1,:)=0;
img = zeros(M,N);
img(:) = GroundTure;
figure;
subplot 221;
imshow(img,colorMap);
title('original image');
img(:)= Lab0;
subplot 222;
imshow(img,colorMap);
title('recognized image0');
img(:)= Lab1;
subplot 223;
imshow(img,colorMap);
title('recognized image1');
img(:)= Lab2;
subplot 224;
imshow(img,colorMap);
title('recognized image2');

end

acc=acc/loopCnt 
acc1=acc1/loopCnt 
acc2=acc2/loopCnt 
OA=OA/loopCnt
OA1=OA1/loopCnt
OA2=OA2/loopCnt
%printConMat(conMat);
