function [matrix_success, rate_success] = user_performance(event)
% Function that determines the success of one whole experiment
%   The function takes as input the double matrix of header.EVENT.TYP, 
%   that contains the type of events throughout the exp. 
%   It gives back as output a matrix "matrix_success" containing the
%   trajectories in columns and the 34 waypoints in lines. A waypoint
%   successfully passed is 1, a waypoint missed is 0. 
%   The other ouput is "rate_success" which contains the rate of success of
%   the different trajectories in line. 


len = length(event);
traj = 0;
success = [];

% Form the success_matrix
for i=1:floor(len/2)
    if(event(2*i) == 1)
        traj = traj + 1;
        suc = [];
    elseif( (event(2*i) == 16) && (event(2*(i-1)) ~= 1) )
        suc(end+1) = 0;
    elseif( event(2*i) == 48 )
        suc(end+1) = 1;
    elseif(event(2*i) == 255)
        success(:,traj) = suc';
    end
end

% Calculate the success rate
for i=1:length(success(1,:))
    rate_success(i) = length(find(success(:,i) == 1))/length(success(:,i));
end
    
matrix_success = success;


% Plot the success rate





end



