rule = {
    matches = {
        {
            { "device.name", "equals", "alsa_card.pci-0000_03_00.6" },
        },
    },
    apply_properties = {
        ["node.description"] = "System",
        ["node.name"] = "System"
    },
}
table.insert(alsa_monitor.rules,rule)
