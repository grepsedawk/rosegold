eval File.open('framework.rb') { |f| f.read }

Inventory.pick 'minecraft:iron_ingot'
Client.wait_tick 5
Chat.say '/ctf 20,000_Snitches_Under_the_Sea'
Inventory.pick 'minecraft:note_block'
Client.wait_tick 5
Player.interact
Client.wait_tick 5
Chat.say '/cto'
Client.wait_tick 5
Inventory.pick 'minecraft:sand'
