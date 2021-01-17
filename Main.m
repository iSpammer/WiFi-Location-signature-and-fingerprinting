clear;clc;close all
d0=1;             % close-in reference distance
h_user=1;           % the reciever hieght
AP1 = [6,15.5625];
AP2 = [17.5,4];
AP3 = [25.5,15.5625];
AP4 = [33.5,4];
AP5 = [45,15.5625];

Walls=[0,52,0,20;0,0,6,15;6,0,8,15;14,0,8,8;14,8,8,7;22,0,3,15;25,0,2,15;
    27,0,3,15;30,0,8,8;30,8,8,7;38,0,8,15;46,0,6,15;0,15,2,5;2,16.5,4,3.5;
    6,16.5,4,3.5;10,16.5,4,3.5;14,16.5,4,3.5;18,16.5,4,3.5;22,16.5,4,3.5;
    26,16.5,4,3.5;30,16.5,4,3.5;34,16.5,4,3.5;38,16.5,4,3.5;42,16.5,4,3.5];


APs=[AP1;AP2;AP3;AP4;AP5];  % collect the coordinates of the APs in a single matrix
%% Plot the floor figure
figure;
N_blockes=size(Walls,1);        % number of rectangulars in the floor
for i=1:N_blockes           % loop over the rectangulars
    x1=Walls(i,1);y1=Walls(i,2);
    x2=x1+Walls(i,3);y2=y1+Walls(i,4);
    poly = polyshape([x1 x2 x2 x1],[y1 y1 y2 y2]);
    plot(poly);hold on
end
xlim([0 52]);ylim([0 20]);
title('The floor plot')
plot(APs(:,1),APs(:,2),'ks','MarkerSize',10,'MarkerFaceColor',[0,0,0])

%% The Reference points calculation
Ref_points_X=[];          % matrix to store the refernce pionts x coordinations
Ref_points_Y=[];          % matrix to store the refernce pionts y coordinations
X_ref=0.25:0.5:52;      % the possible x coordinates of the reference points
Y_ref=0.25:0.5:20;      % the possible y coordinates of the reference points
for i=1:length(X_ref)             % loop over x-corrdenates
    for j=1:length(Y_ref)            % loop over y-corrdenates
        Ref_points_X(i,j)=X_ref(i);
        Ref_points_Y(i,j)=Y_ref(j);
    end
end

%% Calculate the received power at each reference point from each AP
Pr=[];              % The matrix to store the received power from each AP at each reference point
for i=1:length(X_ref)             % loop over x-corrdenates
    for j=1:length(Y_ref)            % loop over y-corrdenates
        xy_ref=[Ref_points_X(i,j) Ref_points_Y(i,j)];      % the [x,y] coordinates of the reference points
        for k=1:5                   % loop over the APs
            xy_AP=APs(k,:);              % the [x,y] coordinates of the access point
            
            d2=(xy_ref(1)-xy_AP(1))^2+(xy_ref(2)-xy_AP(2))^2+(h_user-3)^2;
            d=sqrt(d2);                 % claculate the distance between the AP and the reference point
            
            N_Partition = Calculate_number_of_wall_loss(Walls,xy_AP,xy_ref);    % calculate number of walls intersect
            PL=Indoor_loss(d,d0,N_Partition);       % calculate the path loss between the AP and the ref point
            
            Pr(i,j,k)=20-PL;          % the received power in dBm
        end
    end
    xy_ref=[Ref_points_X(i,j) Ref_points_Y(i,j)]      % the [x,y] coordinates of the reference points
end

%% Plot the value of the received power
figure
for i=1:5
    subplot(2,3,i);
    contourf(Ref_points_X,Ref_points_Y,Pr(:,:,i));
    title(['Pr in dBm from the AP #' num2str(i) ', at (' num2str(APs(i,1)) ',' num2str(APs(i,2)) ')'])
end
    subplot(2,3,6);
    contourf(Ref_points_X,Ref_points_Y,sum(Pr,3));
    title('Total received power in dBm')

%% Ask the user for the received power from each AP
while(1)
    for i=1:5
        Pr_star(i)=input(['Enter the received power from AP' num2str(i) ' in dBm:  ']);
    end
    
    %% Calculte the distance for each reference point
    for i=1:length(X_ref)             % loop over x-corrdenates
        for j=1:length(Y_ref)            % loop over y-corrdenates
            distance(i,j)=0;
            for k=1:5
                distance(i,j)=distance(i,j)+(Pr(i,j,k)-Pr_star(k))^2;
            end
        end
    end
    
    Min_distance=min(min(distance));    % The minimum distance value
    
    [i,j]=find(distance==Min_distance(1));      % find the location of the minimum
    
    display(['Estimated user location = (' num2str(Ref_points_X(i,j)) ' , ' num2str(Ref_points_Y(i,j)) ')'])
    figure(1)
    plot(Ref_points_X(i,j),Ref_points_Y(i,j),'r*','MarkerSize',10)
    Continue=input('Do you need extra location (y/n)?','s');
    if Continue=='n'
        break
    end
end