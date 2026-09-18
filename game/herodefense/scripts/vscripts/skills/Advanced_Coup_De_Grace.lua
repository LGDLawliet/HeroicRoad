--------------------------------------------------------------------------------------------
--特效优化 √
Advanced_Coup_De_Grace = class({})
LinkLuaModifier("modifier_Advanced_Coup_De_Grace", "skills/Advanced_Coup_De_Grace", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Coup_De_Grace_secondstrike", "skills/Advanced_Coup_De_Grace", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Coup_De_Grace_god", "skills/Advanced_Coup_De_Grace", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Coup_De_Grace_unlock1_thinker", "skills/Advanced_Coup_De_Grace", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier( "modifier_generic_animation_frozen", "modifier/generic/modifier_generic_animation_frozen", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_Advanced_Coup_De_Grace_unlock2", "skills/Advanced_Coup_De_Grace", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Coup_De_Grace_unlock3", "skills/Advanced_Coup_De_Grace", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Coup_De_Grace_break", "skills/Middle_Coup_De_Grace", LUA_MODIFIER_MOTION_NONE)

function Advanced_Coup_De_Grace:GetIntrinsicModifierName() return "modifier_Advanced_Coup_De_Grace" end

function Advanced_Coup_De_Grace:CheckKV(key)
	local table = {
		crit_bonus = 13.6,
	}
	local value = table[key] or -1
	return value
end

function Advanced_Coup_De_Grace:UnlockFirstCore(key)
	return true
end
function Advanced_Coup_De_Grace:UnlockSecondCore(key)
	return true
end
function Advanced_Coup_De_Grace:UnlockThirdCore(key)
	return true
end

function Advanced_Coup_De_Grace:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/spell/coup_de_grace/unlock1/effect.vpcf", context )
	PrecacheResource( "particle", "particles/econ/events/nexon_hero_compendium_2014/blink_dagger_start_nexon_hero_cp_2014.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/spell/coup_de_grace/unlock2/effectart_nexon_hero_cp_2014.vpcf", context )
end

function Advanced_Coup_De_Grace:Unlock1Effect(target)
	local caster = self:GetCaster()
	local pos = target:GetAbsOrigin()
	local new_pos = pos + Vector(RandomInt(-1000, 1000),RandomInt(-1000, 1000),0)
	local dir = ( new_pos-pos):Normalized()
	dir.z = 0

	local new_pos1 = pos + dir * 500

	new_pos = pos + Vector(RandomInt(-1000, 1000),RandomInt(-1000, 1000),0)
	dir = ( new_pos-pos):Normalized()
	dir.z = 0
	local new_pos2 =  pos + dir * 500

	--计算点到中点的方向向量
	local dir1 = (new_pos1-pos):Normalized()
	dir1.z = 0
	local dir2 = (new_pos2-pos):Normalized()
	dir2.z = 0

	local target_pos1 = new_pos1 - dir1 *1000
	local target_pos2 = new_pos2 - dir2 *1000


	local hUnit  =CreateModifierThinker(caster, self, "modifier_Advanced_Coup_De_Grace_unlock1_thinker", 
	{duration = 0.2,pos_x = target_pos1.x,pos_y = target_pos1.y,pos_z = target_pos1.z}, new_pos1, caster:GetTeamNumber(), false)

	hUnit:SetOriginalModel(caster.origin_model_name)
	hUnit:SetModelScale(caster:GetModelScale())
	hUnit:SetForwardVector(-dir1)
	local hModel = caster:FirstMoveChild()
	while hModel ~= nil do
		if hModel:GetClassname() ~= "" and hModel:GetClassname() == "dota_item_wearable" and hModel:GetModelName() ~= "" then
			local hWearable = SpawnEntityFromTableSynchronous("prop_dynamic", { model = hModel:GetModelName(), origin = hUnit:GetAbsOrigin() })
			-- hWearable:SetRenderColor(vRBG.x, vRBG.y, vRBG.z)
			hWearable:FollowEntity(hUnit, true)
		end
		hModel = hModel:NextMovePeer()
	end


	local hUnit  =CreateModifierThinker(caster, self, "modifier_Advanced_Coup_De_Grace_unlock1_thinker", 
	{duration = 0.2,pos_x = target_pos2.x,pos_y = target_pos2.y,pos_z = target_pos2.z}, new_pos2, caster:GetTeamNumber(), false)

	hUnit:SetOriginalModel(caster.origin_model_name)
	hUnit:SetModelScale(caster:GetModelScale())
	hUnit:SetForwardVector(-dir2)
	local hModel = caster:FirstMoveChild()
	while hModel ~= nil do
		if hModel:GetClassname() ~= "" and hModel:GetClassname() == "dota_item_wearable" and hModel:GetModelName() ~= "" then
			local hWearable = SpawnEntityFromTableSynchronous("prop_dynamic", { model = hModel:GetModelName(), origin = hUnit:GetAbsOrigin() })
			-- hWearable:SetRenderColor(vRBG.x, vRBG.y, vRBG.z)
			hWearable:FollowEntity(hUnit, true)
		end
		hModel = hModel:NextMovePeer()
	end
