local wezterm = require 'wezterm'
local act = wezterm.action

local process_icons = {
  ['fish']    = '',
  ['bash']    = '',
  ['git']     = '󰊢',
  ['cargo']   = '',
  ['nix']     = '󱄅',
  ['python']  = '',
}

local function get_process_icon(tab)
  local process = tab.active_pane.foreground_process_name
  local name = process:match('([^/]+)$') or process
  return process_icons[name] or '󰆍'
end

wezterm.on('format-tab-title', function(tab, tabs, panes, config, hover, max_width)
  local icon = get_process_icon(tab)
  local is_active = tab.is_active

  local bg = is_active
    and config.resolved_palette.ansi[5]
    or  config.resolved_palette.background

  local fg = is_active
    and config.resolved_palette.background
    or  config.resolved_palette.foreground

  local bar_bg = config.resolved_palette.background

  return {
    { Background = { Color = bar_bg } },
    { Foreground = { Color = bg } },
    { Text = '' },
    { Background = { Color = bg } },
    { Foreground = { Color = fg } },
    { Text = ' ' .. icon .. ' ' },
    { Background = { Color = bar_bg } },
    { Foreground = { Color = bg } },
    { Text = '' },
    { Text = ' ' },
  }
end)

wezterm.on('update-status', function(window)
  local SOLID_LEFT_ARROW = utf8.char(0xe0b2)
  local color_scheme = window:effective_config().resolved_palette
  local bg = color_scheme.background
  local fg = color_scheme.foreground
  window:set_right_status(wezterm.format({
    { Background = { Color = 'none' } },
    { Foreground = { Color = bg } },
    { Text = SOLID_LEFT_ARROW },
    { Background = { Color = bg } },
    { Foreground = { Color = fg } },
    { Text = ' ' .. wezterm.hostname() .. ' ' },
  }))
end)

return {
  check_for_updates = false,
  enable_wayland = true,
  enable_tab_bar = true,
  tab_bar_at_bottom = true,
  use_fancy_tab_bar = false,
  font = wezterm.font("FiraCode Nerd Font Propo"),
  font_size = 11,
  color_scheme = "Noctalia",
  window_background_opacity = 0.90,
  hide_tab_bar_if_only_one_tab = true,
  window_close_confirmation = "NeverPrompt",
  audible_bell = "Disabled",
  keys = {
    -- Tabs
    { key = 'n',   mods = 'ALT',           action = act.SpawnTab 'CurrentPaneDomain' },
    { key = 'q',   mods = 'ALT',           action = act.CloseCurrentTab{ confirm = false } },
    { key = 'w',   mods = 'ALT',           action = act.CloseCurrentPane{ confirm = false } },
    { key = 'h',   mods = 'ALT',           action = act.ActivateTabRelative(-1) },
    { key = 'l',   mods = 'ALT',           action = act.ActivateTabRelative(1) },
    { key = 'Tab', mods = 'ALT|CTRL',      action = act.ActivateTabRelative(1) },
    { key = 'Tab', mods = 'ALT|CTRL|SHIFT',action = act.ActivateTabRelative(-1) },
    { key = '1',   mods = 'ALT',           action = act.ActivateTab(0) },
    { key = '2',   mods = 'ALT',           action = act.ActivateTab(1) },
    { key = '3',   mods = 'ALT',           action = act.ActivateTab(2) },
    { key = '4',   mods = 'ALT',           action = act.ActivateTab(3) },
    { key = '5',   mods = 'ALT',           action = act.ActivateTab(4) },
    { key = '6',   mods = 'ALT',           action = act.ActivateTab(5) },
    { key = '7',   mods = 'ALT',           action = act.ActivateTab(6) },
    { key = '8',   mods = 'ALT',           action = act.ActivateTab(7) },
    { key = '9',   mods = 'ALT',           action = act.ActivateTab(8) },
    -- Paneles (vim style)
    { key = 'h',   mods = 'ALT|CTRL',      action = act.ActivatePaneDirection 'Left' },
    { key = 'l',   mods = 'ALT|CTRL',      action = act.ActivatePaneDirection 'Right' },
    { key = 'k',   mods = 'ALT|CTRL',      action = act.ActivatePaneDirection 'Up' },
    { key = 'j',   mods = 'ALT|CTRL',      action = act.ActivatePaneDirection 'Down' },
    -- Líder
    { key = 't',   mods = 'ALT',           action = act.ActivateKeyTable{
        name = 'tab_pane_mode',
        one_shot = true,
    }},
  },
  key_tables = {
    tab_pane_mode = {
      { key = 't',      mods = 'NONE', action = act.SpawnTab 'CurrentPaneDomain' },
      { key = 'p',      mods = 'NONE', action = act.SplitPane{
          direction = 'Right',
          size = { Percent = 50 },
      }},
      { key = 'Escape', mods = 'NONE', action = act.PopKeyTable },
    },
  },
}
