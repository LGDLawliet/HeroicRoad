--特效优化 √
Advanced_Phantom_Strike = class({})

LinkLuaModifier("modifier_Advanced_Phantom_Strike", "skills/Advanced_Phantom_Strike", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Phantom_Strike_buff", "skills/Advanced_Phantom_Strike", LUA_MODIFIER_MOTION_NONE)


LinkLuaModifier("modifier_Advanced_Phantom_Strike_unlock3", "skills/Advanced_Phantom_Strike", LUA_MODIFIER_MOTION_NONE)


LinkLuaModifier("modifier_Advanced_Phantom_Strike_unlock3_attack", "skills/Advanced_Phantom_Strike", LUA_MODIFIER_MOTION_NONE)





require('internal/timers')

function Advanced_Phantom_Strike:CheckKV(key)
	local table = {

	


		bonus_attack_speed = 10,





	}
	local value = table[key] or -1
	return value

end
function Advanced_Phantom_Strike:UnlockFirstCore(key)
	-- local caster = self:GetCaster()
	-- caster:AddNewModifier(caster,self,"modifier_Advanced_Blur_unlock1",{})
	return true
end
function Advanced_Phantom_Strike:UnlockSecondCore(key)
	-- local caster = self:GetCaster()
	-- self.modifier = caster:AddNewModifier(caster,self,"modifier_Advanced_Viscous_Nasal_Goo_unlock2",{})
	return true
end
function Advanced_Phantom_Strike:UnlockThirdCore(key)
	-- local caster = self:GetCaster()
	-- local modifier = caster:AddNewModifier(caster,self,"modifier_Advanced_Blur_unlock3",{})
	return true

end
function Advanced_Phantom_Strike:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/spell/phantom_strike/unlock2/effect.vpcf", context )
	PrecacheResource( "particle", "particles/econ/events/nexon_hero_compendium_2014/blink_dagger_start_nexon_hero_cp_2014.vpcf", context )
end



function Advanced_Phantom_Strike:IsHiddenWhenStolen() 		return false end
function Advanced_Phantom_Strike:IsRefreshable() 			return true end
function Advanced_Phantom_Strike:IsStealable() 			return true end
function Advanced_Phantom_Strike:IsNetherWardStealable()	return true end

function Advanced_Phantom_Strike:CastFilterResultTarget(target)
	if target:IsInvulnerable() then
		return UF_FAIL_INVULNERABLE
	end
	if target == self:GetCaster() or target:IsOther() or target:IsCourier() then
		return UF_FAIL_CUSTOM
	end
end

function Advanced_Phantom_Strike:GetCustomCastErrorTarget(target)
	if target == self:GetCaster() then
		return "#dota_hud_error_cant_cast_on_self"
	else
		return "#dota_hud_error_cant_cast_on_other"
	end
end

function Advanced_Phantom_Strike:OnSpellStart()
	local caster = self:GetCaster()
	EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Hero_PhantomAssassin.Strike.Start", caster)
	local target = self:GetCursorTarget()
	if  target:GetTeamNumber() ~= caster:GetTeamNumber() and  target:TriggerSpellAbsorb(self) then
		return
	end
	-- if target:TriggerStandardTargetSpell(self) then
	-- 	return
	-- end
	local startpos = caster:GetAbsOrigin()
	local endpos = target:GetAbsOrigin() + (target:GetForwardVector() * -1) * 100
	FindClearSpaceForUnit(caster, endpos, true)
	local pfx_name1 = "particles/units/heroes/hero_phantom_assassin/phantom_assassin_phantom_strike_blur.vpcf"
	local pfx_name2 = "particles/units/heroes/hero_phantom_assassin/phantom_assassin_phantom_strike_end.vpcf"
	
	local pfx1 = ParticleManager:CreateParticle(pfx_name1, PATTACH_WORLDORIGIN, nil)
	ParticleManager:SetParticleControl(pfx1, 0, startpos)
	ParticleManager:ReleaseParticleIndex(pfx1)
	local pfx2 = ParticleManager:CreateParticle(pfx_name2, PATTACH_WORLDORIGIN, caster)
	ParticleManager:SetParticleControl(pfx2, 0, endpos)
	ParticleManager:ReleaseParticleIndex(pfx2)

	local ModifierStatusGain = self:GetCaster():GetModifierDurationGainIndex(1)
	caster:AddNewModifier(caster, self, "modifier_Advanced_Phantom_Strike", {duration = self:GetSpecialValueFor("buff_duration")*ModifierStatusGain})
	local duration = 1
	if self.advanced_level>=5 then
		duration = 1.5
	elseif self.advanced_level>=20 then
		duration = 2
	end
	
	caster:AddNewModifier(caster, self, "modifier_Advanced_Phantom_Strike_buff", {duration = duration*ModifierStatusGain})
	--caster:SetMaximumAttackSpeed(caster:GetMaximumAttackSpeed() + self:GetAbility():GetSpecialValueFor("bonus_attack_speed"))
	if target:GetTeamNumber() ~= caster:GetTeamNumber() then
		-- caster:SetAttacking(target)
		-- caster:SetForceAttackTarget(target)
		caster:MoveToTargetToAttack(target)
		-- Timers:CreateTimer(0.5, function()
		-- 	caster:SetForceAttackTarget(nil)
		-- end)
	end
	
	if self.unlock3 then
		self:CallPhantom()
	end
	--local enemies = FindUnitsInLine(caster:GetTeamNumber(), startpos, endpos, nil, 128, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NO_INVIS)
	-- local ability = caster:FindAbilityByName("imba_phantom_assassin_coup_de_grace")
	-- if ability and ability:GetLevel() > 0 then
	-- 	for i=1, #enemies do
	-- 		for j=1, ability:GetSpecialValueFor("crit_increase") do
	-- 			buff = caster:AddNewModifier(caster, ability, "modifier_imba_coup_de_grace_stacks", {duration = ability:GetSpecialValueFor("crit_increase_duration")})
	-- 			buff:SetStackCount(buff:GetStackCount() + 1)
	-- 		end
	-- 	end
	-- end
	caster:EmitSound("Hero_PhantomAssassin.Strike.End")
end

function Advanced_Phantom_Strike:CallPhantom()
	local caster = self:GetCaster()
	local ability = self
	local pos = caster:GetOrigin()
	local forward = caster:GetForwardVector()
	local duration = 10
	local unit  = CreateUnitByName("npc_hd_double", pos, true, caster, caster, caster:GetTeamNumber())
	unit:AddNewModifier(caster, ability, "modifier_Advanced_Phantom_Strike_unlock3", {duration=duration,type=0})
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
	local unit  = CreateUnitByName("npc_hd_double", pos, true, caster, caster, caster:GetTeamNumber())
	unit:AddNewModifier(caster, ability, "modifier_Advanced_Phantom_Strike_unlock3", {duration=duration,type=1})
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


modifier_Advanced_Phantom_Strike = class({})

function modifier_Advanced_Phantom_Strike:IsDebuff()			return false end
function modifier_Advanced_Phantom_Strike:IsHidden() 			return false end
function modifier_Advanced_Phantom_Strike:IsPurgable() 			return true end
function modifier_Advanced_Phantom_Strike:IsPurgeException() 	return true end
function modifier_Advanced_Phantom_Strike:DeclareFunctions() 
	return {MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
	MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT,
	MODIFIER_EVENT_ON_ATTACK_LANDED
} end
function modifier_Advanced_Phantom_Strike:OnCreated(keys)
	local ability = self:GetAbility()
	--该技能需要从网表拿等级数据 自定义变量拿不到该值
	local NetTable_key = tostring(self:GetCaster():GetPlayerOwnerID()).."_"..ability:GetAbilityName()
	self.advanced_level = CustomNetTables:GetTableValue( "playerSpellLevelInfo", NetTable_key).level
	self.bonus_attack_speed = ability:GetSpecialValueFor("bonus_attack_speed")
	self.bonus_move = 500
	self.ignoremovespeedlimit = 0
	--LV10解锁神行+
	if self.advanced_level>=10 then
		self.bonus_move = 700
		self.ignoremovespeedlimit = 1
	end
	if IsServer() then
		if ability.unlock1 then
			self.bonus_attack_speed = 20000
		end
		self.max_trigger = 20
		self.trigget_chance = 20
		if ability.unlock2 then
			self.max_trigger = 100
			self.trigget_chance = 50
			self.unlock2 = true
		end

	end
end


function modifier_Advanced_Phantom_Strike:OnRefresh(keys)
	if IsServer() then
		self:SetStackCount(0)
	end
end

function modifier_Advanced_Phantom_Strike:GetModifierAttackSpeedBonus_Constant() 

	return self.bonus_attack_speed 
end
function modifier_Advanced_Phantom_Strike:GetModifierMoveSpeedBonus_Constant() return self.bonus_move end
function modifier_Advanced_Phantom_Strike:GetModifierIgnoreMovespeedLimit() return self.ignoremovespeedlimit end


function modifier_Advanced_Phantom_Strike:OnAttackLanded(keys)
	if not IsServer() then
		return 
	end
	if keys.attacker ~= self:GetParent() or self:GetParent():IsIllusion() or self:GetParent():PassivesDisabled() or not keys.target:IsAlive() then
		return
	end
	--LV15解锁影舞
	if self.advanced_level>=15 then
		if self:GetStackCount()>=self.max_trigger then
			return
		end
		local caster = self:GetCaster()
		local target = keys.target
		if self:GetCaster():GetRandomEffect(self.trigget_chance,INT_TYPE,1) > RandomInt(0,100) then
			self:IncrementStackCount()
			Timers:CreateTimer(0.1, function()
				if not caster or caster:IsNull() or not target or target:IsNull() or not IsValid(self) then
					return
				end
				local ability = self:GetAbility()
				if not ability then
					return
				end
				local modifier_keys = {
					duration = 0.1,
					iSpecialAttack = 1,
					iDisableApplyModifier = 0,
					iDisableCleave =0,
					iDisableSplit = 0,
			
				}
				local attackEffectRecord = caster:AddAttackEffectModifier( ability,modifier_keys)
				caster:PerformAttack(target, false, true, true, false, false, false, true)
				if IsValid(attackEffectRecord) then
					attackEffectRecord:Destroy()
				end
				if self.unlock2 then
					local target_pos = target:GetOrigin()
					local new_pos = target_pos + Vector(RandomFloat(-500, 500),RandomFloat(-500, 500),0)
					local dir = CalculateDirection(target_pos,new_pos)
					local pos_1 = target_pos + dir*500 + Vector(0,0,RandomInt(0, 300))
					local pos_2 = target_pos - dir*500 + Vector(0,0,RandomInt(0, 300))
					local iPtclID = ParticleManager:CreateParticle('particles/rebuild/spell/phantom_strike/unlock2/effect.vpcf', PATTACH_CUSTOMORIGIN, nil)
					ParticleManager:SetParticleControl(iPtclID, 0, pos_2)
					ParticleManager:SetParticleControl(iPtclID, 1, pos_1)
					ParticleManager:ReleaseParticleIndex(iPtclID)
					caster:EmitSound("Hero_Centaur.DoubleEdge.TI9")
				end
			end)
			
		
		end
	end


end



--function modifier_Advanced_Phantom_Strike:GetModifierBaseAttackTimeConstant() return 0.2 end
modifier_Advanced_Phantom_Strike_buff = class({})

function modifier_Advanced_Phantom_Strike_buff:IsDebuff()			return false end
function modifier_Advanced_Phantom_Strike_buff:IsHidden() 			return true end
function modifier_Advanced_Phantom_Strike_buff:IsPurgable()     	return false end
function modifier_Advanced_Phantom_Strike_buff:IsPurgeException() 	return false end
-- function modifier_Advanced_Phantom_Strike_buff:DeclareFunctions() return {MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT} end
function modifier_Advanced_Phantom_Strike_buff:GetModifierBaseAttackTimeConstant() return 0.7 end
function modifier_Advanced_Phantom_Strike_buff:OnCreated(keys)
	if IsServer() then
		self.advanced_level = self:GetAbility().advanced_level
	end
end
function modifier_Advanced_Phantom_Strike_buff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_INVISIBILITY_LEVEL,
		MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT,
	}
	return funcs
