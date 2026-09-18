
Advanced_Ghost_Saya = class({})

LinkLuaModifier("modifier_Advanced_Ghost_Saya_thinker", "skills/Advanced_Ghost_Saya", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Ghost_Saya_frozen", "skills/Advanced_Ghost_Saya", LUA_MODIFIER_MOTION_NONE)

function Advanced_Ghost_Saya:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/spell/sayaghost_purimn/ring.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/spell/ghost_saya/Sayaecon/items/arc_warden/arc_warden_ti9_immortal/arc_warden_ti9_wraith.vpcf", context )
	PrecacheResource( "particle", "particles/generic_gameplay/generic_frozen.vpcf", context )
end
function Advanced_Ghost_Saya:UnlockFirstCore(key)
	return false
end
function Advanced_Ghost_Saya:UnlockSecondCore(key)
	return false
end
function Advanced_Ghost_Saya:UnlockThirdCore(key)
	return false
end
function Advanced_Ghost_Saya:CheckKV(key)
	local table = {
		damage = 9,
        bonus_damage = 0.09,
        chance = 0.8,
	}
	local value = table[key] or -1
	return value
end

function Advanced_Ghost_Saya:IsHiddenWhenStolen() 	return false end
function Advanced_Ghost_Saya:IsRefreshable() 		return false end
function Advanced_Ghost_Saya:IsStealable() 			return true end

function Advanced_Ghost_Saya:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end

function Advanced_Ghost_Saya:OnSpellStart()
	if not IsServer() then
		return
	end

	local caster = self:GetCaster()
	local pos = self:GetCursorPosition()

	--LV20御鬼之极
    if self.advanced_level >= 20 then
        self:GetCaster():GameTimer(1.7,function()
            local enemies = FindUnitsInRadius(
            self:GetCaster():GetTeamNumber(),	
            pos,
            nil,	
            self:GetSpecialValueFor("radius"),	
            DOTA_UNIT_TARGET_TEAM_ENEMY,
            DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	
            DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE,	
            FIND_ANY_ORDER,	
            false	
            )
            for _,enemy in pairs(enemies) do
                local modifier = enemy:FindModifierByName("modifier_creep_special_gain_enraged_buff")
				if modifier then
					enemy:RemoveModifierByName("modifier_creep_special_gain_enraged_buff")
				end
            end
        end)
    end

	local thinker =CreateModifierThinker(
		self:GetCaster(),
		self,
		"modifier_Advanced_Ghost_Saya_thinker",
		{
			duration = self:GetSpecialValueFor("duration"),
			radius = self:GetSpecialValueFor("radius"),
		},
		pos,
		self:GetCaster():GetTeamNumber(),
		false
	)
	caster:EmitSound("Hero_ArcWarden.SparkWraith.Cast")	
	caster:EmitSound("Hero_ArcWarden.SparkWraith.Activate")	
end

------------------------------------------------------
modifier_Advanced_Ghost_Saya_thinker = advanced_modifier({})

function modifier_Advanced_Ghost_Saya_thinker:OnCreated(params)
	if IsServer() then
		self.radius = params.radius
		self.chance = self:GetAbility():GetSpecialValueFor("chance")
		self.interval = self:GetAbility():GetSpecialValueFor("interval")
		self.advanced_level = self:GetAbility():GetSpecialValueFor("advanced_level")

		--LV20御鬼之极
		if self.advanced_level >= 20 then
			self.interval = self.interval *0.7
		end

		self.effect_cast = ParticleManager:CreateParticle( "particles/rebuild/spell/sayaghost_purimn/ring.vpcf", PATTACH_CUSTOMORIGIN, self:GetParent() )
		ParticleManager:SetParticleControl( self.effect_cast, 0, self:GetParent():GetAbsOrigin()  )
		ParticleManager:SetParticleControl( self.effect_cast, 1, Vector(self.radius, self.radius, self.radius) )
		ParticleManager:SetParticleControl( self.effect_cast, 60, Vector(0, 234, 230) )
		ParticleManager:SetParticleControl( self.effect_cast, 61, Vector(1,0, 0) )
    
		self.effect_cast2 = ParticleManager:CreateParticle( "particles/rebuild/spell/ghost_saya/Sayaecon/items/arc_warden/arc_warden_ti9_immortal/arc_warden_ti9_wraith.vpcf", PATTACH_CUSTOMORIGIN, self:GetParent() )
		ParticleManager:SetParticleControl( self.effect_cast2, 0, self:GetParent():GetAbsOrigin() + Vector(0,0,65) )
		ParticleManager:SetParticleControl( self.effect_cast2, 1, Vector(self.radius, self.radius, self.radius) )
		self:StartIntervalThink(self.interval)
	end
end

function modifier_Advanced_Ghost_Saya_thinker:OnIntervalThink()
	if not IsServer() then
        return
    end

	local ability = self:GetAbility()
	if not ability or ability:IsNull() then
		return
	end

	local enemies = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),	
		self:GetParent():GetOrigin(),
		nil,	
		self.radius,	
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE,	
		FIND_ANY_ORDER,	
		false	
	)

	for _,enemy in pairs(enemies) do

		self.chance = self:GetAbility():GetSpecialValueFor("chance")
		self.damage = self:GetAbility():GetSpecialValueFor("damage") + self:GetAbility():GetSpecialValueFor("bonus_damage")*self:GetCaster():GetIntellect(false)

		--LV10急速冷却
		if enemy:GetHealthPercent() >= 100 then
			self.chance = 2*self.chance
		end

		if self.chance >= RandomInt(1, 100) then
			local hp_removal = enemy:GetHealth() *(self:GetAbility():GetSpecialValueFor("advanced_damage")*0.01)

			local keys = {
				origin = hp_removal,
				limit = 100*self:GetCaster():GetIntellect(false),
				index = 20
			}
			hp_removal = SqrtPercentage(keys)
			enemy:ModifyHealth(enemy:GetHealth() - hp_removal , self:GetAbility(), false, 0)

			local ModifierStatusNegativeGain = self:GetCaster():GetModifierStatusNegativeGainIndex(0.3)
			local StatusResistance =  enemy:GetHDStatusResistanceIndex(0.8)*ModifierStatusNegativeGain
			enemy:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_Advanced_Ghost_Saya_frozen", {duration = self:GetAbility():GetSpecialValueFor("frozen_duration")*StatusResistance})
			--LV5封印解除+
			if self.advanced_level >= 5 then
				self.mp = self:GetCaster():GetMaxMana()*0.02
				self:GetCaster():GiveMana(self.mp)
			end
			--LV15刺骨寒气+
			if self.advanced_level >= 15 then
				self.damage = self.damage * 1.25
			end
		end
		
		self.damageTable = {
			victim = enemy,
			attacker = self:GetCaster(),
			ability = self:GetAbility(),
			damage = self.damage,
			damage_type = self:GetAbility():GetAbilityDamageType(),
			damage_flags = DOTA_DAMAGE_FLAG_NONE,
			--hd_flags = HD_DAMAGE_FLAG_
		}
		ApplyDamage(self.damageTable)
	end
