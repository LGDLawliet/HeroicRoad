Primary_Blood_grudge_Dagger = class({})

LinkLuaModifier("modifier_Primary_Blood_grudge_Dagger_passive", "skills/Primary_Blood_grudge_Dagger", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Primary_Blood_grudge_Dagger", "skills/Primary_Blood_grudge_Dagger", LUA_MODIFIER_MOTION_NONE)

function Primary_Blood_grudge_Dagger:GetIntrinsicModifierName() return "modifier_Primary_Blood_grudge_Dagger_passive" end
function Primary_Blood_grudge_Dagger:IsHiddenWhenStolen() return true end

modifier_Primary_Blood_grudge_Dagger_passive = class({})

function modifier_Primary_Blood_grudge_Dagger_passive:IsDebuff()			return false end
function modifier_Primary_Blood_grudge_Dagger_passive:IsHidden() 			return true end
function modifier_Primary_Blood_grudge_Dagger_passive:IsPurgable() 		return false end
function modifier_Primary_Blood_grudge_Dagger_passive:IsPurgeException() 	return false end
function modifier_Primary_Blood_grudge_Dagger_passive:DeclareFunctions() return {MODIFIER_EVENT_ON_ATTACK_LANDED} end

function modifier_Primary_Blood_grudge_Dagger_passive:OnAttackLanded(keys)
	if not IsServer() then
		return
	end
	local target = keys.target
	local caster = self:GetParent()
	if caster:PassivesDisabled() or keys.attacker ~= caster or target:IsOther() or target:IsBuilding()then
		return
	end

	if target:IsMagicImmune() or not target:IsAlive()  then
		return
	end
	local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(1)
	target:AddNewModifier(caster,self:GetAbility(),"modifier_Primary_Blood_grudge_Dagger",{	duration = self:GetAbility():GetSpecialValueFor("duration")*ModifierStatusNegativeGain})
end










modifier_Primary_Blood_grudge_Dagger = class({})

function modifier_Primary_Blood_grudge_Dagger:IsHidden()	return false end
function modifier_Primary_Blood_grudge_Dagger:IsDebuff()	return true end
function modifier_Primary_Blood_grudge_Dagger:IsPurgable()	return true end
function modifier_Primary_Blood_grudge_Dagger:GetEffectName() return "particles/econ/items/bloodseeker/bloodseeker_eztzhok_weapon/bloodseeker_bloodrage_eztzhok.vpcf"  end



function modifier_Primary_Blood_grudge_Dagger:OnCreated(params)
	self.ability = self:GetAbility()
	if IsServer() then
		self.timer = 0
		self.interval = 0.1
		self.tData = {}
		table.insert(self.tData, { dieTime = self:GetDieTime() })
		self:IncrementStackCount()
		self:StartIntervalThink(self.interval)

		
		-- self.bonus_armor = self.ability:GetSpecialValueFor("bonus_armor")
		-- self.bonus_health_regeneration = self.ability:GetSpecialValueFor("bonus_health_regeneration")
	end
end
function modifier_Primary_Blood_grudge_Dagger:OnRefresh(params)
	if IsServer() then
		local dieTime = self:GetDieTime()

		table.insert(self.tData, {dieTime = dieTime })
		self:IncrementStackCount()
		-- if self:GetStackCount()>= (10+_G.GAME_ROUND*4) then
		-- 	--移除第一个 添加一个
		-- 	table.remove(self.tData, 1)
		-- 	table.insert(self.tData, {dieTime = dieTime })

		-- else
		-- 	--当叠加乘数没达到最高时
		-- 	table.insert(self.tData, {dieTime = dieTime })
		-- 	self:IncrementStackCount()
		-- end
	end
end

function modifier_Primary_Blood_grudge_Dagger:OnIntervalThink()
	if not self:GetAbility() or self:GetAbility():IsNull() then
		self:Destroy()
		return
	end
	if IsServer() then
		-- local hParent = self:GetParent()
		local fGameTime = GameRules:GetGameTime()

		for i = #self.tData, 1, -1 do
			if fGameTime >= self.tData[i].dieTime then
				table.remove(self.tData, i)
				self:DecrementStackCount()
			end
		end

		self.timer = self.timer + self.interval
		if self.timer>=1 then
			self.timer = self.timer - 1
			self:PlayEffect()

		end
	end
end


function modifier_Primary_Blood_grudge_Dagger:PlayEffect()
	local ability = self:GetAbility()
	if not ability or ability:IsNull() then
		self:SafeDestroy()
		return
	end
	local dmg = self:GetStackCount() * (ability:GetSpecialValueFor("basic_damage") + ability:GetSpecialValueFor("bonus_damage")* self:GetCaster():HDGetPrimaryStatValue())
	
	dmg = dmg * self:GetCaster():GetBleedingAmpIndex()
	if dmg<=0 then
		return
	end
	local damage = ApplyDamage({
		victim = self:GetParent(), 
		attacker = self:GetCaster(), 
		damage = dmg, 
		damage_type = self:GetAbility():GetAbilityDamageType(), 
		damage_flags = DOTA_DAMAGE_FLAG_HPLOSS, 
		ability = self:GetAbility()
	})
	SendOverheadEventMessage(nil, OVERHEAD_ALERT_CRITICAL , self:GetParent(), damage, nil)
end