LinkLuaModifier("modifier_chaotic_darkness_thinker", "chaotic_spell/class_2/chaotic_darkness", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chaotic_darkness_debuff", "chaotic_spell/class_2/chaotic_darkness", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_chaotic_darkness_debuff_root", "chaotic_spell/class_2/chaotic_darkness", LUA_MODIFIER_MOTION_NONE)




chaotic_darkness = class({})






function chaotic_darkness:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/chaotic_spell/chaotic_darkness/effect_thinker/effect.vpcf", context )

end
function chaotic_darkness:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end
function chaotic_darkness:GetCastRange(vLocation, hTarget)
	local range = self:GetSpecialValueFor("cast_range")
	if self:GetRuneType()==3 then
		range = range * (1+self:GetSpecialValueFor("rune_3_range")*0.01)
	end
	return range
end
function chaotic_darkness:OnSpellStart()
	local caster = self:GetCaster()
	local pos = self:GetCursorPosition()
	if self:GetRuneType()==3 then
		local ori_pos = caster:GetAbsOrigin()
		CreateModifierThinker(caster, self, "modifier_chaotic_darkness_thinker", {duration = self:GetSpecialValueFor("duration")}, ori_pos, caster:GetTeamNumber(), false)
		caster:SetAbsOrigin(pos)
	end
	CreateModifierThinker(caster, self, "modifier_chaotic_darkness_thinker", {duration = self:GetSpecialValueFor("duration")}, pos, caster:GetTeamNumber(), false)
end







modifier_chaotic_darkness_thinker = advanced_modifier({})

function modifier_chaotic_darkness_thinker:IsAura()return true end
function modifier_chaotic_darkness_thinker:OnCreated(keys)
	if IsServer() then
		local ability = self:GetAbility()
		self.radius = self:GetAbility():GetSpecialValueFor("radius")
		if ability:GetRuneType()==2 then
			self.radius = self.radius * (1-ability:GetSpecialValueFor("rune_2_radius")*0.01)
		end
		local parent = self:GetParent()
		parent:EmitSound("chaotic_darkness_cast")
		self.particle = ParticleManager:CreateParticle("particles/rebuild/chaotic_spell/chaotic_darkness/effect_thinker/effect.vpcf", PATTACH_POINT_FOLLOW, parent)
		ParticleManager:SetParticleControlEnt( self.particle, 0, parent, PATTACH_POINT_FOLLOW, "attach_hitloc" ,Vector(0,0,0), true )
		-- ParticleManager:SetParticleControlEnt( self.particle, 1, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc" ,Vector(0,0,0), true )
		ParticleManager:SetParticleControl( self.particle, 60, Vector(-self.radius,self.radius,0) )
		self:AddParticle(self.particle, false, false, -1, false, false)
		self:StartIntervalThink(1)
	end
end
function modifier_chaotic_darkness_thinker:OnDestroy(keys)
	if IsServer() then
		ParticleManager:DestroyParticle(self.particle,false)
		UTIL_Remove(self:GetParent())
	end
end
function modifier_chaotic_darkness_thinker:OnIntervalThink()
	if not self:GetAbility() then
		self:Destroy()
	end
end


function modifier_chaotic_darkness_thinker:GetAuraRadius()return self.radius end
function modifier_chaotic_darkness_thinker:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_chaotic_darkness_thinker:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_BOTH end
function modifier_chaotic_darkness_thinker:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_chaotic_darkness_thinker:GetAuraDuration() return 0.05 end
function modifier_chaotic_darkness_thinker:GetModifierAura()return "modifier_chaotic_darkness_debuff" end
function modifier_chaotic_darkness_thinker:GetAuraEntityReject(hEntity)
	if hEntity:IsGiant() then
		return true
	end
	return false
end



modifier_chaotic_darkness_debuff = advanced_modifier({})

function modifier_chaotic_darkness_debuff:IsHidden() 			return false end
function modifier_chaotic_darkness_debuff:IsPurgable() 			return false end
function modifier_chaotic_darkness_debuff:IsPurgeException() 	return false end
function modifier_chaotic_darkness_debuff:IsDebuff() return true end
function modifier_chaotic_darkness_debuff:OnCreated(keys)
	local ability = self:GetAbility()
	self.miss_chance = ability:GetSpecialValueFor("miss_chance")

	if ability:GetRuneType()==1 then
		self.rune_1_timer = GameRules:GetGameTime()+ability:GetSpecialValueFor("rune_1_duration")
		self.rune_1_attack_range = -ability:GetSpecialValueFor("rune_1_attack_range")
	end
	if ability:GetRuneType()==2 then
		self.miss_chance = ability:GetSpecialValueFor("rune_2_miss")
	end

end



function modifier_chaotic_darkness_debuff:DeclareFunctions()
    return 
    {
		MODIFIER_PROPERTY_TOOLTIP,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
	}
end

function modifier_chaotic_darkness_debuff:OnTooltip() return self.miss_chance end
function modifier_chaotic_darkness_debuff:GetModifierMoveSpeedBonus_Constant()
	if self:GetAbility():GetRuneType()==2 then
		return -self:GetAbility():GetSpecialValueFor("rune_2_move")
	end
	return 0
end

function modifier_chaotic_darkness_debuff:ADDeclareFunctions()
	local funcs =   {
		advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE_MUL,
		

	
    }
	if self:GetAbility():GetRuneType()==1 then
		table.insert(funcs,advanced_MODIFIER_PROPERTY_ATTACK_RANGE_BONUS)
	end
    return funcs
  
end
function modifier_chaotic_darkness_debuff:Advanced_GetModifierIncomingDamage_Percentage(keys)
	if IsServer() then
		if keys.attacker and not keys.attacker:HasModifier("modifier_chaotic_darkness_debuff") then
			if keys.attacker:IsGiant() then
				return 0
			end
			if self.miss_chance>=RandomInt(1, 100) then
				return -100
			end
		end
	end
	return 0
end
function modifier_chaotic_darkness_debuff:Advanced_GetModifierTotalDamageOutgoing_Percentage_Mul(keys)
	if IsServer() then
		if keys.target and not keys.target:HasModifier("modifier_chaotic_darkness_debuff") then
			if keys.target:IsGiant() then
				return 0
			end
			if self.miss_chance>=RandomInt(1, 100) then
				return -100
			end
		end
	end
	return 0
end


function modifier_chaotic_darkness_debuff:Advanced_GetModifierAttackRangeBonus(keys)
	if self.rune_1_timer and GameRules:GetGameTime()<=self.rune_1_timer then
		return self.rune_1_attack_range
	
	end
	return 0
end

