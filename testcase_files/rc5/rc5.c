#include <stdio.h>

int main()
{ 
   unsigned int KeyWords = 4;
    
   unsigned int NumRounds = 15;
    
   unsigned int Table[ 32 ] = { 0xb7e15163, 0x5618cb1c, 0xf45044d5,
                                         0x9287be8e, 0x30bf3847, 0xcef6b200,
                                         0x6d2e2bb9, 0x0b65a572, 0xa99d1f2b,
                                         0x47d498e4, 0xe60c129d, 0x84438c56,
                                         0x227b060f, 0xc0b27fc8, 0x5ee9f981,
                                         0xfd21733a, 0x9b58ecf3, 0x399066ac,
                                         0xd7c7e065, 0x75ff5a1e, 0x1436d3d7,
                                         0xb26e4d90, 0x50a5c749, 0xeedd4102,
                                         0x8d14babb, 0x2b4c3474, 0xc983ae2d,
                                         0x67bb27e6, 0x05f2a19f, 0xa42a1b58,
                                         0x42619511, 0xe0990eca };

  
    
  unsigned int i;
  unsigned int A;
  unsigned int B;
  unsigned int j;
  unsigned int k;
  unsigned int temp;
  unsigned int L[KeyWords];

  A = 0;
  B = 0;
  i = 0;
  j = 0;


  for (k=0; k < 3*32; k++) {
      
    unsigned int ShiftAmt = (3 & (unsigned int)0x1f);
    unsigned int ShiftBack = 0x20 - ShiftAmt;  
    Table[i] = ((Table[i]+(A+B)) << ShiftAmt) | ((Table[i]+(A+B)) >> ShiftBack);
    
    A = Table[i];

    ShiftAmt = ((A+B) & (unsigned int)0x1f);
    ShiftBack = 0x20 - ShiftAmt;  
    L[j] = ((L[j]+(A+B)) << ShiftAmt) | ((L[j]+(A+B)) >> ShiftBack);
        
    B = L[j]; 
    i= (i+1) & (32-1); 
    j= (j+1) & (KeyWords-1);
  }

  unsigned int PlainText1[2] = {1,1};
  unsigned int PlainText2[2];
  unsigned int CryptoText[2] = {0,0};  
    
  A = PlainText1[0] + Table[0];
  B = PlainText1[1] + Table[1];

  for (i = 1; i <= NumRounds; i++) {
    temp = i << 1; 
    unsigned int ShiftAmt = (B & (unsigned int)0x1f);
    unsigned int ShiftBack = 0x20 - ShiftAmt;   
    A = ((((A^B) << ShiftAmt) |(A^B) >> ShiftBack)) + Table[temp]; 
    ShiftAmt = (A & (unsigned int)0x1f);
    ShiftBack = 0x20 - ShiftAmt; 
    B = ((((A^B) << ShiftAmt) |(A^B) >> ShiftBack)) + Table[temp+1]; 
  }
      
  CryptoText[0] = A; 
  CryptoText[1] = B;

  for (i=NumRounds; i > 0; i--) { 
    temp = i << 1;
    unsigned int ShiftAmt = (A & (unsigned int)0x1f);
    unsigned int ShiftBack = 0x20 - ShiftAmt; 
    B = (((B - Table[temp+1]) >> ShiftAmt) | ((B - Table[temp+1]) << ShiftBack))^A; 
    ShiftAmt = (B & (unsigned int)0x1f);
    ShiftBack = 0x20 - ShiftAmt; 
    A = (((A - Table[temp]) >> ShiftAmt) | ((A - Table[temp]) << ShiftBack))^B;
  }
      
  PlainText2[1] = B-Table[1]; 
  PlainText2[0] = A-Table[0]; 
     

    return 0;
}
