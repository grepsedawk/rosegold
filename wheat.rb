eval File.open('framework.rb') { |f| f.read }

require 'date'

GlobalVars.put_int('large_chest_index', 0)
# GlobalVars.put_int('wheat_watermark', 74)
wheat_watermark = GlobalVars.get_int('wheat_watermark') || 0.tap { |v| GlobalVars.put_int('wheat_watermark', v) }
start_position = Position.new(7608, 68.9, -1831 - wheat_watermark)
end_position = Position.new(7803, 68.9, -1956)

# Chat.say "/g Titan Starting Wheat Harvest at #{DateTime.now} skipping to row #{wheat_watermark}"

current_position = Position.new(
  start_position.x,
  start_position.y,
  start_position.z + 1
)

def deposit(large_chest_index = GlobalVars.get_int('large_chest_index') || 0)
  Keyboard.release 'key.left'
  Keyboard.release 'key.right'
  Keyboard.release 'key.use'

  GlobalVars.put_int('large_chest_index', large_chest_index)

  Inventory.close
  Client.wait_tick 10

  Keyboard.release 'key.sprint'
  Client.wait_tick 3
  Keyboard.press 'key.sprint'
  Player.move_to 7611 + (large_chest_index * 2), 69, -1829

  Player.yaw = 0
  Player.pitch = 60
  Client.wait_tick 5
  Keyboard.press_and_release 'key.use'
  Client.wait_tick 5
  Inventory.dump 'minecraft:wheat_seeds'
  Inventory.dump 'minecraft:wheat_seeds', 'hotbar'
  Client.wait_tick 10
  return deposit(large_chest_index + 1) unless Inventory.free_slots?('container')

  Inventory.close

  Client.wait_tick 20

  Player.yaw = 0
  Player.pitch = 0
  Client.wait_tick 5
  Keyboard.press_and_release 'key.use'
  Client.wait_tick 5
  Inventory.dump 'minecraft:wheat'
  Inventory.dump 'minecraft:wheat', 'hotbar'
  Client.wait_tick 10
  return deposit(large_chest_index + 1) unless Inventory.free_slots?('container')

  Inventory.close

  Client.wait_tick 20
end

deposit

until current_position.z <= end_position.z
  Player.eat!
  Hotbar.pick('minecraft:golden_pickaxe') || Inventory.pick('minecraft:golden_pickaxe')

  Keyboard.release 'key.sprint'
  Client.wait_tick 3
  Keyboard.press 'key.sprint'
  Player.move_to(*current_position.to_a)

  until Player.x > end_position.x
    Player.yaw = 180
    Player.pitch = 24
    Keyboard.press 'key.right'
    Keyboard.press 'key.use'
    Client.wait_tick 5
  end
  Keyboard.release 'key.right'
  Client.wait_tick 10
  Keyboard.release 'key.use'
  GlobalVars.increment_and_get_int('wheat_watermark')
  deposit and redo unless Inventory.free_slots?

  current_position.x = end_position.x
  current_position.z = current_position.z - 1

  Player.move_to(*current_position.to_a)

  Player.eat!
  Hotbar.pick('minecraft:golden_pickaxe') || Inventory.pick('minecraft:golden_pickaxe')

  until Player.x < start_position.x + 1
    Player.yaw = 180
    Player.yaw = 180
    Player.pitch = 25
    Keyboard.press 'key.left'
    Keyboard.press 'key.use'
    Client.wait_tick 5
  end
  Keyboard.release 'key.left'
  Client.wait_tick 10
  Keyboard.release 'key.use'
  GlobalVars.increment_and_get_int('wheat_watermark')
  deposit and redo unless Inventory.free_slots?

  current_position.x = start_position.x
  current_position.z = current_position.z - 1

end

GlobalVars.put_int('wheat_watermark', 0)

deposit

Chat.say '/logout'
