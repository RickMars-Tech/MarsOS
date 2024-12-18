{ ... }: {
   
   security = {

        #==> Apparmor <==#
        /*apparmor = {
            enable = true;
            enableCache = true;
            packages = with pkgs; [
                apparmor-kernel-patches
                roddhjav-apparmor-rules
            ];
            killUnconfinedConfinables = true;
        };*/
        
        #==> Polkit <==#
        polkit = {
            enable = true;
            extraConfig = ''
                polkit.addRule(function(action, subject) {
                    if (
                        subject.isInGroup("users")
                        && (
                            action.id == "org.freedesktop.login1.reboot" ||
                            action.id == "org.freedesktop.login1.reboot-multiple-sessions" ||
                            action.id == "org.freedesktop.login1.power-off" ||
                            action.id == "org.freedesktop.login1.power-off-multiple-sessions"
                        )
                    )
                    {
                        return polkit.Result.YES;
                    }
                })
            '';
        };

        #==> MemorySafe for Sudo <==#
        sudo-rs = {
            enable = true;
            execWheelOnly = true;
            /*extraConfig = ''
                Defaults pwfeedback
                Defaults insults
            '';*/
        };
    };
}
