local math = require("math")

local function random_choice (option1, option2)
    local prob = math.random(1, 2)

    if prob == 1 then
        return option1
    else
        return option2
    end
    
end

return {
    random_choice = random_choice
}