function fish_prompt
    switch "$fish_key_bindings"
        case fish_hybrid_key_bindings fish_vi_key_bindings
            set STARSHIP_KEYMAP "$fish_bind_mode"
        case '*'
            set STARSHIP_KEYMAP insert
    end
    set STARSHIP_CMD_STATUS $status
    # Account for changes in variable name between v2.7 and v3.0
    set STARSHIP_DURATION "$CMD_DURATION$cmd_duration"
    "/nix/store/n4plkck96hlnvakn18nn9x3xsc7m3r1j-starship-0.55.0/bin/starship" prompt --status=$STARSHIP_CMD_STATUS --keymap=$STARSHIP_KEYMAP --cmd-duration=$STARSHIP_DURATION --jobs=(count (jobs -p))
end
