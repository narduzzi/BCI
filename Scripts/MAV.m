function [avg] = MAV(signal)
avg = mean(abs(signal),2);
end