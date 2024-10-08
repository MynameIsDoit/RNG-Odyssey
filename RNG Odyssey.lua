local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()
local Window = OrionLib:MakeWindow({Name = "RNG Odyssey", HidePremium = false, SaveConfig = true, ConfigFolder = "OrionTest"})

local Tab = Window:MakeTab({
	Name = "Auto Farm",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})
local Section = Tab:AddSection({
	Name = "Main"
})

Tab:AddButton({
	Name = "Fast Attack",
	Callback = function()
	for _, value in next, getgc(true) do
    if type(value) == 'table' and rawget(value, 'Cooldown') and rawget(value, 'Range') then
            rawset(value, 'Cooldown', 0)
            rawset(value, 'Range', 1000)
        end
    end
    OrionLib:MakeNotification({
	Name = "Fast Attack",
	Content = "          Active",
	Image = "rbxassetid://4483345998",
	Time = 5
})

  	end    
})
local VirtualInputManager = game:GetService("VirtualInputManager")
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local VirtualUser = game:GetService("VirtualUser")

local selectedMethod = nil
local isActive = false  

local function simulateEKeyPress()
    for i = 1, 20 do
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)  
        wait(0.1)  
    end
    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)  
end

local function bringAllCratesToPlayer()
    local raritiesFolder = game:GetService("Workspace").Rarities
    for _, crate in ipairs(raritiesFolder:GetChildren()) do
        if crate:IsA("MeshPart") then
            local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
            if humanoidRootPart then
                local frontPosition = humanoidRootPart.Position + (humanoidRootPart.CFrame.LookVector * 1.6) + Vector3.new(-2, 0, 0) 
                crate.Position = frontPosition
            end
        end
    end
end

local function simulateMouseClick()
    while isActive do
        VirtualUser:CaptureController()
        VirtualUser:ClickButton1(Vector2.new(50, 50), CFrame.new(Vector3.new(0, 0, 0)))
        bringAllCratesToPlayer()
        task.wait() 
    end
end

Tab:AddDropdown({
    Name = "Choose Method",
    Default = "None",
    Options = {"Auto Heavy Attack (BUG)", "Auto Attack"},
    Callback = function(Value)
        selectedMethod = Value
    end    
})

Tab:AddToggle({
    Name = "Enable Autofarm",
    Default = false,
    Callback = function(Value)
        isActive = Value  

        if Value then
            spawn(function()
                while isActive do
                    character = player.Character or player.CharacterAdded:Wait()
                    
                    bringAllCratesToPlayer()

                    if selectedMethod == "Auto Heavy Attack" then
                        simulateEKeyPress()  
                    elseif selectedMethod == "Auto Attack" then
                        simulateMouseClick() 
                    end
                    
                    task.wait(0.5)  
                end
            end)
        end
    end    
})


local Tab = Window:MakeTab({
	Name = "Stats",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})
local Section = Tab:AddSection({
	Name = "Level Points"
})

local selectedResource = "Luck"
local isLooping = false

Tab:AddDropdown({
    Name = "Select Resource",
    Default = selectedResource,  
    Options = {"Luck", "Coins", "Gems", "Damage", "Spawn Speed", "XP"},
    Callback = function(resource)
        selectedResource = resource  
    end    
})

Tab:AddToggle({
    Name = "Auto Upgrade Levelpoint",
    Default = false,  
    Callback = function(value)
        isLooping = value  
        if isLooping then
            while isLooping do
                game:GetService("ReplicatedStorage").Remotes.LevelPointUpgrade:FireServer(selectedResource)  
                wait(1)  
            end
        end
    end    
})
local armorTiers = {"Tier1", "Tier2"}  -- Define armor tiers
local selectedArmorTier = armorTiers[1]  -- Default selection

Tab:AddDropdown({
    Name = "Select Armor Tier",
    Default = selectedArmorTier,  -- Set default option
    Options = armorTiers,  -- Options for the dropdown
    Callback = function(tier)
        selectedArmorTier = tier  -- Update the selected armor tier
    end    
})

local purchaseTypes = {"Single", "Triple"}  
Tab:AddDropdown({
    Name = "Select Purchase Type",
    Default = selectedPurchaseType,  
    Options = purchaseTypes,  
    Callback = function(purchaseType)
        selectedPurchaseType = purchaseType  
    end    
})

Tab:AddToggle({
    Name = "Auto Buy Armor Boxes",
    Default = false,  
    Callback = function(value)
        if value then
            while value do
                local gemValue = game:GetService("Players").LocalPlayer.Values.Gems.Value  
                if selectedArmorTier == "Tier1" and gemValue >= 100 then
                    game:GetService("ReplicatedStorage").Remotes.BuyArmorBox:FireServer(selectedArmorTier, selectedPurchaseType)  
                    wait(1)  
                elseif selectedArmorTier == "Tier2" and gemValue >= 1000 then
                    game:GetService("ReplicatedStorage").Remotes.BuyArmorBox:FireServer(selectedArmorTier, selectedPurchaseType)  
                    wait(1) 
                else
                    wait(1)  
                end
            end
        end
    end    
})

local Tab = Window:MakeTab({
	Name = "Misc",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})
local Section = Tab:AddSection({
	Name = "Gifts"
})


Tab:AddToggle({
    Name = "Claim All Gifts",
    Default = false,  
    Callback = function(value)
        if value then
            for i = 1, 12 do
                game:GetService("ReplicatedStorage").Remotes.ClaimGift:FireServer(i) 
                wait(0.5) 
            end
            Tab:GetToggle("Claim All Gifts").SetValue(false) 
        end
    end    
})

local isTouching = false 
local player = game.Players.LocalPlayer 
local character = player.Character or player.CharacterAdded:Wait()
local rewardButton = game:GetService("Workspace").Obby.RewardButton["Meshes/ground"]

Tab:AddToggle({
    Name = "Auto Obby",
    Default = false,
    Callback = function(Value)
        isTouching = Value 
        if isTouching then
            while isTouching do
                if rewardButton then
                    rewardButton:Touch(character)
                    wait(5) 
                else
                    warn("RewardButton not found!")
                    break
                end
                wait(5) 
            end
        end
    end    
})



