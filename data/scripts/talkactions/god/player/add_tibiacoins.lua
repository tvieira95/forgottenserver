local MAX_TIBIA_COINS = 4294967295

local function shopHistoryExists()
	if db.tableExists then
		return db.tableExists("shop_history")
	end
	return true
end

local function addCoinHistory(accountId, playerGuid, amount, adminName)
	if not shopHistoryExists() then
		return
	end

	db.query("INSERT INTO `shop_history` (`account`, `player`, `date`, `title`, `price`, `costSecond`, `count`, `target`) VALUES (" ..
		accountId .. ", " ..
		playerGuid .. ", NOW(), " ..
		db.escapeString("God Add Tibia Coins") .. ", " ..
		amount .. ", 0, 1, " ..
		db.escapeString(adminName) .. ")")
end

local talkaction = TalkAction("/add")
function talkaction.onSay(player, words, param)
	local split = param:splitTrimmed(",")
	if not split[1] or not split[2] or not split[3] then
		player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Usage: /add tibiacoins, player name, amount")
		return false
	end

	local currency = split[1]:lower():gsub("[%s_%-]+", "")
	if currency ~= "tibiacoins" and currency ~= "tc" and currency ~= "coins" then
		player:sendCancelMessage("Unknown add type. Use: /add tibiacoins, player name, amount")
		return false
	end

	local targetName = split[2]
	local amount = math.floor(tonumber(split[3]) or 0)
	if amount <= 0 then
		player:sendCancelMessage("Amount must be a positive number.")
		return false
	end

	local resultId = db.storeQuery("SELECT p.`id`, p.`account_id`, p.`name`, a.`tibia_coins` FROM `players` p INNER JOIN `accounts` a ON a.`id` = p.`account_id` WHERE p.`name` = " .. db.escapeString(targetName) .. " LIMIT 1")
	if resultId == false then
		player:sendCancelMessage("Player not found.")
		return false
	end

	local targetGuid = result.getDataInt(resultId, "id")
	local accountId = result.getDataInt(resultId, "account_id")
	local storedName = result.getDataString(resultId, "name")
	local currentCoins = result.getDataInt(resultId, "tibia_coins")
	result.free(resultId)

	if currentCoins >= MAX_TIBIA_COINS then
		player:sendCancelMessage(storedName .. " already has the maximum Tibia Coins.")
		return false
	end

	local newBalance = math.min(currentCoins + amount, MAX_TIBIA_COINS)
	local addedAmount = newBalance - currentCoins
	if addedAmount <= 0 then
		player:sendCancelMessage("Could not add Tibia Coins.")
		return false
	end

	local target = Player(storedName)
	if target then
		target:setTibiaCoins(newBalance)
	elseif not db.query("UPDATE `accounts` SET `tibia_coins` = " .. newBalance .. " WHERE `id` = " .. accountId) then
		player:sendCancelMessage("Could not update Tibia Coins.")
		return false
	end

	addCoinHistory(accountId, targetGuid, addedAmount, player:getName())

	player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Added " .. addedAmount .. " Tibia Coins to " .. storedName .. ". New balance: " .. newBalance .. ".")

	if target then
		target:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "You received " .. addedAmount .. " Tibia Coins.")
	end
	return false
end
talkaction:separator(" ")
talkaction:accountType(6)
talkaction:access(true)
talkaction:register()
