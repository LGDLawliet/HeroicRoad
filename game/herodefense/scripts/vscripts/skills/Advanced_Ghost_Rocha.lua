
Advanced_Ghost_Rocha = class({})

LinkLuaModifier("modifier_Advanced_Ghost_Rocha_thinker", "skills/Advanced_Ghost_Rocha", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Ghost_Rocha_effect", "skills/Advanced_Ghost_Rocha", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Ghost_Rocha_nosoul", "skills/Advanced_Ghost_Rocha", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_noheal", "skills/Middle_Ghost_Rocha", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_losevision", "skills/Middle_Ghost_Rocha", LUA_MODIFIER_MOTION_NONE)

function Advanced_Ghost_Rocha:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/spell/rochaghost_purimn/ring.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/spell/ghost_rocha/rochaecon/items/arc_warden/arc_warden_ti9_immortal/arc_warden_ti9_wraith.vpcf", context )
end
function Advanced_Ghost_Rocha:UnlockFirstCore(key)
	return false
end
function Advanced_Ghost_Rocha:UnlockSecondCore(key)
	return false
end
function Advanced_Ghost_Rocha:UnlockThirdCore(key)
	return false
end
function Advanced_Ghost_Rocha:CheckKV(key)
	local table = {
        chance = 0.2,
	}
	local value = table[key] or -1
	return value
end

function Advanced_Ghost_Rocha:IsHiddenWhenStolen() 	return false end
function Advanced_Ghost_Rocha:IsRefreshable() 		return false end
function Advanced_Ghost_Rocha:IsStealable() 			return true end

function Advanced_Ghost_Rocha:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end

