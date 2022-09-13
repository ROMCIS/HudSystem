setElementData(localPlayer, "hud:hungerr" , 100)
setElementData(localPlayer, "hud:thirstt" , 100)

local x,y = guiGetScreenSize()  
local cx,cy = 1920,1080

local screenWidth, screenHeight = guiGetScreenSize()

local screenW,screenH = guiGetScreenSize()
locationname = getResourceName(getThisResource())
local page = "http://mta/"..locationname.."/html/index.html"
local initBrowser = guiCreateBrowser(1130*x/cx, 30*y/cy, 757*x/cx, 682*y/cy, true, true, false)
local theBrowser = guiGetBrowser(initBrowser) 
guiSetVisible(initBrowser, false)

addEventHandler("onClientBrowserCreated", theBrowser, 
	function()
		loadBrowserURL(source, page)		
	end
)

function isCameraOnPlayer()
	local vehicle = getPedOccupiedVehicle(getLocalPlayer())
	if vehicle then
		return getCameraTarget( ) == vehicle
	else
		return getCameraTarget( ) == getLocalPlayer()
	end
end

local stamina = 100
local stamina_MAX = 100

function staminaCycle()
	local tired = getElementData(localPlayer, "tired")
	if tired then
		stamina = stamina+7
	elseif getPedMoveState(localPlayer) == "stand" then
		stamina = stamina+2
	elseif getPedMoveState(localPlayer) == "walk" then
		stamina = stamina+2
	elseif getPedMoveState(localPlayer) == "powerwalk" then
		stamina = stamina+3
	elseif getPedMoveState(localPlayer) == "jog" then
		stamina = stamina-2
	elseif getPedMoveState(localPlayer) == "sprint" then
		stamina = stamina-3
	elseif getPedMoveState(localPlayer) == "jump" then
		stamina = stamina-8
	elseif getPedMoveState(localPlayer) == "crouch" then
		stamina = stamina+2
	elseif getPedMoveState(localPlayer) == "crawl" then
		stamina = stamina-3
	else
		stamina = stamina+1
	end

	if stamina > stamina_MAX then
		stamina = stamina_MAX
	end
	if stamina > 20 then
		toggleControl("jump", true)
	end
	if stamina >= 100 then
		toggleControl("sprint", true)
	end
	if stamina < 0 then
		toggleControl("jump", false)
		toggleControl("sprint", false)
		stamina = 0
		triggerServerEvent("setTiredAnimation", root, localPlayer)
	end
	setElementData(localPlayer, "stamina", stamina)
	setTimer(staminaCycle, 1000, 1)
end
setTimer(staminaCycle, 1000, 1)


setTimer(function()
local time = getRealTime()
local hours = time.hour
local minutes = time.minute
local seconds = time.second
local monthday = time.monthday
local month = time.month
local year = time.year
if (hours > 12)then
hours = hours - 12
end
local romcisDate = string.format("%02d/%02d/%04d", monthday, month + 1, year + 1900)
local romcisTime = string.format("%02d:%02d", hours, minutes)
local converted = ("".. (hours >= 12 and "AM" or "PM") .."")
if ((getElementData(getLocalPlayer(),"hud:hungerr") or 100) >= 100) then setElementData(getLocalPlayer(),"hud:hungerr",100) end
if ((getElementData(getLocalPlayer(),"hud:thirstt") or 100) >= 100) then setElementData(getLocalPlayer(),"hud:thirstt",100) end
if ((getElementData(getLocalPlayer(),"hud:hungerr") or 100) <= 0) then setElementData(getLocalPlayer(),"hud:hungerr",0) setElementHealth(getLocalPlayer(),getElementHealth(getLocalPlayer()) - 0.05) end
if ((getElementData(getLocalPlayer(),"hud:thirstt") or 100) <= 0) then setElementData(getLocalPlayer(),"hud:thirstt",0) setElementHealth(getLocalPlayer(),getElementHealth(getLocalPlayer()) - 0.03) end
if ((getElementData(getLocalPlayer(),"hud:hungerr") or 100) <= 100) then setElementData(getLocalPlayer(),"hud:hungerr",(getElementData(getLocalPlayer(),"hud:hungerr") or 0) - 0.03) end
if ((getElementData(getLocalPlayer(),"hud:thirstt") or 100) <= 100) then setElementData(getLocalPlayer(),"hud:thirstt",(getElementData(getLocalPlayer(),"hud:thirstt") or 0) - 0.03) end
hunger = getElementData(localPlayer, "hud:hungerr")
thirst = getElementData(localPlayer, "hud:thirstt")
executeBrowserJavascript(theBrowser, 'document.getElementById("water").style.height = "'..thirst..'%"');
walk = getPedWalkingStyle ( localPlayer )
sdw = "Walk "..walk
executeBrowserJavascript(theBrowser, 'document.getElementById("walk_id").innerHTML = "' .. sdw .. '"')
executeBrowserJavascript(theBrowser, 'document.getElementById("food").style.height = "'..hunger..'%"');
tun = getElementData(localPlayer, "stamina")
executeBrowserJavascript(theBrowser, 'document.getElementById("run").style.height = "'..tun..'%"');
executeBrowserJavascript(theBrowser, 'document.getElementById("date").innerHTML = "' .. romcisTime .. ' ' .. converted .. ' || ' .. romcisDate .. '"')
shield = math.floor( getPlayerArmor( localPlayer ) ).."%"
executeBrowserJavascript(theBrowser, 'document.getElementById("shield").style.height = "'..shield..'"');
healt = math.floor( getElementHealth( localPlayer ) ).."%"
executeBrowserJavascript(theBrowser, 'document.getElementById("heart").style.height = "'..healt..'"');
end,1000,0)

