
Advanced_Tidebringer = Advanced_Tidebringer or class({})
LinkLuaModifier("modifier_Advanced_Tidebringer", "skills/Advanced_Tidebringer", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Tidebringer_debuff", "skills/Advanced_Tidebringer", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier( "modifier_Advanced_Tidebringer_ghost", "skills/Advanced_Tidebringer", LUA_MODIFIER_MOTION_NONE )

require('internal/timers')
function Advanced_Tidebringer:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_kunkka/kunkka_spell_tidebringer.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/spell/tidebringer/single_tidebringer_hit.vpcf", context )
	PrecacheResource( "particle", "particles/econ/items/kunkka/kunkka_weapon_whaleblade_retro/kunkka_spell_torrent_retro_whaleblade_wave.vpcf", context )

	
end

function Advanced_Tidebringer:UnlockFirstCore(key)
	-- local caster = self:GetCaster()
	-- local modifier = caster:AddNewModifier(caster,self,"modifier_Advanced_hyakkiyakou_unlock1",{})
	
	return true
end
function Advanced_Tidebringer:UnlockSecondCore(key)
	-- local caster = self:GetCaster()
	-- local modifier = caster:AddNewModifier(caster,self,"modifier_Advanced_Thunderstrike_unlock2",{})
	
	return true
end
function Advanced_Tidebringer:UnlockThirdCore(key)
	-- local caster = self:GetCaster()
	-- local modifier = caster:AddNewModifier(caster,self,"modifier_Advanced_Thunderstrike_unlock2",{})
	
	return true
end



function Advanced_Tidebringer:CheckKV(key)
	local table = {

		bonus_damage =10,
		-- bonus_damage_min = 0.1,
	}
	local value = table[key] or -1
	return value

end


function Advanced_Tidebringer:CheckKVFixedOverride(key)
	if key=="cleave_damage" then
		if self:GetUnlock(3)==3 then
			return 190
		end
	end

	return -999999

end




function Advanced_Tidebringer:GetIntrinsicModifierName()	return "modifier_Advanced_Tidebringer" end
function Advanced_Tidebringer:GetCastRange(location, target)
	return self:GetCaster():Script_GetAttackRange()
end
-- function Advanced_Tidebringer:GetCooldown( nLevel )
-- 	local cooldown = self.BaseClass.GetCooldown( self, nLevel )
-- 	local caster = self:GetCaster()

-- 	if caster:HasModifier("modifier_imba_ebb_and_flow_tide_wave") or caster:HasModifier("modifier_imba_ebb_and_flow_tsunami") or (caster:HasTalent("special_bonus_imba_kunkka_2") and caster:HasModifier("modifier_imba_ghostship_rum")) then
-- 		cooldown = 0
-- 	end
-- 	return cooldown
-- end
function Advanced_Tidebringer:Unlock1Target(target,dir)
	local hCaster = self:GetCaster()
	local pos = target:GetOrigin()-dir*150
	local ghost = self:SpawnGhost(pos,dir)
end

function Advanced_Tidebringer:Unlock2Target(target,dir)
	local hCaster = self:GetCaster()
	local pos = target:GetOrigin()-dir*150
	local ghost = self:SpawnGhost(pos,dir)
end

function Advanced_Tidebringer:SpawnGhost(pos,dir)
	local hCaster = self:GetCaster()
	local illusion =	CreateUnitByName( "npc_hd_kunkka_ghost", pos, true, nil, nil, hCaster:GetTeamNumber() )
	illusion:SetOrigin(pos)
	illusion:AddNewModifier(hCaster, self, "modifier_Advanced_Tidebringer_ghost", {duration=2.5})
	illusion:AddActivityModifier("tidebringer")
	-- illusion:StartGesture(ACT_DOTA_ATTACK)
	illusion:SetForwardVector(dir)
	illusion.isThinker = true
	return illusion
end



modifier_Advanced_Tidebringer =modifier_Advanced_Tidebringer or class({})
function modifier_Advanced_Tidebringer:IsHidden()	return true end
function modifier_Advanced_Tidebringer:RemoveOnDeath()	return false end
function modifier_Advanced_Tidebringer:IsPurgable()	return false end
function modifier_Advanced_Tidebringer:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_EVENT_ON_ATTACK_START,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_EVENT_ON_DAMAGE_CALCULATED,
	}
