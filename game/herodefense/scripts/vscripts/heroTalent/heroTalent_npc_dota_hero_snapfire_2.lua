heroTalent_npc_dota_hero_snapfire_2 = class({})
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_snapfire_2", "heroTalent/heroTalent_npc_dota_hero_snapfire_2", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_snapfire_buff", "heroTalent/heroTalent_npc_dota_hero_snapfire", LUA_MODIFIER_MOTION_NONE )

function heroTalent_npc_dota_hero_snapfire_2:GetIntrinsicModifierName()
	return "modifier_heroTalent_npc_dota_hero_snapfire_2"
end



modifier_heroTalent_npc_dota_hero_snapfire_2 = class({})

function modifier_heroTalent_npc_dota_hero_snapfire_2:IsHidden()	return self:GetStackCount()<=0 end
function modifier_heroTalent_npc_dota_hero_snapfire_2:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_snapfire_2:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_snapfire_2:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_snapfire_2:RemoveOnDeath() return false end
function modifier_heroTalent_npc_dota_hero_snapfire_2:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
	return funcs
end

function modifier_heroTalent_npc_dota_hero_snapfire_2:OnAttackLanded( params )
	if IsServer() then
		if self:GetParent()==params.attacker then
			self:IncrementStackCount()
			if self:GetStackCount()>=5 then
				self:SetStackCount(0)
				self:GetParent():AddNewModifier(self:GetParent(),self:GetAbility(),"modifier_heroTalent_npc_dota_hero_snapfire_buff",{stack=2})
			end
		end
	end
end

