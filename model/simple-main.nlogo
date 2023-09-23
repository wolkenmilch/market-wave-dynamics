; Define local attributes for each patch (agent) in the simulation.
patches-own[
  strategy   ; The trading strategy adopted by the agent: 1 for Saving, 2 for Fundamental Trading, and 3 for Chart Trading.
  indicator  ; Binary indicator denoting whether a patch is participating (1) or not (0) in the market.
]

globals[
  price                   ; current price in the market
  abs-price               ; absolute value of the current price (seems unused in the provided code)
  last-price              ; price from the last tick or time step
  last-price2             ; price from two ticks or time steps ago
  F                       ; variable related to fundamental price or value (exact meaning might require further context)
  F2                      ; previous value of the fundamental price or value
  returns                 ; returns calculated based on the price change
  str-random              ; random number for initial strategy selection
  talks-done              ; number of executed talks per tick
  talker-strategy         ; strategy of the agent currently talking
  talks-per-round         ; number of talks that happen in one tick or round

  alpha                   ; random term for price adjustment (might represent price shocks)
  beta                    ; random term affecting chartist orders
  sigma                   ; random term affecting saving strategy orders
  yota                    ; random term affecting fundamentalist orders

  securities              ; orders based on saving strategy
  securities2             ; previous value of saving strategy orders
  securities3             ; value of saving strategy orders two ticks ago
  chart-orders            ; orders based on chartist strategy
  chart-orders2           ; previous value of chartist strategy orders
  chart-orders3           ; value of chartist strategy orders two ticks ago
  fund-orders             ; orders based on fundamentalist strategy
  fund-orders2            ; previous value of fundamentalist strategy orders
  fund-orders3            ; value of fundamentalist strategy orders two ticks ago
  all-orders              ; combined orders from all strategies

  N                       ; total number of active agents (not using strategy 0)
  NN                      ; combined count of chartist and fundamentalist agents
  NN2                     ; previous combined count of chartist and fundamentalist agents
  NN3                     ; combined count of chartist and fundamentalist agents from two ticks ago
  N-save                  ; count of agents using saving strategy
  N2-save                 ; previous count of agents using saving strategy
  N-fund                  ; count of agents using fundamentalist strategy
  N2-fund                 ; previous count of agents using fundamentalist strategy
  N-chart                 ; count of agents using chartist strategy
  N2-chart                ; previous count of agents using chartist strategy

  W-save                  ; weight or proportion of agents using saving strategy
  W-fund                  ; weight or proportion of agents using fundamentalist strategy
  W-chart                 ; weight or proportion of agents using chartist strategy

  fit-chart2              ; previous fitness value of chartist strategy
  fit-chart               ; current fitness value of chartist strategy
  fit-fund2               ; previous fitness value of fundamentalist strategy
  fit-fund                ; current fitness value of fundamentalist strategy
  fit-save2               ; previous fitness value of saving strategy
  fit-save                ; current fitness value of saving strategy

  prob-change-chart-fund  ; probability of a chartist changing to fundamentalist strategy
  prob-change-fund-chart  ; probability of a fundamentalist changing to chartist strategy
  prob-change-chart-save  ; probability of a chartist changing to saving strategy
  prob-change-save-chart  ; probability of a saver changing to chartist strategy
  prob-change-fund-save   ; probability of a fundamentalist changing to saving strategy
  prob-change-save-fund   ; probability of a saver changing to fundamentalist strategy

  trans-prob-chart-save   ; transition probability of a chartist changing to saving strategy
  trans-prob-chart-fund   ; transition probability of a chartist changing to fundamentalist strategy
  trans-prob-save-chart   ; transition probability of a saver changing to chartist strategy
  trans-prob-save-fund    ; transition probability of a saver changing to fundamentalist strategy
  trans-prob-fund-save    ; transition probability of a fundamentalist changing to saving strategy
  trans-prob-fund-chart   ; transition probability of a fundamentalist changing to chartist strategy

  trans-prob              ; combined transition probabilities from all strategies
  min-trans-prob          ; minimum transition probability allowed in the model
]

; The `setup` procedure initializes the model, setting up its initial state.
to setup
  ; Clear the world, removing all turtles, links, and patch variables.
  clear-all
  ; Clear all plots to prepare them for fresh data.
  clear-all-plots
  ; Call the procedure to set up the traders in the model.
  setup-traders

  ; Count and set the number of patches where the strategy is not 0 (i.e., inactive).
  set N sum [indicator] of patches with [not (strategy = 0)]
  ; Count and set the number of patches where the strategy is 3 (chartists).
  set N-chart sum [indicator] of patches with [strategy = 3]
  ; Count and set the number of patches where the strategy is 2 (fundamentalists).
  set N-fund sum [indicator] of patches with [strategy = 2]
  ; Count and set the number of patches where the strategy is 1 (savers).
  set N-save sum [indicator] of patches with [strategy = 1]
  ; Calculate the sum of chartists and fundamentalists.
  set NN  (N-chart +  N-fund)
  ; Set NN2 and NN3 to the value of NN. The purpose is not clear without context.
  set NN2 NN
  set NN3 NN2
  ; Initialize secondary counts for savers, fundamentalists, and chartists to 0.
  set N2-save 0
  set N2-fund 0
  set N2-chart 0

  ; Set the minimum transition probability based on the total number of patches.
  set min-trans-prob 3 / count patches
  ; Calculate the number of talks per round based on a parameter (`perc-talk`) and the total number of patches.
  set talks-per-round (perc-talk / 200) * count patches

  ; Initialize price-related and order-related variables to 0.
  set F 0
  set F2 F
  set returns 0
  set price F
  set abs-price 0
  set last-price F
  set last-price2 F
  set securities 0
  set securities2 0
  set securities3 0
  set chart-orders 0
  set chart-orders2 0
  set chart-orders3 0
  set fund-orders 0
  set fund-orders2 0
  set fund-orders3 0
  set all-orders 0

  ; Initialize the weights of the different strategies to 0.
  set W-save 0
  set W-fund 0
  set W-chart 0

  ; Initialize fitness values for different strategies to 0.
  set fit-chart2 0
  set fit-chart 0
  set fit-fund2 0
  set fit-fund 0
  set fit-save2 0
  set fit-save 0

  ; Reset the tick counter to 0.
  reset-ticks
