//+------------------------------------------------------------------+
//|                                                     JJN-Fibo.mq4 |
//|                                      Copyright © 2010, JJ Newark |
//|                                           http://jjnewark.atw.hu |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2010, JJ Newark"
#property link      "http://jjnewark.atw.hu"

#property indicator_chart_window

#property  indicator_buffers 7
#property  indicator_color1  Chocolate
#property  indicator_color2  DarkSlateGray
#property  indicator_color3  DarkSlateGray
#property  indicator_color4  Chocolate
#property  indicator_color5  DarkSlateGray
#property  indicator_color6  Chocolate
#property  indicator_color7  DarkSlateGray
#property  indicator_width1  2
#property  indicator_width2  1
#property  indicator_width3  1
#property  indicator_width4  1
#property  indicator_width5  1
#property  indicator_width6  2
#property  indicator_width7  1


//---- indicator buffers
double     Fib0[];
double     Fib1[];
double     Fib2[];
double     Fib3[];
double     Fib4[];
double     Fib5[];
double     Fib6[];


double H,L,W;
//int UniqueId;

extern int        ProcessedUnits              = 1;
extern color      TextColor                   = Black;
extern string     Help_For_BasisTF            = "M:43200;W:10080;D1:1440;H4:240;H1:60";
extern int        BasisTF                     = PERIOD_D1;
extern string     Help_for_DisplayDecimals    = "Used only: 4,5!";
extern int        DisplayDecimals             = 4;


//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators

   SetIndexStyle(0,DRAW_LINE);
   SetIndexBuffer(0,Fib0);
   SetIndexStyle(1,DRAW_LINE,STYLE_DOT);
   SetIndexBuffer(1,Fib1);
   SetIndexStyle(2,DRAW_LINE,STYLE_DOT);
   SetIndexBuffer(2,Fib2);
   SetIndexStyle(3,DRAW_LINE,STYLE_DOT);
   SetIndexBuffer(3,Fib3);
   SetIndexStyle(4,DRAW_LINE,STYLE_DOT);
   SetIndexBuffer(4,Fib4);
   SetIndexStyle(5,DRAW_LINE);
   SetIndexBuffer(5,Fib5);
   SetIndexStyle(6,DRAW_LINE,STYLE_DOT);
   SetIndexBuffer(6,Fib6);
      
   SetIndexLabel(0,"Fib0");
   SetIndexLabel(1,"Fib1");
   SetIndexLabel(2,"Fib2");
   SetIndexLabel(3,"Fib3");
   SetIndexLabel(4,"Fib4");
   SetIndexLabel(5,"Fib5");
   SetIndexLabel(6,"Fib6");
      
   
   IndicatorShortName("JJN-Fibo");
   
   //MathSrand(TimeLocal());
   //UniqueId=MathRand();
   

//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   ObjectDelete("FibLevel0"); 
   ObjectDelete("FibLevel1");
   ObjectDelete("FibLevel2");  
   ObjectDelete("FibLevel3"); 
   ObjectDelete("FibLevel4"); 
   ObjectDelete("FibLevel5"); 
   ObjectDelete("FibLevel6"); 
   
   Comment("");
    
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   
//---- 
      
   datetime starttime;
   int shift_open;
   int unitbars;
   //ArrayResize(starttime,ProcessedUnits);
   //ArrayResize(shift_open,ProcessedUnits);
   //ArrayResize(unitbars,ProcessedUnits);
   










