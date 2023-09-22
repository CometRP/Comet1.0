let DroppedInventories = [];
let InUseInventories = [];
let DataEntries = 0;
let hasBrought = [];
let CheckedDeginv = [];
const DROPPED_ITEM_KEEP_ALIVE = 1000 * 60 * 15;

function cleanInv() {
    for (let Row in DroppedInventories) {
        if (new Date(DroppedInventories[Row].lastUpdated + DROPPED_ITEM_KEEP_ALIVE).getTime() < Date.now() && DroppedInventories[Row].used && !InUseInventories[DroppedInventories[Row].name]) {
            emitNet("Inventory-Dropped-Remove", -1, [DroppedInventories[Row].name])
            delete DroppedInventories[Row];
        }
    }
}

setInterval(cleanInv, 20000)

RegisterServerEvent("server-request-update")
onNet("server-request-update", async (cid) => {
    let src = source
    let playerInventory = 'ply-' + cid
    let query = `SELECT COUNT(item_id) AS amount, item_id, id, name, information, slot, dropped, quality,  creationDate, MIN(creationDate) AS creationDate FROM user_inventory2 WHERE name = 'ply-${cid}' GROUP BY item_id, slot`;

    exports["oxmysql"].execute(query, {}, function (result) {
        emitNet("inventory-update-player", src, [result, 0, playerInventory]);
    });
});

RegisterServerEvent("server-request-update-src")
onNet("server-request-update-src", async (cid, src) => {
    let playerInventory = 'ply-' + cid
    let query = `SELECT COUNT(item_id) AS amount, item_id, id, name, information, slot, dropped, quality, creationDate, MIN(creationDate) AS creationDate FROM user_inventory2 WHERE name = '${playerInventory}' GROUP BY item_id`;

    exports["oxmysql"].execute(query, {}, function (result) {
        emitNet("inventory-update-player", src, [result, 0, playerInventory]);
    });
});

RegisterServerEvent("server-remove-item")
onNet("server-remove-item", async (cid, itemId, amount, openedInv) => {
    let src = source
    let playerInventory = 'ply-' + cid
    let query = `DELETE FROM user_inventory2 WHERE name = '${playerInventory}' AND item_id = '${itemId}' LIMIT ${amount}`;

    exports["oxmysql"].execute(query, {}, function () {
        emit("server-request-update-src", cid, src)
    });
});

RegisterServerEvent("server-remove-item-slot")
onNet("server-remove-item-slot", async (cid, itemId, amount, slotId) => {
    let src = source
    let playerInventory = 'ply-' + cid
    let query = `DELETE FROM user_inventory2 WHERE name = '${playerInventory}' and item_id = '${itemId}' and slot = '${slotId}' LIMIT ${amount}`

    exports["oxmysql"].execute(query, {}, function () {
        emit("server-request-update-src", cid, src)
    })
})

RegisterServerEvent("server-remove-item-kv")
onNet("server-remove-item-kv", async (cid, itemId, amount, metaKey, metaValue) => {
    let src = source
    let playerInventory = 'ply-' + cid
    let query = `DELETE FROM user_inventory2 WHERE name = '${playerInventory}' and item_id = '${itemId}' AND (information LIKE '${metaKey}' OR information LIKE '${metaValue}') LIMIT ${amount}`;

    exports["oxmysql"].execute(query, {}, function () {
        emit("server-request-update-src", cid, src)
    });
});

RegisterServerEvent("server-remove-item-multiple-kv")
onNet("server-remove-item-multiple-kv", async (cid, itemId, amount, kvs, checkQuality) => {
    let src = source
    let playerInventory = 'ply-' + cid
    let query = `DELETE FROM user_inventory2 WHERE name = '${playerInventory}' AND item_id = '${itemId}' AND (information LIKE '${kvs}') AND quality = '${checkQuality}' LIMIT ${amount}`;

    exports["oxmysql"].execute(query, {}, function () {
        emit("server-request-update-src", cid, src)
    });
});

RegisterServerEvent("server-update-item")
onNet("server-update-item", async (cid, itemId, slotId, pData) => {
    let src = source
    let playerInventory = 'ply-' + cid
    let query = `UPDATE user_inventory2 SET information = '${pData}' WHERE item_id = '${itemId}' AND name = '${playerInventory}' AND slot = '${slotId}'`

    exports["oxmysql"].execute(query, {}, function () {
        emit("server-request-update-src", cid, src)
    });
});

