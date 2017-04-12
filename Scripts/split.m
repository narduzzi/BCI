function splitted = split(samples,windows_size,step_size)
    shape = size(samples);
    N = shape(2);
    splitted = [];
    

    
    for i=0:N
        idx = i*step_size+1;
        endidx = idx+windows_size-1
        slice = zeros([shape(1),windows_size]);
        if(endidx>N)
            slice = samples(:,idx:N);
        else
            slice = samples(:,idx:endidx);
        end
        splitted = [splitted slice];
    end
    
    