end

function modifier_Advanced_Phantom_Strike_buff:GetModifierInvisibilityLevel()	return 2 end


function modifier_Advanced_Phantom_Strike_buff:CheckState()
	local state = {}
	--LV20解锁隐秘
	if self.advanced_level>=20 then
		state = {
			[MODIFIER_STATE_INVISIBLE] = true,
		}
	end

	return state
end











modifier_Advanced_Phantom_Strike_unlock3 = modifier_Advanced_Phantom_Strike_unlock3 or class({})
function modifier_Advanced_Phantom_Strike_unlock3:IsHidden()	return true end
function modifier_Advanced_Phantom_Strike_unlock3:IsDebuff()	return false end
function modifier_Advanced_Phantom_Strike_unlock3:IsPurgable()	return false end
function modifier_Advanced_Phantom_Strike_unlock3:IsPurgeException()	return false end
function modifier_Advanced_Phantom_Strike_unlock3:OnCreated(keys)
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
function modifier_Advanced_Phantom_Strike_unlock3:OnDestroy()
	if IsServer() then
		-- self:GetParent():ForceKill(false)
		local pfx = ParticleManager:CreateParticle("particles/econ/events/nexon_hero_compendium_2014/blink_dagger_start_nexon_hero_cp_2014.vpcf", PATTACH_WORLDORIGIN, nil)
		ParticleManager:SetParticleControl(pfx, 0, self:GetParent():GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex( pfx )
		UTIL_Remove(self:GetParent())
	end
end
function modifier_Advanced_Phantom_Strike_unlock3:CheckState()
	return {
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_OUT_OF_GAME] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_DISARMED] = true,
	}
