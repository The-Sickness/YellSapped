-- YellSapped
-- Made by Sharpedge_Gaming
-- v1.0	 - 10.0.2

local YellSapped = CreateFrame("Frame")
YellSapped.playername = UnitName("player")

YellSapped:SetScript("OnEvent", function(self, evt)   
    if( evt == "COMBAT_LOG_EVENT_UNFILTERED" )then
        local _, event, _, _, sourceName, _, _, _, dstName, _,_,spellId = CombatLogGetCurrentEventInfo()
        
        if( (spellId == 6770)
            and (dstName == YellSapped.playername)
            and (event == "SPELL_AURA_APPLIED" or event == "SPELL_AURA_REFRESH")
            )then
            SendChatMessage("I've been SAPPED!!","YELL")
            DEFAULT_CHAT_FRAME:AddMessage("Sapped by: "..(sourceName or "(unknown)"))
        end
        
    end
end)

YellSapped:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
DEFAULT_CHAT_FRAME:AddMessage("YellSapped is loaded")
