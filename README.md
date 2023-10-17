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

## Controls/Parameters

### Spatial Controls

The model divides the environment into spatial zones. Researchers can customize the following aspects related to spatial zones:

#### Number of zones

You can change the number of spatial zones in the model to match the complexity of the environment. More zones allow for a more detailed representation of the spatial distribution of hosts and diseases.

#### Size and Shape

The size and shape of each zone can be adjusted to mimic different environments. For example, you can have large zones for open fields or small, confined zones for indoor spaces.

### Recovery Rates

Recovery rates play a significant role in modeling the dynamics of infectious diseases. Researchers can modify the following:

```rust
const RECOVERY_RATE:[f64;2] = [0.002,0.008]; //Lower and upper range that increases with age
```

which is a linearly increasing recovery rate with age. The gradient is determined by the min and max age that you set here:

```rust
const MEAN_AGE:f64 = 17.0*7.0*24.0; //Mean age of hosts imported (IN HOURS)
const STD_AGE:f64 = 3.0*24.0;//Standard deviation of host age (when using normal distribution)
const MAX_AGE:f64 = 20.0*7.0*24.0; //Maximum age of host accepted (Note: as of now, minimum age is 0.0)
const DEFECATION_RATE:f64 = 6.0; //Number times a day host is expected to defecate
const MIN_AGE:f64 = 1.0*24.0;
```

So the recovery rate is set to be a maximum of the 2nd number in the array set up in RECOVERY_RATE no matter what distribution of ages you provide (Gaussian). 

```rust
    fn recover(mut vector:&mut Vec<host>,rec0:f64,rec1:f64){
        vector.iter_mut().for_each(|mut x| {
            let grad:f64 = (rec1-rec0)/(MAX_AGE - MIN_AGE);
            let prob:f64 = rec0+(x.age-MIN_AGE) * grad;            
            if roll(prob){
                if x.infected && x.motile == 0 && !x.colonized{
                    x.infected = false;
                    x.colonized = false;
                    x.time_infected = 0.0;
                    x.number_of_times_infected = 0;
                    x.generation_time =gamma(ADJUSTED_TIME_TO_COLONIZE[0],ADJUSTED_TIME_TO_COLONIZE[1])*24.0;
                }                 
            }
        })
    }
```

### Colonization Parameters

#### Time to colonize

The time taken for a persistent infection (which has not been recovered from) to lead to a state of "colonized tissue". This is a simplification of how colonization via a disease is done. It is typically on a spectrum, the % of the tissue that has been colonized. However, for simplicity, we have defined a state of having been colonized. This in turn correlates to a definitive feature that the infected host will lay infected consumable deposits (such as eggs). 

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

#### Restriction

Restrictions can also be placed on whether hosts can move out of their individual segments (cages) within each designated zone as well.

```rust
//Restriction?
const RESTRICTION:bool = true;
```
#### Perching or Flying

You can enable or disable perching and flying behavior in hosts. Depending on your scenario, you may choose to represent hosts that can perch or fly between zones.

```rust
//Vertical perches
const PERCH:bool = false;
const PERCH_HEIGHT:f64 = 2.0; //Number to be smaller than segment range z -> Denotes frequency of heights at which hens can perch
const PERCH_FREQ:f64 = 0.15; //probability that chickens go to perch
const DEPERCH_FREQ:f64 = 0.4; //probability that a chicken when already on perch, decides to go down from perch
```
Note that perching and flying has been set to be **mutually exclusive** in this model. A scenario where the hosts fly, cannot be simulated whereby they also perch as of now.

#### Nesting behaviour

Some hosts exhibit proper nesting behaviour in the appropriate spaces. This model has a simple implementation for it.

```rust
//Nesting areas
const NEST:bool = false;
const NESTING_AREA:f64 = 0.25; //ratio of the total area of segment in of which nesting area is designated - min x y z side
```

### Cleaning and Collection

The code includes functions for cleaning the environment and collecting hosts and deposits. These functions influence the removal of hosts from the population based on age and mobility.

```rust
const COLLECT_DEPOSITS: bool = true;
const AGE_OF_DEPOSITCOLLECTION:f64 = 1.0*24.0; //If you were collecting their eggs every day
const FAECAL_CLEANUP_FREQUENCY:usize = 2; //How many times a day do you want faecal matter to be cleaned up?
```

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




## Conclusion

In conclusion, this disease transmission model was created to simulate and analyze the dynamics of infectious diseases within a population of hosts, particularly chickens. It takes into account both infection and colonization, offering a more comprehensive understanding of disease spread. By exploring the code and its implementation, researchers and epidemiologists can gain valuable insights into the factors influencing disease transmission and make informed decisions about disease control strategies and risk assessment.

Please note that the code and model presented here are highly customizable and can be adapted to specific research questions and scenarios. Researchers can modify parameters and rules to align the model with the characteristics of different diseases and host populations.



