extensions[py]

patches-own[
  strategy
  indicator
]

globals[
  price
  abs-price
  last-price
  last-price2
  F
  F2
  returns
  str-random
  talks-done
  talker-strategy
  talks-per-round

  alpha
  beta
  sigma
  yota

  securities
  securities2
  securities3
  chart-orders
  chart-orders2
  chart-orders3
  fund-orders
  fund-orders2
  fund-orders3
  all-orders

  N
  NN
  NN2
  NN3
  N-save
  N2-save
  N-fund
  N2-fund
  N-chart
  N2-chart

  W-save
  W-fund
  W-chart

  fit-chart2
  fit-chart
  fit-fund2
  fit-fund
  fit-save2
  fit-save

  prob-change-chart-fund
  prob-change-fund-chart
  prob-change-chart-save
  prob-change-save-chart
  prob-change-fund-save
  prob-change-save-fund

  trans-prob-chart-save
  trans-prob-chart-fund
  trans-prob-save-chart
  trans-prob-save-fund
  trans-prob-fund-save
  trans-prob-fund-chart

  trans-prob
  min-trans-prob

  price-data
  return-data
  agent-number
  market-number
  save-number
  fund-number
  chart-number

  ABM_dist
  ABM_vola

  d_D
  d_V
  d_hill
  d_aac
  d_ac
  d_sum
  d_max
  d_all

  time
  d_time
]

to setup
  clear-all
  clear-all-plots

  ifelse Inflow = true
  [ setup-traders]
  [ setup-traders-full ]

  if ExportData = true
  [ setup-python ]

  set N sum [indicator] of patches with [not (strategy = 0)]
  set N-chart sum [indicator] of patches with [strategy = 3]
  set N-fund sum [indicator] of patches with [strategy = 2]
  set N-save sum [indicator] of patches with [strategy = 1]
  set NN  (N-chart +  N-fund)
  set NN2 NN
  set NN3 NN2
  set N2-save 0
  set N2-fund 0
  set N2-chart 0

  ifelse Inflow = true
  [ set min-trans-prob 4 / count patches with [not (strategy = 0)] ]
  [ set min-trans-prob 4 / count patches ]

  set talks-per-round (perc-talk / 100) * count patches

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

  set W-save 0
  set W-fund 0
  set W-chart 0

  set fit-chart2 0
  set fit-chart 0
  set fit-fund2 0
  set fit-fund 0
  set fit-save2 0
  set fit-save 0

  set price-data []
  set return-data []
  set agent-number []
  set market-number []
  set save-number []
  set fund-number []
  set chart-number []

  set ABM_dist 0
  set ABM_vola 0

  set d_D 10
  set d_V 10
  set d_hill 10
  set d_aac 10
  set d_ac "NaN"
  set d_sum 10
  set d_max 10
  set d_all 10

 ;Inlow-Stuff
  set time 1
  if Inflow = true
  [ set d_time int (steps / count patches with [strategy = 0]) ]

  reset-ticks
end

to setup-bulk
  clear-all
  clear-all-plots

  ifelse Inflow = true
  [ setup-traders]
  [ setup-traders-full ]

  set N sum [indicator] of patches with [not (strategy = 0)]
  set N-chart sum [indicator] of patches with [strategy = 3]
  set N-fund sum [indicator] of patches with [strategy = 2]
  set N-save sum [indicator] of patches with [strategy = 1]
  set NN  (N-chart +  N-fund)
  set NN2 NN
  set NN3 NN2
  set N2-save 0
  set N2-fund 0
  set N2-chart 0

  ifelse Inflow = true
  [ set min-trans-prob 4 / count patches with [not (strategy = 0)] ]
  [ set min-trans-prob 4 / count patches ]

  set talks-per-round (perc-talk / 100) * count patches

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

  set W-save 0
  set W-fund 0
  set W-chart 0

  set fit-chart2 0
  set fit-chart 0
  set fit-fund2 0
  set fit-fund 0
  set fit-save2 0
  set fit-save 0

  set price-data []
  set return-data []
  set agent-number []
  set market-number []
  set save-number []
  set fund-number []
  set chart-number []

  set ABM_dist 0
  set ABM_vola 0

  set d_D 10
  set d_V 10
  set d_hill 10
  set d_aac 10
  ; set d_ac 10
  set d_sum 10
  set d_max 10
  set d_all 10

 ;Inlow-Stuff
  set time 1
  if Inflow = true
  [ set d_time int (steps / count patches with [strategy = 0]) ]

  reset-ticks
