LinkLuaModifier("modifier_chaotic_conjure_barrage_debuff", "chaotic_spell/class_3/chaotic_conjure_barrage", LUA_MODIFIER_MOTION_NONE)


chaotic_conjure_barrage = class({})


function chaotic_conjure_barrage:GetIntrinsicModifierName()
	return "modifier_generic_custom_indicator"
end
function chaotic_conjure_barrage:CastFilterResultLocation( vLoc )
	if IsClient() then
		if self.custom_indicator then
			self.custom_indicator:Register( vLoc )
		end
	end
	if not IsServer() then return end

	return UF_SUCCESS
end


function chaotic_conjure_barrage:CreateCustomIndicator()
	local particle_cast = "particles/ui_mouseactions/custom_sector_finder.vpcf"
	self.effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
end


function chaotic_conjure_barrage:UpdateCustomIndicator( loc )
	local caster = self:GetCaster()
	local pos = loc
	local caster_loc = caster:GetAbsOrigin()
	if pos==caster_loc then
		pos = pos +caster:GetForwardVector()*500
	end
	local direction 	= (pos - caster_loc):Normalized()

	local target_pos = caster_loc + direction* self:GetSpecialValueFor("distance")
	local start_width = self:GetSpecialValueFor("start_width")
	local end_width = self:GetSpecialValueFor("end_width")
	if self:GetRuneType()==2 then
		start_width = start_width*(1+self:GetSpecialValueFor("rune_2_radius")*0.01)
		end_width = end_width*(1+self:GetSpecialValueFor("rune_2_radius")*0.01)
	end
	ParticleManager:SetParticleControl( self.effect_cast, 0,caster_loc)
	ParticleManager:SetParticleControl( self.effect_cast, 1, caster_loc)
	ParticleManager:SetParticleControl( self.effect_cast, 2, target_pos)
	ParticleManager:SetParticleControl( self.effect_cast, 3, Vector(end_width,start_width,0))
	ParticleManager:SetParticleControl( self.effect_cast, 4, Vector(0,128,255))
	ParticleManager:SetParticleControl( self.effect_cast, 6, Vector(1,1,1))
end

function chaotic_conjure_barrage:DestroyCustomIndicator()
	ParticleManager:DestroyParticle( self.effect_cast, true ) 
	ParticleManager:ReleaseParticleIndex( self.effect_cast )

end

function chaotic_conjure_barrage:GetCooldown()
	local cd = self:GetSpecialValueFor("cooldown")
	if self:GetRuneType()==2 then
		cd = cd * (1-self:GetSpecialValueFor("rune_2_cd")*0.01)
	end
	return  cd
end
function chaotic_conjure_barrage:GetCastRange()
	if IsServer() then
		return 30000
	end
	local caster = self:GetCaster()
	return self:GetSpecialValueFor("distance") - caster:GetCastRangeBonus()

end

function chaotic_conjure_barrage:Precache( context )

	PrecacheResource( "particle", "particles/rebuild/chaotic_spell/chaotic_conjure_barrage/effect_cast/group.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/spell/creeps_spell_flame_of_the_splitter/flame_laungh/effect_backstab_hit_blood.vpcf", context )


	
	PrecacheResource( "particle", "particles/ui_mouseactions/custom_sector_finder.vpcf", context )
end
function chaotic_conjure_barrage:GetManaCost(iLevel)
	local cost = self.BaseClass.GetManaCost(self,iLevel)
	cost = cost * self:GetManaCostGain()
	return cost
end



function chaotic_conjure_barrage:OnSpellStart()

	local caster = self:GetCaster()
	local pos = self:GetCursorPosition()
	local caster_loc = caster:GetAbsOrigin()
	if pos==caster_loc then
		pos = pos +caster:GetForwardVector()
	end
	local direction 	= (pos - caster_loc):Normalized()
	direction.z = 0
	local distance = self:GetSpecialValueFor("distance")
	-- local target_pos = caster_loc + direction* distance

	caster:EmitSound("Hero_LegionCommander.Overwhelming.Cast")


	local start_width = self:GetSpecialValueFor("start_width")
	local end_width = self:GetSpecialValueFor("end_width")
	if self:GetRuneType()==2 then
		start_width = start_width*(1+self:GetSpecialValueFor("rune_2_radius")*0.01)
		end_width = end_width*(1+self:GetSpecialValueFor("rune_2_radius")*0.01)
	end

	local perpendicularDirection = Vector(-direction.y, direction.x, direction.z)
	local count = 0
	local current_distance = 0
	local distance_step = 250
	local max_count = distance / distance_step  --求出箭雨有几阵
	local width_step = (end_width-start_width)/max_count   --每次增长的宽度
	local arrow_span_pos = caster_loc - direction * 1000 + Vector(0,0,1000)
	local interval = FrameTime()*3

	local speed = (distance_step/(interval+0.06))

	local info = {
		Source = caster,
		Ability = self,
		vSpawnOrigin = caster:GetAbsOrigin(),
		
	    bDeleteOnHit = false,
	    
	    iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
	    iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
	    
	    EffectName = "",
	    fDistance = distance-(end_width*0.5),
	    fStartRadius = start_width,
	    fEndRadius =end_width,
		vVelocity = direction * speed,
		}
	ProjectileManager:CreateLinearProjectile(info)




	-- 技能表现
	caster:GameTimer(0.1, function()
		caster:EmitSound("Hero_DrowRanger.Multishot.FrostArrows")
		current_distance = current_distance + distance_step
		local targetPos = caster_loc + direction*current_distance
		count = count + 1
		if count%2==0 then
			-- 能整除 左右相同数次
			local count_ = count/2
			if count_>=1 then
				for i = 1, count_, 1 do
					local child_pos1 = targetPos + perpendicularDirection *width_step*i
					local child_pos2 = targetPos - perpendicularDirection *width_step*i
					self:PlayEffect(arrow_span_pos,child_pos1)
					self:PlayEffect(arrow_span_pos,child_pos2)
				end
			end
		else
			local count_ = math.floor(count/2)
			if count_>=1 then
				for i = 1, count_, 1 do
					local child_pos1 = targetPos + perpendicularDirection *width_step*i
					local child_pos2 = targetPos - perpendicularDirection *width_step*i

					self:PlayEffect(arrow_span_pos,child_pos1)
					self:PlayEffect(arrow_span_pos,child_pos2)
				end
			end
			self:PlayEffect(arrow_span_pos,targetPos)
		end

		if count>=max_count then
			return nil
		end

		return interval
	end)







