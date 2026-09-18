LinkLuaModifier("modifier_chaotic_Grease_thinker", "chaotic_spell/class_1/chaotic_Grease", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chaotic_Grease_debuff", "chaotic_spell/class_1/chaotic_Grease", LUA_MODIFIER_MOTION_NONE)





chaotic_Grease = class({})



function chaotic_Grease:GetCooldown(iLevel)

	return self:GetSpecialValueFor("cooldown_time")
end




function chaotic_Grease:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/chaotic_spell/chaotic_grease/effect_earth/effect.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_batrider/batrider_stickynapalm_debuff.vpcf", context )
end
function chaotic_Grease:GetAOERadius()
	local radius = self:GetSpecialValueFor("radius")
	if self:GetRuneType()==2 then
		radius = radius*(1+self:GetSpecialValueFor("rune_2_bonus_radius")*0.01)
	end
	return radius
end

function chaotic_Grease:GetManaCost(iLevel)
	local cost = self.BaseClass.GetManaCost(self,iLevel)
	cost = cost * self:GetManaCostGain()
	return cost
end




function chaotic_Grease:OnSpellStart()
	local caster = self:GetCaster()
	local pos = self:GetCursorPosition()
	-- local pos = caster:GetOrigin()+Vector(0,0,64)
	-- local effect_cast1 = ParticleManager:CreateParticle( "particles/rebuild/chaotic_spell/chaotic_Grease/cast_effect/effect_th_cast.vpcf", PATTACH_CUSTOMORIGIN, target )
	-- ParticleManager:SetParticleControl( effect_cast1, 0, pos )
	-- DestroyParticleByDelay(effect_cast1,5)
	CreateModifierThinker(caster, self, "modifier_chaotic_Grease_thinker", {duration = self:GetSpecialValueFor("duration")}, pos, caster:GetTeamNumber(), false)
end


function chaotic_Grease:PlayEffect(target)
	local effect_cast1 = ParticleManager:CreateParticle( "particles/rebuild/chaotic_spell/chaotic_Grease/target/effect.vpcf", PATTACH_CUSTOMORIGIN, target )
	ParticleManager:SetParticleControlEnt( effect_cast1, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc" ,Vector(0,0,0), true )
	ParticleManager:ReleaseParticleIndex(effect_cast1)
	target:EmitSound("chaotic_Grease_target")
end



-------------------------------------

modifier_chaotic_Grease_thinker = advanced_modifier({})

function modifier_chaotic_Grease_thinker:IsAura()return true end
function modifier_chaotic_Grease_thinker:OnCreated(keys)
	self:GetParent().modifier_chaotic_Grease_thinker = self
	self.gain = self:GetAbility():GetEffectGain()
	if IsServer() then

		self.radius = self:GetAbility():GetSpecialValueFor("radius")
		if self:GetAbility():GetRuneType()==2 then
			self.radius = self.radius*(1+self:GetAbility():GetSpecialValueFor("rune_2_bonus_radius")*0.01)
		end

		local parent = self:GetParent()
		parent:EmitSound("Hero_Clinkz.TarBomb.Target")

		self.particle = ParticleManager:CreateParticle("particles/rebuild/chaotic_spell/chaotic_grease/effect_earth/effect.vpcf", PATTACH_POINT_FOLLOW, parent)
		ParticleManager:SetParticleControlEnt( self.particle, 0, parent, PATTACH_POINT_FOLLOW, "attach_hitloc" ,Vector(0,0,0), true )
		ParticleManager:SetParticleControlEnt( self.particle,3, parent, PATTACH_POINT_FOLLOW, "attach_hitloc" ,Vector(0,0,0), true )
		ParticleManager:SetParticleControl(self.particle,5,Vector(self.radius,1,1))
		ParticleManager:SetParticleControl(self.particle,10,Vector(self:GetRemainingTime(),1,1))
		self:AddParticle(self.particle, false, false, -1, false, false)
		-- DestroyParticleByDelay(particle,13)
		self:StartIntervalThink(1)
	end
end
function modifier_chaotic_Grease_thinker:OnDestroy(keys)
	if IsServer() then
		ParticleManager:DestroyParticle(self.particle,false)
		UTIL_Remove(self:GetParent())
	end
end
function modifier_chaotic_Grease_thinker:OnIntervalThink()
	if not self:GetAbility() then
		self:Destroy()
	end
end


function modifier_chaotic_Grease_thinker:GetAuraRadius()return self.radius end
function modifier_chaotic_Grease_thinker:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_chaotic_Grease_thinker:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_BOTH end
function modifier_chaotic_Grease_thinker:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_chaotic_Grease_thinker:GetAuraDuration() return 0.05 end
function modifier_chaotic_Grease_thinker:GetModifierAura()return "modifier_chaotic_Grease_debuff" end
function modifier_chaotic_Grease_thinker:GetAuraEntityReject(hEntity)
	if self:GetAbility() and self:GetAbility():GetRuneType()==2 then
		if hEntity:GetTeamNumber() == self:GetCaster():GetTeamNumber() then
			return false
		end
	end
	if hEntity:IsImmuneDisadvantagedTerrain() then
		-- 免疫劣势地形影响
		return true
	end
	if hEntity:IsImmuneDisadvantagedTerrain_Slow() then
		return true
	end
	return false
end
function modifier_chaotic_Grease_thinker:GetGain()
	return self.gain
end
function modifier_chaotic_Grease_thinker:FireBallTrigger()
	self:Destroy()
end
-- self.gain


modifier_chaotic_Grease_debuff = advanced_modifier({})

function modifier_chaotic_Grease_debuff:IsHidden() 			return false end
function modifier_chaotic_Grease_debuff:IsPurgable() 			return false end
function modifier_chaotic_Grease_debuff:IsPurgeException() 	return false end
function modifier_chaotic_Grease_debuff:IsDebuff() return true end
function modifier_chaotic_Grease_debuff:GetEffectName() return "particles/units/heroes/hero_batrider/batrider_stickynapalm_debuff.vpcf" end

function modifier_chaotic_Grease_debuff:OnCreated(keys)
	local owner = self:GetAuraOwner()
	local gain = 1
	if owner then
		local modifier = owner.modifier_chaotic_Grease_thinker
		
		if IsValid(modifier) then
			-- print("123")
			gain = modifier:GetGain()
		end
		-- print("222")
	end
	if not self:GetAbility() then
		return
	end

	self.move_speed_reduction = self:GetAbility():GetSpecialValueFor("move_slow") * gain
	self.rune_1_attack_slow = self:GetAbility():GetSpecialValueFor("rune_1_attack_slow")
	self.rune_3_bonus_damage = self:GetAbility():GetSpecialValueFor("rune_3_bonus_damage")
	if self:GetAbility():GetRuneType()==3 then
		self.move_speed_reduction = self.move_speed_reduction * (1+self:GetAbility():GetSpecialValueFor("rune_3_move_down")*0.01)
	end
end

function modifier_chaotic_Grease_debuff:DeclareFunctions()
	local funcs =  {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,         --移动速度
		MODIFIER_PROPERTY_TOOLTIP,
	}
	if self:GetAbility():GetRuneType()==1 then
		table.insert(funcs,MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT)
	end
    return funcs
end

function modifier_chaotic_Grease_debuff:ADDeclareFunctions()
	local funcs =  {}
	if self:GetAbility():GetRuneType()==3 then
		table.insert(funcs,advanced_MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE)
	end
    return funcs
end

function modifier_chaotic_Grease_debuff:GetModifierMoveSpeedBonus_Constant() 
	if self:GetAbility():GetRuneType()==2 then
		if self:GetParent():GetTeamNumber() == self:GetCaster():GetTeamNumber() then
			return self.move_speed_reduction
		end
	end
	return   -self.move_speed_reduction 
end

function modifier_chaotic_Grease_debuff:OnTooltip() return self:GetModifierMoveSpeedBonus_Constant() end

function modifier_chaotic_Grease_debuff:GetModifierAttackSpeedBonus_Constant() 
	return -self.rune_1_attack_slow
end

function modifier_chaotic_Grease_debuff:Advanced_GetModifierDamageOutgoing_Percentage()
	return self.rune_3_bonus_damage
end



