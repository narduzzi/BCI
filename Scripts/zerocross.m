function[zero] = zerocross(signal)
shape = size(signal);
zero = zeros(shape(1),1);
for j = shape(1)
    for i= 1:length(signal(j,:))-1
        if signal(j,i)>0 && signal(j,i+1) <= 0
            zero = zero+1;
        elseif signal(j,i)<0 && signal(j,i+1) >= 0
            zero = zero +1;
        end
    end
end
end