end
function modifier_Advanced_Phantom_Strike_unlock3:OnAttackStart(keys)
	if self.caster == keys.attacker then
		if self.attack_standby then
			if self.caster:IsAttacking() then
				-- 根据攻击速度触发攻击
				local parent = self:GetParent()
				if self.attack_cooldown<=GameRules:GetGameTime() then
					local needTime = math.max(self.caster:GetSecondsPerAttack(false),0.06)
					self.attack_cooldown = GameRules:GetGameTime() + needTime - FrameTime()
					
					parent:AddNewModifier(parent, self:GetAbility(), "modifier_Advanced_Phantom_Strike_unlock3_attack", {duration=needTime})
					parent:StartGestureWithPlaybackRate(ACT_DOTA_ATTACK,1/needTime)
				end
				
			end
		end
    end
end

function modifier_Advanced_Phantom_Strike_unlock3:OnIntervalThink()

	local caster = self:GetCaster()

	if not caster then
		self:SafeDestroy()
		return
	end
	

	-- if not caster:HasModifier("modifier_Advanced_elder_dragon_form_transform") then
	-- 	-- self:SafeDestroy()
	-- 	self:GoDie()
	-- 	return
	-- end
	self.bonus_move = caster:GetMoveSpeedModifier(caster:GetBaseMoveSpeed(), true)
	local parent = self:GetParent()
	local pos
	if self.type==0 then
		pos = caster:GetAbsOrigin()
		local forward = caster:GetForwardVector()
		local newpos = RotatePosition(pos, QAngle(0, 90, 0), pos + forward)
		local dir = (newpos-pos):Normalized()
		local target_pos = pos+dir*200
		-- target_pos.z = target_pos.z+128
		local dis = CalculateDistance(target_pos,parent:GetAbsOrigin())
		if dis>=2000 then
			parent:SetForwardVector(forward)
			parent:SetAbsOrigin(target_pos+dir)
			return
		end
		if dis>=150 then
			parent:MoveToPosition(target_pos)
			self.attack_standby = false
		else
			-- parent:SetForwardVector(dir)
			parent:FaceTowards(target_pos+dir*100)
			self.attack_standby = true
		end
		-- parent:SetForwardVector(forward)
		-- parent:SetAbsOrigin(target_pos)
	elseif self.type==1 then

		pos = caster:GetAbsOrigin()
		local forward = caster:GetForwardVector()
		-- pos = pos + forward*10
		local newpos = RotatePosition(pos, QAngle(0, -90, 0), pos + forward)
		local dir = (newpos-pos):Normalized()
		local target_pos = pos+dir*200
		-- target_pos.z = target_pos.z+128
		local dis = CalculateDistance(target_pos,parent:GetAbsOrigin())
		if dis>=2000 then
			parent:SetForwardVector(forward)
			parent:SetAbsOrigin(target_pos+dir)
			return
		end
		if dis>=150 then
			parent:MoveToPosition(target_pos)
			self.attack_standby = false
		else
			-- parent:SetForwardVector(forward)
			parent:FaceTowards(target_pos+dir*100)
			self.attack_standby = true
		end
		-- parent:SetForwardVector(forward)
		-- parent:SetAbsOrigin(target_pos)

	-- elseif self.type==2 then
	-- 	local attachment = caster:ScriptLookupAttachment( "attach_head" )
	-- 	pos = caster:GetAttachmentOrigin(attachment)
	-- 	-- pos.z = pos.z + 128
	-- 	local forward = caster:GetForwardVector()
	-- 	pos = pos - forward*50
	-- 	local dis = CalculateDistance(pos,parent:GetAbsOrigin())
	-- 	if dis>=2000 then
	-- 		parent:SetForwardVector(forward)
	-- 		parent:SetAbsOrigin(pos)
	-- 		return
	-- 	end
	-- 	if dis>=100 then
	-- 		parent:MoveToPosition(pos)
	-- 	else
	-- 		parent:SetForwardVector(forward)
	-- 	end
		-- parent:SetForwardVector(forward)
		-- parent:SetAbsOrigin(pos)
	
	end


	