setTimer(function()
if getElementData(getLocalPlayer(), "exclusiveGUI") or not isCameraOnPlayer() then
return
end
if getElementData(localPlayer, "loggedin") == 1 then 
executeBrowserJavascript(theBrowser, 'document.getElementById("hud").style.display = ""');
executeBrowserJavascript(theBrowser, 'document.getElementById("top").style.display = ""');
guiSetVisible(initBrowser, true)
else 
executeBrowserJavascript(theBrowser, 'document.getElementById("hud").style.display = "none"'); 
executeBrowserJavascript(theBrowser, 'document.getElementById("top").style.display = "none"'); 
guiSetVisible(initBrowser, false)
end 
end, 3000, 0)


addEventHandler("onClientElementDataChange",root,function()
if getElementType(source) == "player" then 
local hasTogPM, togPMState = exports.donators:hasPlayerPerk(localPlayer, 1)
if hasTogPM then
executeBrowserJavascript(theBrowser, 'document.getElementById("togpm").style.display = ""');
else 
executeBrowserJavascript(theBrowser, 'document.getElementById("togpm").style.display = "none"');
end 
----------------------------- شارة السكربتر :

local scripter = exports.integration:isPlayerScripter(localPlayer)
if scripter then 
executeBrowserJavascript(theBrowser, 'document.getElementById("scripter").style.display = ""');
else 
executeBrowserJavascript(theBrowser, 'document.getElementById("scripter").style.display = "none"');
end 

----------------------------- شارة الفوندر :

local founder = exports.integration:isPlayerFounder(localPlayer)
if founder then 
executeBrowserJavascript(theBrowser, 'document.getElementById("founder").style.display = ""');
else 
executeBrowserJavascript(theBrowser, 'document.getElementById("founder").style.display = "none"');
end 

----------------------------- شارة الأدمن :

local admin = exports.integration:isPlayerTrialAdmin(localPlayer)
if admin then 
executeBrowserJavascript(theBrowser, 'document.getElementById("admin").style.display = ""');
else 
executeBrowserJavascript(theBrowser, 'document.getElementById("admin").style.display = "none"');
end 

----------------------------- شارة سبورتر :

local supp = exports.integration:isPlayerSupporter(localPlayer)
if supp then 
executeBrowserJavascript(theBrowser, 'document.getElementById("support").style.display = ""');
else 
executeBrowserJavascript(theBrowser, 'document.getElementById("support").style.display = "none"');
end 

----------------------------- داعم بوستر :

local Booster = exports.integration:isPlayerBooster(localPlayer)
if Booster then 
executeBrowserJavascript(theBrowser, 'document.getElementById("nitro").style.display = ""');
else 
executeBrowserJavascript(theBrowser, 'document.getElementById("nitro").style.display = "none"');
end 

if getPedWeapon(localPlayer) ~= 0 then 
executeBrowserJavascript(theBrowser, 'document.getElementById("gun").style.display = ""');
else 
executeBrowserJavascript(theBrowser, 'document.getElementById("gun").style.display = "none"'); 

end 
end
end)


function romcis_afk(ms)
if getElementData ( localPlayer, "afk" ) == "on" then
	setElementData(localPlayer, "afk", "off")
	playToggleSound()
	executeBrowserJavascript(theBrowser, 'document.getElementById("afk").style.opacity = "0.5"');
else 
	setElementData(localPlayer, "afk", "on")
	playToggleSound()
	executeBrowserJavascript(theBrowser, 'document.getElementById("afk").style.opacity = "1"');
