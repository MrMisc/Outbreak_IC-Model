# Outbreak_(IC Model)
## Introduction | Motivation

The code provided here represents a disease transmission model, primarily focusing on the spread of diseases within a host population. This document serves as an explanation of the key concepts, motivations, and details of the model, shedding light on the thought process behind its creation. 

The primary motivation behind the creation of this disease transmission model is to understand and simulate the dynamics of infectious diseases within a population of hosts, particularly chickens. This type of modeling is valuable for several reasons:

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
A state in of which a host carries the disease internally. They have some limited potential to spread such a disease. Infected hosts, for instance can undergo fecal shedding (such as for chickens innoculated with Salmonella Enteritidis) for a limited period of time. nfected hosts are identified in the model by setting the infected field to true. Disease transmission, however, DOES NOT occur when infected hosts come into contact with uninfected hosts.

#### Colonization
Colonization represents a more persistent state of infection where the disease-causing agents have established themselves within the host's body or environment. Colonized hosts are identified by setting the colonized field to true. Colonization can have a different impact on disease spread compared to simple infection. This includes via contact (if the user allows it to be possible within the **infection control panel**.

### Transmission Simulation
The model uses the transmit function to simulate the spread of diseases. This function is responsible for calculating the probability of one host infecting another. It considers various factors and conditions when determining whether disease transmission occurs, such as host-to-host contact rules(set by **infection control panel**), spatial boundaries, and more.

## Implementation Details

### Host properties
The model represents individual hosts (chickens) as objects with various properties, including infection status, age, location, and mobility. These properties play a crucial role in disease transmission.

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
    time:f64, //Time chicken has spent in facility - start from 0.0 from zone 0
    origin_x:u64,
    origin_y:u64,
    origin_z:u64,
    restrict:bool,  //Are the hosts free roaming or not?
    range_x:u64,  //"Internal" GRIDSIZE to simulate caged chickens in side the zone itself, not free roaming within facility ->Now to be taken from Segment
    range_y:u64,  //Same as above but for the y direction
    range_z:u64
}
```


