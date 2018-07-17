function [y] = OMP(D,x,K)
% ���������
%       D - �ֵ䣨�����ǹ��걸�ֵ䣩
%       x - �۲��ź�
%       K - �źŵ�ϡ���
% ���������
%       y - ϡ��ϡ�����.

%��ʼ��
y = zeros(size(D,2),size(x,2));             %
index = zeros(1,K);                         %֧����������ʼΪ��
residual = x;                               %�в��ʼΪx

for i = 1 : K
    pro = D' * residual; %�ֵ������в�ĳ˻�
    pos = find(abs(pro)==max(abs(pro)));    %�ҵ��ڻ�����ֵ�����У�����в�����ص���
   
    index(i) = pos(1);                      %��Ѱ�ҵ�������Ϊ֧�������������ź�֧�ż�
    temp = pinv(D(:,index(1:i))) * x;     %��ѡȡ��ԭ�Ӽ���ʩ������������֮����۲��ź�����õ���С���˽�
    residual = x - D(:,index(1:i)) * temp;  %���²в�
    %temp = pinv(D(:,index(i))) * x;     %��ѡȡ��ԭ�Ӽ���ʩ������������֮����۲��ź�����õ���С���˽�
    %residual = x - D(:,index(i)) * temp;  %���²в�
    %residual1 = norm(residual,2);
end
if (~isempty(index))
    y(index,:) = temp;
end
