clc;
clear;
%distribution parameters and number of customers
lambda = 10; %per minute 
mu = 5; %per minute 
customer_prompt = "Enter number of passengers: ";
passengers = input(customer_prompt);

%Airlines and Airplanes available, random generation if customer airline
%and airport
airlines = ["Egypt_Air","Saudi_Air"];
c_line= randsample(airlines,passengers,true);
airplanes = ["Plane1","Plane2"];
c_plane = randsample(airplanes,passengers,true);

%Creating luggage assignmnet
luggage = randi(40 ,1,passengers);  

%Creating two distributions for the classes 
%for business class 
b_passengers=0.2*passengers; %number of business 
b_inter_arrival = poissrnd(lambda,1,b_passengers);
b_inter_arrival=b_inter_arrival+1;
b_customer_arrival = cumsum(b_inter_arrival);
b_customer_arrival(1)=1;
b_cus_service_time = exprnd(mu,1,b_passengers);

%for economy class 
E_passengers=0.8*passengers; %number of economy 
E_inter_arrival = poissrnd(lambda,1,E_passengers);
E_inter_arrival=E_inter_arrival+1; 
E_customer_arrival = cumsum(E_inter_arrival);
E_customer_arrival(1)=1;
E_cus_service_time = exprnd(mu,1,E_passengers);

%Creating Empty business and economy queues
b_queue = [];
E_queue = [];
%specific Q for extra luggage 
b_lugg_queue = [];
E_lugg_queue = [];

%Business and Economy customer counters for simulation
b_passenger = 0;
E_passenger = 0;

%Prompting users to enter servers for both Airlines
prompt1 = 'Number of Egypt_Air Servers:';
totalServers1= input(prompt1); 
idle_servers1=totalServers1-1; %intialize all servers as idle at first 
lugg_server1=0; %intializing a special server for luggage 

prompt2 = 'Number of Saudi_Air Servers:';
totalServers2 = input(prompt2);
idle_servers2=totalServers2-1; %intialize all servers as idle at first 
lugg_server2=0; %intializing a special server for luggage 0 for idle and 1 for busy 

%total number of servers 
C=totalServers1+totalServers2;

%timer variable to track time during simulation
time = 0;  

total_wait_Q=0; 
%Calculating simulation time according to last customer in queue
if ((b_customer_arrival(end)+b_cus_service_time(end)) > (E_customer_arrival(end)+E_cus_service_time(end)))
    sim_time = b_customer_arrival(end)+b_cus_service_time(end);
else 
    sim_time = E_customer_arrival(end)+E_cus_service_time(end);
end

sim_time = round(sim_time);


%variables for calculating time stamp at which service ends for a customer
time_service_ends=0;
lugg_time_sevice_ends=0;
%arrays for holding the time stamps of the service ends 
service_ends_servers1=[];
service_ends_servers2=[];
service_ends_lugg1=[];
service_ends_lugg2=[];

pass_wait=0; 
wait_passegers=0;