end

modifier_Advanced_Coup_De_Grace = advanced_modifier({})

function modifier_Advanced_Coup_De_Grace:IsDebuff()			return false end
function modifier_Advanced_Coup_De_Grace:IsHidden() 		return true end
function modifier_Advanced_Coup_De_Grace:IsPurgable() 		return false end
function modifier_Advanced_Coup_De_Grace:IsPurgeException() return false end
function modifier_Advanced_Coup_De_Grace:OnCreated() 
	if not IsServer() then
		return
	end
	self.crit = {} 
	self.crit_unlock1 = {}
	self.no_armor = self:GetAbility():GetSpecialValueFor("no_armor")
	self.break_duration = self:GetAbility():GetSpecialValueFor("break_duration")
	self.break_bonus = self:GetAbility():GetSpecialValueFor("break_bonus")*0.01 +1
end

function modifier_Advanced_Coup_De_Grace:OnDestroy() 
	self.crit = nil 
	self.crit_unlock1 = nil
end

function modifier_Advanced_Coup_De_Grace:DeclareFunctions() return 
	{
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_EVENT_ON_ATTACK_FAIL,
	} 
end

function modifier_Advanced_Coup_De_Grace:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_CRITICALSTRIKE,
		advanced_MODIFIER_PROPERTY_ARMOR_IGNORE,
    }
end

function modifier_Advanced_Coup_De_Grace:Advanced_GetModifierAttackArmor_Ignore(keys)
	--新LV5
	if self:GetAbility().advanced_level >= 5 then
		self.no_armor = self:GetAbility():GetSpecialValueFor("no_armor") + 3
	end
	return self.no_armor
end

function modifier_Advanced_Coup_De_Grace:Advanced_GetModifierCriticalStrike(keys)
	if IsServer() and keys.attacker == self:GetParent() and not self:GetParent():PassivesDisabled() then
		local ability = self:GetAbility()
		local random = math.random
		local pct = ability:GetSpecialValueFor("crit_chance")
		local level = ability.advanced_level
	
		if self:GetParent():HasModifier("modifier_Advanced_Coup_De_Grace_unlock2") or self:GetParent():HasModifier("modifier_Advanced_Coup_De_Grace_unlock3") then
			pct = 100
		end
		if self:GetStackCount() >= 8 then
			pct = 100
		end
		if pct > random(0,100) then
			local crit_damage =  ability:GetSpecialValueFor("crit_bonus")

			self.crit[keys.record] = true
			if ability.unlock1 and self:GetCaster():GetRandomEffect(20,INT_TYPE,1)  > random(1, 100) then
				crit_damage = crit_damage * 5
				self.crit_unlock1[keys.record] = true
			end

			local caster = self:GetParent()
			local damage_mul = crit_damage
			--新LV20
			if level >= 20 then
				if keys.target:PassivesDisabled() or keys.target:IsSilenced() then
					damage_mul = crit_damage*1.3
				end
			else
				if keys.target:PassivesDisabled() then
					damage_mul = crit_damage*self.break_bonus
				end
			end
			
			keys.target:AddNewModifier(keys.attacker, self:GetAbility(), "modifier_Middle_Coup_De_Grace_break", {duration = self.break_duration})
			self:SetStackCount(0)
			---天赋相关
			local ability = caster:FindAbilityByName("heroTalent_npc_dota_hero_phantom_assassin_4")
			
			if ability then
				if keys.target:GetHealth()<=caster:GetAverageTrueAttackDamage(nil) then
					TrueKill(self:GetParent(), keys.target, self:GetAbility())
				else
					if ability:IsCooldownReady() then
						damage_mul =( damage_mul + 100)*2
						ability:UseResources(true, true, true, true)
					else
						damage_mul = damage_mul +100
					end
				end
			end
			--------------
			return damage_mul 
		else
			--新LV15
			if level >= 15 then
				self:SetStackCount(math.min(self:GetStackCount()+1 , 8))
			end
			return 0
		end
	end
