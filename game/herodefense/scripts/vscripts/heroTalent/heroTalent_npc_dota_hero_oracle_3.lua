heroTalent_npc_dota_hero_oracle_3 = class({})
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_oracle_3", "heroTalent/heroTalent_npc_dota_hero_oracle_3.lua", LUA_MODIFIER_MOTION_NONE )

function heroTalent_npc_dota_hero_oracle_3:GetIntrinsicModifierName()
    return "modifier_heroTalent_npc_dota_hero_oracle_3"
end


function heroTalent_npc_dota_hero_oracle_3:Spawn()
	if IsServer() then
		local caster = self:GetCaster()
		caster:GameTimer(0.1, function()
            if self.already == nil then
			    caster:AddItemByName("item_chaotic_oracle_box")
                self.already = 1
                self:SetActivated(false)
            end
		end)
	end
end

function heroTalent_npc_dota_hero_oracle_3:OnSpellStart()
    self.oracle_used = true
    chaotic_era_spawner:InitCardEffect(3)
    self:GetCaster():AddItemByName("item_chaotic_oracle_box")
    self:SetActivated(false)
end


modifier_heroTalent_npc_dota_hero_oracle_3 = advanced_modifier({})
function modifier_heroTalent_npc_dota_hero_oracle_3:IsHidden() return true end
function modifier_heroTalent_npc_dota_hero_oracle_3:IsPurgable() return false end
function modifier_heroTalent_npc_dota_hero_oracle_3:RemoveOnDeath() return false end
function modifier_heroTalent_npc_dota_hero_oracle_3:OnCreated(table)
    self.round = self:GetAbility():GetSpecialValueFor("round")
    self:SetStackCount(0)
end
function modifier_heroTalent_npc_dota_hero_oracle_3:ADDeclareFunctions()
    return{
        MODIFIER_EVENT_ON_Wave_Start = {}
    }
end

function modifier_heroTalent_npc_dota_hero_oracle_3:OnWaveStart()
	if not IsServer() then
		return
	end
	self:SetStackCount(self:GetStackCount()+1)
    if self:GetStackCount() >= self.round then
        self:GetParent():AddItemByName("item_chaotic_oracle_box")
        self:SetStackCount(0)
    end
end