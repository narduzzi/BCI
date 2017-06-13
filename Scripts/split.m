function splitted = split(samples,windows_size,step_size)
    shape = size(samples);
    N = shape(2);
    splitted = [];
    
    sizeidx = round(N/step_size)+1;
    
    trajectory_index = 0;
    
    for i=0:sizeidx
        idx = i*step_size+1;
        endidx = idx+windows_size-1;
        slice = zeros([shape(1)+1,windows_size]);
        if(endidx<=N)
            slice = samples(:,idx:endidx);
           
            if(max(slice)<9*1e3)
                last = trajectory_index;
                slice(shape(1)+1,:) = zeros([1,windows_size])+last;
                splitted = [splitted slice];
            else
                %Seen a 1e4 -> trajectory change
                trajectory_index = trajectory_index + 1;
                %In case the windowing contrains 2 or 3 "1e4" in a row,
                %then the trajectory must not change because it's the same
                %marker, sampled many times
                if(trajectory_index - last > 1)
                    trajectory_index = trajectory_index - 1;
                    disp(fprintf('trajectory index : %0.0f \n', trajectory_index));
                end
            end
        end
    end
