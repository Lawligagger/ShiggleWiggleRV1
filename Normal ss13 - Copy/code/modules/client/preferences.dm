//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:33

var/list/preferences_datums = list()

var/global/list/special_roles = list( //keep synced with the defines BE_* in setup.dm --rastaf
//some autodetection here.
	"traitor" = IS_MODE_COMPILED("traitor"),             // 0
	"operative" = IS_MODE_COMPILED("nuclear"),           // 1
	"changeling" = IS_MODE_COMPILED("changeling"),       // 2
	"wizard" = IS_MODE_COMPILED("wizard"),               // 3
	"malf AI" = IS_MODE_COMPILED("malfunction"),         // 4
	"revolutionary" = IS_MODE_COMPILED("revolution"),    // 5
	"alien candidate" = 1, //always show                 // 6
	"pAI candidate" = 1, // -- TLE                       // 7
	"cultist" = IS_MODE_COMPILED("cult"),                // 8
	"infested monkey" = IS_MODE_COMPILED("monkey"),      // 9
)


var/const/MAX_SAVE_SLOTS = 3


datum/preferences
	//doohickeys for savefiles
	var/path
	var/default_slot = 1				//Holder so it doesn't default to slot 1, rather the last one used
	var/savefile_version = 0

	//non-preference stuff
	var/warns = 0
	var/muted = 0
	var/last_ip
	var/last_id

	//game-preferences
	var/lastchangelog = ""				//Saved changlog filesize to detect if there was a change
	var/ooccolor = "#b82e00"
	var/be_special = 0					//Special role selection
	var/UI_style = "Midnight"
	var/toggles = TOGGLES_DEFAULT

	//character preferences
	var/real_name						//our character's name
	var/be_random_name = 0				//whether we are a random name every round
	var/gender = MALE					//gender of character (well duh)
	var/age = 30						//age of character
	var/b_type = "A+"					//blood type (not-chooseable)
	var/underwear = 1					//underwear type
	var/backbag = 2						//backpack type
	var/h_style = "Bald"				//Hair type
	var/r_hair = 0						//Hair color
	var/g_hair = 0						//Hair color
	var/b_hair = 0						//Hair color
	var/f_style = "Shaved"				//Face hair type
	var/r_facial = 0					//Face hair color
	var/g_facial = 0					//Face hair color
	var/b_facial = 0					//Face hair color
	var/s_tone = 0						//Skin color
	var/r_eyes = 0						//Eye color
	var/g_eyes = 0						//Eye color
	var/b_eyes = 0						//Eye color

		//Mob preview
	var/icon/preview_icon_front = null
	var/icon/preview_icon_side = null

		//Jobs, uses bitflags
	var/job_civilian_high = 0
	var/job_civilian_med = 0
	var/job_civilian_low = 0

	var/job_medsci_high = 0
	var/job_medsci_med = 0
	var/job_medsci_low = 0

	var/job_engsec_high = 0
	var/job_engsec_med = 0
	var/job_engsec_low = 0

		// Want randomjob if preferences already filled - Donkie
	var/userandomjob = 1 //defaults to 1 for fewer assistants

	// 0 = character settings, 1 = game preferences
	var/current_tab = 0

		// OOC Metadata:
	var/metadata = ""

/datum/preferences/New(client/C)
	b_type = pick(4;"O-", 36;"O+", 3;"A-", 28;"A+", 1;"B-", 20;"B+", 1;"AB-", 5;"AB+")
	if(istype(C))
		if(!IsGuestKey(C.key))
			load_path(C.ckey)
			if(load_preferences())
				if(load_character())
					return
	gender = pick(MALE, FEMALE)
	real_name = random_name(gender)

