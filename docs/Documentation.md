# Documentation
*Researcher's Guide & Basic User Companion*

## Getting Started

### Overview
This model was developed to explore the dynamics of financial markets by simulating various trading strategies and observing their impacts on market stability. It combines economic theories with computational simulation to offer a comprehensive understanding of market behaviors.

### Requirements
- **NetLogo**: Ensure you have [NetLogo](https://ccl.northwestern.edu/netlogo/) installed. This model was developed and tested in NetLogo. If the specific version is mentioned in your documents, replace 'latest version' with the exact version number.
  
### Installation & Setup Instructions
1. **Install NetLogo**: If you haven't already, download and install NetLogo from the [official website](https://ccl.northwestern.edu/netlogo/download.shtml).
2. **Open NetLogo**: Launch the NetLogo application on your computer.
3. **Load the Model**: Navigate to 'File' > 'Open', and select the `simple-main.nlogo` file you've downloaded.
4. **Required Files**: Ensure that any additional data sets or files mentioned in the model are in the same directory as the `.nlogo` file.
5. **Initialization**: Before running the model, set the desired parameters using the sliders, dropdowns, and input boxes available on the interface. Once your parameters are set, click on the 'Setup' button to initialize the agents and other model components.
6. **Running the Model**: After initialization, click on the 'Go' button to start the simulation. Monitor the plots, graphs, and output displays to observe the results.

For additional help and troubleshooting, refer to the [NetLogo User Manual](https://ccl.northwestern.edu/netlogo/docs/).

Note: For a detailed understanding of each parameter and its implications, refer to the "Deep Dive: Model Formulation & Analysis" section.


## Running the Model: A Basic Guide

[Market Wave Dynamics](https://wolkenmilch.github.io/web-model.html)

### Buttons:
- **Setup**: Click this button first to initialize the model. It sets up the agents and defines the initial conditions based on the parameters set by the sliders and switches.
- **Start**: Once you've set up the model, click this button to begin or continue the simulation. Pressing it again during the simulation will pause or stop the simulation, allowing for intermediate analysis or parameter modification.

### Sliders:
- **perc-talk**: Dictates the percentage of talking agents in the simulation. When set to a certain percentage, an equal number of agents listen, ensuring all agents interact.
- **chart_react_param**: Sets the sensitivity for chartist agents, influencing their reactions to past price trends.
- **fund-react-param**: Determines the reaction parameter for fundamentalist agents, affecting their responses to price deviations from the fundamental value.
- **save-react-param**: Influences how savers adjust their savings in response to market conditions.
- **rand-chart-shocks**, **rand-deviat-fund**, **rand-savings**: Introduce randomness into agent behaviors, accounting for varied strategies within agent groups.
- **return-on-savings**: Sets the rate of return on savings or represents inflation when negative.
- **memory**: Dictates the duration of past data (prices and returns) agents consider in their decisions.

### Switches:
- **save2fund**: Controls the introduction of FOMO behavior in agents, influencing their transition from saving to trading based on market trends.
- **fund2save**: Dictates the conditions under which agents transition from a trading behavior back to saving.

### Plots:
- **Market Participants**: Displays the number of active market participants (fundamentalists + chartists).
- **Traders Inflow**: Shows the inflow of traders into the market.
- **Price-Chart**: Represents asset prices (black), returns (red), and fundamental values (blue) over time.
- **Agent-Weights**: A live bar chart indicating the current influence of different agent types in the market.

For a deeper understanding of each parameter and its implications, as well as the theoretical underpinnings of the model, refer to the accompanying scientific paper and detailed documentation.

## Deep Dive: Model Formulation & Analysis

### Detailed Description of Model Entities, Variables, and Design:

**Entities**:
- **Chartists**: Agents who base their trading decisions on past price trends. They believe that historical price movements can predict future price direction.
- **Fundamentalists**: Agents who trade based on the fundamental value of assets. They believe assets will revert to their intrinsic value over time.
- **Savers**: Not active participants in the market. They hold onto their assets due to various reasons, including risk aversion.

**Variables**:
- **Global Variables**: Influence the entire model or capture global metrics.
- **Agent-specific Variables**: Specific to each agent type, capturing their state, wealth, and decision parameters.
- **Constants**: Fixed values that set initial conditions or fundamental parameters.

**Design**:
The model simulates a financial market with various agent interactions. It aims to capture real-world financial market dynamics, considering behavioral factors and trading strategies.

### Process Overview, Scheduling, Initialization, and Input Data:

**Process Overview**:
The model starts with initialization and progresses with agents making trading decisions, influencing market dynamics.

**Scheduling**:
In each simulation tick:
1. Agents evaluate the market and decide on trading actions.
2. Market prices adjust based on demand and supply.
3. Agents update their states and wealth.
4. Metrics are updated and visualized.

**Initialization**:
On pressing `Setup`:
1. Previous data is cleared.
2. New agents are created based on interface parameters.
3. Initial conditions are set, and agents are prepared for the simulation.

**Input Data**:
The model uses parameters from the interface sliders, switches, and controls to guide the simulation.

### Analytical Walkthrough of the Code:

**Key Procedures**:
1. **Setup**: Initializes the model, setting initial conditions and creating agents.
2. **Go**: The main loop of the simulation, orchestrating agent actions and market updates.
3. **Update-Agents**: Agents update their strategies and states.
4. **Update-Market**: Market state is updated based on aggregate agent decisions.
5. **Update-Metrics**: Global metrics are calculated and updated.

**Flow and Logic**:
The model operates cyclically, with agent decisions influencing the market and vice versa. This feedback loop creates complex behaviors in the simulation.

## FOMO Experiment:

The Fear of Missing Out (FOMO) is a behavioral phenomenon that can greatly influence trading behaviors in financial markets. The model encapsulates this by considering the tendency of savers to transition to active trading roles when they perceive potential market profits.

### Experimental Design:

1. **Parameter Control**: 
   - The model incorporates the `save2fund` switch to simulate the FOMO effect. When this switch is activated, savers have the potential to transition into fundamentalists based on conditions reflecting market opportunities.
   
2. **Baseline Comparison**:
   - A baseline scenario is established by running the model without the FOMO effect (i.e., `save2fund` switch turned off). This scenario aids in understanding the inherent market dynamics without the influence of FOMO.
   
3. **Introduction of FOMO**:
   - In subsequent model runs, FOMO is introduced (with the `save2fund` switch turned on) to study its direct impact on market dynamics compared to the baseline.

### Results & Interpretation:

1. **Increased Market Activity**:
   - With FOMO in play, the model depicts a marked increase in market activity. The number of active traders witnesses a surge due to savers transitioning based on perceived market opportunities.
   
2. **Price Volatility**:
   - The presence of FOMO leads to heightened price volatility, attributed to increased trading and the domino effect of behavioral biases on decision-making.
   
3. **Shift in Agent Composition**:
   - The results highlight a significant shift in agent dynamics, marked by a decrease in savers and an uptick in fundamentalists and chartists, underscoring FOMO's profound impact on market participation.


## Behind the Scenes: NetLogo Procedures

Delving deeper into the model's code, this section provides insights into its logic, flow, and key procedures, complemented by example code snippets from the `simple-main.nlogo` file.

### Main Procedures:

1. **Setup**:
   - This procedure initializes the simulation, setting the stage for the agents and the environment:
     ```netlogo
     to setup
       clear-all
       set-default-shape turtles "circle"
       ; ... [more initialization code]
       reset-ticks
     end
     ```

2. **Go**:
   - Acting as the main loop of the simulation, this procedure orchestrates the flow and interactions of the model:
     ```netlogo
     to go
       if not any? turtles [breed = savers] [stop]
       update-agents
       update-market
       ; ... [more updates and logic]
       tick
     end
     ```

3. **Update-Agents**:
   - Here, each agent evaluates the market conditions, updates their strategies, and decides on potential actions:
     ```netlogo
     to update-agents
       ask turtles
       [
         ; ... [agent-specific updates and logic]
       ]
     end
     ```

4. **Update-Market**:
   - The market's state undergoes adjustments based on the collective decisions and actions of the agents:
     ```netlogo
     to update-market
       ; ... [market update logic]
     end
     ```

### Logic and Flow:

The model's design ensures a sequence where individual agent decisions influence broader market dynamics, which then circle back to influence subsequent agent decisions. This cyclical feedback mechanism is evident in the code structure, where procedures are organized to reflect this interconnected flow.


