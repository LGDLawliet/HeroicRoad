--特效优化 √
Advanced_invincible_army = class({})
require("internal/timers")
LinkLuaModifier("modifier_Advanced_invincible_army_thinker", "skills/Advanced_invincible_army", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_invincible_army_triger", "skills/Advanced_invincible_army", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_invincible_army_kill", "skills/Primary_invincible_army", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_Advanced_invincible_army_buff", "skills/Advanced_invincible_army", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_invincible_army_unlock2", "skills/Advanced_invincible_army", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_Advanced_invincible_army_damage", "skills/Advanced_invincible_army", LUA_MODIFIER_MOTION_NONE)


function Advanced_invincible_army:Precache( context )

	
	-- PrecacheResource( "particle", "particles/items2_fx/teleport_end.vpcf", context )
	PrecacheResource( "particle", "particles/status_fx/status_effect_techies_tazer.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/spell/invincible_army/invincible_armyecon/events/ti7/teleport_end_ti7_lvl2.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/spell/invincible_army/ring/ring_army_hot_edge.vpcf", context )
	PrecacheResource( "particle", "particles/econ/events/pw_compendium_2014/teleport_start_l_pw2014.vpcf", context )

end
function Advanced_invincible_army:UnlockFirstCore(key)
	-- self:GetCaster():AddItemByName("item_hd_infernal_menace")
	-- local caster = self:GetCaster()
	-- local modifier = caster:AddNewModifier(caster,self,"modifier_Advanced_hyakkiyakou_unlock1",{})
	
	return true
end
function Advanced_invincible_army:UnlockSecondCore(key)
	local caster = self:GetCaster()
	local modifier = caster:AddNewModifier(caster,self,"modifier_Advanced_invincible_army_unlock2",{})
	
	return true
end
function Advanced_invincible_army:UnlockThirdCore(key)
	-- self:GetCaster():AddItemByName("item_hd_infernal_menace")
	-- local caster = self:GetCaster()
	-- local modifier = caster:AddNewModifier(caster,self,"modifier_Advanced_fear_arua_unlock2",{})
	
	return true
end
function Advanced_invincible_army:CheckKV(key)
	local table = {

	

		bonus_damage = 0.08,
		-- duration = 0.3,


	}
	local value = table[key] or -1
	return value

end
function Advanced_invincible_army:IsHiddenWhenStolen() 	return false end
function Advanced_invincible_army:IsRefreshable() 		return true end
function Advanced_invincible_army:IsStealable() 			return true end

function Advanced_invincible_army:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end
function Advanced_invincible_army:OnSpellStart()

	local caster = self:GetCaster()
	local pos = self:GetCursorPosition()
	local thinker =CreateModifierThinker(
		self:GetCaster(),
		self,
		"modifier_Advanced_invincible_army_thinker",
		{
			duration = self:GetSpecialValueFor("duration"),
		},
		pos,
		self:GetCaster():GetTeamNumber(),
		false
	)
	caster:EmitSound("Visage_Familar.BellToll")	
	caster:EmitSound("Loot_Drop_Stinger_Arcana")	
end


function Advanced_invincible_army:OnProjectileHit_ExtraData(target, location, keys)
	-- print("aaa")
	if not target or target:IsMagicImmune() then
		return
	end
	target:EmitSound("Hero_ArcWarden.SparkWraith.Damage")
	local caster = self:GetCaster()
	local dmg = self:GetSpecialValueFor("damage")+self:GetSpecialValueFor("bonus_damage")*caster:GetIntellect(false)
	local damageTable = {
						victim = target,
						attacker = self:GetCaster(),
						damage = dmg,
						damage_type = self:GetAbilityDamageType(),
						damage_flags = DOTA_DAMAGE_FLAG_NONE, 
						ability = self,
						}
	ApplyDamage(damageTable)

	
end



modifier_Advanced_invincible_army_thinker = class({})
function modifier_Advanced_invincible_army_thinker:IsAura()
	return self.arua
end

function modifier_Advanced_invincible_army_thinker:GetModifierAura()	return "modifier_Advanced_invincible_army_buff" end
function modifier_Advanced_invincible_army_thinker:GetAuraRadius()	return self.radius  end
function modifier_Advanced_invincible_army_thinker:GetAuraSearchTeam()	return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_Advanced_invincible_army_thinker:GetAuraSearchType()	return DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC end

function modifier_Advanced_invincible_army_thinker:GetAuraSearchFlags()	return DOTA_UNIT_TARGET_FLAG_INVULNERABLE  end


function modifier_Advanced_invincible_army_thinker:OnCreated(params)
	local ability = self:GetAbility()
	self.arua = false
	if ability:GetSpecialValueFor("advanced_level")>=15 then
		self.arua = true
	end
	if IsServer() then
		
		self.radius = ability:GetSpecialValueFor("radius")
		self.life_time = ability:GetSpecialValueFor("life_duration")
		self.effect_cast = ParticleManager:CreateParticle( "particles/rebuild/spell/invincible_army/ring/ring_army_hot_edge.vpcf", PATTACH_CUSTOMORIGIN, self:GetParent() )
		ParticleManager:SetParticleControl( self.effect_cast, 0, self:GetParent():GetAbsOrigin()  )
		ParticleManager:SetParticleControl( self.effect_cast, 1, Vector(self.radius, self.radius, self.radius) )



		-- self.effect_cast2 = ParticleManager:CreateParticle( "particles/econ/items/arc_warden/arc_warden_ti9_immortal/arc_warden_ti9_wraith.vpcf", PATTACH_CUSTOMORIGIN, self:GetParent() )
		-- ParticleManager:SetParticleControl( self.effect_cast2, 0, self:GetParent():GetAbsOrigin() + Vector(0,0,65) )
		-- ParticleManager:SetParticleControl( self.effect_cast2, 1, Vector(self.radius, self.radius, self.radius) )
		self.interval = ability:GetSpecialValueFor("interval")
		self.timer = 0
		if ability.advanced_level>=20 then
			self.interval = self.interval*0.8
			self.life_time = self.life_time - 1
			if ability.unlock1 then
				self.unlock1 = true
				self.interval = 0.1
				self.count = 0
			end
		end
		self:StartIntervalThink(self.interval)
		self:GetParent():EmitSound("Hero_ArcWarden.SparkWraith.Appear")	
	end
end

function modifier_Advanced_invincible_army_thinker:OnIntervalThink()

	local ability = self:GetAbility()
	if not ability or ability:IsNull() then
		self:SafeDestroy()
		return
	end
	if self.unlock1 then
		self:OnIntervalThinkUnlock1()
		return
	end

	local caster = self:GetCaster()
	local parent = self:GetParent()
	local pos = parent:GetAbsOrigin()
	pos.x = pos.x + RandomInt(-self.radius+200, self.radius-200)
	pos.y = pos.y + RandomInt(-self.radius+200, self.radius-200)
	local pfx = ParticleManager:CreateParticle( "particles/rebuild/spell/invincible_army/invincible_armyecon/events/ti7/teleport_end_ti7_lvl2.vpcf", PATTACH_CUSTOMORIGIN, caster )
	ParticleManager:SetParticleControl( pfx, 0, pos  )
	ParticleManager:SetParticleControl( pfx, 1, pos  )
	-- ParticleManager:SetParticleControl( pfx, 3, pos  )
	ParticleManager:SetParticleControlEnt( pfx, 3, caster, PATTACH_POINT, nil, caster:GetAbsOrigin(), true )
	-- ParticleManager:SetParticleControl( pfx, 3, Vector(5,0,0)  )
	ParticleManager:SetParticleControl( pfx, 4, Vector(1,0,0)  )
	ParticleManager:SetParticleControl( pfx, 5, pos  )
	ParticleManager:SetParticleControl( pfx, 61, Vector(RandomFloat(-180, 180),0,0)  )
	Timers:CreateTimer(3, function()
		ParticleManager:DestroyParticle(pfx, false)
		ParticleManager:ReleaseParticleIndex(pfx)
		-- EmitSoundOnLocationWithCaster(pos, "Portal.Hero_Disappear", nil)
		if caster and not caster:IsNull() and ability and not ability:IsNull() then
			-- HdEmitSoundOnLocation(caster,pos,"Portal.Hero_Disappear",3)
			local illusion =	CreateUnitByName( "npc_hd_double", pos, true, nil, nil, caster:GetTeamNumber() )


			if illusion then

				illusion:SetOriginalModel(caster.origin_model_name)
				illusion:SetModelScale(caster:GetModelScale())
				local hModel = caster:FirstMoveChild()
				while hModel ~= nil do
					if hModel:GetClassname() ~= "" and hModel:GetClassname() == "dota_item_wearable" and hModel:GetModelName() ~= "" then
						local hWearable = SpawnEntityFromTableSynchronous("prop_dynamic", { model = hModel:GetModelName(), origin = illusion:GetAbsOrigin() })
						-- hWearable:SetRenderColor(vRBG.x, vRBG.y, vRBG.z)
						hWearable:FollowEntity(illusion, true)
					end
					hModel = hModel:NextMovePeer()
				end
				illusion:AddNewModifier(caster, ability, "modifier_invincible_army_kill", {duration = self.life_time})
				illusion:AddNewModifier(caster, ability, "modifier_Advanced_invincible_army_triger", {})
				illusion:EmitSound("Portal.Hero_Disappear")
				-- illusion:SetForwardVector(caster:GetForwardVector())
				local angle = caster:GetAngles()
				illusion:SetAngles(angle.x, angle.y, angle.z)
				FindClearSpaceForUnit(illusion, pos, true)
			end


			
		end
		
	end)


	if ability.advanced_level>=15 then
		self.timer =self.timer +self.interval
		if self.timer >=1 then
			self.timer = self.timer - 1
			local units = FindUnitsInRadius(caster:GetTeamNumber(), parent:GetAbsOrigin(), nil, self.radius,
						DOTA_UNIT_TARGET_TEAM_ENEMY,
	   					DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)  
			if #units>=5 and not units[1]:IsNull() then
				local target =  units[1]
				local damageTable = {
					victim 			= units[1],
					damage 			= ability:GetSpecialValueFor("bonus_damage")*caster:GetAgility()*2,
					damage_type		= ability:GetAbilityDamageType(),
					damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
					attacker 		= caster,
					ability 		= ability
				}
				ApplyDamage(damageTable)
				local particle = ParticleManager:CreateParticle("particles/rebuild/spell/invincible_army/lightning/lightning_bolt.vpcf", PATTACH_WORLDORIGIN, target)
				local pos = target:GetAbsOrigin()
				ParticleManager:SetParticleControl(particle, 0, Vector(pos.x, pos.y, pos.z+1000))
				ParticleManager:SetParticleControl(particle, 1, Vector(pos.x, pos.y, pos.z))
				target:EmitSound("Hero_Zuus.LightningBolt")
				-- ParticleManager:SetParticleControl(particle, 2, Vector(pos.x, pos.y, pos.z))
			end
		end
	end

end

function modifier_Advanced_invincible_army_thinker:OnDestroy(params)
	if not IsServer() then
		return
	end
	ParticleManager:DestroyParticle(self.effect_cast, false)
	ParticleManager:ReleaseParticleIndex(self.effect_cast)
	UTIL_Remove( self:GetParent() )
end


function modifier_Advanced_invincible_army_thinker:OnIntervalThinkUnlock1()
	local ability = self:GetAbility()
	if not ability or ability:IsNull() then
		self:SafeDestroy()
		return
	end

	local caster = self:GetCaster()
	local parent = self:GetParent()
	local pos = parent:GetAbsOrigin()
	if self.count<15 then
		self.count = self.count + 1
		pos.x = pos.x + RandomInt(-self.radius+200, self.radius-200)
		pos.y = pos.y + RandomInt(-self.radius+200, self.radius-200)
		local pfx = ParticleManager:CreateParticle( "particles/rebuild/spell/invincible_army/invincible_armyecon/events/ti7/teleport_end_ti7_lvl2.vpcf", PATTACH_CUSTOMORIGIN, caster )
		ParticleManager:SetParticleControl( pfx, 0, pos  )
		ParticleManager:SetParticleControl( pfx, 1, pos  )
		ParticleManager:SetParticleControlEnt( pfx, 3, caster, PATTACH_POINT, nil, caster:GetAbsOrigin(), true )
		ParticleManager:SetParticleControl( pfx, 4, Vector(1,0,0)  )
		ParticleManager:SetParticleControl( pfx, 5, pos  )
		ParticleManager:SetParticleControl( pfx, 61, Vector(RandomFloat(-180, 180),0,0)  )
	
		Timers:CreateTimer(1.3, function()
			ParticleManager:DestroyParticle(pfx, false)
			ParticleManager:ReleaseParticleIndex(pfx)
			-- EmitSoundOnLocationWithCaster(pos, "Portal.Hero_Disappear", nil)
			if caster and not caster:IsNull() and ability and not ability:IsNull() then
				-- HdEmitSoundOnLocation(caster,pos,"Portal.Hero_Disappear",3)
				local illusion =	CreateUnitByName( "npc_hd_double", pos, true, nil, nil, caster:GetTeamNumber() )


				if illusion then

					illusion:SetOriginalModel(caster.origin_model_name)
					illusion:SetModelScale(caster:GetModelScale())
					local hModel = caster:FirstMoveChild()
					while hModel ~= nil do
						if hModel:GetClassname() ~= "" and hModel:GetClassname() == "dota_item_wearable" and hModel:GetModelName() ~= "" then
							local hWearable = SpawnEntityFromTableSynchronous("prop_dynamic", { model = hModel:GetModelName(), origin = illusion:GetAbsOrigin() })
							-- hWearable:SetRenderColor(vRBG.x, vRBG.y, vRBG.z)
							hWearable:FollowEntity(illusion, true)
						end
						hModel = hModel:NextMovePeer()
					end
					illusion:AddNewModifier(caster, ability, "modifier_invincible_army_kill", {duration = self.life_time})
					local modifier = illusion:AddNewModifier(caster, ability, "modifier_Advanced_invincible_army_triger", {})
					if modifier then
						modifier:InitUnlock1(self)
					end
					illusion:EmitSound("Portal.Hero_Disappear")
					-- illusion:SetForwardVector(caster:GetForwardVector())
					local angle = caster:GetAngles()
					illusion:SetAngles(angle.x, angle.y, angle.z)
					FindClearSpaceForUnit(illusion, pos, true)
				end


				
			end
			
		end)
	end
	


	self.timer =self.timer +self.interval
	if self.timer >=1 then
		self.timer = self.timer - 1
		local units = FindUnitsInRadius(caster:GetTeamNumber(), parent:GetAbsOrigin(), nil, self.radius,
					DOTA_UNIT_TARGET_TEAM_ENEMY,
					DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)  
		if #units>=5 and not units[1]:IsNull() then
			local target =  units[1]
			local damageTable = {
				victim 			= units[1],
				damage 			= ability:GetSpecialValueFor("bonus_damage")*caster:GetAgility()*2,
				damage_type		= ability:GetAbilityDamageType(),
				damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
				attacker 		= caster,
				ability 		= ability
			}
			ApplyDamage(damageTable)
			local particle = ParticleManager:CreateParticle("particles/rebuild/spell/invincible_army/lightning/lightning_bolt.vpcf", PATTACH_WORLDORIGIN, target)
			local pos = target:GetAbsOrigin()
			ParticleManager:SetParticleControl(particle, 0, Vector(pos.x, pos.y, pos.z+1000))
			ParticleManager:SetParticleControl(particle, 1, Vector(pos.x, pos.y, pos.z))
			target:EmitSound("Hero_Zuus.LightningBolt")
			-- ParticleManager:SetParticleControl(particle, 2, Vector(pos.x, pos.y, pos.z))
		end
	end
end


function modifier_Advanced_invincible_army_thinker:DecrementCount()
	self.count = self.count - 1
end




modifier_Advanced_invincible_army_triger = advanced_modifier({})

function modifier_Advanced_invincible_army_triger:IsDebuff()			return false end
function modifier_Advanced_invincible_army_triger:IsHidden() 			return false end
function modifier_Advanced_invincible_army_triger:IsPurgable() 		return false end
function modifier_Advanced_invincible_army_triger:IsPurgeException() 	return false end
function modifier_Advanced_invincible_army_triger:GetStatusEffectName() return "particles/status_fx/status_effect_techies_tazer.vpcf" end
function modifier_Advanced_invincible_army_triger:StatusEffectPriority() return 100000 end
function modifier_Advanced_invincible_army_triger:CheckState() return 
	{[MODIFIER_STATE_INVULNERABLE] = true,
	 [MODIFIER_STATE_NO_HEALTH_BAR] = true,
	 [MODIFIER_STATE_UNSELECTABLE] = true, 
	 [MODIFIER_STATE_NOT_ON_MINIMAP] = true, 
	 [MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
	 [MODIFIER_STATE_ROOTED] = true,
	 [MODIFIER_STATE_NO_UNIT_COLLISION] = true
	}
	 end

function modifier_Advanced_invincible_army_triger:DeclareFunctions() return {
	MODIFIER_EVENT_ON_ATTACK_LANDED,
	MODIFIER_PROPERTY_ATTACKSPEED_BASE_OVERRIDE,
	MODIFIER_PROPERTY_TRANSLATE_ATTACK_SOUND,
	-- MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
	MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
} 
end
function modifier_Advanced_invincible_army_triger:OnCreated(keys)
	if IsServer() then
		local ability = self:GetAbility()
		-- self.damageTable = {
        --     -- victim 			= enemy,
        --     damage 			= ability:GetSpecialValueFor("bonus_damage")*self:GetCaster():GetAgility(),
        --     damage_type		= ability:GetAbilityDamageType(),
        --     damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
        --     attacker 		= self:GetCaster(),
        --     ability 		= ability
        -- }

		self.sound =   string.sub(self:GetCaster():GetUnitName(),10,40)  
        self.attack_speed = self:GetCaster():GetAttackSpeed(false)
		self.radius = ability:GetSpecialValueFor("attack_range")
		self.chance = 20
		if ability.advanced_level>=5 then
			self.radius = self.radius +100
			if ability.advanced_level>=10 then
				self.chance = 30
			end
		end
		self:StartIntervalThink(0.7)
	end
end
function modifier_Advanced_invincible_army_triger:Advanced_GetModifierAttackRangeOverride() return self.radius end
function modifier_Advanced_invincible_army_triger:GetModifierAttackSpeedBaseOverride() return self.attack_speed end
function modifier_Advanced_invincible_army_triger:GetAttackSound() return self.sound  end
-- function modifier_Advanced_invincible_army_triger:GetModifierTotalDamageOutgoing_Percentage() return -100  end
function modifier_Advanced_invincible_army_triger:GetActivityTranslationModifiers()	
	if self:GetCaster():GetUnitName()=="npc_dota_hero_terrorblade" then
		return "abysm"
	end
	if self:GetCaster():GetUnitName()=="npc_dota_hero_monkey_king" then
		return "attack_long_range"
	end
	return "" 
end

function modifier_Advanced_invincible_army_triger:OnIntervalThink()
	if not IsServer() then
		return
	end
	local caster = self:GetCaster()  
	local parent = self:GetParent()            

	local enemy = FindUnitsInRadius(caster:GetTeamNumber(), parent:GetAbsOrigin(), nil, self.radius,
	 DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
	 if #enemy>0 and enemy[1]:IsAlive() then
		  self:GetParent():SetForceAttackTarget(enemy[1])
	 else
		self:GetParent():SetForceAttackTarget(nil)
	 end
end



function modifier_Advanced_invincible_army_triger:OnAttackLanded(keys)
	if not IsServer() or keys.attacker ~= self:GetParent() then
		return
	end
	local target = keys.target
	local ability = self:GetAbility()
	if not ability or ability:IsNull() then
		local parent = self:GetParent()
		if parent and not parent:IsNull() then
			parent:ForceKill(false)
		end
		
		return
	end
	local caster = ability:GetCaster() 

	
	local damage = ability:GetSpecialValueFor("bonus_damage")*caster:GetAgility()
	target:AddNewModifier(caster, ability, "modifier_Advanced_invincible_army_damage", {stack = damage})
			
	
	if ability.unlock3 then
		local modifier_keys = {
			duration = 0.1,
			iSpecialAttack = 1,
			iDisableApplyModifier = 0,
			iDisableCleave =1,
			iDisableSplit = 1,
	
		}
		local attackEffectRecord = caster:AddAttackEffectModifier(ability,modifier_keys)
		
		caster:PerformAttack(target, false, true, true, false, false, false, true)
		if IsValid(attackEffectRecord) then
			attackEffectRecord:Destroy()
		end
	else
		if self:GetCaster():GetRandomEffect(self.chance,INT_TYPE,1)  >=RandomInt(1, 100) then
			local modifier_keys = {
				duration = 0.1,
				iSpecialAttack = 1,
				iDisableApplyModifier = 0,
				iDisableCleave =1,
				iDisableSplit = 1,
		
			}
			local attackEffectRecord = caster:AddAttackEffectModifier(ability,modifier_keys)
			caster:PerformAttack(target, false, true, true, false, false, false, true)
			if IsValid(attackEffectRecord) then
				attackEffectRecord:Destroy()
			end

		end
	end

	


	self:IncrementStackCount()

	if self:GetStackCount()>=4 then
		local parent = self:GetParent()
		local modifier = parent:FindModifierByName("modifier_invincible_army_kill")
		if modifier then
			modifier:SetDuration(0.01, false)
		end
	end

end



function modifier_Advanced_invincible_army_triger:InitUnlock1(modifier)
	self.unlock1Modifier = modifier
end

function modifier_Advanced_invincible_army_triger:OnDestroy()
	if IsServer() then
		if self.unlock1Modifier and not self.unlock1Modifier:IsNull() then
			self.unlock1Modifier:DecrementCount()
		end
	end

end

-- advanced_modifier
function modifier_Advanced_invincible_army_triger:ADDeclareFunctions()
	local funcs = {
        advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
		advanced_MODIFIER_PROPERTY_ATTACK_RANGE_BASE_OVERRIDE
    }

	return funcs

end
function modifier_Advanced_invincible_army_triger:Advanced_GetModifierTotalDamageOutgoing_Percentage(keys)
    return -100
end




modifier_Advanced_invincible_army_buff = advanced_modifier({})

function modifier_Advanced_invincible_army_buff:IsHidden()	return false end
function modifier_Advanced_invincible_army_buff:IsDebuff()	return false end
function modifier_Advanced_invincible_army_buff:IsPurgable()	return false end
function modifier_Advanced_invincible_army_buff:IsPurgeException() return false end
function modifier_Advanced_invincible_army_buff:RemoveOnDeath() return false end

-- function modifier_Advanced_invincible_army_buff:DeclareFunctions()
-- 	local funcs = {

-- 		MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,   --所有伤害加成


-- 	}

-- 	return funcs
-- end

-- function modifier_Advanced_invincible_army_buff:GetModifierTotalDamageOutgoing_Percentage()	
-- 	return 12
-- end

-- advanced_modifier
function modifier_Advanced_invincible_army_buff:ADDeclareFunctions()
	if self:GetParent():GetUnitName()=="npc_hd_double" then
		return {}
	end
	local funcs = {
        advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
    }

	return funcs

end
function modifier_Advanced_invincible_army_buff:Advanced_GetModifierTotalDamageOutgoing_Percentage(keys)
    return 12
end



modifier_Advanced_invincible_army_unlock2 = class({})


function modifier_Advanced_invincible_army_unlock2:IsHidden()	return true end
function modifier_Advanced_invincible_army_unlock2:IsDebuff()	return false end
function modifier_Advanced_invincible_army_unlock2:IsStunDebuff()	return false end
function modifier_Advanced_invincible_army_unlock2:RemoveOnDeath()	return false end
function modifier_Advanced_invincible_army_unlock2:DestroyOnExpire()	return false end
function modifier_Advanced_invincible_army_unlock2:IsPurgable() 		return false end
function modifier_Advanced_invincible_army_unlock2:IsPurgeException() 	return false end

function modifier_Advanced_invincible_army_unlock2:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
end



function modifier_Advanced_invincible_army_unlock2:OnAttackLanded(keys)
	if not IsServer()  or self:GetParent():IsIllusion()  or keys.attacker ~=self:GetParent() then
		return
	end
	local ability = self:GetAbility()
	local caster = self:GetParent()
	if not caster:IsApplyModifier() then
		return
	end
	local chance = 15
	if caster:IsInSpecialAttack() then
		chance = 2
	end
	if chance  > RandomInt(1, 100) then
		
		if not keys.target or keys.target:IsNull() then
			return
		end
		if not keys.target:IsAlive() or keys.target:IsMagicImmune() then
			return
		end


		local pos = keys.target:GetAbsOrigin()
		pos.x = pos.x + RandomInt(-200, 200)
		pos.y = pos.y + RandomInt(-200, 200)
		local pfx = ParticleManager:CreateParticle( "particles/rebuild/spell/invincible_army/invincible_armyecon/events/ti7/teleport_end_ti7_lvl2.vpcf", PATTACH_CUSTOMORIGIN, caster )
		ParticleManager:SetParticleControl( pfx, 0, pos  )
		ParticleManager:SetParticleControl( pfx, 1, pos  )
		-- ParticleManager:SetParticleControl( pfx, 3, pos  )
		ParticleManager:SetParticleControlEnt( pfx, 3, caster, PATTACH_POINT, nil, caster:GetAbsOrigin(), true )
		-- ParticleManager:SetParticleControl( pfx, 3, Vector(5,0,0)  )
		ParticleManager:SetParticleControl( pfx, 4, Vector(1,0,0)  )
		ParticleManager:SetParticleControl( pfx, 5, pos  )
		ParticleManager:SetParticleControl( pfx, 61, Vector(RandomFloat(-180, 180),0,0)  )
		Timers:CreateTimer(3, function()
			ParticleManager:DestroyParticle(pfx, false)
			ParticleManager:ReleaseParticleIndex(pfx)
			-- EmitSoundOnLocationWithCaster(pos, "Portal.Hero_Disappear", nil)
			if caster and not caster:IsNull() and ability and not ability:IsNull() then
				-- HdEmitSoundOnLocation(caster,pos,"Portal.Hero_Disappear",3)
				local illusion =	CreateUnitByName( "npc_hd_double", pos, true, nil, nil, caster:GetTeamNumber() )
	
	
				if illusion then
	
					illusion:SetOriginalModel(caster.origin_model_name)
					illusion:SetModelScale(caster:GetModelScale())
					local hModel = caster:FirstMoveChild()
					while hModel ~= nil do
						if hModel:GetClassname() ~= "" and hModel:GetClassname() == "dota_item_wearable" and hModel:GetModelName() ~= "" then
							local hWearable = SpawnEntityFromTableSynchronous("prop_dynamic", { model = hModel:GetModelName(), origin = illusion:GetAbsOrigin() })
							-- hWearable:SetRenderColor(vRBG.x, vRBG.y, vRBG.z)
							hWearable:FollowEntity(illusion, true)
						end
						hModel = hModel:NextMovePeer()
					end
					illusion:AddNewModifier(caster, ability, "modifier_invincible_army_kill", {duration = self.life_time})
					illusion:AddNewModifier(caster, ability, "modifier_Advanced_invincible_army_triger", {})
					illusion:EmitSound("Portal.Hero_Disappear")
					-- illusion:SetForwardVector(caster:GetForwardVector())
					local angle = caster:GetAngles()
					illusion:SetAngles(angle.x, angle.y, angle.z)
					FindClearSpaceForUnit(illusion, pos, true)
				end
	
	
				
			end
			
		end)

				
		
	end

	
end







modifier_Advanced_invincible_army_damage = class({})

function modifier_Advanced_invincible_army_damage:IsDebuff() return true end
function modifier_Advanced_invincible_army_damage:IsHidden() return false end
function modifier_Advanced_invincible_army_damage:IsPurgable() return false end
function modifier_Advanced_invincible_army_damage:IsPurgeException() return false end
function modifier_Advanced_invincible_army_damage:OnCreated(keys)
	if IsServer() then
		self:SetStackCount(keys.stack)
		self:StartIntervalThink(0.5)
	end
end

function modifier_Advanced_invincible_army_damage:OnRefresh(keys)
	if IsServer() then
		self:SetStackCount(self:GetStackCount()+ keys.stack)

	end
end
function modifier_Advanced_invincible_army_damage:OnIntervalThink()
	local ability = self:GetAbility()
	if not ability then
		self:SafeDestroy()
		return
	end
	local damageTable = {
		victim = self:GetParent(),
		attacker = self:GetCaster(),
		damage =  self:GetStackCount(),
		damage_type = ability:GetAbilityDamageType(),
		damage_flags = DOTA_UNIT_TARGET_FLAG_NONE, 
		ability = ability,
	}
	ApplyDamage(damageTable)
	self:SetStackCount(0)
	self:SafeDestroy()
end