end

; The `setup-traders` procedure initializes each patch to represent a trader with a specific strategy.
to setup-traders
  ; For each patch, assign a strategy based on a random value.
  ask patches
    [
    ; Initially, set the patch's indicator to 1.
    set indicator  1
    ; Generate a random float between 0 and 1.
    set str-random (random-float 1.0)
    ; Assign strategies based on the value of the random float:
    ; If less than 1/3, it's a saver (green).
    ; If between 1/3 and 2/3, it's a chartist (red).
    ; Otherwise, it's a fundamentalist (blue).
    ifelse str-random < (1 / 3)
      [ set strategy 1
        set pcolor green]
      [ ifelse str-random < (2 / 3)
        [ set strategy 3
          set pcolor red]
        [ set strategy 2
          set pcolor blue]
      ]
    ]
end

; This is the main loop of the simulation.
to go
  ; Stop the simulation when the predefined number of steps is reached.
  if ticks >= steps [stop]

  ; After the initial two ticks (time steps), agents begin the talk-and-learn process.
  if ticks >  2 [talk-and-learn]

  ; Execute the market mechanics that include order calculation, weight calculation, price mechanics, fitness calculation, and strategy change probability calculation.
  market-mechanics

  ; Advance the simulation clock by one tick (time step).
  tick
end

; This procedure defines the main operations that happen in the market every tick.
to market-mechanics
  ; Calculate the orders based on the strategies of agents and market conditions.
  calculate-orders

  ; Calculate the weights or proportions of each strategy in the market.
  calculate-weights

  ; Determine the price changes in the market.
  price-mechanics

  ; Calculate the fitness of each strategy based on their performance.
  calculate-fitness

  ; Determine the probability of agents changing their strategies based on their fitness.
  change-probability
end

; The talk-and-learn procedure allows agents to communicate with each other.
; Agents will share their strategies and, based on certain conditions,
; might adapt the strategies of the agents they communicate with.
to talk-and-learn

  ; Initialize the number of talks done in this round to zero.
  set talks-done 0

  ; Continue the process until the desired number of talks-per-round is achieved.
  while [talks-per-round >= talks-done]
  [
    ; Randomly select a listening agent (patch).
    ask patch random-xcor random-ycor
    [
      ; Randomly select another agent and get its strategy to be the talking agent's strategy.
      set talker-strategy [strategy] of patch random-xcor random-ycor

      ; Check if the listening and talking agents have different strategies.
      if not (strategy = talker-strategy)
      [
        ; If the talking agent's strategy is "Saving".
        if talker-strategy = 1
        [
          ; Check conditions to see if a Fundamentalist agent should adopt the Saving strategy.
          if strategy = 2 and (fit-save > fit-fund) and (trans-prob-fund-save > min-trans-prob) and (fund2save = True)
          [
            set strategy 1     ; Change strategy to Saving.
            set pcolor green   ; Update agent color to green for visualization.
          ]

          ; Check conditions to see if a Chartist agent should adopt the Saving strategy.
          if strategy = 3 and (fit-save > fit-chart) and (trans-prob-chart-save  >  min-trans-prob)
          [
            set strategy 1     ; Change strategy to Saving.
            set pcolor green   ; Update agent color to green for visualization.
          ]
        ]

        ; If the talking agent's strategy is "Fundamental Trading".
        if talker-strategy = 2
        [
          ; Check conditions to see if a Saver agent should adopt the Fundamental Trading strategy.
          if strategy = 1 and (fit-fund > fit-save) and (trans-prob-save-fund > min-trans-prob) and (save2fund = True)
          [
            set strategy 2     ; Change strategy to Fundamental Trading.
            set pcolor blue    ; Update agent color to blue for visualization.
          ]

          ; Check conditions to see if a Chartist agent should adopt the Fundamental Trading strategy.
          if strategy = 3 and (fit-fund > fit-chart) and (trans-prob-chart-fund > min-trans-prob)
          [
            set strategy 2     ; Change strategy to Fundamental Trading.
            set pcolor blue    ; Update agent color to blue for visualization.
          ]
        ]

        ; If the talking agent's strategy is "Chart Trading".
        if talker-strategy = 3
        [
          ; Check conditions to see if a Saver agent should adopt the Chart Trading strategy.
          if strategy = 1 and (fit-chart > fit-save) and (trans-prob-save-chart > min-trans-prob)
          [
            set strategy 3     ; Change strategy to Chart Trading.
            set pcolor red     ; Update agent color to red for visualization.
          ]

          ; Check conditions to see if a Fundamentalist agent should adopt the Chart Trading strategy.
          if strategy = 2 and (fit-chart > fit-fund) and (trans-prob-fund-chart > min-trans-prob)
          [
            set strategy 3     ; Change strategy to Chart Trading.
            set pcolor red     ; Update agent color to red for visualization.
          ]
        ]
      ]
    ]

    ; Increment the talks-done counter.
    set talks-done talks-done + 1
  ]
