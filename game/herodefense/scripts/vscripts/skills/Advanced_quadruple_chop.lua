--特效优化 √
Advanced_quadruple_chop = class({})

LinkLuaModifier( "modifier_Advanced_quadruple_chop_debuff", "skills/Advanced_quadruple_chop", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_Advanced_quadruple_chop_passive", "skills/Advanced_quadruple_chop", LUA_MODIFIER_MOTION_NONE)
require('internal/timers')   --计时器功能


function Advanced_quadruple_chop:UnlockFirstCore(key)
	return true
end
function Advanced_quadruple_chop:UnlockSecondCore(key)
	local caster = self:GetCaster()
	caster:AddNewModifier(caster,self,"modifier_Advanced_quadruple_chop_passive",{})
	return true
end
function Advanced_quadruple_chop:UnlockThirdCore(key)
	return true
end
function Advanced_quadruple_chop:CheckKV(key)
	local table = {

	


		damage = 6,
		bonus_damage = 0.1,





	}
	local value = table[key] or -1
	return value

end


function Advanced_quadruple_chop:OnSpellStart()

	local caster = self:GetCaster()
	local point = self:GetCursorPosition()
	local origin = caster:GetOrigin()
	local min_dist = 200
	local max_dist = 1000
	local radius = 250


	local direction = (point-origin)
	local dist = math.max( math.min( max_dist, direction:Length2D() ), min_dist )
	direction.z = 0
	direction = direction:Normalized()

	local target = GetGroundPosition( origin + direction*dist, nil )
	FindClearSpaceForUnit( caster, target, true )


	local enemies = FindUnitsInLine(self:GetCaster():GetTeamNumber(),	origin,	target,	nil,	radius,	
		DOTA_UNIT_TARGET_TEAM_ENEMY,	DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES	
	)
	local modifier_keys = {
		duration = 0.1,
		iSpecialAttack = 1,
		iDisableApplyModifier = 0,
		iDisableCleave =1,
		iDisableSplit = 1,

	}
	local attackEffectRecord = caster:AddAttackEffectModifier( self,modifier_keys)
	for _,enemy in pairs(enemies) do

		caster:PerformAttack( enemy, true, true, true, false, false, false, true )
		if self.unlock3 then
			enemy:AddNewModifier(caster, self, "modifier_Advanced_quadruple_chop_debuff", {})
		end

		-- self:PlayEffects2( enemy )
	end
	if IsValid(attackEffectRecord) then
		attackEffectRecord:Destroy()
	end
	self:PlayEffects1( origin, target )
	local damage = self:GetSpecialValueFor("damage")+(self:GetSpecialValueFor("bonus_damage"))*caster:GetAgility()
	local damageTable = {
		victim = target,
		attacker = caster,
		damage = damage,
		damage_type = self:GetAbilityDamageType(),
		ability = self, --Optional.
	}
	local count = self:GetSpecialValueFor("effect_count")
	local blade_count = 4 + self:GetCurrentAbilityCharges()
	self:SetCurrentAbilityCharges(0)
	local range = 600
	if self.advanced_level>=5 then
		blade_count = blade_count +2
		if self.advanced_level>=10 then
			count = count +2
			range = range*1.5
		end
	end
	
	
	for i = 1, blade_count, 1 do

		Timers:CreateTimer(RandomFloat(0.1, 0.5), function()
			local vDir = Vector(RandomFloat(-1, 1),RandomFloat(-1, 1),0)
			vDir.z = 0
			vDir = vDir:Normalized()
			local pos_0 = target
			if not self:GetAutoCastState() then
				pos_0 = pos_0+ Vector(RandomInt(-400, 400),RandomInt(-400, 400),0)
			end
			
			local pos_1 = pos_0 + vDir * range
			local pos_2 = pos_0 - vDir * range
			local tTargets = FindUnitsInLine(caster:GetTeamNumber(), pos_1, pos_2, nil, 150,
			DOTA_UNIT_TARGET_TEAM_ENEMY,
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES)

			for i, hTarget in pairs(tTargets) do
				damageTable.victim = hTarget
				ApplyDamage(damageTable)
				if self.unlock3 then
					hTarget:AddNewModifier(caster, self, "modifier_Advanced_quadruple_chop_debuff", {})
				end
				if i>=count then
					break
				end
			end

			local iPtclID = ParticleManager:CreateParticle('particles/rebuild/spell/quadruple_chop_2/quadruple_chop.vpcf', PATTACH_CUSTOMORIGIN, nil)
			ParticleManager:SetParticleControl(iPtclID, 0, pos_2)
			ParticleManager:SetParticleControl(iPtclID, 1, pos_1)
			ParticleManager:SetParticleControl( iPtclID, 60, Vector(255,0,0) )
			ParticleManager:SetParticleControl( iPtclID, 61, Vector(1,0,0) )
			ParticleManager:ReleaseParticleIndex(iPtclID)
			caster:EmitSound("Hero_Centaur.DoubleEdge.TI9")
		end)

	end
	
	if self.advanced_level>=15 then
		if self.unlock1 then
			-- target  中心点
			local ability = self
			local angle = caster:GetAngles()

			for i = 1, 20, 1 do
				Timers:CreateTimer(0.05*i, function()
					if ability and not ability:IsNull() then
						local new_pos = target + Vector(RandomInt(-500,500),RandomInt(-500,500),0)
						local now_pos = caster:GetAbsOrigin()
						local dir = (new_pos-target):Normalized()
						dir.z = 0
						new_pos = target+dir*500
				
						local enemies = FindUnitsInLine(self:GetCaster():GetTeamNumber(),	new_pos,	now_pos,	nil,	radius,	
						DOTA_UNIT_TARGET_TEAM_ENEMY,	DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES	)
						local modifier_keys = {
							duration = 0.1,
							iSpecialAttack = 1,
							iDisableApplyModifier = 0,
							iDisableCleave =1,
							iDisableSplit = 1,
					
						}
						local attackEffectRecord = caster:AddAttackEffectModifier( self,modifier_keys)
						for i,enemy in pairs(enemies) do
							caster:PerformAttack( enemy, true, true, true, false, false, false, true )
							if i>=3 then
								break
							end
						end
						if IsValid(attackEffectRecord) then
							attackEffectRecord:Destroy()
						end
						local direction = (new_pos-now_pos)
						direction.z = 0
						direction = direction:Normalized()
						caster:SetForwardVector(direction)
						self:PlayEffects1( new_pos, now_pos )
						FindClearSpaceForUnit( caster, new_pos, true )
					end
				end)
				
			end
			Timers:CreateTimer(1.05, function()
				local now_pos = caster:GetAbsOrigin()
				local enemies = FindUnitsInLine(self:GetCaster():GetTeamNumber(),	now_pos,	origin,	nil,	radius,	
				DOTA_UNIT_TARGET_TEAM_ENEMY,	DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES	)
				local modifier_keys = {
					duration = 0.1,
					iSpecialAttack = 1,
					iDisableApplyModifier = 0,
					iDisableCleave =1,
					iDisableSplit = 1,
			
				}
				local attackEffectRecord = caster:AddAttackEffectModifier( self,modifier_keys)
				for i,enemy in pairs(enemies) do
					caster:PerformAttack( enemy, true, true, true, false, false, false, true )
					if i>=3 then
						break
					end
				end
				if IsValid(attackEffectRecord) then
					attackEffectRecord:Destroy()
				end
				self:PlayEffects1( now_pos, origin )
				caster:SetAngles(angle.x, angle.y, angle.z)
				FindClearSpaceForUnit( caster, origin, true )
			end)
			
		else
			Timers:CreateTimer(1, function()
				local enemies = FindUnitsInLine(self:GetCaster():GetTeamNumber(),	target,	origin,	nil,	radius,	
				DOTA_UNIT_TARGET_TEAM_ENEMY,	DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES	)
				local modifier_keys = {
					duration = 0.1,
					iSpecialAttack = 1,
					iDisableApplyModifier = 0,
					iDisableCleave =1,
					iDisableSplit = 1,
			
				}
				local attackEffectRecord = caster:AddAttackEffectModifier( self,modifier_keys)
				for _,enemy in pairs(enemies) do
					caster:PerformAttack( enemy, true, true, true, false, false, false, true )
					if self.unlock3 then
						enemy:AddNewModifier(caster, self, "modifier_Advanced_quadruple_chop_debuff", {})
					end
				end
				if IsValid(attackEffectRecord) then
					attackEffectRecord:Destroy()
				end
				self:PlayEffects1( target, origin )
				FindClearSpaceForUnit( caster, origin, true )
				if self.advanced_level>=20 then
					Timers:CreateTimer(0.1, function()
						local enemies = FindUnitsInLine(self:GetCaster():GetTeamNumber(),	origin,	target,	nil,	radius,	
						DOTA_UNIT_TARGET_TEAM_ENEMY,	DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES	)
						local modifier_keys = {
							duration = 0.1,
							iSpecialAttack = 1,
							iDisableApplyModifier = 0,
							iDisableCleave =1,
							iDisableSplit = 1,
					
						}
						local attackEffectRecord = caster:AddAttackEffectModifier( self,modifier_keys)
						for _,enemy in pairs(enemies) do
							caster:PerformAttack( enemy, true, true, true, false, false, false, true )
							if self.unlock3 then
								enemy:AddNewModifier(caster, self, "modifier_Advanced_quadruple_chop_debuff", {})
							end
						end
						if IsValid(attackEffectRecord) then
							attackEffectRecord:Destroy()
						end
						self:PlayEffects1( origin, target )
						FindClearSpaceForUnit( caster, target, true )
					end)
					Timers:CreateTimer(0.2, function()
						local enemies = FindUnitsInLine(self:GetCaster():GetTeamNumber(),	target,	origin,	nil,	radius,	
						DOTA_UNIT_TARGET_TEAM_ENEMY,	DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES	)
						local modifier_keys = {
							duration = 0.1,
							iSpecialAttack = 1,
							iDisableApplyModifier = 0,
							iDisableCleave =1,
							iDisableSplit = 1,
					
						}
						local attackEffectRecord = caster:AddAttackEffectModifier( self,modifier_keys)
						for _,enemy in pairs(enemies) do
							caster:PerformAttack( enemy, true, true, true, false, false, false, true )
							if self.unlock3 then
								enemy:AddNewModifier(caster, self, "modifier_Advanced_quadruple_chop_debuff", {})
							end
						end
						if IsValid(attackEffectRecord) then
							attackEffectRecord:Destroy()
						end
						self:PlayEffects1( target, origin )
						FindClearSpaceForUnit( caster, origin, true )
					end)
				end
			end)
		end

	end

	
end

--------------------------------------------------------------------------------
function Advanced_quadruple_chop:PlayEffects1( origin, target )
	
	local particle_cast = "particles/rebuild/spell/quadruple_chop_2/quadruple_chop.vpcf"
	local sound_start = "Hero_VoidSpirit.AstralStep.Start"
	local sound_end = "Hero_VoidSpirit.AstralStep.End"


	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, origin )
	ParticleManager:SetParticleControl( effect_cast, 1, target )
	ParticleManager:SetParticleControl( effect_cast, 60, Vector(255,0,0) )
	ParticleManager:SetParticleControl( effect_cast, 61, Vector(1,0,0) )
	ParticleManager:ReleaseParticleIndex( effect_cast )


	EmitSoundOnLocationWithCaster( origin, sound_start, self:GetCaster() )
	EmitSoundOnLocationWithCaster( target, sound_end, self:GetCaster() )
