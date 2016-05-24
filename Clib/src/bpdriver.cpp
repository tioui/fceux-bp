#include"../include/bpdriver.h"

#include <stdio.h>

bool turbo = false;

int closeFinishedMovie = 0;

EIF_OBJECT eiffel_driver_callback_object;

/**
 * Set the correct value for the callback system
 *
 * @param object The Eiffel object that will receive the callback
 */
void unset_eiffel_driver_callback_object()
{
    eif_wean(eiffel_driver_callback_object);
    eiffel_driver_callback_object = NULL;
}

/**
 * Set the correct value for the callback system
 *
 * @param object The Eiffel object that will receive the callback
 */
void set_eiffel_driver_callback_object(EIF_OBJECT object)
{
    eiffel_driver_callback_object = eif_adopt(object);
}

void FCEUD_SetPalette(uint8 index,uint8 r,uint8 g,uint8 b)
{
    EIF_PROCEDURE ep;
    EIF_TYPE_ID tid;
    if (eiffel_driver_callback_object){
        tid = eif_type(eiffel_driver_callback_object);
        if (tid != EIF_NO_TYPE){
            ep = eif_procedure ("fceud_set_palette", tid);
            if(ep != NULL){
                (ep) (eif_access(eiffel_driver_callback_object), index, r, g, b);
            }else{
                eif_panic(
                        "Feature `fceud_set_palette' of class"
                        "{FCEUX_CALLBACK} is not visible"
                        );
            }
        }else{
            eif_panic("Class {FCEUX_CALLBACK} is not visible");
        }
    }else{
        eif_panic("The {FCEUX_CALLBACK} object is not initialized.");
    }
    return;
}

void FCEUD_GetPalette(uint8 index, uint8 *r, uint8 *g, uint8 *b)
{
    EIF_PROCEDURE ep;
    EIF_TYPE_ID tid;
    if (eiffel_driver_callback_object){
        tid = eif_type(eiffel_driver_callback_object);
        if (tid != EIF_NO_TYPE){
            ep = eif_procedure ("fceud_get_palette", tid);
            if(ep != NULL){
                (ep) (eif_access(eiffel_driver_callback_object), index, r, g, b);
            }else{
                eif_panic(
                        "Feature `fceud_get_palette' of class"
                        "{FCEUX_CALLBACK} is not visible"
                        );
            }
        }else{
            eif_panic("Class {FCEUX_CALLBACK} is not visible");
        }
    }else{
        eif_panic("The {FCEUX_CALLBACK} object is not initialized.");
    }
    return;
}

void FCEUD_PrintError(const char *s)
{
    EIF_PROCEDURE ep;
    EIF_TYPE_ID tid;
    if (eiffel_driver_callback_object){
        tid = eif_type(eiffel_driver_callback_object);
        if (tid != EIF_NO_TYPE){
            ep = eif_procedure ("fceud_print_error", tid);
            if(ep != NULL){
                (ep) (eif_access(eiffel_driver_callback_object), s);
            }else{
                eif_panic(
                        "Feature `fceud_print_error' of class"
                        "{FCEUX_CALLBACK} is not visible"
                        );
            }
        }else{
            eif_panic("Class {FCEUX_CALLBACK} is not visible");
        }
    }else{
        eif_panic("The {FCEUX_CALLBACK} object is not initialized.");
    }
    return;
}

void FCEUD_Message(const char *s)
{
    EIF_PROCEDURE ep;
    EIF_TYPE_ID tid;
    if (eiffel_driver_callback_object){
        tid = eif_type(eiffel_driver_callback_object);
        if (tid != EIF_NO_TYPE){
            ep = eif_procedure ("fceud_message", tid);
            if(ep != NULL){
                (ep) (eif_access(eiffel_driver_callback_object), s);
            }else{
                eif_panic(
                        "Feature `fceud_message' of class"
                        "{FCEUX_CALLBACK} is not visible"
                        );
            }
        }else{
            eif_panic("Class {FCEUX_CALLBACK} is not visible");
        }
    }else{
        eif_panic("The {FCEUX_CALLBACK} object is not initialized.");
    }
    return;
}