end

; Function to calculate orders based on strategies and random variables
to calculate-orders
  ; Generate random variables influencing chartist, fundamentalist, and saver behavior
  set beta   random-normal 0  rand-chart-shocks  ; Random shock for chartists
  set yota   random-normal 0  rand-deviat-fund   ; Random deviation for fundamentalists
  set sigma  random-normal 0  rand-savings       ; Random factor for savers

  ; Calculate the security orders for savers
  set securities3 securities2
  set securities2 securities
  set securities (save-react-param * return-on-savings) + sigma

  ; Calculate the orders for chartists
  set chart-orders3 chart-orders2
  set chart-orders2 chart-orders
  set chart-orders (chart_react_param *  (price - last-price) + beta)

  ; Calculate the orders for fundamentalists
  set fund-orders3 fund-orders2
  set fund-orders2 fund-orders
  set fund-orders (fund-react-param * (F - price) + yota)

  ; Calculate the sum of absolute orders from chartists and fundamentalists
  set all-orders (abs chart-orders + abs fund-orders)
end

; Function to calculate weights based on the number of agents following each strategy
to calculate-weights
  ; Count the number of agents with non-zero strategy
  set N sum [indicator] of patches with [not (strategy = 0)]

  ; Count the number of chartists and calculate their proportion
  set N2-chart N-chart
  set N-chart sum [indicator] of patches with [strategy = 3]
  set W-chart (N-chart / N)

  ; Count the number of fundamentalists and calculate their proportion
  set N2-fund N-fund
  set N-fund sum [indicator] of patches with [strategy = 2]
  set W-fund (N-fund / N)

  ; Count the number of savers and calculate their proportion
  set N2-save N-save
  set N-save sum [indicator] of patches with [strategy = 1]
  set W-save (N-save / N)

  ; Calculate the sum of chartists and fundamentalists
  set NN2 NN
  set NN3 NN2
  set NN (N2-chart + N2-fund)
end

; Function to update price based on current orders and random fluctuations
to price-mechanics
  ; Generate random price fluctuation factor
  set alpha  random-normal 0 0.0025

  ; Update price based on the previous price, chart and fundamental orders, and the random factor
  set last-price2 last-price
  set last-price price
  set F2 F
  set price (last-price + (chart-orders * W-chart + fund-orders * W-fund) + alpha)

  ; Calculate returns based on the price change
  ifelse last-price = 0
  [set returns 0.0]
  [set returns (price - last-price)]
end

; Function to calculate the fitness of each strategy
to calculate-fitness
  ; Calculate the fitness of chartists based on price change and past fitness
  set fit-chart2 fit-chart
  set fit-chart (((exp price) - (exp last-price)) * chart-orders3 + memory * fit-chart2)

  ; Calculate the fitness of fundamentalists based on price change and past fitness
  set fit-fund2 fit-fund
  set fit-fund (((exp price) - (exp last-price)) * fund-orders3 + memory * fit-fund2)

  ; Calculate the fitness of savers based on returns on savings and past fitness
  set fit-save2 fit-save
  set fit-save  ((exp return-on-savings) * securities3 + memory * fit-save2)
end

