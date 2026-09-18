--特效优化 √
Advanced_feast = class({})
-- LinkLuaModifier("modifier_Advanced_feast_arua", "special_gain/Advanced_feast", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_Advanced_feast_arua_effect", "special_gain/Advanced_feast", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_feast", "skills/Advanced_feast", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_feast_damage", "skills/Advanced_feast", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_Advanced_feast_active", "special_gain/Advanced_feast", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_Advanced_feast_effect", "special_gain/Advanced_feast", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_Advanced_feast_effect2", "special_gain/Advanced_feast", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_Advanced_feast_active_standby", "special_gain/Advanced_feast", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_Advanced_feast_debuff", "special_gain/Advanced_feast", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_Advanced_feast_thinker", "special_gain/Advanced_feast", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_Advanced_feast_unlock3", "skills/Advanced_feast", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_feast_unlock3_active", "skills/Advanced_feast", LUA_MODIFIER_MOTION_NONE)

function Advanced_feast:CheckKV(key)
	local table = {


		bonus_life_steal = 0.1,
		bonus_damage = 10,


	}
	local value = table[key] or -1
	return value

end
function Advanced_feast:UnlockFirstCore(key)
	-- local caster = self:GetCaster()
	-- caster:AddNewModifier(caster,self,"modifier_Advanced_Viscous_Nasal_Goo_unlock1",{})
	return true
end
function Advanced_feast:UnlockSecondCore(key)
	-- local caster = self:GetCaster()
	-- self.modifier = caster:AddNewModifier(caster,self,"modifier_Advanced_Viscous_Nasal_Goo_unlock2",{})
	return true
end
function Advanced_feast:UnlockThirdCore(key)
	local caster = self:GetCaster()
	local modifier = caster:AddNewModifier(caster,self,"modifier_Advanced_feast_unlock3",{})
	return true

end
function Advanced_feast:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/spell/feast/unlock3/effect.vpcf", context )

end






-- Item Passive
-- require('internal/timers')   --计时器功能
function Advanced_feast:GetIntrinsicModifierName()
	return "modifier_Advanced_feast"
end

function Advanced_feast:OnSpellStart()
	

	local caster = self:GetCaster()
	local modifier = caster:FindModifierByName("modifier_Advanced_feast_unlock3")
	if modifier then

		local target = self:GetCursorTarget()
		local modifier_target = target:FindModifierByName("modifier_Advanced_feast_unlock3_active")
		if modifier_target then
			return
		end
		self.target = target
		self.target:AddNewModifier(caster, self, "modifier_Advanced_feast_unlock3_active", {})
		modifier:SafeDestroy()
		caster:EmitSound("hero_bloodseeker.bloodRage")
		-- local particleName = "particles/econ/items/riki/riki_head_ti8/riki_smokebomb_ti8_crimson.vpcf"
		-- local pfx = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, target)
		-- ParticleManager:SetParticleControl(pfx,0,target:GetOrigin())
		-- ParticleManager:SetParticleControl(pfx,1,Vector(325,325,325))
		-- ParticleManager:ReleaseParticleIndex(pfx)
		-- caster:EmitSound("Hero_Riki.Smoke_Screen.ti8")
		return
	end

	self:OnToggle()
	


end


function Advanced_feast:GetBehavior()


	if self:GetCaster():HasModifier("modifier_Advanced_feast_unlock3") then
		return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET
	end
	if self:GetUnlock(3)==3 then
		return DOTA_ABILITY_BEHAVIOR_PASSIVE
	end
	return self.BaseClass.GetBehavior(self)
	
end
function Advanced_feast:CastFilterResultTarget( target )
	-- check nohammer
	if IsServer() then
		if not target:IsRealHero() then
			return UF_FAIL_CUSTOM
		end
		if target==self:GetCaster() then
			return UF_FAIL_CUSTOM
		end
		local modifier = target:FindModifierByName("modifier_Advanced_feast_unlock3_active")
		if modifier then
			return UF_FAIL_CUSTOM
		end

		return UF_SUCCESS
	end
	
end
function Advanced_feast:GetCustomCastErrorTarget( target )
	-- check nohammer
	if IsServer() then
	    return "#DOTA_HUB_CANT_CAST_TO_TARGET"
	end

end


modifier_Advanced_feast = class({})

function modifier_Advanced_feast:IsDebuff() return false end
function modifier_Advanced_feast:IsHidden() return true end
function modifier_Advanced_feast:IsPurgable() 		return false end
function modifier_Advanced_feast:IsPurgeException() 	return false end
function modifier_Advanced_feast:RemoveOnDeath()  return false end