end

function modifier_Advanced_Coup_De_Grace:OnAttackLanded(keys)
	if not IsServer() then
		return
	end

	if keys.attacker ~= self:GetParent() or self:GetParent():PassivesDisabled() or not keys.target:IsAlive() then
		return
	end
	local caster = self:GetParent()
	local random = math.random
	if self:GetAbility().unlock2 and caster:GetRandomEffect(1,INT_TYPE,1)  > random(1, 100) then
		caster:AddNewModifier(caster, self:GetAbility(), "modifier_Advanced_Coup_De_Grace_unlock2", {duration = 1.5})
	end
	if self.crit[keys.record] then
		local level = self:GetAbility().advanced_level
		local pos = keys.target:GetAbsOrigin()
	
		local pfx_name = "particles/econ/items/phantom_assassin/phantom_assassin_arcana_elder_smith/phantom_assassin_crit_arcana_swoop_r.vpcf"
		local pfx = ParticleManager:CreateParticle(pfx_name, PATTACH_ABSORIGIN, keys.target)
		self:GetParent():EmitSound("Hero_PhantomAssassin.CoupDeGrace")
		self.secondstrikemodifier = self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_Advanced_Coup_De_Grace_secondstrike", {duration = 5})
		ParticleManager:SetParticleControlEnt(pfx, 0, keys.target, PATTACH_POINT_FOLLOW, "attach_hitloc", pos, true)
		ParticleManager:SetParticleControl(pfx, 1, pos)
		ParticleManager:SetParticleControlOrientation(pfx, 1, caster:GetForwardVector() * -1, caster:GetRightVector(), caster:GetUpVector())
		ParticleManager:ReleaseParticleIndex(pfx)
		local pfx_name2 = "particles/econ/events/ti4/blink_dagger_start_sparkles_ti4.vpcf"
		local pfx2 = ParticleManager:CreateParticle(pfx_name2, PATTACH_ABSORIGIN, keys.target)
		ParticleManager:SetParticleControlEnt(pfx2, 0, keys.target, PATTACH_POINT_FOLLOW, "attach_hitloc",pos, true)
		ParticleManager:SetParticleControl(pfx2, 1, pos)
		ParticleManager:SetParticleControlOrientation(pfx2, 1, caster:GetForwardVector() * -1, caster:GetRightVector(), caster:GetUpVector())
		ParticleManager:ReleaseParticleIndex(pfx2)

		if self.crit_unlock1[keys.record] then
			self:GetAbility():Unlock1Effect(keys.target)
			self.crit_unlock1[keys.record] = nil
		end

		if self:GetAbility().unlock3 and not caster:HasModifier("modifier_Advanced_Coup_De_Grace_unlock3") then
			local units = FindUnitsInRadius(caster:GetTeamNumber(), keys.target:GetAbsOrigin(), nil, 500, 
			DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_NONE, FIND_ANY_ORDER , false)
			for _, unit in ipairs(units) do
				local modifier = caster:AddNewModifier(caster, self:GetAbility(), "modifier_Advanced_Coup_De_Grace_unlock3", {duration =0.1})
				local modifier_keys = {
					duration = 0.1,
					iSpecialAttack = 1,
					iDisableApplyModifier = 0,
					iDisableCleave =0,
					iDisableSplit = 0,
			
				}
				local attackEffectRecord = caster:AddAttackEffectModifier(self:GetAbility(),modifier_keys)
				caster:PerformAttack(unit, false, true, true, false, false, false, true)
				if IsValid(attackEffectRecord) then
					attackEffectRecord:Destroy()
				end
				if modifier then
					modifier:SafeDestroy()
				end
				break
			end
		end


	end
	self.crit[keys.record] = nil
