-- Sets this theme live (SetActiveTheme) when it starts; stopping it goes back to whip_core's Config.Theme.
-- Only Config.Theme instead (Config.Theme = 'd11_theme' in whip_core): set d11_theme_runtime 0 in server.cfg.
-- Inside Whip.register (not at file scope) so it is set again after a whip_core restart.
local SELF = GetCurrentResourceName()

-- css/d11_hud.css is d11_hud's layer (round minimap, rev dial and WHIP's gauges hidden): d11_hud's export WhipLayerCss
-- while d11_hud runs, empty without it (a layer left behind would keep WHIP's gauges hidden). theme.css always imports
-- this local file, so nothing breaks and nothing is edited by hand, with or without d11_hud.
-- Written only here, as this resource starts: FiveM hands players a resource's files as they were when it started,
-- so a later write would never reach them. When d11_hud starts after us or stops, it restarts this resource.
local HUD, HUD_LAYER = 'd11_hud', 'css/d11_hud.css'
local EMPTY_LAYER = "/* d11_hud's layer inside WHIP's page: written by d11_theme/server.lua as it starts. Do not edit. */\n"

local function hudLayer()
    if GetResourceState(HUD) ~= 'started' then return EMPTY_LAYER end
    local ok, got = pcall(function() return exports[HUD]:WhipLayerCss() end)
    return ok and type(got) == 'string' and got ~= '' and got or EMPTY_LAYER
end

do
    local css = hudLayer()
    if (LoadResourceFile(SELF, HUD_LAYER) or '') ~= css and not SaveResourceFile(SELF, HUD_LAYER, css, -1) then
        print(('^1[d11_theme] could not write %s^0'):format(HUD_LAYER))
    end
    print(('^2[d11_theme] d11_hud layer %s^0'):format(css == EMPTY_LAYER and 'off (d11_hud not running)' or 'on'))
end

Whip.register(function()
    if GetConvarInt('d11_theme_runtime', 1) == 0 then
        print('^2[d11_theme] runtime switch off (d11_theme_runtime 0): whip_core\'s Config.Theme decides^0')
        return
    end
    local ok, err = exports.whip_core:SetActiveTheme(SELF)
    if ok then
        print('^2[d11_theme] on: WHIP\'s active theme^0')
    else
        print(('^1[d11_theme] not applied: %s^0'):format(tostring(err)))
    end
end)

-- Sent again after login: whip_core sends the theme at login, but FiveM's NUI can serve the theme.css cached from the
-- last session; sending it again swaps the <link> and the page fetches it anew.
AddEventHandler('whip_core:player:loaded', function(data)
    local src = type(data) == 'table' and tonumber(data.source)
    if not src then return end
    SetTimeout(2000, function()
        if GetPlayerName(src) and exports.whip_core:GetActiveTheme() == SELF then
            TriggerClientEvent('whip_core:client:applyTheme', src, SELF)
        end
    end)
end)
