heroTalent_npc_dota_hero_axe_4 = class({})
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_axe_4", "heroTalent/heroTalent_npc_dota_hero_axe_4", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_axe_4_buff", "heroTalent/heroTalent_npc_dota_hero_axe_4", LUA_MODIFIER_MOTION_NONE )

function heroTalent_npc_dota_hero_axe_4:GetIntrinsicModifierName()
	return "modifier_heroTalent_npc_dota_hero_axe_4"
end
function heroTalent_npc_dota_hero_axe_4:GetHealthCost()
    return self:GetCaster():GetMaxHealth()*self:GetSpecialValueFor("hp_cost")*0.01
end
function heroTalent_npc_dota_hero_axe_4:OnSpellStart()
    self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_heroTalent_npc_dota_hero_axe_4_buff", {})
end
function heroTalent_npc_dota_hero_axe_4:Spawn()
	if IsServer() then
		local caster = self:GetCaster()
		caster:GameTimer(0.1, function()
			if IsValid(self) then
				local costKeys = {
					baseCost = 500,
					to_level2_cost = 1000,
					to_level3_cost = 1500,
					upgrade_cost = 500,
					
				}
				skillshop:LearnTalentDefaultAbility(caster,"Culling_Blade",costKeys)
			end
		end)
	
	end

end



modifier_heroTalent_npc_dota_hero_axe_4 = class({})

function modifier_heroTalent_npc_dota_hero_axe_4:IsHidden()	return true end
function modifier_heroTalent_npc_dota_hero_axe_4:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_axe_4:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_axe_4:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_axe_4:RemoveOnDeath() return false end

modifier_heroTalent_npc_dota_hero_axe_4_buff = class({})

function modifier_heroTalent_npc_dota_hero_axe_4_buff:IsHidden()	return false end
function modifier_heroTalent_npc_dota_hero_axe_4_buff:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_axe_4_buff:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_axe_4_buff:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_axe_4_buff:RemoveOnDeath() return false end