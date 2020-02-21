ScriptName RaceMenuMorphsUNPR Extends RaceMenuBase

; Version data
Int Property SKEE_VERSION = 1 AutoReadOnly
Int Property NIOVERRIDE_SCRIPT_VERSION = 6 AutoReadOnly
Int Property RM_UNPR_VERSION = 1 AutoReadOnly
Int Property Version = 0 Auto

String Property CALLBACK_PART = "ChangeMorph" AutoReadOnly

String Property CATEGORY_KEY = "rsm_bodymorph_UNPR" AutoReadOnly
String Property MORPH_KEY = "UNPR.esp" AutoReadOnly

String[] morphs

Event OnInit()
	Parent.OnInit()
	Version = RM_UNPR_VERSION
EndEvent

Bool Function CheckNiOverride()
	Return SKSE.GetPluginVersion("skee") >= SKEE_VERSION && NiOverride.GetScriptVersion() >= NIOVERRIDE_SCRIPT_VERSION
EndFunction

Function InitMorphNames()
	morphs     = new String[82]
    morphs[0]  = "AnkleSeam"
    morphs[1]  = "WristSeam"
	morphs[2]  = "UNPR High"
	morphs[3]  = "UNPR to CBBE2"
	morphs[4]  = "UNPR to UUNP"
	morphs[5]  = "UNPR to 7base"
	morphs[6]  = "UNPR to UNPK"
	morphs[7]  = "UNPR to VanillaLow"
	morphs[8]  = "UNPR to VanillaHigh"
	morphs[9] = "UNPR To TBD"
	morphs[10] = "Breasts Lift"
	morphs[11] = "Breasts Apart"
	morphs[12] = "Breast Gravity"
	morphs[13] = "Breasts Perky"
	morphs[14] = "Breats Pointy"
	morphs[15] = "Breats Thick"
	morphs[16] = "Breast Together"
	morphs[17] = "Bigger Breasts"
	morphs[18] = "Chest Cavity"
	morphs[19] = "Nipple Distance"
	morphs[20] = "Nipple Up"
	morphs[21] = "Nipple Down"
	morphs[22] = "Nipple Pointy"
	morphs[23] = "Apple Cheeks"
	morphs[24] = "Cutie Booty"
	morphs[25] = "Big Booty"
	morphs[26] = "Round Booty"
	morphs[27] = "Tiny  Booty"
	morphs[28] = "Butt Up"
	morphs[29] = "Butt Down"
	morphs[30] = "Tight Cheeks"
	morphs[31] = "Neck Rise"
	morphs[32] = "Collar Bone"
	morphs[33] = "Belly Pup"
	morphs[34] = "Flat Belly"
	morphs[35] = "Belly Sink"
	morphs[36] = "Belly Tight"
	morphs[37] = "Big Belly"
	morphs[38] = "Belly Pregnancy"
	morphs[39] = "Tummy Tuck"
	morphs[40] = "Arm Growth"
	morphs[41] = "Arms Skinny"
	morphs[42] = "Arms Apart"
	morphs[43] = "Biceps Enlarged"
	morphs[44] = "Bicep Thin"
	morphs[45] = "Forearms Bulge"
	morphs[46] = "Forearms Thin"
	morphs[47] = "Tricep Slim"
	morphs[48] = "Tricep Thick"
	morphs[49] = "Shoulder Blades"
	morphs[50] = "Shoulder Minimize"
	morphs[51] = "Shoulders Stretch"
	morphs[52] = "Ribs Slim"
	morphs[53] = "Ribs Thick"
	morphs[54] = "Thick Torso"
	morphs[55] = "Slim Torso"
	morphs[56] = "Love Handles"
	morphs[57] = "Hips Curvy"
	morphs[58] = "Skinny Waist"
	morphs[59] = "Back Tight"
	morphs[60] = "Back Up"
	morphs[61] = "Back Down"
	morphs[62] = "Big Legs"
	morphs[63] = "Legs Thick"
	morphs[64] = "Legs Thin"
	morphs[65] = "Thin Legs"
	morphs[66] = "Thick Calves"
	morphs[67] = "Thin Calves"
	morphs[68] = "Thick Knees"
	morphs[69] = "Knee Height"
	morphs[70] = "Lower Bump"
	morphs[71] = "Puffy Lower Lips"
	morphs[72] = "Pussy Bump"
	morphs[73] = "Pussy Thick Labia"
	morphs[74] = "Pussy Thin Labia"
	morphs[75] = "Pussy Hanging Labia"
	morphs[76] = "Pussy Slant"
	morphs[77] = "Pussy Lift"
	morphs[78] = "Pussy Front Labia"
	morphs[79] = "Pussy Back Labia"
	morphs[80] = "Pussy Left Labia"
	morphs[81] = "Pussy Right Labia"
EndFunction

Event OnCategoryRequest()
	AddCategory(CATEGORY_KEY, "UNPR MORPHS", -944)
	InitMorphNames()
EndEvent

;Add custom sliders here
Event OnSliderRequest(Actor player, ActorBase playerBase, Race actorRace, Bool isFemale)
	If !isFemale && CheckNiOverride()
		AddSliderEx("Reset", CATEGORY_KEY, CALLBACK_PART + "Reset", 0.0, 2.0, 1.0, 0.0)

		Int m
		While m < morphs.Length
			AddSliderEx(morphs[m], CATEGORY_KEY, CALLBACK_PART + morphs[m], -1.0, 1.0, 0.01, getBodyMorph(morphs[m]))
			m += 1
		EndWhile
		
		Version = RM_UNPR_VERSION
	Endif
EndEvent

Event OnSliderChanged(String callback, Float value)
	If CheckNiOverride()
		If callback == (CALLBACK_PART + "Reset")
			If value == 2.0
				clearBodyMorphs()
			EndIf
		Else
			Int m
			While m < morphs.Length
				If callback == (CALLBACK_PART + morphs[m])
					addBodyMorph(morphs[m], value)
				EndIf
				m += 1
			EndWhile
		EndIf
	Endif
EndEvent

Function addBodyMorph(String morphName, Float value)
	NiOverride.SetBodyMorph(_targetActor, morphName, MORPH_KEY, value)
	NiOverride.UpdateModelWeight(_targetActor)
EndFunction

Float Function getBodyMorph(String morphName)
	Return NiOverride.GetBodyMorph(_targetActor, morphName, MORPH_KEY)
EndFunction

Function clearBodyMorphs()
	NiOverride.ClearBodyMorphKeys(_targetActor, MORPH_KEY)
	NiOverride.UpdateModelWeight(_targetActor)

	Int sliderPosFlag = 1 + 2 + 4 + 8
	Int sliderUpdateFlag = 2 + 4 + 8
	String[] sliderNames = Utility.CreateStringArray(morphs.Length + 1)
	Float[] sliderValues = Utility.CreateFloatArray(morphs.Length + 1)
	Int[] sliderFlags = Utility.CreateIntArray(morphs.Length + 1, sliderPosFlag)

	Int m
	While m < morphs.Length
		sliderNames[m] = CALLBACK_PART + morphs[m]
		m += 1
	EndWhile

	sliderNames[sliderNames.Length - 1] = CALLBACK_PART + "Reset"
	sliderFlags[sliderFlags.Length - 1] = sliderUpdateFlag

	SetSliderParametersEx(sliderNames, sliderValues, sliderValues, sliderValues, sliderValues, sliderFlags)
EndFunction
