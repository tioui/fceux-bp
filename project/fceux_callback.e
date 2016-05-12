note
	description: "Summary description for {FCEUX_CALLBACK}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	FCEUX_CALLBACK

inherit
	DISPOSABLE

feature {NONE} -- Implementation

	make(a_video_manager:FCEUX_VIDEO_MANAGER)
		do
			video_manager := a_video_manager
			set_eiffel_callback_object(Current);
		end

feature {NONE} -- Implementation

	video_manager:FCEUX_VIDEO_MANAGER

	dispose
			-- <Precursor>
		do
			unset_eiffel_callback_object
		end

	show_message(a_message:STRING_8)
		deferred
		end

	show_error(a_message:STRING_8)
		deferred
		end

feature {NONE} -- C externals

	set_eiffel_callback_object(a_object:FCEUX_CALLBACK)
		external
			"C++ inline use <bpdriver.h>"
		alias
			"set_eiffel_callback_object($a_object)"
		end

	unset_eiffel_callback_object
		external
			"C++ inline use <bpdriver.h>"
		alias
			"unset_eiffel_callback_object()"
		end

feature {NONE} -- C callback

	fceud_video_changed
		do
			video_manager.video_has_changed
		end

	fceud_print_error(a_message_pointer:POINTER)
		local
			l_c_message:C_STRING
		do
			create l_c_message.make_shared_from_pointer (a_message_pointer)
			show_error (l_c_message.string)
		end

	fceud_message(a_message_pointer:POINTER)
		local
			l_c_message:C_STRING
		do
			create l_c_message.make_shared_from_pointer (a_message_pointer)
			show_message (l_c_message.string)
		end

	fceud_set_palette(a_index, a_red, a_green, a_blue:NATURAL_8)
		do
			video_manager.set_palette (a_index, a_red, a_green, a_blue)
		end

	fceud_get_palette(a_index:NATURAL_8; a_red, a_green, a_blue:POINTER)
		local
			l_color:TUPLE[red, green, blue:NATURAL_8]
			l_managed_pointer:MANAGED_POINTER
		do
			l_color := video_manager.get_palette (a_index)
			create l_managed_pointer.make_from_pointer (a_red, 1)
			l_managed_pointer.put_natural_8 (l_color.red, 0)
			create l_managed_pointer.make_from_pointer (a_green, 1)
			l_managed_pointer.put_natural_8 (l_color.green, 0)
			create l_managed_pointer.make_from_pointer (a_blue, 1)
			l_managed_pointer.put_natural_8 (l_color.blue, 0)
		end


--int FCEUD_NetworkConnect(void)
--{
--	return 0;
--}

--int FCEUD_GetDataFromClients(uint8 *data)
--{
--	return 0;
--}

--int FCEUD_SendDataToClients(uint8 *data)
--{
--	return 0;
--}

--int FCEUD_SendDataToServer(uint8 v, uint8 cmd)
--{
--	return 0;
--}

--int FCEUD_GetDataFromServer(uint8 *data)
--{
--	return 0;
--}

--void FCEUD_NetworkClose(void)
--{
--	return;
--}

--bool FCEUD_PauseAfterPlayback()
--{
--	return false;
--}

--void FCEUD_SetInput(bool fourscore, bool microphone, ESI port0, ESI port1, ESIFC fcexp)
--{
--	return;
--}

--void FCEUD_VideoChanged()
--{
--	return;
--}

--bool FCEUI_AviIsRecording(void)
--{
--	return false;
--}

--FCEUFILE* FCEUD_OpenArchiveIndex(
--		ArchiveScanRecord& asr, std::string &fname, int innerIndex)
--{
--	return 0;
--}

--uint64 FCEUD_GetTime()
--{
--	return 0;
--}

--uint64 FCEUD_GetTimeFreq(void)
--{
--		return 1000;
--}

--FCEUFILE* FCEUD_OpenArchive(
--		ArchiveScanRecord& asr, std::string& fname,
--		std::string* innerFilename)
--{
--	return NULL;
--}


--bool FCEUI_AviEnableHUDrecording()
--{
--	return false;
--}

--bool FCEUD_ShouldDrawInputAids()
--{
--	return false;
--}

--bool FCEUI_AviDisableMovieMessages()
--{
--	return false;
--}

--void FCEUI_AviVideoUpdate(const unsigned char* buffer)
--{
--	return;
--}

--void FCEUD_SetEmulationSpeed(int cmd)
--{
--	return;
--}

--void FCEUD_TurboOff(void)
--{
--	return;
--}

--void FCEUD_TurboOn(void)
--{
--	return;
--}

--void GetMouseData (uint32 (&d)[3])
--{
--	return;
--}

--int FCEUD_SendData(void *data, uint32 len)
--{
--	return 0;
--}

--int FCEUD_RecvData(void *data, uint32 len)
--{
--	return 0;
--}

--void FCEUD_NetplayText(uint8 *text)
--{
--	return;
--}

--void FCEUI_UseInputPreset(int preset)
--{
--	return;
--}

--void FCEUD_SoundVolumeAdjust(int vol)
--{
--	return;
--}

--void FCEUD_HideMenuToggle(void){
--	return;
--}

--void FCEUD_TurboToggle(void){
--	return;
--}

--void FCEUD_SaveStateAs(void)
--{
--	return;
--}

--void FCEUD_LoadStateFrom(void)
--{
--	return;
--}

--void FCEUD_MovieRecordTo(void)
--{
--	return;
--}

--void FCEUD_MovieReplayFrom(void)
--{
--	return;
--}

--void FCEUD_ToggleStatusIcon(void)
--{
--	return;
--}

--void FCEUD_SoundToggle(void)
--{
--	return;
--}

--void FCEUD_AviRecordTo(void)
--{
--	return;
--}

--void FCEUD_AviStop(void)
--{
--	return;
--}

--int FCEUD_ShowStatusIcon(void)
--{
--	return 0;
--}

--unsigned int *GetKeyboard(void)
--{
--	return NULL;
--}


end