; Determine the probability of changing strategies based on the fitness of each strategy
to change-probability

  ; Compare fitness of chartists and fundamentalists
  ; If chartists are more fit, they're less likely to become fundamentalists and vice versa
  let prob_talk_change 0.45
  if (fit-chart > fit-fund)
  [
    set prob-change-chart-fund 0.5 - prob_talk_change ; Decrease the probability for chartists to become fundamentalists
    set prob-change-fund-chart 0.5 + prob_talk_change ; Increase the probability for fundamentalists to become chartists
  ]
  if (fit-fund > fit-chart)
  [
    set prob-change-chart-fund 0.5 + prob_talk_change ; Increase the probability for chartists to become fundamentalists
    set prob-change-fund-chart 0.5 - prob_talk_change ; Decrease the probability for fundamentalists to become chartists
  ]

  ; Compare fitness of chartists and savers
  ; If chartists are more fit, they're less likely to become savers and vice versa
  if (fit-chart > fit-save)
  [
    set prob-change-chart-save 0.5 - prob_talk_change ; Decrease the probability for chartists to become savers
    set prob-change-save-chart 0.5 + prob_talk_change ; Increase the probability for savers to become chartists
  ]
  if (fit-save > fit-chart)
  [
    set prob-change-chart-save 0.5 + prob_talk_change ; Increase the probability for chartists to become savers
    set prob-change-save-chart 0.5 - prob_talk_change ; Decrease the probability for savers to become chartists
  ]

  ; Compare fitness of savers and fundamentalists
  ; If savers are more fit, they're less likely to become fundamentalists and vice versa
  if (fit-save > fit-fund)
  [
    set prob-change-fund-save 0.5 + prob_talk_change ; Increase the probability for fundamentalists to become savers
    set prob-change-save-fund 0.5 - prob_talk_change ; Decrease the probability for savers to become fundamentalists
  ]
  if (fit-fund > fit-save)
  [
    set prob-change-fund-save 0.5 - prob_talk_change ; Decrease the probability for fundamentalists to become savers
    set prob-change-save-fund 0.5 + prob_talk_change ; Increase the probability for savers to become fundamentalists
  ]

  ; Calculate transition probabilities for agents to switch strategies
  ; This is based on current strategy weights and change probabilities
  let prob-indep-change 0.1
  set trans-prob-chart-save (W-chart * (prob-indep-change + prob-change-chart-save * W-save))
  set trans-prob-chart-fund (W-chart * (prob-indep-change + prob-change-chart-fund * W-fund))
  set trans-prob-save-chart (W-save * (prob-indep-change + prob-change-save-chart * W-chart))
  set trans-prob-save-fund (W-save * (prob-indep-change + prob-change-save-fund * W-fund))
  set trans-prob-fund-save (W-fund * (prob-indep-change + prob-change-fund-save * W-save))
  set trans-prob-fund-chart (W-fund * (prob-indep-change + prob-change-fund-chart * W-chart))

  ; Calculate the sum of all transition probabilities to give an overall view of strategy shifts in the market
  set trans-prob ( trans-prob-chart-save + trans-prob-chart-fund + trans-prob-save-chart +
                   trans-prob-save-fund + trans-prob-fund-save + trans-prob-fund-chart )
end
@#$#@#$#@
GRAPHICS-WINDOW
536
254
736
455
-1
-1
27.5
1
10
1
1
1
0
1
1
1
0
6
0
6
1
1
1
ticks
30.0

BUTTON
6
46
89
79
Start
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
6
10
89
43
Setup
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
7
96
180
129
perc-talk
perc-talk
1
50
7.0
1
1
%
HORIZONTAL

SLIDER
136
276
169
436
return-on-savings
return-on-savings
-0.05
0.05
-0.02
0.01
1
NIL
VERTICAL

PLOT
185
130
843
250
Price-Chart
time
price
0.0
1000.0
0.0
0.0
true
true
"" ""
PENS
"log price" 1.0 0 -16777216 true "" "plot price"
"fund price" 1.0 0 -11221820 true "" "plot F"
"returns" 1.0 0 -2674135 true "" "plot returns"

PLOT
186
252
346
400
Agent-Weights
time
weight
0.0
1000.0
0.0
0.0
true
false
"set-plot-x-range 1 4\nset-plot-y-range 0 count patches\n;set-histogram-num-bars 3" ""
PENS
"savers" 1.0 1 -14439633 true "" "histogram filter[s -> s = 1] [strategy] of patches"
"fundis" 1.0 1 -14070903 true "" "histogram filter[s -> s = 3] [strategy] of patches"
"chartis" 1.0 1 -5298144 true "" "histogram filter[s -> s = 2] [strategy] of patches"
"diff" 1.0 0 -16777216 true "" ""

SLIDER
6
225
179
258
save-react-param
save-react-param
0.005
0.1
0.01
0.005
1
NIL
HORIZONTAL

INPUTBOX
100
11
168
79
steps
5002.0
1
0
Number

PLOT
185
10
526
130
Market Participants
NIL
Count
0.0
1000.0
0.0
0.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" "plot (n-chart + n-fund)"

PLOT
527
10
843
130
Traders Inflow
time
diff
0.0
1000.0
0.0
0.0
true
false
"" ""
PENS
"flow" 1.0 0 -16777216 true "" "plot NN - NN2"

SWITCH
365
300
486
333
save2fund
save2fund
0
1
-1000

SWITCH
365
333
486
366
fund2save
fund2save
0
1
-1000

SLIDER
9
275
42
435
rand-chart-shocks
rand-chart-shocks
0.005
0.1
0.05
0.005
1
NIL
VERTICAL

SLIDER
48
275
81
435
rand-deviat-fund
rand-deviat-fund
0.005
0.01
0.007
0.001
1
NIL
VERTICAL

SLIDER
7
137
178
170
chart_react_param
chart_react_param
0.01
0.1
0.07
0.01
1
NIL
HORIZONTAL

SLIDER
7
180
178
213
fund-react-param
fund-react-param
0.01
0.1
0.01
0.01
1
NIL
HORIZONTAL

SLIDER
1
444
173
477
memory
memory
0.05
1
0.5
0.05
1
NIL
HORIZONTAL

SLIDER
97
276
130
436
rand-savings
rand-savings
0
0.01
0.002
0.001
1
NIL
VERTICAL

@#$#@#$#@
## WHAT IS IT?

