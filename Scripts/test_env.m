'   This is an example to test the splitting (sample epoching)'

matA = zeros([4,10]);
shape = size(matA);
N = shape(2);

for i=1:N
    if(mod(i,2)==1)
        startIDX = 1+i*4;
        if(startIDX>N)
            break
        end
        matA(:,startIDX:startIDX+3) = 1;
    end 
end
windows_size = 4;
step_size = 2;

splitted = split(matA,windows_size,step_size);
matA
splitted

sizeidx = round(N/windows_size)+1;
shape_splitted = size(splitted);
for i=0:sizeidx
    endidx = (i*4+windows_size);
    if(endidx>shape_splitted(2))
        endidx = shape_splitted(2);
        splitted(:,(i*4+1):endidx)
        break
    end
        splitted(:,(i*4+1):endidx)
end
