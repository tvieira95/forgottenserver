-- Weekly Task Delivery Items Configuration
-- Mapped by difficulty tier (0=Beginner, 1=Adept, 2=Expert, 3=Master)
-- Each entry: { itemId = X, amount = Y }
-- Add your server's item IDs here.

return {
	-- Beginner (difficulty 0)
	[0] = {
		{ itemId = 2461, amount = 5 },  -- Dragon Egg (example)
		{ itemId = 2464, amount = 5 },  -- Chain Armor
		{ itemId = 2465, amount = 5 },  -- Brass Armor
		{ itemId = 2378, amount = 10 }, -- Plate Legs
		{ itemId = 2398, amount = 10 }, -- Mace
		{ itemId = 2416, amount = 10 }, -- Two Handed Sword
		{ itemId = 2413, amount = 10 }, -- Broadsword
		{ itemId = 2672, amount = 5 },  -- Wolf Paw
		{ itemId = 2229, amount = 5 },  -- Skull
		{ itemId = 2643, amount = 10 }, -- Orc Leather
	},

	-- Adept (difficulty 1)
	[1] = {
		{ itemId = 2488, amount = 5 },  -- Crown Armor
		{ itemId = 2502, amount = 5 },  -- Dwarven Shield
		{ itemId = 2438, amount = 5 },  -- Daramanian Mace
		{ itemId = 2458, amount = 10 }, -- Knight Axe
		{ itemId = 2426, amount = 10 }, -- Obsidian Lance
		{ itemId = 2424, amount = 10 }, -- Halberd
		{ itemId = 2672, amount = 10 }, -- Wolf Paw
		{ itemId = 5925, amount = 5 },  -- Holy Orchid
		{ itemId = 5908, amount = 10 }, -- Demonic Essence
		{ itemId = 2472, amount = 10 }, -- Plate Armor
	},

	-- Expert (difficulty 2)
	[2] = {
		{ itemId = 2472, amount = 10 }, -- Plate Armor
		{ itemId = 2490, amount = 5 },  -- Dark Armor
		{ itemId = 2498, amount = 5 },  -- Royal Helmet
		{ itemId = 2516, amount = 5 },  -- Dragon Shield
		{ itemId = 2430, amount = 5 },  -- Dragon Lance
		{ itemId = 5877, amount = 5 },  -- Green Mushroom
		{ itemId = 5908, amount = 10 }, -- Demonic Essence
		{ itemId = 5958, amount = 10 }, -- Piece of Dead King
		{ itemId = 2535, amount = 10 }, -- Plate Shield
		{ itemId = 2487, amount = 10 }, -- Crown Legs
	},

	-- Master (difficulty 3)
	[3] = {
		{ itemId = 2493, amount = 5 },  -- Demon Helmet
		{ itemId = 2509, amount = 5 },  -- Mastermind Shield
		{ itemId = 2400, amount = 5 },  -- Magic Sword
		{ itemId = 2523, amount = 5 },  -- Golden Legs
		{ itemId = 5904, amount = 5 },  -- Vampire Dust
		{ itemId = 5958, amount = 10 }, -- Piece of Dead King
		{ itemId = 2476, amount = 10 }, -- Knight Armor
		{ itemId = 2475, amount = 10 }, -- Warrior Helmet
		{ itemId = 2518, amount = 10 }, -- Beholder Shield
		{ itemId = 5925, amount = 10 }, -- Holy Orchid
	},
}