Dive into the intricate world of financial markets! This model, inspired by the bustling realm of Bitcoin trading, simulates how individuals decide their financial strategies. From cautious savers to strategic traders, we explore how each player influences market dynamics. The model introduces a unique agent, the 'saver', who doesn't trade but holds onto their savings. By studying behaviors like the 'Fear of Missing Out' (FOMO), we aim to understand the inflow of new investors and its impact on market prices. As waves of new investors pour into the market, the dynamics of price changes become more pronounced, leading to intriguing fluctuations and trends. Whether you're intrigued by the complexity of Bitcoin bubbles or the subtle dance of supply and demand, this simulation offers a window into the world of financial ebbs and flows.



## HOW IT WORKS

Imagine a financial playground, bustling with activity, strategies, and interactions. Here's the breakdown:  


- **Agents & Their Roles:** 
    - Our model world is inhabited by a diverse set of agents, each with their own financial strategy. These agents can be broadly categorized into:
        - **Savers:** These are conservative agents who do not actively trade but hold onto their savings, earning a fixed return each period.
        - **Fundamentalists:** Experienced traders who base their decisions on the fundamental value of assets.
        - **Chartists (Technical Traders):** Those who use past price trends to make future trading decisions.  
</br>

- **Interactions & Dynamics:**
    - Agents decide their trading or saving strategy based on a set of rules and conditions. They can switch strategies based on interactions with other agents, market dynamics, and their own past experiences.
    - Fear of Missing Out (FOMO) plays a crucial role. Seeing others profit can spur agents to dive into the market, leading to waves of new investors.  
</br>

- **Market Behavior & Price Dynamics:** 
    - The market price changes based on trading orders from chartists and fundamentalists. Savers introduce market in- and outflows, affecting overall market volatility.
    - Price inefficiencies can arise due to behavioral patterns. For instance, when savers dominate, prices might not revert to the fundamental value but remain stable until other agents take the lead.  
</br>


## HOW TO USE IT

This model provides an interactive simulation to understand the behavior of financial agents in a market scenario inspired by Bitcoin trading dynamics. The interface consists of several controls that allow you to manipulate the agents' behaviors, market conditions, and view the results in real-time.

### Controls:

1. **Buttons**:
    - **Setup**: Click this button to initialize the model with the specified parameters.
    - **Start**: Begins the simulation. Once clicked, the agents will start their trading or saving activities based on their strategies.

2. **Sliders**:
    - **perc-talk**: Adjusts the percentage of agents that talk or communicate with each other.
    - **return-on-savings**: Determines the return on savings for the saver agents.
    - **save-react-param** & **chart_react_param**: Adjusts how reactive savers and chartists are to market changes.
    - **rand-chart-shocks**, **rand-deviat-fund**, **rand-price-flucts**, **rand-savings**: Introduce randomness to respective agent strategies and market conditions.
    - **price-adj-coeff**, **prob_talk_change**, **prob-indep-change**, **memory**: Fine-tune various agent behaviors and memory effects.

3. **Switches**:
    - **save2fund** & **fund2save**: Toggles the ability for savers to become fundamentalists and vice versa.

4. **Plots**:
    - **Price-Chart**: Visualizes the price changes over time.
    - **Agent-Weights**: Shows the distribution of agent strategies over time.
    - **Market Participants** & **Traders Inflow**: Displays the number of active participants and new entrants in the market.

5. **InputBox**:
    - **steps**: Define the total number of steps the simulation should run for.

### Example Use Case:

1. Click the **Setup** button to initialize the simulation.
2. Adjust the **perc-talk** slider to 30%. This means 30% of the agents will communicate with each other.
3. Set **return-on-savings** to 0.02, implying savers get a 2% return on their savings.
4. Turn on the **save2fund** switch, allowing savers to become fundamentalists.
5. Click the **Start** button to begin the simulation.
6. Observe the **Price-Chart**. As the simulation progresses, you might notice price fluctuations based on agent interactions and their strategies.
7. Experiment by adjusting other sliders and observing the effects on the plots.

By manipulating the controls and observing the outcomes, you can gain insights into how different factors influence market dynamics, agent behavior, and price fluctuations.


## THINGS TO NOTICE

### 1. **Price Changes and Endogenous Responses**
- The Simple Influx Model has shown that price changes in financial markets can occur due to endogenous responses, without the need for exogenous shocks.
- Price inefficiencies may emerge from behavioral patterns of traders.
- The model captures the phenomenon where the market can stay in a regime for some time before transitioning to another.
- Volatility clustering is evident: periods of high volatility are often followed by periods of low volatility. Observe this in the log price and return panels.

### 2. **Regime Switches and Trading Strategies**
- The movement of single agents from one strategy to another contributes to regime switches. This results in periods dominated by either technical traders or fundamentalists.
- During times of high price inefficiencies, technical traders often dominate the market. However, when the deviation between market price and fundamental value enlarges, the fundamental trading strategy becomes more enticing, leading to a market dominated by fundamentalists.
- Take note of the "experience effect" wherein fundamentalists (considered experienced traders) cause prices to stay closer to the fundamental value, leading to a more stable market price.

