-- Resource Balance: sends 0xEE opcode for task-related point balances.
-- Called on login and after any point changes.

local ResourceBalance = {}

local protocol -- set by init.lua

function ResourceBalance.setProtocol(protoModule)
	protocol = protoModule
end

-- Send all task-related resource balances to a player
function ResourceBalance.sendAll(player)
	if not player or not protocol then
		return false
	end

	-- Task Hunting Points (0x32)
	protocol.sendResourceBalance(player, protocol.RESOURCE_TASK_HUNTING, player:getTaskHuntingPoints())

	-- Bounty Points (0x56)
	protocol.sendResourceBalance(player, protocol.RESOURCE_BOUNTY_POINTS, player:getBountyPoints())

	-- Soulseals Points (0x57)
	protocol.sendResourceBalance(player, protocol.RESOURCE_SOULSEALS_POINTS, player:getSoulsealsPoints())

	return true
end

return ResourceBalance
