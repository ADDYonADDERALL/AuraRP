Async = {}

function Async.parallel(asyncTasks, asyncCb)
	local asyncRemaining = #asyncTasks
	if asyncRemaining == 0 then
		asyncCb({})
		return
	end

	local asyncResults = {}
	for i=1, asyncRemaining, 1 do
		Citizen.CreateThread(function()
			asyncTasks[i](function(asyncResult)
				table.insert(asyncResults, asyncResult)
				
				asyncRemaining = asyncRemaining - 1;
				if asyncRemaining == 0 then
					asyncCb(asyncResults)
				end
			end)
		end)
	end
end

function Async.parallelLimit(asyncTasks, asyncLimit, asyncCb)
	local asyncRemaining = #asyncTasks
	if asyncRemaining == 0 then
		asyncCb({})
		return
	end

	local asyncQueue = {}
	for i=1, asyncRemaining, 1 do
		table.insert(asyncQueue, asyncTasks[i])
	end

	local asyncRunning = 0
	local asyncResults = {}
	local function processQueue()
		if #asyncQueue == 0 then
			return
		end

		while asyncRunning < asyncLimit and #asyncQueue > 0 do
			local curAsyncTask = table.remove(asyncQueue, 1)

			asyncRunning = asyncRunning + 1
			curAsyncTask(function(asyncResult)
				table.insert(asyncResults, asyncResult)

				asyncRunning  = asyncRunning - 1
				asyncRemaining = asyncRemaining - 1
				if asyncRemaining == 0 then
					asyncCb(asyncResults)
				end

			end)
		end

		Citizen.CreateThread(processQueue)
	end

	processQueue()
end

function Async.series(asyncTasks, asyncCb)
	Async.parallelLimit(asyncTasks, 1, asyncCb)
end