### 3. **Saver Impact and Market Flow**
- Introducing savers as a new agent type results in recurring market inflow and outflow. This is evident in the market flow panels.
- During saver-dominated regimes, market prices tend to stabilize, but they don't necessarily revert back to the fundamental value. They remain at their current efficiency level until either fundamentalists or technical traders take over.
- Be aware of the model's limitation: the inflow to the market is capped by the total number of agents. Thus, if all agents are trading, further inflows are not feasible.

### 4. **Return on Savings**
- The return on savings parameter can significantly influence market dynamics. For instance, as the return on savings increases, there's a clear drop in both log price and return volatilities.
- A negative return on savings (indicative of inflation) makes the market more volatile, while a positive return reduces volatility.
- The Hill tail index, which measures the distribution of returns, becomes more convex as the return on savings increases, suggesting fewer extreme market events.

### 5. **Saver Reactions**
- The propensity of market participants to become savers is influenced by the saver reaction parameter. Higher values lead to reduced market volatility.
- A value below 0.01 for the saver reaction parameter results in fewer participants opting for saving, which in turn reduces market inflow and leads to less volatile market prices.


## THINGS TO TRY

### 1. **Adjust Market Dynamics**
- **Return on Savings:** Experiment with the 'Return on Savings' parameter. Move the slider to values both above and below zero to simulate positive and negative returns. Notice how this affects the market volatility and the behavior of savers.
- **Saver Reaction:** Tweak the 'Saver Reaction' parameter. Try values above and below 0.01 to observe how the number of savers and overall market volatility is affected.

### 2. **Experiment with Trader Behavior**
- **Technical vs. Fundamental Traders:** Adjust the balance between technical traders and fundamentalists. Notice the regime switches and how the market reacts to a dominance of one group over the other.
- **Trading Strategy Evolution:** Observe the stacked area diagrams representing the evolution of trading strategies. Try to induce regime switches by adjusting relevant parameters and notice how strategies evolve over time.

### 3. **Influence Market Inflow and Outflow**
- **Introduce More Savers:** Increase the initial number of savers and observe how this affects the overall market dynamics and volatility. 
- **Limit Market Inflow:** Set a cap on the number of agents that can enter the market to simulate scenarios where further inflows are impossible. Note how this influences price inefficiencies and market stability.

### 4. **Simulate Extreme Scenarios**
- **Bubbles and Crashes:** Try to create market bubbles or crashes by heavily skewing the parameters. For instance, maximize the number of technical traders or minimize the return on savings.
- **Stability:** Conversely, attempt to create a stable market where prices hover around the fundamental value. This might involve balancing the number of fundamentalists and technical traders or adjusting the saver parameters.

### 5. **Replicate Real-world Phenomena**
- **FOMO Effect:** Restrict savers from transitioning to fundamentalist traders and allow them only to become technical traders. This simulates the Fear Of Missing Out (FOMO) effect observed especially in the crypto community. Monitor how this behavioral change affects market dynamics.

### 6. **Robustness Checks**
- Given the limitation mentioned in the paper about market inflow, try to address this in the model. Experiment with allowing an unlimited number of agents or introduce external shocks to simulate exogenous factors.

### 7. **Visual Analysis**
- Pay attention to the various figures and panels in the model output. Adjust parameters and observe how these visual representations change. This can provide insights into the underlying dynamics and how different factors are interrelated.



## EXTENDING THE MODEL

While the current implementation captures many features of financial markets, there are several avenues for further enhancement and refinement:

### 1. **Agent Activation Mechanism**
- **Customizable Activation Intervals:** Allow users to specify custom intervals for activating agents rather than predefined ones. For instance, instead of having fixed scenarios like 25%, 50%, or 75% inflow, users can input their desired percentages.
- **Variable Activation Rates:** Introduce a mechanism where the rate of agent activation can change over time, simulating different market conditions.

### 2. **Enhanced Inflow Scenarios**
- **Dynamic Inflow:** Instead of fixed percentages, implement a system where the inflow rate can vary based on market conditions or external factors.
- **Multiple Inflow Sources:** Consider introducing multiple sources of inflow, simulating different types of investors entering the market.

### 3. **New Agent Behaviors**
- **Additional Trading Strategies:** Beyond just fundamental and technical traders, introduce other trading strategies observed in real-world markets.
- **Learning Agents:** Allow agents to learn from past market conditions and adjust their strategies accordingly.

### 4. **Modelling Real-world Phenomena**
- **Extend FOMO Behavior:** Broaden the representation of FOMO behavior to include various levels of intensity or different triggers for FOMO.
- **External Shocks:** Introduce external shocks to the model to simulate unexpected market events, like policy changes or global events.

### 5. **Analysis Tools**
- **Advanced Visualization:** Extend the model's visualization capabilities to better represent complex dynamics, such as network effects among agents.
- **In-depth Statistical Analysis:** Include more comprehensive statistical tools to analyze the model's output, especially for understanding the long-term impacts of different parameters.

### 6. **Parameter Optimization**
- Re-run parameter searches considering the inflow of new savers to optimize the model's performance for different scenarios.

### 7. **Model Complexity and Realism**
- **Multiple Markets:** Consider introducing multiple interconnected markets where agents can move between them based on certain conditions.
- **Agent Resources:** Introduce a mechanism where agents have limited resources, influencing their trading decisions.

