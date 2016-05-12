#ifndef INCLUDE_bpdriver_h__
#define INCLUDE_bpdriver_h__

#include"../../libfceux/include/types.h"
#include"../../libfceux/include/file.h"
#include"../../libfceux/include/git.h"
#include "eif_plug.h"
#include "eif_cecil.h" 
#include "eif_hector.h"

extern bool turbo;

extern int closeFinishedMovie;

void unset_eiffel_callback_object(void);

void set_eiffel_callback_object(EIF_OBJECT object);

#endif

/* vi: set ts=4 sw=4 expandtab: */