function Advanced_Ghost_Rocha:OnSpellStart()
	if not IsServer() then
		do return end
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
                enemy:AddNewModifier(self:GetCaster(), ability, "modifier_Advanced_Ghost_Rocha_nosoul", {duration = 3})
            end
        end)
    end

	local thinker =CreateModifierThinker(
		self:GetCaster(),
		self,
		"modifier_Advanced_Ghost_Rocha_thinker",
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
modifier_Advanced_Ghost_Rocha_thinker = advanced_modifier({})

function modifier_Advanced_Ghost_Rocha_thinker:OnCreated(params)
	if IsServer() then
		self.radius = params.radius

		self.effect_cast = ParticleManager:CreateParticle( "particles/rebuild/spell/rochaghost_purimn/ring.vpcf", PATTACH_CUSTOMORIGIN, self:GetParent() )
		ParticleManager:SetParticleControl( self.effect_cast, 0, self:GetParent():GetAbsOrigin()  )
		ParticleManager:SetParticleControl( self.effect_cast, 1, Vector(self.radius, self.radius, self.radius) )
		ParticleManager:SetParticleControl( self.effect_cast, 60, Vector(153, 8, 153) )
		ParticleManager:SetParticleControl( self.effect_cast, 61, Vector(1,0, 0) )
    
		self.effect_cast2 = ParticleManager:CreateParticle( "particles/rebuild/spell/ghost_rocha/rochaecon/items/arc_warden/arc_warden_ti9_immortal/arc_warden_ti9_wraith.vpcf", PATTACH_CUSTOMORIGIN, self:GetParent() )
		ParticleManager:SetParticleControl( self.effect_cast2, 0, self:GetParent():GetAbsOrigin() + Vector(0,0,65) )
		ParticleManager:SetParticleControl( self.effect_cast2, 1, Vector(self.radius, self.radius, self.radius) )
		self:StartIntervalThink(1)
	end
end

function modifier_Advanced_Ghost_Rocha_thinker:OnIntervalThink()
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
		enemy:AddNewModifier(self:GetCaster(), ability, "modifier_Advanced_Ghost_Rocha_effect", {duration = 1.1})
	end
end

function modifier_Advanced_Ghost_Rocha_thinker:OnDestroy(params)
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
modifier_Advanced_Ghost_Rocha_effect = advanced_modifier({})

function modifier_Advanced_Ghost_Rocha_effect:IsHidden() 	return false end
function modifier_Advanced_Ghost_Rocha_effect:IsDebuff() 		return true end
function modifier_Advanced_Ghost_Rocha_effect:IsPurgable() 			return false end

function modifier_Advanced_Ghost_Rocha_effect:OnCreated()
    self.move_down = self:GetAbility():GetSpecialValueFor("move_down")
	self.interval = self:GetAbility():GetSpecialValueFor("interval")
	self.chance = self:GetAbility():GetSpecialValueFor("chance")
	self.nega_duration = self:GetAbility():GetSpecialValueFor("nega_duration")

	self.advanced_level = self:GetAbility():GetSpecialValueFor("advanced_level")
	if IsServer() then
		self:StartIntervalThink(self.interval)
	end
	--LV5封印解除+
	if self.advanced_level >= 5 then
		self.chance = self.chance + 15
	end
	--LV20御鬼之极
	if self.advanced_level >= 20 then
		self.nega_duration = self.nega_duration *1.2
	end
end 

function modifier_Advanced_Ghost_Rocha_effect:ADDeclareFunctions()
	return{
		MODIFIER_EVENT_ON_DEATH = {nil,self:GetParent()}
	}
end

function modifier_Advanced_Ghost_Rocha_effect:OnDeath(keys)
	if not IsServer() then
		return
	end
	local enemies = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),	
		self:GetParent():GetOrigin(),
		nil,	
		1200,	
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE,	
		FIND_CLOSEST,	
		false	
	)
	for _,enemy in pairs(enemies) do
		--LV15蔓延的绝望+
		if self.advanced_level >= 15 then
			self.chance = 100
		end
		if self.chance >= RandomInt(1, 100) then
		
		local random = RandomInt(1, 6)
		if random == 1 then
			local ModifierStatusNegativeGain = self:GetCaster():GetModifierStatusNegativeGainIndex(0.2)
			local StatusResistance =  enemy:GetHDStatusResistanceIndex(0.9)*ModifierStatusNegativeGain
			enemy:AddNewModifier(self:GetCaster(),self:GetAbility(),"modifier_stunned",{duration = self.nega_duration*StatusResistance})
		end
		if random == 2 then
			local ModifierStatusNegativeGain = self:GetCaster():GetModifierStatusNegativeGainIndex(0.2)
			local StatusResistance =  enemy:GetHDStatusResistanceIndex(0.9)*ModifierStatusNegativeGain
			enemy:AddNewModifier(self:GetCaster(),self:GetAbility(),"modifier_rooted",{duration = self.nega_duration*StatusResistance})
		end
		if random == 3 then
			local ModifierStatusNegativeGain = self:GetCaster():GetModifierStatusNegativeGainIndex(0.2)
			local StatusResistance =  enemy:GetHDStatusResistanceIndex(0.9)*ModifierStatusNegativeGain
			enemy:AddNewModifier(self:GetCaster(),self:GetAbility(),"modifier_silence",{duration = self.nega_duration*StatusResistance})
		end
		if random == 4 then
			local ModifierStatusNegativeGain = self:GetCaster():GetModifierStatusNegativeGainIndex(0.2)
			local StatusResistance =  enemy:GetHDStatusResistanceIndex(0.9)*ModifierStatusNegativeGain
			enemy:AddNewModifier(self:GetCaster(),self:GetAbility(),"modifier_disarmed",{duration = self.nega_duration*StatusResistance})
		end
		if random == 5 then
			local ModifierStatusNegativeGain = self:GetCaster():GetModifierStatusNegativeGainIndex(0.2)
			local StatusResistance =  enemy:GetHDStatusResistanceIndex(0.9)*ModifierStatusNegativeGain
			enemy:AddNewModifier(self:GetCaster(),self:GetAbility(),"modifier_noheal",{duration = self.nega_duration*StatusResistance})
		end
		if random == 6 then
			local ModifierStatusNegativeGain = self:GetCaster():GetModifierStatusNegativeGainIndex(0.2)
			local StatusResistance =  enemy:GetHDStatusResistanceIndex(0.9)*ModifierStatusNegativeGain
			enemy:AddNewModifier(self:GetCaster(),self:GetAbility(),"modifier_losevision",{duration = self.nega_duration*StatusResistance})
		end

		end
		break
	end
