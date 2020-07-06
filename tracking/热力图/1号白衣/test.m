clear all;
close all;
load hh_mat.mat new_pos
xx = new_pos(:,1);  
yy = 90-new_pos(:,2);  
gridSize = 13;  
% 选择colormap  
colormap(summer);  
  
% 建立网格  
x=linspace(1,120,gridSize);  
y=linspace(1,100,gridSize);  
gridEval = zeros(length(x)-1,length(y)-1);  
  
% 计算每个网格中点的频数  
for cnt_x=1:length(x)-1  
    for cnt_y=1:length(y)-1  
        x_ind=intersect(find(xx>x(cnt_x)),find(xx<=x(cnt_x+1)));                                                      
        xy_ind=intersect(find(yy(x_ind)>y(cnt_y)), find(yy(x_ind)<=y(cnt_y+1)));       
        gridEval(cnt_y, cnt_x)=length(xy_ind);  
    end  
end  
  
% surface函数绘制热图  
surf((x(1:end-1)+ x(2:end))/2,(y(1:end-1)+y(2:end))/2,gridEval); view(2);   
shading interp;  hold on;  
axis([min(xx),max(xx) min(yy),max(yy)]);  
  
% 添加标注  
title(['密度图, 网格大小: ' num2str(gridSize) ' x ' num2str(gridSize) ' 个网格'],'Fontsize',14);  
xlabel('x','Fontsize',14);  
ylabel('y','Fontsize',14);  
axis tight;  
h1 = gca; % 保存句柄，以便后面添加边框  
  
% 添加颜色条  
h=colorbar;  
axes(h);ylabel('密度, 每个网格的点数','Fontsize',14);  
set(gcf,'color',[1 1 1],'paperpositionmode','auto');  
  
% 添加黑色的边框  
axes(h1);  
line(get(gca,'xlim'),repmat(min(get(gca,'ylim')),1,2),'color',[0 0 0],'linewidth',1);  
line(get(gca,'xlim'),repmat(max(get(gca,'ylim')),1,2),'color',[0 0 0],'linewidth',2);  
line(repmat(min(get(gca,'xlim')),1,2),get(gca,'ylim'),'color',[0 0 0],'linewidth',2);  
line(repmat(max(get(gca,'xlim')),1,2),get(gca,'ylim'),'color',[0 0 0],'linewidth',1); 