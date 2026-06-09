// Copyright 2023 The Forgotten Server Authors. All rights reserved.
// Use of this source code is governed by the GPL-2.0 License that can be found in the LICENSE file.
// SaveManager - Async save coordination using ThreadPool

#ifndef FS_SAVE_MANAGER_H
#define FS_SAVE_MANAGER_H

#include <atomic>
#include <future>
#include <memory>
#include <string>
#include <unordered_map>
#include <unordered_set>
#include <vector>

#include "iologindata.h"

class Player;

class SaveManager
{
public:
	SaveManager() = default;

	void saveAll();
	bool savePlayer(Player* player);
	void saveMapAsync();
	bool savePlayerSync(Player* player);

	/**
	 * @brief Thread-safe: blocks until all pending save operations for the given
	 * GUID have been fully persisted to the database.
	 *
	 * Called from the login flow (thread pool worker) before loadPlayerById
	 * to prevent reading stale data when a logout/async-save race occurred.
	 */
	bool drainPlayerFlush(uint32_t guid);

	[[nodiscard]] bool isSaving() const noexcept
	{
		return saving.load(std::memory_order_relaxed) || pendingSaveFlushes.load(std::memory_order_relaxed) != 0;
	}
	[[nodiscard]] uint64_t getLastSaveTime() const noexcept { return lastSaveDurationMs.load(std::memory_order_relaxed); }
	[[nodiscard]] uint32_t getLastPlayerCount() const noexcept { return lastPlayersSaved.load(std::memory_order_relaxed); }

private:
	struct PendingPlayerFlush
	{
		std::string name;
		IOLoginData::PlayerSaveSnapshot save;
		bool trackedBySaveAll = false;
	};

	// Player state snapshots and flush queue bookkeeping must run on the dispatcher thread.
	bool schedulePlayerFlush(Player* player, bool trackSaveAll = false);
	void onPlayerFlushed(uint32_t guid, bool trackedBySaveAll, bool success, IOLoginData::PlayerSaveSnapshot save);
	void acknowledgePlayerSave(uint32_t guid, const IOLoginData::PlayerSaveSnapshot& save);
	void beginTrackedFlush() noexcept;
	void completeTrackedFlush() noexcept;
	void dispatchPlayerFlush(uint32_t guid, PendingPlayerFlush pending);

	std::atomic<bool> saving{false};
	std::atomic<uint32_t> pendingSaveFlushes{0};
	std::atomic<uint64_t> lastSaveDurationMs{0};
	std::atomic<uint32_t> lastPlayersSaved{0};
	std::atomic<int64_t> lastSaveTimestamp{0};
	std::unordered_set<uint32_t> flushInFlight;
	std::unordered_map<uint32_t, PendingPlayerFlush> pendingFlushes;

	std::unordered_map<uint32_t, std::vector<std::shared_ptr<std::promise<void>>>> flushChainWaiters;

	static constexpr int64_t MIN_SAVE_INTERVAL_MS = 2000;
};

extern SaveManager g_saveManager;

#endif // FS_SAVE_MANAGER_H
