# CryptoWaveDynamics

Dive into the intricate world of financial markets with the [CryptoWaveDynamics](https://wolkenmilch.github.io/simple-web.html) model! Inspired by Bitcoin trading dynamics, this simulation explores the behaviors and strategies of financial agents and how they shape the market landscape.

Eager to experiment with the model or contribute to its growth? Dive into the [Documentation](docs/Documentation.md) for detailed guidance and insights!

## Table of Contents
- [What is it?](#what-is-it)
- [How it Works](#how-it-works)
- [How to Use it](#how-to-use-it)
- [Things to Notice](#things-to-notice)
- [Things to Try](#things-to-try)
- [Extending the Model](#extending-the-model)
- [NetLogo Features](#netlogo-features)
- [Related Models](#related-models)
- [Credits and References](#credits-and-references)

## What is it?

Dive into the intricate world of financial markets! This model, inspired by the bustling realm of Bitcoin trading, simulates how individuals decide their financial strategies. From cautious savers to strategic traders, we explore how each player influences market dynamics. The model introduces a unique agent, the 'saver', who doesn't trade but holds onto their savings. By studying behaviors like the 'Fear of Missing Out' (FOMO), we aim to understand the inflow of new investors and its impact on market prices. As waves of new investors pour into the market, the dynamics of price changes become more pronounced, leading to intriguing fluctuations and trends. Whether you're intrigued by the complexity of Bitcoin bubbles or the subtle dance of supply and demand, this simulation offers a window into the world of financial ebbs and flows.

## How it Works

Imagine a financial playground, bustling with activity, strategies, and interactions. Here's the breakdown:  


**Agents & Their Roles:** 

- Our model world is inhabited by a diverse set of agents, each with their own financial strategy. These agents can be broadly categorized into:
- **Savers:** These are conservative agents who do not actively trade but hold onto their savings, earning a fixed return each period.
- **Fundamentalists:** Experienced traders who base their decisions on the fundamental value of assets.
- **Chartists (Technical Traders):** Those who use past price trends to make future trading decisions.  

**Interactions & Dynamics:**

- Agents decide their trading or saving strategy based on a set of rules and conditions. They can switch strategies based on interactions with other agents, market dynamics, and their own past experiences.
- Fear of Missing Out (FOMO) plays a crucial role. Seeing others profit can spur agents to dive into the market, leading to waves of new investors.  

**Market Behavior & Price Dynamics:** 

- The market price changes based on trading orders from chartists and fundamentalists. Savers introduce market in- and outflows, affecting overall market volatility.
- Price inefficiencies can arise due to behavioral patterns. For instance, when savers dominate, prices might not revert to the fundamental value but remain stable until other agents take the lead.  



## How to Use it

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


## Things to Notice


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



## Things to Try


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

## Extending the Model


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


## NetLogo Features


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


## Related Models


Several agent-based models (ABMs) have been proposed in the literature to investigate and understand the phenomenon of asset price bubbles. Here are some models and studies of related interest:

**Brock & Hommes (1998)**:  

This model allows market participants to select among different trading strategies based on past profits. The model explores how agents' orders influence price, which in turn affects the success of a strategy and its selection probability. This mechanism can lead to the emergence of bubbles and crashes.  

**Kirman (1993)**:  

This model is inspired by the behavior of ant colonies choosing between two food sources. It applies a stochastic learning process to the foreign exchange market. The model explores how agents change groups based on the majority opinion and the success of their strategy.  

**Westerhoff (2010)**:  

This model combines the herding mechanism from Kirman’s ant model with the success-dependent switching probabilities from Brock & Hommes (1998). It shows the interaction between different types of traders leading to the emergence of bubbles and crashes.  

For implementation in NetLogo, users can refer to the official NetLogo library and specifically the models developed by Wilensky (1999).  


## Credits and References

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


---

## Contributing
If you'd like to contribute to the project, please fork the repository and make changes as you'd like. Pull requests are warmly welcome.

## License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Support
If you have any questions or run into issues, please open an issue and we'll do our best to help.

---