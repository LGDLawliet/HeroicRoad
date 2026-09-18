LinkLuaModifier("modifier_creeps_spell_barr_thunder_element_buff", "creeps_spell/creeps_spell_barr_thunder_element", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creeps_spell_barr_thunder_element_position", "creeps_spell/creeps_spell_barr_thunder_element", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_creeps_spell_barr_thunder_debuff", "creeps_spell/creeps_spell_barr_thunder_attack", LUA_MODIFIER_MOTION_NONE)


creeps_spell_barr_thunder_element = class({})



function creeps_spell_barr_thunder_element:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_disruptor/disruptor_static_storm.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/spell/creeps_spell_barr_thunder_element/effect_charge/effect_charge_active.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/chaotic_spell/lightning_bolt/cast_effect_body_buff/effect.vpcf", context )



	
	
end
function creeps_spell_barr_thunder_element:Spawn()
	if IsServer() then
		-- print("111111111111111111111111")
		local caster = self:GetCaster()
		caster:GameTimer(1.5, function()
			if IsValid(caster) and caster:IsAlive() then
				caster:EmitSound("Hero_TemplarAssassin.Trap.Explode")
				local health = self:GetSpecialValueFor("bonus_health")*0.01 * caster:GetMaxHealth()
				local armor = self:GetSpecialValueFor("bonus_armor")*0.01 * caster:GetPhysicalArmorValue(false)
				-- local gain = self:GetEffectGain()
			
				local damage = 0
				local unit_pos = self:GetCaster():GetAbsOrigin() + (self:GetCaster():GetForwardVector() * 250) 
			
				
				for i = 1, 2, 1 do
					local unit = caster:SummonUnit("npc_monster_boss_chaoc_form_real_one_trail",nil,
					unit_pos,
					caster:GetForwardVector(),self,0,health,nil,damage,armor,1,1)
					
					local infest_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_disruptor/disruptor_static_storm.vpcf", PATTACH_POINT, unit)
					ParticleManager:SetParticleControl(infest_particle, 0, unit_pos)
					ParticleManager:SetParticleControlEnt( infest_particle, 0, unit, PATTACH_POINT_FOLLOW, "" , unit:GetOrigin(), true )
					ParticleManager:SetParticleControl(infest_particle, 1, Vector(200,0,0))
					ParticleManager:SetParticleControl(infest_particle, 2, Vector(0.5,0,0))
					ParticleManager:ReleaseParticleIndex(infest_particle)
					caster:EmitSound("Hero_Zuus.StaticField")
					-- unit:StartGesture(ACT_DOTA_SPAWN)
					unit:AddNewModifier(caster, self, "modifier_creeps_spell_barr_thunder_element_buff", {})
					unit:AddNewModifier(caster, self, "modifier_creeps_spell_barr_thunder_element_position", {state = i})
					-- print("aaaaaaaaaaaaaaaaaaaaaaaa",unit)
				end
			end
		end)
		
	
	end
end





modifier_creeps_spell_barr_thunder_element_buff = advanced_modifier({})

function modifier_creeps_spell_barr_thunder_element_buff:IsDebuff() return false end
function modifier_creeps_spell_barr_thunder_element_buff:IsHidden() return true end
function modifier_creeps_spell_barr_thunder_element_buff:IsPurgable() 		return false end
function modifier_creeps_spell_barr_thunder_element_buff:IsPurgeException() 	return false end
-- function modifier_creeps_spell_barr_thunder_element_buff:RemoveOnDeath()  return false end
function modifier_creeps_spell_barr_thunder_element_buff:DestroyOnExpire() return false end
function modifier_creeps_spell_barr_thunder_element_buff:OnCreated(keys)
	if IsServer() then
		local angle = self:GetParent():GetAngles()
		self:GetParent():SetAngles(110, angle.y, 0)
		self.interval = self:GetAbility():GetSpecialValueFor("interval")
		self:StartIntervalThink(0.1)
		
	end
end

