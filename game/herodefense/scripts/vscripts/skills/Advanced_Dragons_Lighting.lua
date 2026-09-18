--特效优化 √
LinkLuaModifier("modifier_Advanced_Dragons_Lighting_debuff", "skills/Advanced_Dragons_Lighting", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Dragons_Lighting_unlock3", "skills/Advanced_Dragons_Lighting", LUA_MODIFIER_MOTION_NONE)
Advanced_Dragons_Lighting			= Advanced_Dragons_Lighting or class({})


function Advanced_Dragons_Lighting:CheckKV(key)
	local table = {

		damage =30,
		bonus_damage = 0.3,
		bonus_dis_damage = 0.01,

	}
	local value = table[key] or -1
	return value

end



function Advanced_Dragons_Lighting:UnlockFirstCore(key)
	return true
end
function Advanced_Dragons_Lighting:UnlockSecondCore(key)
	return true
end
function Advanced_Dragons_Lighting:UnlockThirdCore(key)
	local caster = self:GetCaster()
	caster:AddNewModifier(caster,self,"modifier_Advanced_Dragons_Lighting_unlock3",{})
	return true
end
function Advanced_Dragons_Lighting:GetCooldown(iLevel)
	if self:GetUnlock(2)==2 then
		return self.BaseClass.GetCooldown(self,  iLevel)*0.5
	end
	return self.BaseClass.GetCooldown(self,  iLevel)
end
-- function Advanced_Dragons_Lighting:GetCastRange(location, target)
-- 	return self.BaseClass.GetCastRange(self, location, target)
-- end
require('internal/timers')   --计时器功能
function Advanced_Dragons_Lighting:OnSpellStart()
	local target = self:GetCursorTarget()
	local caster = self:GetCaster()
	caster:EmitSound("Hero_Zuus.ArcLightning.Cast")
	local damage = self:GetSpecialValueFor("damage")+(self:GetSpecialValueFor("bonus_damage"))*caster:GetIntellect(false)
	
	if not target:TriggerSpellAbsorb(self) then
		if self.unlock1 then
			local heigh = math.max(500*math.sqrt(caster:GetIntellect(false)),self.BaseClass.GetCastRange(self, caster:GetOrigin(), target)) + caster:GetCastRangeBonus()
			heigh = math.max(heigh,100)
			local caster_pos = caster:GetAbsOrigin()
			local need_dis = 35
			local count = heigh/need_dis
			count =count - count%1
			count = math.min(math.max(count-6,1),200)
			-- local interval = 0.04
			local interval = 5/count
			target:AddNewModifier(caster, self, "modifier_Advanced_Dragons_Lighting_debuff", {duration = 5 ,stack = count})
			local target_pos = target:GetOrigin() + Vector(0,0,heigh)
			-- 目标头顶
			local npc_attack_unit = CreateUnitByName("npc_attack_unit", target_pos, true, caster, caster, caster:GetTeamNumber())
			npc_attack_unit:AddNewModifier(nil, nil, "modifier_phased", {duration =0.8})
			npc_attack_unit:AddNewModifier(nil, nil, "modifier_invulnerable", {duration =0.8})
			npc_attack_unit:SetOrigin(target_pos)
			npc_attack_unit:AddNoDraw()
			Timers:CreateTimer(0.5, function()
				UTIL_Remove(npc_attack_unit)
			end)
			local head_particle = ParticleManager:CreateParticle("particles/rebuild/spell/dragons_lightning/dragons_lightning_lightning_head.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
			ParticleManager:SetParticleControlEnt(head_particle, 0, npc_attack_unit, PATTACH_POINT_FOLLOW, nil, npc_attack_unit:GetAbsOrigin(), true)
			ParticleManager:SetParticleControlEnt(head_particle, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
			ParticleManager:SetParticleControl(head_particle, 61, Vector(count*interval/0.25, 7, 0))
			ParticleManager:ReleaseParticleIndex(head_particle)
			local damageTable = {
				victim = target,
				attacker = caster,
				damage = damage,
				damage_type = self:GetAbilityDamageType(),
				damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
				ability = self, --Optional.
				hd_flags = HD_DAMAGE_FLAG_LIGHTING_DAMAGE,
			}
			ApplyDamage(damageTable)


		
		

			damageTable.damage = (self:GetSpecialValueFor("bonus_dis_damage"))*caster:GetIntellect(false)*3
			local norm = (target:GetAbsOrigin() - target_pos):Normalized()
			for i = 1, count, 1 do
			
				Timers:CreateTimer(i*interval, function()
					if (i-1)%3==0 then
						ApplyDamage(damageTable)
					end
					local time = self:GetCooldownTimeRemaining()
	
					self:EndCooldown()
					self:StartCooldown(time*0.99)
					local target_point = target_pos + norm * i*need_dis
					target_point.z = target_point.z +300
					target_point.x = target_point.x + RandomInt(-200, 200)
					target_point.y = target_point.y + RandomInt(-200, 200)
					local head_particle = ParticleManager:CreateParticle("particles/rebuild/spell/dragons_lightning/dragons_lightning_lightning_head.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
					
					local unit = CreateUnitByName("npc_attack_unit", target_point, true, caster, caster, caster:GetTeamNumber())
					unit:AddNewModifier(nil, nil, "modifier_phased", {duration =0.8})
					unit:AddNewModifier(nil, nil, "modifier_invulnerable", {duration = 0.8})
					unit:SetOrigin(target_point)
					unit:AddNoDraw()
					Timers:CreateTimer(0.5, function()
						UTIL_Remove(unit)
				
					end)
	
					ParticleManager:SetParticleControlEnt(head_particle, 0, unit, PATTACH_POINT_FOLLOW, nil, unit:GetAbsOrigin(), true)
					-- ParticleManager:SetParticleControl(head_particle, 0, target_point)
					ParticleManager:SetParticleControlEnt(head_particle, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
					ParticleManager:SetParticleControl(head_particle, 61, Vector(1, 1, 0))
					ParticleManager:ReleaseParticleIndex(head_particle)
					target:EmitSound("Hero_Zuus.ArcLightning.Cast")
	
					local head_particle = ParticleManager:CreateParticle("particles/rebuild/spell/dragons_lightning/dragons_lightning_lightning_head.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
					ParticleManager:SetParticleControlEnt(head_particle, 0, unit, PATTACH_POINT_FOLLOW, nil, unit:GetAbsOrigin(), true)
					-- ParticleManager:SetParticleControl(head_particle, 0, target_point)
					ParticleManager:SetParticleControlEnt(head_particle, 1, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
					ParticleManager:SetParticleControl(head_particle, 61, Vector(1, 1, 0))
					ParticleManager:ReleaseParticleIndex(head_particle)
					

					if i==count and not target:IsNull() then
						local radius = 2000+caster:GetCastRangeBonus()
						local units = FindUnitsInRadius(caster:GetTeamNumber(),target:GetAbsOrigin(), nil, math.max(radius,100), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_ANY_ORDER, false)
						local effect_count = 0
			
						for _, enemy in pairs(units) do
							if enemy~=target then
								local head_particle = ParticleManager:CreateParticle("particles/rebuild/spell/dragons_lightning/dragons_lightning_lightning_head.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
								ParticleManager:SetParticleControlEnt(head_particle, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
								ParticleManager:SetParticleControlEnt(head_particle, 1, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin(), true)
								ParticleManager:SetParticleControl(head_particle, 61, Vector(3, 7, 0))
								ParticleManager:ReleaseParticleIndex(head_particle)
								local damageTable2 = {
									victim = enemy,
									attacker = caster,
									damage = damage*10,
									damage_type = self:GetAbilityDamageType(),
									damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
									ability = self, --Optional.
									hd_flags = HD_DAMAGE_FLAG_LIGHTING_DAMAGE,
								}
								ApplyDamage(damageTable2)
								effect_count = effect_count + 1
								if effect_count>=8 then
									break
								end
							
							end
			
						end
					end
	
		

					
				end)
			end

		-- 本身的效果
		else
			local caster_pos = caster:GetAbsOrigin()
			local norm = (target:GetAbsOrigin() - caster_pos):Normalized()
			local dis= GetDistanceBetweenTwoUnit(caster,target)
			local need_dis = 50
			local bonus_count = 1
			if self.advanced_level>=5 then
				bonus_count = 2
				if self.advanced_level>=15 then
					need_dis = 35
				end
			end
			local count = dis/need_dis
			count =count - count%1
			count = math.min(math.max(count-6,1),60)
			local interval = 0.04
			local buff = target:AddNewModifier(caster, self, "modifier_Advanced_Dragons_Lighting_debuff", {duration = 5 ,stack = count})
			local head_particle = ParticleManager:CreateParticle("particles/rebuild/spell/dragons_lightning/dragons_lightning_lightning_head.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
			ParticleManager:SetParticleControlEnt(head_particle, 0, caster, PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetAbsOrigin(), true)
			ParticleManager:SetParticleControlEnt(head_particle, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
			ParticleManager:SetParticleControl(head_particle, 61, Vector(count*interval/0.25, 7, 0))
			ParticleManager:ReleaseParticleIndex(head_particle)
			local damageTable = {
				victim = target,
				attacker = caster,
				damage = damage,
				damage_type = self:GetAbilityDamageType(),
				damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
				ability = self, --Optional.
				hd_flags = HD_DAMAGE_FLAG_LIGHTING_DAMAGE,
			}
			ApplyDamage(damageTable)
			local units = FindUnitsInRadius(caster:GetTeamNumber(),target:GetAbsOrigin(), nil, 2000+caster:GetCastRangeBonus(), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_FARTHEST, false)
			local i = 0
			for _, enemy in pairs(units) do
				if enemy~=target then
					local head_particle = ParticleManager:CreateParticle("particles/rebuild/spell/dragons_lightning/dragons_lightning_lightning_head.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
					ParticleManager:SetParticleControlEnt(head_particle, 0, target, PATTACH_POINT_FOLLOW, "attach_attack1", target:GetAbsOrigin(), true)
					ParticleManager:SetParticleControlEnt(head_particle, 1, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin(), true)
					ParticleManager:SetParticleControl(head_particle, 61, Vector(3, 7, 0))
					ParticleManager:ReleaseParticleIndex(head_particle)
					local damageTable2 = {
						victim = enemy,
						attacker = caster,
						damage = damage,
						damage_type = self:GetAbilityDamageType(),
						damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
						ability = self, --Optional.
						hd_flags = HD_DAMAGE_FLAG_LIGHTING_DAMAGE,
					}
					ApplyDamage(damageTable2)
					i = i+1
					if i>=bonus_count then
						break
					end
				
				end

			end
			

			damageTable.damage = (self:GetSpecialValueFor("bonus_dis_damage"))*caster:GetIntellect(false)*3
			if self.unlock2 then
				damageTable.damage = damageTable.damage * 3
			end

			local index = 0.99
			if self.unlock3 then
				index = 0.98
			end

			if self.advanced_level>=20 then
				for i = 1, count, 1 do

					Timers:CreateTimer(i*interval, function()
	
		
						local time = self:GetCooldownTimeRemaining()
						self:EndCooldown()
						self:StartCooldown(time*index)
						local target_point = caster_pos + norm * i*need_dis
						target_point.z = target_point.z +300
						target_point.x = target_point.x + RandomInt(-200, 200)
						target_point.y = target_point.y + RandomInt(-200, 200)
						local head_particle = ParticleManager:CreateParticle("particles/rebuild/spell/dragons_lightning/dragons_lightning_lightning_head.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
						
						local unit = CreateUnitByName("npc_attack_unit", target_point, true, caster, caster, caster:GetTeamNumber())
						unit:AddNewModifier(nil, nil, "modifier_phased", {duration =0.8})
						unit:AddNewModifier(nil, nil, "modifier_invulnerable", {duration = 0.8})
						unit:SetOrigin(target_point)
						unit:AddNoDraw()
						Timers:CreateTimer(0.5, function()
							UTIL_Remove(unit)
					
						end)
		
						ParticleManager:SetParticleControlEnt(head_particle, 0, unit, PATTACH_POINT_FOLLOW, nil, unit:GetAbsOrigin(), true)
						-- ParticleManager:SetParticleControl(head_particle, 0, target_point)
						ParticleManager:SetParticleControlEnt(head_particle, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
						ParticleManager:SetParticleControl(head_particle, 61, Vector(1, 1, 0))
						ParticleManager:ReleaseParticleIndex(head_particle)
						target:EmitSound("Hero_Zuus.ArcLightning.Cast")
		
						local head_particle = ParticleManager:CreateParticle("particles/rebuild/spell/dragons_lightning/dragons_lightning_lightning_head.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
						ParticleManager:SetParticleControlEnt(head_particle, 0, unit, PATTACH_POINT_FOLLOW, nil, unit:GetAbsOrigin(), true)
						-- ParticleManager:SetParticleControl(head_particle, 0, target_point)
						ParticleManager:SetParticleControlEnt(head_particle, 1, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
						ParticleManager:SetParticleControl(head_particle, 61, Vector(1, 1, 0))
						ParticleManager:ReleaseParticleIndex(head_particle)


						if (i-1)%3==0 then
							ApplyDamage(damageTable)
							if self.unlock2 then
								local units = FindUnitsInRadius(caster:GetTeamNumber(),target:GetAbsOrigin(), nil, 500, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_ANY_ORDER, false)
								local i = 0
								for _, enemy in pairs(units) do
									if enemy~=target then
										local head_particle = ParticleManager:CreateParticle("particles/rebuild/spell/dragons_lightning/dragons_lightning_lightning_head.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
				
										ParticleManager:SetParticleControlEnt(head_particle, 0, unit, PATTACH_POINT_FOLLOW, nil, unit:GetAbsOrigin(), true)
										-- ParticleManager:SetParticleControl(head_particle, 0, target_point)
										ParticleManager:SetParticleControlEnt(head_particle, 1, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin(), true)
										ParticleManager:SetParticleControl(head_particle, 61, Vector(1, 1, 0))
										ParticleManager:ReleaseParticleIndex(head_particle)
										damageTable.victim = enemy
										ApplyDamage(damageTable)
										i = i+1
										if i>=3 then
											break
										end
									
									end
					
								end
								damageTable.victim = target
								
							end
							
						end
					end)
				end

			else
				for i = 1, count, 1 do

					Timers:CreateTimer(i*interval, function()
						if (i-1)%3==0 then
							ApplyDamage(damageTable)
						end
		
		
						local target_point = caster_pos + norm * i*need_dis
						target_point.z = target_point.z +300
						target_point.x = target_point.x + RandomInt(-200, 200)
						target_point.y = target_point.y + RandomInt(-200, 200)
						local head_particle = ParticleManager:CreateParticle("particles/rebuild/spell/dragons_lightning/dragons_lightning_lightning_head.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
						
						local unit = CreateUnitByName("npc_attack_unit", target_point, true, caster, caster, caster:GetTeamNumber())
						unit:AddNewModifier(nil, nil, "modifier_phased", {duration =0.8})
						unit:AddNewModifier(nil, nil, "modifier_invulnerable", {duration = 0.8})
						unit:SetOrigin(target_point)
						unit:AddNoDraw()
						Timers:CreateTimer(0.5, function()
							UTIL_Remove(unit)
					
						end)
		
						ParticleManager:SetParticleControlEnt(head_particle, 0, unit, PATTACH_POINT_FOLLOW, nil, unit:GetAbsOrigin(), true)
						-- ParticleManager:SetParticleControl(head_particle, 0, target_point)
						ParticleManager:SetParticleControlEnt(head_particle, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
						ParticleManager:SetParticleControl(head_particle, 61, Vector(1, 1, 0))
						ParticleManager:ReleaseParticleIndex(head_particle)
						target:EmitSound("Hero_Zuus.ArcLightning.Cast")
					end)
					
				end
			end

		end
		


	end
end


modifier_Advanced_Dragons_Lighting_debuff = class({})

function modifier_Advanced_Dragons_Lighting_debuff:IsDebuff()			return true end
function modifier_Advanced_Dragons_Lighting_debuff:IsHidden() 			return false end
function modifier_Advanced_Dragons_Lighting_debuff:IsPurgable() 		return true end
function modifier_Advanced_Dragons_Lighting_debuff:IsPurgeException() 	return true end
function modifier_Advanced_Dragons_Lighting_debuff:DeclareFunctions() return {MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS} end
function modifier_Advanced_Dragons_Lighting_debuff:OnCreated(keys)
	--该技能需要从网表拿等级数据 自定义变量拿不到该值
	local NetTable_key = tostring(self:GetCaster():GetPlayerOwnerID()).."_"..self:GetAbility():GetAbilityName()
	self.advanced_level = CustomNetTables:GetTableValue( "playerSpellLevelInfo", NetTable_key).level
	
	self.index = 1
	if self.advanced_level>=10 then
		self.index = 1.35
	end
	if IsServer() then
		self:SetStackCount(math.min(keys.stack,50))
	end
end
function modifier_Advanced_Dragons_Lighting_debuff:GetModifierMagicalResistanceBonus() return -self:GetStackCount()*self.index end




modifier_Advanced_Dragons_Lighting_unlock3 = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_Advanced_Dragons_Lighting_unlock3:IsHidden()	return true end
function modifier_Advanced_Dragons_Lighting_unlock3:IsDebuff()	return false end
function modifier_Advanced_Dragons_Lighting_unlock3:IsPurgable() 		return false end
function modifier_Advanced_Dragons_Lighting_unlock3:IsPurgeException() 	return false end
function modifier_Advanced_Dragons_Lighting_unlock3:RemoveOnDeath()  return false end
function modifier_Advanced_Dragons_Lighting_unlock3:DestroyOnExpire()	return false end
function modifier_Advanced_Dragons_Lighting_unlock3:OnCreated()
	if IsServer() then
		self:StartIntervalThink(2)
	end
end
function modifier_Advanced_Dragons_Lighting_unlock3:OnIntervalThink()
	local parent = self:GetParent()
	local pos = parent:GetOrigin()
	local units = FindUnitsInRadius(parent:GetTeamNumber(),parent:GetAbsOrigin(), nil, 2000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_ANY_ORDER, false)
	local effect_count = 0
	local ability = self:GetAbility()
	local damageTable = {
		-- victim = enemy,
		attacker = parent,
		damage = parent:GetMaxMana()*0.4,
		damage_type = ability:GetAbilityDamageType(),
		damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
		ability = ability, --Optional.
		hd_flags = HD_DAMAGE_FLAG_LIGHTING_DAMAGE,
	}
	local time = ability:GetCooldownTimeRemaining()
	for _, enemy in pairs(units) do
		local target_point = pos + Vector(RandomInt(-2000, 2000),RandomInt(-2000, 2000),5000)
		local head_particle = ParticleManager:CreateParticle("particles/rebuild/spell/dragons_lightning/dragons_lightning_lightning_head.vpcf", PATTACH_ABSORIGIN_FOLLOW, parent)
		local unit = CreateUnitByName("npc_attack_unit", target_point, true, parent, parent, parent:GetTeamNumber())
		unit:AddNewModifier(nil, nil, "modifier_phased", {duration =0.8})
		unit:AddNewModifier(nil, nil, "modifier_invulnerable", {duration = 0.8})
		unit:SetOrigin(target_point)
		unit:AddNoDraw()
		Timers:CreateTimer(0.5, function()
			UTIL_Remove(unit)
		end)


		ParticleManager:SetParticleControlEnt(head_particle, 0, unit, PATTACH_POINT_FOLLOW, nil, unit:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(head_particle, 1, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin(), true)
		ParticleManager:SetParticleControl(head_particle, 61, Vector(1, 1, 0))
		ParticleManager:ReleaseParticleIndex(head_particle)
		damageTable.victim = enemy
		ApplyDamage(damageTable)
	
		local head_particle = ParticleManager:CreateParticle("particles/rebuild/spell/dragons_lightning/dragons_lightning_lightning_head.vpcf", PATTACH_ABSORIGIN_FOLLOW, parent)
		ParticleManager:SetParticleControlEnt(head_particle, 0, unit, PATTACH_POINT_FOLLOW, nil, unit:GetAbsOrigin(), true)
		-- ParticleManager:SetParticleControl(head_particle, 0, target_point)
		ParticleManager:SetParticleControlEnt(head_particle, 1, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true)
		ParticleManager:SetParticleControl(head_particle, 61, Vector(1, 1, 0))
		ParticleManager:ReleaseParticleIndex(head_particle)
		effect_count = effect_count + 1
		time =  time*0.98

		if effect_count>=10 then
			break
		end

	end
	if effect_count>=1 then
		ability:EndCooldown()
		ability:StartCooldown(time)
		parent:EmitSound("Hero_Zuus.ArcLightning.Cast")
	end
	


end