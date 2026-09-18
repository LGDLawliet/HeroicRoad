heroTalent_npc_dota_hero_spectre_2 = heroTalent_npc_dota_hero_spectre_2 or class({})

LinkLuaModifier("modifier_heroTalent_npc_dota_hero_spectre_2", "heroTalent/heroTalent_npc_dota_hero_spectre_2", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_heroTalent_npc_dota_hero_spectre_2_attack", "heroTalent/heroTalent_npc_dota_hero_spectre_2", LUA_MODIFIER_MOTION_NONE)

-- function heroTalent_npc_dota_hero_spectre_2:GetCastRange()
-- 	local caster = self:GetCaster()
-- 	return 1500 - caster:GetCastRangeBonus()

-- end
-- function heroTalent_npc_dota_hero_spectre_2:IsHiddenWhenStolen() 		return false end
-- function heroTalent_npc_dota_hero_spectre_2:IsRefreshable() 			return true end
-- function heroTalent_npc_dota_hero_spectre_2:IsStealable() 				return true end
-- function heroTalent_npc_dota_hero_spectre_2:IsNetherWardStealable()		return true end
-- function heroTalent_npc_dota_hero_spectre_2:GetIntrinsicModifierName() return "modifier_heroTalent_npc_dota_hero_spectre_2" end
function heroTalent_npc_dota_hero_spectre_2:Spawn()
	if IsServer() then
		self:CallPhantom()
	end
end
function heroTalent_npc_dota_hero_spectre_2:CallPhantom()
	local caster = self:GetCaster()
	local ability = self
	local pos = caster:GetOrigin()
	local forward = caster:GetForwardVector()
	local duration = -1
	local unit  = CreateUnitByName("npc_hd_double", pos, true, caster, caster, caster:GetTeamNumber())
	unit:AddNewModifier(caster, ability, "modifier_heroTalent_npc_dota_hero_spectre_2", {duration=duration,type=0})
	unit:SetForwardVector(forward)
	unit:SetOriginalModel(caster.origin_model_name)
	unit:SetModelScale(caster:GetModelScale())
	local hModel = caster:FirstMoveChild()
	while hModel ~= nil do
		if hModel:GetClassname() ~= "" and hModel:GetClassname() == "dota_item_wearable" and hModel:GetModelName() ~= "" then
			local hWearable = SpawnEntityFromTableSynchronous("prop_dynamic", { model = hModel:GetModelName(), origin = unit:GetAbsOrigin() })
			-- hWearable:SetRenderColor(vRBG.x, vRBG.y, vRBG.z)
			hWearable:FollowEntity(unit, true)
		end
		hModel = hModel:NextMovePeer()
	end
	
end





modifier_heroTalent_npc_dota_hero_spectre_2 = modifier_heroTalent_npc_dota_hero_spectre_2 or class({})
function modifier_heroTalent_npc_dota_hero_spectre_2:IsHidden()	return true end
function modifier_heroTalent_npc_dota_hero_spectre_2:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_spectre_2:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_spectre_2:IsPurgeException()	return false end
function modifier_heroTalent_npc_dota_hero_spectre_2:OnCreated(keys)
	if IsServer() then
		-- local caster = self:GetCaster()
		self.type = keys.type
		self:GetParent():SetHullRadius(0)
		-- self:GetParent():SetModelScale(0.9)
		self.caster = self:GetCaster()
		self:StartIntervalThink(0.01)
		self:SetStackCount(self.type)
		self.attack_cooldown = GameRules:GetGameTime()
		self.attack_standby = false
		
		local name = self.caster:GetUnitName()
		if name=="npc_dota_hero_terrorblade" then
			self:GetParent():AddActivityModifier("abysm")
		end
		if name=="npc_dota_hero_monkey_king" then
			self:GetParent():AddActivityModifier("attack_long_range")
			-- return "attack_long_range"
		end
	end
	-- if self:GetStackCount()==2 then
	-- 	self.height_offect = 300
	-- end
end
function modifier_heroTalent_npc_dota_hero_spectre_2:OnDestroy()
	if IsServer() then
		-- self:GetParent():ForceKill(false)
		local pfx = ParticleManager:CreateParticle("particles/econ/events/nexon_hero_compendium_2014/blink_dagger_start_nexon_hero_cp_2014.vpcf", PATTACH_WORLDORIGIN, nil)
		ParticleManager:SetParticleControl(pfx, 0, self:GetParent():GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex( pfx )
		UTIL_Remove(self:GetParent())
	end
end
function modifier_heroTalent_npc_dota_hero_spectre_2:CheckState()
	return {
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_OUT_OF_GAME] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_DISARMED] = true,
	}
