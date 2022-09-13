local x, y = guiGetScreenSize()
local link = "http://mta/"..getResourceName(getThisResource()).."/ui/index.html"
local browser = createBrowser(x, y, true, true, false)
local voice = false

addEventHandler("onClientBrowserCreated", browser, function()
   loadBrowserURL(source, link)
end)


function SendNUIMessage(browser, table)
   if isElement(browser) and type(table) == "table" then
      return executeBrowserJavascript(browser, 'window.postMessage('..toJSON(table)..'[0])')
   end
end

function dxNUI()

    dxDrawImage(0, 0, x, y, browser)
    local time = getRealTime()
    hour = time.hour
    minute = time.minute
    local health = getElementHealth(localPlayer)
    local armour = getPlayerArmor(localPlayer)
    local x,y,z = getElementPosition(localPlayer)
    local city = getZoneName(x, y, z, true)
    local zone = getZoneName(x, y, z)
    local radiof = getElementData(localPlayer, "config.elementradio") or "desativado"
    local oxygen = getPedOxygenLevel ( localPlayer ) or 100
    local thirst = getElementData(localPlayer, "sede") or 1
    local hunger = getElementData(localPlayer, "fome") or 1

      if isPedInVehicle(localPlayer) then
        local veh = getPedOccupiedVehicle(localPlayer)
        if not isElement(veh) then return end
        local gas = getElementData(veh, "Gasolina") or 100
        local showbelt = getElementData(localPlayer, 'Cinto') or false
        local engine = getElementHealth(getPedOccupiedVehicle(getLocalPlayer()))/10
        local speed = ( function( x, y, z ) return math.floor( math.sqrt( x*x + y*y + z*z ) * 155 ) end )( getElementVelocity( getPedOccupiedVehicle(localPlayer) ) ) 
        if armour > 1 then
        SendNUIMessage(browser, { hud = true,  screen = false, vehicle = true, talking = talking, health = health, armour = armour, oxigen = oxygen, direction = city, street = zone, radio = "Radio F: "..radiof, hours = hour, minutes = minute,  fuel = gas, rpm = speed, speed = speed.."kmh", thirst = thirst, hunger = hunger, engine = engine, showbelt = showbelt, engine = engine })
    else
        SendNUIMessage(browser, { hud = true, screen = false, vehicle = true, talking = talking, health = health, oxigen = oxygen, direction = city, street = zone, radio = "Radio F: "..radiof, hours = hour, minutes = minute,  fuel = gas, rpm = speed, speed = speed.."kmh", thirst = thirst, hunger = hunger, engine = engine, showbelt = showbelt, engine = engine })
      end
   else
      if armour > 1 then
        SendNUIMessage(browser, { hud = true, screen = false, vehicle = false, talking = talking, health = health, armour = armour, oxigen = oxygen, direction = city, street = zone, radio = "Radio F: "..radiof, hours = hour, minutes = minute, thirst = thirst, hunger = hunger })
      else
        SendNUIMessage(browser, { hud = true, screen = false, vehicle = false, talking = talking, health = health,  armour = armour, oxigen = oxygen, radio = "Radio F: "..radiof, direction = city, street = zone, hours = hour, minutes = minute, thirst = thirst, hunger = hunger })
    end
 end
end
addEventHandler('onClientRender', getRootElement(), dxNUI) 


function VoiceStart()
    talking = true
 end
 addEventHandler("onClientPlayerVoiceStart", localPlayer, VoiceStart)
 
 function VoiceStop()
    talking = false
 end
 addEventHandler("onClientPlayerVoiceStop", localPlayer, VoiceStop)

 
function setHud()
   setPlayerHudComponentVisible("armour", false)
   setPlayerHudComponentVisible("wanted", false)
   setPlayerHudComponentVisible("weapon", false)
   setPlayerHudComponentVisible("money", false)
   setPlayerHudComponentVisible("health", false)
   setPlayerHudComponentVisible("clock", false)
   setPlayerHudComponentVisible("breath", false)
   setPlayerHudComponentVisible("ammo", false)
end
addEventHandler("onClientResourceStart", getResourceRootElement(getThisResource()), setHud)

addEvent("speedo:clickEnigne", true);
addEventHandler("speedo:clickEnigne", browser, function()
triggerServerEvent("toggleEngine", localPlayer, localPlayer)

end)     

addEvent("speedo:clickHandbrake", true);
addEventHandler("speedo:clickHandbrake", browser, function()
exports['realism-system']:doHandbrake()
executeBrowserJavascript(browser, "toggleIcon('battery', true)");

     
end)	

   addEvent("speedo:clickLights", true);
addEventHandler("speedo:clickLights", browser, function()
   triggerServerEvent('togLightsVehicle', localPlayer)

     
end)	

      addEvent("speedo:clickSeatbelt", true);
addEventHandler("speedo:clickSeatbelt", browser, function()
   triggerServerEvent('realism:seatbelt:toggle', localPlayer, localPlayer)
end)

      addEvent("speedo:clickDoor", true);
addEventHandler("speedo:clickDoor", browser, function()
triggerServerEvent('togLockVehicle', localPlayer, localPlayer)
end)

      addEvent("speedo:clickSpeedoL", true);
addEventHandler("speedo:clickSpeedoL", browser, function()
triggerEvent('realism:togCc', localPlayer)
end)	

      addEvent("speedo:clickWindow", true);
addEventHandler("speedo:clickWindow", browser, function()
triggerServerEvent('vehicle:togWindow', localPlayer)
-- toggleIcon
end)	

      addEvent("speedo:OEginge", true);
addEventHandler("speedo:OEginge", browser, function()
executeBrowserJavascript(browser, "toggleIcon('battery', true)");

-- toggleIcon
end)	

      addEvent("speedo:CEginge", true);
addEventHandler("speedo:CEginge", browser, function()
executeBrowserJavascript(browser, "toggleIcon('battery', false)");

-- toggleIcon
end)	