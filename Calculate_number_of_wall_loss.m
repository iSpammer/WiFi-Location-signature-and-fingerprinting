function [N_Partition, Intersect_points]=Calculate_number_of_wall_loss(Walls,XY1,XY2)
% This function calculates number of walls that is penetrated by the LoS
% propagation from the point at XY1 to the point at XY2

Intersect_points=[];    % empty matrix to store the intersection points
N_blockes=size(Walls,1);        % number of rectangulars in the floor
for i=1:N_blockes           % loop over the rectangulars
    X=[Walls(i,1) Walls(i,1)+Walls(i,3) Walls(i,1)+Walls(i,3) Walls(i,1) Walls(i,1)]; % x coordinates of this rectangular vertices
    Y=[Walls(i,2) Walls(i,2) Walls(i,2)+Walls(i,4) Walls(i,2)+Walls(i,4) Walls(i,2)]; % y coordinates of this rectangular vertices
    
    x2=[XY1(1) XY2(1)];     % x coordinates of this LoS line
    y2=[XY1(2) XY2(2)];     % y coordinates of this LoS line
    
    [x0,y0] = intersections(X,Y,x2,y2);   % calculate the intersection points between this rectangule and the LoS
    
    Intersect_points=[Intersect_points; x0 y0]; % store the intersection points
end

%% remove repeated points
if size(Intersect_points,1)>1  % if there is more than one intersection
    Intersect_points=sortrows(Intersect_points);    % sort the Intersect_points, so the repeated Intersect_points will be adjacent
    change_in_Intersect_pointss=diff(Intersect_points); % the change in adjacent rows
    change_indication=sum(abs(change_in_Intersect_pointss),2);  % summation the difference
    change_indication=[1;change_indication];    % make the first element ~= 0 to keep it
    Intersect_points=Intersect_points(change_indication~=0,:);      % keep the rows which have non zero change with previous Intersect_points
end
%% Calculte number of intersection points
N_Partition=size(Intersect_points,1);