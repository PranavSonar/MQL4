//+------------------------------------------------------------------+
//|                                                Elliott_Waves.mq4 |
//|                                Copyright © 2009, Õëûñòîâ Âëàäèìð |
//|                                                ñmillion@narod.ru |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2009, Õëûñòîâ Âëàäèìð"
#property link      "ñmillion@narod.ru"
 
#property indicator_chart_window
 
   datetime X1,X2;
   double   Y1,Y2,LINE[11][6];
   int ÑÒÈËÜ,Ò_ËÈÍÈÈ,ÂÎËÍÀ,ÖÂÅÒ;
   double High_Win,Low_Win,shift_X,shift_Y;
   string Name[11]={ "-",
                     "1 ÂÎËÍÀ ","2 ÂÎËÍÀ ","3 ÂÎËÍÀ ","4 ÂÎËÍÀ ","5 ÂÎËÍÀ ",
                     "a ÂÎËÍÀ ","b ÂÎËÍÀ ","c ÂÎËÍÀ ","d ÂÎËÍÀ ","e ÂÎËÍÀ "};
   string òåêñò,Obj_Name,ÈÍÔÎ;
   int per;
   extern bool  ïîêàçàòü_âñå_ïåðèîäû = true;
   extern color Ö1=White;
   extern color Ö2=DeepSkyBlue;
   extern color Ö3=Yellow;
   extern color Ö4=Turquoise;
   extern color Ö5=Magenta;
   extern color Ö6=Yellow;
   extern color Ö7=MediumSpringGreen;
   extern color Ö8=Violet;
   extern color Ö9=DarkOrchid;
 
//æææææææææææææææææææææææææææææææææææææææææææææææææææææææææææææææææææ
//////////////////////////////////////////////////////////////////////
int init()
{
   ObjectCreate ("áàð", OBJ_LABEL, 0, 0, 0);// Ñîçäàíèå îáú.
   ObjectSet    ("áàð", OBJPROP_XDISTANCE, 500);      
   ObjectSet    ("áàð", OBJPROP_YDISTANCE, 0);
   ObjectSet    ("áàð", OBJPROP_CORNER, 1); //óãîë_âûâîäà_îðäåðîâ
   per =Period();
   Obj_Name = string_ïåð(per);
   for(int k=0; k<=10; k++) Name[k] = Name[k]+Obj_Name;
   Comment("ÂÎËÍÛ ÝËËÈÎÒÀ "+Obj_Name+" "+âðåìÿ(CurTime()));
   return(0);
}
//æææææææææææææææææææææææææææææææææææææææææææææææææææææææææææææææææææ
//*////////////////////////////////////////////////////////////////*//
int deinit()
  {
      ObjectDelete("áàð");
      óäàëèòü_îáüåêòû("Ö");
      óäàëèòü_îáüåêòû("Name");
      óäàëèòü_îáüåêòû("Èíôî");
   return(0);
  }
//*////////////////////////////////////////////////////////////////*//
//æææææææææææææææææææææææææææææææææææææææææææææææææææææææææææææææææææ
 
