# D11 Theme for WHIP

The look we run on District 11 (D11), as a [WHIP](https://github.com/WHIPFX/whip_core) theme: dark opaque cards, no
glass, italic Quantico titles, pill chips and buttons, blue only as a detail. It redeclares whip_core's tokens
(`html/css/base.css`, the theme contract in whip_core's `docs/nui-theming.md`) and adds one layer per screen, each
scoped to its WHIP panel. Nothing in whip_core changes, so it survives updates: a renamed class only brings that one
detail back to WHIP's base look.

| Layer | What it dresses |
| --- | --- |
| `theme.css` | The tokens: surfaces, borders, radii, text, colours, slots, fonts. Everything WHIP draws picks them up. |
| `css/menus.css` | Titles, dialogs, text on screen and progress bar, objectives, pause menu, character select, death screen, radial menu. |
| `css/inventory.css` | WHIP's own inventory, tooltip and right-click menu, and the quick-access bar. |
| `css/notify.css` | The top-right notifications. |
| `css/creator.css` | The character editor: a column of cards on the left, the chosen piece on a card on the right, 3-per-row photo grid. |

**With [d11_hud](https://github.com/DLady25/whip-d11-hud)**, uncomment its two `@import` lines at the top of
`theme.css` (round minimap under the radar ring, rev dial and status gauges hidden, voice as a circle). They ship
commented out: an `@import` from a resource that is not installed makes whip_core drop the whole theme
("theme.css could not be loaded ... Falling back to the base look"), so the theme works on its own by default.

> Replaces `whip_theme_d12` from the old D11 Starter Kit. Remove that one (and its `whip_d12_hud`) before installing.

## Installation

Put `d11_theme` in your `resources` folder and add, after the `ensure whip_*` lines and **before** `ensure d11_hud`:

```cfg
ensure d11_theme
ensure d11_hud      # optional
```

It sets itself as WHIP's active theme when it starts (`SetActiveTheme`) and stopping it brings WHIP's look back. Only
one theme can be active: if another resource already holds it, the console says which. To use whip_core's
`Config.Theme = 'd11_theme'` instead, add `set d11_theme_runtime 0` to server.cfg.

The server console says `[d11_theme] on` when it is applied.

## Options

- **Keep WHIP's health gauges with d11_hud** (d11_hud's `Status = false`): uncomment only the `whip/hud.css` line in
  `theme.css`.
- **The quick-access bar's label** is CSS text: `--d11-hotbar-title` and `--d11-hotbar-keys` at the top of `theme.css`
  (English by default; the Portuguese is in the comment next to them).
- **Colours**: the tokens in `theme.css`. `--ui-accent` is the blue.
- **Use WHIP's classic HUD skin** with d11_hud (`/whip` → Config → HUD skin): the black skin draws its minimap frame in
  the game itself.

## Requirements

- whip_core 1.0.1 or newer.
- Optional: d11_hud (its HUD layer), d11_inventory (our inventory renderer; this theme dresses WHIP's own inventory).

## License

MIT (see `LICENSE`).

## Credits

- Fonts in `fonts/`: Quantico (Andrea Herstowski) and Geist (Vercel), both under the SIL Open Font License.
- Built on WHIP by Whippy and the WHIP contributors.
