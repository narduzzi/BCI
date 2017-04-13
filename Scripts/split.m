function splitted = split(samples,windows_size,step_size)
    shape = size(samples);
    N = shape(2);
    splitted = [];
    
    sizeidx = round(N/step_size)+1;
    
    for i=0:sizeidx
        idx = i*step_size+1;
        endidx = idx+windows_size-1
        slice = zeros([shape(1),windows_size]);
        if(endidx<=N)
            slice = samples(:,idx:endidx);
            splitted = [splitted slice];
        %else
            %slice = samples(:,idx:endidx);
        end
    end
    
    