//æææææææææææææææææææææææææææææææææææææææææææææææææææææææææææææææææææ
//////////////////////////////////////////////////////////////////////
int start()
{
   High_Win = WindowPriceMax();
   Low_Win  = WindowPriceMin();
   shift_X = WindowBarsPerChart();
   ObjectSetText("áàð","Áàð íà ýêðàíå "+DoubleToStr(shift_X,0),8,"Arial",White);   
   shift_X = shift_X/80*per;
   shift_Y = (High_Win-Low_Win) / 50;
   for(int k=0; k<=ObjectsTotal(); k++) 
   {
      Obj_Name = ObjectName(k);                           // Çàïðàøèâàåì èìÿ îáúåêòà
      if (Obj_Name=="") continue;
      ÂÎËÍÀ = N_Âîëíû(Obj_Name);
      if (ÂÎËÍÀ>0&&ÂÎËÍÀ<11)
      {
         if (Obj_Name != Name[ÂÎËÍÀ]) redraw_LINE(Obj_Name,Name[ÂÎËÍÀ]);
         X1 =    ObjectGet(Name[ÂÎËÍÀ], OBJPROP_TIME1); 
         Y1 =    ObjectGet(Name[ÂÎËÍÀ], OBJPROP_PRICE1);
         X2 =    ObjectGet(Name[ÂÎËÍÀ], OBJPROP_TIME2); 
         Y2 =    ObjectGet(Name[ÂÎËÍÀ], OBJPROP_PRICE2);
         ÖÂÅÒ  = ObjectGet(Name[ÂÎËÍÀ], OBJPROP_COLOR);
         ÑÒÈËÜ = ObjectGet(Name[ÂÎËÍÀ], OBJPROP_STYLE);
         Ò_ËÈÍÈÈ=ObjectGet(Name[ÂÎËÍÀ], OBJPROP_WIDTH);
         if (X1 > X2) redraw_LINE(Name[ÂÎËÍÀ],Name[ÂÎËÍÀ]+" r ");
         if (Y1 < Y2) LINE[ÂÎËÍÀ][0]=1; else LINE[ÂÎËÍÀ][0]=-1;//íàïðàâëåíèå âîëíû
         ObjectDelete("Ö "+Name[ÂÎËÍÀ]);
         ObjectDelete("Öåëü "+Name[ÂÎËÍÀ]);
         LINE[ÂÎËÍÀ][1]=X1;//íà÷àëî âîëíû
         LINE[ÂÎËÍÀ][2]=Y1;
         LINE[ÂÎËÍÀ][3]=X2;//êîíåö âîëíû
         LINE[ÂÎËÍÀ][4]=Y2;
         LINE[ÂÎËÍÀ][5]=Îáüåì_Âîëíû(Name[ÂÎËÍÀ]);
         if ((MathAbs(LINE[ÂÎËÍÀ][3]-LINE[ÂÎËÍÀ+1][1])<per*120) || (MathAbs(LINE[ÂÎËÍÀ][4]-LINE[ÂÎËÍÀ+1][2])/Point<=MarketInfo(Symbol(),MODE_STOPLEVEL)))
         {
            ObjectSet   (Name[ÂÎËÍÀ+1], OBJPROP_COLOR, ÖÂÅÒ); //ñòûêîâêà - âûäåëåíèå öâåòà
            ObjectSet   (Name[ÂÎËÍÀ+1], OBJPROP_STYLE, ÑÒÈËÜ);// Ñòèëü   
            ObjectSet   (Name[ÂÎËÍÀ+1], OBJPROP_WIDTH, Ò_ËÈÍÈÈ);
            ObjectSet   (Name[ÂÎËÍÀ+1], OBJPROP_PRICE1 ,LINE[ÂÎËÍÀ][4]);//Ïðèâÿçêà ñëåäóþùåé âîëíû ê òåêóùåé PRICE1
            ObjectSet   (Name[ÂÎËÍÀ+1], OBJPROP_TIME1  ,LINE[ÂÎËÍÀ][3]);//Ïðèâÿçêà ñëåäóþùåé âîëíû ê òåêóùåé TIME1
         }
         ÈÍÔÎ = "Èíôî "+Name[ÂÎËÍÀ]+" ðû÷àã "+DoubleToStr(MathAbs(LINE[ÂÎËÍÀ][2]-LINE[ÂÎËÍÀ][4])/Point,0);
         if (ÂÎËÍÀ==3&&(LINE[3][5]<LINE[2][5]||LINE[3][5]<LINE[1][5]||LINE[3][5]<LINE[4][5]||LINE[3][5]<LINE[5][5])) òåêñò = "Îáüåì íå ìîæåò áûòü ìåíüøå â 3 âîëíå "+DoubleToStr(LINE[ÂÎËÍÀ][5],0);
         else òåêñò = "V = "+DoubleToStr(LINE[ÂÎËÍÀ][5],0);
         óäàëèòü_îáüåêòû("Èíôî");
         ObjectCreate (ÈÍÔÎ, OBJ_TEXT  ,0,LINE[ÂÎËÍÀ][3], LINE[ÂÎËÍÀ][4]+shift_Y*Ò_ËÈÍÈÈ*3*LINE[ÂÎËÍÀ][0],0,0,0,0);
         ObjectSetText(ÈÍÔÎ,òåêñò ,8,"Arial");
         ObjectSet    (ÈÍÔÎ, OBJPROP_COLOR, ÖÂÅÒ);
         
         ObjectDelete ("Name "+Name[ÂÎËÍÀ]);
         ObjectCreate ("Name "+Name[ÂÎËÍÀ], OBJ_TEXT  ,0,LINE[ÂÎËÍÀ][3], LINE[ÂÎËÍÀ][4]+shift_Y*Ò_ËÈÍÈÈ*2*LINE[ÂÎËÍÀ][0]+0.7*shift_Y,0,0,0,0);
         if (ÔÐÀÊÒÀË(LINE[ÂÎËÍÀ][3],Name[ÂÎËÍÀ])==true)
         {
            ObjectSetText("Name "+Name[ÂÎËÍÀ], StringSubstr(Name[ÂÎËÍÀ],0,1),10*Ò_ËÈÍÈÈ,"Arial");
            ObjectSet    ("Name "+Name[ÂÎËÍÀ], OBJPROP_COLOR, ÖÂÅÒ);
         }
         else
         {
            ObjectSetText("Name "+Name[ÂÎËÍÀ], "íåò ôðàêòàëà" ,10,"Arial");
            ObjectSet    ("Name "+Name[ÂÎËÍÀ], OBJPROP_COLOR, Red);
         }
         if (LINE[ÂÎËÍÀ][3]!=LINE[ÂÎËÍÀ+1][1]) // åñëè íåò ñëåäóþùåé âîëíû
         {
               if (LINE[ÂÎËÍÀ][1]!=LINE[ÂÎËÍÀ-1][3]) // åñëè íåò ïðåäûäóùåé âîëíû
               {
                  X1=LINE[ÂÎËÍÀ][3]+(LINE[ÂÎËÍÀ][3]-LINE[ÂÎËÍÀ][1])*0.38;
                  X2=LINE[ÂÎËÍÀ][3]+(LINE[ÂÎËÍÀ][3]-LINE[ÂÎËÍÀ][1])*0.62;
                  Y1=LINE[ÂÎËÍÀ][4]+(LINE[ÂÎËÍÀ][2]-LINE[ÂÎËÍÀ][4])*0.38; 
                  Y2=LINE[ÂÎËÍÀ][4]+(LINE[ÂÎËÍÀ][2]-LINE[ÂÎËÍÀ][4])*0.62;
 
                  if (ÂÎËÍÀ==6) //òåêóùàÿ Âîëíà a
                        Y1=LINE[6][4]+(LINE[6][2]-LINE[6][4])*0.50; 
 
               }
               else//åñòü ïðåä âîëíà
               {
                  switch(ÂÎËÍÀ)
                  {
                     case 2 ://òåêóùàÿ Âîëíà 2
                        X2=LINE[2][3]+(LINE[2][3]-LINE[1][1])/0.38;
                        X1=LINE[2][3]+(LINE[2][3]-LINE[1][1])/0.62;
                        Y1=LINE[1][4]-MathAbs(LINE[1][2]-LINE[1][4])*LINE[2][0]*1.00; 
                        Y2=LINE[1][4]-MathAbs(LINE[1][2]-LINE[1][4])*LINE[2][0]*1.62;
                        break;
                     case 3 ://òåêóùàÿ Âîëíà 3
                        X1=LINE[2][1]+(LINE[3][3]-LINE[1][3])*1.38;
                        X2=LINE[3][1]+(LINE[3][3]-LINE[1][3])*1.62;
                        Y1=LINE[3][4]-MathAbs(LINE[3][2]-LINE[3][4])*LINE[3][0]*0.38; 
                        Y2=LINE[3][4]-MathAbs(LINE[3][2]-LINE[3][4])*LINE[3][0]*0.50;
                        if ((Y2<LINE[1][4] && LINE[3][0]==1)||(Y2>LINE[1][4] && LINE[3][0]==-1))
                        {
                           ObjectSetText("Name "+Name[ÂÎËÍÀ],"4 ÂÎËÍÀ íå ìîæåò ëåæàòü íèæå 1 ÂÎËÍÛ",8,"Arial");
                           ObjectSet    ("Name "+Name[ÂÎËÍÀ], OBJPROP_COLOR, Red);
                        }
                        if (LINE[1][3]!=LINE[2][1])
                        {
                           ObjectSet(Name[ÂÎËÍÀ], OBJPROP_COLOR, Red);
                           ObjectSetText("Name "+Name[ÂÎËÍÀ],"íåò ÂÎËÍÛ 1",8,"Arial");
                           ObjectSet    ("Name "+Name[ÂÎËÍÀ], OBJPROP_COLOR, Red);
                        }
                        break;
                     case 4 ://òåêóùàÿ Âîëíà 4
                        X1=LINE[4][3]+(LINE[3][3]-LINE[3][1])*0.38;
                        X2=LINE[4][3]+(LINE[3][3]-LINE[3][1])*0.62;
                        Y1=LINE[4][2]-MathAbs(LINE[1][2]-LINE[3][4])*LINE[4][0]*0.62; 
                        Y2=LINE[4][2]-MathAbs(LINE[1][2]-LINE[3][4])*LINE[4][0]*1.00;
                        òåêñò="--4 ÂÎËÍÀ <> 1 ÂÎËÍÛ--";
                        ObjectDelete(òåêñò);
                        if ((LINE[4][4]<LINE[1][4] && LINE[4][0]==-1)||(LINE[4][4]>LINE[1][4] && LINE[4][0]==1))
                        {
                           ObjectSet(Name[ÂÎËÍÀ], OBJPROP_COLOR, Red);
                           ObjectSetText("Name "+Name[ÂÎËÍÀ],"4 ÂÎËÍÀ íå ìîæåò ëåæàòü íèæå 1 ÂÎËÍÛ",8,"Arial");
                           ObjectSet    ("Name "+Name[ÂÎËÍÀ], OBJPROP_COLOR, Red);
                           ObjectCreate(òåêñò, OBJ_TREND, 0,LINE[1][3],LINE[1][4],LINE[4][3],LINE[1][4]);
                           ObjectSet   (òåêñò, OBJPROP_COLOR, Red);    // Öâåò   
                           ObjectSet   (òåêñò, OBJPROP_STYLE, STYLE_DASH);// Ñòèëü   
                           ObjectSet   (òåêñò, OBJPROP_WIDTH, 0);
                           ObjectSet   (òåêñò, OBJPROP_BACK,  true);
                           ObjectSet   (òåêñò, OBJPROP_RAY,   false);     // Ëó÷   
                        }
                        if (LINE[1][3]!=LINE[2][1] || LINE[2][3]!=LINE[3][1])
                        {
                           ObjectSet(Name[ÂÎËÍÀ], OBJPROP_COLOR, Red);
                           ObjectSetText("Name "+Name[ÂÎËÍÀ],"íåò ÂÎËÍÛ 1 èëè 2",8,"Arial");
                           ObjectSet    ("Name "+Name[ÂÎËÍÀ], OBJPROP_COLOR, Red);
                        }
                        break;
                     case 5 ://òåêóùàÿ Âîëíà 5
                        X1=LINE[5][3]+(LINE[5][3]-LINE[5][1])*0.38;
                        X2=LINE[5][3]+(LINE[5][3]-LINE[5][1])*0.62;
                        Y1=LINE[5][4]-MathAbs(LINE[5][2]-LINE[5][4])*LINE[5][0]*0.38; 
                        Y2=LINE[5][4]-MathAbs(LINE[5][2]-LINE[5][4])*LINE[5][0]*0.62;
                        double MFI_3=iMACD(NULL,0,5,34,5,PRICE_CLOSE,MODE_MAIN  ,iBarShift(NULL,0,LINE[3][3],FALSE));
                        double MFI_5=iMACD(NULL,0,5,34,5,PRICE_CLOSE,MODE_MAIN  ,iBarShift(NULL,0,LINE[5][3],FALSE));
                        if (LINE[1][3]!=LINE[2][1] || LINE[2][3]!=LINE[3][1] || LINE[3][3]!=LINE[4][1])
                        {
                           ObjectSet(Name[ÂÎËÍÀ], OBJPROP_COLOR, Red);
                           ObjectSetText("Name "+Name[ÂÎËÍÀ],"íåò ÂÎËÍÛ 1,2 èëè 3",8,"Arial");
                           ObjectSet    ("Name "+Name[ÂÎËÍÀ], OBJPROP_COLOR, Red);
                        }
                        if ((MFI_3 < MFI_5 && LINE[5][0]==1)||(MFI_3 > MFI_5 && LINE[5][0]==-1))
                        {
                           ObjectDelete ("MFI "+âðåìÿ(LINE[3][3]));
                           ObjectCreate ("MFI "+âðåìÿ(LINE[3][3]),OBJ_TEXT,0,LINE[3][3],LINE[5][4]+shift_Y*LINE[5][0],0,0,0,0);
                           ObjectSetText("MFI "+âðåìÿ(LINE[3][3]),DoubleToStr(MFI_3,0),8,"Arial");
                           ObjectSet    ("MFI "+âðåìÿ(LINE[3][3]),OBJPROP_COLOR, ÖÂÅÒ);
                           ObjectDelete ("MFI "+âðåìÿ(LINE[5][3]));
                           ObjectCreate ("MFI "+âðåìÿ(LINE[5][3]),OBJ_TEXT,0,LINE[5][3],LINE[5][4]+shift_Y*LINE[5][0],0,0,0,0);
                           ObjectSetText("MFI "+âðåìÿ(LINE[5][3]),DoubleToStr(MFI_5,0),8,"Arial");
                           ObjectSet    ("MFI "+âðåìÿ(LINE[5][3]),OBJPROP_COLOR, ÖÂÅÒ);
                           ObjectSetText("Name "+Name[ÂÎËÍÀ],"Íåò äèâåðãåíöèè MFI 3 è 5 ÂÎËÍÛ",8,"Arial");
                           ObjectSet    ("Name "+Name[ÂÎËÍÀ], OBJPROP_COLOR, Red);
                        }
                        break;
                     case 6 ://òåêóùàÿ Âîëíà a
                        X1=LINE[6][3]+(LINE[6][3]-LINE[6][1])*0.38;
                        X2=LINE[6][3]+(LINE[6][3]-LINE[6][1])*0.62;
                        Y1=LINE[6][4]+(LINE[6][2]-LINE[6][4])*0.50; 
                        Y2=LINE[6][4]+(LINE[6][2]-LINE[6][4])*0.62;
                        break;
                     case 7 ://òåêóùàÿ Âîëíà b
                        X2=LINE[7][3]+(LINE[7][3]-LINE[6][1])/0.38;
                        X1=LINE[7][3]+(LINE[7][3]-LINE[6][1])/0.62;
                        Y1=LINE[6][4]-MathAbs(LINE[6][2]-LINE[6][4])*LINE[7][0]*1.00; 
                        Y2=LINE[6][4]-MathAbs(LINE[6][2]-LINE[6][4])*LINE[7][0]*1.62;
                        break;
                     case 8 ://òåêóùàÿ Âîëíà c
                        X1=LINE[7][1]+(LINE[8][3]-LINE[6][3])*1.38;
                        X2=LINE[7][1]+(LINE[8][3]-LINE[6][3])*1.62;
                        Y1=LINE[8][4]-MathAbs(LINE[8][2]-LINE[8][4])*LINE[8][0]*0.38; 
                        Y2=LINE[8][4]-MathAbs(LINE[8][2]-LINE[8][4])*LINE[8][0]*0.50;
                        if (LINE[6][3]!=LINE[7][1])
                        {
                           ObjectSet(Name[ÂÎËÍÀ], OBJPROP_COLOR, Red);
                           ObjectSetText("Name "+Name[ÂÎËÍÀ],"íåò ÂÎËÍÛ a",8,"Arial");
                           ObjectSet    ("Name "+Name[ÂÎËÍÀ], OBJPROP_COLOR, Red);
                        }
                        break;
                     case 9 ://òåêóùàÿ Âîëíà d
                        X1=LINE[9][3]+(LINE[8][3]-LINE[8][1])*0.38;
                        X2=LINE[9][3]+(LINE[8][3]-LINE[8][1])*0.62;
                        Y1=LINE[9][2]-MathAbs(LINE[6][2]-LINE[8][4])*LINE[9][0]*0.62; 
                        Y2=LINE[9][2]-MathAbs(LINE[6][2]-LINE[8][4])*LINE[9][0]*1.00;
                         if (LINE[6][3]!=LINE[7][1] || LINE[7][3]!=LINE[8][1])
                        {
                           ObjectSet(Name[ÂÎËÍÀ], OBJPROP_COLOR, Red);
                           ObjectSetText("Name "+Name[ÂÎËÍÀ],"íåò ÂÎËÍÛ a èëè b ",8,"Arial");
                           ObjectSet    ("Name "+Name[ÂÎËÍÀ], OBJPROP_COLOR, Red);
                        }
                        break;
                     case 10 ://òåêóùàÿ Âîëíà e
                        X1=LINE[10][3]+(LINE[10][3]-LINE[10][1])*0.38;
                        X2=LINE[10][3]+(LINE[10][3]-LINE[10][1])*0.62;
                        Y1=LINE[10][4]-MathAbs(LINE[10][2]-LINE[10][4])*LINE[10][0]*0.38; 
                        Y2=LINE[10][4]-MathAbs(LINE[10][2]-LINE[10][4])*LINE[10][0]*0.62;
                        if (LINE[6][3]!=LINE[7][1] || LINE[7][3]!=LINE[8][1] || LINE[8][3]!=LINE[9][1])
                        {
                           ObjectSet(Name[ÂÎËÍÀ], OBJPROP_COLOR, Red);
                           ObjectSetText("Name "+Name[ÂÎËÍÀ],"íåò ÂÎËÍÛ a,b èëè c",8,"Arial");
                           ObjectSet    ("Name "+Name[ÂÎËÍÀ], OBJPROP_COLOR, Red);
                        }
                        break;
                  }//switch
            }
            ObjectCreate("Ö "+Name[ÂÎËÍÀ], OBJ_TREND, 0,LINE[ÂÎËÍÀ][3],LINE[ÂÎËÍÀ][4],X1,Y1);
            ObjectSet   ("Ö "+Name[ÂÎËÍÀ], OBJPROP_COLOR, ÖÂÅÒ);    // Öâåò   
            ObjectSet   ("Ö "+Name[ÂÎËÍÀ], OBJPROP_STYLE, STYLE_DASH);// Ñòèëü   
            ObjectSet   ("Ö "+Name[ÂÎËÍÀ], OBJPROP_WIDTH, 0);
            ObjectSet   ("Ö "+Name[ÂÎËÍÀ], OBJPROP_BACK,  true);
            ObjectSet   ("Ö "+Name[ÂÎËÍÀ], OBJPROP_RAY,   false);     // Ëó÷   
               
            ObjectCreate("Öåëü "+Name[ÂÎËÍÀ], OBJ_RECTANGLE,0,0,0,0,0);
            ObjectSet   ("Öåëü "+Name[ÂÎËÍÀ], OBJPROP_STYLE, STYLE_DASH);
            ObjectSet   ("Öåëü "+Name[ÂÎËÍÀ], OBJPROP_COLOR, ÖÂÅÒ);
            ObjectSet   ("Öåëü "+Name[ÂÎËÍÀ], OBJPROP_BACK,  false);
            ObjectSet   ("Öåëü "+Name[ÂÎËÍÀ], OBJPROP_TIME1 ,X1);
            ObjectSet   ("Öåëü "+Name[ÂÎËÍÀ], OBJPROP_PRICE1,Y1);
            ObjectSet   ("Öåëü "+Name[ÂÎËÍÀ], OBJPROP_TIME2 ,X2);
            ObjectSet   ("Öåëü "+Name[ÂÎËÍÀ], OBJPROP_PRICE2,Y2);
         }
      }//-Âîëíû 1 - å --------------------------------------------------------------------------------------------------------+
   }//for
  
   ÖÂÅÒ = color_per(per);
   for(k=1; k<=10; k++) 
   {
      ObjectDelete ("Name "+k);
      if (ObjectFind(Name[k])==0)
      {
         ObjectCreate ("Name "+k, OBJ_LABEL, 0, 0, 0);// Ñîçäàíèå îáú.
         ObjectSetText("Name "+k, Name[k]+âðåìÿ(LINE[k][1])+" "+DoubleToStr(LINE[k][2],Digits)+" "+âðåìÿ(LINE[k][3])+" "+DoubleToStr(LINE[k][4],Digits)     ,8,"Arial");
         ObjectSet    ("Name "+k, OBJPROP_CORNER, 3);
         ObjectSet    ("Name "+k, OBJPROP_XDISTANCE, 300);
         ObjectSet    ("Name "+k, OBJPROP_YDISTANCE, 10+10*k);
         ObjectSet    ("Name "+k, OBJPROP_COLOR, ÖÂÅÒ);    // Öâåò 
      }
      else //î÷èñòêà çíà÷åíèé óäàëåííîé âîëíû
      {
         LINE[k][0]=0;LINE[k][1]=0;LINE[k][2]=0;LINE[k][3]=0;LINE[k][4]=0;LINE[k][5]=0;
         //óäàëèòü_îáüåêòû("Name");
         //óäàëèòü_îáüåêòû("MFI");
         ObjectDelete("Ö "+Name[k]);
         ObjectDelete("ÔÐÀÊÒÀË "+Name[k]);
         ObjectDelete("color_MFI "+Name[k]+"1");
         ObjectDelete("color_MFI "+Name[k]+"2");
         ObjectDelete("color_MFI "+Name[k]+"3");
         ObjectDelete("color_MFI "+Name[k]+"4");
         ObjectDelete("color_MFI "+Name[k]+"5");
         óäàëèòü_îáüåêòû("Èíôî "+Name[k]);
         ObjectDelete("Öåëü "+Name[k]);
         ObjectDelete("Name "+Name[k]);
      } //î÷èñòêà çíà÷åíèé óäàëåííîé âîëíû
   }
return;
}
//////////////////////////////////////////////////////////////////////
//æææææææææææææææææææææææææææææææææææææææææææææææææææææææææææææææææææ*/
 
