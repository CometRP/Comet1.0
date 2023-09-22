let showPrompt = false;
let listener;
let openedBait = false;

setImmediate(async () => {
    // const spawnPublicZones = true;
    // const craftingSpots = await exports['comet-base']:FetchComponent("Callback"):CallAsync("comet-inventory:getCraftingSpots");
    // craftingSpots.forEach(spot => {
    //     if (spot.zoneData.options.data.public && !spawnPublicZones) return;
    //     const name = `comet-inventory:crafting:${spot.id}`;
    //     exports["comet-base"].FetchComponent("PolyZone").AddBoxZone(name, spot.zoneData.position, spot.zoneData.length, spot.zoneData.width, spot.zoneData.options);
    // })
})

on("comet-base:polyzone:enter", async (zone, data) => {
    // if (!zone.startsWith("comet-inventory:crafting:")) return;

    // if (data.gangOnly) {
    //     const currentGang = await exports['qb-gangsystem'].GetCurrentGang();

    //     if (!currentGang) return;
    // }

    // listener = setTick(() => {
    //     if (openedBait && data.progression && data.inventories[0].id === "baitinventory") return;
    //     if (!showPrompt) {
    //         exports["qb-interface"].showInteraction(data.prompt);
    //         showPrompt = true;
    //     }
    //     if (IsControlJustPressed(0, data.key)) {
    //         exports["qb-interface"].hideInteraction();
    //         if (data.progression) {
    //             const progression = exports["qb-progression"].GetProgression(data.progression);
    //             let inventory = data.inventories[0];
    //             data.inventories.forEach(inv => {
    //                 if (progression >= inv.progression && inv.progression > inventory.progression) inventory = inv;
    //             });
    //             emit("server-inventory-open", inventory.id, `Crafting:${inventory.id}`);
    //             if (inventory.id == "baitinventory") openedBait = true;
    //         }else {
    //             emit("server-inventory-open", data.inventory, "Craft");
    //         }
    //     }
    // });
});

on("comet-base:polyzone:exit", (zone, data) => {
    // if (!zone.startsWith("comet-inventory:crafting:") || !listener) return;
    // clearTick(listener);
    // listener = null;
    // showPrompt = false;
    // exports["qb-interface"].hideInteraction();
});