end

function modifier_Advanced_Phantom_Strike_unlock3:DeclareFunctions()
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

-- function modifier_Advanced_Phantom_Strike_unlock3:GetModifierMoveSpeedBonus_Constant( params )
-- 	local index =  (self:GetParent():GetAbsOrigin() - self:GetCaster():GetAbsOrigin()):Length2D()/500
-- 	return self.bonus_move*index
-- end


function modifier_Advanced_Phantom_Strike_unlock3:GetModifierMoveSpeed_AbsoluteMin()
	local caster = self:GetCaster()
	local index =  (self:GetParent():GetAbsOrigin() - caster:GetAbsOrigin()):Length2D()/500
	return math.max( caster:GetMoveSpeedModifier(caster:GetBaseMoveSpeed(), true),self.bonus_move*index)
end


function modifier_Advanced_Phantom_Strike_unlock3:GetModifierIgnoreMovespeedLimit( params )
	return 1
end

function modifier_Advanced_Phantom_Strike_unlock3:GetModifierModelChange(params)
	-- return "models/creeps/omniknight_golem/omniknight_golem.vmdl"
	if IsServer() then
		return self:GetCaster().origin_model_name
	end
	
end
-- function modifier_Advanced_Phantom_Strike_unlock3:GetOverrideAnimation(params)
-- 	return ACT_DOTA_ATTACK
-- end
-- function modifier_Advanced_Phantom_Strike_unlock3:GetOverrideAnimationRate()	return 50 end
function modifier_Advanced_Phantom_Strike_unlock3:GetActivityTranslationModifiers()	
	if self:GetCaster():GetUnitName()=="npc_dota_hero_phantom_assassin" then

		return "haste"
	end
	return "run_fast" 