//æææææææææææææææææææææææææææææææææææææææææææææææææææææææææææææææææææ*/
//////////////////////////////////////////////////////////////////////
void redraw_LINE(string old, string ÈÌß)
{
   datetime x1,x2;
   double   y1,y2;
   ÑÒÈËÜ = ObjectGet(old, OBJPROP_STYLE);
   ÖÂÅÒ = ObjectGet(old, OBJPROP_COLOR);
   Ò_ËÈÍÈÈ = ObjectGet(old, OBJPROP_WIDTH);    // Ò ËÈÍÈÈ
   x1 =     ObjectGet(old, OBJPROP_TIME1);
   y1 =     ObjectGet(old, OBJPROP_PRICE1);
   x2 =     ObjectGet(old, OBJPROP_TIME2);
   y2 =     ObjectGet(old, OBJPROP_PRICE2);
   if (x1>x2)
   {
      x2 =     ObjectGet(old, OBJPROP_TIME1);
      y2 =     ObjectGet(old, OBJPROP_PRICE1);
      x1 =     ObjectGet(old, OBJPROP_TIME2);
      y1 =     ObjectGet(old, OBJPROP_PRICE2);
   }
   ObjectDelete(ÈÌß); //óäàëÿåò äâîéíèêà
   ObjectCreate(ÈÌß, OBJ_TREND, 0,  x1,y1,x2,y2);
   ObjectSet   (ÈÌß, OBJPROP_COLOR, ÖÂÅÒ);    // Öâåò   
   ObjectSet   (ÈÌß, OBJPROP_STYLE, ÑÒÈËÜ);    // Ñòèëü   
   ObjectSet   (ÈÌß, OBJPROP_WIDTH, Ò_ËÈÍÈÈ);    // Ò ËÈÍÈÈ
   ObjectSet   (ÈÌß, OBJPROP_BACK,  true);
   ObjectSet   (ÈÌß, OBJPROP_RAY,   false);    // Ëó÷   
   ObjectDelete(old);
 
return;
}
//////////////////////////////////////////////////////////////////////
//æææææææææææææææææææææææææææææææææææææææææææææææææææææææææææææææææææ*/
 
