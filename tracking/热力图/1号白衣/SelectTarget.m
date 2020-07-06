function init_pos = SelectTarget(sImg)
% Select initial position for a target to track
%		init_pos = SelectTarget(sImg)
% Input:
% Output:
%	init_pos - target selected by user (or automatically), it is a 2x3
%		matrix, such that each COLUMN is a point indicating a corner of the target
%		in the first image. Let [p1 p2 p3 p4] be the Four points, they are
%		used to determine the affine parameters of the target, as following
% 			  p1-------------------p3
% 				\					\
% 				 \       target      \
% 				  \                   \
% 				  p2-------------------p4

%%
im	= imread(sImg);
figure;
imshow(im);	hold on;
title(['top-left -> bottom-left -> top-right -> bottom-right'], 'FontSize', 14);
xlabel('Right click after done', 'FontSize', 14);

pos		= zeros(2,4);
btn		= -1;
count	= 0;
while btn~=3
    [x,y,btn]	= ginput(1);
    if btn==1
        if count==5
            imshow(im);	hold on;
            title('top-left -> bottom-left -> top-right -> bottom-right', 'FontSize', 14);
            xlabel('Right click after done', 'FontSize', 14);
        end
        
        count	= mod(count,4)+1;
        pos(1,count)	= y;
        pos(2,count)	= x;
        
        %errorTolerance = 4; %2 pixel error tolerance
        %if(count == 2 &&  pos(1,2) < pos(1,1))%-errorTolerance)
        %    title('Error in selecting the second point. Please start over.', 'Color', 'r', 'FontSize', 14);
        %    return;
        %elseif(count == 3 && (pos(2,3) < pos(2,1)-errorTolerance || pos(1,3) > pos(1,2)+errorTolerance)) %pos(2,3) < pos(2,2)-errorTolerance || 
        %    title('Error in selecting the third point. Please start over.', 'Color', 'r', 'FontSize', 14);
        %    return;
        %end
        
        plot(pos(2,count), pos(1,count), 'r+','LineWidth',2);
        if count==4
            plot(pos(2,1:2), pos(1,1:2),'Color','blue','LineWidth',2);
            plot(pos(2,[1 3]), pos(1,[1 3]),'Color','blue','LineWidth',2);
            plot(pos(2,[2 4]), pos(1,[2 4]),'Color','blue','LineWidth',2);
            plot(pos(2,[3 4]), pos(1,[3 4]),'Color','blue','LineWidth',2);
        end
    end
end

if count==4
    init_pos	= round(pos);
else
    init_pos	= [];
end


