-- Hyprland (>= 0.57, config em Lua) — réplica do antigo i3 (ver o histórico do git)
-- Mesmos atalhos, modos (resize e saída), bordas de 1px sem gaps e cores Catppuccin.
-- Wiki: https://wiki.hypr.land/configuring/
--
-- Diferenças inevitáveis em relação ao i3:
--   * SUPER+S (stacking) e SUPER+W (tabbed) viram "grupos" do Hyprland (abas)
--   * SUPER+A (focus parent) não existe no Hyprland
--   * SUPER+SHIFT+R (restart do i3) recarrega a config, como SUPER+SHIFT+C

local c = require("mocha")

------------------
---- MONITORES ----
------------------

-- Liste com `hyprctl monitors` e adicione um bloco por monitor se precisar
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = "auto" })

-------------------
---- PROGRAMAS ----
-------------------

local terminal = "kitty"                    -- i3: alacritty
local menu     = "wofi --show run"          -- i3: dmenu_run
local browser  = "waterfox"                 -- i3: qutebrowser

-------------------
---- AUTOSTART ----
-------------------
-- i3: picom (embutido no Hyprland), nm-applet, polybar, feh, xss-lock + i3lock

hl.on("hyprland.start", function()
    hl.exec_cmd("waybar")                   -- polybar
    hl.exec_cmd("hyprpaper")                -- feh --bg-scale ~/background.png
    hl.exec_cmd("hypridle")                 -- xss-lock + i3lock
    -- Dark mode para apps GTK
    hl.exec_cmd("gsettings set org.gnome.desktop.interface gtk-theme 'adw-gtk3-dark'")
    hl.exec_cmd("gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'")
end)

hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "auto")
hl.env("HYPRSHOT_DIR", os.getenv("HOME") .. "/Pictures/Screenshots")

------------------
---- APARÊNCIA ----
------------------
-- i3: `for_window [class="^.*"] border pixel 1`, sem gaps e sem animações;
-- client.focused = mauve, client.unfocused = overlay0

hl.config({
    general = {
        gaps_in     = 0,
        gaps_out    = 0,
        border_size = 1,
        col = {
            active_border   = "rgb(" .. c.mauve .. ")",
            inactive_border = "rgb(" .. c.overlay0 .. ")",
        },
        layout = "dwindle",
    },
    decoration = {
        rounding = 0,
        shadow   = { enabled = false },
        blur     = { enabled = false },
    },
    animations = {
        enabled = false,
    },
    group = {
        col = {
            border_active   = "rgb(" .. c.mauve .. ")",
            border_inactive = "rgb(" .. c.overlay0 .. ")",
        },
        groupbar = {
            font_size    = 11,
            text_color   = "rgb(" .. c.text .. ")",
            col = {
                active   = "rgb(" .. c.mauve .. ")",
                inactive = "rgb(" .. c.base .. ")",
            },
        },
    },
    dwindle = {
        preserve_split = true, -- a orientação escolhida com SUPER+E é mantida (como no i3)
    },
    misc = {
        force_default_wallpaper = 0,
        disable_hyprland_logo   = true,
        disable_splash_rendering = true,
    },
})

---------------
---- INPUT ----
---------------

hl.config({
    input = {
        kb_layout    = "br",     -- i3: setxkbmap -model abnt-2 -layout br
        kb_model     = "abnt2",
        follow_mouse = 1,        -- foco segue o mouse, como no i3
    },
})

-----------------
---- ATALHOS ----
-----------------

local mod = "SUPER" -- i3: set $mod Mod4
local function key(k) return mod .. " + " .. k end

-- bindsym $mod+Return exec alacritty / $mod+d exec dmenu_run / $mod+b exec qutebrowser
hl.bind(key("Return"), hl.dsp.exec_cmd(terminal))
hl.bind(key("D"),      hl.dsp.exec_cmd(menu))
hl.bind(key("B"),      hl.dsp.exec_cmd(browser))

-- bindsym $mod+Shift+q kill
hl.bind(key("SHIFT + Q"), hl.dsp.window.close())

-- Foco e movimento: $mod+hjkl/setas e $mod+Shift+hjkl/setas
local directions = {
    H = "left", J = "down", K = "up", L = "right",
    left = "left", down = "down", up = "up", right = "right",
}
for k, dir in pairs(directions) do
    hl.bind(key(k),               hl.dsp.focus({ direction = dir }))
    hl.bind(key("SHIFT + " .. k), hl.dsp.window.move({ direction = dir }))