//æææææææææææææææææææææææææææææææææææææææææææææææææææææææææææææææææææ*/
//////////////////////////////////////////////////////////////////////
//-- ÔÐÀÊÒÀË -------------------------------------------------------------------------
bool ÔÐÀÊÒÀË(datetime t,string ÈÌß)
{
   int i=0,KOD;
   int ÒÅÊ_ÁÀÐ=iBarShift(NULL,0,t,FALSE);
   double fr_DN = iFractals(NULL,0,MODE_LOWER,ÒÅÊ_ÁÀÐ);
   double fr_UP = iFractals(NULL,0,MODE_UPPER,ÒÅÊ_ÁÀÐ);
   if (fr_UP==0 &&fr_DN ==0) return(false);
   ObjectDelete("ÔÐÀÊÒÀË "+ÈÌß);
   double y,Y,fr;
   if (ObjectFind(ÈÌß)==0)
   {
      if (fr_DN!=0) fr=fr_DN; else fr=fr_UP;
      if (t==ObjectGet(ÈÌß, OBJPROP_TIME2)) ObjectSet(ÈÌß, OBJPROP_PRICE2,fr);//Ïðèâÿçêà âîëíû ê ÔÐÀÊÒÀËÓ
      if (t==ObjectGet(ÈÌß, OBJPROP_TIME1)) ObjectSet(ÈÌß, OBJPROP_PRICE1,fr);//Ïðèâÿçêà âîëíû ê ÔÐÀÊÒÀËÓ
      ÖÂÅÒ  = ObjectGet(ÈÌß, OBJPROP_COLOR);
      Ò_ËÈÍÈÈ = ObjectGet(ÈÌß, OBJPROP_WIDTH);    // Ò ËÈÍÈÈ
   }
   else
   {
      ÖÂÅÒ  = Yellow;
      Ò_ËÈÍÈÈ = 1;    // Ò ËÈÍÈÈ
   }
   if (fr_DN != 0) {Y = fr_DN-shift_Y * Ò_ËÈÍÈÈ + 0.5 * shift_Y; y = Y + 0.7 * shift_Y; KOD=218;} 
   if (fr_UP != 0) {Y = fr_UP+shift_Y * Ò_ËÈÍÈÈ + 0.5 * shift_Y; y = Y - 1.2 * shift_Y; KOD=217;}
   ObjectCreate("ÔÐÀÊÒÀË "+ÈÌß, OBJ_ARROW,0,t,Y,0,0,0,0);
   ObjectSet   ("ÔÐÀÊÒÀË "+ÈÌß, OBJPROP_ARROWCODE,KOD);
   ObjectSet   ("ÔÐÀÊÒÀË "+ÈÌß, OBJPROP_COLOR,ÖÂÅÒ );
   for(int k=ÒÅÊ_ÁÀÐ-2; k<=ÒÅÊ_ÁÀÐ+2; k++) 
   {
      i++;
      ObjectDelete("color_MFI "+ÈÌß+i);
      ObjectCreate("color_MFI "+ÈÌß+i, OBJ_ARROW,0,Time[k],y,0,0,0,0);
      ObjectSet   ("color_MFI "+ÈÌß+i, OBJPROP_ARROWCODE,117);
      ObjectSet   ("color_MFI "+ÈÌß+i, OBJPROP_WIDTH, 0);    // Ò ËÈÍÈÈ
      ObjectSet   ("color_MFI "+ÈÌß+i, OBJPROP_BACK, true);
      if ( iVolume(NULL, 0, k) > iVolume(NULL, 0, k+1) && iBWMFI(NULL, 0, k) > iBWMFI(NULL, 0, k+1) ) ObjectSet("color_MFI "+ÈÌß+i, OBJPROP_COLOR,Lime); //Çåëåíûé
      if ( iVolume(NULL, 0, k) < iVolume(NULL, 0, k+1) && iBWMFI(NULL, 0, k) < iBWMFI(NULL, 0, k+1) ) ObjectSet("color_MFI "+ÈÌß+i, OBJPROP_COLOR,Brown); //Óâÿäàþùèé
      if ( iVolume(NULL, 0, k) < iVolume(NULL, 0, k+1) && iBWMFI(NULL, 0, k) > iBWMFI(NULL, 0, k+1) ) ObjectSet("color_MFI "+ÈÌß+i, OBJPROP_COLOR,Blue); //Ôàëüøèâûé
      if ( iVolume(NULL, 0, k) > iVolume(NULL, 0, k+1) && iBWMFI(NULL, 0, k) < iBWMFI(NULL, 0, k+1) ) ObjectSet("color_MFI "+ÈÌß+i, OBJPROP_COLOR,Pink); //Ïðèñåäàþùèé
      ObjectSet("ÔÐÀÊÒÀË "+ÈÌß, OBJPROP_WIDTH,Ò_ËÈÍÈÈ);    // Ò ËÈÍÈÈ
   }
return(true);
}
   //-- ÔÐÀÊÒÀË -------------------------------------------------------------------------
