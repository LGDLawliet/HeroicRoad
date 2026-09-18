heroTalent_npc_dota_hero_juggernaut = class({})
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_juggernaut", "heroTalent/heroTalent_npc_dota_hero_juggernaut", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_juggernaut_effect", "heroTalent/heroTalent_npc_dota_hero_juggernaut", LUA_MODIFIER_MOTION_NONE )

-- require('internal/timers')   --计时器功能
function heroTalent_npc_dota_hero_juggernaut:GetIntrinsicModifierName()
	return "modifier_heroTalent_npc_dota_hero_juggernaut"
end



modifier_heroTalent_npc_dota_hero_juggernaut = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_juggernaut:IsHidden()	return true end
function modifier_heroTalent_npc_dota_hero_juggernaut:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_juggernaut:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_juggernaut:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_juggernaut:RemoveOnDeath() return false end

function modifier_heroTalent_npc_dota_hero_juggernaut:Advanced_GetModifierIncomingDamage_Percentage(keys)
	if IsServer() then
		local parent = self:GetParent()
		if parent:PassivesDisabled() then
			return
		end
		if keys.damage_category==DOTA_DAMAGE_CATEGORY_SPELL  then
			return
		end
		if not self:GetAbility():IsCooldownReady() then
			return
		end
		if parent:IsAttacking() then
	
			local effect_cast = ParticleManager:CreateParticle( "particles/items_fx/abyssal_blade_crimson_jugger.vpcf", PATTACH_ABSORIGIN_FOLLOW, parent )
			ParticleManager:SetParticleControl( effect_cast, 0, parent:GetAbsOrigin() )
			ParticleManager:ReleaseParticleIndex(effect_cast)
			parent:EmitSound("DOTA_Item.AbyssalBlade.Activate")
			self:GetAbility():UseResources(true, true, true,true)
			parent:AddNewModifier(parent, self:GetAbility(), "modifier_heroTalent_npc_dota_hero_juggernaut_effect", {duration = self:GetAbility():GetSpecialValueFor("duration"),stack = self:GetAbility():GetSpecialValueFor("count")})
			return -100
		end
	end
	return 
end

function modifier_heroTalent_npc_dota_hero_juggernaut:ADDeclareFunctions()
	local funcs = {advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE}
	return funcs
end


----------------------

modifier_heroTalent_npc_dota_hero_juggernaut_effect = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_juggernaut_effect:IsDebuff() return false end
function modifier_heroTalent_npc_dota_hero_juggernaut_effect:IsHidden() return false end
function modifier_heroTalent_npc_dota_hero_juggernaut_effect:IsPurgable() return false end
function modifier_heroTalent_npc_dota_hero_juggernaut_effect:GetTexture()return "item_echo_sabre" end
function modifier_heroTalent_npc_dota_hero_juggernaut_effect:GetEffectName() return "particles/new_effect/status/new_status_effect_soul_04.vpcf" end
function modifier_heroTalent_npc_dota_hero_juggernaut_effect:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_heroTalent_npc_dota_hero_juggernaut_effect:OnCreated(table)
	if not IsServer() then
		return
	end
	self:SetStackCount(table.stack)
end
function modifier_heroTalent_npc_dota_hero_juggernaut_effect:OnRefresh(table)
	if not IsServer() then
		return
	end
	self:SetStackCount(table.stack)
end
function modifier_heroTalent_npc_dota_hero_juggernaut_effect:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,       --攻击速度
	}
end
function modifier_heroTalent_npc_dota_hero_juggernaut_effect:ADDeclareFunctions()
	return {
		advanced_MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
		MODIFIER_EVENT_ON_ATTACK = {self:GetParent(),nil},
	}
end
function modifier_heroTalent_npc_dota_hero_juggernaut_effect:OnAttack(keys)
	if not IsServer() then
		return
	end

	if keys.attacker ~= self:GetParent() then
		return
	end

	self:SetStackCount(self:GetStackCount()-1)
	if self:GetStackCount()<=0 then
		self:SafeDestroy()
	end
end
function modifier_heroTalent_npc_dota_hero_juggernaut_effect:CheckState()
	local state = {[MODIFIER_STATE_CANNOT_MISS] = true}

	return state
end

function modifier_heroTalent_npc_dota_hero_juggernaut_effect:GetModifierAttackSpeedBonus_Constant()return 1000 end
function modifier_heroTalent_npc_dota_hero_juggernaut_effect:Advanced_GetModifierAttackRangeBonus()return 2000 end



