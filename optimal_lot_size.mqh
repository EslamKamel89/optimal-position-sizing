//+------------------------------------------------------------------+
//|                                             optimal_lot_size.mqh |
//|                                                  EslamAhmedKamel |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "EslamAhmedKamel"
#property link      "https://www.mql5.com"
#property strict



double optimalLotSize(double riskPercent , int maxLossInPips)
{
// total amount of money in you account even if you have open trades and
// you have reserved margin it don't care
// i will be using accountEquity in my position sizing functions
   double accEquity = AccountEquity();

// return the net amount of money that you can use to open new trades
//double accBalance = AccountBalance();

// get the lotSize for the current account if standard, mini or micro
   double lotSize = MarketInfo(NULL, MODE_LOTSIZE) ;

// gives you the tick value for the current chart in the quote currency
// in your deposit currency
// Tick value for one lot and for one point
// 1 point = 0.00001 quotecurency = tickValue usd
   double tickValue = MarketInfo(NULL, MODE_TICKVALUE);
   
// for jpy currency pairs the code won't work 
   if(Digits <=3)
   {
   tickValue = tickValue / 100 ;
   }

// claculating maximum amount you could lose in a trade
   double maxLossDollar = accEquity * riskPercent ;

// clacuating maximum amount you could lose in the quote currency
   double maxLossInQuoteCurrency = maxLossDollar / tickValue ;

// getPipValue return 0.0001 or 0.01 depneding on the pair type
   double optimalLotSize =(maxLossInQuoteCurrency / (maxLossInPips * getPipValue())) / lotSize;
   optimalLotSize = NormalizeDouble(optimalLotSize, 2);
   Print("Account Equity: " + accEquity);
   Print("Tick Value In Deposit Currency USD: " + tickValue);
   Print("Maximum Loss In Pips: " + maxLossInPips);
   Print("Maximum Loss Dollar: " + maxLossDollar);
   Print("Maximum Loss In Quote Currency: " + maxLossInQuoteCurrency);
   Print("Optimal Lot Size : " + optimalLotSize);
   return optimalLotSize ;
}

double optimalLotSize (double riskPercent , double entryPrice , double stoploss)
{
   int maxLossInPips = MathFloor(MathAbs(entryPrice-stoploss)/getPipValue());
   return optimalLotSize(riskPercent , maxLossInPips);
}