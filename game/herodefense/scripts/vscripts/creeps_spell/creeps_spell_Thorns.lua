creeps_spell_Thorns = class({})

LinkLuaModifier("modifier_creeps_spell_Thorns_passive", "creeps_spell/creeps_spell_Thorns", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creeps_spell_Thorns_reflection", "creeps_spell/creeps_spell_Thorns", LUA_MODIFIER_MOTION_NONE)


-- Item Passive
function creeps_spell_Thorns:GetIntrinsicModifierName()return "modifier_creeps_spell_Thorns_passive" end






-- Unique passive
modifier_creeps_spell_Thorns_passive = class({})

function modifier_creeps_spell_Thorns_passive:IsDebuff() return false end
function modifier_creeps_spell_Thorns_passive:IsHidden() return true end
function modifier_creeps_spell_Thorns_passive:IsPurgable() 		return false end
function modifier_creeps_spell_Thorns_passive:IsPurgeException() 	return false end
function modifier_creeps_spell_Thorns_passive:RemoveOnDeath()  return false end




function modifier_creeps_spell_Thorns_passive:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_TAKEDAMAGE
	}
	return funcs
end


function modifier_creeps_spell_Thorns_passive:OnTakeDamage(keys)
	if not IsServer() then
		return
	end
	if keys.unit ~= self:GetParent() then
		return
    end
    if keys.damage <50 then
        return
    end
	--低难度没用
	if _G.GAME_DIFFICULTY<4 then
		return
	end
	if self:GetParent():PassivesDisabled() then
		return
	end

	-- if bit.band( keys.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION ) == DOTA_DAMAGE_FLAG_REFLECTION then		return 	end

	-- if bit.band( keys.damage_flags, DOTA_DAMAGE_FLAG_HPLOSS ) == DOTA_DAMAGE_FLAG_HPLOSS then return	end

	-- if bit.band( keys.damage_flags, DOTA_CUSTOM_DAMAGE_FLAG_NO_ADDITIONAL_EFFECT ) == DOTA_CUSTOM_DAMAGE_FLAG_NO_ADDITIONAL_EFFECT then return  end
	-- print("1111")
	if keys.attacker.modifier_creeps_spell_Thorns_reflection_trigger==1 then
		return
	end


	if keys.attacker:IsMagicImmune() then
		return
	end


    local ability = self:GetAbility()
    local caster = ability:GetCaster()

    keys.attacker:AddNewModifier(caster, ability, "modifier_creeps_spell_Thorns_reflection", {duration = 20})
    keys.attacker.modifier_creeps_spell_Thorns_reflection_trigger = 1
    Timers:CreateTimer(1, function()
        keys.attacker.modifier_creeps_spell_Thorns_reflection_trigger = 0
    end)
    -----------------------------------------------
end



modifier_creeps_spell_Thorns_reflection = class({})

function modifier_creeps_spell_Thorns_reflection:IsDebuff() return true end
function modifier_creeps_spell_Thorns_reflection:IsHidden() return false end
function modifier_creeps_spell_Thorns_reflection:IsPurgable() return false end

function modifier_creeps_spell_Thorns_reflection:OnCreated(table)
	if not IsServer() then
		return
	end
	self.type = self:GetAbility():GetAbilityDamageType()
	self:SetStackCount(1)
end
function modifier_creeps_spell_Thorns_reflection:OnRefresh(table)
	if not IsServer() then
		return
	end
	self:IncrementStackCount()
end
function modifier_creeps_spell_Thorns_reflection:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_TAKEDAMAGE
	}
	return funcs
end


function modifier_creeps_spell_Thorns_reflection:OnTakeDamage(params)

	if IsServer() then
		local Attacker = params.attacker
		local Target = params.unit

		local flDamage = params.damage
		
		if flDamage<100 then
		
			return
		end
	

		if Target  ~= self:GetCaster() and Attacker~=self:GetParent() then
			return 0
		end
		if Target:PassivesDisabled() then
			return
		end
		if bit.band( params.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION ) == DOTA_DAMAGE_FLAG_REFLECTION then
			return 0
		end
		if bit.band( params.damage_flags, DOTA_DAMAGE_FLAG_HPLOSS ) == DOTA_DAMAGE_FLAG_HPLOSS then --防止无限反弹
			return 0
		end
		if bit.band( params.damage_flags, DOTA_DAMAGE_FLAG_NO_DIRECTOR_EVENT ) == DOTA_DAMAGE_FLAG_NO_DIRECTOR_EVENT then --防止无限反弹
			return 0
		end
		if Attacker:IsMagicImmune() then
			return
		end

		local damage = flDamage*self:GetStackCount()*0.02


		local damage_table = {
			victim = Attacker,
			attacker = Target,
			damage = damage,
			damage_type = self.type,
			damage_flags = DOTA_DAMAGE_FLAG_REFLECTION + DOTA_DAMAGE_FLAG_HPLOSS + DOTA_DAMAGE_FLAG_NO_DIRECTOR_EVENT + DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION
		}
		ApplyDamage(damage_table)
	end
	return 0.0
end



