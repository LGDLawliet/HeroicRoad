
LinkLuaModifier( "modifier_Advanced_summon_wolves", "skills/Advanced_summon_wolves", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_summon_wolves_leder", "skills/Advanced_summon_wolves", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_summon_wolves_leder_unlock1", "skills/Advanced_summon_wolves", LUA_MODIFIER_MOTION_NONE )

Advanced_summon_wolves						= Advanced_summon_wolves or class({})
function Advanced_summon_wolves:IsSummonSpell()return true end

function Advanced_summon_wolves:CheckKV(key)
	local table = {
		bonus_damage=2,
		bonus_health=1,

	}
	local value = table[key] or -1
	return value

end		
function Advanced_summon_wolves:Spawn()
	self.unlock2_point = 0
	self.unlock2_spell_time = 0
end

function Advanced_summon_wolves:UnlockFirstCore(key)
	return true
end
function Advanced_summon_wolves:UnlockSecondCore(key)
	return true
end
function Advanced_summon_wolves:UnlockThirdCore(key)
	return true
end
function Advanced_summon_wolves:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/spell/wolfs/unlock1/effect.vpcf", context )
end


function Advanced_summon_wolves:OnSpellStart()
	if self.unlock2 and Game_State:IsInBattle() then
		self.unlock2_spell_time = self.unlock2_spell_time + 1
	end
	
	local caster =self:GetCaster()

	if not self.summon_table then
		self.summon_table = {}
	end
	for _, unit in ipairs(self.summon_table) do
		if IsValidEntity(unit) then
			unit:ForceKill(false)	
		end
	end
	

	EmitSoundOn("Hero_Lycan.SummonWolves", self:GetCaster())	
	
	-- Add cast particles
	local particle_cast_fx = ParticleManager:CreateParticle("particles/units/heroes/hero_lycan/lycan_summon_wolves_cast.vpcf", PATTACH_ABSORIGIN, self:GetCaster())
	ParticleManager:SetParticleControl(particle_cast_fx, 0, self:GetCaster():GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(particle_cast_fx)
	
	local wolves_spawn_particle = nil
	self.summon_table = {}  --储存召唤物 用于在重复召唤时候移除它们



	--召唤强度

	local life_duration = self:GetSpecialValueFor("duration") 
	local heal = (self:GetSpecialValueFor("bonus_health"))*0.01 * caster:GetMaxHealth()
	local armor = self:GetSpecialValueFor("bonus_armor")*0.01 * caster:GetPhysicalArmorValue(false)
	local damage = (self:GetSpecialValueFor("bonus_damage"))*0.01 * caster:GetBaseDamageMax()
	local count = self:GetSpecialValueFor("wolves_count")-1
	local mana = 1000
	if self.unlock3 and caster:IsInNightTime() then
		heal = heal *1.5
		armor = armor*1.5
		damage = damage *1.5
	end
	--LV15解锁狼群
	if self.advanced_level>=15 then
		count = count + 1
	end
	
	local ex_count = math.floor(math.min(self.unlock2_point/25,5))
	local big_wolf = math.floor(self.unlock2_spell_time/8)
	local ability_Advanced_howl = caster:FindAbilityByName("Advanced_howl")
	local howl = false
	if ability_Advanced_howl and ability_Advanced_howl.unlock1 then
		count = count + 3
		howl = true
	end
	-- local summon_count = self:GetSpecialValueFor("wolves_count")
	local bonus_lv20 = false
	if caster:HasAbility("heroTalent_npc_dota_hero_lycan_2") then 
		count = count + 2
		bonus_lv20 = true

	end
	local start_left = -120 * (count*0.5)
	

	for i = 0, count do	
		--LV20解锁头狼	
		if i==0 and self.advanced_level>=20 then
			local unit = caster:SummonUnit("npc_hd_normal_wolf",life_duration,
			-- self:GetCaster():GetAbsOrigin() + (self:GetCaster():GetForwardVector() * 200) + (self:GetCaster():GetRightVector() * (120 * (i - ((count - 1) / 2)))),
			self:GetCaster():GetAbsOrigin() + (self:GetCaster():GetForwardVector() * 200) + (self:GetCaster():GetRightVector() * (start_left+120 * i)),
			self:GetCaster():GetForwardVector(),self,0,heal*1.5,mana,damage*1.5,armor*1.5,1,1)
			
			unit:AddNewModifier(caster, self, "modifier_Advanced_summon_wolves_leder", {})
			table.insert(self.summon_table,unit)
			
			-- Add spawn particles in spawn location
			wolves_spawn_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_lycan/lycan_summon_wolves_spawn.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit)
			ParticleManager:ReleaseParticleIndex(wolves_spawn_particle)
			unit:SetForwardVector(self:GetCaster():GetForwardVector())
			unit:AddNewModifier(caster, self, "modifier_Advanced_summon_wolves", {})
			if self.unlock3 and caster:IsInNightTime() then
				local ability = unit:AddAbility("creeps_spell_Howl")
				ability:SetLevel(1)
			end
		else
			if i==count and self.advanced_level>=20 and bonus_lv20 then
				local unit = caster:SummonUnit("npc_hd_normal_wolf",life_duration,
				-- self:GetCaster():GetAbsOrigin() + (self:GetCaster():GetForwardVector() * 200) + (self:GetCaster():GetRightVector() * (120 * (i - ((count - 1) / 2)))),
				self:GetCaster():GetAbsOrigin() + (self:GetCaster():GetForwardVector() * 200) + (self:GetCaster():GetRightVector() * (start_left+120 * i)),
				self:GetCaster():GetForwardVector(),self,0,heal*1.5,mana,damage*1.5,armor*1.5,1,1)
				
				unit:AddNewModifier(caster, self, "modifier_Advanced_summon_wolves_leder", {})
				table.insert(self.summon_table,unit)
				
				-- Add spawn particles in spawn location
				wolves_spawn_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_lycan/lycan_summon_wolves_spawn.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit)
				ParticleManager:ReleaseParticleIndex(wolves_spawn_particle)
				unit:SetForwardVector(caster:GetForwardVector())
				unit:AddNewModifier(caster, self, "modifier_Advanced_summon_wolves", {})
				if self.unlock3 and caster:IsInNightTime() then
					local ability = unit:AddAbility("creeps_spell_Howl")
					ability:SetLevel(1)
				end
			else
				local unit = caster:SummonUnit("npc_hd_normal_wolf",life_duration,
				caster:GetAbsOrigin() + (caster:GetForwardVector() * 200) + (caster:GetRightVector() * (start_left+120 * i)),
				caster:GetForwardVector(),self,0,heal,mana,damage,armor,1,1)

		
				table.insert(self.summon_table,unit)
				
				-- Add spawn particles in spawn location
				wolves_spawn_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_lycan/lycan_summon_wolves_spawn.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit)
				ParticleManager:ReleaseParticleIndex(wolves_spawn_particle)
				unit:AddNewModifier(caster, self, "modifier_Advanced_summon_wolves", {})
				if self.unlock3 and caster:IsInNightTime() then
					local ability = unit:AddAbility("creeps_spell_Howl")
					ability:SetLevel(1)
				end
			end
			
		end


		
		

	end	

	for i = 0, ex_count do	
		if ex_count==0 then
			break
		end
		local index = 0.5
		if i<big_wolf then
			index = 1
		end
		local unit = caster:SummonUnit("npc_hd_normal_wolf",life_duration,
		self:GetCaster():GetAbsOrigin() + (self:GetCaster():GetForwardVector() * 400) + (self:GetCaster():GetRightVector() * 120 * (i - ((ex_count - 1) / 2))),
		self:GetCaster():GetForwardVector(),self,0,heal*index,0,damage*index,armor*index,1,1)

		if index==0.5 then
			unit:SetModelScale(0.6)
		end
		table.insert(self.summon_table,unit)
		
		-- Add spawn particles in spawn location
		wolves_spawn_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_lycan/lycan_summon_wolves_spawn.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit)
		ParticleManager:ReleaseParticleIndex(wolves_spawn_particle)
		unit:AddNewModifier(caster, self, "modifier_Advanced_summon_wolves", {})
	end

	if howl then
		for _, unit in ipairs(self.summon_table) do
			ability_Advanced_howl:SpellEffect(unit)
		end
		
	end