end



function chaotic_conjure_barrage:PlayEffect(arrow_span_pos,target_pos)
	local pfx = ParticleManager:CreateParticle( "particles/rebuild/chaotic_spell/chaotic_conjure_barrage/effect_cast/group.vpcf", PATTACH_CUSTOMORIGIN, nil )
	ParticleManager:SetParticleControl( pfx, 0, target_pos )
	ParticleManager:SetParticleControl( pfx, 1, arrow_span_pos  )
	ParticleManager:ReleaseParticleIndex(pfx)
end
function chaotic_conjure_barrage:PlayEffect_hit(target)
	local pfx = ParticleManager:CreateParticle( "particles/rebuild/spell/creeps_spell_flame_of_the_splitter/flame_laungh/effect_backstab_hit_blood.vpcf", PATTACH_POINT_FOLLOW, target )
	ParticleManager:SetParticleControlEnt( pfx, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc" , target:GetOrigin(), true )
	ParticleManager:ReleaseParticleIndex(pfx)
end


function chaotic_conjure_barrage:OnProjectileHit( target, location )
	if not target then return end

	-- load data
	local damage = self:GetSpecialValueFor( "base_damage" ) + self:GetSpecialValueFor( "bonus_damage" )*self:GetCaster():HDGetPrimaryStatValue()
	-- local duration = self:GetSpecialValueFor( "duration" )
	local modifier = target:FindModifierByName("modifier_chaotic_conjure_barrage_debuff")
	if modifier then
		damage = damage * (1+modifier:GetStackCount()*self:GetSpecialValueFor("debuff_bonus_damage")*0.01)
	end
	self:PlayEffect_hit(target)
	target:EmitSound("Hero_Clinkz.ProjectileImpact")
	-- damage
	local damageTable = {
		victim = target,
		attacker = self:GetCaster(),
		damage = damage*self:GetEffectGain(),
		damage_type = self:GetAbilityDamageType(),
		ability = self, --Optional.
	}
	ApplyDamage(damageTable)

	
	if IsValid(target) and target:IsAlive() then
		local chance = self:GetSpecialValueFor("proc_chance")
		local caster = self:GetCaster()
			
		if caster:RollRandom(chance,1)  then
			local stack = 1
			if self:GetRuneType()==1 then
				if caster:RollRandom(self:GetSpecialValueFor("rune_1_chance"),1) then
					stack = stack * (self:GetSpecialValueFor("rune_1_bounus")*0.01 + 1)
				end
			end
			local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(1)
			local StatusResistance = target:GetHDStatusResistanceIndex()*ModifierStatusNegativeGain
			local duration = self:GetSpecialValueFor("debuff_duration")*StatusResistance
			if self:GetRuneType()==3 then
				duration = duration *(1-self:GetSpecialValueFor("rune_3_duration")*0.01)
			end
			target:AddNewModifier(caster, self, "modifier_chaotic_conjure_barrage_debuff", {duration = self:GetSpecialValueFor("debuff_duration")*StatusResistance,stack = stack})
		end
	end


end









modifier_chaotic_conjure_barrage_debuff = class({})

function modifier_chaotic_conjure_barrage_debuff:IsHidden()	return false end
function modifier_chaotic_conjure_barrage_debuff:IsDebuff()	return true end
function modifier_chaotic_conjure_barrage_debuff:IsPurgable()	return false end
function modifier_chaotic_conjure_barrage_debuff:DeclareFunctions()
	return{
		MODIFIER_PROPERTY_DISABLE_HEALING
	}
end
function modifier_chaotic_conjure_barrage_debuff:GetDisableHealing()
	if self:GetAbility():GetRuneType()==3 then
		return 1
	end
	return 0 
end
function modifier_chaotic_conjure_barrage_debuff:OnCreated(keys)
	if IsServer() then
		self.tData = {}
		table.insert(self.tData, { 
			dieTime = self:GetDieTime(),
			stack = keys.stack
		})
		self:SetStackCount(self:GetStackCount()+keys.stack)
		self:StartIntervalThink(0.1)
	end
end
function modifier_chaotic_conjure_barrage_debuff:OnRefresh(keys)
	if IsServer() then
		local dieTime = self:GetDieTime()
		table.insert(self.tData, { 
			dieTime = self:GetDieTime(),
			stack = keys.stack
		})
		self:SetStackCount(self:GetStackCount()+keys.stack)
		self:IncrementStackCount()
	end
end

function modifier_chaotic_conjure_barrage_debuff:OnIntervalThink()
	if IsServer() then
		-- local hParent = self:GetParent()
		local fGameTime = GameRules:GetGameTime()

		for i = #self.tData, 1, -1 do
			if fGameTime >= self.tData[i].dieTime then
				self:SetStackCount(self:GetStackCount()-self.tData[i].stack)
				table.remove(self.tData, i)

			end
		end
	end
end


