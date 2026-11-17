# D11 for WHIP 1.2.0: installation

**English** · [Português](#português)

Five packages, made and tested together on a stock **whip_core 1.2.0**:

| Package | Version | What it is |
| --- | --- | --- |
| `whip-d11-inventory` | 2.0.1 | Inventory renderer, bags, weapon attachments, physical trunk and ground |
| `whip-d11-clothing` | 1.1.0 | Clothing stores, clothes as items, our character editor, outfit photos |
| `whip-d11-hud` | 1.1.0 | HUD: status, speedometer, turbo/nitrous, seatbelt, radar, ammo |
| `whip-d11-theme` | 1.1.0 | The D11 look for WHIP's own screens |
| `whip-d11-map` | 1.0.0 | Pause map: places panel, day/night theme, street and district names |

`D11-for-WHIP-1.2.0-all.zip` holds all of them; each one also comes as its own zip. Every package has a `README.md` with
the details. This file is the short path.

## 1. Before you start

- A working WHIP server: **whip_core 1.2.0** as it ships, plus `whip_gunny`, `oxmysql` and WHIP's media packs in
  `[assets]`.
- **Back up `whip_core`** (and `whip_gunny`): copy both folders somewhere outside `resources/`.
- Stop the server.

## 2. Copy the resources

Unzip the package(s). From inside each package folder, copy into your `resources/`:

| From | Copy |
| --- | --- |
| `whip-d11-inventory/` | `[d11-inventory]` |
| `whip-d11-clothing/` | `[d11-clothing]` |
| `whip-d11-hud/` | `d11_hud` |
| `whip-d11-theme/` | `d11_theme` |
| `whip-d11-map/` | `d11_mapnomes` |

Running the old D11 Starter Kit? Remove `whip_theme_d12` and `whip_d12_hud` first.

## 3. Patch whip_core

The patches use the `patch` command. On Windows, run them in **Git Bash** (it comes with Git for Windows). Set `D11`
to where you unzipped the packages, then go to your `resources/` folder. **Keep this order.**

```bash
D11=/c/Users/you/Downloads/D11-for-WHIP-1.2.0-all
cd /path/to/server/resources
```

First, the drag-gestures patch, from **inside** `whip_core/`:

```bash
cd whip_core
patch -p1 < "$D11/whip-d11-inventory/whip_core-patches/whip_core-inventory-drag-gestures-upstream.patch"
cd ..
```

Then the rest, from `resources/`:

```bash
P="$D11/whip-d11-inventory/whip_core-patches"
patch -p1 < "$P/whip_core-ground-panel-d11.patch"
patch -p1 < "$P/whip_core-inventory-noblur-d11.patch"
patch -p1 < "$P/whip_core-inventory-drive-d11.patch"
patch -p1 < "$P/whip_core-hotbar-slots-d11.patch"
patch -p1 < "$P/whip_core-progress-keep-inventory-d11.patch"
patch -p1 < "$P/whip_gunny-mag-load-keep-inventory-d11.patch"
patch -p1 < "$P/whip_core-trunk-opener-d11.patch"
patch -p1 < "$P/whip_core-ground-physics-d11.patch"
patch -p1 < "$P/whip_core-store-panel-d11.patch"
patch -p1 < "$P/whip_core-item-prop-resolver-d11.patch"
patch -p1 < "$P/whip_core-item-prop-amount-d11.patch"
patch -p1 < "$D11/whip-d11-hud/whip_core-patches/whip_core-vehicle-stat-reading-d11.patch"
patch -p1 < "$D11/whip-d11-clothing/whip_core-patches/whip_core-creator-d11.patch"
patch -p1 < "$D11/whip-d11-map/whip_core-patches/whip_core-map-d11.patch"
```

If a patch says `Reversed (or previously applied) patch detected` or a hunk fails, answer **n**, stop, and put your
whip_core backup back before trying again.

> **Do not use** `whip_core-appearance-policy-1.0.1.patch` or `-1.1.x.patch` from the clothing package. They are only
> for whip_core 1.0.1 / 1.1.x. On 1.2.0 they are not needed.

## 4. whip_core/config.lua

Make room in the Equipped strip (6-16 clothes, 17-21 equipment):

```lua
Config.ContainerSlots = { player = 30, accessory = 21 }
Config.MaxWeight      = { player = 80.0, accessory = 25.0 }
```

## 5. server.cfg

After the `ensure whip_*` lines and `ensure [assets]`:

```cfg
setr d11_locale en
ensure d11_theme
ensure d11_hud
ensure d11_inventory
setr whip_inventory_renderer d11_inventory
ensure d11_bags
ensure d11_attachments
ensure d11_ptrunk
setr whip_trunk_opener d11_ptrunk
setr whip_item_prop_resolver d11_ptrunk
ensure d11_clothing
ensure d11_stores
ensure d11_wardrobe
ensure d11_photostudio
ensure d11_mapnomes
```

`d11_inventory` **must** come before `d11_ptrunk`. The theme and the HUD sort themselves out in any order (if d11_hud
starts after d11_theme, it restarts d11_theme once).

## 6. Start and check

Restart the **whole server** (not just one resource: the Equipped strip only grows when whip_core restarts). In the
server console look for:

- `[whip] ... Nothing to fix`
- `[d11_hud] WHIP layer on: carried by d11_theme`
- then run `ptrunkpreflight`: it must report **0 problems**.

No SQL to run on a fresh install: `d11_ptrunk` creates its `d11_ptrunk_*` tables by itself.

## Upgrading the inventory from 1.x

The bag items were renamed in 2.0. With the server **stopped**, run
`whip-d11-inventory/sql/upgrade-1.x-to-2.0.sql` once on your database. A fresh install does not need it.

## Options

- **Language**: `setr d11_locale en` or `setr d11_locale pt-BR` (every D11 resource).
- **The inventory in the world**: `D11Inventory_World` in `d11_inventory/config.lua`. Our defaults: `Blur = false`,
  `Move = true`, `MoveLook = false`, `Trunk = true`, `Ground = true`, `Camera = true`. Flip one to get WHIP's own
  behaviour back. Restart the server after a change.
- **HUD**: `d11_hud/config.lua`. `Status = false` keeps WHIP's own health gauges; `SpeedUnit = 'mph'` or `'kmh'`.
  Use WHIP's **classic** HUD skin (`/whip` → Config → HUD skin).
- **Trunk profiles per car**: `d11_ptrunk/data/profiles` (`base`, `onx`, `nopixel`; the NoPixel ones only load when a
  `*nopixel*` resource is running). Calibrate a car with `/ptrunkwizard start` and share it with `/ptrunkexport`.
- **Clothing stores**: in game at `/whip` → Settings → Clothing stores.
  Pressing a store's prompt shows a notice and opens the editor **3 seconds** later, so the player can stand in the
  open: `Config.OpenDelay` in `d11_stores/config.lua` (0 opens at once).
- **Map theme**: players switch Auto/Day/Night in the map's panel. `setr d11_map_theme_auto_only 1` puts everyone on
  Auto (follows the game clock) and hides the button. Added roads? `/d11mapnomes` in game, then
  `restart d11_mapnomes` (see the map's README).

---

## Português

Cinco pacotes, feitos e testados juntos num **whip_core 1.2.0** de fábrica:

| Pacote | Versão | O que é |
| --- | --- | --- |
| `whip-d11-inventory` | 2.0.1 | Inventário, bolsas, acessórios de arma, porta-malas e chão físicos |
| `whip-d11-clothing` | 1.1.0 | Lojas de roupa, roupas como itens, nosso editor de personagem, fotos do visual |
| `whip-d11-hud` | 1.1.0 | HUD: status, velocímetro, turbo/nitro, cinto, radar, munição |
| `whip-d11-theme` | 1.1.0 | O visual D11 nas telas do próprio WHIP |
| `whip-d11-map` | 1.0.0 | Mapa do pause: painel de locais, tema dia/noite, nomes de ruas e bairros |

O `D11-for-WHIP-1.2.0-all.zip` traz todos; cada um também vem num zip próprio. Cada pacote tem um `README.md` com
os detalhes. Este arquivo é o caminho curto.

## 1. Antes de começar

- Um servidor WHIP funcionando: **whip_core 1.2.0** de fábrica, mais `whip_gunny`, `oxmysql` e os packs de mídia do
  WHIP em `[assets]`.
- **Faça backup do `whip_core`** (e do `whip_gunny`): copie as duas pastas para fora de `resources/`.
- Pare o servidor.

## 2. Copiar os recursos

Descompacte o(s) pacote(s). De dentro de cada pasta de pacote, copie para o seu `resources/`:

| De | Copiar |
| --- | --- |
| `whip-d11-inventory/` | `[d11-inventory]` |
| `whip-d11-clothing/` | `[d11-clothing]` |
| `whip-d11-hud/` | `d11_hud` |
| `whip-d11-theme/` | `d11_theme` |
| `whip-d11-map/` | `d11_mapnomes` |

Usa o antigo D11 Starter Kit? Remova antes o `whip_theme_d12` e o `whip_d12_hud`.

## 3. Aplicar os patches no whip_core

Os patches usam o comando `patch`. No Windows, rode no **Git Bash** (vem com o Git for Windows). Ponha em `D11` a pasta
onde descompactou os pacotes e vá para a pasta `resources/` do servidor. **Mantenha esta ordem.**

```bash
D11=/c/Users/voce/Downloads/D11-for-WHIP-1.2.0-all
cd /caminho/do/servidor/resources
```

Primeiro, o patch de gestos de arrastar, de **dentro** do `whip_core/`:

```bash
cd whip_core
patch -p1 < "$D11/whip-d11-inventory/whip_core-patches/whip_core-inventory-drag-gestures-upstream.patch"
cd ..
```

Depois o resto, a partir de `resources/`:

```bash
P="$D11/whip-d11-inventory/whip_core-patches"
patch -p1 < "$P/whip_core-ground-panel-d11.patch"
patch -p1 < "$P/whip_core-inventory-noblur-d11.patch"
patch -p1 < "$P/whip_core-inventory-drive-d11.patch"
patch -p1 < "$P/whip_core-hotbar-slots-d11.patch"
patch -p1 < "$P/whip_core-progress-keep-inventory-d11.patch"
patch -p1 < "$P/whip_gunny-mag-load-keep-inventory-d11.patch"
patch -p1 < "$P/whip_core-trunk-opener-d11.patch"
patch -p1 < "$P/whip_core-ground-physics-d11.patch"
patch -p1 < "$P/whip_core-store-panel-d11.patch"
patch -p1 < "$P/whip_core-item-prop-resolver-d11.patch"
patch -p1 < "$P/whip_core-item-prop-amount-d11.patch"
patch -p1 < "$D11/whip-d11-hud/whip_core-patches/whip_core-vehicle-stat-reading-d11.patch"
patch -p1 < "$D11/whip-d11-clothing/whip_core-patches/whip_core-creator-d11.patch"
patch -p1 < "$D11/whip-d11-map/whip_core-patches/whip_core-map-d11.patch"
```

Se um patch disser `Reversed (or previously applied) patch detected` ou um trecho falhar, responda **n**, pare e
volte o backup do whip_core antes de tentar de novo.

> **Não use** o `whip_core-appearance-policy-1.0.1.patch` nem o `-1.1.x.patch` do pacote de roupas. Eles são só para
> whip_core 1.0.1 / 1.1.x. No 1.2.0 não são necessários.

## 4. whip_core/config.lua

Abra espaço na faixa de Equipados (6-16 roupas, 17-21 equipamento):

```lua
Config.ContainerSlots = { player = 30, accessory = 21 }
Config.MaxWeight      = { player = 80.0, accessory = 25.0 }
```

## 5. server.cfg

Depois das linhas `ensure whip_*` e do `ensure [assets]`:

```cfg
setr d11_locale pt-BR
ensure d11_theme
ensure d11_hud
ensure d11_inventory
setr whip_inventory_renderer d11_inventory
ensure d11_bags
ensure d11_attachments
ensure d11_ptrunk
setr whip_trunk_opener d11_ptrunk
setr whip_item_prop_resolver d11_ptrunk
ensure d11_clothing
ensure d11_stores
ensure d11_wardrobe
ensure d11_photostudio
ensure d11_mapnomes
```

O `d11_inventory` **tem que** vir antes do `d11_ptrunk`. Tema e HUD se acertam sozinhos em qualquer ordem (se o d11_hud
subir depois do d11_theme, ele reinicia o d11_theme uma vez).

## 6. Subir e conferir

Reinicie o **servidor inteiro** (não só um recurso: a faixa de Equipados só cresce quando o whip_core reinicia). No
console do servidor, procure:

- `[whip] ... Nothing to fix`
- `[d11_hud] WHIP layer on: carried by d11_theme`
- depois rode `ptrunkpreflight`: tem que dar **0 problemas**.

Instalação nova não precisa de SQL: o `d11_ptrunk` cria sozinho as tabelas `d11_ptrunk_*`.

## Atualizando o inventário da 1.x

Os itens de bolsa mudaram de nome na 2.0. Com o servidor **parado**, rode uma vez no banco o
`whip-d11-inventory/sql/upgrade-1.x-to-2.0.sql`. Instalação nova não precisa.

## Opções

- **Idioma**: `setr d11_locale en` ou `setr d11_locale pt-BR` (vale para todos os recursos D11).
- **O inventário no mundo**: `D11Inventory_World` no `d11_inventory/config.lua`. Nosso padrão: `Blur = false`,
  `Move = true`, `MoveLook = false`, `Trunk = true`, `Ground = true`, `Camera = true`. Trocar um valor devolve o
  comportamento do próprio WHIP. Reinicie o servidor depois de mudar.
- **HUD**: `d11_hud/config.lua`. `Status = false` mantém os medidores de vida do WHIP; `SpeedUnit = 'mph'` ou `'kmh'`.
  Use a skin de HUD **classic** do WHIP (`/whip` → Config → HUD skin).
- **Perfis de porta-malas por carro**: `d11_ptrunk/data/profiles` (`base`, `onx`, `nopixel`; os do NoPixel só carregam
  com um recurso `*nopixel*` rodando). Calibre um carro com `/ptrunkwizard start` e compartilhe com `/ptrunkexport`.
- **Lojas de roupa**: no jogo, em `/whip` → Settings → Clothing stores.
  Ao interagir com a loja aparece um aviso e o editor abre **3 segundos** depois, para o jogador se posicionar num
  espaço livre: `Config.OpenDelay` no `d11_stores/config.lua` (0 abre na hora).
- **Tema do mapa**: o jogador troca Auto/Dia/Noite no painel do mapa. `setr d11_map_theme_auto_only 1` deixa todos no
  Auto (segue o relógio do jogo) e some com o botão. Ruas novas? `/d11mapnomes` no jogo, depois
  `restart d11_mapnomes` (ver o README do mapa).
