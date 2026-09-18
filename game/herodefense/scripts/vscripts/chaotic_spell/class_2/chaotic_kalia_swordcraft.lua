chaotic_kalia_swordcraft = class({})
LinkLuaModifier("modifier_chaotic_kalia_swordcraft", "chaotic_spell/class_2/chaotic_kalia_swordcraft", LUA_MODIFIER_MOTION_NONE)

function chaotic_kalia_swordcraft:GetIntrinsicModifierName() return "modifier_chaotic_kalia_swordcraft" end


function chaotic_kalia_swordcraft:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/chaotic_spell/chaotic_kalia_swordcraft/effect_cast/kalia_swordcraft.vpcf", context )
	PrecacheResource( "particle", "particles/econ/items/sven/sven_ti7_sword/sven_ti7_sword_spell_great_cleave.vpcf", context )
end



modifier_chaotic_kalia_swordcraft = advanced_modifier({})

function modifier_chaotic_kalia_swordcraft:IsDebuff()			return false end
function modifier_chaotic_kalia_swordcraft:IsHidden() 		return true end
function modifier_chaotic_kalia_swordcraft:IsPurgable() 		return false end
function modifier_chaotic_kalia_swordcraft:IsPurgeException() return false end

function modifier_chaotic_kalia_swordcraft:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
	}
	if self:GetAbility():GetRuneType() == 1 then
		table.insert(funcs,MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT)
	end
	return funcs
end
function modifier_chaotic_kalia_swordcraft:GetModifierAttackSpeedBonus_Constant()return self.rune_1_bonus end

function modifier_chaotic_kalia_swordcraft:ADDeclareFunctions()
    local funcs = 
    {
        MODIFIER_EVENT_ON_ATTACK_LANDED = {self:GetParent(),nil},
        advanced_MODIFIER_PROPERTY_CRITICALSTRIKE,
        MODIFIER_EVENT_ON_ATTACK_RECORD_DESTROY = {self:GetParent(),nil},
        advanced_MODIFIER_PROPERTY_PhysicalCriticalAmp,
    }

	if self:GetAbility():GetRuneType() == 3 then
		table.insert(funcs,advanced_MODIFIER_PROPERTY_ARMOR_IGNORE)
	end

	return funcs
end

function modifier_chaotic_kalia_swordcraft:OnCreated() 
    self.crit_mult = self:GetAbility():GetSpecialValueFor("crit_bonus")
	self.rune_1_bonus = self:GetAbility():GetSpecialValueFor("rune_1_bonus")
    if IsServer() then
        self.crit = {}
        self.crit_pct = self:GetAbility():GetSpecialValueFor("crit_chance")
        self.crit_damage = self:GetAbility():GetSpecialValueFor("crit_damage")
    end
end

function modifier_chaotic_kalia_swordcraft:OnRefresh() 
    self.crit_mult = self:GetAbility():GetSpecialValueFor("crit_bonus")
	self.rune_1_bonus = self:GetAbility():GetSpecialValueFor("rune_1_bonus")
    if IsServer() then
        self.crit = {}
        self.crit_pct = self:GetAbility():GetSpecialValueFor("crit_chance")
        self.crit_damage = self:GetAbility():GetSpecialValueFor("crit_damage")
    end
end

function modifier_chaotic_kalia_swordcraft:Advanced_GetModifierAttackArmor_Ignore()
	if self:GetAbility():GetRuneType()==3 then
		return self:GetAbility():GetSpecialValueFor("rune_3_no_armor")
	end
	return
end

function modifier_chaotic_kalia_swordcraft:OnAttackFail(keys) self.crit[keys.record] = nil end


function modifier_chaotic_kalia_swordcraft:OnAttackLanded(keys)
	if not IsServer() then
		return
	end

	local caster = self:GetParent()
	if self.crit[keys.record] then
		--local pfx_name2 = "particles/rebuild/spell/chaotic_kalia_swordcraft_11.vpcf"
		local pfx_name2 = "particles/rebuild/chaotic_spell/chaotic_kalia_swordcraft/effect_cast/kalia_swordcraft.vpcf"
        --怪物周边粒子特效
		local pfx2 = ParticleManager:CreateParticle(pfx_name2, PATTACH_ABSORIGIN, caster)
		ParticleManager:SetParticleControlEnt(pfx2, 0, caster, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
		ParticleManager:SetParticleControl(pfx2, 1, caster:GetAbsOrigin())
		ParticleManager:SetParticleControlOrientation(pfx2, 1, caster:GetForwardVector(), Vector(0, 0, 0),  Vector(0, 0, 0))
		ParticleManager:ReleaseParticleIndex(pfx2)

        caster:EmitSound("chaotic_kalia_swordcraft_hit")
	end
	

	--巨力挥舞部分，真分裂，物理，完全等额伤害
	if self:GetAbility():GetRuneType()==2 then
		local random = math.random
		local ability = self:GetAbility()
		if not self:GetAbility():IsCooldownReady() or not self.crit[keys.record] then
			return
		end
		if keys.attacker:IsDisableCleave() then
			return
		end
		if keys.attacker ~= caster or keys.target:IsBuilding() or keys.target:IsOther() or caster:PassivesDisabled() or not keys.target:IsAlive() then
			return
		end
		local dmg = keys.damage *ability:GetSpecialValueFor("rune_2_cleave")*0.01
		local pfx = "particles/econ/items/sven/sven_ti7_sword/sven_ti7_sword_spell_great_cleave.vpcf"
		DoIMBACleaveAttack(caster, keys.target, ability, dmg, 50,575, 550, pfx)
		self:GetAbility():StartCooldown(self:GetAbility():GetSpecialValueFor("rune_2_cd"))
	end

	self.crit[keys.record] = nil
end

function modifier_chaotic_kalia_swordcraft:Advanced_GetModifierCriticalStrike(keys)

    -- print("aaaa")
	if IsServer() and keys.attacker == self:GetParent() and not keys.target:IsBuilding() and not keys.target:IsOther()
	 and not self:GetParent():PassivesDisabled() then
		if self.crit_pct >= RandomInt(1,100) then

			self.crit[keys.record] = true
			return self.crit_damage
		end
	end
end

function modifier_chaotic_kalia_swordcraft:OnAttackRecordDestroy(keys)
	if self.crit[keys.record] then
        self.crit[keys.record] = nil
    end
end




function modifier_chaotic_kalia_swordcraft:Advanced_GetModifier_PhysicalCriticalAmp(keys)
	return self.crit_mult
end