end

-- $mod+f fullscreen toggle / $mod+Shift+space floating toggle
hl.bind(key("F"),             hl.dsp.window.fullscreen())
hl.bind(key("SHIFT + space"), hl.dsp.window.float({ action = "toggle" }))

-- $mod+s layout stacking / $mod+w layout tabbed → grupos (abas) do Hyprland
-- $mod+e layout toggle split
hl.bind(key("S"), hl.dsp.group.toggle())
hl.bind(key("W"), hl.dsp.group.toggle())
hl.bind(key("E"), hl.dsp.layout("togglesplit"))

-- Workspaces: $mod+1..0 e $mod+Shift+1..0 (move sem seguir a janela, como no i3)
for i = 1, 10 do
    local k = i % 10
    hl.bind(key(k),               hl.dsp.focus({ workspace = i }))
    hl.bind(key("SHIFT + " .. k), hl.dsp.window.move({ workspace = i, follow = false }))
end

-- $mod+Shift+c reload / $mod+Shift+r restart
hl.bind(key("SHIFT + C"), hl.dsp.reload_config())
hl.bind(key("SHIFT + R"), hl.dsp.reload_config())

-- floating_modifier $mod: arrastar com SUPER + botão esquerdo, redimensionar com o direito
hl.bind(key("mouse:272"), hl.dsp.window.drag(),   { mouse = true })
hl.bind(key("mouse:273"), hl.dsp.window.resize(), { mouse = true })

-- Screenshots: Print (tela inteira) / $mod+Print (área) — i3: gnome-screenshot -i / -a
hl.bind("Print",      hl.dsp.exec_cmd("hyprshot --silent -m output"))
hl.bind(key("Print"), hl.dsp.exec_cmd("hyprshot --silent -m region"))

-- Modo resize ($mod+r): h/←  diminui largura, l/→ aumenta largura,
--                       k/↑  diminui altura,  j/↓ aumenta altura
hl.bind(key("R"), hl.dsp.submap("resize"))
hl.define_submap("resize", function()
    local step = 50
    local sizes = {
        H = { -step, 0 }, left  = { -step, 0 },
        L = { step, 0 },  right = { step, 0 },
        K = { 0, -step }, up    = { 0, -step },
        J = { 0, step },  down  = { 0, step },
    }
    for k, d in pairs(sizes) do
        hl.bind(k, hl.dsp.window.resize({ x = d[1], y = d[2], relative = true }), { repeating = true })
    end
    hl.bind("Return",   hl.dsp.submap("reset"))
    hl.bind("escape",   hl.dsp.submap("reset"))
    hl.bind(key("R"),   hl.dsp.submap("reset"))
end)

-- Modo saída ($mod+Shift+e): (S)uspend, (L)ogout, (R)eboot, (P)oweroff
hl.bind(key("SHIFT + E"), hl.dsp.submap("(S)uspend, (L)ogout, (R)eboot, (P)oweroff"))
hl.define_submap("(S)uspend, (L)ogout, (R)eboot, (P)oweroff", function()
    local actions = {
        S = "systemctl suspend",
        L = "hyprctl dispatch 'hl.dsp.exit()'",
        R = "systemctl reboot",
        P = "systemctl poweroff",
    }
    for k, cmd in pairs(actions) do
        hl.bind(k, function()
            hl.dispatch(hl.dsp.submap("reset"))
            hl.dispatch(hl.dsp.exec_cmd(cmd))
        end)
    end
    hl.bind("Return", hl.dsp.submap("reset"))
    hl.bind("escape", hl.dsp.submap("reset"))
end)

-- Teclas multimídia (i3: pactl ±10% e brightnessctl ±5%)
local media = { locked = true, repeating = true }
hl.bind("XF86AudioRaiseVolume",  hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 10%+"), media)
hl.bind("XF86AudioLowerVolume",  hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 10%-"),      media)
hl.bind("XF86AudioMute",         hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),      { locked = true })
hl.bind("XF86AudioMicMute",      hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),    { locked = true })
hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("brightnessctl set +5%"),                           media)
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl set 5%-"),                           media)

-------------------------
---- REGRAS DE JANELA ----
-------------------------

hl.window_rule({
    name  = "suppress-maximize-events",
    match = { class = ".*" },
    suppress_event = "maximize",
})

hl.window_rule({
    name  = "fix-xwayland-drags",
    match = { class = "^$", title = "^$", xwayland = true, float = true, fullscreen = false, pin = false },
    no_focus = true,
})
