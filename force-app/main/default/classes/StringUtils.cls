public class StringUtils {

   private static String[] tensNames = new String[]{
    '',
    ' TEN',
    ' TWENTY',
    ' THIRTY',
    ' FOURTY',
    ' FIFTY',
    ' SIXTY',
    ' SEVENTY',
    ' EIGHTY',
    ' NINETY'
  };

  private static String[] numNames = new String[]{
    '',
    ' one',
    ' two',
    ' three',
    ' four',
    ' five',
    ' six',
    ' seven',
    ' eight',
    ' nine',
    ' ten',
    ' eleven',
    ' twelve',
    ' thirteen',
    ' fourteen',
    ' fifteen',
    ' sixteen',
    ' seventeen',
    ' eighteen',
    ' nineteen'
  };

  
  private static String convertLessThanOneThousand(Integer num) {
    String soFar;

    if (Math.Mod(num,100) < 20){
      soFar = numNames[Math.Mod(num,100)];
      num /= 100;
    }
    else {
      soFar = numNames[Math.Mod(num,10)];
      num /= 10;

      soFar = tensNames[Math.Mod(num,10)] + soFar;
      num /= 10;
    }
    if (num == 0) return soFar;
    return numNames[num] + ' hundred' + soFar;
  }


  public static String convert(Integer num) {
    // 0 to 999 999 999 999
    if (num == 0) { return 'zero'; }

    String snum = String.valueOf(num);
      String padd='';
      for(integer i=0; i<(12-snum.length());i++){
          padd +='0';
      }
    snum = padd+snum;

    // pad with '0'
    //String mask = '000000000000';
    //DecimalFormat df = new DecimalFormat(mask);
    //snum = df.format(num);

    // XXXnnnnnnnnn
    Integer billions = Integer.valueOf(snum.substring(0,3));
    // nnnXXXnnnnnn
    Integer millions  = Integer.valueOf(snum.substring(3,6));
    // nnnnnnXXXnnn
    Integer hundredThousands = Integer.valueOf(snum.substring(6,9));
    // nnnnnnnnnXXX
    Integer thousands = Integer.valueOf(snum.substring(9,12));

    String tradBillions =null;
      if(billions==0){
         tradBillions = '';   
      }else if(billions==1){
        tradBillions = convertLessThanOneThousand(billions)
      + ' billion ';
      }else{
       tradBillions = convertLessThanOneThousand(billions)
      + ' billion ';
    }
    String result =  tradBillions;

    String tradMillions;
    if(millions ==0)  {
          tradMillions = '';
    }else if(millions ==1){
          tradMillions = convertLessThanOneThousand(millions)
         + ' million ';
    }else{
         tradMillions = convertLessThanOneThousand(millions)
         + ' million ';  
    }
      
      
    result =  result + tradMillions;

    String tradHundredThousands;
    
    /*if(millions ==0)  {
          tradHundredThousands = '';
    }else if(millions ==1){
          tradHundredThousands = ' one thousand ';
    }else{
          tradHundredThousands = convertLessThanOneThousand(hundredThousands)
         + ' thousand ';  
    } */
      
      
      if(num > 999 && num < 999999){
          
          tradHundredThousands = numNames[Math.Mod(num/1000,10)] + ' thousand ';
      }   
      
    result =  result + tradHundredThousands;

    String tradThousand;
    tradThousand = convertLessThanOneThousand(thousands);
    result =  result + tradThousand;

    // remove extra spaces!
    return result.replaceAll('^\\s+', '').replaceAll('\\b\\s{2,}\\b', ' ').toUpperCase();
  }
    
}