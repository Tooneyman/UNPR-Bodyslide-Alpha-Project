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
	morphs     = new String[90]
	morphs[0]  = "NeckSeam"
    morphs[1]  = "AnkleSeam"
    morphs[2]  = "WristSeam"
	morphs[3]  = "UNPR High"
	morphs[4]  = "UNPR to CBBE2"
	morphs[5]  = "UNPR to UUNP"
	morphs[6]  = "UNPR to 7base"
	morphs[7]  = "UNPR to UNPK"
	morphs[8]  = "UNPR to VanillaLow"
	morphs[9]  = "UNPR to VanillaHigh"
	morphs[10] = "UNPR To TBD"
	morphs[11] = "Breasts Lift"
	morphs[12] = "Breasts Apart"
	morphs[13] = "Breast Gravity"
	morphs[14] = "Breasts Perky"
	morphs[15] = "Breats Pointy"
	morphs[16] = "Breats Thick"
	morphs[17] = "Breast Together"
	morphs[18] = "Bigger Breasts"
	morphs[19] = "Chest Cavity"
	morphs[20] = "Nipple Distance"
	morphs[21] = "Nipple Up"
	morphs[22] = "Nipple Down"
	morphs[23] = "Nipple Pointy"
	morphs[24] = "Apple Cheeks"
	morphs[25] = "Cutie Booty"
	morphs[26] = "Big Booty"
	morphs[27] = "Round Booty"
	morphs[28] = "Tiny  Booty"
	morphs[29] = "Butt Up"
	morphs[30] = "Butt Down"
	morphs[31] = "Tight Cheeks"
	morphs[32] = "Neck Rise"
	morphs[33] = "Collar Bone"
	morphs[34] = "Belly Pup"
	morphs[35] = "Flat Belly"
	morphs[36] = "Belly Sink"
	morphs[37] = "Belly Tight"
	morphs[38] = "Big Belly"
	morphs[39] = "Belly Pregnancy"
	morphs[40] = "Tummy Tuck"
	morphs[41] = "Arm Growth"
	morphs[42] = "Arms Skinny"
	morphs[43] = "Arms Apart"
	morphs[44] = "Biceps Enlarged"
	morphs[45] = "Bicep Thin"
	morphs[46] = "Forearms Bulge"
	morphs[47] = "Forearms Thin"
	morphs[48] = "Tricep Slim"
	morphs[49] = "Tricep Thick"
	morphs[50] = "Shoulder Blades"
	morphs[51] = "Shoulder Minimize"
	morphs[52] = "Shoulders Stretch"
	morphs[53] = "Ribs Slim"
	morphs[54] = "Ribs Thick"
	morphs[55] = "Thick Torso"
	morphs[56] = "Slim Torso"
	morphs[57] = "Love Handles"
	morphs[58] = "Hips Curvy"
	morphs[59] = "Skinny Waist"
	morphs[60] = "Back Tight"
	morphs[61] = "Back Up"
	morphs[62] = "Back Down"
	morphs[63] = "Big Legs"
	morphs[65] = "Legs Thick"
	morphs[66] = "Legs Thin"
	morphs[67] = "Thin Legs"
	morphs[68] = "Thick Calves"
	morphs[69] = "Thin Calves"
	morphs[70] = "Thick Knees"
	morphs[71] = "Knee Height"
	morphs[72] = "Lower Bump"
	morphs[73] = "Puffy Lower Lips"
	morphs[74] = "Pussy Bump"
	morphs[75] = "Pussy Thick Labia"
	morphs[76] = "Pussy Thin Labia"
	morphs[77] = "Pussy Hanging Labia"
	morphs[78] = "Pussy Slant"
	morphs[79] = "Pussy Lift"
	morphs[80] = "Pussy Front Labia"
	morphs[81] = "Pussy Back Labia"
	morphs[82] = "Pussy Left Labia"
	morphs[83] = "Pussy Right Labia"
EndFunction

Event OnCategoryRequest()
	AddCategory(CATEGORY_KEY, "UNPR MORPHS", -945)
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
