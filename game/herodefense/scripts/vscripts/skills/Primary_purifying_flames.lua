Primary_purifying_flames = class({})

--------------------------------------------------------------------------------
-- Ability Start

LinkLuaModifier("modifier_Primary_purifying_flames_active", "skills/Primary_purifying_flames", LUA_MODIFIER_MOTION_NONE)
require('internal/timers')   --计时器功能



function Primary_purifying_flames:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	if target:GetTeamNumber()~=caster:GetTeamNumber() then
		if target:IsInvulnerable() or target:TriggerSpellAbsorb( self ) then
			return
		end
	end

	local damage =self:GetSpecialValueFor("basic_damage")+self:GetSpecialValueFor("bonus_damage")*caster:GetIntellect(false)

	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_oracle/oracle_purifyingflames_hit.vpcf", PATTACH_POINT_FOLLOW, target)
	ParticleManager:SetParticleControl(particle, 0, target:GetAbsOrigin())
	ParticleManager:SetParticleControl(particle, 1, target:GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(particle)
	local ability = self
	local damage_type = self:GetAbilityDamageType()
	Timers:CreateTimer(0.2, function()
		
		if not ability or ability:IsNull() then
			return
		end
		local damageTable = {
			victim = target,
			attacker = caster,
			damage = damage,
			damage_type = damage_type,
			damage_flags = DOTA_DAMAGE_FLAG_NONE,
			ability = self, --Optional.
		}
		if target:GetTeamNumber()==caster:GetTeamNumber() then
			damageTable.damage_flags = DOTA_DAMAGE_FLAG_NON_LETHAL
		end
		target:EmitSound("Hero_Oracle.PurifyingFlames.Damage")

		target:AddNewModifier(caster, ability, "modifier_Primary_purifying_flames_active", {duration = 10})
		ApplyDamage(damageTable)

		
	end)
	

end



modifier_Primary_purifying_flames_active = class({})

function modifier_Primary_purifying_flames_active:IsDebuff() return false end
function modifier_Primary_purifying_flames_active:IsHidden() return false end
function modifier_Primary_purifying_flames_active:IsPurgable() return true end
function modifier_Primary_purifying_flames_active:GetEffectName() return "particles/units/heroes/hero_oracle/oracle_purifyingflames_heal.vpcf" end
function modifier_Primary_purifying_flames_active:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
-- function modifier_Primary_purifying_flames_active:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
-- function modifier_Primary_purifying_flames_active:OnCreated(table)
-- 	if IsServer() then
-- 		self.ability = self:GetAbility()
-- 		self.caster = self:GetCaster()
-- 		self.parent = self:GetParent()
-- 		self.heal = (self.ability:GetSpecialValueFor("basic_heal")+self.ability:GetSpecialValueFor("bonus_heal")*self.caster:GetIntellect(false))/10
-- 		self:StartIntervalThink(1)
-- 	end
-- end

-- function modifier_Primary_purifying_flames_active:OnIntervalThink(table)
-- 	if IsServer() then
-- 		local healing = HealWithGain(self.heal,self.caster,self.parent,self.ability)
-- 		SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, self.parent, healing, nil)
-- 	end
-- end
function modifier_Primary_purifying_flames_active:OnCreated(params)
	if IsServer() then
		self.tData = {}
		table.insert(self.tData, { dieTime = self:GetDieTime() })
		self:IncrementStackCount()
		self.timer = 0
		self:StartIntervalThink(0.1)
	end
end
function modifier_Primary_purifying_flames_active:OnRefresh(params)
	if IsServer() then
		local dieTime = self:GetDieTime()
		table.insert(self.tData, {dieTime = dieTime })
		self:IncrementStackCount()

	end
end

function modifier_Primary_purifying_flames_active:OnIntervalThink()
	if IsServer() then
		-- local hParent = self:GetParent()
		local fGameTime = GameRules:GetGameTime()

		for i = #self.tData, 1, -1 do
			if fGameTime >= self.tData[i].dieTime then
				table.remove(self.tData, i)
				self:DecrementStackCount()
			end
		end
		self.timer = self.timer + 0.1
		if self.timer>=1 then
			self.timer = self.timer - 1
			local ability = self:GetAbility()
			if ability then
				local caster = self:GetCaster()
				local parent = self:GetParent()
				local heal = (ability:GetSpecialValueFor("basic_heal")+(ability:GetSpecialValueFor("bonus_heal"))*caster:GetIntellect(false))/10
				heal = heal * self:GetStackCount()
				local healing = HealWithGain(heal,caster,parent,ability)
				SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, parent, healing, nil)
			else
				return
			end
		end
	end
end

