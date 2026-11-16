fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'd11_theme'
description 'D11 Theme for WHIP: the dark D11 look for WHIP menus, inventory, notifications and character editor; with d11_hud, its HUD layer too.'
author 'District 11 (D11)'
version '1.0.0'
repository 'https://github.com/DLady25/whip-d11-theme'

dependency 'whip_core'
shared_script '@whip_core/lib/satellite.lua'

server_script 'server.lua'

-- whip_core injects https://cfx-nui-<this resource>/theme.css; the rest comes through relative @import/url().
-- Without these files{} it 404s and WHIP falls back to its base look (soft fail, a warning in F8).
files {
    'theme.css',
    'css/*.css',
    'fonts/Geist-Medium.woff2',
    'fonts/Quantico-Bold.ttf',
}

whip_requires '1.0'
