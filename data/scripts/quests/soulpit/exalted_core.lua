-- Exalted Core: downgrades a soul core to a lower difficulty tier's monster.
-- Ported from Crystal Server.

-- Guard: only load if Soulpit system is enabled
if not configManager or not configManager.getBoolean or not configManager.getBoolean(configKeys.SOULPIT_SYSTEM_ENABLED) then
	return
end

local exaltedCore = Action()

function exaltedCore.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if not player or not item or not target then
		return false
	end

	-- Item must be exalted core (ID 37110)
	if item:getId() ~= SoulPit.itemIds.exaltedCore then
		return false
	end

	-- Target must be a soul core
	local targetName = target:getName()
	local monsterName = SoulPit.getSoulCoreMonster(targetName)
	if not monsterName then
		player:sendTextMessage(MESSAGE_INFO_DESCR, "You can only use the exalted core on a soul core.")
		return false
	end

	-- Get current monster's difficulty
	local monsterType = MonsterType(monsterName)
	if not monsterType then
		player:sendTextMessage(MESSAGE_INFO_DESCR, "This creature does not exist.")
		return false
	end

	local currentStars = monsterType:bestiaryStars() or 1

	-- Get previous difficulty level
	local targetStars = currentStars
	if currentStars > 1 then
		targetStars = currentStars - 1
	end

	-- Find a random monster at the target difficulty
	local candidates = {}
	if CustomBestiary and CustomBestiary.monstersByRaceId then
		for raceId, entry in pairs(CustomBestiary.monstersByRaceId) do
			if entry.stars == targetStars then
				candidates[#candidates + 1] = entry
			end
		end
	end

	if #candidates == 0 then
		player:sendTextMessage(MESSAGE_INFO_DESCR, "No creatures found at the previous difficulty tier.")
		return false
	end

	-- Pick a random candidate and find its soul core item
	local chosen = candidates[math.random(#candidates)]
	if not chosen or not chosen.name then
		player:sendTextMessage(MESSAGE_INFO_DESCR, "Could not determine the target creature.")
		return false
	end
	local newCoreName = (chosen.name:lower() .. " soul core")
	local newCoreType = ItemType(newCoreName)
	if not newCoreType or newCoreType:getId() == 0 then
		player:sendTextMessage(MESSAGE_INFO_DESCR, "Soul core for " .. chosen.name .. " not found.")
		return false
	end

	-- Validate before consuming
	local newCoreId = newCoreType:getId()
	target:remove(1)
	item:remove(1)

	player:addItem(newCoreId, 1)
	player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
	player:sendTextMessage(MESSAGE_INFO_DESCR, "Exalted Core used successfully! The soul core has been transformed into " .. chosen.name .. ".")

	return true
end

exaltedCore:id(SoulPit.itemIds.exaltedCore)
exaltedCore:register()