end

function modifier_Advanced_Ghost_Rocha_effect:OnIntervalThink()
	if self.chance >= RandomInt(1, 100) then
		self:Randomnega()
	end
end

function modifier_Advanced_Ghost_Rocha_effect:Randomnega()
	local random = RandomInt(1, 6)
	if random == 1 then
		local ModifierStatusNegativeGain = self:GetCaster():GetModifierStatusNegativeGainIndex(0.2)
		local StatusResistance =  self:GetParent():GetHDStatusResistanceIndex(0.9)*ModifierStatusNegativeGain
		self:GetParent():AddNewModifier(self:GetCaster(),self:GetAbility(),"modifier_stunned",{duration = self.nega_duration*StatusResistance})
	end
	if random == 2 then
		local ModifierStatusNegativeGain = self:GetCaster():GetModifierStatusNegativeGainIndex(0.2)
		local StatusResistance =  self:GetParent():GetHDStatusResistanceIndex(0.9)*ModifierStatusNegativeGain
		self:GetParent():AddNewModifier(self:GetCaster(),self:GetAbility(),"modifier_rooted",{duration = self.nega_duration*StatusResistance})
	end
	if random == 3 then
		local ModifierStatusNegativeGain = self:GetCaster():GetModifierStatusNegativeGainIndex(0.2)
		local StatusResistance =  self:GetParent():GetHDStatusResistanceIndex(0.9)*ModifierStatusNegativeGain
		self:GetParent():AddNewModifier(self:GetCaster(),self:GetAbility(),"modifier_silence",{duration = self.nega_duration*StatusResistance})
	end
	if random == 4 then
		local ModifierStatusNegativeGain = self:GetCaster():GetModifierStatusNegativeGainIndex(0.2)
		local StatusResistance =  self:GetParent():GetHDStatusResistanceIndex(0.9)*ModifierStatusNegativeGain
		self:GetParent():AddNewModifier(self:GetCaster(),self:GetAbility(),"modifier_disarmed",{duration = self.nega_duration*StatusResistance})
	end
	if random == 5 then
		local ModifierStatusNegativeGain = self:GetCaster():GetModifierStatusNegativeGainIndex(0.2)
		local StatusResistance =  self:GetParent():GetHDStatusResistanceIndex(0.9)*ModifierStatusNegativeGain
		self:GetParent():AddNewModifier(self:GetCaster(),self:GetAbility(),"modifier_noheal",{duration = self.nega_duration*StatusResistance})
	end
	if random == 6 then
		local ModifierStatusNegativeGain = self:GetCaster():GetModifierStatusNegativeGainIndex(0.2)
		local StatusResistance =  self:GetParent():GetHDStatusResistanceIndex(0.9)*ModifierStatusNegativeGain
		self:GetParent():AddNewModifier(self:GetCaster(),self:GetAbility(),"modifier_losevision",{duration = self.nega_duration*StatusResistance})
	end
end

function modifier_Advanced_Ghost_Rocha_effect:DeclareFunctions()
    return{
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
    }
end

function modifier_Advanced_Ghost_Rocha_effect:GetModifierMoveSpeedBonus_Constant()
    return -self.move_down
end
function modifier_Advanced_Ghost_Rocha_effect:GetModifierMoveSpeedBonus_Percentage()
	--LV10前路渺茫
	if self.advanced_level >= 10 then
		return -20
	end
    return 0
end
------------------------------------------------------
------------------------------------------------------
modifier_Advanced_Ghost_Rocha_nosoul = advanced_modifier({})

function modifier_Advanced_Ghost_Rocha_nosoul:IsHidden() 	return false end
function modifier_Advanced_Ghost_Rocha_nosoul:IsDebuff() 		return true end
function modifier_Advanced_Ghost_Rocha_nosoul:IsPurgable() 			return false end
function modifier_Advanced_Ghost_Rocha_nosoul:RemoveOnDeath() 			return false end