int FCEUD_NetworkConnect(void)
{
    printf("Not done: FCEUD_NetworkConnect\n");
    return 0;
}

int FCEUD_GetDataFromClients(uint8 *data)
{
    printf("Not done: FCEUD_GetDataFromClients\n");
    return 0;
}

int FCEUD_SendDataToClients(uint8 *data)
{
    printf("Not done: FCEUD_SendDataToClients\n");
    return 0;
}

int FCEUD_SendDataToServer(uint8 v, uint8 cmd)
{
    printf("Not done: FCEUD_SendDataToServer\n");
    return 0;
}

int FCEUD_GetDataFromServer(uint8 *data)
{
    printf("Not done: FCEUD_GetDataFromServer\n");
    return 0;
}

void FCEUD_NetworkClose(void)
{
    printf("Not done: FCEUD_NetworkClose\n");
    return;
}

/**
 * Opens a file to be read a byte at a time.
 */
EMUFILE_FILE* FCEUD_UTF8_fstream(const char *fn, const char *m)
{
    std::ios_base::openmode mode = std::ios_base::binary;
    if(!strcmp(m,"r") || !strcmp(m,"rb"))
        mode |= std::ios_base::in;
    else if(!strcmp(m,"w") || !strcmp(m,"wb"))
        mode |= std::ios_base::out | std::ios_base::trunc;
    else if(!strcmp(m,"a") || !strcmp(m,"ab"))
        mode |= std::ios_base::out | std::ios_base::app;
    else if(!strcmp(m,"r+") || !strcmp(m,"r+b"))
        mode |= std::ios_base::in | std::ios_base::out;
    else if(!strcmp(m,"w+") || !strcmp(m,"w+b"))
        mode |= std::ios_base::in | std::ios_base::out | std::ios_base::trunc;
    else if(!strcmp(m,"a+") || !strcmp(m,"a+b"))
        mode |= std::ios_base::in | std::ios_base::out | std::ios_base::app;
    return new EMUFILE_FILE(fn, m);
}

bool FCEUD_PauseAfterPlayback()
{
    printf("Not done: FCEUD_PauseAfterPlayback\n");
    return false;
}

void FCEUD_SetInput(bool fourscore, bool microphone, ESI port0, ESI port1, ESIFC fcexp)
{
    printf("Not done: FCEUD_SetInput\n");
    return;
}


FILE *FCEUD_UTF8fopen(const char *fn, const char *mode)
{
    return(fopen(fn,mode));
}

void FCEUD_VideoChanged()
{
    EIF_PROCEDURE ep;
    EIF_TYPE_ID tid;
    if (eiffel_driver_callback_object){
        tid = eif_type(eiffel_driver_callback_object);
        if (tid != EIF_NO_TYPE){
            ep = eif_procedure ("fceud_video_changed", tid);
            if(ep != NULL){
                (ep) (eif_access(eiffel_driver_callback_object));
            }else{
                eif_panic(
                        "Feature `fceud_video_changed' of class"
                        "{FCEUX_CALLBACK} is not visible"
                        );
            }
        }else{
            eif_panic("Class {FCEUX_CALLBACK} is not visible");
        }
    }else{
        eif_panic("The {FCEUX_CALLBACK} object is not initialized.");
    }
    return;

    return;
}

bool FCEUI_AviIsRecording(void)
{
    printf("Not done: FCEUI_AviIsRecording\n");
    return false;
}

ArchiveScanRecord FCEUD_ScanArchive(std::string fname)
{
    return ArchiveScanRecord();
}

FCEUFILE* FCEUD_OpenArchiveIndex(
        ArchiveScanRecord& asr, std::string &fname, int innerIndex)
{ 
    printf("Not done: FCEUD_OpenArchiveIndex\n");
    return 0;
}

