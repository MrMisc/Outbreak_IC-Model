# Outbreak_(IC Model)
## Introduction | Motivation

The code provided here represents a disease transmission model, primarily focusing on the spread of diseases within a host population. This document serves as an explanation of the key concepts, motivations, and details of the model, shedding light on the thought process behind its creation. 

The primary motivation behind the creation of this disease transmission model is to understand and simulate the dynamics of infectious diseases within a population of hosts, particularly hosts. This type of modeling is valuable for several reasons:

### Epidemiological Understanding
Disease transmission models help epidemiologists and researchers gain insights into how infectious diseases spread, including factors like transmission rates, spatial distribution, and the impact of various parameters.

### Disease Control Strategies
By simulating disease spread, the model can help evaluate and optimize control strategies, such as vaccination, movement restrictions, or biosecurity measures.

### Risk Assessment
Understanding disease dynamics is crucial for assessing the risks associated with different diseases, particularly zoonotic diseases that can pass from animals to humans.

### Scientific Research
Disease transmission models are used for scientific research, allowing researchers to test hypotheses and better understand the biological and ecological factors influencing disease transmission.

## Key Concepts

### Infection and Colonization
This model distinguishes between two important disease-related concepts:infection and colonization
#### Infection
A state in of which a host carries the disease internally. They have some limited potential to spread such a disease. Infected hosts, for instance can undergo fecal shedding (such as for hosts innoculated with Salmonella Enteritidis) for a limited period of time. nfected hosts are identified in the model by setting the infected field to true. Disease transmission, however, DOES NOT occur when infected hosts come into contact with uninfected hosts.

#### Colonization
Colonization represents a more persistent state of infection where the disease-causing agents have established themselves within the host's body or environment. Colonized hosts are identified by setting the colonized field to true. Colonization can have a different impact on disease spread compared to simple infection. This includes via contact (if the user allows it to be possible within the **infection control panel**.

### Transmission Simulation
The model uses the transmit function to simulate the spread of diseases. This function is responsible for calculating the probability of one host infecting another. It considers various factors and conditions when determining whether disease transmission occurs, such as host-to-host contact rules(set by **infection control panel**), spatial boundaries, and more.

## Implementation Details

### Host properties
The model represents individual hosts (hosts) as objects with various properties, including infection status, age, location, and mobility. These properties play a crucial role in disease transmission.

```rust
#[derive(Clone)]
pub struct host{
    infected:bool,
    number_of_times_infected:u32,
    time_infected:f64,
    generation_time:f64,
    colonized:bool,
    motile:u8,
    zone:usize, //Possible zones denoted by ordinal number sequence
    prob1:f64,  //Probability of contracting disease - these are tied to zone if you create using .new() implementation within methods
    prob2:f64,  //standard deviation if required OR second probabiity value for transferring in case that is different from prob1
    x:f64,
    y:f64,
    z:f64, //can be 0 if there is no verticality
    perched:bool,
    age:f64,  //Age of host
    time:f64, //Time host has spent in facility - start from 0.0 from zone 0
    origin_x:u64,
    origin_y:u64,
    origin_z:u64,
    restrict:bool,  //Are the hosts free roaming or not?
    range_x:u64,  //"Internal" GRIDSIZE to simulate caged hosts in side the zone itself, not free roaming within facility ->Now to be taken from Segment
    range_y:u64,  //Same as above but for the y direction
    range_z:u64
}
```


### Host Movements

The code simulates the movement of hosts, considering factors like restrictions on movement, perching and flying. Movement impacts the likelihood of contact between hosts, and is a very regularly overlooked consideration in other extrapolated mathetmatical infectious models. 

```rust
const MAX_MOVE:f64 = 1.0;
const MEAN_MOVE:f64 = 0.5;
const STD_MOVE:f64 = 1.0; // separate movements for Z config
const MAX_MOVE_Z:f64 = 1.0;
const MEAN_MOVE_Z:f64 = 2.0;
const STD_MOVE_Z:f64 = 4.0;
```
The above is a snippet of the code showing where the user is able to adjust the movement parameters of the hosts. Movements are currently following a Gaussian distribution. This can easily be changed to any other distributions thanks to statrs being used in this. 

### Cleaning and Collection

The code includes functions for cleaning the environment and collecting hosts and deposits. These functions influence the removal of hosts from the population based on age and mobility.

```rust
const COLLECT_DEPOSITS: bool = true;
const AGE_OF_DEPOSITCOLLECTION:f64 = 1.0*24.0; //If you were collecting their eggs every day
const FAECAL_CLEANUP_FREQUENCY:usize = 2; //How many times a day do you want faecal matter to be cleaned up?
```

## Conclusion

In conclusion, this disease transmission model was created to simulate and analyze the dynamics of infectious diseases within a population of hosts, particularly chickens. It takes into account both infection and colonization, offering a more comprehensive understanding of disease spread. By exploring the code and its implementation, researchers and epidemiologists can gain valuable insights into the factors influencing disease transmission and make informed decisions about disease control strategies and risk assessment.

Please note that the code and model presented here are highly customizable and can be adapted to specific research questions and scenarios. Researchers can modify parameters and rules to align the model with the characteristics of different diseases and host populations.



