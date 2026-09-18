LinkLuaModifier("modifier_creeps_spell_barr_thunder_debuff", "creeps_spell/creeps_spell_barr_thunder_attack", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_creeps_spell_barr_thunder_on_casting", "creeps_spell/creeps_spell_barr_thunder_attack", LUA_MODIFIER_MOTION_NONE)

creeps_spell_barr_thunder_attack = class({})



function creeps_spell_barr_thunder_attack:Precache( context )
	PrecacheResource( "particle", "particles/indicator/range_finder_fade/effect.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/chaotic_spell/lightning_bolt/cast_effect/thundergods_wrath_start_bolt_parent.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/chaotic_spell/chaotic_lightning_bolt/hit_effect/effect.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/spell/creeps_spell_barr_thunder_attack/lighting_effect/eye_of_the_storm.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/chaotic_spell/lightning_bolt/cast_effect_buff/effect.vpcf", context )	
end




function creeps_spell_barr_thunder_attack:OnSpellStart()

	local caster = self:GetCaster()
	local pos = self:GetCursorPosition()
	local caster_loc = caster:GetAbsOrigin()
	if pos==caster_loc then
		pos = pos +caster:GetForwardVector()
	end
	local nearby_enemy_units = FindUnitsInRadius(
		caster:GetTeamNumber(), 
		caster:GetAbsOrigin(), 
		nil, 
		3000, 
		DOTA_UNIT_TARGET_TEAM_ENEMY, 
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 
		FIND_CLOSEST, 
		false
	)
	caster:StartGestureWithPlaybackRate(ACT_DOTA_IDLE_RARE,0.75)
	local delay = self:GetSpecialValueFor("delay")
	caster:AddNewModifier(caster, self, "modifier_creeps_spell_barr_thunder_on_casting", {duration =delay})
				
	self:PlayCastEffect()




	local count = self:GetSpecialValueFor("count")
	
	local distance = self:GetSpecialValueFor("distance")
	local width = self:GetSpecialValueFor("width")
	local immunity_damage_index = self:GetSpecialValueFor("immunity_damage_index")*0.01
	local lightning_bonus_damage = self:GetSpecialValueFor("lightning_bonus_damage")
	local damage = (self:GetSpecialValueFor("base_damage") + caster:GetAverageTrueAttackDamage(nil)*self:GetSpecialValueFor("bonus_damage"))
	local damageTable = {
		attacker	= self:GetCaster(),
		-- victim = target,
		damage		= damage,
		damage_type	= self:GetAbilityDamageType(),
		ability		= self,
		hd_flags = HD_DAMAGE_FLAG_LIGHTING_DAMAGE,
	}
	-- local releaseTime = GameRules:GetGameTime()+delay

	caster:GameTimer(delay, function()
		if IsValid(caster) and caster:IsAlive() then
			self:PlayCastEffect()
		end
	end)
	
	for i = 1, count, 1 do
		local start_pos = pos + Vector(RandomInt(-1400, 1400),RandomInt(-1400, 1400),0)
		local end_pos = pos + Vector(RandomInt(-1500, 1500),RandomInt(-1500, 1500),0)
		if #nearby_enemy_units>=1 and 20>=RandomInt(1, 100) then
			start_pos = nearby_enemy_units[RandomInt(1, #nearby_enemy_units)]:GetAbsOrigin() + Vector(RandomInt(-200, 200),RandomInt(-200, 200),0)
		end
		local direction 	= (end_pos - start_pos):Normalized()
		direction.z = 0
		end_pos = start_pos + direction*distance
		local particle_cast = "particles/indicator/range_finder_fade/effect.vpcf"
		local pfx = ParticleManager:CreateParticle( particle_cast, PATTACH_CUSTOMORIGIN, nil )
		ParticleManager:SetParticleControl( pfx, 0, start_pos )
		ParticleManager:SetParticleControl( pfx, 1, end_pos )
		ParticleManager:SetParticleControl( pfx,60, Vector(width,0,0) )
		ParticleManager:SetParticleShouldCheckFoW(pfx, false)
		DestroyParticleByDelay(pfx,delay)
		-- caster:GameTimer(0, function()
		-- 	if IsValid(caster) and caster:IsAlive() then
		-- 		local particle_cast = "particles/rebuild/spell/creeps_spell_barr_thunder_attack/lighting_effect/eye_of_the_storm.vpcf"
		-- 		local pfx = ParticleManager:CreateParticle( particle_cast, PATTACH_CUSTOMORIGIN, nil )
		-- 		-- ParticleManager:SetParticleControl( pfx, 0, start_pos )
		-- 		local attach = "attach_attack1"
		-- 		if RandomInt(1, 2)==1 then
		-- 			attach="attach_attack2"
		-- 		end
		-- 		ParticleManager:SetParticleControlEnt( pfx, 0, caster, PATTACH_POINT_FOLLOW, attach , caster:GetOrigin(), true )
		-- 		ParticleManager:SetParticleControl( pfx, 1, start_pos+Vector(0,0,128) )
		-- 		ParticleManager:SetParticleShouldCheckFoW(pfx, false)
		-- 		DestroyParticleByDelay(pfx,delay)
		-- 		-- EmitSoundOnLocationWithCaster(start_pos, "Hero_Zuus.StaticField", caster)
		-- 		if GameRules:GetGameTime()<=(releaseTime-0.3) then
		-- 			return 0.1
		-- 		end
		-- 	end
		-- end)
		local particle_cast = "particles/rebuild/spell/creeps_spell_barr_thunder_attack/lighting_effect/eye_of_the_storm.vpcf"
		local pfx = ParticleManager:CreateParticle( particle_cast, PATTACH_CUSTOMORIGIN, nil )
		-- ParticleManager:SetParticleControl( pfx, 0, start_pos )
		local attach = "attach_attack1"
		if RandomInt(1, 2)==1 then
			attach="attach_attack2"
		end
		ParticleManager:SetParticleControlEnt( pfx, 0, caster, PATTACH_POINT_FOLLOW, attach , caster:GetOrigin(), true )
		ParticleManager:SetParticleControl( pfx, 1, start_pos+Vector(0,0,128) )
		ParticleManager:SetParticleShouldCheckFoW(pfx, false)
		DestroyParticleByDelay(pfx,delay)
		EmitSoundOnLocationWithCaster(start_pos, "Hero_Zuus.StaticField", caster)


		caster:GameTimer(delay, function()
			if IsValid(caster) and caster:IsAlive() then
				local pfx = ParticleManager:CreateParticle( "particles/rebuild/chaotic_spell/lightning_bolt/cast_effect/thundergods_wrath_start_bolt_parent.vpcf", PATTACH_CUSTOMORIGIN, nil )
				ParticleManager:SetParticleControl( pfx, 1,start_pos+Vector(0,0,64))
				ParticleManager:SetParticleControl( pfx, 2, end_pos + Vector(0,0,64)  )
				ParticleManager:SetParticleControlForward(pfx, 0, direction)  --方向
				ParticleManager:SetParticleShouldCheckFoW(pfx, false)
				ParticleManager:ReleaseParticleIndex(pfx)
				EmitSoundOnLocationWithCaster(start_pos, "chaotic_lightning_bolt_cast", caster)
				-- caster:EmitSound("creeps_spell_barr_thunder_attack_cast")
				local tTargets = FindUnitsInLine(caster:GetTeamNumber(), start_pos, end_pos,nil, self:GetSpecialValueFor("width"),
					DOTA_UNIT_TARGET_TEAM_ENEMY,
					DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
					DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
				)
				
				local line_dir = end_pos - start_pos --线的向量
				for i, unit in pairs(tTargets) do

					local unit_pos = unit:GetAbsOrigin()
					-- 计算从 caster_loc 到 unit_pos 的向量
					local caster_to_unit = unit_pos - caster_loc
					-- 计算投影长度
					local dot_product = caster_to_unit.x * line_dir.x + caster_to_unit.y * line_dir.y + caster_to_unit.z * line_dir.z
					local projection_length = dot_product / (line_dir.x^2 + line_dir.y^2 + line_dir.z^2)
					local intersection_point = Vector(caster_loc.x + projection_length * line_dir.x,caster_loc.y + projection_length * line_dir.y,caster_loc.z + 128)
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
					ApplyDamage(damageTable)
					--unit:AddNewModifier(caster, self, "modifier_creeps_spell_barr_thunder_debuff", {duration =-1,stack=lightning_bonus_damage})
					unit:Elecshocking(caster, self:GetAbility(), lightning_bonus_damage)
				end
			end
		end)
	end



	

	
	



end

function creeps_spell_barr_thunder_attack:PlayCastEffect()
	local caster = self:GetCaster()
	local particle_cast = "particles/rebuild/chaotic_spell/lightning_bolt/cast_effect_buff/effect.vpcf"
	local pfx = ParticleManager:CreateParticle( particle_cast, PATTACH_CUSTOMORIGIN, nil )
	ParticleManager:SetParticleControlEnt( pfx, 0, caster, PATTACH_POINT_FOLLOW, "" , caster:GetOrigin(), true )
	DestroyParticleByDelay(pfx,1)
	-- EmitSoundOnLocationWithCaster(start_pos, "Hero_Zuus.StaticField", caster)

end




modifier_creeps_spell_barr_thunder_debuff = advanced_modifier({})

function modifier_creeps_spell_barr_thunder_debuff:IsHidden() return false end
function modifier_creeps_spell_barr_thunder_debuff:IsPurgable() return false end
function modifier_creeps_spell_barr_thunder_debuff:IsDebuff() return true end
function modifier_creeps_spell_barr_thunder_debuff:IsPurgeException() return false end
function modifier_creeps_spell_barr_thunder_debuff:RemoveOnDeath() return false end
function modifier_creeps_spell_barr_thunder_debuff:GetTexture() return "chaotic_era_spell/chaotic_chain_lightning" end

function modifier_creeps_spell_barr_thunder_debuff:OnCreated(keys)
	self.bonus_damage = self:GetAbility():GetSpecialValueFor("rune_1_bonus_damage")
	if IsServer() then
		self:SetStackCount(keys.stack)
	end
end


function modifier_creeps_spell_barr_thunder_debuff:OnRefresh(keys)
	if IsServer() then
		self:SetStackCount(self:GetStackCount()+keys.stack)
	end
end


function modifier_creeps_spell_barr_thunder_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP,  
	}
end

function modifier_creeps_spell_barr_thunder_debuff:OnTooltip() return self:GetStackCount() end
function modifier_creeps_spell_barr_thunder_debuff:Advanced_GetModifierIncomingDamage_Percentage(keys)	
	if IsServer() and DamageFilter(keys.record,HD_DAMAGE_FLAG_LIGHTING_DAMAGE) then
		return self:GetStackCount()
	end
	return 0
end
function modifier_creeps_spell_barr_thunder_debuff:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,

    }
end











modifier_creeps_spell_barr_thunder_on_casting = advanced_modifier({})

function modifier_creeps_spell_barr_thunder_on_casting:IsHidden() return true end
function modifier_creeps_spell_barr_thunder_on_casting:IsPurgable() return false end
function modifier_creeps_spell_barr_thunder_on_casting:IsDebuff() return false end
function modifier_creeps_spell_barr_thunder_on_casting:IsPurgeException() return false end
function modifier_creeps_spell_barr_thunder_on_casting:RemoveOnDeath() return false end
function modifier_creeps_spell_barr_thunder_on_casting:GetPriority() return 1000 end
function modifier_creeps_spell_barr_thunder_on_casting:CheckState()
	local state = {
		[MODIFIER_STATE_STUNNED] = true
	}
	return state
end