Remember, while extending the model adds depth and detail, it's essential to ensure that the added complexity serves a clear purpose and enhances the understanding of the system being modeled.


## NETLOGO FEATURES

This model showcases several notable features and techniques in its NetLogo implementation:

### 1. **State Memory**:
   The model maintains memory of previous states for several variables, such as `last-price2` and `last-price`. This feature allows the model to perform calculations based on past values, such as returns.

### 2. **Randomness**:
   The model introduces various random elements (`random-normal`) to simulate uncertainty and fluctuations in factors like chartist shocks (`beta`), deviations for fundamentalists (`yota`), factors for savers (`sigma`), and price fluctuations (`alpha`).

### 3. **Agent Interaction**:
   The `talk-and-learn` procedure lets agents interact, share their strategies, and potentially adapt others' strategies based on certain conditions, mimicking real-world scenarios where investors share insights and adjust their trading behaviors.

### 4. **Conditional Operations**:
   The code uses several conditional checks (`if`, `ifelse`) to determine agent behaviors, strategy switches, and market mechanics. For example, agents compare their current strategy to a received strategy and may adopt it based on certain conditions.

### 5. **Dynamic Weight Calculation**:
   The model dynamically calculates weights for each trading strategy based on the number of agents following that strategy, adjusting the influence of each strategy in market mechanics.

### 6. **Market Dynamics**:
   The `market-mechanics` procedure bundles several crucial market operations, such as order calculations, weight calculations, price dynamics, fitness calculations, and strategy change probability calculations.

### 7. **Strategy Transition Probabilities**:
   The `change-probability` procedure calculates the likelihood of agents switching between different strategies. This procedure dynamically adjusts these probabilities based on the fitness of each strategy, providing a dynamic interplay between agent behaviors.

### 8. **Modularity**:
   The model's code is modular, with different functionalities encapsulated in separate procedures, making it easy to read, understand, and extend.

### 9. **Optimization Opportunities**:
   While the model is comprehensive, there's an opportunity to introduce more efficient coding techniques. For instance, the repeated calculation of weights and orders for various agents could be optimized.

### Workarounds:
   The model seems optimized for the current functionalities. However, as with any simulation, there's always room for further refinement or the addition of new features to enhance its predictive capabilities or realism.

It's essential to understand these features when extending or adapting the model, as they form the backbone of the simulation's mechanics and behaviors.



## RELATED MODELS

Several agent-based models (ABMs) have been proposed in the literature to investigate and understand the phenomenon of asset price bubbles. Here are some models and studies of related interest:

**Brock & Hommes (1998)**:  

This model allows market participants to select among different trading strategies based on past profits. The model explores how agents' orders influence price, which in turn affects the success of a strategy and its selection probability. This mechanism can lead to the emergence of bubbles and crashes.  

**Kirman (1993)**:  

This model is inspired by the behavior of ant colonies choosing between two food sources. It applies a stochastic learning process to the foreign exchange market. The model explores how agents change groups based on the majority opinion and the success of their strategy.  

**Westerhoff (2010)**:  

This model combines the herding mechanism from Kirman’s ant model with the success-dependent switching probabilities from Brock & Hommes (1998). It shows the interaction between different types of traders leading to the emergence of bubbles and crashes.  

For implementation in NetLogo, users can refer to the official NetLogo library and specifically the models developed by Wilensky (1999).  

---

## CREDITS AND REFERENCES

For a detailed understanding and deeper dive into the topics discussed, readers can refer to the following references:

- **Becker, G. S. (1991)**: [A Note on Restaurant Pricing and Other Examples of Social Influences on Price](https://doi.org/10.1086/261791). *Journal of Political Economy, 99(5)*, 1109–1116.
- **Berkman, H., & Koch, P. D. (2008)**: [Noise trading and the price formation process](https://doi.org/10.1016/j.jempfin.2006.10.005). *Journal of Empirical Finance, 15(2)*, 232–250.
- **Bikhchandani, S., Hirshleifer, D., & Welch, I. (1992)**: A Theory of Fads, Fashion, Custom, and Cultural Change as Informational Cascades. *The Journal of Political Economy, 100(5)*, 992–1026.
- **Blaurock, I., Schmitt, N., & Westerhoff, F. (2018)**: [Market entry waves and volatility outbursts in stock markets](https://doi.org/10.1016/j.jebo.2018.03.022). *Journal of Economic Behavior & Organization, 153*, 19–37.
- **Brock, W. A., & Hommes, C. H. (1998)**: [Heterogeneous beliefs and routes to chaos in a simple asset pricing model](https://doi.org/10.1016/S0165-1889(98)00011-6). *Journal of Economic Dynamics and Control, 22(8)*, 1235–1274.
- **Brunnermeier, M. K. (2001)**: Asset Pricing Under Asymmetric Information: Bubbles, Crashes, Technical Analysis, and Herding. *Oxford University Press*.
- **Coinmetrics.io. (2023)**: [Bitcoin Price History and Wallet Counts (Version 1)](https://charts.coinmetrics.io/crypto-data). *Dataset*.
- **Delfabbro, P., King, D. L., & Williams, J. (2021)**: [The psychology of cryptocurrency trading: Risk and protective factors](https://doi.org/10.1556/2006.2021.00037). *Journal of Behavioral Addictions, 10(2)*, 201–207.
- **Diamond, D. W., & Dybvig, P. H. (1983)**: [Bank Runs, Deposit Insurance, and Liquidity](https://doi.org/10.1086/261155). *Journal of Political Economy, 91(3)*, 401–419.
- **Farmer, J. D., & Foley, D. (2009)**: [The economy needs agent-based modelling](https://doi.org/10.1038/460685a). *Nature, 460(7256)*, 685–686.
- **Farmer, J. D., & Joshi, S. (2002)**: [The price dynamics of common trading strategies](https://doi.org/10.1016/S0167-2681(02)00065-3). *Journal of Economic Behavior & Organization, 49(2)*, 149–171.
- **Frankel, J. A., & Froot, K. A. (1986)**: [The Dollar as Speculative Bubble: A Tale of Fundamentalists and Chartists (Working Paper No. 1854)](https://doi.org/10.3386/w1854). *National Bureau of Economic Research*.
- **Hill, B. M. (1975)**: A Simple General Approach to Inference About the Tail of a Distribution. *The Annals of Statistics, 3(5)*, 1163–1174.
- **Hirshleifer, D. A. (2008)**: [The Blind Leading the Blind: Social Influence, Fads and Informational Cascades (SSRN Scholarly Paper No. 1278625)](https://papers.ssrn.com/abstract=1278625).
- **Kahneman, D. (2013)**: Thinking, fast and slow (First paperback edition). *Farrar, Straus and Giroux*.
- **Kahneman, D., Slovic, P., & Tversky, A. (Eds.). (1982)**: Judgment under uncertainty: Heuristics and biases (Reprinted). *Cambridge University Press*.
- **Keynes, J. M. (1935)**: The general theory of employment, interest, and money. *New York, Harcourt, Brace & World*.
- **Kindleberger, C. P. (2011)**: Manias, panics and crashes: A history of financial crises (6. ed.). *Palgrave Macmillan*.
- **Kirchler, M., Bonn, C., Huber, J., & Razen, M. (2015)**: [The “inflow-effect”—Trader inflow and price efficiency](https://doi.org/10.1016/j.euroecorev.2015.03.006). *European Economic Review, 77*, 1–19.
- **Kirman, A. (1991)**: Money and financial markets. *B. Blackwell*.
- **Kirman, A. (1993)**: [Ants, Rationality, and Recruitment*](https://doi.org/10.2307/2118498). *The Quarterly Journal of Economics, 108(1)*, 137–156.
- **Lux, T. (1995)**: [Herd Behaviour, Bubbles and Crashes](https://doi.org/10.2307/2235156). *The Economic Journal, 105(431)*, 881–896.
- **McFadden, D. (1989)**: [A Method of Simulated Moments for Estimation of Discrete Response Models Without Numerical Integration](https://doi.org/10.2307/1913621). *Econometrica, 57(5)*, 995–1026.
- **Razen, M., Huber, J., & Kirchler, M. (2017)**: [Cash inflow and trading horizon in asset markets](https://doi.org/10.1016/j.euroecorev.2016.11.010). *European Economic Review, 92*, 359–384.
- **Schmitt, N., & Westerhoff, F. (2017)**: [Herding behaviour and volatility clustering in financial markets](https://doi.org/10.1080/14697688.2016.1267391). *Quantitative Finance, 17(8)*, 1187–1203.
- **Slovic, P., Finucane, M. L., Peters, E., & MacGregor, D. G. (2007)**: [The affect heuristic](https://doi.org/10.1016/j.ejor.2005.04.006). *European Journal of Operational Research, 177(3)*, 1333–1352.
- **Thaler, R. H. (1993)**: Advances in behavioral finance. *Russell Sage Foundation*.
- **Thaler, R. H. (2015)**: Misbehaving: How economics became behavioural. *Lane*.
- **Weitzel, U., Huber, C., Huber, J., Kirchler, M., Lindner, F., & Rose, J. (2020)**: [Bubbles and Financial Professionals](https://doi.org/10.1093/rfs/hhz093). *The Review of Financial Studies, 33(6)*, 2659–2696.
- **Westerhoff, F. (2010)**: [A Simple Agent-based Financial Market Model: Direct Interactions and Comparisons of Trading Profits](https://doi.org/10.1007/978-3-642-04023-8_17). In G. I. Bischi, C. Chiarella, & L. Gardini (Eds.), *Nonlinear Dynamics in Economics, Finance and Social Sciences: Essays in Honour of John Barkley Rosser Jr (pp. 313–332)*. Springer.
- **Wilensky, U. (1999)**: [NetLogo (6.3.0)](http://ccl.northwestern.edu/netlogo/). *Center for Connected Learning and Computer-Based Modeling, Northwestern University, Evanston, IL*.
- **Xie, H., & Zhang, J. (2012)**: [Bubbles and Experience: An Experiment with a Steady Inflow of New Traders (SSRN Scholarly Paper No. 1999041)](https://doi.org/10.2139/ssrn.1999041).
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.2.0
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@
