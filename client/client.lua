Citizen.CreateThread(function()
  while true do
    if Vdist2(GetEntityCoords(PlayerPedId()), LockerPosition) <= 100.0 then
      DrawMarker(27, LockerPosition, vector3(0.0, 0.0, 0.0), vector3(0.0, 0.0, 0.0), vector3(1.0, 1.0, 1.0), 255, 0, 255, 150, false, false, 2, false, false, false)
      if Vdist2(GetEntityCoords(PlayerPedId()), LockerPosition) <= 2.0 then
          HelpText((Strings['Press_E']):format(Strings['Storage']), storage)
          if IsControlJustReleased(0, 38) and Vdist2(GetEntityCoords(PlayerPedId()), LockerPosition) <= 2.0 then
            ESX.UI.Menu.CloseAll()

              ESX.UI.Menu.Open(
                  'default', GetCurrentResourceName(), 'storage',
              {
                  title = Strings['Locker'],
                  align = 'right',
                  elements = {
          {label = 'Put Object',  value = 'put_stock'},
          {label = 'Get Object',  value = 'get_stock'},
                  },
              },
              function(data, menu)

                      if data.current.value == 'put_stock' then
                          OpenPutStocksMenu()
                      end

                      if data.current.value == 'get_stock' then
                      OpenGetStocksMenu()
                      end
                      

              end,function(data, menu)
                      menu.close()
                  end)

          end
      end
    end 
  Wait(0)
  end
end)
function OpenPutStocksMenu()

  ESX.TriggerServerCallback('esx_cummon:getPlayerInventory', function(inventory)

    local elements = {}

    for i=1, #inventory.items, 1 do

      local item = inventory.items[i]
      if item.count > 0 then
        table.insert(elements, {label = item.label .. ' x' .. item.count, type = 'item_standard', value = item.name})
      end

    end

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'stocks_menu',
      {
        title    = 'inventory',
        elements = elements
      },
      function(data, menu)

        local itemName = data.current.value

        ESX.UI.Menu.Open(
          'dialog', GetCurrentResourceName(), 'stocks_menu_put_item_count',
          {
            title = 'quantity'
          },
          function(data2, menu2)

            local count = tonumber(data2.value)

            if count == nil then
              ESX.ShowNotification('quantity_invalid')
            else
              TriggerServerEvent('kal_locker:putStockItems', itemName, count)
              menu2.close()
              menu.close()
              OpenPutStocksMenu()              
            end

          end,
          function(data2, menu2)
            menu2.close()
          end
        )

      end,
      function(data, menu)
        menu.close()
      end
    )

  end)

end
function OpenGetStocksMenu()

  ESX.TriggerServerCallback('kal_locker:getStockItems', function(items)
    local elements = {}
    for i=1, #items.items, 1 do
        if (items.items[i].count > 0) then
            table.insert(elements, {label = 'x' .. items.items[i].count .. ' ' .. items.items[i].label, value = items.items[i].name, type = nill})
        end
    end
    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'stocks_menu',
      {
        title    = 'Stock',
        elements = elements
      },
      function(data, menu)

        local itemName = data.current.value
        local type = data.current.type

        ESX.UI.Menu.Open(
          'dialog', GetCurrentResourceName(), 'stocks_menu_get_item_count',
          {
            title = 'quantity'
          },
          function(data2, menu2)

            local count = tonumber(data2.value)

            if count == nil then
              ESX.ShowNotification('quantity_invalid')
            else
              TriggerServerEvent('kal_locker:getStockItem', itemName, type, count)
              menu2.close()
              menu.close()
            end

          end,
          function(data2, menu2)
            menu2.close()
          end
        )

      end,
      function(data, menu)
        menu.close()
      end
    )

  end)

end

function HelpText(msg, coords)
  if not coords or not Config.Use3DText then
      AddTextEntry(GetCurrentResourceName(), msg)
      DisplayHelpTextThisFrame(GetCurrentResourceName(), false)
  else
      DrawText3D(coords, string.gsub(msg, "~INPUT_CONTEXT~", "~r~[~w~E~r~]~w~"), 0.35)
  end
end