end

-- function Advanced_quadruple_chop:PlayEffects2( target )

-- 	local particle_cast = "particles/units/heroes/hero_void_spirit/astral_step/void_spirit_astral_step_impact.vpcf"


-- 	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
-- 	ParticleManager:ReleaseParticleIndex( effect_cast )
-- end




modifier_Advanced_quadruple_chop_passive = class({})

function modifier_Advanced_quadruple_chop_passive:IsHidden()	return false end
function modifier_Advanced_quadruple_chop_passive:IsDebuff()	return false end
function modifier_Advanced_quadruple_chop_passive:IsPurgable()	return false end
function modifier_Advanced_quadruple_chop_passive:IsPurgeException() return false end
function modifier_Advanced_quadruple_chop_passive:RemoveOnDeath() return false end
function modifier_Advanced_quadruple_chop_passive:DeclareFunctions()
    return {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
    }
end

function modifier_Advanced_quadruple_chop_passive:OnAttackLanded(keys)
	if not IsServer() then return end
	local caster = self:GetCaster()
	if not caster:IsRealHero() then
		return false
	end
	if keys.attacker == caster and keys.target and keys.target:GetTeamNumber() ~= caster:GetTeamNumber() and  not caster:PassivesDisabled() then	
		if caster:IsInSpecialAttack() then
			return
		end
		local ability = self:GetAbility()
		self:IncrementStackCount()
		if self:GetStackCount()>=5 then
			self:SetStackCount(0)
			local target =keys.target
			local pos = target:GetAbsOrigin()
			local vDir = Vector(RandomFloat(-1, 1),RandomFloat(-1, 1),0)
			local pos_1 = pos + vDir * 1200


		
		
			local enemies = FindUnitsInLine(caster:GetTeamNumber(),pos,	pos_1,	nil,	250,	
				DOTA_UNIT_TARGET_TEAM_ENEMY,	DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES	
			)
			local modifier_keys = {
				duration = 0.1,
				iSpecialAttack = 1,
				iDisableApplyModifier = 0,
				iDisableCleave =1,
				iDisableSplit = 1,
		
			}
			local attackEffectRecord = caster:AddAttackEffectModifier( self:GetAbility(),modifier_keys)
			for i,enemy in pairs(enemies) do
				caster:PerformAttack( enemy, true, true, true, false, false, false, true )
				if i>=5 then
					break
				end
			end
			if IsValid(attackEffectRecord) then
				attackEffectRecord:Destroy()
			end
			ability:PlayEffects1( pos, pos_1 )

		end
		
	end
end




modifier_Advanced_quadruple_chop_debuff = advanced_modifier({})
function modifier_Advanced_quadruple_chop_debuff:IsDebuff()			return true end
function modifier_Advanced_quadruple_chop_debuff:IsHidden() 			return false end
function modifier_Advanced_quadruple_chop_debuff:IsPurgable() 			return false end
function modifier_Advanced_quadruple_chop_debuff:IsPurgeException() 	return false end

function modifier_Advanced_quadruple_chop_debuff:OnCreated()

	if IsServer() then
		self:IncrementStackCount()
	end
end

function modifier_Advanced_quadruple_chop_debuff:OnRefresh()
	if IsServer() then
		if self:GetStackCount()>=100 then
			return
		end
		self:IncrementStackCount()
	end
end

function modifier_Advanced_quadruple_chop_debuff:Advanced_GetModifierPhysicalArmorBonus() return -self:GetStackCount() end

function modifier_Advanced_quadruple_chop_debuff:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }
end