function modifier_Advanced_feast:OnCreated(keys)
    self.ability = self:GetAbility()

 
    -- local parent = self:GetParent()
	self.life_steal_count = 0

	
	-- self.bonus_life_steal = self.ability:GetSpecialValueFor("bonus_life_steal")*0.01  --在这里先计算就不用每次攻击都浪费一次计算了
	


 
end



function modifier_Advanced_feast:DeclareFunctions()
	return {
		
		MODIFIER_EVENT_ON_TAKEDAMAGE,                       --受到伤害事件
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		

	}
end

function modifier_Advanced_feast:GetModifierPreAttack_BonusDamage()
	return self:GetAbility():GetSpecialValueFor("bonus_damage")
end

function modifier_Advanced_feast:OnTakeDamage( params )

	if IsServer() then
		local Attacker = params.attacker
		local Target = params.unit
		local Ability = params.inflictor
		local flDamage = params.damage
		local feast_aiblity = self:GetAbility()


		if Attacker ~= self:GetParent() or Target == nil then
			return 0
		end

		if params.damage_category == 0 and not feast_aiblity.unlock1 then   --DOTA_DAMAGE_CATEGORY_SPELL = 0 只能是攻击伤害
			return
		end

		if bit.band( params.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION ) == DOTA_DAMAGE_FLAG_REFLECTION then
			return 0
		end
		if bit.band( params.damage_flags, DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL ) == DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL then
			return 0
		end
		if flDamage<=0 then
			return
		end
		if Attacker:PassivesDisabled() then
			return
		end
		self.advanced_level = feast_aiblity.advanced_level

		self.bonus_life_steal = (self.ability:GetSpecialValueFor("bonus_life_steal"))*0.01
		local gain = 0
		--LV20解锁真祖
		if Attacker:GetModifierLifeStealGain(1)>0 and self.advanced_level>=20 then
			gain = Attacker:GetModifierLifeStealGain(3)
		else
			gain = Attacker:GetModifierLifeStealGain(1)
		end
		local flLifesteal = flDamage * self.bonus_life_steal*gain
		local steal_basic_health = 0.01
		--LV10解锁暴食症+
		if self.advanced_level >=10 then
			steal_basic_health = 0.02
		end
		--暴食症增益
		local health_gain = 1+(100-Attacker:GetHealthPercent())*steal_basic_health
		flLifesteal = flLifesteal*health_gain
		if flLifesteal<=0 then
			return
		end

		if feast_aiblity.unlock3 and feast_aiblity.target then
			if Ability then
				local nFXIndex = ParticleManager:CreateParticle( "particles/items3_fx/octarine_core_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, Attacker )
				ParticleManager:ReleaseParticleIndex( nFXIndex )
				local nFXIndex = ParticleManager:CreateParticle( "particles/items3_fx/octarine_core_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, feast_aiblity.target )
				ParticleManager:ReleaseParticleIndex( nFXIndex )
			else
				local nFXIndex = ParticleManager:CreateParticle( "particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, Attacker )
				ParticleManager:ReleaseParticleIndex( nFXIndex )
				local nFXIndex = ParticleManager:CreateParticle( "particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, feast_aiblity.target )
				ParticleManager:ReleaseParticleIndex( nFXIndex )
			end
			local self_steal_index = 2.5
			flLifesteal = flLifesteal*self_steal_index
			Attacker:Heal( flLifesteal, feast_aiblity )
			feast_aiblity.target:Heal( flLifesteal, feast_aiblity )
			
			self.life_steal_count = self.life_steal_count+flLifesteal
			local index = Attacker:GetAverageTrueAttackDamage(Attacker)*2
			if index>=0 and self.life_steal_count>=index  then
				self.life_steal_count = self.life_steal_count - index
				Attacker:AddNewModifier(Attacker, self:GetAbility(), "modifier_Advanced_feast_damage", {duration = 5})
			end
			return
		end


		if feast_aiblity:GetToggleState() then
			--激活独食
			if Ability then
				local nFXIndex = ParticleManager:CreateParticle( "particles/items3_fx/octarine_core_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, Attacker )
				ParticleManager:ReleaseParticleIndex( nFXIndex )
			else
				local nFXIndex = ParticleManager:CreateParticle( "particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, Attacker )
				ParticleManager:ReleaseParticleIndex( nFXIndex )
			end
			local self_steal_index = 1.6
			--LV5解锁独食+
			if self.advanced_level>=5 then
				self_steal_index = 2.5
			end
			flLifesteal = flLifesteal*self_steal_index
			Attacker:Heal( flLifesteal, feast_aiblity )
			
			self.life_steal_count = self.life_steal_count+flLifesteal
		else
			--分享
			local unit = FinDLowestHealthPerAllyInRange(Attacker, 1000 )
			if unit then

				--恢复自己
				if Ability then
					local nFXIndex = ParticleManager:CreateParticle( "particles/items3_fx/octarine_core_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, Attacker )
					ParticleManager:ReleaseParticleIndex( nFXIndex )
				else
					local nFXIndex = ParticleManager:CreateParticle( "particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, Attacker )
					ParticleManager:ReleaseParticleIndex( nFXIndex )
				end

				Attacker:Heal( flLifesteal, feast_aiblity )
				---------------------------------------------------------
				--恢复友军
				if Ability then
					local nFXIndex = ParticleManager:CreateParticle( "particles/items3_fx/octarine_core_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit )
					ParticleManager:ReleaseParticleIndex( nFXIndex )
				else
					local nFXIndex = ParticleManager:CreateParticle( "particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit )
					ParticleManager:ReleaseParticleIndex( nFXIndex )
				end

				unit:Heal( flLifesteal, feast_aiblity )

				--LV5解锁分享+
				if self.advanced_level>=5 then
					local unit = FinDLowestHealthPerAllyInRange(Attacker, 1000 )
					if unit then
		
						--恢复自己
						if Ability then
							local nFXIndex = ParticleManager:CreateParticle( "particles/items3_fx/octarine_core_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, Attacker )
							ParticleManager:ReleaseParticleIndex( nFXIndex )
						else
							local nFXIndex = ParticleManager:CreateParticle( "particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, Attacker )
							ParticleManager:ReleaseParticleIndex( nFXIndex )
						end
		
						Attacker:Heal( flLifesteal, feast_aiblity )
						---------------------------------------------------------
						--恢复友军
						if Ability then
							local nFXIndex = ParticleManager:CreateParticle( "particles/items3_fx/octarine_core_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit )
							ParticleManager:ReleaseParticleIndex( nFXIndex )
						else
							local nFXIndex = ParticleManager:CreateParticle( "particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit )
							ParticleManager:ReleaseParticleIndex( nFXIndex )
						end
		
						unit:Heal( flLifesteal, feast_aiblity )
		
				
					end
				end

				
			else
				--当区域内没有可以触发的友军单位时仍旧触发独食
				--激活独食
				if Ability then
					local nFXIndex = ParticleManager:CreateParticle( "particles/items3_fx/octarine_core_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, Attacker )
					ParticleManager:ReleaseParticleIndex( nFXIndex )
				else
					local nFXIndex = ParticleManager:CreateParticle( "particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, Attacker )
					ParticleManager:ReleaseParticleIndex( nFXIndex )
				end
				local self_steal_index = 1.6
				--LV5解锁独食+
				if self.advanced_level>=5 then
					self_steal_index = 2.5
				end
				flLifesteal = flLifesteal*self_steal_index
				Attacker:Heal( flLifesteal, feast_aiblity )

			end

		end
		--LV15解锁血液狂乱
		if self.advanced_level>=15 then
			self.life_steal_count = self.life_steal_count+flLifesteal
			local index = Attacker:GetAverageTrueAttackDamage(Attacker)*2
			if index>=0 and self.life_steal_count>=index  then
				self.life_steal_count = self.life_steal_count - index
				Attacker:AddNewModifier(Attacker, self:GetAbility(), "modifier_Advanced_feast_damage", {duration = 5})
			end
		end
	end
	return 0.0
end




modifier_Advanced_feast_damage = class({})

function modifier_Advanced_feast_damage:IsDebuff() return false end
function modifier_Advanced_feast_damage:IsHidden() return true end
function modifier_Advanced_feast_damage:IsPurgable() return false end
function  modifier_Advanced_feast_damage:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end




function modifier_Advanced_feast_damage:DeclareFunctions()
	return {

		MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
	}
end

function modifier_Advanced_feast_damage:GetModifierBaseDamageOutgoing_Percentage() return self:GetStackCount()* 10 end






function modifier_Advanced_feast_damage:OnCreated(params)
	self.ability = self:GetAbility()
	if IsServer() then
		self.tData = {}
		table.insert(self.tData, { dieTime = self:GetDieTime() })
		self:IncrementStackCount()
		self:StartIntervalThink(0.1)
		
		-- self.bonus_armor = self.ability:GetSpecialValueFor("bonus_armor")
		-- self.bonus_health_regeneration = self.ability:GetSpecialValueFor("bonus_health_regeneration")
	end
end
function modifier_Advanced_feast_damage:OnRefresh(params)
	if IsServer() then
		local dieTime = self:GetDieTime()

		
		if self:GetStackCount()>= 15 then
			--移除第一个 添加一个
			table.remove(self.tData, 1)
			table.insert(self.tData, {dieTime = dieTime })

		else
			--当叠加乘数没达到最高时
			table.insert(self.tData, {dieTime = dieTime })
			self:IncrementStackCount()
		end
	end
end

function modifier_Advanced_feast_damage:OnIntervalThink()
	if IsServer() then
		-- local hParent = self:GetParent()
		local fGameTime = GameRules:GetGameTime()

		for i = #self.tData, 1, -1 do
			if fGameTime >= self.tData[i].dieTime then
				table.remove(self.tData, i)
				self:DecrementStackCount()
			end
		end
	end
end




modifier_Advanced_feast_unlock3 = class({})

function modifier_Advanced_feast_unlock3:IsDebuff()			return false end
function modifier_Advanced_feast_unlock3:IsHidden() 			return true end
function modifier_Advanced_feast_unlock3:IsPurgable() 		return false end
function modifier_Advanced_feast_unlock3:IsPurgeException() 	return false end
function modifier_Advanced_feast_unlock3:RemoveOnDeath() return false end




modifier_Advanced_feast_unlock3_active = class({})

function modifier_Advanced_feast_unlock3_active:IsDebuff()			return false end
function modifier_Advanced_feast_unlock3_active:IsHidden() 			return false end
function modifier_Advanced_feast_unlock3_active:IsPurgable() 		return false end
function modifier_Advanced_feast_unlock3_active:IsPurgeException() 	return false end
function modifier_Advanced_feast_unlock3_active:RemoveOnDeath() return false end

function modifier_Advanced_feast_unlock3_active:OnCreated(keys)
    self.ability = self:GetAbility()
	self.life_steal_count = 0
	if IsServer() then
		local pfx_name ="particles/rebuild/spell/feast/unlock3/effect.vpcf"
		self.pfx = ParticleManager:CreateParticle(pfx_name, PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControlEnt(self.pfx, 1, self:GetCaster(), PATTACH_CENTER_FOLLOW, "attach_hitloc", self:GetCaster():GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(self.pfx, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
		self:AddParticle(self.pfx, false, false, 15, false, false)
	end
end



function modifier_Advanced_feast_unlock3_active:DeclareFunctions()
	return {
		
		MODIFIER_EVENT_ON_TAKEDAMAGE,                       --受到伤害事件
	
		

	}
end


function modifier_Advanced_feast_unlock3_active:OnTakeDamage( params )

	if IsServer() then
		local Attacker = params.attacker
		local Target = params.unit
		local Ability = params.inflictor
		local flDamage = params.damage
		local feast_aiblity = self:GetAbility()


		if not feast_aiblity then
			self:SafeDestroy()
			return
		end
		if Attacker ~= self:GetParent() or Target == nil then
			return 0
		end

		if params.damage_category == 0 and not feast_aiblity.unlock1 then   --DOTA_DAMAGE_CATEGORY_SPELL = 0 只能是攻击伤害
			return
		end

		if bit.band( params.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION ) == DOTA_DAMAGE_FLAG_REFLECTION then
			return 0
		end
		if bit.band( params.damage_flags, DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL ) == DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL then
			return 0
		end
		if flDamage<=0 then
			return
		end
		if Attacker:PassivesDisabled() then
			return
		end
		self.advanced_level = feast_aiblity.advanced_level

		self.bonus_life_steal = (self.ability:GetSpecialValueFor("bonus_life_steal"))*0.01
		local gain = 0

		if Attacker:GetModifierLifeStealGain(1)>0  then
			gain = Attacker:GetModifierLifeStealGain(3)
		else
			gain = Attacker:GetModifierLifeStealGain(1)
		end
		local flLifesteal = flDamage * self.bonus_life_steal*gain
		local steal_basic_health = 0.02
		--暴食症增益
		local health_gain = 1+(100-Attacker:GetHealthPercent())*steal_basic_health
		flLifesteal = flLifesteal*health_gain
		if flLifesteal<=0 then
			return
		end
		if Ability then
			local nFXIndex = ParticleManager:CreateParticle( "particles/items3_fx/octarine_core_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, Attacker )
			ParticleManager:ReleaseParticleIndex( nFXIndex )
		else
			local nFXIndex = ParticleManager:CreateParticle( "particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, Attacker )
			ParticleManager:ReleaseParticleIndex( nFXIndex )
		end
		local self_steal_index = 1.6
		--LV5解锁独食+
		if self.advanced_level>=5 then
			self_steal_index = 2.5
		end
		flLifesteal = flLifesteal*self_steal_index
		Attacker:Heal( flLifesteal, feast_aiblity )

		self.life_steal_count = self.life_steal_count+flLifesteal
		local index = Attacker:GetAverageTrueAttackDamage(Attacker)*2
		if index>=0 and self.life_steal_count>=index  then
			self.life_steal_count = self.life_steal_count - index
			Attacker:AddNewModifier(Attacker, self:GetAbility(), "modifier_Advanced_feast_damage", {duration = 5})
		end
	
	end
	return 0.0
end