%simulation process
while(time<=sim_time || ~isempty(b_queue)|| ~isempty(E_queue)|| ~isempty(b_lugg_queue) || ~isempty(E_lugg_queue) || idle_servers1~=(totalServers1-1) || idle_servers2~=(totalServers2-1)||lugg_server1==1 ||lugg_server2==1 )

    time = time+1;
    time
    %when time is equal arrival time of one of the customers 
        %Business Customer Enters
       if(ismember(time,b_customer_arrival))
           b_passenger = b_passenger +1;
           %if luggage does not exceed the Max., the passenger enters
           %business Q
           if(luggage(b_passenger)<=32)
                b_queue = [b_queue b_passenger];
           %if luggage does exceed the Max., the passenger enters
           %business luggage Q
           else 
               b_lugg_queue = [b_lugg_queue b_passenger]; 
           end 
           index = b_passenger;
       end 
       
        %Economy Customer Enters
       if(ismember(time,E_customer_arrival))
           E_passenger = E_passenger +1;
           %if luggage does not exceed the Max., the passenger enters
           %economy Q
           if(luggage(E_passenger)<=23)
               E_queue = [E_queue E_passenger]; 
            %if luggage does exceed the Max., the passenger enters
           %economy luggage Q
           else
               E_lugg_queue = [E_lugg_queue E_passenger]; 
           end 
           index = E_passenger;
       end
       
    %time   %printing current time stamp 
     
   
    %print Qs content for simulation verification
    E_queue 
    b_queue
    E_lugg_queue
    b_lugg_queue
    
    
    
    %Releasing servers when service ends for current customer
     if(~isempty(service_ends_servers2) &&time >= service_ends_servers2(1)) %if time is equal to the time the service ends
         idle_servers2=idle_servers2+1;            %make sever idle
         service_ends_servers2=service_ends_servers2(:,2:end);
     end
     if( ~isempty(service_ends_lugg2) && time >= service_ends_lugg2(1)) %if time is equal to the time the service ends
        lugg_server2=0;            %make sever idle
        service_ends_lugg2=service_ends_lugg2(:,2:end);
     end
     %Releasing servers when service ends for current passenger
     if(~isempty(service_ends_servers1) &&time >= service_ends_servers1(1) ) %if time is equal to the time the service ends
        idle_servers1=idle_servers1+1;            %make sever idle
        service_ends_servers1 = service_ends_servers1(:,2:end);
     end
     if(~isempty(service_ends_lugg1) &&time >= service_ends_lugg1(1)) %if time is equal to the time the service ends
        lugg_server1=0;            %make sever idle
        service_ends_lugg1 = service_ends_lugg1(:,2:end);
     end  
 %$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$   
    %Services customer of Burger_Air Airline for either plane(common terminal)
    if(c_line(index)=="Egypt_Air" && (c_plane(index) == "Plane2" || c_plane(index) == "Plane1")) 
    
      
     %Available Burger Airline server and Both Qs are not empty (Prioritizing Business)
     if(idle_servers1>0 &&  ~isempty(b_queue)&&  ~isempty(E_queue))
         % calcute the service end time 
         time_service_ends = time + b_cus_service_time(b_passenger);
         time_service_ends = round(time_service_ends);
         service_ends_servers1=[service_ends_servers1 time_service_ends];
         
         pass_wait=(time- b_customer_arrival(b_queue(1)));
         if(pass_wait ~=0)
             wait_passegers = wait_passegers +1;
         end 
         total_wait_Q= total_wait_Q+pass_wait; 
         
         b_queue = b_queue(:,2:end); 
         idle_servers1=idle_servers1-1;
         
       
         %Available Burger Airline server, Empty Business Q (Chooses Economy)
    elseif(idle_servers1>0 &&  isempty(b_queue)&&  ~isempty(E_queue))
        % calcute the service end time 
         time_service_ends = time + E_cus_service_time(E_passenger);
         time_service_ends = round(time_service_ends);
         service_ends_servers1=[service_ends_servers1 time_service_ends];
         pass_wait= (time-E_customer_arrival(E_queue(1)));
         if(pass_wait ~=0)
             wait_passegers= wait_passegers+1;
         end 
         total_wait_Q= total_wait_Q+ pass_wait;
         
         E_queue = E_queue(:,2:end); 
         idle_servers1=idle_servers1-1;
         
         
     %Available Burger Airline server, Empty Economy Q (Chooses Business)
     elseif(idle_servers1>0 &&  ~isempty(b_queue)&&  isempty(E_queue))
         % calcute the service end time 
         time_service_ends = time + b_cus_service_time(b_passenger);
         time_service_ends = round(time_service_ends);
         service_ends_servers1=[service_ends_servers1 time_service_ends];
         pass_wait=(time-b_customer_arrival(b_queue(1)));
         if(pass_wait ~=0)
             wait_passegers= wait_passegers+1;
         end 
         total_wait_Q= total_wait_Q+pass_wait;
         b_queue = b_queue(:,2:end); 
         idle_servers1=idle_servers1-1;
         
     end
    
     
     %--------------------------------------
     %luggage handling 
     %there are passengers in both business and economy luggae Qs and the special counter is empty(Prioritizing Business)
     if(lugg_server1==0&& ~isempty(b_lugg_queue) && (~isempty(E_lugg_queue)||isempty(E_lugg_queue)))
         % calcute the service end time 
         lugg_time_sevice_ends = time + b_cus_service_time(b_passenger);
         lugg_time_sevice_ends = round(lugg_time_sevice_ends);
         service_ends_lugg1 = [service_ends_lugg1 lugg_time_sevice_ends];
         pass_wait=(time-b_customer_arrival(b_lugg_queue(1)));
         if(pass_wait ~=0)
             wait_passegers= wait_passegers+1;
         end 
         total_wait_Q= total_wait_Q+pass_wait;
         b_lugg_queue = b_lugg_queue(:,2:end);
         lugg_server1=1;
         
     %there are passengers in economy luggae Q, business luggae Q is empty, and the special counter is empty(Chooses Economy)
     elseif(lugg_server1==0&& isempty(b_lugg_queue) && ~isempty(E_lugg_queue))
         % calcute the service end time 
         lugg_time_sevice_ends = time + E_cus_service_time(E_passenger);
         lugg_time_sevice_ends = round(lugg_time_sevice_ends);
         service_ends_lugg1 = [service_ends_lugg1 lugg_time_sevice_ends];
         pass_wait=(time-E_customer_arrival(E_lugg_queue(1)));
         if(pass_wait ~=0)
             wait_passegers= wait_passegers+1;
         end
         total_wait_Q= total_wait_Q+pass_wait;
         E_lugg_queue = E_lugg_queue(:,2:end);
         lugg_server1=1;
         

     end 
    
     
    end
    
      
     