end 
end 
addEvent("romcis_afk", true) 
addEventHandler("romcis_afk", root, romcis_afk) 


function scriper_fy(ms)
	
	if getElementData(localPlayer, "d_duty") == "1" then 
	triggerEvent("accounts:settings:updateAccountSettings", localPlayer, "duty_dev", 0)
	setElementData(localPlayer , "d_duty" , "0")
	playToggleSound()
	executeBrowserJavascript(theBrowser, 'document.getElementById("scripter").style.opacity = "0.5"');
else 
	triggerEvent("accounts:settings:updateAccountSettings", localPlayer, "duty_dev", 1)
	setElementData(localPlayer , "d_duty" , "1")
	playToggleSound()
	executeBrowserJavascript(theBrowser, 'document.getElementById("scripter").style.opacity = "1"');
end 
end 
addEvent("scriper_fy", true) 
addEventHandler("scriper_fy", root, scriper_fy) 

function founder_fy(ms)
	if getElementData(localPlayer, "a_duty") == "1" then 
	triggerEvent("accounts:settings:updateAccountSettings", localPlayer, "duty_admin", 0)
	setElementData(localPlayer , "a_duty" , "0")
	playToggleSound()
	executeBrowserJavascript(theBrowser, 'document.getElementById("founder").style.opacity = "0.5"');
else 
	triggerEvent("accounts:settings:updateAccountSettings", localPlayer, "duty_admin", 1)
	setElementData(localPlayer , "a_duty" , "1")
	playToggleSound()
	executeBrowserJavascript(theBrowser, 'document.getElementById("founder").style.opacity = "1"');

end 
end 
addEvent("founder_fy", true) 
addEventHandler("founder_fy", root, founder_fy) 


function admins_fy(ms)
if getElementData(localPlayer, "a_duty") == "1" then 
	triggerEvent("accounts:settings:updateAccountSettings", localPlayer, "duty_admin", 0)
	setElementData(localPlayer , "a_duty" , "0")
	playToggleSound()
	executeBrowserJavascript(theBrowser, 'document.getElementById("admin").style.opacity = "0.5"');
else 
	triggerEvent("accounts:settings:updateAccountSettings", localPlayer, "duty_admin", 1)
	setElementData(localPlayer , "a_duty" , "1")
	playToggleSound()
	executeBrowserJavascript(theBrowser, 'document.getElementById("admin").style.opacity = "1"');
end 
end 
addEvent("admins_fy", true) 
addEventHandler("admins_fy", root, admins_fy) 



function supp(ms)
if getElementData(localPlayer, "s_duty") == "1" then 
	setElementData(localPlayer , "s_duty" , "0")
	triggerEvent("accounts:settings:updateAccountSettings", localPlayer, "duty_supporter", 0)
	playToggleSound()
	executeBrowserJavascript(theBrowser, 'document.getElementById("support").style.opacity = "0.5"');
else 
	triggerEvent("accounts:settings:updateAccountSettings", localPlayer, "duty_supporter", 1)
	setElementData(localPlayer , "s_duty" , "1")
	playToggleSound()
	executeBrowserJavascript(theBrowser, 'document.getElementById("support").style.opacity = "1"');

end 
end 
addEvent("supp_fy", true) 
addEventHandler("supp_fy", root, supp) 


function playToggleSound()
	playSFX("genrl", 52, 10, false)
end

function vip_fy(ms)
if getElementData( localPlayer,"duty_booster" ) == 1 then
					triggerEvent("accounts:settings:updateAccountSettings", localPlayer, "duty_booster", 0)
							triggerServerEvent("updateNametagColor", localPlayer)
							playToggleSound()
							executeBrowserJavascript(theBrowser, 'document.getElementById("nitro").style.opacity = "0.5"');
else 
						triggerEvent("accounts:settings:updateAccountSettings", localPlayer, "duty_booster", 1)
							triggerServerEvent("updateNametagColor", localPlayer)
							playToggleSound()
							executeBrowserJavascript(theBrowser, 'document.getElementById("nitro").style.opacity = "1"');
end
end 
addEvent("vip_fy", true) 
addEventHandler("vip_fy", root, vip_fy) 



function walkstyle_fy(ss)

triggerServerEvent("realism:switchWalkingStyle", localPlayer)
	playToggleSound()

end 
addEvent("walkstyle_fy", true) 
addEventHandler("walkstyle_fy", root, walkstyle_fy) 


function togprivate(ss)
triggerServerEvent("chat:togpm", localPlayer,localPlayer)
	playToggleSound()
end 
addEvent("togprivate", true) 
addEventHandler("togprivate", root, togprivate) 
