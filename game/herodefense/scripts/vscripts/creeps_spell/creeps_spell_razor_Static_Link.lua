
LinkLuaModifier("modifier_creeps_spell_razor_Static_Link_debuff", "creeps_spell/creeps_spell_razor_Static_Link.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creeps_spell_razor_Static_Link", "creeps_spell/creeps_spell_razor_Static_Link.lua", LUA_MODIFIER_MOTION_HORIZONTAL)
--Abilities
if creeps_spell_razor_Static_Link == nil then
	creeps_spell_razor_Static_Link = class({})
end
function creeps_spell_razor_Static_Link:Precache( context )

	PrecacheResource( "particle", "particles/units/heroes/hero_razor/razor_static_link.vpcf", context )

	PrecacheResource( "particle", "particles/units/heroes/hero_razor/razor_static_link_hit.vpcf", context )

	
	
end


function creeps_spell_razor_Static_Link:OnSpellStart()
	local hCaster = self:GetCaster()
	local hTarget = self:GetCursorTarget()

	if hTarget:TriggerSpellAbsorb(self) then
		return
	end
	hCaster:EmitSound("Ability.static.start")

	local link_modifier = hCaster:AddNewModifier(hCaster, self, "modifier_creeps_spell_razor_Static_Link",{duration = self:GetSpecialValueFor("duration") ,hTargetEntIndex=hTarget:entindex()})

end



if modifier_creeps_spell_razor_Static_Link == nil then
	modifier_creeps_spell_razor_Static_Link = class({})
end
function modifier_creeps_spell_razor_Static_Link:IsHidden()return false end
function modifier_creeps_spell_razor_Static_Link:IsDebuff()return false end
function modifier_creeps_spell_razor_Static_Link:IsPurgable()return false end
function modifier_creeps_spell_razor_Static_Link:IsPurgeException()return false end
function modifier_creeps_spell_razor_Static_Link:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_creeps_spell_razor_Static_Link:OnCreated(params)
	if IsServer() then
		-- local ability = self:GetAbility()
		self.fDrainRate =0.2
		self.radius = 1400
		self.bonus = self:GetAbility():GetSpecialValueFor("bonus_damage")*self.fDrainRate
		self.hTarget=EntIndexToHScript(params.hTargetEntIndex)
		if not self.hTarget then
			self:SafeDestroy()
		end

		self.iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_razor/razor_static_link.vpcf", PATTACH_POINT_FOLLOW, self:GetCaster())
		ParticleManager:SetParticleControlEnt(self.iParticleID, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_whip1", self:GetCaster():GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(self.iParticleID, 1, self.hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", self.hTarget:GetAbsOrigin(), true)
		self:AddParticle(self.iParticleID, false, false, -1, false, false)
		self:StartIntervalThink(self.fDrainRate)
	end
end
function modifier_creeps_spell_razor_Static_Link:OnIntervalThink()
	if IsServer() then
		local caster = self:GetCaster()
		if self.hTarget:IsNull() or not self.hTarget:IsAlive() or CalculateDistance(self.hTarget,caster)>self.radius then
			-- print(CalculateDistance(self.hTarget,caster)>self.radius)
		
			self:StartIntervalThink(-1)
			if self.iParticleID then
				self:GetCaster():EmitSound("Ability.static.end")
				ParticleManager:DestroyParticle(self.iParticleID, false)
				ParticleManager:ReleaseParticleIndex(self.iParticleID)
				self.iParticleID = nil
			end

		end
		if not caster:IsAlive() then
			self:SafeDestroy()
		end

		local bonus = caster:GetAverageTrueAttackDamage(nil)*self.bonus
		bonus = math.min(math.max(bonus,1),60)
		self:SetStackCount(self:GetStackCount()+bonus)
		self:ForceRefresh()
		if self.modifier and not self.modifier:IsNull() then
			self.modifier:LinkRefresh(bonus)
		else
			self.modifier = self.hTarget:AddNewModifier(caster, self:GetAbility(), "modifier_creeps_spell_razor_Static_Link_debuff",{duration = self:GetAbility():GetSpecialValueFor("duration")*self.hTarget:GetHDStatusResistanceIndex(),stack = bonus })
		end
		
	end
end

function modifier_creeps_spell_razor_Static_Link:OnDestroy()
	if IsServer() then
		if self.iParticleID then
			self:GetCaster():EmitSound("Ability.static.end")
			ParticleManager:DestroyParticle(self.iParticleID, false)
			ParticleManager:ReleaseParticleIndex(self.iParticleID)
			self.iParticleID = nil
		end
		
		self:StartIntervalThink(-1)
	end
end
function modifier_creeps_spell_razor_Static_Link:GetModifierPreAttack_BonusDamage()return self:GetStackCount()end
function modifier_creeps_spell_razor_Static_Link:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
	}
end

if modifier_creeps_spell_razor_Static_Link_debuff == nil then
	modifier_creeps_spell_razor_Static_Link_debuff = class({})
end
function modifier_creeps_spell_razor_Static_Link_debuff:IsHidden()return false end
function modifier_creeps_spell_razor_Static_Link_debuff:IsDebuff()return true end
function modifier_creeps_spell_razor_Static_Link_debuff:IsPurgable()return false end
function modifier_creeps_spell_razor_Static_Link_debuff:IsPurgeException()return false end
function modifier_creeps_spell_razor_Static_Link_debuff:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_creeps_spell_razor_Static_Link_debuff:OnCreated(keys)
	if IsServer() then
		self:SetStackCount(keys.stack)
	end
end
function modifier_creeps_spell_razor_Static_Link_debuff:LinkRefresh(bonus)
	if IsServer() then
		self:SetStackCount(self:GetStackCount()+ bonus)
	end
end

function modifier_creeps_spell_razor_Static_Link_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
	}
end

function modifier_creeps_spell_razor_Static_Link_debuff:GetModifierPreAttack_BonusDamage()return -self:GetStackCount() end
function modifier_creeps_spell_razor_Static_Link_debuff:GetEffectName()
	return "particles/units/heroes/hero_razor/razor_static_link_debuff.vpcf"
end