%$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
    %Services customer of Pizza_Air Airline for either plane(common terminal)
    if(c_line(index)=="Saudi_Air" && (c_plane(index) == "Plane2" || c_plane(index) == "Plane1"))
        %Available Burger Airline server and Both Qs are not empty (Prioritizing Business)
        if(idle_servers2>0 &&  ~isempty(b_queue)&&  ~isempty(E_queue)) 
         time_service_ends = time + b_cus_service_time(b_passenger);
         time_service_ends = round(time_service_ends);
         service_ends_servers2=[service_ends_servers2 time_service_ends];
         pass_wait=(time-b_customer_arrival(b_queue(1)));
         if(pass_wait ~=0)
             wait_passegers= wait_passegers+1;
         end
         total_wait_Q= total_wait_Q+ pass_wait; 
         b_queue = b_queue(:,2:end); 
         idle_servers2=idle_servers2-1;
         

         
        %Available Burger Airline server, Empty Business Q (Chooses Economy)
        elseif(idle_servers2>0 &&  isempty(b_queue)&&  ~isempty(E_queue))
         time_service_ends = time + E_cus_service_time(E_passenger);
         time_service_ends = round(time_service_ends);
         service_ends_servers2=[service_ends_servers2 time_service_ends];
         pass_wait=(time-E_customer_arrival(E_queue(1)));
         if(pass_wait ~=0)
             wait_passegers= wait_passegers+1;
         end
         total_wait_Q= total_wait_Q+pass_wait; 
         E_queue = E_queue(:,2:end); 
         idle_servers2=idle_servers2-1;
        

         
        %Available Burger Airline server, Empty Economy Q (Chooses Business)
        elseif(idle_servers2>0 &&  ~isempty(b_queue)&&  isempty(E_queue))
         time_service_ends = time + b_cus_service_time(b_passenger);
         time_service_ends = round(time_service_ends);
         service_ends_servers2=[service_ends_servers2 time_service_ends];
         pass_wait=(time-b_customer_arrival(b_queue(1)));
         if(pass_wait ~=0)
             wait_passegers= wait_passegers+1;
         end
         total_wait_Q= total_wait_Q+ pass_wait;
         b_queue = b_queue(:,2:end); 
         idle_servers2=idle_servers2-1;
         
        end
        
        
     %---------------------------------------------------------------------------------------
     %luggage handling 
     %there are passengers in both business and economy luggae Qs and the special counter is empty(Prioritizing Business)
     if(lugg_server2==0&& ~isempty(b_lugg_queue) && (~isempty(E_lugg_queue)||isempty(E_lugg_queue)))
         lugg_server2=1;
         lugg_time_sevice_ends = time + b_cus_service_time(b_passenger);
         lugg_time_sevice_ends = round(lugg_time_sevice_ends);
         service_ends_lugg2 = [service_ends_lugg2 lugg_time_sevice_ends];
         pass_wait=(time-b_customer_arrival(b_lugg_queue(1)));
         if(pass_wait ~=0)
             wait_passegers= wait_passegers+1;
         end
         total_wait_Q= total_wait_Q+pass_wait;
         b_lugg_queue = b_lugg_queue(:,2:end);
         
     %there are passengers in economy luggae Q, business luggae Q is empty, and the special counter is empty(Chooses Economy)
     elseif(lugg_server2==0&& isempty(b_lugg_queue) && ~isempty(E_lugg_queue))
         lugg_server2=1;
         lugg_time_sevice_ends = time + E_cus_service_time(E_passenger);
         lugg_time_sevice_ends = round(lugg_time_sevice_ends);
         service_ends_lugg2 = [service_ends_lugg2 lugg_time_sevice_ends];
         pass_wait=(time-E_customer_arrival(E_lugg_queue(1)));
         if(pass_wait ~=0)
             wait_passegers= wait_passegers+1;
         end
         total_wait_Q= total_wait_Q+pass_wait; 
         E_lugg_queue = E_lugg_queue(:,2:end);
         
     end 
    end
    
     total_wait_Q
