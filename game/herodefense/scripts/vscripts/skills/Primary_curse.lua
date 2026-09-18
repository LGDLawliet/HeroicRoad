LinkLuaModifier( "modifier_Primary_curse", "skills/Primary_curse.lua", LUA_MODIFIER_MOTION_NONE )

Primary_curse = class({})

function Primary_curse:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end
function Primary_curse:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_witchdoctor/witchdoctor_maledict_aoe.vpcf", context )
end
function Primary_curse:OnSpellStart()
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()
	local radius = self:GetSpecialValueFor("radius")
	local duration = self:GetSpecialValueFor("duration")
	local incoming = self:GetSpecialValueFor("incoming")
	local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(0.5)
	duration = duration*ModifierStatusNegativeGain

	self:Applycurse(point,radius,duration,incoming)
end

function Primary_curse:Applycurse(point,radius,duration,incoming)
	local caster = self:GetCaster()
	-- 播放施法音效
	EmitSoundOnLocationWithCaster(point, "Hero_WitchDoctor.Maledict_Cast", caster)
	-- 创建巫蛊咒术特效
	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_witchdoctor/witchdoctor_maledict_aoe.vpcf", PATTACH_WORLDORIGIN, nil)
	ParticleManager:SetParticleControl(particle, 0, point)
	ParticleManager:SetParticleControl(particle, 1, Vector(radius, 0, 0))
	ParticleManager:DestroyParticle(particle, false)
	--ParticleManager:ReleaseParticleIndex(particle)
	
	-- 寻找范围内的敌人
	local enemies = FindUnitsInRadius(
		caster:GetTeamNumber(),
		point,
		nil,
		radius,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		0,
		0,
		false
	)
	
	-- 对范围内的敌人施加减甲效果
	for _, enemy in pairs(enemies) do
		enemy:AddNewModifier(caster, self, "modifier_Primary_curse", {incoming = incoming , duration = duration})
	end
end

----------------------------------
modifier_Primary_curse = advanced_modifier({})

function modifier_Primary_curse:IsHidden()return false end
function modifier_Primary_curse:IsDebuff()return true end
function modifier_Primary_curse:IsPurgable()return false end

function modifier_Primary_curse:OnCreated(keys)
	if IsServer() then
		self.incoming = keys.incoming or 0
		self:SetStackCount(self.incoming)
	end
	
end
function modifier_Primary_curse:OnRefresh(keys)
	if IsServer() then
		self.incoming = keys.incoming or 0
		self:SetStackCount(self.incoming)
	end
	
end
function modifier_Primary_curse:ADDeclareFunctions()
	return {
		advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
	}
end
function modifier_Primary_curse:Advanced_GetModifierIncomingDamage_Percentage()
	return self:GetStackCount()
end
function modifier_Primary_curse:GetEffectName()
	return "particles/units/heroes/hero_witchdoctor/witchdoctor_maledict_dot.vpcf"
end
function modifier_Primary_curse:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end