--YellSapped--
--Sharpedge_Gaming--
--v.1.6

local AceAddon = LibStub("AceAddon-3.0"):NewAddon("YellSapped", "AceConsole-3.0", "AceEvent-3.0")
local AceConfig = LibStub("AceConfig-3.0")
local AceConfigDialog = LibStub("AceConfigDialog-3.0")

-- Define your message options
local messages = {
    "I've been SAPPED!!",
    "Sapped! Need some help!",
    "Someone just sapped me!",
    "Just got sapped!",
    "Rogue is here!",
    "Feeling woozy, sapped again!",
    "Sapped and trapped, assistance required!",
    "Rogue's tricks got me sapped!",
    "Sapped! Where did that come from?",
    "Help! I've been hit by a sap!",
    "Under the rogue's spell, sapped!",
    "Sapped in the shadows, rogue nearby!",
    "Beware, rogue sapped me out of nowhere!",
    "Can't move, sapped by a sneaky rogue!",
    "Rogue alert! Just got sapped again!"
}

-- Define default settings
local defaults = {
    profile = {
        selectedMessage = 1, -- Default to the first message
    },
}

function AceAddon:OnInitialize()
    self.db = LibStub("AceDB-3.0"):New("YellSappedDB", defaults, true)

    AceConfig:RegisterOptionsTable("YellSapped", self:GetOptions())
    AceConfigDialog:AddToBlizOptions("YellSapped", "YellSapped")

    local addon = self  
    local YellSappedFrame = CreateFrame("Frame")

    YellSappedFrame:SetScript("OnEvent", function(_, evt)
        if evt == "COMBAT_LOG_EVENT_UNFILTERED" then
            local _, event, _, _, sourceName, _, _, _, dstName, _, _, spellId = CombatLogGetCurrentEventInfo()
            if spellId == 6770 and dstName == UnitName("player") and (event == "SPELL_AURA_APPLIED" or event == "SPELL_AURA_REFRESH") then
                local inInstance, instanceType = IsInInstance()
                if (inInstance and (instanceType == "pvp" or instanceType == "arena")) or GetPVPInfo() then
                    SendChatMessage(messages[addon.db.profile.selectedMessage], "YELL")
                    DEFAULT_CHAT_FRAME:AddMessage("Sapped by: "..(sourceName or "(unknown)"))
                end
            end
        end
    end)

    YellSappedFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
    DEFAULT_CHAT_FRAME:AddMessage("YellSapped is loaded")
end

-- Define the options table
function AceAddon:GetOptions()
    local options = {
        name = "YellSapped",
        type = "group",
        args = {
            selectedMessage = {
                order = 1,
                type = "select",
                name = "Selected Message",
                desc = "Choose the message to yell when sapped",
                values = messages, 
                get = function(info) return self.db.profile.selectedMessage end,
                set = function(info, newValue)
                    self.db.profile.selectedMessage = newValue
                    
                end,
            },
            messagePreview = {
                order = 2,
                type = "description",
                name = function()
                    return "Preview: " .. messages[self.db.profile.selectedMessage]
                end,
				},
				outputChannel = {
    order = 3,
    type = "select",
    name = "Output Channel",
    desc = "Choose where to send the sapped message",
    values = {
    ["YELL"] = "Yell",
    ["SAY"] = "Say",
    ["PARTY"] = "Party",
    ["RAID"] = "Raid",
    ["GUILD"] = "Guild",
    ["OFFICER"] = "Officer",

    },
    get = function(info) return self.db.profile.outputChannel end,
    set = function(info, value)
        self.db.profile.outputChannel = value
    end,
            },
        },
    }
    return options
end


