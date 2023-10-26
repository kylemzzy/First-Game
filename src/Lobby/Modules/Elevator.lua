-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- references
local ObjectOrientatedModels = ReplicatedStorage:WaitForChild("ObjectOrientatedModels")

local elevator = {}

function elevator.New(template)
    print (template)
    -- search for the elevator name in the models folder in rep Storage
    local templateElevatorModel = ObjectOrientatedModels:FindFirstChild(template.Name)
    if not templateElevatorModel then return end
    
    local elevatorModel = templateElevatorModel:Clone()
    elevatorModel.Parent = workspace.Map.Elevators
    elevatorModel:PivotTo(template.CFrame)






    template:Destroy()
end

return elevator