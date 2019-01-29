/*****************************

*convert.cpp

******************************/
#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <string.h>
#include <math.h> 

#include "convert.h"

int file_convert(char *src, char *dst, char *c_audio_path, char *b_audio_path)
{
    FILE *psrc = fopen(src, "rb");
    FILE *pdst = fopen(dst, "ab");
    FILE *paudio = NULL;

    if(psrc == NULL || pdst == NULL)
    {
        return -1;
    }

    char *tmp_buf = (char *)malloc(1000000 * sizeof(char));
    memset(tmp_buf, 0, 1000000 * sizeof(char));
    size_t ele_read = 0;
  
    char n_name[256] = {0};
    int n_total = 0;
    int n_dim = 0;
    int n_type = 0;
    int n_size = 0;

    char audio_name[256] = {0};
    char audio_path[256] = {0};
    char book_path[256] = {0};
    int pos = 0;
    int flag = 0;    //0: cover >0: book

    long file_size = 0, left_size = 0;
    fseek(psrc, 0, SEEK_END);
    file_size = left_size = ftell(psrc);
    fseek(psrc, 0, SEEK_SET);

    strcpy(book_path, b_audio_path);

    while(left_size > 0)
    {
        ele_read = fread((void *)tmp_buf, (128 * 2) * sizeof(char), 1, psrc);
        //assert(ele_read == 1);
        memset(tmp_buf, 0, strlen(tmp_buf));

        //--------------------------------feature
        ele_read = fread((void *)n_name, (128) * sizeof(char), 1, psrc);
        printf("feature1 %d\n", ele_read);
        //assert(ele_read == 1);
        fwrite((void *)n_name, (128) * sizeof(char), 1, pdst);
        fflush(pdst);
        printf("feature2 %s\n", n_name);

        ele_read = fread((void *)&n_total, 4, 1, psrc);
        //assert(ele_read == 1);
        fwrite((void *)&n_total, 4, 1, pdst);
        printf("feature3 %d\n", n_total);

        ele_read = fread((void *)&n_dim, sizeof(int), 1, psrc);
        //assert(ele_read == 1);
        fwrite((void *)&n_dim, sizeof(int), 1, pdst);
        printf("feature4 %d\n", n_dim);

        ele_read = fread((void *)&n_type, sizeof(int), 1, psrc);
        //assert(ele_read == 1);
        fwrite((void *)&n_type, sizeof(int), 1, pdst);
        printf("feature5 %d\n", n_type);

        ele_read = fread((void *)&n_size, sizeof(int), 1, psrc);
        //assert(ele_read == 1);
        fwrite((void *)&n_size, sizeof(int), 1, pdst);
        printf("feature6 %d\n", n_size);

        ele_read = fread((void *)tmp_buf, n_size, 1, psrc);
        //assert(ele_read == 1);
        fwrite((void *)tmp_buf, n_size, 1, pdst);

        
        //--------------------------------bow
        ele_read = fread((void *)tmp_buf, (128 * 1) * sizeof(char), 1, psrc);
        //assert(ele_read == 1);
        fwrite((void *)tmp_buf, (128 * 1) * sizeof(char), 1, pdst);
        memset(tmp_buf, 0, strlen(tmp_buf));      

        ele_read = fread((void *)&n_size, sizeof(int), 1, psrc);
        //assert(ele_read == 1);
        fwrite((void *)&n_size, sizeof(int), 1, pdst);

        printf("bow %d %s\n", n_size, tmp_buf);

        ele_read = fread((void *)tmp_buf, (n_size * 2) * sizeof(int), 1, psrc);
        //assert(ele_read == 1);
        fwrite((void *)tmp_buf, (n_size * 2) * sizeof(int), 1, pdst);

        //--------------------------------audio
        ele_read = fread((void *)&n_size, sizeof(int), 1, psrc);
        ele_read = fread((void *)audio_path, (128) * sizeof(char), 1, psrc);
        //assert(ele_read == 1);
        printf("audio %d %s\n", n_size, audio_path);

        for (size_t a = strlen(audio_path) - 1; a >= 0; a--)
        {
            char a_tmp[1] = { 0 };
            strncpy(a_tmp, &audio_path[a], 1);

            if (a_tmp[0] == '/')
            {
                pos = a;
                break;
            }
        }

        strcpy(audio_name, &audio_path[pos]);

        if(flag == 0)
        {
            strcat(c_audio_path, audio_name);
            paudio = fopen(c_audio_path, "wb");

            if(paudio == NULL)
            {
                return -1;
            }

            ele_read = fread((void *)tmp_buf, (n_size) * sizeof(char), 1, psrc);
            //assert(ele_read == 1);
            fwrite((void *)tmp_buf, (n_size) * sizeof(char), 1, paudio);

            flag++;
            fclose(paudio);
            paudio = NULL;
        }
        else
        {
            strcat(book_path, audio_name);
            paudio = fopen(book_path, "wb");
            printf("audio %d %s\n", n_size, book_path);

            if(paudio == NULL)
            {
                return -1;
            }

            ele_read = fread((void *)tmp_buf, (n_size) * sizeof(char), 1, psrc);
            //assert(ele_read == 1);
            fwrite((void *)tmp_buf, (n_size) * sizeof(char), 1, paudio);

            fclose(paudio);
            paudio = NULL;
            strcpy(book_path, b_audio_path);
        }
        fflush(pdst);

        left_size = file_size - ftell(psrc);
        printf("end %d %d\n", left_size, file_size);
    }

    free(tmp_buf);
    fclose(psrc);
    fclose(pdst);

    return 0;
}