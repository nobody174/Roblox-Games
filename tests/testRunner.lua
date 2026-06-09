--[=[
  Ghost Catcher Tycoon - Test Runner
  Author:  nobody174 (nobodylearn174@gmail.com)
  Repo:    https://github.com/nobody174/roblox-games
  License: All rights reserved © 2025 nobody174
  "It's never too late to give up!"
]=]

local TestRunner = {}
TestRunner.tests = {}
TestRunner.passed = 0
TestRunner.failed = 0

function TestRunner:register(name, fn)
	table.insert(self.tests, { name = name, fn = fn })
end

function TestRunner:run()
	print("\n" .. string.rep("=", 60))
	print("Running Tests...")
	print(string.rep("=", 60) .. "\n")

	for _, test in ipairs(self.tests) do
		local success, err = pcall(test.fn)

		if success then
			print("✓ " .. test.name)
			self.passed = self.passed + 1
		else
			print("✗ " .. test.name)
			print("  Error: " .. tostring(err))
			self.failed = self.failed + 1
		end
	end

	print("\n" .. string.rep("=", 60))
	print("Results: " .. self.passed .. " passed, " .. self.failed .. " failed")
	print(string.rep("=", 60) .. "\n")

	return self.failed == 0
end

function TestRunner:assertEquals(actual, expected, message)
	if actual ~= expected then
		error(message or ("Expected " .. tostring(expected) .. " but got " .. tostring(actual)))
	end
end

function TestRunner:assertTrue(condition, message)
	if not condition then
		error(message or "Expected true but got false")
	end
end

function TestRunner:assertFalse(condition, message)
	if condition then
		error(message or "Expected false but got true")
	end
end

return TestRunner
