LinkLuaModifier("modifier_chaotic_web_thinker", "chaotic_spell/class_2/chaotic_web", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chaotic_web_debuff", "chaotic_spell/class_2/chaotic_web", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_chaotic_web_debuff_root", "chaotic_spell/class_2/chaotic_web", LUA_MODIFIER_MOTION_NONE)




chaotic_web = class({})



function chaotic_web:GetManaCost(iLevel)
	local cost = self.BaseClass.GetManaCost(self,iLevel)
	cost = cost * self:GetManaCostGain()
	return cost
end





function chaotic_web:Precache( context )
	PrecacheResource( "particle", "particles/econ/items/broodmother/broodmother_2022_immortal/broodmother_2022_immortal_web_spin_cast.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/chaotic_spell/chaotic_web/web/effect.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/chaotic_spell/chaotic_web/effect_debuff/cepter_sticky_snare_root.vpcf", context )
end

function chaotic_web:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end


function chaotic_web:OnSpellStart()
	local caster = self:GetCaster()
	local pos = self:GetCursorPosition()

	local effect_cast1 = ParticleManager:CreateParticle( "particles/econ/items/broodmother/broodmother_2022_immortal/broodmother_2022_immortal_web_spin_cast.vpcf", PATTACH_CUSTOMORIGIN, caster )
	ParticleManager:SetParticleControl( effect_cast1, 0, pos )
	ParticleManager:SetParticleControl( effect_cast1,1, pos )
	ParticleManager:SetParticleControl( effect_cast1, 2, Vector(500,0,0) )
	DestroyParticleByDelay(effect_cast1,3)

	CreateModifierThinker(caster, self, "modifier_chaotic_web_thinker", {duration = self:GetSpecialValueFor("duration")}, pos, caster:GetTeamNumber(), false)
end







modifier_chaotic_web_thinker = advanced_modifier({})