//////////////////////////////////////////////////////////////////////
//æææææææææææææææææææææææææææææææææææææææææææææææææææææææææææææææææææ*/
 
//æææææææææææææææææææææææææææææææææææææææææææææææææææææææææææææææææææ
///////////////////////////////////////////////////////////////////
string âðåìÿ(int taim)
{
   string sTaim;
   //int YY=TimeYear(taim);   // Year         
   int MN=TimeMonth(taim);  // Month                  
   int DD=TimeDay(taim);    // Day         
   int HH=TimeHour(taim);   // Hour                  
   int MM=TimeMinute(taim); // Minute   
 
   if (DD<10) sTaim = "0"+DoubleToStr(DD,0);
   else sTaim = DoubleToStr(DD,0);
   sTaim = sTaim+"/";
   if (MN<10) sTaim = sTaim+"0"+DoubleToStr(MN,0);
   else sTaim = sTaim+DoubleToStr(MN,0);
   sTaim = sTaim+" ";
   if (HH<10) sTaim = sTaim+"0"+DoubleToStr(HH,0);
   else sTaim = sTaim+DoubleToStr(HH,0);
   if (MM<10) sTaim = sTaim+":0"+DoubleToStr(MM,0);
   else sTaim = sTaim+":"+DoubleToStr(MM,0);
   return(sTaim);
}
//*////////////////////////////////////////////////////////////////*//
//æææææææææææææææææææææææææææææææææææææææææææææææææææææææææææææææææææ
 
