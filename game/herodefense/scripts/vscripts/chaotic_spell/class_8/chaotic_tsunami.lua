LinkLuaModifier("modifier_chaotic_tsunami_thinker_particle", "chaotic_spell/class_8/chaotic_tsunami", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_chaotic_tsunami_debuff", "chaotic_spell/class_8/chaotic_tsunami", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier( "modifier_chaotic_tsunami_debuff_motion", "chaotic_spell/class_8/chaotic_tsunami", LUA_MODIFIER_MOTION_NONE )

chaotic_tsunami = class({})

function chaotic_tsunami:OnAbilityPhaseInterrupted()

end
function chaotic_tsunami:OnAbilityPhaseStart()
	if not self:CheckVectorTargetPosition() then return false end
	SendToConsole("-dota_ability_execute")  --由于ntV蛇不知道改了什么东西需要手动取消施法状态
	return true 
end


function chaotic_tsunami:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/chaotic_spell/chaotic_tsunami/tsunami_effect/effect.vpcf", context )


end



function chaotic_tsunami:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local targets = self:GetVectorTargetPosition()


	local distance = self:GetSpecialValueFor("vector_distance_all")
	caster:EmitSound("Ability.GushCast")

	local casterPos = caster:GetAbsOrigin()
	local startPos = targets.init_pos
	local endPos = startPos +  distance *  targets.direction

	local unit_pos = startPos
	-- 计算从 caster_loc 到 unit_pos 的向量
	local caster_to_unit = unit_pos - casterPos
	-- 计算投影长度
	local dot_product = caster_to_unit.x * targets.direction.x + caster_to_unit.y * targets.direction.y + caster_to_unit.z * targets.direction.z
	local projection_length = dot_product / (targets.direction.x^2 + targets.direction.y^2 + targets.direction.z^2)
	local intersection_point = Vector(casterPos.x + projection_length * targets.direction.x,casterPos.y + projection_length * targets.direction.y,casterPos.z + 128)
	local dir = CalculateDirection(startPos,intersection_point)




	local duration = self:GetSpecialValueFor("duration")
	local thinker = CreateModifierThinker(caster, self, "modifier_chaotic_tsunami_thinker_particle", {duration = duration}, startPos, caster:GetTeamNumber(), false)
	if thinker then
		local modifier = thinker:FindModifierByName("modifier_chaotic_tsunami_thinker_particle")
		if modifier then
			modifier:InitEffect(startPos,endPos,dir)
		end
	end




end







modifier_chaotic_tsunami_thinker_particle = advanced_modifier({})

function modifier_chaotic_tsunami_thinker_particle:IsAura()return true end

function modifier_chaotic_tsunami_thinker_particle:InitEffect(startPos,endPos,dir)
	if IsServer() then

		self.radius = self:GetAbility():GetSpecialValueFor("radius")
		self.max_count = self:GetAbility():GetSpecialValueFor("max_count")
		self.height = 300
		self.effect = 1
		if self:GetAbility():GetRuneType()==1 then
			self.effect = self.effect * (1+self:GetAbility():GetSpecialValueFor("rune_1_bonus")*0.01)
		end
		local parent = self:GetParent()
		parent:EmitSound("Hero_Kunkka.TidalWave")

		self.dir = dir
		self.startPos = startPos
		self.endPos = endPos

		self.particle = ParticleManager:CreateParticle("particles/rebuild/chaotic_spell/chaotic_tsunami/tsunami_effect/effect.vpcf", PATTACH_POINT_FOLLOW, parent)


		ParticleManager:SetParticleControlForward(self.particle,0,dir)
		ParticleManager:SetParticleControl(self.particle,1,dir*600)
		ParticleManager:SetParticleControl(self.particle,8,startPos)
		ParticleManager:SetParticleControl(self.particle,9,endPos)
		ParticleManager:SetParticleControl(self.particle,10,Vector(0,0,self.height))
		if self:GetAbility():GetRuneType()==2 then
			self.rune_type_2 = true
			self.particle2 = ParticleManager:CreateParticle("particles/rebuild/chaotic_spell/chaotic_tsunami/tsunami_effect/effect.vpcf", PATTACH_POINT_FOLLOW, parent)
			ParticleManager:SetParticleControlForward(self.particle2,0,-dir)
			ParticleManager:SetParticleControl(self.particle2,1,-dir*600)
			ParticleManager:SetParticleControl(self.particle2,8,startPos)
			ParticleManager:SetParticleControl(self.particle2,9,endPos)
			ParticleManager:SetParticleControl(self.particle2,10,Vector(0,0,self.height))
		end
		
		self:AddParticle(self.particle, false, false, -1, false, false)
		-- DestroyParticleByDelay(particle,13)
		self:StartIntervalThink(0.03)
	end
end





function modifier_chaotic_tsunami_thinker_particle:OnDestroy(keys)
	if IsServer() then
		ParticleManager:DestroyParticle(self.particle,false)
		if self.particle2 then
			ParticleManager:DestroyParticle(self.particle2,false)
		end
		
		UTIL_Remove(self:GetParent())
	end
end


function modifier_chaotic_tsunami_thinker_particle:ReduceEffect()
	self.effect = self.effect - self:GetAbility():GetSpecialValueFor("effect_reduce")*0.01
	ParticleManager:SetParticleControl(self.particle,10,Vector(0,0,self.height*self.effect))
	ParticleManager:SetParticleControl(self.particle,1,self.dir*600*self.effect)
	if self.particle2 then
		ParticleManager:SetParticleControl(self.particle2,10,Vector(0,0,self.height*self.effect))
		ParticleManager:SetParticleControl(self.particle2,1,-self.dir*600*self.effect)
	end


		
end
function modifier_chaotic_tsunami_thinker_particle:OnIntervalThink()
	local ability = self:GetAbility()
	if not ability then
		self:Destroy()
	end
	if self.effect<=0 then
		self:Destroy()
		return
	end
	local caster = self:GetCaster()
	if self.rune_type_2 then
		local parent = self:GetParent()
		if true then
			local tTargets = FindUnitsInLine(caster:GetTeamNumber(), self.startPos+self.dir*self.radius*0.5, self.endPos+self.dir*self.radius*0.5,nil, self.radius,
			DOTA_UNIT_TARGET_TEAM_ENEMY,
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES)
			if #tTargets<self.max_count then
				for index, unit in ipairs(tTargets) do
					unit:AddNewModifier(caster, ability, "modifier_chaotic_tsunami_debuff_motion", {duration = 0.6,dir_x=self.dir.x,dir_y=self.dir.y,effect=self.effect})
					unit:AddNewModifier(parent, ability, "modifier_chaotic_tsunami_debuff", {duration = 0.3,effect=self.effect})
				end
			end
		end
		if true then
			local tTargets = FindUnitsInLine(caster:GetTeamNumber(), self.startPos-self.dir*self.radius*0.5, self.endPos-self.dir*self.radius*0.5,nil, self.radius,
			DOTA_UNIT_TARGET_TEAM_ENEMY,
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES)
			if #tTargets<self.max_count then
				for index, unit in ipairs(tTargets) do
					unit:AddNewModifier(caster, ability, "modifier_chaotic_tsunami_debuff_motion", {duration = 0.6,dir_x=-self.dir.x,dir_y=-self.dir.y,effect=self.effect})
					unit:AddNewModifier(parent, ability, "modifier_chaotic_tsunami_debuff", {duration = 0.3,effect=self.effect})
				end
			end
		end
		
	else
		local tTargets = FindUnitsInLine(caster:GetTeamNumber(), self.startPos, self.endPos,nil, self.radius,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES)
		if #tTargets>=self.max_count then
			return
		end
		local parent = self:GetParent()
		for index, unit in ipairs(tTargets) do
			unit:AddNewModifier(caster, ability, "modifier_chaotic_tsunami_debuff_motion", {duration = 0.6,dir_x=self.dir.x,dir_y=self.dir.y,effect=self.effect})
			unit:AddNewModifier(parent, ability, "modifier_chaotic_tsunami_debuff", {duration = 0.3,effect=self.effect})
		end
	end

	

end

function modifier_chaotic_tsunami_thinker_particle:CheckState()
	local state	=	{
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true
	}
	return state
end










modifier_chaotic_tsunami_debuff = advanced_modifier({})

function modifier_chaotic_tsunami_debuff:IsHidden() 			return true end
function modifier_chaotic_tsunami_debuff:IsPurgable() 			return false end
function modifier_chaotic_tsunami_debuff:IsPurgeException() 	return false end
function modifier_chaotic_tsunami_debuff:IsDebuff() return true end



function modifier_chaotic_tsunami_debuff:OnCreated(keys)
	
	if IsServer() then
		if not IsEnemy(self:GetParent(),self:GetCaster()) then
			return
		end




		local ability = self:GetAbility()

		self.effect_reduce_by_scale = ability:GetSpecialValueFor("effect_reduce_by_scale")
		self.effect_reduce_by_scale_min = ability:GetSpecialValueFor("effect_reduce_by_scale_min")
		self.effect= keys.effect

		local thinker = self:GetCaster()
		self.parent_modifier = thinker:FindModifierByName("modifier_chaotic_tsunami_thinker_particle")
		self.damageTable = {
			victim = self:GetParent(),
			attacker = self:GetAbility():GetCaster(),
			-- damage = damage,
			damage_type = ability:GetAbilityDamageType(),
			ability = ability, --Optional.
		}
		self:OnIntervalThink()
		self:StartIntervalThink(1)
	end
end

function modifier_chaotic_tsunami_debuff:OnRefresh(keys)
	if IsServer() then
		self.effect= keys.effect
	end
end

function modifier_chaotic_tsunami_debuff:OnIntervalThink()
	local parent = self:GetParent()




	self:StartIntervalThink(1)
	local ability = self:GetAbility()
	if not ability then
		return
	end
	local damage = ability:GetSpecialValueFor( "base_damage" ) + ability:GetSpecialValueFor( "bonus_damage" )*self:GetAbility():GetCaster():HDGetPrimaryStatValue()
	local scale = parent:GetBodyScale()
	if scale>=self.effect_reduce_by_scale_min then
		local index = math.min((scale-self.effect_reduce_by_scale_min)/self.effect_reduce_by_scale,100)*0.01
		damage = damage* (1-index)
	end
	damage = damage *self.effect
	if damage>0 then
		self.damageTable.damage = damage
		ApplyDamage(self.damageTable)
	end

	if IsValid(self.parent_modifier) then
		self.parent_modifier:ReduceEffect()
	end


end






modifier_chaotic_tsunami_debuff_motion = class({})

function modifier_chaotic_tsunami_debuff_motion:IsDebuff()			return true end
function modifier_chaotic_tsunami_debuff_motion:IsHidden() 			return true end
function modifier_chaotic_tsunami_debuff_motion:IsPurgable() 		return false end
function modifier_chaotic_tsunami_debuff_motion:IsPurgeException() 	return false end
function modifier_chaotic_tsunami_debuff_motion:IsMotionController() return true end

function modifier_chaotic_tsunami_debuff_motion:OnCreated(keys)
	if IsServer() then
		
		local ability = self:GetAbility()
		self.move_speed = ability:GetSpecialValueFor("move_speed")
		self.effect_reduce_by_scale = ability:GetSpecialValueFor("effect_reduce_by_scale")
		self.effect_reduce_by_scale_min = ability:GetSpecialValueFor("effect_reduce_by_scale_min")
		self.effect= keys.effect
		self.dir = Vector(keys.dir_x,keys.dir_y,0)

		self:StartIntervalThink(FrameTime())   --FrameTime()获取上一帧在服务器上花费的时间
	end
end

function modifier_chaotic_tsunami_debuff_motion:OnRefresh(keys)
	if IsServer() then
		self.effect= keys.effect
	end
end
function modifier_chaotic_tsunami_debuff_motion:OnDestroy()
	if IsServer() then
		FindClearSpaceForUnit(self:GetParent(), self:GetParent():GetOrigin(), true)
	end
end




function modifier_chaotic_tsunami_debuff_motion:OnIntervalThink(keys)   
	
	local parent = self:GetParent()
	local dt = FrameTime()
	local scale = parent:GetBodyScale()
	local speed = self.move_speed
	if scale>=self.effect_reduce_by_scale_min then
		local index = math.min((scale-self.effect_reduce_by_scale_min)/self.effect_reduce_by_scale,100)*0.01
		speed = speed* (1-index)
	end
	speed =  math.max(speed  *self.effect,0)
	if speed<=10 then
		return
	end


	local pos = parent:GetOrigin() + self.dir * speed * dt
	pos = GetGroundPosition( pos, parent )
	parent:SetOrigin( pos )
    
end

function modifier_chaotic_tsunami_debuff_motion:CheckState()
	local state	=	{
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
	}
	return state
end