uint64 FCEUD_GetTime()
{
    printf("Not done: FCEUD_GetTime\n");
    return 0;
}

uint64 FCEUD_GetTimeFreq(void)
{
    printf("Not done: FCEUD_GetTimeFreq\n");
        return 1000;
}

FCEUFILE* FCEUD_OpenArchive(
        ArchiveScanRecord& asr, std::string& fname, 
        std::string* innerFilename)
{
    printf("Not done: FCEUD_OpenArchive\n");
    return NULL;
}


bool FCEUI_AviEnableHUDrecording()
{
//    printf("Not done: FCEUI_AviEnableHUDrecording\n");
    return false;
}

bool FCEUD_ShouldDrawInputAids()
{
//    printf("Not done: FCEUD_ShouldDrawInputAids\n");
    return false;
}

bool FCEUI_AviDisableMovieMessages()
{
    printf("Not done: FCEUI_AviDisableMovieMessages\n");
    return false;
}

void FCEUI_AviVideoUpdate(const unsigned char* buffer)
{
//    printf("Not done: FCEUI_AviVideoUpdate\n");
    return;
}

void FCEUD_SetEmulationSpeed(int cmd)
{
    printf("Not done: FCEUD_SetEmulationSpeed\n");
    return;
}

void FCEUD_TurboOff(void)
{
    printf("Not done: FCEUD_TurboOff\n");
    return;
}

void FCEUD_TurboOn(void)
{
    printf("Not done: FCEUD_TurboOn\n");
    return;
}

void GetMouseData (uint32 (&d)[3])
{
    printf("Not done: GetMouseData\n");
    return;
}

int FCEUD_SendData(void *data, uint32 len)
{
    printf("Not done: FCEUD_SendData\n");
    return 0;
}

int FCEUD_RecvData(void *data, uint32 len)
{
    printf("Not done: FCEUD_RecvData\n");
    return 0;
}

void FCEUD_NetplayText(uint8 *text)
{
    printf("Not done: FCEUD_NetplayText\n");
    return;
}

void FCEUI_UseInputPreset(int preset)
{
    printf("Not done: FCEUI_UseInputPreset\n");
    return;
}

void FCEUD_SoundVolumeAdjust(int vol)
{
    printf("Not done: FCEUD_SoundVolumeAdjust\n");
    return;
}

void FCEUD_HideMenuToggle(void){
    return;
    printf("Not done: FCEUD_HideMenuToggle\n");
}

void FCEUD_TurboToggle(void){
    return;
    printf("Not done: FCEUD_TurboToggle\n");
}

void FCEUD_SaveStateAs(void)
{
    printf("Not done: FCEUD_SaveStateAs\n");
    return;
}

void FCEUD_LoadStateFrom(void)
{
    printf("Not done: FCEUD_LoadStateFrom\n");
    return;
}

void FCEUD_MovieRecordTo(void)
{
    printf("Not done: FCEUD_MovieRecordTo\n");
    return;
}

void FCEUD_MovieReplayFrom(void)
{
    printf("Not done: FCEUD_MovieReplayFrom\n");
    return;
}

void FCEUD_ToggleStatusIcon(void)
{
    printf("Not done: FCEUD_ToggleStatusIcon\n");
    return;
}

void FCEUD_SoundToggle(void)
{
    printf("Not done: FCEUD_SoundToggle\n");
    return;
}

void FCEUD_AviRecordTo(void)
{
    printf("Not done: FCEUD_AviRecordTo\n");
    return;
}

void FCEUD_AviStop(void)
{
    printf("Not done: FCEUD_AviStop\n");
    return;
}

int FCEUD_ShowStatusIcon(void)
{
//    printf("Not done: FCEUD_ShowStatusIcon\n");
    return 0;
}

unsigned int *GetKeyboard(void)
{
    printf("Not done: GetKeyboard\n");
    return NULL;
}


/* vi: set ts=4 sw=4 expandtab: */
