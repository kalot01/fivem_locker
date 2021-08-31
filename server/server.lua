ESX.RegisterServerCallback('kal_locker:getStockItems', function(source, cb)
	local items = {}
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerEvent('esx_addoninventory:getInventory', 'locker', xPlayer.identifier, function(inventory)
		items = inventory.items
	end)
  	cb({
		items      = items
	})

end)
RegisterServerEvent('kal_locker:getStockItem')
AddEventHandler('kal_locker:getStockItem', function(itemName, type, count)

    local xPlayer = ESX.GetPlayerFromId(source)
    if type ~= 'item_account' then
        TriggerEvent('esx_addoninventory:getInventory', 'locker', xPlayer.identifier, function(inventory)

            local item = inventory.getItem(itemName)

            if item.count >= count then
                if (exports.linden_inventory:canCarryItem(xPlayer,itemName, count)) then
                    inventory.removeItem(itemName, count)
                    exports.linden_inventory:addInventoryItem(xPlayer,itemName, count)
                else
                    TriggerClientEvent('kalcrafting:notification', xPlayer.source, Strings['maxweight'])
                end
            else
                TriggerClientEvent('kalcrafting:notification', xPlayer.source, Strings['quantity_invalid'])
            end
        end)
	end
end)
ESX.RegisterServerCallback('esx_cummon:getPlayerInventory', function(source, cb)

	local xPlayer    = ESX.GetPlayerFromId(source)
	local items      = exports.linden_inventory:getPlayerInventory(xPlayer,false)
    

	cb({
		items      = items
	})

end)
RegisterServerEvent('kal_locker:putStockItems')
AddEventHandler('kal_locker:putStockItems', function(itemName, count)

  local xPlayer = ESX.GetPlayerFromId(source)

  TriggerEvent('esx_addoninventory:getInventory', 'locker', xPlayer.identifier, function(inventory)

    local item = inventory.getItem(itemName)
	print(itemName)
	print(exports.linden_inventory:getInventoryItem(xPlayer,itemName).count)
	print(count)
    if exports.linden_inventory:getInventoryItem(xPlayer,itemName).count >= count then
      exports.linden_inventory:removeInventoryItem(xPlayer,itemName, count)
      inventory.addItem(itemName, count)
    else
        TriggerClientEvent('kalcrafting:notification', xPlayer.source, Strings['quantity_invalid'])
    end
  end)

end)