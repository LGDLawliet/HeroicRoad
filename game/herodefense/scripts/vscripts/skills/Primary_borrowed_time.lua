
LinkLuaModifier("modifier_Primary_borrowed_time_handler", "skills/Primary_borrowed_time", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Primary_borrowed_time_buff_hot_caster", "skills/Primary_borrowed_time", LUA_MODIFIER_MOTION_NONE)

Primary_borrowed_time = Primary_borrowed_time or class({})

function Primary_borrowed_time:GetIntrinsicModifierName()
	if self:GetCaster():IsRealHero() then
		return "modifier_Primary_borrowed_time_handler"
	end
end


function Primary_borrowed_time:OnSpellStart()
	if IsServer() then
		local caster = self:GetCaster()
		local buff_duration = self:GetSpecialValueFor("duration")
		if caster:HasAbility("heroTalent_npc_dota_hero_abaddon_2") then
			buff_duration = buff_duration + 2
			caster:EmitSound("HeroTime")
		end
		caster:AddNewModifier(caster, self, "modifier_Primary_borrowed_time_buff_hot_caster", { duration = buff_duration })
		caster:EmitSound("Hero_Abaddon.BorrowedTime")

	end
end

--自动施法
modifier_Primary_borrowed_time_handler = modifier_Primary_borrowed_time_handler or class({})
function modifier_Primary_borrowed_time_handler:IsDebuff() return false end
function modifier_Primary_borrowed_time_handler:IsHidden() return true end
function modifier_Primary_borrowed_time_handler:IsPurgable() 		return false end
function modifier_Primary_borrowed_time_handler:IsPurgeException() 	return false end
function modifier_Primary_borrowed_time_handler:RemoveOnDeath()  return false end
function modifier_Primary_borrowed_time_handler:AllowIllusionDuplicate() return false end

function modifier_Primary_borrowed_time_handler:_CheckHealth(damage)
	local target = self:GetParent()
	local ability = self:GetAbility()

	-- Check state
	if not ability:IsHidden() and ability:IsCooldownReady()and target:IsAlive() then
		local hp_threshold = target:GetMaxHealth()*0.15
		local current_hp = target:GetHealth()
		if current_hp <= hp_threshold then
			ability:OnSpellStart()
			ability:UseResources(false, false, true,true)
			-- target:CastAbilityImmediately(ability, target:GetPlayerID())
		end
	end
end

function modifier_Primary_borrowed_time_handler:OnCreated()
	if IsServer() then
		local target = self:GetParent()
		if target:IsIllusion() then
			self:SafeDestroy()
		end
	end
end

function modifier_Primary_borrowed_time_handler:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_EVENT_ON_STATE_CHANGED
	}

	return funcs
end

function modifier_Primary_borrowed_time_handler:OnTakeDamage(kv)

	if IsServer() then
		local target = self:GetParent()

		if target == kv.unit then
			self:_CheckHealth(kv.damage)
		end
	end

end



modifier_Primary_borrowed_time_buff_hot_caster = modifier_Primary_borrowed_time_buff_hot_caster or advanced_modifier({})
function modifier_Primary_borrowed_time_buff_hot_caster:IsDebuff() return false end
function modifier_Primary_borrowed_time_buff_hot_caster:IsHidden() return false end
function modifier_Primary_borrowed_time_buff_hot_caster:IsPurgable() return false end
function modifier_Primary_borrowed_time_buff_hot_caster:GetEffectName() return "particles/units/heroes/hero_abaddon/abaddon_borrowed_time.vpcf" end
function modifier_Primary_borrowed_time_buff_hot_caster:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW  end
function modifier_Primary_borrowed_time_buff_hot_caster:GetStatusEffectName() return "particles/status_fx/status_effect_abaddon_borrowed_time.vpcf" end
function modifier_Primary_borrowed_time_buff_hot_caster:StatusEffectPriority() return 10 end

function modifier_Primary_borrowed_time_buff_hot_caster:DeclareFunctions()
	local funcs = {
		
	}
	if IsServer() then
		if self:GetCaster():HasAbility("heroTalent_npc_dota_hero_abaddon_2") then
			table.insert(funcs,MODIFIER_PROPERTY_STATS_STRENGTH_BONUS)
			table.insert(funcs,MODIFIER_PROPERTY_STATS_INTELLECT_BONUS)
			table.insert(funcs,MODIFIER_PROPERTY_STATS_AGILITY_BONUS)
		end
	end

	return funcs
end




function modifier_Primary_borrowed_time_buff_hot_caster:OnCreated()
	if IsServer() then
		local target = self:GetParent()
		target:Purge(false, true, false, true, false)
		if target:HasAbility("heroTalent_npc_dota_hero_abaddon_2") then
			self.bonus_str =math.min(math.max(target:GetStrength()*0.55,80),400)
			self.bonus_agi = self.bonus_str
			self.bonus_int = self.bonus_str
		end
		

	end
end



function modifier_Primary_borrowed_time_buff_hot_caster:Advanced_GetModifierIncomingDamage_Percentage(kv)
	if IsServer() then
		-- Ability properties
		local target 	= self:GetParent()
		if kv.damage<=0 then
			return
		end
		-- Show borrowed time heal particle
		local heal_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_abaddon/abaddon_borrowed_time_heal.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
		local target_vector = target:GetAbsOrigin()
		ParticleManager:SetParticleControl(heal_particle, 0, target_vector)
		ParticleManager:SetParticleControl(heal_particle, 1, target_vector)
		ParticleManager:ReleaseParticleIndex(heal_particle)

	

		target:Heal(kv.damage, target)
		
		return -100
	end
	return -100
end



function modifier_Primary_borrowed_time_buff_hot_caster:GetModifierBonusStats_Strength()	return self.bonus_str or 0 end
function modifier_Primary_borrowed_time_buff_hot_caster:GetModifierBonusStats_Intellect()	return self.bonus_int or 0  end
function modifier_Primary_borrowed_time_buff_hot_caster:GetModifierBonusStats_Agility()	return self.bonus_agi or 0  end

function modifier_Primary_borrowed_time_buff_hot_caster:ADDeclareFunctions()
	local funcs = {advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE}
	return funcs
end