//      int bar = WindowFirstVisibleBar();
//   
//   // If price breaking out to new highs or lows, don't redraw the fib until the next bar
//   // That's what the -1 and 1 are for.
//   int shiftLowest = iLowest(NULL, 0, MODE_LOW, bar - 1, 1);
//   int shiftHighest = iHighest(NULL, 0, MODE_HIGH, bar - 1, 1);       
//    
//   bool isSwingDown = shiftHighest > shiftLowest;
//
//   if (isSwingDown == true)
//   {     
   










   
      starttime =iTime(NULL,BasisTF,0);
      if(BasisTF==10080)
         shift_open=iBarShift(NULL,0,starttime)-1; // Because the weekly start is Sunday!
      else
         shift_open=iBarShift(NULL,0,starttime);

   unitbars=iBarShift(NULL,0,starttime)+1; // The number of candles remaining in the last unit (because incomplete unit is the last)
   // Summabars: number of candles
   int summabars=shift_open+1;
   
   int k=1;  
   for(int i=unitbars-1; i>=0; i--)
   {
                                
         int shift_close=iBarShift(NULL,0,Time[summabars-k]);  //index of bar for this time
         int countbars=shift_open-shift_close+1;
         
         
         H=High[iHighest(NULL,0,MODE_HIGH,countbars,summabars-k)];   //get highest price
         L=Low[iLowest(NULL,0,MODE_LOW,countbars,summabars-k)];      //get lowest price
         W=H-L;                                                      //difference between high and low prices
               
         Fib0[summabars-k]=H;
         Fib5[summabars-k]=L;
         
         Fib1[summabars-k]=H-(W*0.236);
         Fib2[summabars-k]=H-(W*0.382);
         Fib3[summabars-k]=H-(W*0.50);
         Fib4[summabars-k]=H-(W*0.618);
         Fib6[summabars-k]=H-(W*0.764);
      
         k++;
   }
   
   //
   ObjectDelete("FibLevel0"); 
   ObjectDelete("FibLevel1");
   ObjectDelete("FibLevel2");  
   ObjectDelete("FibLevel3"); 
   ObjectDelete("FibLevel4"); 
   ObjectDelete("FibLevel5"); 
   ObjectDelete("FibLevel6"); 
         
   int Is_JPY=StringFind(Symbol(),"JPY",0);
   if(Is_JPY==-1)
   {
   int DisplayDec=DisplayDecimals;
   }
   else if(Is_JPY!=-1)
   {
   DisplayDec=DisplayDecimals-2;
   }
   
   if(iHighest(NULL,0,MODE_HIGH,unitbars,0)<iLowest(NULL,0,MODE_LOW,unitbars,0)) 
   {
   // up
   ObjectCreate("FibLevel0",OBJ_TEXT,0,Time[0],Fib0[0]);
   ObjectSetText("FibLevel0",StringConcatenate("                      0.0% - ",DoubleToStr(Fib0[0],DisplayDec)),8,"Tahoma",TextColor); 
   ObjectCreate("FibLevel1",OBJ_TEXT,0,Time[0],Fib1[0]);
   ObjectSetText("FibLevel1",StringConcatenate("                       23.6% - ",DoubleToStr(Fib1[0],DisplayDec)),8,"Tahoma",TextColor);  
   ObjectCreate("FibLevel2",OBJ_TEXT,0,Time[0],Fib2[0]);
   ObjectSetText("FibLevel2",StringConcatenate("                       38.2% - ",DoubleToStr(Fib2[0],DisplayDec)),8,"Tahoma",TextColor);   
   ObjectCreate("FibLevel3",OBJ_TEXT,0,Time[0],Fib3[0]);
   ObjectSetText("FibLevel3",StringConcatenate("                       50.0% - ",DoubleToStr(Fib3[0],DisplayDec)),8,"Tahoma",TextColor); 
   ObjectCreate("FibLevel4",OBJ_TEXT,0,Time[0],Fib4[0]);
   ObjectSetText("FibLevel4",StringConcatenate("                       61.8% - ",DoubleToStr(Fib4[0],DisplayDec)),8,"Tahoma",TextColor); 
   ObjectCreate("FibLevel5",OBJ_TEXT,0,Time[0],Fib5[0]);
   ObjectSetText("FibLevel5",StringConcatenate("                        100.0% - ",DoubleToStr(Fib5[0],DisplayDec)),8,"Tahoma",TextColor); 
   ObjectCreate("FibLevel6",OBJ_TEXT,0,Time[0],Fib6[0]);
   ObjectSetText("FibLevel6",StringConcatenate("                       76.4% - ",DoubleToStr(Fib6[0],DisplayDec)),8,"Tahoma",TextColor); 
   }
   else
   {
   // down
   ObjectCreate("FibLevel0",OBJ_TEXT,0,Time[0],Fib0[0]);
   ObjectSetText("FibLevel0",StringConcatenate("                        100.0% - ",DoubleToStr(Fib0[0],DisplayDec)),8,"Tahoma",TextColor); 
   ObjectCreate("FibLevel1",OBJ_TEXT,0,Time[0],Fib1[0]);
   ObjectSetText("FibLevel1",StringConcatenate("                       76.4% - ",DoubleToStr(Fib1[0],DisplayDec)),8,"Tahoma",TextColor);
   ObjectCreate("FibLevel2",OBJ_TEXT,0,Time[0],Fib2[0]);
   ObjectSetText("FibLevel2",StringConcatenate("                       61.8% - ",DoubleToStr(Fib2[0],DisplayDec)),8,"Tahoma",TextColor);   
   ObjectCreate("FibLevel3",OBJ_TEXT,0,Time[0],Fib3[0]);
   ObjectSetText("FibLevel3",StringConcatenate("                       50.0% - ",DoubleToStr(Fib3[0],DisplayDec)),8,"Tahoma",TextColor); 
   ObjectCreate("FibLevel4",OBJ_TEXT,0,Time[0],Fib4[0]);
   ObjectSetText("FibLevel4",StringConcatenate("                       38.2% - ",DoubleToStr(Fib4[0],DisplayDec)),8,"Tahoma",TextColor); 
   ObjectCreate("FibLevel5",OBJ_TEXT,0,Time[0],Fib5[0]);
   ObjectSetText("FibLevel5",StringConcatenate("                      0.0% - ",DoubleToStr(Fib5[0],DisplayDec)),8,"Tahoma",TextColor); 
   ObjectCreate("FibLevel6",OBJ_TEXT,0,Time[0],Fib6[0]);
   ObjectSetText("FibLevel6",StringConcatenate("                       23.6% - ",DoubleToStr(Fib6[0],DisplayDec)),8,"Tahoma",TextColor); 
   }
   
   
   Comment(">> JJN-Fibo || http://jjnewark.atw.hu");
   
//----
   
//----
   return(0);
  }
//+------------------------------------------------------------------+