function modifier_creeps_spell_barr_thunder_element_buff:OnIntervalThink()
	local caster = self:GetCaster()
	if not caster or not caster:IsAlive() then
		return
	end
	local ability = self:GetAbility()
	if not ability  then
		return
	end
	if self:GetRemainingTime()>=0 then
		return
	end
	
	local parent = self:GetParent()

	local distance = ability:GetSpecialValueFor("distance")

	local enemies = FindUnitsInRadius(
		caster:GetTeamNumber(),	-- int, your team number
		parent:GetAbsOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		distance,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)
	if #enemies>=1 then
		self:SetDuration(self.interval+RandomFloat(0, 0.9), true)
		local target = enemies[RandomInt(1, #enemies)]
		local width = ability:GetSpecialValueFor("width")
		local delay = ability:GetSpecialValueFor("delay")
		local immunity_damage_index = ability:GetSpecialValueFor("immunity_damage_index")*0.01
		local lightning_bonus_damage = ability:GetSpecialValueFor("lightning_bonus_damage")
		local healing_index = ability:GetSpecialValueFor("healing_index")*0.01
		local damage = (ability:GetSpecialValueFor("base_damage") + caster:GetAverageTrueAttackDamage(nil)*ability:GetSpecialValueFor("bonus_damage"))
		local damageTable = {
			attacker	= caster,
			-- victim = target,
			damage		= damage,
			damage_type	= ability:GetAbilityDamageType(),
			ability		= ability,
			hd_flags = HD_DAMAGE_FLAG_LIGHTING_DAMAGE,
		}
		local targetPos = target:GetAbsOrigin()
		local start_pos = parent:GetAbsOrigin()
		local direction 	= (targetPos - start_pos):Normalized()
		direction.z = 0
		local end_pos = start_pos + direction*distance


		local particle_cast = "particles/indicator/range_finder_fade/effect.vpcf"
		local pfx = ParticleManager:CreateParticle( particle_cast, PATTACH_CUSTOMORIGIN, nil )
		ParticleManager:SetParticleControlEnt( pfx, 0, parent, PATTACH_POINT_FOLLOW, "" , parent:GetOrigin(), true )
		ParticleManager:SetParticleControl( pfx, 1, end_pos )
		ParticleManager:SetParticleControl( pfx,60, Vector(width,0,0) )
		ParticleManager:SetParticleShouldCheckFoW(pfx, false)
		local timer = GameRules:GetGameTime() + delay
		parent:GameTimer(FrameTime(), function()
			if IsValid(parent) and parent:IsAlive() and IsValid(caster) and caster:IsAlive() then
				local currentPos = parent:GetAbsOrigin()
				local dir 	= (targetPos - currentPos):Normalized()
				dir.z = 0
				local end_pos = currentPos + dir*distance
				ParticleManager:SetParticleControl( pfx, 1, end_pos )
				if GameRules:GetGameTime()>=timer then
					-- release
					ParticleManager:DestroyParticle(pfx, true)
					local pfx = ParticleManager:CreateParticle( "particles/rebuild/chaotic_spell/lightning_bolt/cast_effect/thundergods_wrath_start_bolt_parent.vpcf", PATTACH_CUSTOMORIGIN, nil )
					ParticleManager:SetParticleControl( pfx, 1,currentPos+Vector(0,0,64))
					ParticleManager:SetParticleControl( pfx, 2, end_pos + Vector(0,0,64)  )
					ParticleManager:SetParticleControlForward(pfx, 0, direction)  --方向
					ParticleManager:SetParticleShouldCheckFoW(pfx, false)
					ParticleManager:ReleaseParticleIndex(pfx)
					EmitSoundOnLocationWithCaster(currentPos, "chaotic_lightning_bolt_cast", parent)
					-- caster:EmitSound("creeps_spell_barr_thunder_attack_cast")
					local tTargets = FindUnitsInLine(caster:GetTeamNumber(), currentPos, end_pos,nil, width,
						DOTA_UNIT_TARGET_TEAM_ENEMY,
						DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
						DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
					)
					
					local line_dir = end_pos - currentPos --线的向量
					local total_damage = 0
					for i, unit in pairs(tTargets) do

						local unit_pos = unit:GetAbsOrigin()
						-- 计算从 caster_loc 到 unit_pos 的向量
						local caster_to_unit = unit_pos - currentPos
						-- 计算投影长度
						local dot_product = caster_to_unit.x * line_dir.x + caster_to_unit.y * line_dir.y + caster_to_unit.z * line_dir.z
						local projection_length = dot_product / (line_dir.x^2 + line_dir.y^2 + line_dir.z^2)
						local intersection_point = Vector(currentPos.x + projection_length * line_dir.x,currentPos.y + projection_length * line_dir.y,currentPos.z + 128)
						for i = 1, 2, 1 do
							local pfx = ParticleManager:CreateParticle( "particles/rebuild/chaotic_spell/chaotic_lightning_bolt/hit_effect/effect.vpcf", PATTACH_CUSTOMORIGIN, nil )
							ParticleManager:SetParticleControl( pfx, 0, intersection_point+ RandomVector(25)  )
							ParticleManager:SetParticleControl( pfx, 1, unit_pos + RandomVector(50)  )
							ParticleManager:ReleaseParticleIndex(pfx)
						end
						unit:EmitSound("Hero_Zuus.StaticField")
						if unit:IsMagicImmune() then
							damageTable.damage = damage *immunity_damage_index
						else
							damageTable.damage = damage
						end
						damageTable.victim = unit
						total_damage = total_damage + ApplyDamage(damageTable)
						--unit:AddNewModifier(caster, ability, "modifier_creeps_spell_barr_thunder_debuff", {duration =-1,stack=lightning_bonus_damage})
						unit:Elecshocking(caster, ability, lightning_bonus_damage)
					end
					if total_damage>0 then
						local fhealing =  HealWithGain(total_damage*healing_index,caster,caster,ability)
						SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL,caster, fhealing, nil) 
					end
					return
				end
				return FrameTime()
			else
				ParticleManager:DestroyParticle(pfx, true)
			end
		end)

	end



	




end







modifier_creeps_spell_barr_thunder_element_position = advanced_modifier({})

function modifier_creeps_spell_barr_thunder_element_position:IsDebuff() return false end
function modifier_creeps_spell_barr_thunder_element_position:IsHidden() return true end
function modifier_creeps_spell_barr_thunder_element_position:IsPurgable() 		return false end
function modifier_creeps_spell_barr_thunder_element_position:IsPurgeException() 	return false end
-- function modifier_creeps_spell_barr_thunder_element_position:RemoveOnDeath()  return false end
function modifier_creeps_spell_barr_thunder_element_position:OnCreated(keys)
	if IsServer() then
		-- print("1babsabs")
		self.caster = self:GetCaster()
		self.state = keys.state
		if keys.state==1 then
			self.angle = 90
			-- local newpos1 = RotatePosition(origin, QAngle(0, 120, 0), point)
		else
			self.angle = -90
		end
		self:StartIntervalThink(FrameTime())
	end
end
function modifier_creeps_spell_barr_thunder_element_position:OnDestroy()
	if IsServer() then
		-- print("destroy")
	end
end

function modifier_creeps_spell_barr_thunder_element_position:OnIntervalThink()
	if IsValid(self.caster) and self.caster:IsAlive() then
		local parent = self:GetParent()
		local pos = self.caster:GetAbsOrigin()
		local new_pos  = RotatePosition(pos, QAngle(0, self.angle, 0), pos+self.caster:GetForwardVector())
		local dir = (new_pos-pos):Normalized()
		local target_pos = pos+dir*600
		parent:SetOrigin(target_pos)
	end
end



function modifier_creeps_spell_barr_thunder_element_position:CheckState()
	local state = {
		[MODIFIER_STATE_ROOTED] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
	}
	return state
end