RegisterServerEvent("server-inventory-open")
onNet("server-inventory-open", async (playerPos, cid, secondInventory, targetName, itemToDropArray, vehWeightCalc, invWeight, invSlot) => {
    let src = source
    let playerInventory = 'ply-' + cid

    if (InUseInventories[targetName] || InUseInventories[playerInventory]) {

        if (InUseInventories[playerInventory]) {
            if ((InUseInventories[playerInventory] != cid)) {
                return
            } else {

            }
        }
        if (InUseInventories[targetName]) {
            if (InUseInventories[targetName] == cid) {

            } else {
                secondInventory = "69"
            }
        }
    }

    let query = `SELECT COUNT(item_id) AS amount, id, name, item_id, information, slot, dropped, quality, creationDate FROM user_inventory2 WHERE name = 'ply-${cid}' GROUP BY slot`;

    exports["oxmysql"].execute(query, {}, function (result) {
        var invArray = result;
        var arrayCount = 0;

        InUseInventories[playerInventory] = cid;

        if (secondInventory == "1") {
            var targetInventory = targetName
            let query = `SELECT COUNT(item_id) AS amount, id, name, item_id, information, slot, dropped, quality, creationDate FROM user_inventory2 WHERE name = '${targetInventory}' GROUP BY slot`;

            exports["oxmysql"].execute(query, {}, function (inventory) {
                emitNet("inventory-open-target", src, [invArray, arrayCount, playerInventory, inventory, 0, targetInventory, 500, true, invWeight, invSlot]);
                InUseInventories[targetInventory] = cid
            });
        }
        else if (secondInventory == "3") {
            let Key = "" + DataEntries + "";
            let NewDroppedName = 'Drop-' + Key;
            DataEntries = DataEntries + 1

            var invArrayTarget = [];

            DroppedInventories[NewDroppedName] = {
                position: {
                    x: playerPos[0],
                    y: playerPos[1],
                    z: playerPos[2]
                },
                name: NewDroppedName,
                used: false,
                lastUpdated: Date.now()
            }

            InUseInventories[NewDroppedName] = cid;

            invArrayTarget = JSON.stringify(invArrayTarget)
            emitNet("inventory-open-target", src, [invArray, arrayCount, playerInventory, invArrayTarget, 0, NewDroppedName, 500, false]);
        }
        else if (secondInventory == "13") {
            let Key = "" + DataEntries + "";
            let NewDroppedName = 'Drop-' + Key;
            DataEntries = DataEntries + 1

            for (let Key in itemToDropArray) {
                for (let i = 0; i < itemToDropArray[Key].length; i++) {
                    let objectToDrop = itemToDropArray[Key][i];
                    exports["oxmysql"].execute(`UPDATE user_inventory2 SET slot = '${i + 1}', name = '${NewDroppedName}', dropped = '1' WHERE name = '${Key}' AND slot = '${objectToDrop.faultySlot}' AND item_id = '${objectToDrop.faultyItem}' `);
                }
            }

            DroppedInventories[NewDroppedName] = {
                position: {
                    x: playerPos[0],
                    y: playerPos[1],
                    z: playerPos[2]
                },
                name: NewDroppedName,
                used: false,
                lastUpdated: Date.now()
            }

            emitNet("Inventory-Dropped-Addition", -1, DroppedInventories[NewDroppedName])
        }
        else if (secondInventory == "42069") {
            let Key = "" + DataEntries + "";
            let NewDroppedName = "Drop-Overweight" + Key;
            DataEntries = DataEntries + 1;

            for (let Key in itemToDropArray) {
                for (let i = 0; i < itemToDropArray[Key].length; i++) {
                    let objectToDrop = itemToDropArray[Key][i];
                    let amount = Number(objectToDrop.amount)
                    let creationDate = Date.now()

                    for (let step = 0; step < amount; step++) {
                        exports["oxmysql"].execute(`INSERT INTO user_inventory2 (item_id, name, slot, dropped, creationDate) VALUES ('${objectToDrop.itemid}', '${NewDroppedName}', '${objectToDrop.slot}', '1', '${creationDate}' );`);
                    }
                }
            }

            DroppedInventories[NewDroppedName] = {
                position: {
                    x: playerPos[0],
                    y: playerPos[1],
                    z: playerPos[2]
                },
                name: NewDroppedName,
                used: true,
                lastUpdated: Date.now()
            }

            emitNet("Inventory-Dropped-Addition", -1, DroppedInventories[NewDroppedName])
        }
        else if (secondInventory == "2") {
            var targetInventory = targetName;
            var shopArray = ConvenienceStore();
            var shopAmount = 20;
            emitNet("inventory-open-target", src, [invArray, arrayCount, playerInventory, shopArray, shopAmount, targetInventory, 500, false]);
        }
        else if (secondInventory == "4") {
            var targetInventory = targetName;
            var shopArray = HardwareStore();
            var shopAmount = 43;
            emitNet("inventory-open-target", src, [invArray, arrayCount, playerInventory, shopArray, shopAmount, targetInventory, 500, false]);
        }
        else if (secondInventory == "5") {
            var targetInventory = targetName;
            var shopArray = GunStore();
            var shopAmount = 8;
            emitNet("inventory-open-target", src, [invArray, arrayCount, playerInventory, shopArray, shopAmount, targetInventory, 500, false]);
        }
        else if (secondInventory == "10") {
            var targetInventory = targetName;
            var shopArray = PoliceArmory();
            var shopAmount = 41;
            emitNet("inventory-open-target", src, [invArray, arrayCount, playerInventory, shopArray, shopAmount, targetInventory, 500, false]);
        }
        else if (secondInventory == "15") {
            var targetInventory = targetName;
            var shopArray = EMT();
            var shopAmount = 13;
            emitNet("inventory-open-target", src, [invArray, arrayCount, playerInventory, shopArray, shopAmount, targetInventory, 500, false]);
        }
        else if (secondInventory == "14") {
            var targetInventory = targetName;
            var shopArray = courthouse();
            var shopAmount = 1;
            emitNet("inventory-open-target", src, [invArray, arrayCount, playerInventory, shopArray, shopAmount, targetInventory, 500, false]);
        }
        else if (secondInventory == "18") {
            var targetInventory = targetName;
            var shopArray = TacoTruck();
            var shopAmount = 14;
            emitNet("inventory-open-target", src, [invArray, arrayCount, playerInventory, shopArray, shopAmount, targetInventory, 500, false]);
        }
        else if (secondInventory == "22") {
            var targetInventory = targetName;
            var shopArray = JailFood();
            var shopAmount = 1;
            emitNet("inventory-open-target", src, [invArray, arrayCount, playerInventory, shopArray, shopAmount, targetInventory, 500, false]);
        }
        else if (secondInventory == "25") {
            var targetInventory = targetName;
            var shopArray = JailMeth();
            var shopAmount = 1;
            emitNet("inventory-open-target", src, [invArray, arrayCount, playerInventory, shopArray, shopAmount, targetInventory, 500, false]);
        }
        else if (secondInventory == "12") {
            var targetInventory = targetName;
            var shopArray = burgiestore();
            var shopAmount = 8;
            emitNet("inventory-open-target", src, [invArray, arrayCount, playerInventory, shopArray, shopAmount, targetInventory, 500, false]);
        }
        else if (secondInventory == "600") {
            var targetInventory = targetName;
            var shopArray = policeveding();
            var shopAmount = 9;
            emitNet("inventory-open-target", src, [invArray, arrayCount, playerInventory, shopArray, shopAmount, targetInventory, 500, false]);
        }

        else if (secondInventory == "27") {
            var targetInventory = targetName;
            var shopArray = Mechanic();
            var shopAmount = 6;
            emitNet("inventory-open-target", src, [invArray, arrayCount, playerInventory, shopArray, shopAmount, targetInventory, 500, false]);
        }
        else if (secondInventory == "141") {
            var targetInventory = targetName;
            var shopArray = recycle();
            var shopAmount = 8;
            emitNet("inventory-open-target", src, [invArray, arrayCount, playerInventory, shopArray, shopAmount, targetInventory, 500, false]);
        }
        else if (secondInventory == "998") {
            var targetInventory = targetName;
            var shopArray = JailSlushy();
            var shopAmount = 1;
            emitNet("inventory-open-target", src, [invArray, arrayCount, playerInventory, shopArray, shopAmount, targetInventory, 500, false]);
        }
        else if (secondInventory == "921") {
            var targetInventory = targetName;
            var shopArray = asslockpick();
            var shopAmount = 1;
            emitNet("inventory-open-target", src, [invArray, arrayCount, playerInventory, shopArray, shopAmount, targetInventory, 500, false]);
        }

        else if (secondInventory == "26") {
            var targetInventory = targetName;
            var shopArray = assphone();
            var shopAmount = 1;
            emitNet("inventory-open-target", src, [invArray, arrayCount, playerInventory, shopArray, shopAmount, targetInventory, 500, false]);
        }
        else if (secondInventory == "42103") {
            var targetInventory = targetName;
            var shopArray = irongog();
            var shopAmount = 52;
            emitNet("inventory-open-target", src, [invArray, arrayCount, playerInventory, shopArray, shopAmount, targetInventory, 500, false]);
        }
        else if (secondInventory == "714") {
            var targetInventory = targetName;
            var shopArray = smelter();
            var shopAmount = 1;
            emitNet("inventory-open-target", src, [invArray, arrayCount, playerInventory, shopArray, shopAmount, targetInventory, 500, false]);
        }
        else if (secondInventory == "997") {
            var targetInventory = targetName;
            var shopArray = prison();
            var shopAmount = 7;
            emitNet("inventory-open-target", src, [invArray, arrayCount, playerInventory, shopArray, shopAmount, targetInventory, 500, false]);
        }
        else if (secondInventory == "42087") {
            var targetInventory = targetName;
            var shopArray = craftChains();
            var shopAmount = 12;
            emitNet("inventory-open-target", src, [invArray, arrayCount, playerInventory, shopArray, shopAmount, targetInventory, 500, false]);
        }
        else if (secondInventory == "31") {
            var targetInventory = targetName;
            var shopArray = craftDrink();
            var shopAmount = 21;
            emitNet("inventory-open-target", src, [invArray, arrayCount, playerInventory, shopArray, shopAmount, targetInventory, 500, false]);
        }
        else if (secondInventory == "42071") {
            var targetInventory = targetName;
            var shopArray = craftRoosters();
            var shopAmount = 6;
            emitNet("inventory-open-target", src, [invArray, arrayCount, playerInventory, shopArray, shopAmount, targetInventory, 500, false]);
        }
        else if (secondInventory == "7") {
            var targetInventory = targetName;
            var shopArray = DroppedItem(itemToDropArray);

            itemToDropArray = JSON.parse(itemToDropArray)
            var shopAmount = itemToDropArray.length;

            emitNet("inventory-open-target", src, [invArray, arrayCount, playerInventory, shopArray, shopAmount, targetInventory, 500, false]);
        }
        else {
            emitNet("inventory-update-player", src, [invArray, arrayCount, playerInventory]);
        }
    });
});

