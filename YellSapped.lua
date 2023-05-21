-- Import the Ace3 libraries
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
    -- ... and so on, up to 10 messages or however many you want
}

-- Define your default settings
local defaults = {
    profile = {
        selectedMessage = 1, -- Default to the first message
    },
}

-- Initialize the addon
function AceAddon:OnInitialize()
    -- Load saved variables
    self.db = LibStub("AceDB-3.0"):New("YellSappedDB", defaults, true)

    -- Register the options table
    AceConfig:RegisterOptionsTable("YellSapped", self:GetOptions())
    
    -- Add the options to the Blizzard Interface Options
    AceConfigDialog:AddToBlizOptions("YellSapped", "YellSapped")

    -- Create the frame
    local YellSapped = CreateFrame("Frame")
    YellSapped.playername = UnitName("player")

    YellSapped:SetScript("OnEvent", function(self, evt)   
        if( evt == "COMBAT_LOG_EVENT_UNFILTERED" )then
            local _, event, _, _, sourceName, _, _, _, dstName, _,_,spellId = CombatLogGetCurrentEventInfo()

            if( (spellId == 6770)
                and (dstName == YellSapped.playername)
                and (event == "SPELL_AURA_APPLIED" or event == "SPELL_AURA_REFRESH")
                )then
                -- Use the selected message from the messages table
                SendChatMessage(messages[AceAddon.db.profile.selectedMessage],"YELL")
                DEFAULT_CHAT_FRAME:AddMessage("Sapped by: "..(sourceName or "(unknown)"))
            end
            
        end
    end)

    YellSapped:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
    DEFAULT_CHAT_FRAME:AddMessage("YellSapped is loaded")
end

-- Define the options table
function AceAddon:GetOptions()
    local options = {
        name = "YellSapped",
        type = "group",
        args = {
            selectedMessage = {
                type = "select",
                name = "Selected Message",
                desc = "Choose the message to yell when sapped",
                values = messages, -- This will automatically fill in the dropdown with your message options
                get = function(info) return self.db.profile.selectedMessage end,
                set = function(info, newValue) self.db.profile.selectedMessage = newValue end,
            },
        },
    }
    return options
end

