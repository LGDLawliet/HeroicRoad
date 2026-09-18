Advanced_Blood_grudge_Dagger = class({})
--特效优化 √
LinkLuaModifier("modifier_Advanced_Blood_grudge_Dagger_passive", "skills/Advanced_Blood_grudge_Dagger", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Blood_grudge_Dagger", "skills/Advanced_Blood_grudge_Dagger", LUA_MODIFIER_MOTION_NONE)

function Advanced_Blood_grudge_Dagger:GetIntrinsicModifierName() return "modifier_Advanced_Blood_grudge_Dagger_passive" end
function Advanced_Blood_grudge_Dagger:IsHiddenWhenStolen() return true end



function Advanced_Blood_grudge_Dagger:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/spell/blood_grudge_dagger/unlock1/effect_arcana/juggernaut_arcana_v2_omni_slash_tgt_serrakura.vpcf", context )

	

end



function Advanced_Blood_grudge_Dagger:CheckKVFixedOverride(key)
	if key=="basic_damage" then
		if self:GetUnlock(2)==2 then
			return 100
		end
	end

	return -999999

end








function Advanced_Blood_grudge_Dagger:CheckKV(key)
	local table = {
		basic_damage = 1,
		bonus_damage = 0.01,




	}
	local value = table[key] or -1
	return value

end



function Advanced_Blood_grudge_Dagger:UnlockFirstCore(key)
	-- if self:GetCaster():GetUnitName()~="npc_dota_hero_rubick" then
	-- 	self.CoreUnlock = false
	-- 	self.unlock1 = false
	-- 	SendCustomErrorToPlayer(self:GetCaster():GetPlayerOwnerID(),"dota_hud_Cant_UNLOCK","General.Cancel")
	-- 	return false
	-- end
	return true
end
function Advanced_Blood_grudge_Dagger:UnlockSecondCore(key)
	return true
end
function Advanced_Blood_grudge_Dagger:UnlockThirdCore(key)
	-- l
	-- if self:GetCaster():HasAbility("heroTalent_npc_dota_hero_riki") then
	-- 	self.CoreUnlock = false
	-- 	self.unlock3 = false
	-- 	SendCustomErrorToPlayer(self:GetCaster():GetPlayerOwnerID(),"dota_hud_Cant_UNLOCK","General.Cancel")
	-- 	return false
	-- end

	return true
end


function Advanced_Blood_grudge_Dagger:AddStack(target,stack)
	local caster = self:GetCaster()
	local modifier = target:FindModifierByNameAndCaster("modifier_Advanced_Blood_grudge_Dagger", caster)
	local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(1)
	local base_duration = self:GetSpecialValueFor("duration")
	if self.unlock1 then
		base_duration = 8
	elseif self.unlock2 then
		base_duration =  12
	end
	local duration = base_duration*ModifierStatusNegativeGain
	if modifier then
		modifier:SetDuration(duration, true)
		modifier:AddStack(stack)
	else
		modifier = target:AddNewModifier(caster,self,"modifier_Advanced_Blood_grudge_Dagger",{	duration = duration})
		if modifier then
			modifier:AddStack(stack)
		end
		
	end

end
modifier_Advanced_Blood_grudge_Dagger_passive = class({})

function modifier_Advanced_Blood_grudge_Dagger_passive:IsDebuff()			return false end
function modifier_Advanced_Blood_grudge_Dagger_passive:IsHidden() 			return true end
function modifier_Advanced_Blood_grudge_Dagger_passive:IsPurgable() 		return false end
function modifier_Advanced_Blood_grudge_Dagger_passive:IsPurgeException() 	return false end
function modifier_Advanced_Blood_grudge_Dagger_passive:DeclareFunctions() return {MODIFIER_EVENT_ON_ATTACK_LANDED} end

function modifier_Advanced_Blood_grudge_Dagger_passive:OnAttackLanded(keys)
	if not IsServer() then
		return
	end
	local target = keys.target
	local caster = self:GetParent()
	if caster:PassivesDisabled() or keys.attacker ~= caster or target:IsOther() or target:IsBuilding()then
		return
	end

	if target:IsMagicImmune() or not target:IsAlive()   then
		return
	end
	local ability = self:GetAbility()
	ability:AddStack(target,1)
	if ability.unlock1 and caster:GetRandomEffect(15,INT_TYPE,1)  > RandomInt(1, 100) then
		local pfx = ParticleManager:CreateParticle("particles/rebuild/spell/blood_grudge_dagger/unlock1/effect_arcana/juggernaut_arcana_v2_omni_slash_tgt_serrakura.vpcf", PATTACH_ABSORIGIN, caster)
		ParticleManager:SetParticleControl(pfx, 0, target:GetOrigin())
		ParticleManager:SetParticleControlForward(pfx, 0, Vector(RandomFloat(-1, 1),RandomFloat(-1, 1),RandomFloat(-1, 1)))  --方向
		ParticleManager:ReleaseParticleIndex(pfx)
		caster:EmitSound("hero_bloodseeker.rupture.cast")

		local enemies = FindUnitsInRadius(
			caster:GetTeamNumber(),	-- int, your team number
			target:GetOrigin(),	-- point, center point
			nil,	-- handle, cacheUnit. (not known)
			500,	-- float, radius. or use FIND_UNITS_EVERYWHERE
			DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
			DOTA_UNIT_TARGET_FLAG_NONE,	-- int, flag filter
			FIND_CLOSEST,	-- int, order filter
			false	-- bool, can grow cache
		)
		for i, unit in ipairs(enemies) do
			ability:AddStack(unit,3)
			if i>=5 then
				break
			end
		end
	end
end










modifier_Advanced_Blood_grudge_Dagger = advanced_modifier({})

function modifier_Advanced_Blood_grudge_Dagger:IsHidden()	return false end
function modifier_Advanced_Blood_grudge_Dagger:IsDebuff()	return true end
function modifier_Advanced_Blood_grudge_Dagger:IsPurgable()	return true end
function modifier_Advanced_Blood_grudge_Dagger:GetEffectName() return "particles/econ/items/bloodseeker/bloodseeker_eztzhok_weapon/bloodseeker_bloodrage_eztzhok.vpcf"  end
function modifier_Advanced_Blood_grudge_Dagger:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end


function modifier_Advanced_Blood_grudge_Dagger:OnCreated(params)
	self.ability = self:GetAbility()
	if IsServer() then
		self.timer = 0
		self.interval = 0.1
		self.tData = {}
		-- table.insert(self.tData, { dieTime = self:GetDieTime() })
		-- self:IncrementStackCount()
		self:StartIntervalThink(self.interval)

		self.damage_count= 0
		-- self.bonus_armor = self.ability:GetSpecialValueFor("bonus_armor")
		-- self.bonus_health_regeneration = self.ability:GetSpecialValueFor("bonus_health_regeneration")
	end
end
function modifier_Advanced_Blood_grudge_Dagger:OnDestroy()
	if IsServer() then
		local ability = self:GetAbility()
		if not ability or ability:IsNull() then
			return
		end
		local caster = self:GetCaster()
		local parent = self:GetParent()	
		local radius = 300
		if self:GetAbility().advanced_level>=10 then
			radius = 500
		end
		local enemies = FindUnitsInRadius(
			caster:GetTeamNumber(),	-- int, your team number
			parent:GetAbsOrigin(),	-- point, center point
			nil,	-- handle, cacheUnit. (not known)
			radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
			DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
			DOTA_UNIT_TARGET_FLAG_NONE,	-- int, flag filter
			FIND_CLOSEST,	-- int, order filter
			false	-- bool, can grow cache
		)
		local damage = self.damage_count
		damage = damage*caster:GetBleedingAmpIndex()
		if damage<=0 then
			return
		end
		local damageTable = {
			attacker = caster,
			damage = math.min(damage,1000000),
			damage_type = self:GetAbility():GetAbilityDamageType(),
			damage_flags = DOTA_DAMAGE_FLAG_HPLOSS+DOTA_DAMAGE_FLAG_REFLECTION+DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION, --Optional.
			ability = self:GetAbility(), --Optional.
			hd_flags = HD_DAMAGE_FLAG_NO_SPELL_CRIT + HD_DAMAGE_FLAG_NO_DAMAGE_AMPLIFY
			}



		for i,enemy in pairs(enemies) do
			damageTable.victim = enemy
			ApplyDamage(damageTable)

		end
	
		parent:EmitSound("Ability.SandKing_CausticFinale")
		local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_sandking/sandking_caustic_finale_explode.vpcf", PATTACH_ABSORIGIN, parent)
		ParticleManager:ReleaseParticleIndex(pfx)
	end
end
function modifier_Advanced_Blood_grudge_Dagger:AddStack(stack)
	self:SetStackCount(self:GetStackCount()+stack)
	table.insert(self.tData, { dieTime = self:GetDieTime(),stack=stack })
end



function modifier_Advanced_Blood_grudge_Dagger:OnIntervalThink()
	if not self:GetAbility() or self:GetAbility():IsNull() then
			self:Destroy()
			return
		end
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


function modifier_Advanced_Blood_grudge_Dagger:PlayEffect()
	local ability = self:GetAbility()
	if not ability or ability:IsNull() then
		self:SafeDestroy()
		return
	end
	local caster = self:GetCaster()
	local parent = self:GetParent()
	
	local dmg = self:GetStackCount() * (ability:GetSpecialValueFor("basic_damage") + ability:GetSpecialValueFor("bonus_damage")*caster:HDGetPrimaryStatValue())
	if ability.advanced_level>=10 then
		if ability.unlock2 then
			dmg = dmg + self:GetStackCount() *caster:GetAverageTrueAttackDamage(nil)*0.06
		else
			if ability.unlock3 then
				dmg = dmg + self:GetStackCount() *(caster:GetAverageTrueAttackDamage(nil)*0.02 + caster:GetMaxHealth()*0.015)
			else
				dmg = dmg + self:GetStackCount() *caster:GetAverageTrueAttackDamage(nil)*0.02
			end
			
		end
		
	end
	dmg = dmg * caster:GetBleedingAmpIndex()
	if dmg<=0 then
		return
	end
	
	local damage = ApplyDamage({
		victim = parent, 
		attacker = caster, 
		damage = dmg, 
		damage_type = ability:GetAbilityDamageType(), 
		damage_flags = DOTA_DAMAGE_FLAG_HPLOSS, 
		ability = ability
	})
	self.damage_count = self.damage_count + damage*0.4
	SendOverheadEventMessage(nil, OVERHEAD_ALERT_CRITICAL , self:GetParent(), damage, nil)


	if self:GetCaster():GetRandomEffect(15,INT_TYPE,0.5) >=RandomInt(1, 100) then
		local radius = 300
		if ability.advanced_level>=10 then
			radius = 500
		end
		local units = FindUnitsInRadius(
			caster:GetTeamNumber(),	-- int, your team number
			parent:GetAbsOrigin(),	-- point, center point
			nil,	-- handle, cacheUnit. (not known)
			radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
			DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
			DOTA_UNIT_TARGET_FLAG_NONE,	-- int, flag filter
			FIND_ANY_ORDER,	-- int, order filter
			false	-- bool, can grow cache
		)
		for _, unit in ipairs(units) do
			if unit~=parent then
				ability:AddStack(unit,1)
				break
			end
		end


	end

end









function modifier_Advanced_Blood_grudge_Dagger:DeclareFunctions()
	local ability = self:GetAbility()
	local level = ability:GetSpecialValueFor("advanced_level")
	if level>=15 then
		local funcs = {
			MODIFIER_EVENT_ON_DEATH
		}
		if level>=20 then
			table.insert(funcs,MODIFIER_EVENT_ON_TAKEDAMAGE)
		end

		return funcs
	end
    return 
end

function modifier_Advanced_Blood_grudge_Dagger:OnDeath(keys)
    if not IsServer() then
        return
    end
	local ability = self:GetAbility()
	if not ability or ability:IsNull() then
		self:SafeDestroy()
		return
	end
	local parent =  keys.unit
    if parent == self:GetParent() then
		local stack = self:GetStackCount()*0.3
		if stack<1 then
			return
		end
		stack = stack - stack%1
		
		local caster = self:GetCaster()
		local units = FindUnitsInRadius(
			caster:GetTeamNumber(),	-- int, your team number
			parent:GetAbsOrigin(),	-- point, center point
			nil,	-- handle, cacheUnit. (not known)
			200,	-- float, radius. or use FIND_UNITS_EVERYWHERE
			DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
			DOTA_UNIT_TARGET_FLAG_NONE,	-- int, flag filter
			FIND_CLOSEST,	-- int, order filter
			false	-- bool, can grow cache
		)
		local ability = self:GetAbility()


		for _, unit in ipairs(units) do
			ability:AddStack(unit,stack)
		end
		

    end
end


function modifier_Advanced_Blood_grudge_Dagger:OnTakeDamage( params )

	if IsServer() then
		local Attacker = params.attacker
		local Target = params.unit
		local Ability = params.inflictor
		local flDamage = params.damage

		if Target ~= self:GetParent() then
			return 0
		end
		if Ability and Ability ==self:GetAbility() then
			return
		end
		

		if bit.band( params.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION ) == DOTA_DAMAGE_FLAG_REFLECTION then
			return 0
		end
		if bit.band( params.damage_flags, DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL ) == DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL then
			return 0
		end

		if flDamage>0 then
			print("加"..flDamage)
			-- print()
			self.damage_count = self.damage_count +flDamage*0.1
		end


	end

	return 0.0

end


function modifier_Advanced_Blood_grudge_Dagger:ADDeclareFunctions()
	local funcs = {}
    
	if self:GetAbility():GetUnlock(3)==3 then
		table.insert(funcs,advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS)
		
	end
	return funcs
end
function modifier_Advanced_Blood_grudge_Dagger:Advanced_GetModifierPhysicalArmorBonus()
    return  self:GetStackCount()*(-2)
end