end





modifier_Advanced_summon_wolves= class({})

function modifier_Advanced_summon_wolves:IsDebuff()			return false end
function modifier_Advanced_summon_wolves:IsHidden() 			return true end
function modifier_Advanced_summon_wolves:IsPurgable() 		return false end
function modifier_Advanced_summon_wolves:IsPurgeException() 	return false end
function modifier_Advanced_summon_wolves:DeclareFunctions() 
	local fun = {
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,       --攻击速度
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,       --移动速度百分比
		MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT,

	}
	if self:GetAbility():GetUnlock(2)==2 then
		table.insert(fun,MODIFIER_EVENT_ON_DEATH)
	end
	return fun
end




function modifier_Advanced_summon_wolves:GetModifierBaseAttackTimeConstant()
	return self.rate or 1.2
end
function modifier_Advanced_summon_wolves:GetModifierAttackSpeedBonus_Constant() 	
	if self:GetStackCount()==1 then
		return 290
	end
	return 90 
end
function modifier_Advanced_summon_wolves:GetModifierMoveSpeedBonus_Percentage()	return 20 end

function modifier_Advanced_summon_wolves:OnCreated(keys)
	self.advanced_level = self:GetAbility():GetSpecialValueFor("advanced_level")
	--LV10解锁迅疾
	if self.advanced_level>=10 then
		self.rate = 1
	end
	if IsServer() then
		if self:GetAbility().unlock3 then
			self:StartIntervalThink(0.5)

		end
		
	end

