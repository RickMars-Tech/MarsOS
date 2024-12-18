rule = {
    matches = {
        {
            { "node.name", "equals", "alsa_output.pci-0000_03_00_.6.pro-output-0" },
        },
    },
    apply_properties = {
        ["node.nick"] = "Master",
        ["node.disabled"] = false,
        ["channelmix.normalize"] = true,
        ["monitor.channel-volumes"] = true
    },
}
table.insert(alsa_monitor.rules,rule)
