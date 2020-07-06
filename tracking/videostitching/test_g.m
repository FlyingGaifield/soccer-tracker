dirtest = dir('result');
for x = 1:size(dirtest,1)
    oldname=files(i).name;
    newname=strcat('RH_', oldname);
    command = ['rename' 32 oldname 32 newname];
end