/datum/preferences
	proc/ShowChoices(mob/user)
		if(!user || !user.client)	return
		update_preview_icon()
		user << browse_rsc(preview_icon_front, "previewicon.png")
		user << browse_rsc(preview_icon_side, "previewicon2.png")
		var/dat = "<center>"

		dat += "<a href='?_src_=prefs;preference=tab;tab=0' [current_tab == 0 ? "class='linkOn'" : ""]>Character Settings</a> "
		dat += "<a href='?_src_=prefs;preference=tab;tab=1' [current_tab == 1 ? "class='linkOn'" : ""]>Game Preferences</a>"

		if(!path)
			dat += "<div class='notice'>Please create an account to save your preferences</div>"

		dat += "</center>"

		dat += "<HR>"

		switch(current_tab)
			if (0) // Character Settings#
				if(path)
					var/savefile/S = new /savefile(path)
					if(S)
						dat += "<center>"
						var/name
						for(var/i=1, i<=MAX_SAVE_SLOTS, i++)
							S.cd = "/character[i]"
							S["real_name"] >> name
							if(!name)	name = "Character[i]"
							//if(i!=1) dat += " | "
							dat += "<a href='?_src_=prefs;preference=changeslot;num=[i];' [i == default_slot ? "class='linkOn'" : ""]>[name]</a> "
						dat += "</center>"

				dat += "<center><h2>Occupation Choices</h2>"
				dat += "<a href='?_src_=prefs;preference=job;task=menu'>Set Occupation Preferences</a><br></center>"
				dat += "<h2>Indentity</h2>"
				dat += "<table width='100%'><tr><td width='75%' valign='top'>"
				dat += "<a href='?_src_=prefs;preference=name;task=random'>Random Name</A> "
				dat += "<a href='?_src_=prefs;preference=name'>Always Random Name: [be_random_name ? "Yes" : "No"]</a><BR>"

				dat += "<b>Name:</b> "
				dat += "<a href='?_src_=prefs;preference=name;task=input'>[real_name]</a><BR>"

				dat += "<b>Gender:</b> <a href='?_src_=prefs;preference=gender'>[gender == MALE ? "Male" : "Female"]</a><BR>"
				dat += "<b>Age:</b> <a href='?_src_=prefs;preference=age;task=input'>[age]</a>"


				dat += "</td><td valign='center'>"

				dat += "<div class='statusDisplay'><center><img src=previewicon.png height=64 width=64><img src=previewicon2.png height=64 width=64></center></div>"

				dat += "</td></tr></table>"

				dat += "<h2>Body</h2>"
				dat += "<a href='?_src_=prefs;preference=all;task=random'>Random Body</A><br>"

				dat += "<table width='100%'><tr><td width='24%' valign='top'>"

				dat += "<b>Blood Type:</b> [b_type]<BR>"
				dat += "<b>Skin Tone:</b><BR><a href='?_src_=prefs;preference=s_tone;task=input'>[-s_tone + 35]/220</a><BR>"

				if(gender == MALE)
					dat += "<b>Underwear:</b><BR><a href ='?_src_=prefs;preference=underwear;task=input'>[underwear_m[underwear]]</a><BR>"
				else
					dat += "<b>Underwear:</b><BR><a href ='?_src_=prefs;preference=underwear;task=input'>[underwear_f[underwear]]</a><BR>"

				dat += "<b>Backpack:</b><BR><a href ='?_src_=prefs;preference=bag;task=input'>[backbaglist[backbag]]</a><BR>"


				dat += "</td><td valign='top' width='28%'>"

				dat += "<h3>Hair Style</h3>"

				dat += "<a href='?_src_=prefs;preference=h_style;task=input'>[h_style]</a><BR>"
				dat += "<span style='border: 1px solid #161616; background-color: rgb([r_hair],[g_hair],[b_hair]);'>&nbsp;&nbsp;&nbsp;</span> <a href='?_src_=prefs;preference=hair;task=input'>Change</a><BR>"


				dat += "</td><td valign='top' width='28%'>"

				dat += "<h3>Facial Hair Style</h3>"

				dat += "<a href='?_src_=prefs;preference=f_style;task=input'>[f_style]</a><BR>"
				dat += "<span style='border: 1px solid #161616; background-color: rgb([r_facial],[g_facial],[b_facial]);'>&nbsp;&nbsp;&nbsp;</span> <a href='?_src_=prefs;preference=facial;task=input'>Change</a><BR>"


				dat += "</td><td valign='top'>"

				dat += "<h3>Eye Color</h3>"

				dat += "<span style='border: 1px solid #161616; background-color: rgb([r_eyes],[g_eyes],[b_eyes]);'>&nbsp;&nbsp;&nbsp;</span> <a href='?_src_=prefs;preference=eyes;task=input'>Change</a><BR>"


				dat += "</td></tr></table>"


			if (1) // Game Preferences
				dat += "<table><tr><td width='340px' height='300px' valign='top'>"
				dat += "<h2>General Settings</h2>"
				dat += "<b>UI Style:</b> <a href='?_src_=prefs;preference=ui'>[UI_style]</a><br>"
				dat += "<b>Play admin midis:</b> <a href='?_src_=prefs;preference=hear_midis'>[(toggles & SOUND_MIDI) ? "Yes" : "No"]</a><br>"
				dat += "<b>Play lobby music:</b> <a href='?_src_=prefs;preference=lobby_music'>[(toggles & SOUND_LOBBY) ? "Yes" : "No"]</a><br>"
				dat += "<b>Ghost ears:</b> <a href='?_src_=prefs;preference=ghost_ears'>[(toggles & CHAT_GHOSTEARS) ? "Nearest Creatures" : "All Speech"]</a><br>"
				dat += "<b>Ghost sight:</b> <a href='?_src_=prefs;preference=ghost_sight'>[(toggles & CHAT_GHOSTSIGHT) ? "Nearest Creatures" : "All Emotes"]</a><br>"

				if(config.allow_Metadata)
					dat += "<b>OOC Notes:</b> <a href='?_src_=prefs;preference=metadata;task=input'> Edit </a><br>"

				if(user.client && user.client.holder)
					dat += "<b>Adminhelp Sound</b>: "
					dat += "<a href='?_src_=prefs;preference=hear_adminhelps'>[(toggles & SOUND_ADMINHELP)?"On":"Off"]</a><br>"

					if(config.allow_admin_ooccolor && check_rights(R_ADMIN,0))
						dat += "<br><b>OOC</b><br>"
						dat += "<span style='border: 1px solid #161616; background-color: [ooccolor];'>&nbsp;&nbsp;&nbsp;</span> <a href='?_src_=prefs;preference=ooccolor;task=input'>Change</a><br>"

				dat += "</td><td width='300px' height='300px' valign='top'>"

				dat += "<h2>Antagonist Settings</h2>"

				if(jobban_isbanned(user, "Syndicate"))
					dat += "<b>You are banned from antagonist roles.</b>"
					src.be_special = 0
				else
					var/n = 0
					for (var/i in special_roles)
						if(special_roles[i]) //if mode is available on the server
							if(jobban_isbanned(user, i))
								dat += "<b>Be [i]:</b> <font color=red><b>\[BANNED]</b></font><br>"
							else if(i == "pai candidate")
								if(jobban_isbanned(user, "pAI"))
									dat += "<b>Be [i]:</b> <font color=red><b>\[BANNED]</b></font><br>"
							else
								dat += "<b>Be [i]:</b> <a href='?_src_=prefs;preference=be_special;num=[n]'>[src.be_special&(1<<n) ? "Yes" : "No"]</a><br>"
						n++
				dat += "</td></tr></table>"

		dat += "<hr><center>"

		if(!IsGuestKey(user.key))
			dat += "<a href='?_src_=prefs;preference=load'>Undo</a> "
			dat += "<a href='?_src_=prefs;preference=save'>Save Setup</a> "

		dat += "<a href='?_src_=prefs;preference=reset_all'>Reset Setup</a>"
		dat += "</center>"

		//user << browse(dat, "window=preferences;size=560x560")
		var/datum/browser/popup = new(user, "preferences", "<div align='center'>Character Setup</div>", 580, 560)
		popup.set_content(dat)
		popup.open(0)

	proc/SetChoices(mob/user, limit = 17, list/splitJobs = list("Chief Engineer"), width = 580, height = 560)
		if(!job_master)	return

		//limit 	 - The amount of jobs allowed per column. Defaults to 17 to make it look nice.
		//splitJobs - Allows you split the table by job. You can make different tables for each department by including their heads. Defaults to CE to make it look nice.
		//width	 - Screen' width. Defaults to 550 to make it look nice.
		//height 	 - Screen's height. Defaults to 500 to make it look nice.


		var/HTML = "<center>"
		HTML += "<b>Choose occupation chances</b><br>"
		HTML += "<center><a href='?_src_=prefs;preference=job;task=close'>Done</a></center><br>" // Easier to press up here.
		HTML += "<table width='100%' cellpadding='1' cellspacing='0'><tr><td width='20%'>" // Table within a table for alignment, also allows you to easily add more colomns.
		HTML += "<table width='100%' cellpadding='1' cellspacing='0'>"
		var/index = -1

		//The job before the current job. I only use this to get the previous jobs color when I'm filling in blank rows.
		var/datum/job/lastJob

		for(var/datum/job/job in job_master.occupations)

			index += 1
			if((index >= limit) || (job.title in splitJobs))
				if((index < limit) && (lastJob != null))
					//If the cells were broken up by a job in the splitJob list then it will fill in the rest of the cells with
					//the last job's selection color. Creating a rather nice effect.
					for(var/i = 0, i < (limit - index), i += 1)
						HTML += "<tr bgcolor='[lastJob.selection_color]'><td width='60%' align='right'>&nbsp</td><td>&nbsp</td></tr>"
				HTML += "</table></td><td width='20%'><table width='100%' cellpadding='1' cellspacing='0'>"
				index = 0

			HTML += "<tr bgcolor='[job.selection_color]'><td width='60%' align='right'>"
			var/rank = job.title
			lastJob = job
			if(jobban_isbanned(user, rank))
				HTML += "<font color=red>[rank]</font></td><td><font color=red><b> \[BANNED\]</b></font></td></tr>"
				continue
			if(!job.player_old_enough(user.client))
				var/available_in_days = job.available_in_days(user.client)
				HTML += "<font color=red>[rank]</font></td><td><font color=red> \[IN [(available_in_days)] DAYS\]</font></td></tr>"
				continue
			if((job_civilian_low & ASSISTANT) && (rank != "Assistant"))
				HTML += "<font color=orange>[rank]</font></td><td></td></tr>"
				continue
			if((rank in command_positions) || (rank == "AI"))//Bold head jobs
				HTML += "<b><span class='dark'>[rank]</span></b>"
			else
				HTML += "<span class='dark'>[rank]</span>"

			HTML += "</td><td width='40%'>"

			HTML += "<a class='white' href='?_src_=prefs;preference=job;task=input;text=[rank]'>"

			if(rank == "Assistant")//Assistant is special
				if(job_civilian_low & ASSISTANT)
					HTML += "<font color=green>Yes</font>"
				else
					HTML += "<font color=red>No</font>"
				HTML += "</a></td></tr>"
				continue

			if(GetJobDepartment(job, 1) & job.flag)
				HTML += "High"
			else if(GetJobDepartment(job, 2) & job.flag)
				HTML += "<font color=green>Medium</font>"
			else if(GetJobDepartment(job, 3) & job.flag)
				HTML += "<font color=orange>Low</font>"
			else
				HTML += "<font color=red>NEVER</font>"
			HTML += "</a></td></tr>"

		HTML += "</td'></tr></table>"

		HTML += "</center></table>"

		HTML += "<center><br><a href='?_src_=prefs;preference=job;task=random'>[userandomjob ? "Get random job if preferences unavailable" : "Be an Assistant if preference unavailable"]</a></center>"
		HTML += "<center><a href='?_src_=prefs;preference=job;task=reset'>Reset Preferences</a></center>"

		user << browse(null, "window=preferences")
		//user << browse(HTML, "window=mob_occupation;size=[width]x[height]")
		var/datum/browser/popup = new(user, "mob_occupation", "<div align='center'>Occupation Preferences</div>", width, height)
		popup.set_window_options("can_close=0")
		popup.set_content(HTML)
		popup.open(0)
		return


	proc/SetJob(mob/user, role)
		var/datum/job/job = job_master.GetJob(role)
		if(!job)
			user << browse(null, "window=mob_occupation")
			ShowChoices(user)
			return

		if(role == "Assistant")
			if(job_civilian_low & job.flag)
				job_civilian_low &= ~job.flag
			else
				job_civilian_low |= job.flag
			SetChoices(user)
			return 1

		if(GetJobDepartment(job, 1) & job.flag)
			SetJobDepartment(job, 1)
		else if(GetJobDepartment(job, 2) & job.flag)
			SetJobDepartment(job, 2)
		else if(GetJobDepartment(job, 3) & job.flag)
			SetJobDepartment(job, 3)
		else//job = Never
			SetJobDepartment(job, 4)

		SetChoices(user)
		return 1

	proc/ResetJobs()

		job_civilian_high = 0
		job_civilian_med = 0
		job_civilian_low = 0

		job_medsci_high = 0
		job_medsci_med = 0
		job_medsci_low = 0

		job_engsec_high = 0
		job_engsec_med = 0
		job_engsec_low = 0


	proc/GetJobDepartment(var/datum/job/job, var/level)
		if(!job || !level)	return 0
		switch(job.department_flag)
			if(CIVILIAN)
				switch(level)
					if(1)
						return job_civilian_high
					if(2)
						return job_civilian_med
					if(3)
						return job_civilian_low
			if(MEDSCI)
				switch(level)
					if(1)
						return job_medsci_high
					if(2)
						return job_medsci_med
					if(3)
						return job_medsci_low
			if(ENGSEC)
				switch(level)
					if(1)
						return job_engsec_high
					if(2)
						return job_engsec_med
					if(3)
						return job_engsec_low
		return 0


	proc/SetJobDepartment(var/datum/job/job, var/level)
		if(!job || !level)	return 0
		switch(level)
			if(1)//Only one of these should ever be active at once so clear them all here
				job_civilian_high = 0
				job_medsci_high = 0
				job_engsec_high = 0
				return 1
			if(2)//Set current highs to med, then reset them
				job_civilian_med |= job_civilian_high
				job_medsci_med |= job_medsci_high
				job_engsec_med |= job_engsec_high
				job_civilian_high = 0
				job_medsci_high = 0
				job_engsec_high = 0

		switch(job.department_flag)
			if(CIVILIAN)
				switch(level)
					if(2)
						job_civilian_high = job.flag
						job_civilian_med &= ~job.flag
					if(3)
						job_civilian_med |= job.flag
						job_civilian_low &= ~job.flag
					else
						job_civilian_low |= job.flag
			if(MEDSCI)
				switch(level)
					if(2)
						job_medsci_high = job.flag
						job_medsci_med &= ~job.flag
					if(3)
						job_medsci_med |= job.flag
						job_medsci_low &= ~job.flag
					else
						job_medsci_low |= job.flag
			if(ENGSEC)
				switch(level)
					if(2)
						job_engsec_high = job.flag
						job_engsec_med &= ~job.flag
					if(3)
						job_engsec_med |= job.flag
						job_engsec_low &= ~job.flag
					else
						job_engsec_low |= job.flag
		return 1


	proc/process_link(mob/user, list/href_list)
		if(!user)	return
		if(!istype(user, /mob/new_player))	return

		if(href_list["preference"] == "job")
			switch(href_list["task"])
				if("close")
					user << browse(null, "window=mob_occupation")
					ShowChoices(user)
				if("reset")
					ResetJobs()
					SetChoices(user)
				if("random")
					userandomjob = !userandomjob
					SetChoices(user)
				if("input")
					SetJob(user, href_list["text"])
				else
					SetChoices(user)
			return 1

		switch(href_list["task"])
			if("random")
				switch(href_list["preference"])
					if("name")
						real_name = random_name(gender)
					if("age")
						age = rand(AGE_MIN, AGE_MAX)
					if("hair")
						r_hair = rand(0,255)
						g_hair = rand(0,255)
						b_hair = rand(0,255)
					if("h_style")
						h_style = random_hair_style(gender)
					if("facial")
						r_facial = rand(0,255)
						g_facial = rand(0,255)
						b_facial = rand(0,255)
					if("f_style")
						f_style = random_facial_hair_style(gender)
					if("underwear")
						underwear = rand(1,underwear_m.len)
					if("eyes")
						r_eyes = rand(0,255)
						g_eyes = rand(0,255)
						b_eyes = rand(0,255)
					if("s_tone")
						s_tone = random_skin_tone()
					if("bag")
						backbag = rand(1,3)
					if("all")
						randomize_appearance_for()	//no params needed

			if("input")
				switch(href_list["preference"])
					if("name")
						var/new_name = reject_bad_name( input(user, "Choose your character's name:", "Character Preference")  as text|null )
						if(new_name)
							real_name = new_name
						else
							user << "<font color='red'>Invalid name. Your name should be at least 2 and at most [MAX_NAME_LEN] characters long. It may only contain the characters A-Z, a-z, -, ' and .</font>"

					if("age")
						var/new_age = input(user, "Choose your character's age:\n([AGE_MIN]-[AGE_MAX])", "Character Preference") as num|null
						if(new_age)
							age = max(min( round(text2num(new_age)), AGE_MAX),AGE_MIN)

					if("metadata")
						var/new_metadata = input(user, "Enter any information you'd like others to see, such as Roleplay-preferences:", "Game Preference" , metadata)  as message|null
						if(new_metadata)
							metadata = sanitize(copytext(new_metadata,1,MAX_MESSAGE_LEN))

					if("hair")
						var/new_hair = input(user, "Choose your character's hair colour:", "Character Preference") as color|null
						if(new_hair)
							r_hair = hex2num(copytext(new_hair, 2, 4))
							g_hair = hex2num(copytext(new_hair, 4, 6))
							b_hair = hex2num(copytext(new_hair, 6, 8))

					if("h_style")
						var/new_h_style = input(user, "Choose your character's hair style:", "Character Preference")  as null|anything in hair_styles_list
						if(new_h_style)
							h_style = new_h_style

					if("facial")
						var/new_facial = input(user, "Choose your character's facial-hair colour:", "Character Preference") as color|null
						if(new_facial)
							r_facial = hex2num(copytext(new_facial, 2, 4))
							g_facial = hex2num(copytext(new_facial, 4, 6))
							b_facial = hex2num(copytext(new_facial, 6, 8))

					if("f_style")
						var/new_f_style = input(user, "Choose your character's facial-hair style:", "Character Preference")  as null|anything in facial_hair_styles_list
						if(new_f_style)
							f_style = new_f_style

					if("underwear")
						var/list/underwear_options
						if(gender == MALE)
							underwear_options = underwear_m
						else
							underwear_options = underwear_f

						var/new_underwear = input(user, "Choose your character's underwear:", "Character Preference")  as null|anything in underwear_options
						if(new_underwear)
							underwear = underwear_options.Find(new_underwear)

					if("eyes")
						var/new_eyes = input(user, "Choose your character's eye colour:", "Character Preference") as color|null
						if(new_eyes)
							r_eyes = hex2num(copytext(new_eyes, 2, 4))
							g_eyes = hex2num(copytext(new_eyes, 4, 6))
							b_eyes = hex2num(copytext(new_eyes, 6, 8))

					if("s_tone")
						var/new_s_tone = input(user, "Choose your character's skin-tone:\n(Light 1 - 220 Dark)", "Character Preference")  as num|null
						if(new_s_tone)
							s_tone = 35 - max(min( round(new_s_tone), 220),1)

					if("ooccolor")
						var/new_ooccolor = input(user, "Choose your OOC colour:", "Game Preference") as color|null
						if(new_ooccolor)
							ooccolor = new_ooccolor

					if("bag")
						var/new_backbag = input(user, "Choose your character's style of bag:", "Character Preference")  as null|anything in backbaglist
						if(new_backbag)
							backbag = backbaglist.Find(new_backbag)
			else
				switch(href_list["preference"])
					if("gender")
						if(gender == MALE)
							gender = FEMALE
						else
							gender = MALE

					if("hear_adminhelps")
						toggles ^= SOUND_ADMINHELP

					if("ui")
						switch(UI_style)
							if("Midnight")
								UI_style = "Plasmafire"
							if("Plasmafire")
								UI_style = "Retro"
							else
								UI_style = "Midnight"

					if("be_special")
						var/num = text2num(href_list["num"])
						be_special ^= (1<<num)

					if("name")
						be_random_name = !be_random_name

					if("hear_midis")
						toggles ^= SOUND_MIDI

					if("lobby_music")
						toggles ^= SOUND_LOBBY
						if(toggles & SOUND_LOBBY)
							user << sound(ticker.login_music, repeat = 0, wait = 0, volume = 85, channel = 1)
						else
							user << sound(null, repeat = 0, wait = 0, volume = 85, channel = 1)

					if("ghost_ears")
						toggles ^= CHAT_GHOSTEARS

					if("ghost_sight")
						toggles ^= CHAT_GHOSTSIGHT

					if("save")
						save_preferences()
						save_character()

					if("load")
						load_preferences()
						load_character()

					if("changeslot")
						load_character(text2num(href_list["num"]))

					if("tab")
						if (href_list["tab"])
							current_tab = text2num(href_list["tab"])

		ShowChoices(user)
		return 1

	proc/copy_to(mob/living/carbon/human/character, safety = 0)
		if(be_random_name)
			real_name = random_name()

		if(config.humans_need_surnames)
			var/firstspace = findtext(real_name, " ")
			var/name_length = length(real_name)
			if(!firstspace)	//we need a surname
				real_name += " [pick(last_names)]"
			else if(firstspace == name_length)
				real_name += "[pick(last_names)]"

		character.real_name = real_name
		character.name = character.real_name
		if(character.dna)
			character.dna.real_name = character.real_name

		character.gender = gender
		character.age = age
		character.b_type = b_type

		character.r_eyes = r_eyes
		character.g_eyes = g_eyes
		character.b_eyes = b_eyes

		character.r_hair = r_hair
		character.g_hair = g_hair
		character.b_hair = b_hair

		character.r_facial = r_facial
		character.g_facial = g_facial
		character.b_facial = b_facial

		character.s_tone = s_tone

		character.h_style = h_style
		character.f_style = f_style

		if(underwear > underwear_m.len || underwear < 1)
			underwear = 1 //I'm sure this is 100% unnecessary, but I'm paranoid... sue me.
		character.underwear = underwear

		if(backbag > 3 || backbag < 1)
			backbag = 1 //Same as above
		character.backbag = backbag

		//Debugging report to track down a bug, which randomly assigned the plural gender to people.
		if(character.gender in list(PLURAL, NEUTER))
			if(isliving(src)) //Ghosts get neuter by default
				message_admins("[character] ([character.ckey]) has spawned with their gender as plural or neuter. Please notify coders.")
				character.gender = MALE

