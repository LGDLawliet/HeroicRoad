LinkLuaModifier("modifier_chaotic_plant_growth_thinker", "chaotic_spell/class_3/chaotic_plant_growth", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chaotic_plant_growth_debuff", "chaotic_spell/class_3/chaotic_plant_growth", LUA_MODIFIER_MOTION_NONE)





chaotic_plant_growth = class({})


function chaotic_plant_growth:GetManaCost(iLevel)
	local cost = self.BaseClass.GetManaCost(self,iLevel)
	cost = cost * self:GetManaCostGain()
	return cost
end




function chaotic_plant_growth:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/chaotic_spell/chaotic_plant_growth/cast_effect/effect_th_cast.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/chaotic_spell/chaotic_plant_growth/target/effect.vpcf", context )
end
function chaotic_plant_growth:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end


function chaotic_plant_growth:OnSpellStart()
	local caster = self:GetCaster()
	local pos = self:GetCursorPosition()
	-- local pos = caster:GetOrigin()+Vector(0,0,64)
	local effect_cast1 = ParticleManager:CreateParticle( "particles/rebuild/chaotic_spell/chaotic_plant_growth/cast_effect/effect_th_cast.vpcf", PATTACH_CUSTOMORIGIN, target )
	ParticleManager:SetParticleControl( effect_cast1, 0, pos )
	DestroyParticleByDelay(effect_cast1,5)


	CreateModifierThinker(caster, self, "modifier_chaotic_plant_growth_thinker", {duration = self:GetSpecialValueFor("duration")}, pos, caster:GetTeamNumber(), false)




	
end


function chaotic_plant_growth:PlayEffect(target)
	local effect_cast1 = ParticleManager:CreateParticle( "particles/rebuild/chaotic_spell/chaotic_plant_growth/target/effect.vpcf", PATTACH_CUSTOMORIGIN, target )
	ParticleManager:SetParticleControlEnt( effect_cast1, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc" ,Vector(0,0,0), true )
	ParticleManager:ReleaseParticleIndex(effect_cast1)
	target:EmitSound("chaotic_plant_growth_target")
end





modifier_chaotic_plant_growth_thinker = advanced_modifier({})

function modifier_chaotic_plant_growth_thinker:IsAura()return true end
function modifier_chaotic_plant_growth_thinker:OnCreated(keys)
	self.team = DOTA_UNIT_TARGET_TEAM_BOTH
	if self:GetAbility():GetRuneType()==1 then
		self.team = DOTA_UNIT_TARGET_TEAM_ENEMY
	end
	if IsServer() then

		self.radius = self:GetAbility():GetSpecialValueFor("radius")
		local parent = self:GetParent()
		parent:EmitSound("Hero_Treant.Overgrowth.Cast")

		self.particle = ParticleManager:CreateParticle("particles/rebuild/chaotic_spell/chaotic_plant_growth/effect_thinker/effect_vines.vpcf", PATTACH_POINT_FOLLOW, parent)
		ParticleManager:SetParticleControlEnt( self.particle, 0, parent, PATTACH_POINT_FOLLOW, "attach_hitloc" ,Vector(0,0,0), true )
		self:AddParticle(self.particle, false, false, -1, false, false)
		-- DestroyParticleByDelay(particle,13)
		self:StartIntervalThink(1)
	end
end
function modifier_chaotic_plant_growth_thinker:OnDestroy(keys)
	if IsServer() then
		ParticleManager:DestroyParticle(self.particle,false)
		UTIL_Remove(self:GetParent())
	end
end
function modifier_chaotic_plant_growth_thinker:OnIntervalThink()
	if not self:GetAbility() then
		self:Destroy()
	end
end


function modifier_chaotic_plant_growth_thinker:GetAuraRadius()return self.radius end
function modifier_chaotic_plant_growth_thinker:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_chaotic_plant_growth_thinker:GetAuraSearchTeam() return self.team end
function modifier_chaotic_plant_growth_thinker:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_chaotic_plant_growth_thinker:GetAuraDuration() return 0.05 end
function modifier_chaotic_plant_growth_thinker:GetModifierAura()return "modifier_chaotic_plant_growth_debuff" end
function modifier_chaotic_plant_growth_thinker:GetAuraEntityReject(hEntity)
	if hEntity:IsImmuneDisadvantagedTerrain() then
		-- 免疫劣势地形影响
		return true
	end
	if hEntity:IsImmuneDisadvantagedTerrain_Slow() then
		return true
	end
	return false
end


-- 



modifier_chaotic_plant_growth_debuff = advanced_modifier({})

function modifier_chaotic_plant_growth_debuff:IsHidden() 			return false end
function modifier_chaotic_plant_growth_debuff:IsPurgable() 			return false end
function modifier_chaotic_plant_growth_debuff:IsPurgeException() 	return false end
function modifier_chaotic_plant_growth_debuff:IsDebuff() return true end
function modifier_chaotic_plant_growth_debuff:OnCreated(keys)
	self.move_speed_reduction = -self:GetAbility():GetSpecialValueFor("move_slow") * self:GetAbility():GetEffectGain()
end




function modifier_chaotic_plant_growth_debuff:DeclareFunctions()
    return 
    {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,         --移动速度
		MODIFIER_PROPERTY_TOOLTIP,
	}
end
function modifier_chaotic_plant_growth_debuff:GetModifierMoveSpeedBonus_Constant() return   self.move_speed_reduction end
function modifier_chaotic_plant_growth_debuff:OnTooltip() return self:GetModifierMoveSpeedBonus_Constant() end