RegisterServerEvent("server-inventory-close")
onNet("server-inventory-close", async (cid, targetInventory) => {
    let src = source

    emitNet("toggle-animation", src, false);

    InUseInventories = InUseInventories.filter(item => item != cid);

    if (targetInventory.indexOf("Drop") > -1 && DroppedInventories[targetInventory]) {
        if (DroppedInventories[targetInventory].used === false) {
            delete DroppedInventories[targetInventory];
        } else {
            let query = `SELECT COUNT(item_id) AS amount, item_id, name, information, slot, dropped, quality, creationDate FROM user_inventory2 WHERE name = '${targetInventory}' group by item_id `;

            exports["oxmysql"].execute(query, {}, function (result) {
                if (result.length == 0 && DroppedInventories[targetInventory]) {
                    delete DroppedInventories[targetInventory];
                    emitNet("Inventory-Dropped-Remove", -1, [targetInventory])
                }
            });
        }
    }

    emit("server-request-update-src", cid, src)
});

RegisterServerEvent("server-inventory-stack")
onNet("server-inventory-stack", async (cid, pData, playerPos) => {
    let src = source

    let targetSlot = pData[0]
    let moveAmount = pData[1]
    let targetInventory = pData[2].replace(/"/g, "");
    let originSlot = pData[3]
    let originInventory = pData[4].replace(/"/g, "");
    let isPurchase = pData[5]
    let itemCosts = pData[6]
    let itemId = pData[7]
    let metaInformation = pData[8]

    let amount = pData[9]
    let isCraft = pData[10]
    let isWeapon = pData[11]
    let PlayerStore = pData[12]
    let amountRemaining = pData[13]

    let creationDate = Date.now()

    if ((targetInventory.indexOf("Drop") > -1 || targetInventory.indexOf("hidden") > -1) && DroppedInventories[targetInventory]) {
        if (DroppedInventories[targetInventory].used === false) {
            DroppedInventories[targetInventory] = {
                position: {
                    x: playerPos[0],
                    y: playerPos[1],
                    z: playerPos[2]
                },
                name: targetInventory,
                used: true,
                lastUpdated: Date.now()
            }

            emitNet("Inventory-Dropped-Addition", -1, DroppedInventories[targetInventory])
        }
    }

    if (isPurchase) {
        metaInformation = await GenerateInformation(cid, itemId)
        removeCash(src, itemCosts)

        if (isWeapon) {
            //exports["oxmysql"].execute(`INSERT INTO user_inventory2 (item_id, name, information, slot, creationDate) VALUES ('${itemId}','${targetInventory}','${metaInformation}','${targetSlot}','${creationDate}' );`);
        }

        if (!PlayerStore) {
            for (let i = 0; i < parseInt(amount); i++) {
                exports["oxmysql"].execute(`INSERT INTO user_inventory2 (item_id, name, information, slot, creationDate) VALUES ('${itemId}','${targetInventory}','${metaInformation}','${targetSlot}','${creationDate}' );`);
            }
        }

        if (PlayerStore) {
            exports["oxmysql"].execute(`UPDATE user_inventory2 SET slot = '${targetSlot}', name = '${targetInventory}', dropped = '0' WHERE slot = '${originSlot}' AND name = '${originInventory}'`);
        }

    } else if (isCraft) {
        metaInformation = await GenerateInformation(cid, itemId)

        for (let i = 0; i < parseInt(amount); i++) {
            exports["oxmysql"].execute(`INSERT INTO user_inventory2 (item_id, name, information, slot, creationDate) VALUES ('${itemId}','${targetInventory}','${metaInformation}','${targetSlot}','${creationDate}' );`);
        }

    } else {
        let query = `SELECT item_id, id FROM user_inventory2 WHERE slot='${originSlot}' and name='${originInventory}' LIMIT ${moveAmount}`;

        exports["oxmysql"].execute(query, {}, function (result) {
            var itemIds = "0"

            for (let i = 0; i < result.length; i++) {
                itemIds = itemIds + "," + result[i].id
            }

            if (targetInventory.indexOf("Drop") > -1 || targetInventory.indexOf("hidden") > -1) {
                exports["oxmysql"].execute(`UPDATE user_inventory2 SET slot='${targetSlot}', name='${targetInventory}', dropped='1' WHERE id IN (${itemIds})`);

            } else {
                exports["oxmysql"].execute(`UPDATE user_inventory2 SET slot='${targetSlot}', name='${targetInventory}', dropped='0' WHERE id IN (${itemIds})`);
            }
        });
    }
});

RegisterServerEvent("server-inventory-move")
onNet("server-inventory-move", async (cid, pData, playerPos) => {
    let src = source

    let targetSlot = pData[0]
    let originSlot = pData[1]
    let targetInventory = pData[2].replace(/"/g, "");
    let originInventory = pData[3].replace(/"/g, "");
    let isPurchase = pData[4]
    let itemCosts = pData[5]
    let itemId = pData[6]
    let metaInformation = pData[7]
    let amount = pData[8]
    let isCraft = pData[9]
    let isWeapon = pData[10]
    let PlayerStore = pData[11]

    let creationDate = Date.now()

    if ((targetInventory.indexOf("Drop") > -1 || targetInventory.indexOf("hidden") > -1) && DroppedInventories[targetInventory]) {
        if (DroppedInventories[targetInventory].used === false) {

            DroppedInventories[targetInventory] = {
                position: {
                    x: playerPos[0],
                    y: playerPos[1],
                    z: playerPos[2]
                },
                name: targetInventory,
                used: true,
                lastUpdated: Date.now()
            }
            emitNet("Inventory-Dropped-Addition", -1, DroppedInventories[targetInventory])
        }
    }

    if (isPurchase) {
        metaInformation = await GenerateInformation(cid, itemId)
        removeCash(src, itemCosts)

        if (isWeapon) {
            hadBrought[cid] = true;
            emitNet("Inventory-brought-update", -1, JSON.stringify(Object.assign({}, hadBrought)));
        }

        if (!PlayerStore) {
            for (let i = 0; i < parseInt(amount); i++) {
                exports["oxmysql"].execute(`INSERT INTO user_inventory2 (item_id, name, information, slot, creationDate) VALUES ('${itemId}','${targetInventory}','${metaInformation}','${targetSlot}','${creationDate}' );`);
            }

        } else if (isCraft) {
            metaInformation = await GenerateInformation(cid, itemId)

            for (let i = 0; i < parseInt(amount); i++) {
                exports["oxmysql"].execute(`INSERT INTO user_inventory2 (item_id, name, information, slot, creationDate) VALUES ('${itemId}','${targetInventory}','${metaInformation}','${targetSlot}','${creationDate}' );`);
            }

        } else {
            if (targetInventory.indexOf("Drop") > -1 || targetInventory.indexOf("hidden") > -1) {
                exports["oxmysql"].execute(`INSERT INTO user_inventory2 SET slot = '${targetSlot}', name = '${targetInventory}', dropped = '1' WHERE slot = '${originSlot}' AND name = '${originInventory}'`);
            } else {
                exports["oxmysql"].execute(`UPDATE user_inventory2 SET slot = '${targetSlot}', name = '${targetInventory}', dropped = '0' WHERE slot = '${originSlot}' AND name = '${originInventory}'`);
            }
        }
    } else {
        if (isCraft == true) {
            metaInformation = await GenerateInformation(cid, itemId)

            for (let i = 0; i < parseInt(amount); i++) {
                exports["oxmysql"].execute(`INSERT INTO user_inventory2 (item_id, name, information, slot, creationDate) VALUES ('${itemId}','${targetInventory}','${metaInformation}','${targetSlot}','${creationDate}' );`);
            }
        }

        exports["oxmysql"].execute(`UPDATE user_inventory2 SET slot = '${targetSlot}', name = '${targetInventory}', dropped = '0' WHERE slot = '${originSlot}' AND name = '${originInventory}'`);
    }
});

RegisterServerEvent("server-inventory-swap")
onNet("server-inventory-swap", async (cid, pData, playerPos) => {
    let targetSlot = pData[0]
    let targetInventory = pData[1].replace(/"/g, "");
    let originSlot = pData[2]
    let originInventory = pData[3].replace(/"/g, "");

    let query = `SELECT id FROM user_inventory2 WHERE slot = '${targetSlot}' AND name = '${targetInventory}'`;

    exports["oxmysql"].execute(query, {}, function (result) {
        var itemIds = "0"

        for (let i = 0; i < result.length; i++) {
            itemIds = itemIds + "," + result[i].id
        }

        let query = false;

        if (targetInventory.indexOf("Drop") > -1 || targetInventory.indexOf("hidden") > -1) {
            query = `UPDATE user_inventory2 SET slot = '${targetSlot}', name = '${targetInventory}', dropped = '1' WHERE slot = '${originSlot}' AND name = '${originInventory}'`;
        } else {
            query = `UPDATE user_inventory2 SET slot = '${targetSlot}', name = '${targetInventory}', dropped = '0' WHERE slot = '${originSlot}' AND name = '${originInventory}'`;
        }

        exports["oxmysql"].execute(query, {}, function (inventory) {
            if (originInventory.indexOf("Drop") > -1 || originInventory.indexOf("hidden") > -1) {
                exports["oxmysql"].execute(`UPDATE user_inventory2 SET slot = '${originSlot}', name = '${originInventory}', dropped = '1' WHERE id IN (${itemIds})`);
            } else {
                exports["oxmysql"].execute(`UPDATE user_inventory2 SET slot = '${originSlot}', name = '${originInventory}', dropped = '0' WHERE id IN (${itemIds})`);
            }
        });
    });
});

RegisterServerEvent("server-inventory-remove-any")
onNet("server-inventory-remove-any", async (itemId, amount) => {
    let src = source
    let Player = exports['comet-base'].FetchComponent("Player").GetBySource(src)
    let cid = Player.PlayerData.cid
    let playerInventory = 'ply-' + cid

    exports["oxmysql"].execute(`DELETE FROM user_inventory2 WHERE name = '${playerInventory}' AND item_id = '${itemId}' LIMIT ${amount}`, {}, function () {
        emit("server-request-update-src", cid, src)
    })
})

RegisterServerEvent("server-inventory-remove-slot")
onNet("server-inventory-remove-slot", async (itemId, amount, slotId) => {
    let src = source
    let Player = exports['comet-base'].FetchComponent("Player").GetBySource(src)
    let cid = Player.PlayerData.cid
    let playerInventory = 'ply-' + cid

    exports["oxmysql"].execute(`DELETE FROM user_inventory2 WHERE name = '${playerInventory}' AND item_id = '${itemId}' AND slot = '${slotId}' LIMIT ${amount}`, {}, function () {
        emit("server-request-update-src", cid, src)
    })
})

RegisterServerEvent("server-inventory-give")
onNet("server-inventory-give", async (cid, itemId, slotId, amount, generateInformation, itemData, openedInv, returnData) => {
    let src = source
    let playerInventory = 'ply-' + cid
    let creationDate = Date.now()

    let itemInfo = "{}"

    if (itemId == "idcard") {
        itemInfo = await GenerateInformation(cid, itemId, itemData)
    }

    if (itemId == "evidence" || itemId == "np_evidence_marker_yellow" || itemId == "np_evidence_marker_red" || itemId == "np_evidence_marker_white" || itemId == "np_marker_evidence_marker_orange" || itemId == "np_marker_evidence_marker_light_blue" || itemId == "np_marker_evidence_marker_light_purple") {
        itemInfo = JSON.stringify(itemData);
    }

    if (itemId == "rentalpapers") {
        itemInfo = await GenerateInformation(cid, itemId, itemData)
    }

    if (itemId == "customtoyitem") {
        itemInfo = await GenerateInformation(cid, itemId, itemData)
    }

    if (itemId == "smallbud") {
        itemInfo = await GenerateInformation(cid, itemId, itemData)
    }
    if (itemId == 'weedpackage' || itemId == "weedbaggie") {
        itemInfo = await GenerateInformation(cid, itemId, itemData)
    }
    if (itemId == 'wetbud') {
        itemInfo = returnData;
    }
    if (itemId == 'heiststarttoken') {
        itemInfo = returnData;
    }

    if (itemId == 'spraycan') {
        itemInfo = returnData;
    }

    if (itemId == 'notepadnote') {
        itemInfo = returnData;
    }

    if (itemId == 'femaleseed') {
        itemInfo = returnData;
    }

    if (itemId == "bowlingreceipt") {
        itemInfo = await GenerateInformation(cid, itemId, itemData)
    }

    if (itemId == "craterepairkit") {
        itemInfo = await GenerateInformation(cid, itemId, itemData)
    }

    if (itemId == "drone_lspd" || itemId == "drone_civ" || itemId == "rc_car_civ") {
        itemInfo = await GenerateInformation(cid, itemId, itemData)
    }

    if (itemId == "-2084633992" || itemId == "1593441988" || itemId == "-1716589765") {
        itemInfo = await GenerateInformation(cid, itemId, itemData)
    }

    if (itemId == "resfooditem" || itemId == "ressideitem" || itemId == "resdessertitem" || itemId == "resdrinkitem") {
        itemInfo = await GenerateInformation(cid, itemId, itemData)
    }

    if (itemId == "tcgpromobooster") {
        itemInfo = await GenerateInformation(cid, itemId, itemData)
    }

    if (itemId == "heistlaptop1" || itemId == "heistlaptop2" || itemId == "heistlaptop3" || itemId == "heistlaptop4") {
        itemInfo = returnData;
    }

    if (itemId == "burgershotbag" || itemId == "murdermeal" || itemId == "wrappedgift" || itemId == "casinobag"
        || itemId == "bentobox" || itemId == "pizzabox" || itemId == "roostertakeout" || itemId == "cockbox"
        || itemId == "racingusb2"
        || itemId == "heistduffelbag" || itemId == "lostcut2" || itemId == "vineyardwinebox" || itemId == "custombagitem" || itemId == "casinomember") {
        itemInfo = returnData;
    }

    let values = `('${playerInventory}','${itemId}','${itemInfo}','${slotId}','${creationDate}')`

    if (amount > 1) {
        for (let i = 2; i <= amount; i++) {
            values = values + `,('${playerInventory}','${itemId}','${itemInfo}','${slotId}','${creationDate}')`
        }
    }

    let query = `INSERT INTO user_inventory2 (name, item_id, information, slot, creationDate) VALUES ${values};`

    exports["oxmysql"].execute(query, {}, function () {
        emit("server-request-update-src", cid, src)
    });
});

// RegisterServerEvent("server-inventory-refresh")
// onNet("server-inventory-refresh", async (cid) => {
//     let src = source
//     let query = `SELECT COUNT(item_id) AS amount, id, name, item_id, information, slot, dropped, quality, creationDate FROM user_inventory2 WHERE name = 'ply-${cid}' GROUP BY slot`;

//     exports["oxmysql"].execute(query, {}, function (result) {
//         if (!result) { } else {
//             let invArray = result;
//             let arrayCount = 0;
//             let playerInventory = cid

//             emitNet("inventory-update-player", src, [invArray, arrayCount, playerInventory]);
//         }
//     })
// })

RegisterServerEvent('server-jail-items')
onNet("server-jail-items", async (cid, isSentToJail) => {
    let playerInventory = 'ply-' + cid
    let currInventoryName = `${playerInventory}`
    let newInventoryName = `${playerInventory}`

    if (isSentToJail) {
        currInventoryName = `jail-${cid}`
        newInventoryName = `${playerInventory}`
    } else {
        currInventoryName = `${playerInventory}`
        newInventoryName = `jail-${cid}`
    }

    exports["oxmysql"].execute(`UPDATE user_inventory2 SET name = '${currInventoryName}' WHERE name = '${newInventoryName}' AND dropped = 0`);
});

RegisterServerEvent("inventory:degItem")
onNet("inventory:degItem", async (LastUsedItem, percent, LastUsedItemId, cid) => {
    let playerInventory = 'ply-' + cid
    let amount = percent * 100000000 / 2;

    exports["oxmysql"].execute(`UPDATE user_inventory2 SET creationDate = creationDate - ${amount} WHERE id = ${LastUsedItem} AND item_id = '${LastUsedItemId}' AND name = '${playerInventory}'`);
});

function makeId(length) {
    var result = '';
    var characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghikjlmnopqrstuvwxyz'; //abcdef
    var charactersLength = characters.length;

    for (var i = 0; i < length; i++) {
        result += characters.charAt(Math.floor(Math.random() * charactersLength));
    }

    return result;
}

function GenerateInformation(cid, itemId, itemData, returnData = '{}') {
    let rData = Object.assign({}, itemData);
    let returnInfo = returnData;
    let randomId = Math.floor(Math.random() * 9999999) + 100000;

    return new Promise((resolve, reject) => {
        if (itemId == '') return resolve(returnInfo);

        let timeOut = 0;
        if (!isNaN(itemId)) {
            var serialNumber = cid.toString()

            if (itemData && itemData.fakeWeaponData) {
                serialNumber = Math.floor((Math.random() * 99999) + 1)
                serialNumber = serialNumber.toString()
            }

            if (itemList[itemId].weapon == true) {
                let cartridgeCreated = cid + "-" + makeId(3) + "-" + Math.floor(Math.random() * 999 + 1);
                returnInfo = JSON.stringify({
                    cartridge: cartridgeCreated,
                    serial: serialNumber,
                    quality: "Good"
                })
            }

            timeOut = 1;
            clearTimeout(timeOut)
            return resolve(returnInfo);

        } else if (Object.prototype.toString.call(itemId) === '[object String]') { // Check if itemid is a string
            switch (
            itemId.toLowerCase()
            ) {
                case "idcard":
                    // if (itemData && itemData.fake) {
                    //     returnInfo = JSON.stringify({
                    //         Identifier: itemData.charID,
                    //         Name: itemData.first.replace(/[^\w\s]/gi, ''),
                    //         Surname: itemData.last.replace(/[^\w\s]/gi, ''),
                    //         Sex: itemData.sex,
                    //         DOB: itemData.dob
                    //     });

                    //     timeOut = 1
                    //     clearTimeout(timeOut);
                    //     return resolve(returnInfo);
                    // } else {
                    //     let query = `SELECT firstname, lastname, charinfo FROM players WHERE cid = '${cid}'`;

                    //     exports["oxmysql"].execute(query, {}, function (result) {
                    //         let dateOfBirth = '';
                    //         let gender = JSON.parse(result[0].charinfo)
                    //         try {
                    //             dateOfBirth = new Date(gender.birthdate).toISOString().split('T')[0];
                    //         } catch (err) {
                    //             dateOfBirth = 'N/A';
                    //         }

                    //         returnInfo = JSON.stringify({
                    //             Identifier: cid.toString(),
                    //             Name: result[0].first_name.replace(/[^\w\s]/gi, ''),
                    //             Surname: result[0].last_name.replace(/[^\w\s]/gi, ''),
                    //             Sex: gender.gender === 0 ? "M" : "F",
                    //             DOB: dateOfBirth
                    //         });

                    //         timeOut = 1
                    //         clearTimeout(timeOut);
                    //         return resolve(returnInfo);
                    //     });
                    // }
                    // break;
                case "drivingtest":
                    if (rData.id) {
                        let query = `SELECT * FROM driving_tests WHERE id = '${rData.id}'`;

                        exports["oxmysql"].execute(query, {}, function (result) {
                            if (result[0]) {
                                let timeStamp = new Date(parseInt(result[0].timestamp) * 1000);
                                let testDate = timeStamp.getFullYear() + "-" + ("0" + (timeStamp.getMonth() + 1)).slice(-2) + "-" + ("0" + timeStamp.getDate()).slice(-2);

                                returninfo = JSON.stringify({
                                    ID: result[0].id,
                                    CID: result[0].cid,
                                    Instructor: result[0].instructor,
                                    Date: testDate,
                                });

                                timeOut = 1;
                                clearTimeout(timeOut)
                            }
                            return resolve(returninfo);
                        });
                    } else {
                        timeOut = 1;
                        clearTimeout(timeOut)
                        return resolve(returnInfo);
                    }
                    break;
                case 'huntingcarcass1':
                case 'huntingcarcass2':
                case 'huntingcarcass3':
                case 'huntingcarcass4':
                    returnInfo = JSON.stringify({
                        Identifier: itemData.identifier
                    });

                    timeOut = 1;
                    clearTimeout(timeOut);
                    return resolve(returnInfo);

                case "casing":
                    returnInfo = JSON.stringify({
                        Identifier: itemData.identifier,
                        Type: itemData.eType,
                        Other: itemData.other
                    })

                    timeOut = 1
                    clearTimeout(timeOut);
                    return resolve(returnInfo);

                // case "np_evidence_marker_yellow":
                // case "np_evidence_marker_red":
                // case "np_evidence_marker_white":
                // case "np_marker_evidence_marker_orange":
                // case "np_marker_evidence_marker_light_blue":
                // case "np_marker_evidence_marker_light_purple":
                // case "evidence":
                //     returnInfo = JSON.stringify({
                //         Identifier: itemData.identifier,
                //         Type: itemData.eType,
                //         Other: itemData.other
                //     })

                //     timeOut = 1;
                //     clearTimeout(timeOut);
                //     return resolve(returnInfo);

                case "rentalpapers":
                    returnInfo = JSON.stringify({
                        _hideKeys: ["_netid"],
                    });

                    timeOut = 1;
                    clearTimeout(timeOut);
                    return resolve(returnInfo);

                case "customtoyitem":
                    returnInfo = JSON.stringify({
                        _factory: true,
                        _name: itemData._name,
                        _description: itemData._description,
                        _image_url: itemData._image_url,
                    });

                    timeOut = 1;
                    clearTimeout(timeOut);
                    return resolve(returnInfo);

                case "bowlingreceipt":
                    returnInfo = JSON.stringify({
                        lane: itemData.lane
                    })

                    timeOut = 1;
                    clearTimeout(timeOut)
                    return resolve(returnInfo);
                case "weedbaggie":
                case "weedpackage":
                    returnInfo = JSON.stringify({
                        strain: itemData.strain,
                        quality: itemData.quality,
                        grower: itemData.grower,
                        id: itemData.id,
                        _hideKeys: ["grower", "id"],
                    })

                    timeOut = 1;
                    clearTimeout(timeOut)
                    return resolve(returnInfo);
                case "smallbud":
                    returnInfo = JSON.stringify({
                        strain: itemData.strain,
                        quality: itemData.quality,
                        grower: itemData.grower,
                        id: itemData.id,
                        _hideKeys: ["quality", "grower", "id"],
                    })

                    timeOut = 1;
                    clearTimeout(timeOut)
                    return resolve(returnInfo);
                case "drone_lspd":
                case "drone_civ":
                case "rc_car_civ":
                    returnInfo = JSON.stringify({
                        battery: Math.floor(Math.random() * 20) + 10,
                        charges: 0,
                        id: randomId,
                        _hideKeys: ["charges", "id"],
                    });

                    timeOut = 1;
                    clearTimeout(timeOut);
                    return resolve(returnInfo);

                case "heistlaptop1":
                case "heistlaptop2":
                case "heistlaptop3":
                case "heistlaptop4":
                    returnInfo = JSON.stringify({
                        id: randomId,
                        _hideKeys: ["id"],
                    });

                    timeOut = 1;
                    clearTimeout(timeOut);
                    return resolve(returnInfo);

                case "craterepairkit":
                    returnInfo = JSON.stringify({
                        charges: Math.floor(Math.random() * 20)
                    })

                    timeOut = 1;
                    clearTimeout(timeOut)
                    return resolve(returnInfo);

                case "-2084633992":
                case "1593441988":
                case "-1716589765":
                    returnInfo = JSON.stringify({
                        _hideKeys: ["BulletClub"],
                    });

                    timeOut = 1;
                    clearTimeout(timeOut);
                    return resolve(returnInfo);

                case "resfooditem":
                case "ressideitem":
                case "resdessertitem":
                case "resdrinkitem":
                    returnInfo = JSON.stringify({
                        _foodEnhancements: itemData._foodEnhancements,
                        _name: itemData._name,
                        _description: itemData._description,
                        _image_url: itemData._image_url,
                        _remove_id: itemData._remove_id,
                    });

                    timeOut = 1;
                    clearTimeout(timeOut);
                    return resolve(returnInfo);

                case "tcgpromobooster":
                    returnInfo = JSON.stringify({
                        id: randomId,
                        printId: randomId,
                    });

                    timeOut = 1;
                    clearTimeout(timeOut);
                    return resolve(returnInfo);
                default:
                    timeOut = 1
                    clearTimeout(timeOut)
                    return resolve(returnInfo);
            }
        } else {
            return resolve(returnInfo);
        }

        setTimeout(() => {
            if (timeOut == 0) {
                return resolve(returnInfo);
            }
        }, 500)
    });
}

function removeCash(src, itemCosts) {
    emit('cash:remove', src, itemCosts)
}

function DroppedItem(itemArray) {
    itemArray = JSON.parse(itemArray)
    var shopItems = [];

    shopItems[0] = {
        item_id: itemArray[0].itemid,
        id: 0,
        name: "shop",
        information: "{}",
        slot: 1,
        amount: itemArray[0].amount
    };

    return JSON.stringify(shopItems);
}

function deleteHidden() {
    exports["oxmysql"].execute(`DELETE FROM user_inventory2 WHERE name like '%Hidden%' OR name like '%trash%'`)
}

function deleteHiddenHandler() {
    setTimeout(250000, deleteHidden())
}

onNet('onResourceStart', (resource) => {
    if (resource == GetCurrentResourceName()) {
        exports["oxmysql"].execute(`DELETE FROM user_inventory2 WHERE name like '%Drop%'`)
    }
})

/////////////////////////////// Old Code ///////////////////////////////