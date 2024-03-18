# This script fills Kakoune scratch buffers with a logo and help messages.
# Author: Francois Tonneau

declare-option -docstring 'Splash screen: frame color' str splash_frame rgb:dfdedb

declare-option -docstring 'Splash screen: K body color' str splash_k_body rgb:637486
declare-option -docstring 'Splash screen: K leg color' str splash_k_leg rgb:435a6c

declare-option -docstring 'Splash screen: phonetics foreground' str splash_phon_fg rgb:ffffff
declare-option -docstring 'Splash screen: phonetics background' str splash_phon_bg rgb:b38059

declare-option -docstring 'Splash screen: faded font color' str splash_faded rgb:8a8986

hook -group splash global WinCreate '\*scratch\*' %{
    evaluate-commands -save-regs S %{

        # Fill register with content
        set-register S \
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
        # Paste content into buffer
        execute-keys <esc><esc> <percent> <">S R

        # Colorize frame
        add-highlighter window/borders regex "[─│┌┐└┘├┤┬┴┼]" \
            "0:%opt(splash_frame)"

        # Colorize logo
        add-highlighter window/logo_1 regex "███ ◢██◤" \
            "0:%opt(splash_k_body)"
        add-highlighter window/logo_2 regex "███◢██◤" \
            "0:%opt(splash_k_body)"
        add-highlighter window/logo_3 regex "(█████◤)(◣)" \
            "1:%opt(splash_k_body),%opt(splash_k_leg)+g" "2:%opt(splash_k_leg)"
        add-highlighter window/logo_4 regex "(████◤)(◥█◣)" \
            "1:%opt(splash_k_body)" "2:%opt(splash_k_leg)"
        add-highlighter window/logo_5 regex "A K O U N E" \
            0:default,+b

        # Colorize phonetic string
        add-highlighter window/phon regex "/kə'kuːn/" \
            "0:%opt(splash_phon_fg),%opt(splash_phon_bg)+b"

        # Colorize text elements
        add-highlighter window/edit regex '^ *│ *(Edit this buffer) + (%c)' \
            "1:%opt(splash_faded)" 2:default,+b "3:%opt(splash_faded)"
        add-highlighter window/save regex '^ *│ *(Save on disk) + (:w) FILENAME (<enter>)' \
            "1:%opt(splash_faded)" 2:default,+b "3:%opt(splash_faded)"
        add-highlighter window/open regex '^ *│ *(Open a file) + (:e) (<space>)' \
            "1:%opt(splash_faded)" 2:default,+b "3:%opt(splash_faded)"
        add-highlighter window/help regex '^ *│ *(Read help) + (:doc) (<space>)' \
            "1:%opt(splash_faded)" 2:default,+b "3:%opt(splash_faded)"
        add-highlighter window/quit regex '^ *│ *(Quit) + (:q) (<enter>)' \
            "1:%opt(splash_faded)" 2:default,+b "3:%opt(splash_faded)"
    }
}