end

to setup-traders
  ask patches
    [
    set indicator  1
    ;let x count patches
    set str-random (random-float 1.0)
      ifelse str-random < (fill / 100)  ; fill =50 => 50/100 = 1/2
      [ set strategy 0
        set pcolor black ]
      [ifelse str-random < (100 - 2 * (100 - fill) / 3) / 100 ; < 5 / 6
         [ set strategy 1
           set pcolor green]
         [ ifelse str-random < (100 - (100 - fill) / 3 ) / 100   ; < 4 / 6
             [ set strategy 3
               set pcolor red]
             [ set strategy 2
               set pcolor blue]
         ]
      ]
    ]
end

to setup-traders-full
  ask patches
    [
    set indicator  1
    set str-random (random-float 1.0)
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

to bulk
  if ExportData = true
  [ setup-python ]
  repeat runs [
    setup-bulk
    repeat steps + 1 [
      go
    ]
  ]
  if ExportData = true
  [ py-export ]
end

to go
  if ticks >= steps [
    if ExportData = true [
      do-py-stats
      do-py-dataframe
    ]
    stop
  ]
  if ticks >  2 [talk-and-learn]
  market-mechanics
  if ExportData = true
  [ collect-data ]
  if Inflow = true
  [ add-trader ]
  tick
end

to collect-data
  set price-data lput price price-data
  set return-data lput returns return-data
  set agent-number lput N agent-number
  set market-number lput (N-chart + N-fund) market-number
  set save-number lput N-save save-number
  set fund-number lput N-fund fund-number
  set chart-number lput N-chart chart-number
end

to add-trader
  ifelse time = d_time
  [ set time 1
    let new-patches patches with [strategy = 0]
    if any? new-patches [ask one-of new-patches [
      set strategy 1
      set pcolor green]]
  ]
  [ set time time + 1]
  set min-trans-prob 4 / count patches with [not (strategy = 0)]
end

to market-mechanics

  calculate-orders
  calculate-weights
  price-mechanics
  calculate-fitness
  change-probability

end

to talk-and-learn
  set talks-done 0
  while [talks-per-round >= talks-done]
  [
    let full-patches patches with [not (strategy = 0)]
    ask one-of full-patches
    [
      let filled-patch one-of patches with [not (strategy = 0)]
      set talker-strategy [strategy] of filled-patch

      if not (strategy = talker-strategy)
      [
        if talker-strategy = 1   ; Learn Saving
        [
          if strategy = 2 and (fit-save > fit-fund) and  (trans-prob-fund-save > min-trans-prob) and (fund2save = True)         ; Fundamentalist learns Saving
          [ set strategy 1
            set pcolor green  ]
          if strategy = 3 and (fit-save > fit-chart) and (trans-prob-chart-save  >  min-trans-prob)           ; Chartist learns Saving
          [ set strategy 1
            set pcolor green  ]
        ]
        if talker-strategy = 2   ; Learn Fundamental Trading
        [
          if strategy = 1 and (fit-fund > fit-save) and (trans-prob-save-fund > min-trans-prob) and (save2fund = True)           ; Saver learns Fundamentals
          [ set strategy 2
            set pcolor blue  ]
          if strategy = 3 and (fit-fund > fit-chart) and (trans-prob-chart-fund > min-trans-prob)           ; chartist learns fundamentals
          [ set strategy 2
            set pcolor blue  ]
        ]
        if talker-strategy = 3   ; Learn Chart Trading
        [
          if strategy = 1 and (fit-chart > fit-save) and (trans-prob-save-chart > min-trans-prob)             ; Saver learns Charts
          [ set strategy 3
            set pcolor red  ]
          if strategy = 2 and (fit-chart > fit-fund) and (trans-prob-fund-chart > min-trans-prob)        ; Fundamentalist learns to follow Charts
          [ set strategy 3
            set pcolor red  ]
        ]
      ]
    ]
    set talks-done talks-done + 1
  ]
end

to calculate-orders
     ; set random variables
  set beta   random-normal 0  rand-chart-shocks
  set yota   random-normal 0  rand-deviat-fund
  set sigma  random-normal 0  rand-savings

      ; calculate security orders
  set securities3 securities2
  set securities2 securities
  set securities (save-react-param * (return-on-savings + sigma))
      ; calculate chartist orders
  set chart-orders3 chart-orders2
  set chart-orders2 chart-orders
  set chart-orders (chart_react_param *  ((price - last-price) + beta))
      ; calculate fundamental orders
  set fund-orders3 fund-orders2
  set fund-orders2 fund-orders
  set fund-orders (fund-react-param * ((F - price) + yota))
  set all-orders (abs chart-orders + abs fund-orders)
end

to calculate-weights
  set N sum [indicator] of patches with [not (strategy = 0)]
  set N2-chart N-chart
  set N2-fund N-fund
  set N2-save N-save
  set N-chart sum [indicator] of patches with [strategy = 3]
  set W-chart (N-chart / N)
  set N-fund sum [indicator] of patches with [strategy = 2]
  set W-fund (N-fund / N)
  set N-save sum [indicator] of patches with [strategy = 1]
  set W-save (N-save / N)
  set NN2 NN
  set NN3 NN2
  set NN (N2-chart + N2-fund)
end

to price-mechanics
  set alpha  random-normal 0 rand-price-flucts
    ; update price
  set last-price2 last-price
  set last-price price

  set F2 F
  set price (last-price + price-adj-coeff * (chart-orders * W-chart + fund-orders * W-fund) + alpha)

  ifelse last-price = 0
  [set returns 0.0]
  [set returns (price - last-price)]
end

to calculate-fitness
    ; calculate  fitness of strategie
  set fit-chart2 fit-chart
  set fit-fund2 fit-fund
  set fit-save2 fit-save
  set fit-chart (((exp price) - (exp last-price)) * chart-orders3 + memory * fit-chart2)
  set fit-fund (((exp price) - (exp last-price)) * fund-orders3 + memory * fit-fund2)
  set fit-save  ((exp return-on-savings) * securities3 + memory * fit-save2)
end

to change-probability
    ; Probability of strategy change
  if (fit-chart > fit-fund)
  [
    set prob-change-chart-fund 0.5 - prob_talk_change
    set prob-change-fund-chart 0.5 + prob_talk_change
  ]
  if (fit-fund > fit-chart)
  [
    set prob-change-chart-fund 0.5 + prob_talk_change
    set prob-change-fund-chart 0.5 - prob_talk_change
  ]
  if (fit-chart > fit-save)
  [
    set prob-change-chart-save 0.5 - prob_talk_change
    set prob-change-save-chart 0.5 + prob_talk_change
  ]
  if (fit-save > fit-chart)
  [
    set prob-change-chart-save 0.5 + prob_talk_change
    set prob-change-save-chart 0.5 - prob_talk_change
  ]
  if (fit-save > fit-fund)
  [
    set prob-change-fund-save 0.5 + prob_talk_change
    set prob-change-save-fund 0.5 - prob_talk_change
  ]
  if (fit-fund > fit-save)
  [
    set prob-change-fund-save 0.5 - prob_talk_change
    set prob-change-save-fund 0.5 + prob_talk_change
  ]
  set trans-prob-chart-save (W-chart * (prob-indep-change + prob-change-chart-save * W-save))
  set trans-prob-chart-fund (W-chart * (prob-indep-change + prob-change-chart-fund * W-fund))
  set trans-prob-save-chart (W-save * (prob-indep-change + prob-change-save-chart * W-chart))
  set trans-prob-save-fund (W-save * (prob-indep-change + prob-change-save-fund * W-fund))
  set trans-prob-fund-save (W-fund * (prob-indep-change + prob-change-fund-save * W-save))
  set trans-prob-fund-chart (W-fund * (prob-indep-change + prob-change-fund-chart * W-chart))

  set trans-prob ( trans-prob-chart-save + trans-prob-chart-fund + trans-prob-save-chart +
                   trans-prob-save-fund + trans-prob-fund-save + trans-prob-fund-chart )
end

to setup-python
  py:setup "../pyenv/bin/python"
  (py:run
    "import pandas as pd"
    "import numpy as np"
    "from statsmodels.tsa.stattools import acf"
    "from openpyxl import load_workbook"
    "import datetime as dt"

    "run = 0"
    "df_runs = pd.DataFrame()"
   )
  (py:run
    "def Hill_pro(data, cent):"
    "    Y = np.sort(data)"
    "    n = len(Y)"
    "    c = int(n * cent / 100)"
    "    Hill_est = np.zeros(c)"
    "    for k in range(0, c):"
    "        summ = 0"
    "        for i in range(0,k+1):"
    "            summ += np.log(Y[n-1-i]) - np.log(Y[n-2-k])"
    "        Hill_est[k] = (1 / (k+1)) * summ"
    "    kappa = 1. / Hill_est"
    "    return kappa"
    )
end

to do-py-stats
  py:set "prices" price-data
  py:set "returns" return-data
  (py:run
    "prices = np.array(prices)"
    "returns = np.array(returns)"
    "norm_prices = prices / prices.std()"
    "norm_returns = returns / returns.std()"

    "D = np.std(prices)"
    "V = np.std(returns)"

    "t = returns"
    "tail =  Hill_pro(t, 10)"
    "hill = pd.DataFrame(tail)"
    "hill.rename(columns = {0:'tail'}, inplace = True)"
    "hill['obs_pc'] = hill.index / len(t) * 100"
    "hill_1 = hill[hill['obs_pc'] >= 1]"
    "hill_2 = hill[hill['obs_pc'] >= 2]"
    "hill_3 = hill[hill['obs_pc'] >= 3]"
    "hill_5 = hill[hill['obs_pc'] >= 5]"
    "h1 = round(hill_1['tail'].iloc[0], 4)"
    "h2 = round(hill_2['tail'].iloc[0], 4)"
    "h3 = round(hill_3['tail'].iloc[0], 4)"
    "h5 = round(hill_5['tail'].iloc[0], 4)"
    "h10 = round(hill['tail'].iloc[-1], 4)"

    "aac = acf(abs(np.array(returns)), nlags=100)"
    "ac = acf(np.array(returns), nlags=100)"
    )
  (py:run
    ;Modes from Bitcoin Price Data
    "D_btc = 0.86622"
    "V_btc = 0.04342"

    "hl_1 = 3.8003"
    "hl_2 = 3.4702"
    "hl_3 = 3.0579"
    "hl_5 = 2.4692"
    "hl_10 = 1.9809"

    "ac_r1_btc = 0.0033"
    "ac_r2_btc = 0.0056"
    "ac_r3_btc = 0.0019"

    "aac_r1_btc = 0.2978"
    "aac_r2_btc = 0.2246"
    "aac_r3_btc = 0.1937"
    "aac_r6_btc = 0.182"
    "aac_r12_btc = 0.1575"
    "aac_r25_btc = 0.0977"
    "aac_r50_btc = 0.0687"
    "aac_r100_btc = -0.0093"

    ;Calculate Delta Model Run to BTC
    "d_D = abs((D - D_btc) / D_btc)"
    "d_V = abs((V - V_btc) / V_btc)"
    "d_Vola = (d_D + d_V) / 2"

    "d_h1 = abs((h1 - hl_1) / hl_1)"
    "d_h2 = abs((h2 - hl_2) / hl_2)"
    "d_h3 = abs((h3 - hl_3) / hl_3)"
    "d_h5 = abs((h5 - hl_5) / hl_5)"
    "d_h10 = abs((h10 - hl_10) / hl_10)"
    "d_Hill = (d_h1 + d_h2 + d_h3 + d_h5 + d_h10) / 5"

    "d_ac_r1 = abs((ac[1] - ac_r1_btc) / ac_r1_btc)"
    "d_ac_r2 = abs((ac[2] - ac_r2_btc) / ac_r2_btc)"
    "d_ac_r3 = abs((ac[3] - ac_r3_btc) / ac_r3_btc)"
    "d_AC_r = (d_ac_r1 + d_ac_r2 + d_ac_r3) / 3"

    "d_aac_r1 = abs((aac[1] - aac_r1_btc) / aac_r1_btc)"
    "d_aac_r2 = abs((aac[2] - aac_r2_btc) / aac_r2_btc)"
    "d_aac_r3 = abs((aac[3] - aac_r3_btc) / aac_r3_btc)"
    "d_aac_r6 = abs((aac[6] - aac_r6_btc) / aac_r6_btc)"
    "d_aac_r12 = abs((aac[12] - aac_r12_btc) / aac_r12_btc)"
    "d_aac_r25 = abs((aac[25] - aac_r25_btc) / aac_r25_btc)"
    "d_aac_r50 = abs((aac[50] - aac_r50_btc) / aac_r50_btc)"
    "d_aac_r100 = abs((aac[100] - aac_r100_btc) / aac_r100_btc)"
    "d_AAC_r = (d_aac_r1 + d_aac_r2 + d_aac_r3 + d_aac_r6 + d_aac_r12 + d_aac_r25 + d_aac_r50 + d_aac_r100) / 8"

    "d_all = (d_Vola + d_Hill + d_AAC_r) / 3"

    "Deltas = [d_all, d_Vola, d_Hill, d_AAC_r]"

    "Volatility = ['-',D , V]"
    "d_Vol = [d_Vola, d_D, d_V]"

    "Hill = ['-', h1, h2, h3, h5, h10]"
    "d_Hil = [d_Hill, d_h1, d_h2, d_h3, d_h5, d_h10]"

    "AC_r = ['-', ac[1], ac[2], ac[3]]"
    "del_AC_r = [d_AC_r,d_ac_r1,d_ac_r2,d_ac_r3]"

    "AAC_r = ['-', aac[1], aac[2], aac[3], aac[6], aac[12], aac[25], aac[50], aac[100]]"
    "del_AAC_r = [d_AAC_r,d_aac_r1,d_aac_r2,d_aac_r3,d_aac_r6,d_aac_r12,d_aac_r25,d_aac_r50,d_aac_r100]"
    )

  set d_all py:runresult "d_all"
  set d_V py:runresult "d_Vola"
  set d_hill py:runresult "d_Hill"
  set d_aac py:runresult "d_AAC_r"
  set d_ac py:runresult "d_AC_r"
end

to do-py-dataframe
  py:set "agent_count" agent-number
  py:set "market_count" market-number
  py:set "save_count" save-number
  py:set "fund_count" fund-number
  py:set "chart_count" chart-number
  py:set "prices" price-data
  py:set "returns" return-data

  (py:run
    "run += 1"
    "dict_time = {'Deltas' + '_' + str(run) : Deltas,"
    "             'Volatility' + '_' + str(run) : Volatility,"
    "             'dVol' + '_' + str(run) : d_Vol,"
    "             'hillObs' + '_' + str(run) : hill['obs_pc'],"
    "             'hillIdx' + '_' + str(run) : hill['tail'],"
    "             'Hill' + '_' + str(run) : Hill,"
    "             'dHill' + '_' + str(run) : d_Hil,"
    "             'ACFr' + '_' + str(run) : ac,"
    "             'ACr' + '_' + str(run) : AC_r,"
    "             'dACr' + '_' + str(run) : del_AC_r,"
    "             'AACFr' + '_' + str(run) : aac,"
    "             'AACr' + '_' + str(run) : AAC_r,"
    "             'dAACr' + '_' + str(run) : del_AAC_r,"
    "             'logPrice' + '_' + str(run) : prices,"
    "             'Returns' + '_' + str(run) : returns,"
    "             'AgentCount' + '_' + str(run) : agent_count,"
    "             'MarketCount' + '_' + str(run) : market_count,"
    "             'SaveCount' + '_' + str(run) : save_count,"
    "             'FundCount' + '_' + str(run) : fund_count,"
    "             'ChartCount' + '_' + str(run) : chart_count,"
    "            }"
    "df_time = pd.DataFrame.from_dict(dict_time, orient='index')"
    "df_time = df_time.transpose()"
    "df_runs = pd.concat([df_runs, df_time], axis=1)"
    )
  show py:runresult "print(df_runs.head(7))"
end

to py-export
  py:set "file_name" DataExportName
  (py:run
    "now = dt.datetime.now()"
    "runs_url = '../data/model_out/' + file_name + '_' + now.strftime('%Y-%m-%d_%H-%M-%S') + '.csv'"
    "df_runs.to_csv(runs_url)"
   )
  show py:runresult "print('model output data exported as: ' +  runs_url)"
end
@#$#@#$#@
GRAPHICS-WINDOW
606
10
843
248
-1
-1
22.9
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
9
0
9
1
1
1
ticks
30.0

BUTTON
6
44
89
77
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
8
119
201
152
perc-talk
perc-talk
1
50
19.0
1
1
%
HORIZONTAL

SLIDER
199
487
395
520
return-on-savings
return-on-savings
-0.05
0.03
-0.02
0.005
1
NIL
HORIZONTAL

PLOT
204
10
601
186
Price-Chart
time
price
0.0
5000.0
0.0
0.0
true
false
"" ""
PENS
"log price" 1.0 0 -16777216 true "" "plot price"
"fund price" 1.0 0 -7500403 true "" "plot F"
"returns" 1.0 0 -2674135 true "" "plot returns"

SLIDER
11
487
200
520
save-react-param
save-react-param
0.003
0.3
0.03
0.001
1
NIL
HORIZONTAL

INPUTBOX
92
10
147
77
steps
5000.0
1
0
Number

PLOT
204
188
601
333
Market Participants
NIL
Count
0.0
5000.0
0.0
100.0
false
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" "plot (n-chart + n-fund)"
"agents" 1.0 0 -3026479 true "" "plot N"

PLOT
204
335
601
479
Traders Inflow
time
diff
0.0
5000.0
0.0
0.0
true
false
"" ""
PENS
"pen-2" 1.0 0 -16777216 true "" "plot NN - NN2"

SWITCH
55
451
160
484
save2fund
save2fund
1
1
-1000

SWITCH
54
413
160
446
fund2save
fund2save
0
1
-1000

SLIDER
9
298
200
331
rand-chart-shocks
rand-chart-shocks
0.1
1
0.5
0.1
1
NIL
HORIZONTAL

SLIDER
10
378
200
411
rand-deviat-fund
rand-deviat-fund
0.1
2
1.0
0.1
1
NIL
HORIZONTAL

SLIDER
9
265
200
298
chart_react_param
chart_react_param
0.01
0.2
0.1
0.01
1
NIL
HORIZONTAL

SLIDER
10
345
200
378
fund-react-param
fund-react-param
0.001
0.01
0.003
0.001
1
NIL
HORIZONTAL

SLIDER
395
520
602
553
rand-price-flucts
rand-price-flucts
0.001
0.01
0.005
0.001
1
NIL
HORIZONTAL

SLIDER
395
487
602
520
price-adj-coeff
price-adj-coeff
0.1
3
1.0
0.1
1
NIL
HORIZONTAL

SLIDER
8
152
201
185
prob_talk_change
prob_talk_change
0.1
0.5
0.25
0.05
1
NIL
HORIZONTAL

SLIDER
8
185
201
218
prob-indep-change
prob-indep-change
0
0.1
0.05
0.025
1
NIL
HORIZONTAL

SLIDER
8
218
201
251
memory
memory
0.05
1
0.75
0.05
1
NIL
HORIZONTAL

SLIDER
697
252
844
285
Fill
Fill
10
90
30.0
5
1
%
HORIZONTAL

MONITOR
608
456
698
501
NIL
d_all
4
1
11

MONITOR
699
507
788
552
NIL
d_hill
4
1
11

MONITOR
699
456
788
501
NIL
d_aac
4
1
11

MONITOR
607
285
697
330
steps add
d_time
1
1
11

SLIDER
11
520
199
553
rand-savings
rand-savings
0
0.5
0.25
0.05
1
NIL
HORIZONTAL

INPUTBOX
146
10
200
77
runs
10.0
1
0
Number

BUTTON
6
80
90
117
NIL
bulk
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

MONITOR
608
507
698
552
NIL
d_V
4
1
11

SWITCH
607
252
697
285
Inflow
Inflow
1
1
-1000

SWITCH
607
346
787
379
ExportData
ExportData
0
1
-1000

INPUTBOX
607
381
787
441
DataExportName
InflowModel_00_s2f_false
1
0
String

@#$#@#$#@
## WHAT IS IT?

(a general understanding of what the model is trying to show or explain)

## HOW IT WORKS

(what rules the agents use to create the overall behavior of the model)

## HOW TO USE IT

(how to use the model, including a description of each of the items in the Interface tab)

## THINGS TO NOTICE

(suggested things for the user to notice while running the model)

## THINGS TO TRY

(suggested things for the user to try to do (move sliders, switches, etc.) with the model)

## EXTENDING THE MODEL

(suggested things to add or change in the Code tab to make the model more complicated, detailed, accurate, etc.)

## NETLOGO FEATURES

(interesting or unusual features of NetLogo that the model uses, particularly in the Code tab; or where workarounds were needed for missing features)

## RELATED MODELS

(models in the NetLogo Models Library and elsewhere which are of related interest)

## CREDITS AND REFERENCES

(a reference to the model's URL on the web if it has one, as well as any other necessary credits, citations, and links)
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
