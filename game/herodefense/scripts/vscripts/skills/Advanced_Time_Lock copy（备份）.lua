Advanced_Time_Lock = class({})

LinkLuaModifier("modifier_Advanced_Time_Lock_passive", "skills/Advanced_Time_Lock", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Time_Lock_reduce", "skills/Advanced_Time_Lock", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Time_Lock_unlock2", "skills/Advanced_Time_Lock", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Time_Lock_unlock2_debuff", "skills/Advanced_Time_Lock", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Time_Lock_unlock3", "skills/Advanced_Time_Lock", LUA_MODIFIER_MOTION_NONE)
require('internal/timers')   --计时器功能


LinkLuaModifier("modifier_Advanced_Time_Lock_thinker", "skills/Advanced_Time_Lock", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Time_Lock_debuff", "skills/Advanced_Time_Lock", LUA_MODIFIER_MOTION_NONE)
---------------------------------------------------------------------------------------

--


function Advanced_Time_Lock:CheckKV(key)
	local table = {
		bash_damage=10,


	}
	local value = table[key] or -1
	return value

end
function Advanced_Time_Lock:UnlockFirstCore(key)
	-- local caster = self:GetCaster()
	-- caster:AddNewModifier(caster,self,"modifier_Advanced_magic_blessing_unlock1",{})
	return true
end
function Advanced_Time_Lock:UnlockSecondCore(key)
	-- local caster = self:GetCaster()
	-- caster:AddNewModifier(caster,self,"modifier_Advanced_magic_blessing_unlock2",{})
	return true
end
function Advanced_Time_Lock:UnlockThirdCore(key)
	-- local caster = self:GetCaster()
	-- caster:AddNewModifier(caster,self,"modifier_Advanced_Time_Drain_unlock3",{})
	return true
end
function Advanced_Time_Lock:GetIntrinsicModifierName() return "modifier_Advanced_Time_Lock_passive" end
function Advanced_Time_Lock:GetCooldown(iLevel)

	local advanced_level = self:GetSpecialValueFor("advanced_level")
	--LV10解锁降维打击
	if advanced_level>=10 then
		--LV15解锁降维打击++
		if advanced_level>=15 then
			return 0.5
		end
		return 1
	end
	return 2
end


function Advanced_Time_Lock:CreateChronosphere(caster, position, radius, duration, ally_behavior)  --创造缝隙的函数
	-- Ally Behavior: 1 = Stun Allies, 2 = DO NOT EFFECT Allies, 4 = DO NOT EFFECT SPELL IMMUNE Enemies ////  add them up
	local ially_behavior = ally_behavior or 1
	local thinker = CreateModifierThinker(caster, self, "modifier_Advanced_Time_Lock_thinker", {duration = duration, radius = radius, ally_behavior = ially_behavior}, position, caster:GetTeamNumber(), false)
	return thinker
end
function Advanced_Time_Lock:GetBehavior()
	local NetTable_key = tostring(self:GetCaster():GetPlayerOwnerID()).."_"..self:GetAbilityName().."_unlock"
	local coreUnlockKV = CustomNetTables:GetTableValue( "playerSpellLevelInfo", NetTable_key)
	if coreUnlockKV then
		if coreUnlockKV.coreUnlock ==3 then
			return DOTA_ABILITY_BEHAVIOR_NO_TARGET
		end
		
	end
	return self.BaseClass.GetBehavior(self)
end

function Advanced_Time_Lock:OnSpellStart()
	local caster = self:GetCaster()
	caster:AddNewModifier(caster, self, "modifier_Advanced_Time_Lock_unlock3", {duration = 5})
	self:StartCooldown(60)
end

function Advanced_Time_Lock:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/spell/time_lock/unlock2/effect.vpcf", context )
	PrecacheResource( "particle", "particles/creatures/aghanim/aghanim_outro.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/spell/time_lock/unlock3/effect.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_faceless_void/faceless_void_time_lock_bash.vpcf", context )
end
modifier_Advanced_Time_Lock_passive = class({})

function modifier_Advanced_Time_Lock_passive:IsDebuff()			return false end
function modifier_Advanced_Time_Lock_passive:IsHidden() 			return true end
function modifier_Advanced_Time_Lock_passive:IsPurgable() 		return false end  --不可驱散
function modifier_Advanced_Time_Lock_passive:IsPurgeException() 	return false end

function modifier_Advanced_Time_Lock_passive:DeclareFunctions()	return {MODIFIER_EVENT_ON_ATTACK_LANDED,MODIFIER_EVENT_ON_TAKEDAMAGE} end

function modifier_Advanced_Time_Lock_passive:OnAttackLanded(keys)
	if not IsServer() then
		return 
	end
	if keys.attacker ~= self:GetParent() or self:GetParent():IsIllusion() or self:GetParent():PassivesDisabled() or not keys.target:IsAlive() then
		return
	end
	if keys.target:IsBuilding() or keys.target:IsOther() then
		return
	end
	local ability = self:GetAbility()
	local level = ability.advanced_level
	if self:GetCaster():GetRandomEffect( ability:GetSpecialValueFor("bash_chance"),INT_TYPE,1)  > RandomInt(0,100) then
		local target_pos =  keys.target:GetAbsOrigin()
		local parent = self:GetParent()
		local buff = parent:GetModifierStackCount("modifier_Advanced_Time_Lock_reduce", parent)
		local  bash_radius=ability:GetSpecialValueFor("bash_radius")
		--LV5解锁时间结界+
		if level>=5 then
			bash_radius = bash_radius +100
		end
		local bash_duration = ability:GetSpecialValueFor("bash_duration")
		if self.faceless_void_talent or self:GetParent():HasAbility("heroTalent_npc_dota_hero_faceless_void_3") then
			bash_duration = bash_duration +0.4
			self.faceless_void_talent = true
		end
		local radius_reduce = 20
		local time_reduce = 0.05
		if ability.unlock1 then
			time_reduce = time_reduce *0.3
			bash_duration = bash_duration *2
		end
		local radius = math.max(ability:GetSpecialValueFor("radius_min"), bash_radius - radius_reduce * buff)
		keys.target:EmitSound("Hero_FacelessVoid.TimeLockImpact")
		local duration = bash_duration-buff*time_reduce
		
		--if not self:GetParent():HasTalent("special_bonus_imba_faceless_void_1") then
		local ModifierStatusNegativeGain = self:GetCaster():GetModifierStatusNegativeGainIndex(0.35)
		local StatusResistance = keys.target:GetHDStatusResistanceIndex(1)*ModifierStatusNegativeGain
		duration = math.max(duration,0)*StatusResistance
		if duration>0 then
			if self.faceless_void_talent then
				bash_duration = math.max(0.2,bash_duration)
			end
			ability:CreateChronosphere(parent, target_pos, radius, duration, 2)
			parent:AddNewModifier(parent, ability, "modifier_Advanced_Time_Lock_reduce", {duration = ability:GetSpecialValueFor("reduce_duration")})
		end
		
		--end
		local enemies = FindUnitsInRadius(parent:GetTeamNumber(),target_pos, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
		local attacks = ability:GetSpecialValueFor("additional_attacks")
		--LV15解锁降维打击++
		if level>=15 then
			attacks = 5
		end
		--LV20解锁时间掌握
		if level>=20 and self:GetStackCount()>10 then
			keys.attacker:Heal(self:GetStackCount()/10, keys.attacker)  --	治疗该单位
		end

		local damage = ability:GetSpecialValueFor("bash_damage")
		for _, enemy in pairs(enemies) do
			local damageTable = {
								victim = enemy,
								attacker = parent,
								damage = damage,
								damage_type = ability:GetAbilityDamageType(),
								damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
								ability = ability, --Optional.
								}
			ApplyDamage(damageTable)
		end
	
		if ability:IsCooldownReady() then
			if ability.unlock2 and parent:GetRandomEffect(16,INT_TYPE,1)>= RandomInt(1, 100) then
				-- target_pos
				-- parent
				parent:AddNewModifier(parent, ability, "modifier_Advanced_Time_Lock_unlock2", {duration =10,x=target_pos.x,y=target_pos.y,z=target_pos.z})
		
		
				
			end

			local modifier_keys = {
				duration = 0.1,
				iSpecialAttack = 1,
				iDisableApplyModifier = 0,
				iDisableCleave =1,
				iDisableSplit = 1,
		
			}
	
			local attackEffectRecord = parent:AddAttackEffectModifier(self:GetAbility(),modifier_keys)
			
			for i = 1, attacks do
				if enemies[i] then
					ability:UseResources(true, true, true, true)
					parent:PerformAttack(enemies[i], false, true, true, true, false, false, true)--对一单位执行攻击。
				end
			end
			if IsValid(attackEffectRecord) then
				attackEffectRecord:Destroy()
			end
		end
	end
end

function modifier_Advanced_Time_Lock_passive:OnTakeDamage(keys)
	if not IsServer() then 
		return
	end
	if self:GetAbility().advanced_level<20 then
		return
	end
	if keys.unit ~= self:GetParent() then
		return
	end
	if bit.band(keys.damage_flags, DOTA_DAMAGE_FLAG_HPLOSS) == DOTA_DAMAGE_FLAG_HPLOSS then
		return
	end
	local buff = self:GetParent():GetModifierStackCount("modifier_Advanced_Time_Lock_reduce", self:GetParent())
	local reduce = 0.02
	if self:GetAbility().unlock1 then
		reduce = reduce *0.3
	end
	local time =math.max(0.2-buff*reduce,0)
	if time<=0 then
		return
	end
	local damage = keys.damage-keys.damage%1
	self:SetStackCount(self:GetStackCount()+ damage * 10)

	Timers:CreateTimer(time, function()
		self:SetStackCount(self:GetStackCount()- damage * 10)
	end)
end



modifier_Advanced_Time_Lock_reduce = class({})

function modifier_Advanced_Time_Lock_reduce:IsDebuff()			return true end
function modifier_Advanced_Time_Lock_reduce:IsHidden() 			return false end
function modifier_Advanced_Time_Lock_reduce:IsPurgable() 			return false end
function modifier_Advanced_Time_Lock_reduce:IsPurgeException() 	return false end

function modifier_Advanced_Time_Lock_reduce:OnCreated(params)
	self.ability = self:GetAbility()
	if IsServer() then
		self.tData = {}
		table.insert(self.tData, { dieTime = self:GetDieTime() })
		self:IncrementStackCount()
		self:StartIntervalThink(0.1)
		

	end
end
function modifier_Advanced_Time_Lock_reduce:OnRefresh(params)
	if IsServer() then
		local dieTime = self:GetDieTime()
		table.insert(self.tData, {dieTime = dieTime })
		self:IncrementStackCount()
	end
end


function modifier_Advanced_Time_Lock_reduce:OnIntervalThink()
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









----------------------------------------------------------------------------------
modifier_Advanced_Time_Lock_thinker = class({})

function modifier_Advanced_Time_Lock_thinker:OnCreated(keys)
	if IsServer() then
		AddFOWViewer(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), keys.radius, self:GetDuration(), false)
		self.radius = keys.radius
		self.ally_behavior = keys.ally_behavior
		local pfx_name = "particles/units/heroes/hero_faceless_void/faceless_void_chronosphere.vpcf"

		local pfx = ParticleManager:CreateParticle(pfx_name, PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(pfx, 0, self:GetParent():GetAbsOrigin())
		ParticleManager:SetParticleControl(pfx, 1, Vector(self.radius, self.radius, self.radius))
		self:AddParticle(pfx, false, false, 16, false, false)
	end
end

function modifier_Advanced_Time_Lock_thinker:IsAura() return true end
function modifier_Advanced_Time_Lock_thinker:GetAuraDuration() return 0.1 end
function modifier_Advanced_Time_Lock_thinker:GetModifierAura() return "modifier_Advanced_Time_Lock_debuff" end
function modifier_Advanced_Time_Lock_thinker:GetAuraRadius() return self.radius end
function modifier_Advanced_Time_Lock_thinker:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES end
function modifier_Advanced_Time_Lock_thinker:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_BOTH end
function modifier_Advanced_Time_Lock_thinker:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BUILDING + DOTA_UNIT_TARGET_BASIC end
function modifier_Advanced_Time_Lock_thinker:GetAuraEntityReject(unit)
	if bit.band(self.ally_behavior, 4) == 4 and unit:GetTeamNumber() ~= self:GetCaster():GetTeamNumber() and unit:IsMagicImmune() then
		return true
	end
	if bit.band(self.ally_behavior, 2) == 2 and unit:GetTeamNumber() == self:GetCaster():GetTeamNumber() then
		return true
	end
	if unit:IsInvulnerable() and unit:IsHero() then
		return true
	end
end


function modifier_Advanced_Time_Lock_thinker:OnDestroy()
	if IsServer() then
		
		UTIL_Remove(self:GetParent())
		
	end
end


modifier_Advanced_Time_Lock_debuff = class({})

--Chronosphere Parent Type
Chronosphere_Caster = 1
Chronosphere_Ally = 2
Chronosphere_Ally_Scepter = 3
Chronosphere_Enemy = 4
Chronosphere_Enemy_Ability = 5

function modifier_Advanced_Time_Lock_debuff:OnCreated()
	self.buff_type = 0
	if self:GetParent():GetPlayerOwnerID() == self:GetCaster():GetPlayerOwnerID()then
		self.buff_type = Chronosphere_Caster
	elseif self:GetParent():GetTeamNumber() == self:GetCaster():GetTeamNumber() and not self:GetCaster():HasScepter() then
		self.buff_type = Chronosphere_Ally
	elseif self:GetParent():GetTeamNumber() == self:GetCaster():GetTeamNumber() and self:GetCaster():HasScepter() then
		self.buff_type = Chronosphere_Ally_Scepter
	elseif self:GetParent():GetTeamNumber() ~= self:GetCaster():GetTeamNumber() and not self:GetParent():HasModifier("modifier_Advanced_Time_Lock_aoe") then
		self.buff_type = Chronosphere_Enemy
	elseif self:GetParent():GetTeamNumber() ~= self:GetCaster():GetTeamNumber() and self:GetParent():HasModifier("modifier_Advanced_Time_Lock_aoe") then
		self.buff_type = Chronosphere_Enemy_Ability
	else
		self.buff_type = Chronosphere_Enemy
	end
	self.ms = self:GetParent():GetMoveSpeedModifier(self:GetParent():GetBaseMoveSpeed(), false) * (1 - (self:GetAbility():GetSpecialValueFor("slow_scepter") / 100))
	if IsServer() and self:IsMotionController() then
		self:GetParent():InterruptMotionControllers(false)
		self.abs = self:GetParent():GetAbsOrigin()
		self:StartIntervalThink(FrameTime())
	end





end

function modifier_Advanced_Time_Lock_debuff:OnIntervalThink()

	self:GetParent():InterruptMotionControllers(false)
	self:GetParent():SetOrigin(self.abs)
end

function modifier_Advanced_Time_Lock_debuff:OnDestroy()
	if IsServer() and self:IsMotionController() then
		self.abs = nil
		FindClearSpaceForUnit(self:GetParent(), self:GetParent():GetAbsOrigin(), true)
	end
	self.buff_type = nil
end

function modifier_Advanced_Time_Lock_debuff:IsHidden() 			return true end
function modifier_Advanced_Time_Lock_debuff:IsPurgable() 			return false end
function modifier_Advanced_Time_Lock_debuff:IsPurgeException() 	return false end
function modifier_Advanced_Time_Lock_debuff:GetPriority() return MODIFIER_PRIORITY_SUPER_ULTRA end
function modifier_Advanced_Time_Lock_debuff:IsDebuff() return not (self.buff_type == Chronosphere_Caster or self.buff_type == Chronosphere_Enemy_Ability) end
function modifier_Advanced_Time_Lock_debuff:IsStunDebuff()	return self:IsDebuff() end
function modifier_Advanced_Time_Lock_debuff:IsMotionController() return not (self.buff_type == Chronosphere_Caster or self.buff_type == Chronosphere_Ally_Scepter or self.buff_type == Chronosphere_Enemy_Ability) end
function modifier_Advanced_Time_Lock_debuff:GetMotionControllerPriority() return DOTA_MOTION_CONTROLLER_PRIORITY_HIGHEST end
function modifier_Advanced_Time_Lock_debuff:GetStatusEffectName() return "particles/status_fx/status_effect_faceless_chronosphere.vpcf" end
function modifier_Advanced_Time_Lock_debuff:StatusEffectPriority() return 16 end
function modifier_Advanced_Time_Lock_debuff:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_Advanced_Time_Lock_debuff:GetEffectName()
	if not self:IsMotionController() then
		return "particles/units/heroes/hero_faceless_void/faceless_void_chrono_speed.vpcf"
	else
		return nil
	end
end

function modifier_Advanced_Time_Lock_debuff:CheckState()
	if self:IsMotionController() then
		return {[MODIFIER_STATE_STUNNED] = true, [MODIFIER_STATE_ROOTED] = true, [MODIFIER_STATE_DISARMED] = true, [MODIFIER_STATE_INVISIBLE] = false, [MODIFIER_STATE_FROZEN] = true}
	elseif self.buff_type == Chronosphere_Caster or self.buff_type == Chronosphere_Enemy_Ability then
		return {[MODIFIER_STATE_NO_UNIT_COLLISION] = true}
	else
		return nil
	end
end










modifier_Advanced_Time_Lock_unlock2 = class({})

function modifier_Advanced_Time_Lock_unlock2:IsDebuff()			return true end
function modifier_Advanced_Time_Lock_unlock2:IsHidden() 			return true end
function modifier_Advanced_Time_Lock_unlock2:IsPurgable() 			return false end
function modifier_Advanced_Time_Lock_unlock2:IsPurgeException() 	return false end
function modifier_Advanced_Time_Lock_unlock2:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_Advanced_Time_Lock_unlock2:OnCreated(keys)
	self.ability = self:GetAbility()
	if IsServer() then
		-- particles/rebuild/spell/time_lock/unlock2/effect.vpcf
		self.pos = Vector(keys.x,keys.y,keys.z+800)
		self.timer = 0

		self.nFXIndex = ParticleManager:CreateParticle( "particles/rebuild/spell/time_lock/unlock2/effect.vpcf", PATTACH_WORLDORIGIN, nil )
		ParticleManager:SetParticleControl(self.nFXIndex, 0, self.pos)
		-- ParticleManager:ReleaseParticleIndex(nFXIndex)
	
		self:StartIntervalThink(FrameTime())
		
		-- particles/creatures/aghanim/aghanim_outro.vpcf
	end
end
function modifier_Advanced_Time_Lock_unlock2:OnDestroy()
	if IsServer() then

		ParticleManager:DestroyParticle(self.nFXIndex, true)
		ParticleManager:ReleaseParticleIndex(self.nFXIndex)
	end
end

function modifier_Advanced_Time_Lock_unlock2:OnIntervalThink()
	if IsServer() then
		self.pos.z = self.pos.z -80
		ParticleManager:SetParticleControl(self.nFXIndex, 0, self.pos)
		self.timer  = self.timer  + 1
		if self.timer%4==0 then
			-- self.timer  = 0
			local dir = CalculateDirection(self.pos, self.pos+Vector(RandomInt(-500, 500),RandomInt(-500, 500),0))
			ParticleManager:SetParticleControlForward(self.nFXIndex, 0, dir)  --方向
		end
		if self.timer==10 then
			self:StartIntervalThink(-1)

			self.pos.z = self.pos.z +80
			local nFXIndex = ParticleManager:CreateParticle( "particles/creatures/aghanim/aghanim_outro.vpcf", PATTACH_WORLDORIGIN, nil )
			ParticleManager:SetParticleControl(nFXIndex, 0, self.pos)
			ParticleManager:ReleaseParticleIndex(nFXIndex)
			local parent = self:GetParent()
			local ability = self:GetAbility()
			local enemies = FindUnitsInRadius(parent:GetTeamNumber(), self.pos, nil, 400, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
			local damageTable = {
				-- victim = enemy,
				attacker = parent,
				damage = parent:GetAverageTrueAttackDamage(nil)*3,
				damage_type = DAMAGE_TYPE_PHYSICAL,
				damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
				ability = ability, --Optional.
			}
			local max_count = 8
			for _, enemy in pairs(enemies) do
				damageTable.victim = enemy
				ApplyDamage(damageTable)
				enemy:AddNewModifier(parent, ability, "modifier_Advanced_Time_Lock_unlock2_debuff", {duration =0.1})
				max_count = max_count- 1
				if max_count<=0 then
					break
				end
			end

			parent:EmitSound("Hero_FacelessVoid.Chronosphere.MaceOfAeons")
			self:SafeDestroy()
		end
	
	end
end




modifier_Advanced_Time_Lock_unlock2_debuff = class({})
function modifier_Advanced_Time_Lock_unlock2_debuff:IsHidden() 			return true end
function modifier_Advanced_Time_Lock_unlock2_debuff:IsPurgable() 			return true end
function modifier_Advanced_Time_Lock_unlock2_debuff:IsPurgeException() 	return true end
function modifier_Advanced_Time_Lock_unlock2_debuff:IsDebuff() return true end
function modifier_Advanced_Time_Lock_unlock2_debuff:GetStatusEffectName() return "particles/status_fx/status_effect_faceless_chronosphere.vpcf" end
function modifier_Advanced_Time_Lock_unlock2_debuff:StatusEffectPriority() return 16 end
function modifier_Advanced_Time_Lock_unlock2_debuff:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_Advanced_Time_Lock_unlock2_debuff:GetEffectName()
	return "particles/units/heroes/hero_faceless_void/faceless_void_chrono_speed.vpcf"
end

function modifier_Advanced_Time_Lock_unlock2_debuff:CheckState()
	return {
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_ROOTED] = true,
		[MODIFIER_STATE_DISARMED] = true,
		[MODIFIER_STATE_FROZEN] = true}
end








modifier_Advanced_Time_Lock_unlock3 = class({})

function modifier_Advanced_Time_Lock_unlock3:OnCreated()
	if IsServer() then
		self:StartIntervalThink(FrameTime())
		local particle_cast = "particles/rebuild/spell/time_lock/unlock3/effect.vpcf"

		-- Create Particle
		local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
		-- ParticleManager:SetParticleControl( effect_cast, iControlPoint, vControlVector )
		ParticleManager:SetParticleControlEnt(
			effect_cast,
			0,
			self:GetParent(),
			PATTACH_ABSORIGIN_FOLLOW,
			"attach_hitloc",
			Vector(0,0,0), -- unknown
			true -- unknown, true
		)

		-- buff particle
		self:AddParticle(
			effect_cast,
			false, -- bDestroyImmediately
			false, -- bStatusEffect
			-1, -- iPriority
			false, -- bHeroEffect
			false -- bOverheadEffect
		)
	end
end

function modifier_Advanced_Time_Lock_unlock3:OnIntervalThink()
	local parent = self:GetParent()
	if parent:IsAlive() then
		local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(),
		self:GetCaster():GetAbsOrigin(), nil, 1000, DOTA_UNIT_TARGET_TEAM_ENEMY,
		 DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		if enemies~=nil then
			for _, unit in ipairs(enemies) do
				-- particles/units/heroes/hero_faceless_void/faceless_void_time_lock_bash.vpcf
				local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_faceless_void/faceless_void_time_lock_bash.vpcf", PATTACH_ABSORIGIN_FOLLOW, parent )
				ParticleManager:SetParticleControlEnt( nFXIndex, 0,unit, PATTACH_POINT_FOLLOW, nil,unit:GetAbsOrigin(), true )
				ParticleManager:SetParticleControlEnt( nFXIndex,1,unit, PATTACH_POINT_FOLLOW, nil,unit:GetAbsOrigin(), true )
				ParticleManager:SetParticleControlEnt( nFXIndex,4,unit, PATTACH_POINT_FOLLOW, nil,unit:GetAbsOrigin(), true )
				ParticleManager:SetParticleControlEnt(nFXIndex, 2, parent, PATTACH_CUSTOMORIGIN, "attach_hitloc", parent:GetAbsOrigin(), true)
				-- ParticleManager:SetParticleControl(nFXIndex, 2, Vector(1,0,0))
				ParticleManager:ReleaseParticleIndex(nFXIndex)
				parent:EmitSound("Hero_FacelessVoid.TimeLockImpact")
				local modifier_keys = {
					duration = 0.1,
					iSpecialAttack = 1,
					iDisableApplyModifier = 0,
					iDisableCleave =1,
					iDisableSplit = 1,
			
				}
		
				local attackEffectRecord = parent:AddAttackEffectModifier(self:GetAbility(),modifier_keys)
				parent:PerformAttack(unit, false, true, true, true, false, false, true)--对一单位执行攻击。
				if IsValid(attackEffectRecord) then
					attackEffectRecord:Destroy()
				end
				break
			end
		
		end
	end

end


function modifier_Advanced_Time_Lock_unlock3:IsHidden() 			return false end
function modifier_Advanced_Time_Lock_unlock3:IsPurgable() 			return false end
function modifier_Advanced_Time_Lock_unlock3:IsPurgeException() 	return false end
function modifier_Advanced_Time_Lock_unlock3:IsDebuff() return false end
function modifier_Advanced_Time_Lock_unlock3:GetMotionControllerPriority() return DOTA_MOTION_CONTROLLER_PRIORITY_HIGHEST end
function modifier_Advanced_Time_Lock_unlock3:GetStatusEffectName() return "particles/status_fx/status_effect_faceless_chronosphere.vpcf" end
function modifier_Advanced_Time_Lock_unlock3:StatusEffectPriority() return 16 end
function modifier_Advanced_Time_Lock_unlock3:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
-- function modifier_Advanced_Time_Lock_unlock3:GetEffectName()
-- 	if not self:IsMotionController() then
-- 		return "particles/rebuild/spell/time_lock/unlock3/effect.vpcf"
-- 	else
-- 		return nil
-- 	end
-- end

function modifier_Advanced_Time_Lock_unlock3:CheckState()
	return {[MODIFIER_STATE_NO_UNIT_COLLISION] = true}
end