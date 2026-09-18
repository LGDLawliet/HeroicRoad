
LinkLuaModifier("modifier_creeps_spell_Sleight_of_Fist", "creeps_spell/creeps_spell_Sleight_of_Fist", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creeps_spell_Sleight_of_Fist_invulnerability", "creeps_spell/creeps_spell_Sleight_of_Fist", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creeps_spell_Sleight_of_Fist_marker", "creeps_spell/creeps_spell_Sleight_of_Fist", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creeps_spell_Sleight_of_Fist_disarmed", "creeps_spell/creeps_spell_Sleight_of_Fist", LUA_MODIFIER_MOTION_NONE)

--Abilities
if creeps_spell_Sleight_of_Fist == nil then
	creeps_spell_Sleight_of_Fist = class({})
end
function creeps_spell_Sleight_of_Fist:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end
function creeps_spell_Sleight_of_Fist:OnSpellStart()
	local hCaster = self:GetCaster()

	local vPosition = self:GetCursorPosition()
	local radius = self:GetSpecialValueFor("radius")

	local iParticleID = ParticleManager:CreateParticle(ParticleManager:GetParticleReplacement("particles/units/heroes/hero_ember_spirit/ember_spirit_sleight_of_fist_cast.vpcf", hCaster), PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(iParticleID, 0, vPosition)
	ParticleManager:SetParticleControl(iParticleID, 1, Vector(radius, radius, radius))
	ParticleManager:ReleaseParticleIndex(iParticleID)

	hCaster:AddNewModifier(hCaster, self, "modifier_creeps_spell_Sleight_of_Fist", {position=vPosition})

	hCaster:EmitSound("Hero_EmberSpirit.SleightOfFist.Cast")
end

function creeps_spell_Sleight_of_Fist:IsHiddenWhenStolen()
	return false
end
---------------------------------------------------------------------
if modifier_creeps_spell_Sleight_of_Fist == nil then
	modifier_creeps_spell_Sleight_of_Fist = class({})
end
function modifier_creeps_spell_Sleight_of_Fist:IsHidden()return false end
function modifier_creeps_spell_Sleight_of_Fist:IsDebuff() return false end
function modifier_creeps_spell_Sleight_of_Fist:IsPurgable()return false end
function modifier_creeps_spell_Sleight_of_Fist:IsPurgeException()return false end
function modifier_creeps_spell_Sleight_of_Fist:IsStunDebuff()return false end
function modifier_creeps_spell_Sleight_of_Fist:AllowIllusionDuplicate()return false end
function modifier_creeps_spell_Sleight_of_Fist:OnCreated(params)
	self.radius = self:GetAbility():GetSpecialValueFor("radius") 
	self.bonus_hero_damage = self:GetAbility():GetSpecialValueFor("bonus_hero_damage")
	self.attack_interval = self:GetAbility():GetSpecialValueFor("attack_interval")
	-- self.imba_reduce_cooldown = self:GetAbility():GetSpecialValueFor("imba_reduce_cooldown")
	self.imba_chance = self:GetAbility():GetSpecialValueFor("imba_chance")
	if IsServer() then
		local vPosition = StringToVector(params.position)
		local hCaster = self:GetParent()
		local hAbility = self:GetAbility()

		self.tTargets = FindUnitsInRadius(hCaster:GetTeamNumber(), vPosition, nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_CREEP+DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES+DOTA_UNIT_TARGET_FLAG_NO_INVIS+DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE, 0, false)

		if #self.tTargets > 0 then
			self.vStartPosition = hCaster:GetAbsOrigin()
			hAbility:SetActivated(false)

			hCaster:InterruptMotionControllers(true)
			hCaster:AddNewModifier(hCaster, hAbility, "modifier_creeps_spell_Sleight_of_Fist_invulnerability", nil)
			hCaster:AddNewModifier(hCaster, hAbility, "modifier_creeps_spell_Sleight_of_Fist_disarmed", nil)

			local iParticleID = ParticleManager:CreateParticle(ParticleManager:GetParticleReplacement("particles/units/heroes/hero_ember_spirit/ember_spirit_sleight_of_fist_caster.vpcf", hCaster), PATTACH_CUSTOMORIGIN, nil)
			ParticleManager:SetParticleControl(iParticleID, 0, self.vStartPosition)
			ParticleManager:SetParticleControlEnt(iParticleID, 1, hCaster, PATTACH_CUSTOMORIGIN_FOLLOW, nil, self.vStartPosition, true)
			ParticleManager:SetParticleControlForward(iParticleID, 1, hCaster:GetForwardVector())
			self:AddParticle(iParticleID, false, false, -1, false, false)

			for _, hTarget in pairs(self.tTargets) do
				hTarget:AddNewModifier(hCaster, hAbility, "modifier_creeps_spell_Sleight_of_Fist_marker", nil)
			end

			self:OnIntervalThink()
			self:StartIntervalThink(self.attack_interval)
		else
			self:SafeDestroy()
		end
	end
end
function modifier_creeps_spell_Sleight_of_Fist:OnRefresh(params)
	self.radius = self:GetAbility():GetSpecialValueFor("radius")
	self.bonus_hero_damage = self:GetAbility():GetSpecialValueFor("bonus_hero_damage")
	self.attack_interval = self:GetAbility():GetSpecialValueFor("attack_interval")
	-- self.imba_reduce_cooldown = self:GetAbility():GetSpecialValueFor("imba_reduce_cooldown")
	self.imba_chance = self:GetAbility():GetSpecialValueFor("imba_chance")
end
function modifier_creeps_spell_Sleight_of_Fist:OnDestroy()
	if IsServer() then
		local hCaster = self:GetParent()
		local hAbility = self:GetAbility()

		if self.vStartPosition then
			local iParticleID = ParticleManager:CreateParticle(ParticleManager:GetParticleReplacement("particles/units/heroes/hero_ember_spirit/ember_spirit_sleightoffist_trail.vpcf", hCaster), PATTACH_WORLDORIGIN, nil)
			ParticleManager:SetParticleControl(iParticleID, 0, hCaster:GetAbsOrigin())
			ParticleManager:SetParticleControl(iParticleID, 1, self.vStartPosition)
			ParticleManager:ReleaseParticleIndex(iParticleID)

			FindClearSpaceForUnit(hCaster, self.vStartPosition, true)
		end

		hCaster:RemoveModifierByName("modifier_creeps_spell_Sleight_of_Fist_disarmed")
		hCaster:RemoveModifierByName("modifier_creeps_spell_Sleight_of_Fist_invulnerability")

		for i = #self.tTargets, 1, -1 do
			local _hTarget = self.tTargets[i]
			table.remove(self.tTargets, i)
			if IsValid(_hTarget) then
				_hTarget:RemoveModifierByName("modifier_creeps_spell_Sleight_of_Fist_marker")
			end
		end
		if IsValid(hAbility) then
			hAbility:SetActivated(true)
		end
	end
end
function modifier_creeps_spell_Sleight_of_Fist:OnIntervalThink()
	if IsServer() then
		local hCaster = self:GetParent()
		local hAbility = self:GetAbility()
		local vCasterPosition = hCaster:GetAbsOrigin()

		if not IsValid(hAbility) then
			self:SafeDestroy()
			return
		end

		local hTarget
        --注释掉的是可以发动多次攻击的版本，暂时不需要
		-- for i = #self.tTargets, 1, -1 do
		-- 	local _hTarget = self.tTargets[i]
		-- 	if IsValid(_hTarget) then
		-- 		if UnitFilter(_hTarget, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC+DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES+DOTA_UNIT_TARGET_FLAG_NO_INVIS+DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE, hCaster:GetTeamNumber()) == UF_SUCCESS then
		-- 			hTarget = _hTarget
		-- 			if self.imba_chance > RandomInt(0,100)  then
		-- 				_hTarget:RemoveModifierByName("modifier_creeps_spell_Sleight_of_Fist_marker")
		-- 				table.remove(self.tTargets, i)
		-- 			end
		-- 			break
		-- 		else
		-- 			_hTarget:RemoveModifierByName("modifier_creeps_spell_Sleight_of_Fist_marker")
		-- 		end
		-- 	end
		-- 	table.remove(self.tTargets, i)
		-- end

		for i = #self.tTargets, 1, -1 do
			local _hTarget = self.tTargets[i]
			--进行取单位操作，经过过滤器筛选，如果取成功就破坏循环，否则去掉该实体的modifier并从表中删除
			if IsValid(_hTarget) then
				if UnitFilter(_hTarget, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC+DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES+DOTA_UNIT_TARGET_FLAG_NO_INVIS+DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE, hCaster:GetTeamNumber()) == UF_SUCCESS then
					hTarget = _hTarget
					_hTarget:RemoveModifierByName("modifier_creeps_spell_Sleight_of_Fist_marker")
					table.remove(self.tTargets, i)
					break
				else
					_hTarget:RemoveModifierByName("modifier_creeps_spell_Sleight_of_Fist_marker")
				end
			end
			table.remove(self.tTargets, i)
		end

		if not IsValid(hTarget) then
			self:SafeDestroy()
			return
		end

		EmitSoundOnLocationWithCaster(hTarget:GetAbsOrigin(), "Hero_EmberSpirit.SleightOfFist.Damage", hCaster)

		local vTargetPosition = hTarget:GetAbsOrigin()
		local vDirection = vTargetPosition - self.vStartPosition
		vDirection.z = 0

		local vPosition = vTargetPosition - vDirection:Normalized()*50

		hCaster:SetAbsOrigin(vPosition)

		local iParticleID = ParticleManager:CreateParticle(ParticleManager:GetParticleReplacement("particles/units/heroes/hero_ember_spirit/ember_spirit_sleightoffist_trail.vpcf", hCaster), PATTACH_WORLDORIGIN, nil)
		ParticleManager:SetParticleControl(iParticleID, 0, vCasterPosition)
		ParticleManager:SetParticleControl(iParticleID, 1, vPosition)
		ParticleManager:ReleaseParticleIndex(iParticleID)

		local iParticleID = ParticleManager:CreateParticle(ParticleManager:GetParticleReplacement("particles/units/heroes/hero_ember_spirit/ember_spirit_sleightoffist_tgt.vpcf", hCaster), PATTACH_CUSTOMORIGIN, hTarget)
		ParticleManager:SetParticleControlEnt(iParticleID, 0, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetAbsOrigin(), true)
		ParticleManager:ReleaseParticleIndex(iParticleID)

		hCaster:RemoveModifierByName("modifier_creeps_spell_Sleight_of_Fist_disarmed")
		if not hCaster:IsDisarmed() then
			self.bIsHero = hTarget:IsConsideredHero()
			hCaster:PerformAttack(hTarget,false, true, true, true, false, false, true)
			self.bIsHero = false
			local ability = self:GetCaster():FindAbilityByName("creeps_spell_Fire_Remnant")
			if hCaster.pattern_2 and hTarget:IsRealHero() and ability then
				hCaster:SetCursorPosition(hTarget:GetAbsOrigin())
				ability:OnSpellStart()
			end

		end
		hCaster:AddNewModifier(hCaster, hAbility, "modifier_creeps_spell_Sleight_of_Fist_disarmed", nil)
	end
end
function modifier_creeps_spell_Sleight_of_Fist:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
	}
end
function modifier_creeps_spell_Sleight_of_Fist:GetModifierPreAttack_BonusDamage(params)
	if IsServer() then
		if self.bIsHero == true then
			return self.bonus_hero_damage
		end
	end
	return 0
end
---------------------------------------------------------------------
if modifier_creeps_spell_Sleight_of_Fist_invulnerability == nil then
	modifier_creeps_spell_Sleight_of_Fist_invulnerability = class({})
end
function modifier_creeps_spell_Sleight_of_Fist_invulnerability:IsHidden()return true end
function modifier_creeps_spell_Sleight_of_Fist_invulnerability:IsDebuff()return false end
function modifier_creeps_spell_Sleight_of_Fist_invulnerability:IsPurgable()return false end
function modifier_creeps_spell_Sleight_of_Fist_invulnerability:IsPurgeException()return false end
function modifier_creeps_spell_Sleight_of_Fist_invulnerability:IsStunDebuff()return false end
function modifier_creeps_spell_Sleight_of_Fist_invulnerability:AllowIllusionDuplicate()return false end
function modifier_creeps_spell_Sleight_of_Fist_invulnerability:OnCreated(params)
	if IsServer() then
		self:GetParent():AddNoDraw()  --不绘制模型
	end
end
function modifier_creeps_spell_Sleight_of_Fist_invulnerability:OnDestroy()
	if IsServer() then
		self:GetParent():RemoveNoDraw()
		local ability = self:GetCaster():FindAbilityByName("creeps_spell_Activate_Fire_Remnant")
		self:GetCaster():SetCursorPosition(self:GetCaster():GetAbsOrigin())
		ability:OnSpellStart()
	end
end
function modifier_creeps_spell_Sleight_of_Fist_invulnerability:CheckState()
	return {
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,  -- 无碰撞
		[MODIFIER_STATE_INVULNERABLE] = true,       --无敌
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,      --不绘制生命条
		[MODIFIER_STATE_UNSELECTABLE] = true,       --不可选中
		[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,  --飞行 强制类不管
		[MODIFIER_STATE_SILENCED] = true,
	}
end
---------------------------------------------------------------------
if modifier_creeps_spell_Sleight_of_Fist_marker == nil then
	modifier_creeps_spell_Sleight_of_Fist_marker = class({})
end
function modifier_creeps_spell_Sleight_of_Fist_marker:IsHidden()return true end
function modifier_creeps_spell_Sleight_of_Fist_marker:IsDebuff()return false end
function modifier_creeps_spell_Sleight_of_Fist_marker:IsPurgable()return false end
function modifier_creeps_spell_Sleight_of_Fist_marker:IsPurgeException()return false end
function modifier_creeps_spell_Sleight_of_Fist_marker:IsStunDebuff() return false end
function modifier_creeps_spell_Sleight_of_Fist_marker:AllowIllusionDuplicate()return false end
function modifier_creeps_spell_Sleight_of_Fist_marker:GetEffectName()
	return "particles/units/heroes/hero_ember_spirit/ember_spirit_sleight_of_fist_targetted_marker.vpcf"
end
function modifier_creeps_spell_Sleight_of_Fist_marker:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end
---------------------------------------------------------------------
if modifier_creeps_spell_Sleight_of_Fist_disarmed == nil then
	modifier_creeps_spell_Sleight_of_Fist_disarmed = class({})
end
function modifier_creeps_spell_Sleight_of_Fist_disarmed:IsHidden()return true end
function modifier_creeps_spell_Sleight_of_Fist_disarmed:IsDebuff()return false end
function modifier_creeps_spell_Sleight_of_Fist_disarmed:IsPurgable()return false end
function modifier_creeps_spell_Sleight_of_Fist_disarmed:IsPurgeException()return false end
function modifier_creeps_spell_Sleight_of_Fist_disarmed:IsStunDebuff()return false end
function modifier_creeps_spell_Sleight_of_Fist_disarmed:AllowIllusionDuplicate()return false end
function modifier_creeps_spell_Sleight_of_Fist_disarmed:CheckState()
	return {
		[MODIFIER_STATE_DISARMED] = true,   --缴械
	}
end
