--[[ ⠀⠀

          .                                                      .
        .n                   .                 .                  n.
  .   .dP                  dP                   9b                 9b.    .
 4    qXb         .       dX                     Xb       .        dXp     t
dX.    9Xb      .dXb    __                         __    dXb.     dXP     .Xb
9XXb._       _.dXXXXb dXXXXbo.                 .odXXXXb dXXXXb._       _.dXXP
 9XXXXXXXXXXXXXXXXXXXVXXXXXXXXOo.           .oOXXXXXXXXVXXXXXXXXXXXXXXXXXXXP
  `9XXXXXXXXXXXXXXXXXXXXX'~   ~`OOO8b   d8OOO'~   ~`XXXXXXXXXXXXXXXXXXXXXP'
    `9XXXXXXXXXXXP' `9XX'    NO    `98v8P'  RECOIL  `XXP' `9XXXXXXXXXXXP'
        ~~~~~~~       9X.          .db|db.          .XP       ~~~~~~~
                        )b.  .dbo.dP'`v'`9b.odb.  .dX(
                      ,dXXXXXXXXXXXb     dXXXXXXXXXXXb.
                     dXXXXXXXXXXXP'   .   `9XXXXXXXXXXXb
                    dXXXXXXXXXXXXb   d|b   dXXXXXXXXXXXXb
                    9XXb'   `XXXXXb.dX|Xb.dXXXXX'   `dXXP
                     `'      9XXXXXX(   )XXXXXXP      `'
                              XXXX X.`v'.X XXXX
                              XP^X'`b   d'`X^XX
                              X. 9  `   '  P )X
                              `b  `       '  d'
                               `             '

⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀

        R E C O I L  C O N T R O L  S C R I P T  ( R C S )  V 2 . 2 
				by @mjzt on youtube
        
      -- Patch Notes (V2.2)
        Added Humanizer
        Optimized Layout
        Added Horizontal RC
--]]

--@region: RCS_SETTINGS
local RCS_Settings = {
	Enabled = true,

	Toggle = {
		Required = true,
		Key = "CapsLock"
	},

	Mode = {
		Preset = "Custom", -- Low | Medium | High | Ultra | Insanity | Custom
		CustomStrength = 3
	},

	Recoil = {
		Vertical   = 6,
		Horizontal = 0,
		Delay      = 7
	},

	Humanizer = {
		Enabled   = true,
		Amplitude = 1.3,
		Jitter    = 6,
		Speed     = 0.085
	}
}
--@endregion




--[[
       HOW TO USE FOR DUMBIES, 
  (RC + HUMANIZER)
1: If the first "Enabled" is set to false, change to true.
2: Adjust your Recoil Control Strength, either by using a preset or a custom value!
3: Toggle it on (if you have ForceToggle enabled, else just do step 4.)
4: Hold Mouse1 and Mouse2 (LeftClick and RightClick) and it should drag your cursor downwards.
5: Aim at your target and you're done!

Humanizer (optional, makes recoil look more human):
1: Enabled = true/false (turns humanizer on/off)
2: Amplitude = how much sway is added, higher = more movement
3: Jitter = small random variation per tick, higher = messier but more human-like
4: Speed = how fast the sway oscillates, higher = faster sway

Things to note:

1: I did NOT make the Recoil Control Code, I just simplified everything, so you can adjust it to your needs
2: You don't need to hold down your toggle key, its a toggle
3: You must hold mouse1 and mouse2, or else IT WONT WORK!
4: Delay works in MS, the lower the faster. 7ms = 0.07s, 2000ms = 2s. However the preset Delay rate is perfect for most FPS games. 
5: Humanizer variables can be adjusted to make the recoil feel smoother or more natural. Experiment with Amplitude, Jitter, and Speed to find what feels best.

For Skids who want to take this and reupload without credit:

1: I release my projects publicly because I enjoy coding and sharing what I make.
2: Many of my projects have been stolen or reposted without credit, including:
    - Desync + Velocity FFlags for Roblox (later patched by Roblox)
    - Original Fake Angles Method for Roblox (later patched)
    - Version 2.1 of this Recoil Control Script (posted on UnknownCheats and other places claiming they made it)
    - My serversided desync resolver (posted everywhere, then patched by Roblox themselves)
3: People taking my work and claiming it as their own, or selling it, has made it harder for me to stay motivated to code and release for free.
4: Release your own code. Experiment. Learn. Don't just copy mine, Lua really isnt difficult at all.

--]]































--@region: INIT
EnablePrimaryMouseButtonEvents(true)
math.randomseed(GetRunningTime())
--@endregion



--@region: PRESET_STUFF
local presetshit = {
	Low      = 2,
	Medium   = 6,
	High     = 8,
	Ultra    = 12,
	Insanity = 31
}

local function getStrength()
	if RCS_Settings.Mode.Preset == "Custom" then
		return RCS_Settings.Mode.CustomStrength
	end
	    return presetshit[RCS_Settings.Mode.Preset] or presetshit.Medium
end
--@endregion



--@region: HUMANIZE_RCS
local tickrn = 0
local vleft  = 0
local hleft  = 0

local function humanize(v, h)
	if not RCS_Settings.Humanizer.Enabled then
		return v, h
	end

	tickrn = tickrn + 1

	local sway = math.sin(tickrn * RCS_Settings.Humanizer.Speed) * RCS_Settings.Humanizer.Amplitude

	local jitterv = math.random(-RCS_Settings.Humanizer.Jitter * 10, RCS_Settings.Humanizer.Jitter * 10) / 10

	local jitterh = math.random(-RCS_Settings.Humanizer.Jitter * 10, RCS_Settings.Humanizer.Jitter * 10) / 10

	vleft = vleft + v + sway + jitterv
	hleft = hleft + h + jitterh

	local vout = math.floor(vleft)
	local hout = math.floor(hleft)

	vleft = vleft - vout
	hleft = hleft - hout

	return vout, hout
end
--@endregion



--@region: RC_MAIN
OutputLogMessage("@mjzt on Youtube!\n")
OutputLogMessage("hush while i rot\n")
OutputLogMessage("RCS V2.2\n")
function OnEvent(ev, arg)
	if not RCS_Settings.Enabled then
		return
	end

	if RCS_Settings.Toggle.Required
	and not IsKeyLockOn(RCS_Settings.Toggle.Key) then
		return
	end

	if IsMouseButtonPressed(3) then
		repeat
			if IsMouseButtonPressed(1) then
				repeat
					local v = getStrength()
					local h = RCS_Settings.Recoil.Horizontal

					v, h = humanize(v, h)

					MoveMouseRelative(h, v)
					Sleep(RCS_Settings.Recoil.Delay)

				until not IsMouseButtonPressed(1)
			end
		until not IsMouseButtonPressed(3)
	end
end
--@endregion