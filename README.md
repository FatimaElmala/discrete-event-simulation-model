# discrete-event-simulation-model
 discrete-event simulation model (queuing model) of Airplane and Passenger Boarding in airports. 
 
A simulation model of the passengers boarding process in an airport with two airlines each with two airplanes is studied in this model. The simulation is conducted to help passengers have an easy and organized experience during their boarding process to their desired destination. Since passengers have a high probability of experiencing congestion in airport boarding processes caused by different demand rates at different times. This simulation is conducted based on Queuing systems theories to study the arrival rates, service rates, and waiting times of the passengers in the system. Passengers are divided into business and economy queues where business passengers are prioritized. the model consists of the following four queues: 
1. business queue.
2. luggage queue for business passengers with extra luggage.
3. economy queue.
4. luggage queue for economy passengers with extra luggage. 
the number of servers of the airport is left for the user to input. 


#### Matlab script input constraints: 
Servers number for both airlines must be at least 2; because one server must be assigned for extra luggage passengers. 


#### GUI run steps: 
- first, you need to run the app. 
- Click on generate button to generate random distributions for the economy and business passengers.
- click on increment button to increment time and start the simulation.

#### GUI constraints: 
GUI is built for the case of having 100 passengers and exactly two servers in each airline.