end

function modifier_Advanced_Tidebringer:OnCreated()
	-- local caster = self:GetCaster()
	-- local ability = self:GetAbility()
	if IsServer() then
		self.damageRecord  = {}
	end
end

function modifier_Advanced_Tidebringer:OnRefresh()
	-- local caster = self:GetCaster()
	-- local ability = self:GetAbility()
	if IsServer() then

	end
end

function modifier_Advanced_Tidebringer:OnAttackStart( params )
	if IsClient() then
		return
	end
	local parent = self:GetParent()
	local target = params.target
	if (parent == params.attacker) and (target:GetTeamNumber() ~= parent:GetTeamNumber()) and (target.IsCreep or target.IsHero) then
		if not target:IsBuilding() then
			local ability = self:GetAbility()
			self.sound_triggered = false
			if ability:IsCooldownReady() and not (parent:PassivesDisabled()) then
				if ability:GetAutoCastState() then
					self.pass_attack = true
					self.bonus_damage = ability:GetSpecialValueFor("bonus_damage")
					if ability.unlock3 then
						self.bonus_damage = self.bonus_damage + parent:GetAverageTrueAttackDamage(nil)*2
					end
				else
					self.pass_attack = false
					self.bonus_damage = 0
				end
			end
		end
	end
end

function modifier_Advanced_Tidebringer:OnAttackLanded( keys )
	if IsClient() then
		return
	end
	local ability = self:GetAbility()
	local parent = self:GetParent()
	if keys.attacker == parent and self.pass_attack then
		self.pass_attack = false
		self.bonus_damage = 0

		-- If you get break during attack-swing
		if parent:PassivesDisabled() then
			return 0
		end
		local target = keys.target
		if target ~= nil and target:GetTeamNumber() ~= self:GetParent():GetTeamNumber() then

			local duration = 5
			local chance = 20
			if ability.advanced_level>=5 then
				duration = 9
				if ability.advanced_level>=10 then
					chance = 30
				end
			end
			keys.target:AddNewModifier(keys.attacker,ability, "modifier_Advanced_Tidebringer_debuff", {duration = duration})
			self.damageRecord[keys.record] = true


			
		
			if chance>=RandomInt(1, 100) then
				return
			end
			ability:UseResources(false, false, true,true)


		end
	end
	return 0
end

function modifier_Advanced_Tidebringer:GetModifierPreAttack_BonusDamage(params)
	self.bonus_damage = self.bonus_damage or 0
	return self.bonus_damage
end