end
function modifier_heroTalent_npc_dota_hero_spectre_2:OnAttackStart(keys)
	if self.caster == keys.attacker then
		if self.attack_standby then
			if self.caster:IsAttacking() and 50>=RandomInt(1, 100) then
				-- 根据攻击速度触发攻击
				local parent = self:GetParent()
				if self.attack_cooldown<=GameRules:GetGameTime() then
					local needTime = math.max(self.caster:GetSecondsPerAttack(false),0.06)
					self.attack_cooldown = GameRules:GetGameTime() + needTime - FrameTime()
					
					parent:AddNewModifier(parent, self:GetAbility(), "modifier_heroTalent_npc_dota_hero_spectre_2_attack", {duration=needTime})
					parent:StartGestureWithPlaybackRate(ACT_DOTA_ATTACK,1/needTime)
				end
				
			end
		end
    end
end

function modifier_heroTalent_npc_dota_hero_spectre_2:OnIntervalThink()

	local caster = self:GetCaster()

	if not caster then
		self:SafeDestroy()
		return
	end
	self.bonus_move = caster:GetMoveSpeedModifier(caster:GetBaseMoveSpeed(), true)
	local parent = self:GetParent()
	local pos
	if self.type==0 then
		pos = caster:GetAbsOrigin()
		local forward = caster:GetForwardVector()
		local target_pos = pos-forward*100
		local dis = CalculateDistance(target_pos,parent:GetAbsOrigin())
		if dis>=2000 then
			parent:SetForwardVector(forward)
			parent:SetAbsOrigin(target_pos-forward)
			return
		end
		if dis>=200 then
			parent:MoveToPosition(target_pos)
			self.attack_standby = false
		else
			parent:FaceTowards(target_pos+forward*300)
			self.attack_standby = true
		end

	end


	
end

function modifier_heroTalent_npc_dota_hero_spectre_2:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
		MODIFIER_PROPERTY_MODEL_CHANGE,
		MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT,           --取消移动速度限制
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE_MIN,
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION_RATE,
		MODIFIER_EVENT_ON_ATTACK_START
	}
end
function modifier_heroTalent_npc_dota_hero_spectre_2:GetModifierMoveSpeed_AbsoluteMin()
	local caster = self:GetCaster()
	local index =  (self:GetParent():GetAbsOrigin() - caster:GetAbsOrigin()):Length2D()/300
	return math.max( caster:GetMoveSpeedModifier(caster:GetBaseMoveSpeed()*1.4, true),self.bonus_move*index)
end
function modifier_heroTalent_npc_dota_hero_spectre_2:GetModifierIgnoreMovespeedLimit( params )
	return 1
end
function modifier_heroTalent_npc_dota_hero_spectre_2:GetModifierModelChange(params)
	if IsServer() then
		return self:GetCaster().origin_model_name
	end
	
end
function modifier_heroTalent_npc_dota_hero_spectre_2:GetActivityTranslationModifiers()	
	if self:GetCaster():GetUnitName()=="npc_dota_hero_phantom_assassin" then

		return "haste"
	end
	return "run_fast" 
end


modifier_heroTalent_npc_dota_hero_spectre_2_attack = modifier_heroTalent_npc_dota_hero_spectre_2_attack or class({})
function modifier_heroTalent_npc_dota_hero_spectre_2_attack:IsHidden()	return true end
function modifier_heroTalent_npc_dota_hero_spectre_2_attack:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_spectre_2_attack:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_spectre_2_attack:IsPurgeException()	return false end
function modifier_heroTalent_npc_dota_hero_spectre_2_attack:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_heroTalent_npc_dota_hero_spectre_2_attack:OnCreated(keys)
	-- if IsServer() then
	-- self.speed = 1/self:GetRemainingTime()
	self.caster = self:GetAbility():GetCaster()
	-- end
end
function modifier_heroTalent_npc_dota_hero_spectre_2_attack:DeclareFunctions()
	return {
		-- MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		-- MODIFIER_PROPERTY_OVERRIDE_ANIMATION_RATE,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		-- MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS
	}
end
function modifier_heroTalent_npc_dota_hero_spectre_2_attack:OnAttackLanded(keys)
	if not IsServer() then
		return 
	end
	if keys.attacker ~= self.caster then
		return
	end
	if  self.caster:IsInSpecialAttack() then
		return
	end
	if self.trigger then
		return
	end
	self.trigger = true
	
	local parent = self:GetParent()
	local target_pos = parent:GetOrigin()+parent:GetForwardVector()*350
	local tTargets = FindUnitsInLine(parent:GetTeamNumber(), parent:GetOrigin(),  target_pos, nil, 150,
	DOTA_UNIT_TARGET_TEAM_ENEMY,
	DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
	DOTA_UNIT_TARGET_FLAG_NONE)


	for i, hTarget in pairs(tTargets) do

		local modifier_keys = {
			duration = 0.1,
			iSpecialAttack = 1,
			iDisableApplyModifier = 0,
			iDisableCleave =1,
			iDisableSplit = 1,
	
		}
		local attackEffectRecord = self.caster:AddAttackEffectModifier(self:GetAbility(),modifier_keys)
		self.caster:PerformAttack(hTarget,false, true, true, true, false, false, true)
		if IsValid(attackEffectRecord) then
			attackEffectRecord:Destroy()
		end
		break
	end
	

	self:SafeDestroy()


end
