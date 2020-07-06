a=[2,10,20,30,40,50;15,25,35,45,20,22]
figure(1)
imshow(ones(120,90))
figure(2)
imshow(ones(120,90))
for x = 1: 6
    if mod(x,2) == 0
        figure(1)
        hold on
        plot(a(1,x),a(2,x),'r*')
    else
        figure(2)
        hold on
        plot(a(1,x),a(2,x),'r*')
    end
    pause(3)
end
    
    
    
