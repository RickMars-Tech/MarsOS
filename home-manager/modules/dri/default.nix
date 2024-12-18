{ ... }: {
    # Direct Rendering Infrastructure (DRI) Configuration Files apply for all DRI drivers including Mesa and Nouveau.
    # Documentation for these options can be found at https://dri.freedesktop.org/wiki/ConfigurationOptions/.
    home.file.".drirc" = {
        enable = true;
        text = ''
            <driconf>
                <device>
                    <application name="Default">
                        <option name="vblank_mode" value="0" />
                    </application>
                </device>
            </driconf>
        '';
    };

}