function modifier_Advanced_Tidebringer:OnDamageCalculated(keys)
	if IsServer() then
		local talent4 = keys.attacker:FindAbilityByName("heroTalent_npc_dota_hero_kunkka_4")
		if talent4 then
			self:Talent4Logic(keys,talent4)
		else
			if self.damageRecord[keys.record] then
				self.damageRecord[keys.record] = nil
				local ability = self:GetAbility()
				local fDistance = ability:GetSpecialValueFor("range")
				local fStartRadius = ability:GetSpecialValueFor("start_radius")
				local fEndRadius = ability:GetSpecialValueFor("end_radius")
				local cleaveDamage = keys.damage * (ability:GetSpecialValueFor("cleave_damage") / 100)
				local damageTable = {
					attacker =  keys.attacker,
					damage = cleaveDamage,
					damage_type = DAMAGE_TYPE_PHYSICAL,
					damage_flags =  DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION + DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL, --Optional.
					ability = ability, --Optional.
				}
				-- 分裂攻击在这运算 不使用API
				local target = keys.attacker
				local pos = keys.target:GetAbsOrigin()
				local direction = GetDirection2D(pos, keys.attacker:GetAbsOrigin())
				local units = FindUnitsInTrapezoid(keys.attacker:GetTeamNumber(), direction, GetGroundPosition(target:GetAbsOrigin(), nil), fStartRadius, fEndRadius, fDistance, nil, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE, FIND_CLOSEST, false)
				local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_kunkka/kunkka_spell_tidebringer.vpcf", PATTACH_CUSTOMORIGIN, keys.attacker)
				ParticleManager:SetParticleControl(pfx, 0, keys.attacker:GetAbsOrigin())
				ParticleManager:SetParticleControlForward(pfx, 0, (pos - keys.attacker:GetAbsOrigin()):Normalized())
				local max_count = 10
				-- local count = math.min(#units,max_count)
				local effect_count = 0
				keys.attacker:EmitSound("Hero_Kunkka.Tidebringer.Attack")
				if ability.advanced_level>=15 then
					
	
					local dir = CalculateDirection(keys.target,keys.attacker)
					for i, unit in ipairs(units) do
						if unit~=keys.target then
							if i<=max_count then
								ParticleManager:SetParticleControlEnt(pfx, i + 1, unit, PATTACH_POINT, "attach_hitloc", unit:GetAbsOrigin(), true)
							else
								break
							end
							unit:AddNewModifier(keys.attacker,ability, "modifier_Advanced_Tidebringer_debuff", {duration = 9})
							unit:EmitSound("Hero_Kunkaa.Tidebringer")
							damageTable.victim = unit
							ApplyDamage(damageTable)
							effect_count = effect_count + 1
							if ability.unlock1 and unit:IsAlive() then
								Timers:CreateTimer(RandomFloat(0.03, 0.5), function()
									if ability and not ability:IsNull() and not unit:IsNull() and unit:IsAlive() then
										ability:Unlock1Target(unit,dir)
										Timers:CreateTimer(0.4, function()
											if ability and not ability:IsNull() and not unit:IsNull() and unit:IsAlive() then
												self:PlaySingleTidebringerEffect(keys.attacker,unit,cleaveDamage*1.8)
												-- damageTable.victim =unit
												-- ApplyDamage(damageTable)
											end
										end)
									end
			
		
								end)
							end
							
						end
					end
					if ability.advanced_level>=20 and effect_count<=2 and not keys.target:IsNull() and keys.target:IsAlive() then
						if ability.unlock2 then
	
							keys.target:EmitSound("Hero_Kunkaa.Tidebringer")
							ParticleManager:SetParticleControl(pfx, 1, Vector(0,0,effect_count+1))
							if keys.target:IsAlive() then
								local targetPos = keys.target:GetOrigin()
								local pos = targetPos - dir*150
								for i = 1, 5, 1 do
									local new_pos = RotatePosition(targetPos, QAngle(0, -72*i, 0), pos)
									local new_dir = CalculateDirection(targetPos,new_pos)
									Timers:CreateTimer(RandomFloat(0.03, 0.3), function()
										if ability and not ability:IsNull() and not keys.target:IsNull() and keys.target:IsAlive() then
											ability:Unlock1Target(keys.target,new_dir)
											Timers:CreateTimer(0.4, function()
												if ability and not ability:IsNull() and not keys.target:IsNull() and keys.target:IsAlive() then
													keys.target:AddNewModifier(keys.attacker,ability, "modifier_Advanced_Tidebringer_debuff", {duration = 9})
													self:PlaySingleTidebringerEffect(keys.attacker,keys.target,cleaveDamage)
												end
											end)
										end
									end)
								end
								
							end
						else
							damageTable.victim = keys.target
							ApplyDamage(damageTable)
							keys.target:EmitSound("Hero_Kunkaa.Tidebringer")
							ParticleManager:SetParticleControl(pfx, 1, Vector(0,0,effect_count+2))
							ParticleManager:SetParticleControlEnt(pfx, effect_count + 3,  keys.target, PATTACH_POINT, "attach_hitloc",  keys.target:GetAbsOrigin(), true)
							if ability.unlock1 and keys.target:IsAlive() then
								
								Timers:CreateTimer(RandomFloat(0.03, 0.5), function()
									if ability and not ability:IsNull() and not keys.target:IsNull() and keys.target:IsAlive() then
										ability:Unlock1Target(keys.target,dir)
										Timers:CreateTimer(0.4, function()
											if ability and not ability:IsNull() and not keys.target:IsNull() and keys.target:IsAlive() then
												self:PlaySingleTidebringerEffect(keys.attacker,keys.target,cleaveDamage*1.8)
		
											end
										end)
									end
			
		
								end)
							end
						end
		
					else
						ParticleManager:SetParticleControl(pfx, 1, Vector(0,0,effect_count+1))
					end
				else
					for i, unit in ipairs(units) do
						if unit~=keys.target then
							if i<=max_count then
								ParticleManager:SetParticleControlEnt(pfx, i + 1, unit, PATTACH_POINT, "attach_hitloc", unit:GetAbsOrigin(), true)
							else
								break
							end
							unit:EmitSound("Hero_Kunkaa.Tidebringer")
							damageTable.victim = unit
							ApplyDamage(damageTable)
							effect_count = effect_count + 1
							
							
						end
					end
					ParticleManager:SetParticleControl(pfx, 1, Vector(0,0,effect_count+1))
				end
	
				local ability = keys.attacker:FindAbilityByName("heroTalent_npc_dota_hero_kunkka_3")
				if ability then
					ability:Trigger(cleaveDamage,pos)
				end
				
	
				DestroyParticleByDelay(pfx,2)
			end

		end

	end
end

function modifier_Advanced_Tidebringer:PlaySingleTidebringerEffect(caster,unit,damage)
	unit:EmitSound("Hero_Kunkaa.Tidebringer")
	local pfx = ParticleManager:CreateParticle("particles/rebuild/spell/tidebringer/single_tidebringer_hit.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(pfx, 0, caster:GetAbsOrigin())
	ParticleManager:SetParticleControlForward(pfx, 0, (unit:GetAbsOrigin() - caster:GetAbsOrigin()):Normalized())
	ParticleManager:SetParticleControl(pfx, 1, Vector(0,0,1))
	ParticleManager:SetParticleControlEnt(pfx, 2,  unit, PATTACH_POINT, "attach_hitloc",  unit:GetAbsOrigin(), true)
	DestroyParticleByDelay(pfx,2)

	local damageTable = {
		attacker =  caster,
		victim = unit,
		damage = damage,
		damage_type = DAMAGE_TYPE_PHYSICAL,
		damage_flags =  DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION + DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL, --Optional.
		ability = self:GetAbility(), --Optional.
	}
	ApplyDamage(damageTable)
end


function modifier_Advanced_Tidebringer:Talent4Logic(keys,talent4)
	if self.damageRecord[keys.record] then
		local chance =  talent4:GetSpecialValueFor("chance")
		self.damageRecord[keys.record] = nil
		local ability = self:GetAbility()
		local fDistance = ability:GetSpecialValueFor("range")
		local fStartRadius = ability:GetSpecialValueFor("start_radius")
		local fEndRadius = ability:GetSpecialValueFor("end_radius")
		local cleaveDamage = keys.damage * (ability:GetSpecialValueFor("cleave_damage") / 100) + keys.attacker:GetAverageTrueAttackDamage(nil)* talent4:GetSpecialValueFor("attack_index")*0.01
		local damageTable = {
			attacker =  keys.attacker,
			damage = cleaveDamage,
			damage_type = DAMAGE_TYPE_PURE,
			damage_flags =  DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION + DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL, --Optional.
			ability = ability, --Optional.
		}
		-- 分裂攻击在这运算 不使用API
		local target = keys.attacker
		local pos = keys.target:GetAbsOrigin()
		local direction = GetDirection2D(pos, keys.attacker:GetAbsOrigin())
		local units = FindUnitsInTrapezoid(keys.attacker:GetTeamNumber(), direction, GetGroundPosition(target:GetAbsOrigin(), nil), fStartRadius, fEndRadius, fDistance, nil, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE, FIND_CLOSEST, false)
		local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_kunkka/kunkka_spell_tidebringer.vpcf", PATTACH_CUSTOMORIGIN, keys.attacker)
		ParticleManager:SetParticleControl(pfx, 0, keys.attacker:GetAbsOrigin())
		ParticleManager:SetParticleControlForward(pfx, 0, (pos - keys.attacker:GetAbsOrigin()):Normalized())
		local max_count = 10
		-- local count = math.min(#units,max_count)
		local effect_count = 0
		keys.attacker:EmitSound("Hero_Kunkka.Tidebringer.Attack")
		if ability.advanced_level>=15 then
			

			local dir = CalculateDirection(keys.target,keys.attacker)
			for i, unit in ipairs(units) do
				if unit~=keys.target then
					if i<=max_count then
						ParticleManager:SetParticleControlEnt(pfx, i + 1, unit, PATTACH_POINT, "attach_hitloc", unit:GetAbsOrigin(), true)
					end
					unit:AddNewModifier(keys.attacker,ability, "modifier_Advanced_Tidebringer_debuff", {duration = 9})
					unit:EmitSound("Hero_Kunkaa.Tidebringer")
					damageTable.victim = unit
					ApplyDamage(damageTable)
					effect_count = effect_count + 1
					
					if IsValid(unit) and unit:IsAlive() and chance>=RandomInt(1, 100) then
						talent4:Trigger(damageTable)
					end
					if ability.unlock1 and unit:IsAlive() then
						Timers:CreateTimer(RandomFloat(0.03, 0.5), function()
							if ability and not ability:IsNull() and not unit:IsNull() and unit:IsAlive() then
								ability:Unlock1Target(unit,dir)
								Timers:CreateTimer(0.4, function()
									if ability and not ability:IsNull() and not unit:IsNull() and unit:IsAlive() then
										self:PlaySingleTidebringerEffect(keys.attacker,unit,cleaveDamage*1.8)
										-- damageTable.victim =unit
										-- ApplyDamage(damageTable)
									end
								end)
							end
	

						end)
					end
					
					
				end
			end
			if ability.advanced_level>=20 and effect_count<=2 and not keys.target:IsNull() and keys.target:IsAlive() then
				if ability.unlock2 then

					keys.target:EmitSound("Hero_Kunkaa.Tidebringer")
					ParticleManager:SetParticleControl(pfx, 1, Vector(0,0,effect_count+1))
					if keys.target:IsAlive() then
						local targetPos = keys.target:GetOrigin()
						local pos = targetPos - dir*150
						for i = 1, 5, 1 do
							local new_pos = RotatePosition(targetPos, QAngle(0, -72*i, 0), pos)
							local new_dir = CalculateDirection(targetPos,new_pos)
							Timers:CreateTimer(RandomFloat(0.03, 0.3), function()
								if ability and not ability:IsNull() and not keys.target:IsNull() and keys.target:IsAlive() then
									ability:Unlock1Target(keys.target,new_dir)
									Timers:CreateTimer(0.4, function()
										if ability and not ability:IsNull() and not keys.target:IsNull() and keys.target:IsAlive() then
											keys.target:AddNewModifier(keys.attacker,ability, "modifier_Advanced_Tidebringer_debuff", {duration = 9})
											self:PlaySingleTidebringerEffect(keys.attacker,keys.target,cleaveDamage)
										end
									end)
								end
							end)
						end
						
					end
				else
					damageTable.victim = keys.target
					ApplyDamage(damageTable)
					keys.target:EmitSound("Hero_Kunkaa.Tidebringer")
					ParticleManager:SetParticleControl(pfx, 1, Vector(0,0,effect_count+2))
					ParticleManager:SetParticleControlEnt(pfx, effect_count + 3,  keys.target, PATTACH_POINT, "attach_hitloc",  keys.target:GetAbsOrigin(), true)
					if ability.unlock1 and keys.target:IsAlive() then
						
						Timers:CreateTimer(RandomFloat(0.03, 0.5), function()
							if ability and not ability:IsNull() and not keys.target:IsNull() and keys.target:IsAlive() then
								ability:Unlock1Target(keys.target,dir)
								Timers:CreateTimer(0.4, function()
									if ability and not ability:IsNull() and not keys.target:IsNull() and keys.target:IsAlive() then
										self:PlaySingleTidebringerEffect(keys.attacker,keys.target,cleaveDamage*1.8)

									end
								end)
							end
	

						end)
					end
				end

			else
				ParticleManager:SetParticleControl(pfx, 1, Vector(0,0,math.min(effect_count+1,max_count)))
			end
		else
			for i, unit in ipairs(units) do
				if unit~=keys.target then
					if i<=max_count then
						ParticleManager:SetParticleControlEnt(pfx, i + 1, unit, PATTACH_POINT, "attach_hitloc", unit:GetAbsOrigin(), true)
					end
					unit:EmitSound("Hero_Kunkaa.Tidebringer")
					damageTable.victim = unit
					ApplyDamage(damageTable)
					effect_count = effect_count + 1
					
					if IsValid(unit) and unit:IsAlive() and chance>=RandomInt(1, 100) then
						talent4:Trigger(damageTable)
					end
					
					
				end
			end
			ParticleManager:SetParticleControl(pfx, 1, Vector(0,0,math.min(effect_count+1,max_count)))
		end

		local ability = keys.attacker:FindAbilityByName("heroTalent_npc_dota_hero_kunkka_3")
		if ability then
			ability:Trigger(cleaveDamage,pos)
		end
		

		DestroyParticleByDelay(pfx,2)
	end
end


modifier_Advanced_Tidebringer_debuff = modifier_Advanced_Tidebringer_debuff or advanced_modifier({})

function modifier_Advanced_Tidebringer_debuff:IsDebuff() return true end
function modifier_Advanced_Tidebringer_debuff:IsHidden() return false end
function modifier_Advanced_Tidebringer_debuff:IsPurgable() return false end
-- function modifier_Advanced_Tidebringer_debuff:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_Advanced_Tidebringer_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP,             --护甲
	}
end


function modifier_Advanced_Tidebringer_debuff:OnCreated(params)
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
function modifier_Advanced_Tidebringer_debuff:OnRefresh(params)
	if IsServer() then
		local dieTime = self:GetDieTime()
		table.insert(self.tData, {dieTime = dieTime })
		self:IncrementStackCount()
	end
end

function modifier_Advanced_Tidebringer_debuff:OnIntervalThink()
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


function modifier_Advanced_Tidebringer_debuff:OnTooltip()
    return self:Advanced_GetModifierPhysicalArmorBonus()
end

-- advanced_modifier

function modifier_Advanced_Tidebringer_debuff:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }
end
function modifier_Advanced_Tidebringer_debuff:Advanced_GetModifierPhysicalArmorBonus()
    return -6*self:GetStackCount()
end





modifier_Advanced_Tidebringer_ghost = modifier_Advanced_Tidebringer_ghost or class({})
function modifier_Advanced_Tidebringer_ghost:IsHidden()	return true end
function modifier_Advanced_Tidebringer_ghost:IsDebuff()	return false end
function modifier_Advanced_Tidebringer_ghost:IsPurgable()	return false end
function modifier_Advanced_Tidebringer_ghost:IsPurgeException()	return false end
function modifier_Advanced_Tidebringer_ghost:IsStunDebuff()	return false end
function modifier_Advanced_Tidebringer_ghost:AllowIllusionDuplicate()	return false end
function modifier_Advanced_Tidebringer_ghost:OnCreated(params)
	if IsServer() then
		self.state = 0
		local parent = self:GetParent()
		parent:SetModelScale(0.9)
		-- local model = parent:FirstMoveChild()
		self.current_pos = self:GetParent():GetOrigin()
		self:StartIntervalThink(0.03)
	end
end

function modifier_Advanced_Tidebringer_ghost:OnIntervalThink()
	if self.state==0 then
		local parent = self:GetParent()
		parent:StartGestureWithPlaybackRate(ACT_DOTA_ATTACK, 1.5)
		self.state = 1
		self:StartIntervalThink(1)
		return
	end
	if self.state==1 then
		local parent = self:GetParent()
		-- illusion:StartGestureWithPlaybackRate(ACT_DOTA_ATTACK, 5)
		parent:AddActivityModifier("Espada_pistola")
		parent:StartGesture(ACT_DOTA_ATTACK_STATUE)
		-- parent:SetOrigin(parent:GetOrigin()-self.forward*10 + Vector(0,0,-3))
		self.state =2
		self:StartIntervalThink(0.7)
		local pfx = ParticleManager:CreateParticle("particles/econ/items/kunkka/kunkka_weapon_whaleblade_retro/kunkka_spell_torrent_retro_whaleblade_wave.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(pfx, 0, self.current_pos-self:GetParent():GetForwardVector()*100)
		DestroyParticleByDelay(pfx,4)
		return
	end
	if self.state==2 then
		self:StartIntervalThink(0.01)
		local parent = self:GetParent()
		parent:SetOrigin(parent:GetOrigin()+Vector(0,0,-30))
		return
	end

end


function modifier_Advanced_Tidebringer_ghost:OnDestroy()
	if IsServer() then
		-- self:GetParent():ForceKill(false)




		
		UTIL_Remove( self:GetParent() )
	end
end
function modifier_Advanced_Tidebringer_ghost:CheckState()
	return {
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
		[MODIFIER_STATE_OUT_OF_GAME] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true,
		[MODIFIER_STATE_DISARMED] = true,
	}
end


-- modifier_Advanced_Tidebringer_debuff