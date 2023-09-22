const CraftingSpots = [
    {
        id: "containerbench",
        zoneData: {
            position: {
                x: 1607.94,
                y: 3776.19,
                z: 34.87
            },
            length: 1.6,
            width: 2.0,
            options: {
                heading: 35,
                minZ: 33.87,
                maxZ: 36.27,
                data: {
                    id: "containerbench",
                    prompt: "[E] Craft",
                    key: 38,
                    inventory: "42085",
                }
            }
        }
    },
];

on("comet-base:exportsReady", () => {
    exports['comet-base'].FetchComponent("Callback").Register("comet-inventory:getCraftingSpots", (source, data, cb) => {
        cb(CraftingSpots);
    })
})

on("comet-inventory:crafting:progression", (pSource, pData) => {
    if (pData.inventory.indexOf("Crafting:") === -1) return;
    const user = exports['comet-base'].FetchComponent("Player").GetUser(pSource);
    const cid = user.getCurrentCharacter().id;

    const invId = pData.inventory.split(":")[1];
    if (!invId) return;

    let foundInv, foundSpot;
    for (const spotQ of CraftingSpots) {
        if (!spotQ.zoneData.options.data.progression) continue;
        const inventoryQ = spotQ.zoneData.options.data.inventories.find(inv => inv.id === invId)
        if (inventoryQ) {
            foundInv = inventoryQ
        }
    }
})