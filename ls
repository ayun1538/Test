bba98b2c (ayun1538 2019-01-29 15:59:19 +0800   1) /*****************************
bba98b2c (ayun1538 2019-01-29 15:59:19 +0800   2) 
bba98b2c (ayun1538 2019-01-29 15:59:19 +0800   3) *convert.cpp
bba98b2c (ayun1538 2019-01-29 15:59:19 +0800   4) 
bba98b2c (ayun1538 2019-01-29 15:59:19 +0800   5) ******************************/
bba98b2c (ayun1538 2019-01-29 15:59:19 +0800   6) #include <stdio.h>
bba98b2c (ayun1538 2019-01-29 15:59:19 +0800   7) #include <stdlib.h>
bba98b2c (ayun1538 2019-01-29 15:59:19 +0800   8) #include <errno.h>
bba98b2c (ayun1538 2019-01-29 15:59:19 +0800   9) #include <string.h>
bba98b2c (ayun1538 2019-01-29 15:59:19 +0800  10) #include <math.h> 
bba98b2c (ayun1538 2019-01-29 15:59:19 +0800  11) 
bba98b2c (ayun1538 2019-01-29 15:59:19 +0800  12) #include "convert.h"
bba98b2c (ayun1538 2019-01-29 15:59:19 +0800  13) 
bba98b2c (ayun1538 2019-01-29 15:59:19 +0800  14) int file_convert(char *src, char *dst, char *c_audio_path, char *b_audio_path)
bba98b2c (ayun1538 2019-01-29 15:59:19 +0800  15) {
bba98b2c (ayun1538 2019-01-29 15:59:19 +0800  16)     FILE *psrc = fopen(src, "rb");
bba98b2c (ayun1538 2019-01-29 15:59:19 +0800  17)     FILE *pdst = fopen(dst, "ab");
bba98b2c (ayun1538 2019-01-29 15:59:19 +0800  18)     FILE *paudio = NULL;
bba98b2c (ayun1538 2019-01-29 15:59:19 +0800  19) 
bba98b2c (ayun1538 2019-01-29 15:59:19 +0800  20)     if(psrc == NULL || pdst == NULL)
bba98b2c (ayun1538 2019-01-29 15:59:19 +0800  21)     {
bba98b2c (ayun1538 2019-01-29 15:59:19 +0800  22)         return -1;
bba98b2c (ayun1538 2019-01-29 15:59:19 +0800  23)     }
bba98b2c (ayun1538 2019-01-29 15:59:19 +0800  24) 
bba98b2c (ayun1538 2019-01-29 15:59:19 +0800  25)     char *tmp_buf = (char *)malloc(1000000 * sizeof(char));
bba98b2c (ayun1538 2019-01-29 15:59:19 +0800  26)     memset(tmp_buf, 0, 1000000 * sizeof(char));
bba98b2c (ayun1538 2019-01-29 15:59:19 +0800  27)     size_t ele_read = 0;
bba98b2c (ayun1538 2019-01-29 15:59:19 +0800  28)   
bba98b2c (ayun1538 2019-01-29 15:59:19 +0800  29)     char n_name[256] = {0};
bba98b2c (ayun1538 2019-01-29 15:59:19 +0800  30)     int n_total = 0;
bba98b2c (ayun1538 2019-01-29 15:59:19 +0800  31)     int n_dim = 0;
bba98b2c (ayun1538 2019-01-29 15:59:19 +0800  32)     int n_type = 0;
bba98b2c (ayun1538 2019-01-29 15:59:19 +0800  33)     int n_size = 0;
bba98b2c (ayun1538 2019-01-29 15:59:19 +0800  34) 
bba98b2c (ayun1538 2019-01-29 15:59:19 +0800  35)     char audio_name[256] = {0};
bba98b2c (ayun1538 2019-01-29 15:59:19 +0800  36)     char audio_path[256] = {0};
bba98b2c (ayun1538 2019-01-29 15:59:19 +0800  37)     char book_path[256] = {0};
bba98b2c (ayun1538 2019-01-29 15:59:19 +0800  38)     int pos = 0;
bba98b2c (ayun1538 2019-01-29 15:59:19 +0800  39)     int flag = 0;    //0: cover >0: book
bba98b2c (ayun1538 2019-01-29 15:59:19 +0800  40) 
bba98b2c (ayun1538 2019-01-29 15:59:19 +0800  41)     long file_size = 0, left_size = 0;
bba98b2c (ayun1538 2019-01-29 15:59:19 +0800  42)     fseek(psrc, 0, SEEK_END);
bba98b2c (ayun1538 2019-01-29 15:59:19 +0800  43)     file_size = left_size = ftell(psrc);
bba98b2c (ayun1538 2019-01-29 15:59:19 +0800  44)     fseek(psrc, 0, SEEK_SET);
bba98b2c (ayun1538 2019-01-29 15:59:19 +0800  45) 
bba98b2c (ayun1538 2019-01-29 15:59:19 +0800  46)     strcpy(book_path, b_audio_path);
bba98b2c (ayun1538 2019-01-29 15:59:19 +0800  47) 
bba98b2c (ayun1538 2019-01-29 15:59:19 +0800  48)     while(left_size > 0)
bba98b2c (ayun1538 2019-01-29 15:59:19 +0800  49)     {
bba98b2c (ayun1538 2019-01-29 15:59:19 +0800  50)         ele_read = fread((void *)tmp_buf, (128 * 2) * sizeof(char), 1, psrc);
bba98b2c (ayun1538 2019-01-29 15:59:19 +0800  51)         //assert(ele_read == 1);
bba98b2c (ayun1538 2019-01-29 15:59:19 +0800  52)         memset(tmp_buf, 0, strlen(tmp_buf));
bba98b2c (ayun1538 2019-01-29 15:59:19 +0800  53) 
bba98b2c (ayun1538 2019-01-29 15:59:19 +0800  54)         //--------------------------------feature
bba98b2c (ayun1538 2019-01-29 15:59:19 +0800  55)         ele_read = fread((void *)n_name, (128) * sizeof(char), 1, psrc);
bba98b2c (ayun1538 2019-01-29 15:59:19 +0800  56)         printf("feature1 %d\n", ele_read);
bba98b2c (ayun1538 2019-01-29 15:59:19 +0800  57)         //assert(ele_read == 1);
bba98b2c (ayun1538 2019-01-29 15:59:19 +0800  58)         fwrite((void *)n_name, (128) * sizeof(char), 1, pdst);
bba98b2c (ayun1538 2019-01-29 15:59:19 +0800  59)         fflush(pdst);
bba98b2c (ayun1538 2019-01-29 15:59:19 +0800  60)         printf("feature2 %s\n", n_name);
bba98b2c (ayun1538 2019-01-29 15:59:19 +0800  61) 
bba98b2c (ayun1538 2019-01-29 15:59:19 +0800  62)         ele_read = fread((void *)&n_total, 4, 1, psrc);
bba98b2c (ayun1538 2019-01-29 15:59:19 +0800  63)         //assert(ele_read == 1);
bba98b2c (ayun1538 2019-01-29 15:59:19 +0800  64)         fwrite((void *)&n_total, 4, 1, pdst);
bba98b2c (ayun1538 2019-01-29 15:59:19 +0800  65)         printf("feature3 %d\n", n_total);
bba98b2c (ayun1538 2019-01-29 15:59:19 +0800  66) 
bba98b2c (ayun1538 2019-01-29 15:59:19 +0800  67)         ele_read = fread((void *)&n_dim, sizeof(int), 1, psrc);
bba98b2c (ayun1538 2019-01-29 15:59:19 +0800  68)         //assert(ele_read == 1);
bba98b2c (ayun1538 2019-01-29 15:59:19 +0800  69)         fwrite((void *)&n_dim, sizeof(int), 1, pdst);
bba98b2c (ayun1538 2019-01-29 15:59:19 +0800  70)         printf("feature4 %d\n", n_dim);
bba98b2c (ayun1538 2019-01-29 15:59:19 +0800  71) 
bba98b2c (ayun1538 2019-01-29 15:59:19 +0800  72)         ele_read = fread((void *)&n_type, sizeof(int), 1, psrc);
bba98b2c (ayun1538 2019-01-29 15:59:19 +0800  73)         //assert(ele_read == 1);
bba98b2c (ayun1538 2019-01-29 15:59:19 +0800  74)         fwrite((void *)&n_type, sizeof(int), 1, pdst);
bba98b2c (ayun1538 2019-01-29 15:59:19 +0800  75)         printf("feature5 %d\n", n_type);
bba98b2c (ayun1538 2019-01-29 15:59:19 +0800  76) 
bba98b2c (ayun1538 2019-01-29 15:59:19 +0800  77)         ele_read = fread((void *)&n_size, sizeof(int), 1, psrc);
bba98b2c (ayun1538 2019-01-29 15:59:19 +0800  78)         //assert(ele_read == 1);
bba98b2c (ayun1538 2019-01-29 15:59:19 +0800  79)         fwrite((void *)&n_size, sizeof(int), 1, pdst);
bba98b2c (ayun1538 2019-01-29 15:59:19 +0800  80)         printf("feature6 %d\n", n_size);
bba98b2c (ayun1538 2019-01-29 15:59:19 +0800  81) 
bba98b2c (ayun1538 2019-01-29 15:59:19 +0800  82)         ele_read = fread((void *)tmp_buf, n_size, 1, psrc);
bba98b2c (ayun1538 2019-01-29 15:59:19 +0800  83)         //assert(ele_read == 1);
bba98b2c (ayun1538 2019-01-29 15:59:19 +0800  84)         fwrite((void *)tmp_buf, n_size, 1, pdst);
bba98b2c (ayun1538 2019-01-29 15:59:19 +0800  85) 
bba98b2c (ayun1538 2019-01-29 15:59:19 +0800  86)         
bba98b2c (ayun1538 2019-01-29 15:59:19 +0800  87)         //--------------------------------bow
bba98b2c (ayun1538 2019-01-29 15:59:19 +0800  88)         ele_read = fread((void *)tmp_buf, (128 * 1) * sizeof(char), 1, psrc);
bba98b2c (ayun1538 2019-01-29 15:59:19 +0800  89)         //assert(ele_read == 1);
bba98b2c (ayun1538 2019-01-29 15:59:19 +0800  90)         fwrite((void *)tmp_buf, (128 * 1) * sizeof(char), 1, pdst);
bba98b2c (ayun1538 2019-01-29 15:59:19 +0800  91)         memset(tmp_buf, 0, strlen(tmp_buf));      
bba98b2c (ayun1538 2019-01-29 15:59:19 +0800  92) 
bba98b2c (ayun1538 2019-01-29 15:59:19 +0800  93)         ele_read = fread((void *)&n_size, sizeof(int), 1, psrc);
bba98b2c (ayun1538 2019-01-29 15:59:19 +0800  94)         //assert(ele_read == 1);
bba98b2c (ayun1538 2019-01-29 15:59:19 +0800  95)         fwrite((void *)&n_size, sizeof(int), 1, pdst);
bba98b2c (ayun1538 2019-01-29 15:59:19 +0800  96) 
bba98b2c (ayun1538 2019-01-29 15:59:19 +0800  97)         printf("bow %d %s\n", n_size, tmp_buf);
bba98b2c (ayun1538 2019-01-29 15:59:19 +0800  98) 
bba98b2c (ayun1538 2019-01-29 15:59:19 +0800  99)         ele_read = fread((void *)tmp_buf, (n_size * 2) * sizeof(int), 1, psrc);
bba98b2c (ayun1538 2019-01-29 15:59:19 +0800 100)         //assert(ele_read == 1);
bba98b2c (ayun1538 2019-01-29 15:59:19 +0800 101)         fwrite((void *)tmp_buf, (n_size * 2) * sizeof(int), 1, pdst);
bba98b2c (ayun1538 2019-01-29 15:59:19 +0800 102) 
bba98b2c (ayun1538 2019-01-29 15:59:19 +0800 103)         //--------------------------------audio
bba98b2c (ayun1538 2019-01-29 15:59:19 +0800 104)         ele_read = fread((void *)&n_size, sizeof(int), 1, psrc);
bba98b2c (ayun1538 2019-01-29 15:59:19 +0800 105)         ele_read = fread((void *)audio_path, (128) * sizeof(char), 1, psrc);
bba98b2c (ayun1538 2019-01-29 15:59:19 +0800 106)         //assert(ele_read == 1);
bba98b2c (ayun1538 2019-01-29 15:59:19 +0800 107)         printf("audio %d %s\n", n_size, audio_path);
bba98b2c (ayun1538 2019-01-29 15:59:19 +0800 108) 
bba98b2c (ayun1538 2019-01-29 15:59:19 +0800 109)         for (size_t a = strlen(audio_path) - 1; a >= 0; a--)
bba98b2c (ayun1538 2019-01-29 15:59:19 +0800 110)         {
bba98b2c (ayun1538 2019-01-29 15:59:19 +0800 111)             char a_tmp[1] = { 0 };
bba98b2c (ayun1538 2019-01-29 15:59:19 +0800 112)             strncpy(a_tmp, &audio_path[a], 1);
bba98b2c (ayun1538 2019-01-29 15:59:19 +0800 113) 
bba98b2c (ayun1538 2019-01-29 15:59:19 +0800 114)             if (a_tmp[0] == '/')
bba98b2c (ayun1538 2019-01-29 15:59:19 +0800 115)             {
bba98b2c (ayun1538 2019-01-29 15:59:19 +0800 116)                 pos = a;
bba98b2c (ayun1538 2019-01-29 15:59:19 +0800 117)                 break;
bba98b2c (ayun1538 2019-01-29 15:59:19 +0800 118)             }
bba98b2c (ayun1538 2019-01-29 15:59:19 +0800 119)         }
bba98b2c (ayun1538 2019-01-29 15:59:19 +0800 120) 
bba98b2c (ayun1538 2019-01-29 15:59:19 +0800 121)         strcpy(audio_name, &audio_path[pos]);
bba98b2c (ayun1538 2019-01-29 15:59:19 +0800 122) 
bba98b2c (ayun1538 2019-01-29 15:59:19 +0800 123)         if(flag == 0)
bba98b2c (ayun1538 2019-01-29 15:59:19 +0800 124)         {
bba98b2c (ayun1538 2019-01-29 15:59:19 +0800 125)             strcat(c_audio_path, audio_name);
bba98b2c (ayun1538 2019-01-29 15:59:19 +0800 126)             paudio = fopen(c_audio_path, "wb");
bba98b2c (ayun1538 2019-01-29 15:59:19 +0800 127) 
bba98b2c (ayun1538 2019-01-29 15:59:19 +0800 128)             if(paudio == NULL)
bba98b2c (ayun1538 2019-01-29 15:59:19 +0800 129)             {
bba98b2c (ayun1538 2019-01-29 15:59:19 +0800 130)                 return -1;
bba98b2c (ayun1538 2019-01-29 15:59:19 +0800 131)             }
bba98b2c (ayun1538 2019-01-29 15:59:19 +0800 132) 
bba98b2c (ayun1538 2019-01-29 15:59:19 +0800 133)             ele_read = fread((void *)tmp_buf, (n_size) * sizeof(char), 1, psrc);
bba98b2c (ayun1538 2019-01-29 15:59:19 +0800 134)             //assert(ele_read == 1);
bba98b2c (ayun1538 2019-01-29 15:59:19 +0800 135)             fwrite((void *)tmp_buf, (n_size) * sizeof(char), 1, paudio);
bba98b2c (ayun1538 2019-01-29 15:59:19 +0800 136) 
bba98b2c (ayun1538 2019-01-29 15:59:19 +0800 137)             flag++;
bba98b2c (ayun1538 2019-01-29 15:59:19 +0800 138)             fclose(paudio);
bba98b2c (ayun1538 2019-01-29 15:59:19 +0800 139)             paudio = NULL;
bba98b2c (ayun1538 2019-01-29 15:59:19 +0800 140)         }
bba98b2c (ayun1538 2019-01-29 15:59:19 +0800 141)         else
bba98b2c (ayun1538 2019-01-29 15:59:19 +0800 142)         {
bba98b2c (ayun1538 2019-01-29 15:59:19 +0800 143)             strcat(book_path, audio_name);
bba98b2c (ayun1538 2019-01-29 15:59:19 +0800 144)             paudio = fopen(book_path, "wb");
bba98b2c (ayun1538 2019-01-29 15:59:19 +0800 145)             printf("audio %d %s\n", n_size, book_path);
bba98b2c (ayun1538 2019-01-29 15:59:19 +0800 146) 
bba98b2c (ayun1538 2019-01-29 15:59:19 +0800 147)             if(paudio == NULL)
bba98b2c (ayun1538 2019-01-29 15:59:19 +0800 148)             {
bba98b2c (ayun1538 2019-01-29 15:59:19 +0800 149)                 return -1;
bba98b2c (ayun1538 2019-01-29 15:59:19 +0800 150)             }
bba98b2c (ayun1538 2019-01-29 15:59:19 +0800 151) 
bba98b2c (ayun1538 2019-01-29 15:59:19 +0800 152)             ele_read = fread((void *)tmp_buf, (n_size) * sizeof(char), 1, psrc);
bba98b2c (ayun1538 2019-01-29 15:59:19 +0800 153)             //assert(ele_read == 1);
bba98b2c (ayun1538 2019-01-29 15:59:19 +0800 154)             fwrite((void *)tmp_buf, (n_size) * sizeof(char), 1, paudio);
bba98b2c (ayun1538 2019-01-29 15:59:19 +0800 155) 
bba98b2c (ayun1538 2019-01-29 15:59:19 +0800 156)             fclose(paudio);
bba98b2c (ayun1538 2019-01-29 15:59:19 +0800 157)             paudio = NULL;
bba98b2c (ayun1538 2019-01-29 15:59:19 +0800 158)             strcpy(book_path, b_audio_path);
bba98b2c (ayun1538 2019-01-29 15:59:19 +0800 159)         }
bba98b2c (ayun1538 2019-01-29 15:59:19 +0800 160)         fflush(pdst);
bba98b2c (ayun1538 2019-01-29 15:59:19 +0800 161) 
bba98b2c (ayun1538 2019-01-29 15:59:19 +0800 162)         left_size = file_size - ftell(psrc);
bba98b2c (ayun1538 2019-01-29 15:59:19 +0800 163)         printf("end %d %d\n", left_size, file_size);
bba98b2c (ayun1538 2019-01-29 15:59:19 +0800 164)     }
bba98b2c (ayun1538 2019-01-29 15:59:19 +0800 165) 
bba98b2c (ayun1538 2019-01-29 15:59:19 +0800 166)     free(tmp_buf);
bba98b2c (ayun1538 2019-01-29 15:59:19 +0800 167)     fclose(psrc);
bba98b2c (ayun1538 2019-01-29 15:59:19 +0800 168)     fclose(pdst);
bba98b2c (ayun1538 2019-01-29 15:59:19 +0800 169) 
bba98b2c (ayun1538 2019-01-29 15:59:19 +0800 170)     return 0;
bba98b2c (ayun1538 2019-01-29 15:59:19 +0800 171) }
