LinkLuaModifier("modifier_chaotic_hunger_of_hadar_thinker", "chaotic_spell/class_3/chaotic_hunger_of_hadar", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chaotic_hunger_of_hadar_debuff", "chaotic_spell/class_3/chaotic_hunger_of_hadar", LUA_MODIFIER_MOTION_NONE)





chaotic_hunger_of_hadar = class({})


function chaotic_hunger_of_hadar:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/chaotic_spell/hunger_of_hadar/effect_cast/setup.vpcf", context )
end
function chaotic_hunger_of_hadar:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end
function chaotic_hunger_of_hadar:GetManaCost(iLevel)
	local cost = self.BaseClass.GetManaCost(self,iLevel)
	cost = cost * self:GetManaCostGain()
	return cost
end



function chaotic_hunger_of_hadar:OnSpellStart()
	local caster = self:GetCaster()
	local pos = self:GetCursorPosition()
	local duration = self:GetSpecialValueFor("duration")
	if self:GetRuneType()==3 then
		duration = duration*(1+self:GetSpecialValueFor("rune_3_duration")*0.01)
	end
	caster:EmitSound("chaotic_hunger_of_hadar_cast1")
	CreateModifierThinker(caster, self, "modifier_chaotic_hunger_of_hadar_thinker", {duration = duration}, pos, caster:GetTeamNumber(), false)

end


function chaotic_hunger_of_hadar:PlayEffect(target)
	local effect_cast1 = ParticleManager:CreateParticle( "particles/rebuild/chaotic_spell/hunger_of_hadar/effect_cast/setup.vpcf", PATTACH_CUSTOMORIGIN, target )
	ParticleManager:SetParticleControlEnt( effect_cast1, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc" ,Vector(0,0,0), true )
	ParticleManager:ReleaseParticleIndex(effect_cast1)
	target:EmitSound("chaotic_hunger_of_hadar_target")
end





modifier_chaotic_hunger_of_hadar_thinker = advanced_modifier({})

function modifier_chaotic_hunger_of_hadar_thinker:IsAura()return true end
function modifier_chaotic_hunger_of_hadar_thinker:OnCreated(keys)
	self.rune_3_duration = self:GetAbility():GetSpecialValueFor("rune_3_duration")
	self.interval = 1
	
	self.team = DOTA_UNIT_TARGET_TEAM_BOTH
	if self:GetAbility():GetRuneType()==1 then
		self.team = DOTA_UNIT_TARGET_TEAM_ENEMY
	end
	
	if IsServer() then

		self.radius = self:GetAbility():GetSpecialValueFor("radius")
		local parent = self:GetParent()
		parent:EmitSound("chaotic_hunger_of_hadar_cast2")

		self.particle = ParticleManager:CreateParticle("particles/rebuild/chaotic_spell/hunger_of_hadar/effect_cast/setup.vpcf", PATTACH_POINT_FOLLOW, parent)
		ParticleManager:SetParticleControlEnt( self.particle, 0, parent, PATTACH_POINT_FOLLOW, "attach_hitloc" ,Vector(0,0,0), true )
		ParticleManager:SetParticleControl( self.particle, 1, Vector(self.radius,self.radius,self.radius) )
		ParticleManager:SetParticleControlEnt( self.particle, 3, parent, PATTACH_POINT_FOLLOW, "attach_hitloc" ,Vector(0,0,0), true )
		self:AddParticle(self.particle, false, false, -1, false, false)
		-- DestroyParticleByDelay(particle,13)
		self:StartIntervalThink(self.interval)
	end
end
function modifier_chaotic_hunger_of_hadar_thinker:OnDestroy(keys)
	if IsServer() then
		ParticleManager:DestroyParticle(self.particle,false)
		UTIL_Remove(self:GetParent())
	end
end
function modifier_chaotic_hunger_of_hadar_thinker:OnIntervalThink()
	if not self:GetAbility() then
		self:Destroy()
	end
end


function modifier_chaotic_hunger_of_hadar_thinker:GetAuraRadius()return self.radius end
function modifier_chaotic_hunger_of_hadar_thinker:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_chaotic_hunger_of_hadar_thinker:GetAuraSearchTeam() return self.team end
function modifier_chaotic_hunger_of_hadar_thinker:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_chaotic_hunger_of_hadar_thinker:GetAuraDuration() return 0.05 end
function modifier_chaotic_hunger_of_hadar_thinker:GetModifierAura()return "modifier_chaotic_hunger_of_hadar_debuff" end
-- function modifier_chaotic_hunger_of_hadar_thinker:GetAuraEntityReject(hEntity)
-- 	if hEntity:IsImmuneDisadvantagedTerrain() then
-- 		-- 免疫劣势地形影响
-- 		return true
-- 	end
-- 	return false
-- end


-- 



modifier_chaotic_hunger_of_hadar_debuff = advanced_modifier({})

function modifier_chaotic_hunger_of_hadar_debuff:IsHidden() 			return false end
function modifier_chaotic_hunger_of_hadar_debuff:IsPurgable() 			return false end
function modifier_chaotic_hunger_of_hadar_debuff:IsPurgeException() 	return false end
function modifier_chaotic_hunger_of_hadar_debuff:IsDebuff() return true end
function modifier_chaotic_hunger_of_hadar_debuff:OnCreated(keys)
	if not self:GetAbility() then return end
	
	local gain = self:GetAbility():GetEffectGain()
	self.move_speed_reduction = -self:GetAbility():GetSpecialValueFor("move_slow") * gain
	self.miss = self:GetAbility():GetSpecialValueFor("miss")
	self.rune_2_magic_res = self:GetAbility():GetSpecialValueFor("rune_2_magic_res")
	self.interval = 1
	if not IsEnemy(self:GetParent(),self:GetCaster()) then
		self.rune_1_dark_incoming = 0
		return
	end
	self.rune_1_dark_incoming = self:GetAbility():GetSpecialValueFor("rune_1_dark_incoming")
	
	if self:GetAbility():GetRuneType()==3 then
		self.interval = self:GetAbility():GetSpecialValueFor("rune_3_interval")
	end
	if IsServer() then
		if self:GetAbility():GetRuneType() == 2 then
			return
		end
		self.base_damage = self:GetAbility():GetSpecialValueFor("base_damage")*gain
		self.bonus_damage = self:GetAbility():GetSpecialValueFor("bonus_damage")*gain
		self.damageTable = {
			attacker	= self:GetCaster(),
			victim = self:GetParent(),
			-- damage		= self:GetSpecialValueFor("base_damage") + caster:HDGetPrimaryStatValue()*self:GetSpecialValueFor("bonus_damage"),
			damage_type	= self:GetAbility():GetAbilityDamageType(),
			ability		= self:GetAbility(),
			hd_flags = HD_DAMAGE_FLAG_ICE_DAMAGE + HD_DAMAGE_FLAG_DARK_DAMAGE
		}
		self:StartIntervalThink(self.interval)
	end
end

function modifier_chaotic_hunger_of_hadar_debuff:OnIntervalThink()
	self.damageTable.damage = self.base_damage + self.bonus_damage*self:GetCaster():HDGetPrimaryStatValue()
	ApplyDamage(self.damageTable)
end


function modifier_chaotic_hunger_of_hadar_debuff:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,         --移动速度
		MODIFIER_PROPERTY_TOOLTIP,
		MODIFIER_PROPERTY_MISS_PERCENTAGE
	}
	if self:GetAbility() and self:GetAbility():GetRuneType() == 2 then
		table.insert(funcs,MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS)
	end
	return funcs
end

function modifier_chaotic_hunger_of_hadar_debuff:ADDeclareFunctions()
	local funcs = {}
	if self:GetAbility() and self:GetAbility():GetRuneType() == 1 then
		table.insert(funcs,advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE)
	end
    return funcs
end

function modifier_chaotic_hunger_of_hadar_debuff:Advanced_GetModifierIncomingDamage_Percentage(keys)
	if IsDarkDamage(keys) then
		return self.rune_1_dark_incoming
	end
	return
end
function modifier_chaotic_hunger_of_hadar_debuff:GetModifierMagicalResistanceBonus(keys)
	return -self.rune_2_magic_res
end
function modifier_chaotic_hunger_of_hadar_debuff:GetModifierMoveSpeedBonus_Constant() 
	local parent = self:GetParent()
	if parent:IsImmuneDisadvantagedTerrain_Slow() then
		-- 免疫劣势地形减速
		return 0
	end
	return self.move_speed_reduction 
end
function modifier_chaotic_hunger_of_hadar_debuff:OnTooltip() return self:GetModifierMoveSpeedBonus_Constant() end

function modifier_chaotic_hunger_of_hadar_debuff:GetModifierMiss_Percentage()
	return self.miss
end