//æææææææææææææææææææææææææææææææææææææææææææææææææææææææææææææææææææ
//////////////////////////////////////////////////////////////////////
int N_Âîëíû(string Obj_Name)
{
   if (ObjectType(Obj_Name)!=2) return(-1);//òèï îáüåêòà íå ëèíèÿ
   int V=-1;
   string volna = StringSubstr( Obj_Name, 0, 2);
   if (volna=="1 ") V=1; 
   if (volna=="2 ") V=2; 
   if (volna=="3 ") V=3; 
   if (volna=="4 ") V=4; 
   if (volna=="5 ") V=5; 
   if (volna=="a ") V=6; 
   if (volna=="b ") V=7; 
   if (volna=="c ") V=8; 
   if (volna=="d ") V=9; 
   if (volna=="e ") V=10;
   if (V<0) return(-1);
   if (StringFind(Obj_Name,"ÂÎËÍÀ",2) != 2) return(V);
   //Îñòàëèñü òîëüêî ÂÎËÍû îáîçíà÷åííûå "ÂÎËÍÀ"
   if (StringFind(Obj_Name,string_ïåð(per),8) == 8) //âîëíà ñîçäàíà â ýòîì âðåìåííîì ïåðèîäå
   {
      ÖÂÅÒ = color_per(per);
      ObjectSet(Obj_Name,OBJPROP_COLOR,ÖÂÅÒ);
      return(V);
   }
return(-1);
}
//////////////////////////////////////////////////////////////////////
//æææææææææææææææææææææææææææææææææææææææææææææææææææææææææææææææææææ*/
 