end
%% Statistics 
%Utilization factor
p = lambda/(mu * C);
p = round(p,5);
disp("Utilization factor is=");
disp(p);

%%The probability that there are zero people or units in the system
syms n
sumterm= symsum(((1/factorial(n))*(lambda/mu)^n),n,0,C-1);
secondterm = ((1/factorial(C))*((lambda/mu)^C))*((C*mu)/(C*mu-lambda));
P0=1/(sumterm+secondterm);
P0=round(P0,5);
disp('The probability that there are zero passengers in the system(P0)=')
disp(P0)

%The average number of units (Customers in the system) L
denominator=factorial(C-1)*(C*mu-lambda)^2;
numerator=lambda*mu*(lambda/mu)^C;
L=(numerator/denominator)*P0+(lambda/mu);
L=round(L,5);
disp('The average number of passengers in the airport (L)=')
disp(L)

%The average time a unit spends in the system 
W=L/lambda;
W=round(W,5);
disp('The average time a passenger spends in the airport (W)=')
disp(W)

%𝑎𝑣𝑒𝑟𝑎𝑔𝑒 𝑛𝑢𝑚𝑏𝑒𝑟 𝑜𝑓 𝑢𝑛𝑖𝑡𝑠 𝑤𝑎𝑖𝑡𝑖𝑛𝑔 𝑖𝑛 𝑡ℎ𝑒 𝑄𝑢𝑒𝑢𝑒 
Lq= L-(lambda/mu);
Lq=round(Lq,5);
disp('avergae number of passsengers waiting in the Queue (Lq)=')
disp(Lq)

% The average time a unit spends waiting in the Queue
Wq=Lq/lambda;
Wq=round(Wq,5);
disp('The average time a unit spends waiting in the Queue (Wq)=')
disp(Wq)


%total wait in Qs
disp('total wait in Qs=')
disp(total_wait_Q)

%total service time 
b_service= round(b_cus_service_time);
E_service= round(E_cus_service_time);
total_service=sum(b_service)+sum(E_service);
disp('total service time:')
disp(total_service)

%passengers who wait
disp('number of passengers who wait')
disp(wait_passegers)