end

function modifier_Advanced_Ghost_Saya_thinker:OnDestroy(params)
	if not IsServer() then
		return
	end
	ParticleManager:DestroyParticle(self.effect_cast, false)
	ParticleManager:ReleaseParticleIndex(self.effect_cast)
	ParticleManager:DestroyParticle(self.effect_cast2, false)
	ParticleManager:ReleaseParticleIndex(self.effect_cast2)
	UTIL_Remove( self:GetParent() )
end


------------------------------------------------------
------------------------------------------------------
modifier_Advanced_Ghost_Saya_frozen = advanced_modifier({})

function modifier_Advanced_Ghost_Saya_frozen:IsHidden() 	return false end
function modifier_Advanced_Ghost_Saya_frozen:IsDebuff() 		return true end
function modifier_Advanced_Ghost_Saya_frozen:IsPurgable() 			return false end
function modifier_Advanced_Ghost_Saya_frozen:GetEffectName() return "particles/generic_gameplay/generic_frozen.vpcf" end
function modifier_Advanced_Ghost_Saya_frozen:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end

function modifier_Advanced_Ghost_Saya_frozen:CheckState()
    return{
		[MODIFIER_STATE_FROZEN] = true,
		[MODIFIER_STATE_STUNNED] = true,
	}
end 