//æææææææææææææææææææææææææææææææææææææææææææææææææææææææææææææææææææ
//////////////////////////////////////////////////////////////////////
color color_per(int per)
{
      switch(per)
      {
         case 1    :  //1 ìèíóòà
            return(Ö1);
         case 5    :  //5 ìèíóò 
            return(Ö2);
         case 15   :  //15 ìèíóò
            return(Ö3);
         case 30   :  //30 ìèíóò
            return(Ö4);
         case 60   :  //1 ÷àñ
            return(Ö5);
         case 240  :  //4 ÷àñà
            return(Ö6);
         case 1440 :  //1 äåíü
            return(Ö7);
         case 10080:  //1 íåäåëÿ
            return(Ö8);
         case 43200:  //1 ìåñÿö
            return(Ö9);
      }
return(Gray);
}
//////////////////////////////////////////////////////////////////////
//æææææææææææææææææææææææææææææææææææææææææææææææææææææææææææææææææææ*/
 
 
//æææææææææææææææææææææææææææææææææææææææææææææææææææææææææææææææææææ
//////////////////////////////////////////////////////////////////////
double Îáüåì_Âîëíû(string Name)
{
   double vol=0;
   int Íà÷_ÁÀÐ,Êîí_ÁÀÐ;
   int i=0;
   Íà÷_ÁÀÐ=iBarShift(NULL,0,ObjectGet(Name, OBJPROP_TIME1),FALSE);
   Êîí_ÁÀÐ=iBarShift(NULL,0,ObjectGet(Name, OBJPROP_TIME2),FALSE);
   for(int n=Êîí_ÁÀÐ; n<=Íà÷_ÁÀÐ; n++) 
   {
      vol = vol + iVolume(NULL,0,n);
      i++;
   }
   vol = vol/i;
//   vol = iVolume(NULL,0,Íà÷_ÁÀÐ);
return(vol);
}
//////////////////////////////////////////////////////////////////////
//æææææææææææææææææææææææææææææææææææææææææææææææææææææææææææææææææææ*/
 
