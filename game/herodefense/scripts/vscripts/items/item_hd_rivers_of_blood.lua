item_hd_rivers_of_blood = class({})

LinkLuaModifier("modifier_item_hd_rivers_of_blood", "items/item_hd_rivers_of_blood", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_rivers_of_blood_debuff", "items/item_hd_rivers_of_blood", LUA_MODIFIER_MOTION_NONE)

function item_hd_rivers_of_blood:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/spell/blood_grudge_dagger/unlock1/effect_arcana/juggernaut_arcana_v2_omni_slash_tgt_serrakura.vpcf", context )
	PrecacheResource( "particle", "particles/econ/items/bloodseeker/bloodseeker_eztzhok_weapon/bloodseeker_bloodrage_eztzhok.vpcf", context )
end
-- Item Passive
-- require('internal/timers')   --计时器功能
function item_hd_rivers_of_blood:GetIntrinsicModifierName()
	return "modifier_item_hd_rivers_of_blood"
end
function item_hd_rivers_of_blood:AddStack(target,stack)
	local caster = self:GetCaster()
	local modifier = target:FindModifierByNameAndCaster("modifier_item_hd_rivers_of_blood_debuff", caster)
	local base_duration = 10
	if modifier then
		modifier:SetDuration(base_duration, true)
		modifier:AddStack(stack)
	else
		modifier = target:AddNewModifier(caster,self,"modifier_item_hd_rivers_of_blood_debuff",{	duration = base_duration})
		if modifier then
			modifier:AddStack(stack)
		end
		
	end

end

modifier_item_hd_rivers_of_blood = class({})

function modifier_item_hd_rivers_of_blood:IsDebuff() return false end
function modifier_item_hd_rivers_of_blood:IsHidden() return true end
function modifier_item_hd_rivers_of_blood:IsPurgable() return false end
function modifier_item_hd_rivers_of_blood:IsPurgeException() return false end
function modifier_item_hd_rivers_of_blood:RemoveOnDeath() return false end

function modifier_item_hd_rivers_of_blood:OnCreated(keys)
	self.bonus_damage = self:GetAbility():GetSpecialValueFor("bonus_damage")
	self.bonus_attack_speed = self:GetAbility():GetSpecialValueFor("bonus_attack_speed")
	if IsServer() then
		self:GetParent():UpDateModifierBleedingAmp(self,30)
	end
end
function modifier_item_hd_rivers_of_blood:OnDestroy(keys)
	if IsServer() then
		self:GetParent():RemoveModifierBleedingAmp(self)
	end
end
function modifier_item_hd_rivers_of_blood:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,         
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,         
		MODIFIER_EVENT_ON_ATTACK_LANDED
      

	}
end
function modifier_item_hd_rivers_of_blood:GetModifierPreAttack_BonusDamage()return self.bonus_damage end
function modifier_item_hd_rivers_of_blood:GetModifierAttackSpeedBonus_Constant()return self.bonus_attack_speed end
function modifier_item_hd_rivers_of_blood:OnAttackLanded(keys)
	if not IsServer() then
		return
	end
	local target = keys.target
	local caster = self:GetParent()
	if keys.attacker ~= caster or target:IsOther() or target:IsBuilding()then
		return
	end

	if target:IsMagicImmune() or not target:IsAlive()   then
		return
	end
	local ability = self:GetAbility()
	
	if caster:GetRandomEffect(15,INT_TYPE,1)  > RandomInt(1, 100) then
		if not ability:IsCooldownReady() then
			return
		end
		ability:StartCooldown(0.3)
		local pfx = ParticleManager:CreateParticle("particles/rebuild/spell/blood_grudge_dagger/unlock1/effect_arcana/juggernaut_arcana_v2_omni_slash_tgt_serrakura.vpcf", PATTACH_ABSORIGIN, caster)
		ParticleManager:SetParticleControl(pfx, 0, target:GetOrigin())
		ParticleManager:SetParticleControlForward(pfx, 0, Vector(RandomFloat(-1, 1),RandomFloat(-1, 1),RandomFloat(-1, 1)))  --方向
		ParticleManager:ReleaseParticleIndex(pfx)
		caster:EmitSound("hero_bloodseeker.rupture.cast")
		ability:AddStack(target,1)
		local enemies = FindUnitsInRadius(
			caster:GetTeamNumber(),	-- int, your team number
			target:GetOrigin(),	-- point, center point
			nil,	-- handle, cacheUnit. (not known)
			400,	-- float, radius. or use FIND_UNITS_EVERYWHERE
			DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
			DOTA_UNIT_TARGET_FLAG_NONE,	-- int, flag filter
			FIND_CLOSEST,	-- int, order filter
			false	-- bool, can grow cache
		)
		if #enemies>=1 then
			for i = 1, 3, 1 do
				ability:AddStack(enemies[RandomInt(1, #enemies)],1)
			end
		end

	end
end















modifier_item_hd_rivers_of_blood_debuff = class({})

function modifier_item_hd_rivers_of_blood_debuff:IsHidden()	return false end
function modifier_item_hd_rivers_of_blood_debuff:IsDebuff()	return true end
function modifier_item_hd_rivers_of_blood_debuff:IsPurgable()	return true end
function modifier_item_hd_rivers_of_blood_debuff:GetEffectName() return "particles/econ/items/bloodseeker/bloodseeker_eztzhok_weapon/bloodseeker_bloodrage_eztzhok.vpcf"  end
function modifier_item_hd_rivers_of_blood_debuff:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end


function modifier_item_hd_rivers_of_blood_debuff:OnCreated(params)
	self.ability = self:GetAbility()
	if IsServer() then
		self.timer = 0
		self.interval = 0.1
		self.tData = {}
		self:StartIntervalThink(self.interval)
		self.damage_count= 0
	end
end

function modifier_item_hd_rivers_of_blood_debuff:AddStack(stack)
	self:SetStackCount(self:GetStackCount()+stack)
	table.insert(self.tData, { dieTime = self:GetDieTime(),stack=stack })
end
function modifier_item_hd_rivers_of_blood_debuff:OnIntervalThink()
	if IsServer() then
		-- local hParent = self:GetParent()
		local fGameTime = GameRules:GetGameTime()

		for i = #self.tData, 1, -1 do
			if fGameTime >= self.tData[i].dieTime then
				
				-- self:DecrementStackCount()
				self:SetStackCount(self:GetStackCount()-self.tData[i].stack)
				table.remove(self.tData, i)
			end
		end

		self.timer = self.timer + self.interval
		if self.timer>=1 then
			self.timer = self.timer - 1
			self:PlayEffect()

		end
	end
end


function modifier_item_hd_rivers_of_blood_debuff:PlayEffect()
	local ability = self:GetAbility()
	if not ability or ability:IsNull() then
		self:SafeDestroy()
		return
	end
	local caster = self:GetCaster()
	local parent = self:GetParent()
	local dmg = self:GetStackCount() * caster:GetAverageTrueAttackDamage(nil)*0.03*caster:GetBleedingAmpIndex()
	if dmg<=0 then
		return
	end
	local damage = ApplyDamage({
		victim = parent, 
		attacker = caster, 
		damage = dmg, 
		damage_type = DAMAGE_TYPE_PHYSICAL, 
		damage_flags = DOTA_DAMAGE_FLAG_HPLOSS, 
		ability = ability
	})
	SendOverheadEventMessage(nil, OVERHEAD_ALERT_CRITICAL , self:GetParent(), damage, nil)

end