end


modifier_Advanced_Phantom_Strike_unlock3_attack = modifier_Advanced_Phantom_Strike_unlock3_attack or class({})
function modifier_Advanced_Phantom_Strike_unlock3_attack:IsHidden()	return true end
function modifier_Advanced_Phantom_Strike_unlock3_attack:IsDebuff()	return false end
function modifier_Advanced_Phantom_Strike_unlock3_attack:IsPurgable()	return false end
function modifier_Advanced_Phantom_Strike_unlock3_attack:IsPurgeException()	return false end
function modifier_Advanced_Phantom_Strike_unlock3_attack:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_Advanced_Phantom_Strike_unlock3_attack:OnCreated(keys)
	-- if IsServer() then
	-- self.speed = 1/self:GetRemainingTime()
	self.caster = self:GetAbility():GetCaster()
	-- end
end
function modifier_Advanced_Phantom_Strike_unlock3_attack:DeclareFunctions()
	return {
		-- MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		-- MODIFIER_PROPERTY_OVERRIDE_ANIMATION_RATE,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		-- MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS
	}
end
-- function modifier_Advanced_Phantom_Strike_unlock3_attack:GetPriority() return 9999 end
-- function modifier_Advanced_Phantom_Strike_unlock3_attack:GetActivityTranslationModifiers()	
-- 	local name = self:GetAbility():GetCaster():GetUnitName()
-- 	if name=="npc_dota_hero_terrorblade" then
-- 		return "abysm"
-- 	end
-- 	if name=="npc_dota_hero_monkey_king" then
-- 		return "attack_long_range"
-- 	end
-- end

-- function modifier_Advanced_Phantom_Strike_unlock3_attack:GetOverrideAnimation(params)
-- 	return ACT_DOTA_ATTACK
-- end
-- function modifier_Advanced_Phantom_Strike_unlock3_attack:GetOverrideAnimationRate()	return 0.1 end


function modifier_Advanced_Phantom_Strike_unlock3_attack:OnAttackLanded(keys)
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
		local attackEffectRecord = self.caster:AddAttackEffectModifier( self:GetAbility(),modifier_keys)
		self.caster:PerformAttack(hTarget,false, true, true, true, false, false, true)
		local iPtclID = ParticleManager:CreateParticle('particles/rebuild/spell/phantom_strike/unlock2/effect.vpcf', PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(iPtclID, 0,  parent:GetOrigin())
		ParticleManager:SetParticleControl(iPtclID, 1, hTarget:GetOrigin())
		ParticleManager:ReleaseParticleIndex(iPtclID)
		if IsValid(attackEffectRecord) then
			attackEffectRecord:Destroy()
		end
		break
	end
	

	self:SafeDestroy()


end