//æææææææææææææææææææææææææææææææææææææææææææææææææææææææææææææææææææ
//*////////////////////////////////////////////////////////////////*//
string string_ïåð(int per)
{
   switch(per)
   {
      case 1    : return("M_1");   //1 ìèíóòà
         break;
      case 5    : return("M_5");   //5 ìèíóò 
         break;
      case 15   : return("M15");  //15 ìèíóò
         break;
      case 30   : return("M30");  //30 ìèíóò
         break;
      case 60   : return("H 1");   //1 ÷àñ
         break;
      case 240  : return("H_4");   //4 ÷àñà
         break;
      case 1440 : return("D_1");   //1 äåíü
         break;
      case 10080: return("W_1");   //1 íåäåëÿ
         break;
      case 43200: return("MN1");  //1 ìåñÿö
         break;
   }
return("îøèáêà ïåðèîäà");
}
//*////////////////////////////////////////////////////////////////*//
//æææææææææææææææææææææææææææææææææææææææææææææææææææææææææææææææææææ
 
//æææææææææææææææææææææææææææææææææææææææææææææææææææææææææææææææææææ
//*////////////////////////////////////////////////////////////////*//
int óäàëèòü_îáüåêòû(string PreName)                                     //óäàëÿåò îáüåêòû íà÷èíàþùèåñÿ íà PreName
  {
   for(int k=ObjectsTotal()-1; k>=0; k--) 
     {
      string Obj_Name=ObjectName(k);                           // Çàïðàøèâàåì èìÿ îáúåêòà
      string Head=StringSubstr(Obj_Name,0,StringLen(PreName)); // Èçâëåêàåì ïåðâûå ñèìîëû
 
      if (Head==PreName)// Íàéäåí îáúåêò, ..
         {
         ObjectDelete(Obj_Name);
         }                  
     }
   return(0);
  }
//*////////////////////////////////////////////////////////////////*//
//æææææææææææææææææææææææææææææææææææææææææææææææææææææææææææææææææææ