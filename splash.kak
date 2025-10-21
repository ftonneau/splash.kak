# This script fills Kakoune scratch buffers with a logo and help messages.
# Author: François Tonneau

declare-option -docstring 'Splash screen: frame color' str splash_frame rgb:dfdedb

declare-option -docstring 'Splash screen: K body color' str splash_k_body rgb:637486
declare-option -docstring 'Splash screen: K leg color' str splash_k_leg rgb:435a6c

declare-option -docstring 'Splash screen: phonetics foreground' str splash_phon_fg rgb:ffffff
declare-option -docstring 'Splash screen: phonetics background' str splash_phon_bg rgb:b38059

declare-option -docstring 'Splash screen: faded font color' str splash_faded rgb:8a8986

hook -group splash global WinCreate '\*scratch\*' %{

    # Define content and paste it into the buffer.
    evaluate-commands -save-regs %{"} %{
        set-register dquote \
    "





   ┌───────────────────────────────────────────────────────────────────────┐
   │                                                                       │
   │   ███ ◢██◤                                                            │
   │   ███◢██◤                                                             │
   │   █████◤◣                                                             │
   │   ████◤◥█◣ A K O U N E                          /kə'kuːn/             │
   │                                                                       │
   │                                                                       │
   │                                                                       │
   │                                                                       │
   │                                                                       │
   │   Edit this buffer                              %%c                    │
   │   Save on disk                                  :w FILENAME <enter>   │
   │   Open a file                                   :e <space>            │
   │   Read help                                     :doc <space>          │
   │   Quit                                          :q <enter>            │
   │                                                                       │
   └───────────────────────────────────────────────────────────────────────┘


"
        execute-keys <esc><esc> <percent> R
    }

    # Colorize content.
    add-highlighter window/splash group

    add-highlighter window/splash/borders regex "[─│┌┐└┘├┤┬┴┼]" \
        "0:%opt(splash_frame)"

    add-highlighter window/splash/logo_1 regex "███ ◢██◤" \
        "0:%opt(splash_k_body)"
    add-highlighter window/splash/logo_2 regex "███◢██◤" \
        "0:%opt(splash_k_body)"
    add-highlighter window/splash/logo_3 regex "(█████◤)(◣)" \
        "1:%opt(splash_k_body),%opt(splash_k_leg)+g" "2:%opt(splash_k_leg)"
    add-highlighter window/splash/logo_4 regex "(████◤)(◥█◣)" \
        "1:%opt(splash_k_body)" "2:%opt(splash_k_leg)"
    add-highlighter window/splash/logo_5 regex "A K O U N E" \
        0:default,+b

    add-highlighter window/splash/phon regex "/kə'kuːn/" \
        "0:%opt(splash_phon_fg),%opt(splash_phon_bg)+b"

    add-highlighter window/splash/edit regex '^ *│ *(Edit this buffer) + (%c)' \
        "1:%opt(splash_faded)" 2:default,+b "3:%opt(splash_faded)"
    add-highlighter window/splash/save regex '^ *│ *(Save on disk) + (:w) FILENAME (<enter>)' \
        "1:%opt(splash_faded)" 2:default,+b "3:%opt(splash_faded)"
    add-highlighter window/splash/open regex '^ *│ *(Open a file) + (:e) (<space>)' \
        "1:%opt(splash_faded)" 2:default,+b "3:%opt(splash_faded)"
    add-highlighter window/splash/help regex '^ *│ *(Read help) + (:doc) (<space>)' \
        "1:%opt(splash_faded)" 2:default,+b "3:%opt(splash_faded)"
    add-highlighter window/splash/quit regex '^ *│ *(Quit) + (:q) (<enter>)' \
        "1:%opt(splash_faded)" 2:default,+b "3:%opt(splash_faded)"

    # On first window opening, change cursor faces to make them invisible.
    hook -group splash window -once WinDisplay '\*scratch\*' %{
        set-face window PrimaryCursorEol default
        set-face window LineNumberCursor LineNumbers
    }

    # On first key press, do some cleanup and restore cursor faces to their
    # parent (unmodified) values.
    hook -group splash buffer -once NormalKey .* %{
        execute-keys -draft <percent><a-d>
        remove-highlighter window/splash
        set-face window PrimaryCursorEol PrimaryCursorEol
        set-face window LineNumberCursor LineNumberCursor
    }
}