end

function modifier_Advanced_Coup_De_Grace:OnAttackFail(keys) self.crit[keys.record] = nil end

--------------------------------------------------------------------------------------------------------
modifier_Advanced_Coup_De_Grace_break = advanced_modifier({})

function modifier_Advanced_Coup_De_Grace_break:IsDebuff()			return true end
function modifier_Advanced_Coup_De_Grace_break:IsHidden() 			return false end
function modifier_Advanced_Coup_De_Grace_break:IsPurgable() 	    	return false end
function modifier_Advanced_Coup_De_Grace_break:IsPurgeException() 	return false end
function modifier_Advanced_Coup_De_Grace_break:CheckState()
	return{
		[MODIFIER_STATE_PASSIVES_DISABLED] = true,
	}
end
function modifier_Advanced_Coup_De_Grace_break:ADDeclareFunctions()
	return{
		advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	}
end
function modifier_Advanced_Coup_De_Grace_break:Advanced_GetModifierPhysicalArmorBonus()
	--新LV10
	if self:GetAbility().advanced_level >= 10 then
		return -5
	end
	return 0
end
modifier_Advanced_Coup_De_Grace_god = class({})

function modifier_Advanced_Coup_De_Grace_god:IsDebuff()			return false end
function modifier_Advanced_Coup_De_Grace_god:IsHidden() 		return true end
function modifier_Advanced_Coup_De_Grace_god:IsPurgable() 		return false end
function modifier_Advanced_Coup_De_Grace_god:IsPurgeException() return false end
function modifier_Advanced_Coup_De_Grace_god:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_Advanced_Coup_De_Grace_god:DeclareFunctions()
return {MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT}
end

function modifier_Advanced_Coup_De_Grace_god:GetModifierAttackSpeedBonus_Constant()	return 1000 end
























modifier_Advanced_Coup_De_Grace_unlock1_thinker = modifier_Advanced_Coup_De_Grace_unlock1_thinker or class({})
function modifier_Advanced_Coup_De_Grace_unlock1_thinker:IsHidden()	return true end
function modifier_Advanced_Coup_De_Grace_unlock1_thinker:IsDebuff()	return false end
function modifier_Advanced_Coup_De_Grace_unlock1_thinker:IsPurgable()	return false end
function modifier_Advanced_Coup_De_Grace_unlock1_thinker:IsPurgeException()	return false end
function modifier_Advanced_Coup_De_Grace_unlock1_thinker:IsStunDebuff()	return false end
function modifier_Advanced_Coup_De_Grace_unlock1_thinker:AllowIllusionDuplicate()	return false end
function modifier_Advanced_Coup_De_Grace_unlock1_thinker:OnCreated(keys)
	if IsServer() then

		
		local caster = self:GetCaster()
		local parent = self:GetParent()
		-- local angle = caster:GetAngles()
		parent:SetModelScale(0.9)
		-- parent:SetAngles(angle.x, angle.y, angle.z)
		-- local pos = parent:GetAbsOrigin()
		-- parent:AddNewModifier(caster, self:GetAbility(), "modifier_Advanced_Coup_De_Grace_unlock1_thinker_motion", {duration = 0.8})

		self.target_pos = Vector(keys.pos_x,keys.pos_y,keys.pos_z)


		self:StartIntervalThink(0.06)
	end
end

