#include"../include/bpaudio.h"

#include <stdio.h>
#include <stdlib.h>

void audioCallback(void*  userdata, Uint8* stream, int len)
{
    audio_buffer* buffer = (audio_buffer*) userdata;
    printf("Audio callback - len: %d; Data buffer: %x; head: %d, tail: %d\n", len, (unsigned int)buffer->data, buffer->head, buffer->tail);
    int i = 0;
    Sint16 valeur;
    Sint16 *stream16 = (Sint16 *)stream;
    int len16 = len >> 1;
    while(i < len16){
        if (buffer->data && (buffer->head > buffer->tail))
        {
            valeur = buffer->data[buffer->tail];
//            printf("Valeur: %x, ", *((Sint16*)&(buffer->data[buffer->tail]) + 1));
//            *((Sint16*)&(stream[i])) =
//                *((Sint16*)&(buffer->data[buffer->tail]));
            buffer->tail = buffer->tail + 1;
        }
        else
        {
            printf("0, ");
            valeur = 0;
        }
        stream16[i] = valeur;
        i = i + 1;
    }
}

/* vi: set ts=4 sw=4 expandtab: */
