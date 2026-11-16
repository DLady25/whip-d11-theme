-- Sets this theme live (SetActiveTheme) when it starts; stopping it goes back to whip_core's Config.Theme.
-- Only Config.Theme instead (Config.Theme = 'd11_theme' in whip_core): set d11_theme_runtime 0 in server.cfg.
-- Inside Whip.register (not at file scope) so it is set again after a whip_core restart.
local SELF = GetCurrentResourceName()

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
