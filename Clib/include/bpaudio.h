#ifndef INCLUDE_bpaudio_h__
#define INCLUDE_bpaudio_h__

#include <SDL.h>

#include "eif_plug.h"
#include "eif_cecil.h" 
#include "eif_hector.h"



typedef struct audio_buffer {
    int head;
    int tail;
    Sint32* data;
} audio_buffer;


void audioCallback(void*  userdata, Uint8* stream, int len);

#endif

/* vi: set ts=4 sw=4 expandtab: */