function modifier_Advanced_Coup_De_Grace_unlock1_thinker:OnIntervalThink()
	local parent = self:GetParent()
	parent:AddNewModifier(parent, self:GetAbility(), "modifier_generic_animation_frozen", {})
	local pfx = ParticleManager:CreateParticle("particles/rebuild/spell/coup_de_grace/unlock1/effect.vpcf", PATTACH_WORLDORIGIN, nil)
	ParticleManager:SetParticleControl(pfx, 0, parent:GetAbsOrigin())
	ParticleManager:SetParticleControl(pfx, 1,self.target_pos)
	ParticleManager:SetParticleControl(pfx, 61,Vector(1,0,0))
	ParticleManager:ReleaseParticleIndex( pfx )
	FindClearSpaceForUnit(parent,self.target_pos, true)
	self:StartIntervalThink(-1)

end
function modifier_Advanced_Coup_De_Grace_unlock1_thinker:OnDestroy()
	if IsServer() then
		-- self:GetParent():ForceKill(false)
		local pfx = ParticleManager:CreateParticle("particles/econ/events/nexon_hero_compendium_2014/blink_dagger_start_nexon_hero_cp_2014.vpcf", PATTACH_WORLDORIGIN, nil)
		ParticleManager:SetParticleControl(pfx, 0, self:GetParent():GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex( pfx )
		UTIL_Remove( self:GetParent() )
	end
end
function modifier_Advanced_Coup_De_Grace_unlock1_thinker:CheckState()
	return {
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
		[MODIFIER_STATE_OUT_OF_GAME] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true
	}
end
function modifier_Advanced_Coup_De_Grace_unlock1_thinker:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MODEL_CHANGE,
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION_RATE
	}
end
function modifier_Advanced_Coup_De_Grace_unlock1_thinker:GetModifierModelChange(params)
	-- return "models/creeps/omniknight_golem/omniknight_golem.vmdl"
	if IsServer() then
		return self:GetCaster().origin_model_name
	end
	
end
function modifier_Advanced_Coup_De_Grace_unlock1_thinker:GetOverrideAnimation(params)
	return ACT_DOTA_ATTACK
end
function modifier_Advanced_Coup_De_Grace_unlock1_thinker:GetOverrideAnimationRate()	
	return 8
	
end
function modifier_Advanced_Coup_De_Grace_unlock1_thinker:GetActivityTranslationModifiers()	
	if self:GetCaster():GetUnitName()=="npc_dota_hero_terrorblade" then
		return "abysm"
	end
	if self:GetCaster():GetUnitName()=="npc_dota_hero_monkey_king" then
		return "attack_long_range"
	end
end

-- function modifier_Advanced_Coup_De_Grace_unlock1_thinker:GetStatusEffectName() return "particles/new_effect/status/new_status_effect_soul_02.vpcf" end
-- function modifier_Advanced_Coup_De_Grace_unlock1_thinker:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
---------------------------------------------------------------------












modifier_Advanced_Coup_De_Grace_unlock2 = class({})

function modifier_Advanced_Coup_De_Grace_unlock2:IsDebuff()			return false end
function modifier_Advanced_Coup_De_Grace_unlock2:IsHidden() 			return false end
function modifier_Advanced_Coup_De_Grace_unlock2:IsPurgable() 	    	return false end
function modifier_Advanced_Coup_De_Grace_unlock2:IsPurgeException() 	return false end

function modifier_Advanced_Coup_De_Grace_unlock2:OnCreated()
	if IsServer() then
		local parent = self:GetParent()
		parent:EmitSound("Hero_PhantomAssassin.FanOfKnives.Cast")
		self.pfx = ParticleManager:CreateParticle("particles/rebuild/spell/coup_de_grace/unlock2/effectart_nexon_hero_cp_2014.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControlEnt(self.pfx, 0, parent, PATTACH_CENTER_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true)

	end
end


function modifier_Advanced_Coup_De_Grace_unlock2:OnDestroy()
	if IsServer() then
		ParticleManager:DestroyParticle(self.pfx, false)
		self.pfx = nil
	end
end






modifier_Advanced_Coup_De_Grace_unlock3 = class({})

function modifier_Advanced_Coup_De_Grace_unlock3:IsDebuff()			return false end
function modifier_Advanced_Coup_De_Grace_unlock3:IsHidden() 			return true end
function modifier_Advanced_Coup_De_Grace_unlock3:IsPurgable() 	    	return false end
function modifier_Advanced_Coup_De_Grace_unlock3:IsPurgeException() 	return false end
