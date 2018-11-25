module Main where

import qualified Data.Map as M
import Graphics.X11.ExtraTypes.XF86

import XMonad
import XMonad.Hooks.ManageDocks
import XMonad.Layout.NoBorders
import XMonad.Layout.Fullscreen
import XMonad.Layout.Tabbed
import XMonad.Layout.Spiral
import XMonad.Layout.ThreeColumns


myKeys conf = let modm = modMask conf in M.fromList
    [ ((modm, xK_p),                  spawn "dmenu_run -fn 'Inconsolata for Powerline-12' -b")
    , ((modm .|. shiftMask, xK_l),    spawn "i3lock -c 000000")
    , ((0, xF86XK_MonBrightnessUp),   spawn "xbacklight +5")
    , ((0, xF86XK_MonBrightnessDown), spawn "xbacklight -5")
    , ((0, xF86XK_AudioMute),         spawn "pamixer -t")
    , ((0, xF86XK_AudioRaiseVolume),  spawn "pamixer -i 5")
    , ((0, xF86XK_AudioLowerVolume),  spawn "pamixer -d 5")
    , ((0, xF86XK_Display),           spawn "multihead")
    ]

myManageHook = composeAll
    [ className =? "Chromium" --> doShift "3"
    , className =? "Firefox Developer Edition" --> doShift "2"
    , className =? "Nightly" --> doShift "2"
    , className =? "Emacs" --> doShift "1"
    ]

myLayout = avoidStruts (
    ThreeColMid 1 (3/100) (1/2) |||
    Tall 1 (3/100) (1/2) |||
    Mirror (Tall 1 (3/100) (1/2)) |||
    tabbed shrinkText tabConfig |||
    Full |||
    spiral (6/7) |||
    noBorders (fullscreenFull Full))

tabConfig = def
           
myConfig = def
  { terminal            = "kitty"
  , modMask             = mod4Mask
  , borderWidth         = 2
  , focusFollowsMouse   = False
  , keys                = \c -> myKeys c `M.union` keys def c
  , manageHook          = myManageHook <+> manageHook def
  , layoutHook          = smartBorders myLayout
  }

main :: IO ()
main = xmonad myConfig

