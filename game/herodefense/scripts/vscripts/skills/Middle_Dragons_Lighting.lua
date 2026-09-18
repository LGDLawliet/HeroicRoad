
LinkLuaModifier("modifier_Middle_Dragons_Lighting", "skills/Middle_Dragons_Lighting", LUA_MODIFIER_MOTION_NONE)

Middle_Dragons_Lighting			= Middle_Dragons_Lighting or class({})


-- function Middle_Dragons_Lighting:GetCastRange(location, target)
-- 	return self.BaseClass.GetCastRange(self, location, target)
-- end
require('internal/timers')   --计时器功能
function Middle_Dragons_Lighting:OnSpellStart()
	local target = self:GetCursorTarget()
	local caster = self:GetCaster()
	caster:EmitSound("Hero_Zuus.ArcLightning.Cast")
	
	if not target:TriggerSpellAbsorb(self) then
		local caster_pos = caster:GetAbsOrigin()
		local norm = (target:GetAbsOrigin() - caster_pos):Normalized()
		local dis= GetDistanceBetweenTwoUnit(caster,target)
		local need_dis = 50
		local count = dis/need_dis
		count =count - count%1
		count = math.max(count-6,1)
		count = math.min(math.max(count-6,1),60)
		local interval = 0.04
		local head_particle = ParticleManager:CreateParticle("particles/rebuild/spell/dragons_lightning/dragons_lightning_lightning_head.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
		ParticleManager:SetParticleControlEnt(head_particle, 0, caster, PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(head_particle, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
		ParticleManager:SetParticleControl(head_particle, 61, Vector(count*interval/0.25, 7, 0))
		ParticleManager:ReleaseParticleIndex(head_particle)
		local damageTable = {
			victim = target,
			attacker = caster,
			damage = self:GetSpecialValueFor("damage")+self:GetSpecialValueFor("bonus_damage")*caster:GetIntellect(false),
			damage_type = self:GetAbilityDamageType(),
			damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
			ability = self, --Optional.
			hd_flags = HD_DAMAGE_FLAG_LIGHTING_DAMAGE,
		}
		ApplyDamage(damageTable)
		local units = FindUnitsInRadius(caster:GetTeamNumber(),target:GetAbsOrigin(), nil, math.max(2000+caster:GetCastRangeBonus(),100), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_FARTHEST, false)
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
					damage = self:GetSpecialValueFor("damage")+self:GetSpecialValueFor("bonus_damage")*caster:GetIntellect(false),
					damage_type = self:GetAbilityDamageType(),
					damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
					ability = self, --Optional.
					hd_flags = HD_DAMAGE_FLAG_LIGHTING_DAMAGE,
				}
				ApplyDamage(damageTable2)
				break
			end

		end
		

		damageTable.damage = self:GetSpecialValueFor("bonus_dis_damage")*caster:GetIntellect(false)*3
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
				-- unit:AddNewModifier(nil, nil, "modifier_invulnerable", {duration = 0.5})
				unit:SetOrigin(target_point)
				unit:AddNoDraw()
				Timers:CreateTimer(0.5, function()
					unit:ForceKill(false)
			
				end)
				ParticleManager:SetParticleControlEnt(head_particle, 0, unit, PATTACH_POINT_FOLLOW, "attach_attack1", unit:GetAbsOrigin(), true)
				-- ParticleManager:SetParticleControl(head_particle, 0, target_point)
				ParticleManager:SetParticleControlEnt(head_particle, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
				ParticleManager:SetParticleControl(head_particle, 61, Vector(1, 1, 0))
				ParticleManager:ReleaseParticleIndex(head_particle)
				target:EmitSound("Hero_Zuus.ArcLightning.Cast")

			end)
			
		end

	end
end


-- modifier_Middle_Dragons_Lighting= modifier_Middle_Dragons_Lighting or class({})

-- function modifier_Middle_Dragons_Lighting:IsHidden()		return true end
-- function modifier_Middle_Dragons_Lighting:IsPurgable()		return false end
-- function modifier_Middle_Dragons_Lighting:RemoveOnDeath()	return false end
-- function modifier_Middle_Dragons_Lighting:GetAttributes()	return MODIFIER_ATTRIBUTE_MULTIPLE end

-- function modifier_Middle_Dragons_Lighting:OnCreated(keys)
-- 	if not IsServer() or not self:GetAbility() then return end

-- 	self.arc_damage			= self:GetAbility():GetSpecialValueFor("damage") +self:GetAbility():GetSpecialValueFor("bounus_damage")*self:GetCaster():GetIntellect(false)
-- 	-- self.radius				= 0
-- 	-- self.jump_count			= 0
-- 	-- self.jump_delay			= 0

	
-- 	self.starting_unit_entindex	= keys.starting_unit_entindex  --这是施法目标的index
	
-- 	self.units_affected			= {}  
-- 	self.current_unit						= EntIndexToHScript(self.starting_unit_entindex)
-- 	if self.current_unit then  
-- 		-- Using a previous unit and current unit variable to track n-1 and n-2 unit hit in current Arc Lightning jump, with previous unit being used for the Master of Lightning talent (can only chain if the next target is not current or previous target)
-- 		-- self.current_unit						= EntIndexToHScript(self.starting_unit_entindex)
-- 		self.units_affected[self.current_unit]	= 1  --记录这个单位到表里 接下来这个实例就不会影响它了
		
		
		
-- 		ApplyDamage({
-- 			victim 			= self.current_unit,
-- 			damage 			= self.arc_damage,
-- 			damage_type		= self:GetAbility():GetAbilityDamageType(),
-- 			damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
-- 			attacker 		= self:GetCaster(),
-- 			ability 		= self:GetAbility()
-- 		})
-- 	else  --目标不存在了 移除掉
-- 		self:Destroy()
-- 		return
-- 	end
	
-- 	self.unit_counter			= 0
-- 	self.pos = self.current_unit:GetAbsOrigin()
-- 	-- self:StartIntervalThink(self.jump_delay)
-- end
