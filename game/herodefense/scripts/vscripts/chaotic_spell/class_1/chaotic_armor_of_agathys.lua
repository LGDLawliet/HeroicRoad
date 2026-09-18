
chaotic_armor_of_agathys = class({})
LinkLuaModifier("modifier_chaotic_armor_of_agathys", "chaotic_spell/class_1/chaotic_armor_of_agathys", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chaotic_armor_of_agathys_rune_3", "chaotic_spell/class_1/chaotic_armor_of_agathys", LUA_MODIFIER_MOTION_NONE)


function chaotic_armor_of_agathys:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/chaotic_spell/chaotic_armor_of_agathys/effect.vpcf", context )
	PrecacheResource( "particle", "particles/econ/items/drow/drow_arcana/drow_arcana_marksmanship_frost_flash.vpcf", context )




	

end

function chaotic_armor_of_agathys:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end


function chaotic_armor_of_agathys:GetManaCost(iLevel)
	local cost = self.BaseClass.GetManaCost(self,iLevel)
	cost = cost * self:GetManaCostGain()
	return cost
end




function chaotic_armor_of_agathys:OnSpellStart()
	-- Ability properties
	local caster = self:GetCaster()
	-- local target = self:GetCursorTarget() 


	caster:EmitSound("chaotic_armor_of_agathys_cast")  

	-- local count = self:GetSpecialValueFor("count")-1
	local gain = caster:GetModifierDurationGainIndex(1)
	local duration = self:GetSpecialValueFor("duration")*gain
	
	self:ApplyModifier(caster, duration)

	if self:GetRuneType()==2 then
		local heroes = GetAllRealHeroes()
		for _,hero in pairs(heroes) do
			if hero~=caster then
				self:ApplyModifier(hero, duration)
			end
		end
	end
end

function chaotic_armor_of_agathys:ApplyModifier(target, duration)
	local caster = self:GetCaster()
	-- local gain = caster:GetModifierDurationGainIndex(1)
	-- local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(1)
	-- local StatusResistance = target:GetHDStatusResistanceIndex()*ModifierStatusNegativeGain
	target:AddNewModifier(caster, self, "modifier_chaotic_armor_of_agathys", {duration = duration})
	target:EmitSound("chaotic_armor_of_agathys_cast") 
	local pos = target:GetAbsOrigin()
	local effect_cast1 = ParticleManager:CreateParticle( "particles/rebuild/chaotic_spell/chaotic_armor_of_agathys/effect.vpcf", PATTACH_CUSTOMORIGIN, target )
	-- ParticleManager:SetParticleControl( effect_cast1, 0, pos )
	ParticleManager:SetParticleControlEnt(effect_cast1, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
	-- ParticleManager:SetParticleControl( effect_cast1, 2, pos )
	-- ParticleManager:SetParticleControl( effect_cast1, 3, pos )
	DestroyParticleByDelay(effect_cast1,4)

end




modifier_chaotic_armor_of_agathys = modifier_chaotic_armor_of_agathys or advanced_modifier({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_chaotic_armor_of_agathys:IsHidden()	return false end
function modifier_chaotic_armor_of_agathys:IsDebuff()	return false end
function modifier_chaotic_armor_of_agathys:IsStunDebuff()	return false end
function modifier_chaotic_armor_of_agathys:IsPurgable()	return true end

--------------------------------------------------------------------------------
-- Initializations
function modifier_chaotic_armor_of_agathys:OnCreated( kv )
	if IsServer() then
		local gain = self:GetAbility():GetEffectGain()
		self:SetStackCount(self:GetAbility():GetSpecialValueFor("bonus_health")*gain)
		local damage = self:GetAbility():GetSpecialValueFor("base_damage")
		if self:GetAbility():GetRuneType()==1 then
			damage = damage + self:GetAbility():GetSpecialValueFor("rune_1_bonus_damage")*self:GetCaster():HDGetPrimaryStatValue()
		end
		
		self.damageTable = {
			-- victim = keys.attacker,
			attacker = self:GetParent(),
			damage = damage*gain,
			damage_type = self:GetAbility():GetAbilityDamageType(),
			damage_flags = DOTA_DAMAGE_FLAG_REFLECTION,
			ability = self:GetAbility(), --Optional.
			hd_flags = HD_DAMAGE_FLAG_ICE_DAMAGE,
		}
	end

end
function modifier_chaotic_armor_of_agathys:OnRefresh( kv )
	if IsServer() then
		local gain = self:GetAbility():GetEffectGain()
		local bonus_health = self:GetAbility():GetSpecialValueFor("bonus_health")
		if self:GetAbility():GetRuneType()==2 then
			bonus_health = bonus_health *(1+self:GetAbility():GetSpecialValueFor("rune_2_bonus_health")*0.01)
		end
		self:SetStackCount(bonus_health*gain)
		local damage = self:GetAbility():GetSpecialValueFor("base_damage")
		if self:GetAbility():GetRuneType()==1 then
			damage = damage + self:GetAbility():GetSpecialValueFor("rune_1_bonus_damage")*self:GetCaster():HDGetPrimaryStatValue()
		end
		
		self.damageTable = {
			-- victim = keys.attacker,
			attacker = self:GetParent(),
			damage = damage*gain,
			damage_type = self:GetAbility():GetAbilityDamageType(),
			damage_flags = DOTA_DAMAGE_FLAG_REFLECTION,
			ability = self:GetAbility(), --Optional.
			hd_flags = HD_DAMAGE_FLAG_ICE_DAMAGE,
		}
	end

end




function modifier_chaotic_armor_of_agathys:ADDeclareFunctions()
    return 
    {

		-- 临时生命值需要组合使用
		MODIFIER_SPECIAL_Temporary_Health_Points = {nil, self:GetParent()},
		advanced_MODIFIER_PROPERTY_TEMPORARY_HEALTH,


    }
end


function modifier_chaotic_armor_of_agathys:AdvancedGetModifierTemporaryHealth(keys)
	local stack = self:GetStackCount()
	-- 作为临时生命值加成效果时直接返回
	if keys.temporaryHealthLogic then
		return stack
	end
	if IsClient() then
		return 0
	end
    if stack <= 0 then
        self:SafeDestroy()
        return 0
    end
    if keys.damage > self:GetStackCount() then
        self:SetStackCount(0)
    else
        self:SetStackCount(self:GetStackCount() - math.max(0, keys.damage))
        stack = keys.damage

		self:PlayEffect(keys.attacker)
		self.damageTable.victim = keys.attacker
		if self:GetAbility():GetRuneType()==3 then
			keys.attacker:AddNewModifier(self:GetCaster(),self:GetAbility(),"modifier_chaotic_armor_of_agathys_rune_3",{duration = self:GetAbility():GetSpecialValueFor("rune_3_silence")})
		else
			ApplyDamage(self.damageTable)
		end
    end
    return stack

end

function modifier_chaotic_armor_of_agathys:PlayEffect(target)

	local effect_cast1 = ParticleManager:CreateParticle( "particles/econ/items/drow/drow_arcana/drow_arcana_marksmanship_frost_flash.vpcf", PATTACH_CUSTOMORIGIN, target )
	ParticleManager:SetParticleControlForward( effect_cast1,3, CalculateDirection(self:GetCaster(),target) )
	ParticleManager:SetParticleControlEnt(effect_cast1, 3, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
	-- ParticleManager:SetParticleControl( effect_cast1, 2, pos )
	-- ParticleManager:SetParticleControl( effect_cast1, 3, pos )
	DestroyParticleByDelay(effect_cast1,4)
	target:EmitSound("Hero_DrowRanger.FrostArrows")
end

--------
modifier_chaotic_armor_of_agathys_rune_3 = modifier_chaotic_armor_of_agathys_rune_3 or advanced_modifier({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_chaotic_armor_of_agathys_rune_3:IsHidden()	return false end
function modifier_chaotic_armor_of_agathys_rune_3:IsDebuff()	return true end
function modifier_chaotic_armor_of_agathys_rune_3:IsStunDebuff()	return false end
function modifier_chaotic_armor_of_agathys_rune_3:IsPurgable()	return false end
function modifier_chaotic_armor_of_agathys_rune_3:CheckState()
	return{
		[MODIFIER_STATE_PASSIVES_DISABLED] = true,
		[MODIFIER_STATE_SILENCED] = true,
	}
end