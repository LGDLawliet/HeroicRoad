heroTalent_npc_dota_hero_elder_titan_4 = class({})
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_elder_titan_4", "heroTalent/heroTalent_npc_dota_hero_elder_titan_4.lua", LUA_MODIFIER_MOTION_NONE )

function heroTalent_npc_dota_hero_elder_titan_4:GetIntrinsicModifierName()
    return "modifier_heroTalent_npc_dota_hero_elder_titan_4"
end


function heroTalent_npc_dota_hero_elder_titan_4:Spawn()
	if IsServer() then
		local caster = self:GetCaster()
		caster:GameTimer(0.1, function()
            if self.already == nil then
			    caster:AddItemByName("item_act2_choice")
                self.already = 1
                self:SetActivated(false)
            end
		end)
	end
end

function heroTalent_npc_dota_hero_elder_titan_4:OnSpellStart()
    local target = self:GetCursorTarget()
    if target == self:GetCaster() then return end
    
    self.used = true
    target:AddItemByName("item_act2_choice")
    self:SetActivated(false)
end

function heroTalent_npc_dota_hero_elder_titan_4:OnHeroLevelUp()
	if not IsServer() then return end
    if self.used then return end
    
    if self:GetCaster():GetLevel() >= self:GetSpecialValueFor("line") then
        self:SetActivated(true)
    end
end