end
function modifier_Advanced_summon_wolves:OnTakeDamage( params )

	if IsServer() then
		local Attacker = params.attacker
		local Target = params.unit



		if Attacker ~= self:GetParent() or Target == nil then
			return 0
		end
		local Ability = params.inflictor
		local flDamage = params.damage
		local caster = self:GetCaster()
		local ability = self:GetAbility()
		if not ability or ability:IsNull() then
			return
		end

		if bit.band( params.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION ) == DOTA_DAMAGE_FLAG_REFLECTION then
			return 0
		end
		if bit.band( params.damage_flags, DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL ) == DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL then
			return 0
		end
		-- if self:GetParent():PassivesDisabled() then
		-- 	return
		-- end
		local unit_list = self:GetAbility().summon_table
		local index = 0.15
		if self:GetAbility().unlock1 then
			index = 0.35
		end
		local flLifesteal = flDamage * index
		if flLifesteal<=0 then
			return
		end
		for key, unit in pairs(unit_list) do
			--不为自己治疗
			if IsValidEntity(unit) and unit:IsAlive() and unit:GetHealthPercent()<100 and  unit~=Attacker then
				local healing = HealWithGain(flLifesteal,caster,unit,self:GetAbility())
				SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, unit, healing, nil)
				local nFXIndex = ParticleManager:CreateParticle( "particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit )
				ParticleManager:ReleaseParticleIndex( nFXIndex )

			end
			
		end

		--LV5解锁种族链接
		if self.advanced_level>=5 and caster:GetHealthPercent()<100 then
			local healing = HealWithGain(flLifesteal,caster,caster,self:GetAbility())
			SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, caster, healing, nil)
			local nFXIndex = ParticleManager:CreateParticle( "particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster )
			ParticleManager:ReleaseParticleIndex( nFXIndex )
		end


	end

	return 0.0

end


function modifier_Advanced_summon_wolves:OnIntervalThink()
	if self:GetParent():IsInNightTime() then
		self:SetStackCount(1)
	else
		self:SetStackCount(0)
	end
end
function modifier_Advanced_summon_wolves:OnDeath(keys)
    if not IsServer() then
        return
    end

    if keys.attacker == self:GetParent() and IsEnemy(keys.unit, keys.attacker) then
	
		self:GetAbility().unlock2_point = self:GetAbility().unlock2_point +1
		print(self:GetAbility().unlock2_point)
    end
   
end




modifier_Advanced_summon_wolves_leder= class({})

function modifier_Advanced_summon_wolves_leder:IsDebuff()			return false end
function modifier_Advanced_summon_wolves_leder:IsHidden() 			return true end
function modifier_Advanced_summon_wolves_leder:IsPurgable() 		return false end
function modifier_Advanced_summon_wolves_leder:IsPurgeException() 	return false end
function modifier_Advanced_summon_wolves_leder:IsAura()
	if IsServer() then
		if self:GetAbility() and self:GetAbility().unlock1 then
			return true
		end
	end
	
	return false
end

function modifier_Advanced_summon_wolves_leder:GetModifierAura()	return "modifier_Advanced_summon_wolves_leder_unlock1" end
function modifier_Advanced_summon_wolves_leder:GetAuraRadius()	return 600  end
function modifier_Advanced_summon_wolves_leder:GetAuraSearchTeam()	return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_Advanced_summon_wolves_leder:GetAuraSearchType()	return DOTA_UNIT_TARGET_BASIC end
function modifier_Advanced_summon_wolves_leder:GetAuraSearchFlags()	return DOTA_UNIT_TARGET_FLAG_INVULNERABLE  end
function modifier_Advanced_summon_wolves_leder:GetAuraEntityReject(hEntity)

	if hEntity == self:GetParent() then
		return true
	end
	return false
end

	
function modifier_Advanced_summon_wolves_leder:OnCreated()
	if IsClient() then
		return
	end

	if self:GetAbility().unlock1 then
		self.model = "models/items/lycan/wolves/frostivus2018_lycan_savage_beast_wolves/frostivus2018_lycan_savage_beast_wolves.vmdl"
	end
	self.parent		= self:GetParent()
	self.particle = ParticleManager:CreateParticle("particles/units/heroes/hero_huskar/huskar_berserkers_blood.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent )
	ParticleManager:SetParticleControl(self.particle, 1, Vector( 1000, 0, 0))

end


function modifier_Advanced_summon_wolves_leder:OnDestroy()
	if not IsServer() then return end

	ParticleManager:DestroyParticle(self.particle, false)
	ParticleManager:ReleaseParticleIndex(self.particle)
	

end



function modifier_Advanced_summon_wolves_leder:DeclareFunctions()	
	local fun ={
		MODIFIER_PROPERTY_MODEL_SCALE
	}
	if self:GetAbility():GetUnlock(1)==1 then
		table.insert(fun,MODIFIER_PROPERTY_MODEL_CHANGE)
	end
	return fun

end
function modifier_Advanced_summon_wolves_leder:GetModifierModelChange()
	if self.model then
		return self.model
	end
	return "models/items/lycan/wolves/frostivus2018_lycan_winter_snow_wolf_wolves/frostivus2018_lycan_winter_snow_wolf_wolves.vmdl"
end

function modifier_Advanced_summon_wolves_leder:GetModifierModelScale()
	return 50
end





modifier_Advanced_summon_wolves_leder_unlock1 = class({})
function modifier_Advanced_summon_wolves_leder_unlock1:IsDebuff()			return false end
function modifier_Advanced_summon_wolves_leder_unlock1:IsHidden() 			return false end
function modifier_Advanced_summon_wolves_leder_unlock1:IsPurgable() 		return false end
function modifier_Advanced_summon_wolves_leder_unlock1:IsPurgeException() 	return false end
function modifier_Advanced_summon_wolves_leder_unlock1:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_Advanced_summon_wolves_leder_unlock1:DeclareFunctions()	return {MODIFIER_EVENT_ON_ATTACK_LANDED} end

function modifier_Advanced_summon_wolves_leder_unlock1:OnAttackLanded(keys)
	if not IsServer() then
		return 
	end
	local parent = self:GetParent()
	if keys.attacker ~= parent or parent:IsIllusion() or parent:PassivesDisabled() or not keys.target:IsAlive() then
		return
	end
	if keys.target:IsBuilding() or keys.target:IsOther() then
		return
	end

	if not parent:IsApplyModifier() or parent:IsInSpecialAttack()  then
		return
	end
    if  self:GetAbility():IsCooldownReady() then
       if 30 > RandomInt(0,100) then
		local unit = self:GetAuraOwner()
		local modifier_keys = {
			duration = 0.1,
			iSpecialAttack = 1,
			iDisableApplyModifier = 0,
			iDisableCleave =1,
			iDisableSplit = 1,
	
		}

		local attackEffectRecord = unit:AddAttackEffectModifier(self:GetAbility(),modifier_keys)
        unit:PerformAttack(keys.target, false, true, true, true, false, false, true)
		if IsValid(attackEffectRecord) then
			attackEffectRecord:Destroy()
		end
        local particle = ParticleManager:CreateParticle("particles/rebuild/spell/wolfs/unlock1/effect.vpcf", PATTACH_CENTER_FOLLOW, unit)
		ParticleManager:SetParticleControlEnt(particle, 0, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(particle, 1, keys.target, PATTACH_POINT_FOLLOW, "attach_hitloc", keys.target:GetAbsOrigin(), true)
		ParticleManager:ReleaseParticleIndex(particle)
	
	     end
    end
end


