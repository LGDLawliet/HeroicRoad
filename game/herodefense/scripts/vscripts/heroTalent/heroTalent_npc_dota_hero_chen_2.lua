heroTalent_npc_dota_hero_chen_2 = class({})
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_chen_2_active", "heroTalent/heroTalent_npc_dota_hero_chen_2", LUA_MODIFIER_MOTION_NONE )
--LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_chen_2_effect", "heroTalent/heroTalent_npc_dota_hero_chen_2", LUA_MODIFIER_MOTION_NONE )
function heroTalent_npc_dota_hero_chen_2:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_chen/chen_holy_persuasion.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_weaver/weaver_shukuchi_damage.vpcf", context )

end
--function heroTalent_npc_dota_hero_chen_2:GetIntrinsicModifierName()
--	return "modifier_heroTalent_npc_dota_hero_chen_2"
--end
function heroTalent_npc_dota_hero_chen_2:OnSpellStart()
	local heroes = GetAllRealHeroes()
	for _,hero in pairs(heroes) do
		self:PlayEffect(hero)
	end
end
function heroTalent_npc_dota_hero_chen_2:PlayEffect(unit)
	local target = unit
	EmitSoundOn( "Hero_Chen.PenitenceImpact", target )
	local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_chen/chen_holy_persuasion.vpcf", PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControl(effect_cast,0,target:GetOrigin() )
	ParticleManager:SetParticleControl(effect_cast,1,target:GetOrigin() )
	ParticleManager:ReleaseParticleIndex(effect_cast)
	target:EmitSound("Hero_Chen.HandOfGodHealHero")


	target:Purge(false, true, false, true, false)
	self.line = self:GetSpecialValueFor("line")
	self.heal = self:GetSpecialValueFor("heal")*0.01
	if target:GetHealthPercent() <= self.line then
		target:AddNewModifier(self:GetCaster(), self, "modifier_heroTalent_npc_dota_hero_chen_2_active", {duration = self:GetSpecialValueFor("duration")} )
	end
	local healing = HealWithGain(target:GetMaxHealth()*self.heal,self:GetCaster(),target,self)
	SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, target, healing, nil)
end
-----------------------------------------------------------------------------------------------------
modifier_heroTalent_npc_dota_hero_chen_2_active = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_chen_2_active:IsHidden()	return false end
function modifier_heroTalent_npc_dota_hero_chen_2_active:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_chen_2_active:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_chen_2_active:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_chen_2_active:RemoveOnDeath() return false end
function modifier_heroTalent_npc_dota_hero_chen_2_active:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_heroTalent_npc_dota_hero_chen_2_active:OnCreated()
	if IsServer() then
		self:StartIntervalThink(0.33)
	end
	self.hot = self:GetAbility():GetSpecialValueFor("hot")*0.01
end
function modifier_heroTalent_npc_dota_hero_chen_2_active:OnIntervalThink()
	self.hot = self:GetAbility():GetSpecialValueFor("hot")*0.01*0.33
	local target = self:GetParent()
	local healing = HealWithGain(target:GetMaxHealth()*self.hot,self:GetCaster(),target,self:GetAbility())
	SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, target, healing, nil)
	local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_weaver/weaver_shukuchi_damage.vpcf", PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControl(effect_cast,0,target:GetOrigin() )
	ParticleManager:SetParticleControl(effect_cast,1,target:GetOrigin() )
	ParticleManager:ReleaseParticleIndex(effect_cast)
end
-----------------------------------------------------------------------------------------------------
modifier_heroTalent_npc_dota_hero_chen_2 = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_chen_2:IsHidden()	return true end
function modifier_heroTalent_npc_dota_hero_chen_2:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_chen_2:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_chen_2:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_chen_2:RemoveOnDeath() return false end
function modifier_heroTalent_npc_dota_hero_chen_2:OnCreated()
	if IsServer() then
		--self.hNpcSpawnedGameEvent = ListenToGameEvent( "dota_on_summon", Dynamic_Wrap( self, 'OnSummonTrigger' ),self )
	end
	self.line = self:GetAbility():GetSpecialValueFor("line")
	self.heal = self:GetAbility():GetSpecialValueFor("heal")
	self.count = self:GetAbility():GetSpecialValueFor("counta")
end
function modifier_heroTalent_npc_dota_hero_chen_2:OnDestroy()
	if IsServer() then
		--if self.hNpcSpawnedGameEvent then
		--	StopListeningToGameEvent(self.hNpcSpawnedGameEvent)
		--end
	end
end
function modifier_heroTalent_npc_dota_hero_chen_2:ADDeclareFunctions()
	return
	{
		MODIFIER_EVENT_ON_TAKEDAMAGE = {nil,}
	}
end
function modifier_heroTalent_npc_dota_hero_chen_2:OnSummonTrigger(keys)
	if IsServer() then
		local unit =  EntIndexToHScript(keys.unit)
		local target =  EntIndexToHScript(keys.target)
		if not IsEnemy(unit,self:GetParent()) then
			local ability = self:GetAbility()
			local caster = self:GetCaster()
			if caster:PassivesDisabled() then
				return
			end
			target:AddNewModifier(caster, ability, "modifier_heroTalent_npc_dota_hero_chen_2_effect", {} )
			EmitSoundOn( "Hero_Chen.PenitenceImpact", target )
		end
	end
end

------------------------------------------------------------------------------------
modifier_heroTalent_npc_dota_hero_chen_2_effect = class({})

function modifier_heroTalent_npc_dota_hero_chen_2_effect:IsHidden()	return false end
function modifier_heroTalent_npc_dota_hero_chen_2_effect:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_chen_2_effect:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_chen_2_effect:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_chen_2_effect:GetAttributes() return  MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_heroTalent_npc_dota_hero_chen_2_effect:OnCreated()
	if IsServer() then
		self:SetStackCount(2)
		self:StartIntervalThink(0.1)
	end
end
function modifier_heroTalent_npc_dota_hero_chen_2_effect:OnIntervalThink()
	local parent = self:GetParent()
	if parent:GetHealthPercent()<=50 then
		parent:Purge(false, true, false, true, false)
		local healing = HealWithGain(parent:GetMaxHealth()*0.35,self:GetCaster(),parent,self:GetAbility())

		SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, parent, healing, nil)
		self:PlayEffect(parent)

		self:DecrementStackCount()
		if self:GetStackCount()<=0 then
			self:SafeDestroy()
		end
		
	end

end

function modifier_heroTalent_npc_dota_hero_chen_2_effect:PlayEffect(unit)
	local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_chen/chen_holy_persuasion.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit )
	ParticleManager:SetParticleControl(effect_cast,0,unit:GetOrigin() )
	ParticleManager:SetParticleControl(effect_cast,1,unit:GetOrigin() )
	ParticleManager:ReleaseParticleIndex(effect_cast)
	unit:EmitSound("Hero_Chen.HandOfGodHealHero")

end