function modifier_chaotic_web_thinker:IsAura()return self:GetAbility() and true or false end
function modifier_chaotic_web_thinker:OnCreated(keys)
	self.team = DOTA_UNIT_TARGET_TEAM_BOTH
	if self:GetAbility():GetRuneType()==1 then
		self.team = DOTA_UNIT_TARGET_TEAM_ENEMY
	end
	if IsServer() then

		self.radius = self:GetAbility():GetSpecialValueFor("radius")
		local parent = self:GetParent()
		parent:EmitSound("Hero_Broodmother.SpinWebCast")

		self.particle = ParticleManager:CreateParticle("particles/rebuild/chaotic_spell/chaotic_web/web/effect.vpcf", PATTACH_POINT_FOLLOW, parent)
		ParticleManager:SetParticleControlEnt( self.particle, 0, parent, PATTACH_POINT_FOLLOW, "attach_hitloc" ,Vector(0,0,0), true )
		ParticleManager:SetParticleControlEnt( self.particle, 1, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc" ,Vector(0,0,0), true )
		self:AddParticle(self.particle, false, false, -1, false, false)
		-- DestroyParticleByDelay(particle,13)
		self:StartIntervalThink(1)
	end
end
function modifier_chaotic_web_thinker:OnDestroy(keys)
	if IsServer() then
		ParticleManager:DestroyParticle(self.particle,false)
		UTIL_Remove(self:GetParent())
	end
end
function modifier_chaotic_web_thinker:OnIntervalThink()
	if not self:GetAbility() then
		self:Destroy()
	end
end


function modifier_chaotic_web_thinker:GetAuraRadius()return self.radius end
function modifier_chaotic_web_thinker:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_chaotic_web_thinker:GetAuraSearchTeam() return self.team end
function modifier_chaotic_web_thinker:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_chaotic_web_thinker:GetAuraDuration() return 0.05 end
function modifier_chaotic_web_thinker:GetModifierAura()return "modifier_chaotic_web_debuff" end
function modifier_chaotic_web_thinker:GetAuraEntityReject(hEntity)
	if hEntity:IsImmuneDisadvantagedTerrain() then
		-- 免疫劣势地形影响
		return true
	end
	return false
end



modifier_chaotic_web_debuff = advanced_modifier({})

function modifier_chaotic_web_debuff:IsHidden() 			return false end
function modifier_chaotic_web_debuff:IsPurgable() 			return false end
function modifier_chaotic_web_debuff:IsPurgeException() 	return false end
function modifier_chaotic_web_debuff:IsDebuff() return true end
function modifier_chaotic_web_debuff:OnCreated(keys)
	local ability = self:GetAbility()
	self.move_speed_reduction = -ability:GetSpecialValueFor("move_slow") * ability:GetEffectGain()
	if IsServer() then
		self.prop_chance = ability:GetSpecialValueFor("prop_chance")
		self.debuff_duration = ability:GetSpecialValueFor("debuff_duration")
		if IsEnemy(self:GetParent(),self:GetCaster()) then
			self:StartIntervalThink(ability:GetSpecialValueFor("interval"))
		end
		
	end
end

function modifier_chaotic_web_debuff:CheckState(keys)
	local state = {}
	if self:GetAbility() and self:GetAbility():GetRuneType()==1 then
		state=  {
			[MODIFIER_STATE_PROVIDES_VISION] = true,
		}
	end
	return state
end

function modifier_chaotic_web_debuff:OnIntervalThink()
	local parent = self:GetParent()
	local ability = self:GetAbility()
	local caster = self:GetCaster()
	if self:GetAbility():GetRuneType()==3 then  
		if parent:GetTeamNumber() ~= caster:GetTeamNumber() then
			local poison = caster:HDGetPrimaryStatValue() *ability:GetSpecialValueFor("rune_3_posion")
			parent:Poison(caster, ability, poison)
		end
	end
	if caster:RollRandom(self.prop_chance,1) then
		local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(1)
		local StatusResistance = parent:GetHDStatusResistanceIndex()*ModifierStatusNegativeGain
		parent:AddNewModifier(parent, ability, "modifier_chaotic_web_debuff_root", {duration = self.debuff_duration*StatusResistance})
	end
end

function modifier_chaotic_web_debuff:ADDeclareFunctions()
	local funcs = {}
    if self:GetAbility():GetRuneType()==2 then  
		table.insert(funcs,advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS)
	end
	return funcs
end

function modifier_chaotic_web_debuff:Advanced_GetModifierPhysicalArmorBonus()
	return -self:GetAbility():GetSpecialValueFor("rune_2_armor")
end

function modifier_chaotic_web_debuff:DeclareFunctions()
    return 
    {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,         --移动速度
		MODIFIER_PROPERTY_TOOLTIP,
	}
end
function modifier_chaotic_web_debuff:GetModifierMoveSpeedBonus_Constant() 
	if self:GetParent():IsImmuneDisadvantagedTerrain_Slow() then
		-- 免疫劣势地形减速
		return 0
	end
	return   self.move_speed_reduction 
end
function modifier_chaotic_web_debuff:OnTooltip() return self:GetModifierMoveSpeedBonus_Constant() end




modifier_chaotic_web_debuff_root = advanced_modifier({})

function modifier_chaotic_web_debuff_root:IsHidden() 			return false end
function modifier_chaotic_web_debuff_root:IsPurgable() 			return true end
function modifier_chaotic_web_debuff_root:IsPurgeException() 	return true end
function modifier_chaotic_web_debuff_root:IsDebuff() return true end
function modifier_chaotic_web_debuff_root:CheckState()
	local state=  {
		[MODIFIER_STATE_ROOTED] = true,
	}
	return state
end

function modifier_chaotic_web_debuff_root:GetEffectName() return "particles/rebuild/chaotic_spell/chaotic_web/effect_debuff/cepter_sticky_snare_root.vpcf" end