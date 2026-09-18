LinkLuaModifier("modifier_chaotic_lightning_bolt_rune1_debuff", "chaotic_spell/class_3/chaotic_lightning_bolt", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chaotic_lightning_bolt_rune_2", "chaotic_spell/class_3/chaotic_lightning_bolt", LUA_MODIFIER_MOTION_NONE)

chaotic_lightning_bolt = class({})


function chaotic_lightning_bolt:GetIntrinsicModifierName()
	return "modifier_generic_custom_indicator"
end
function chaotic_lightning_bolt:CastFilterResultLocation( vLoc )
	if IsClient() then
		if self.custom_indicator then
			self.custom_indicator:Register( vLoc )
		end
	end
	if not IsServer() then return end

	return UF_SUCCESS
end


function chaotic_lightning_bolt:CreateCustomIndicator()
	local particle_cast = "particles/ui_mouseactions/custom_range_finder_cone.vpcf"
	self.effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
end


function chaotic_lightning_bolt:UpdateCustomIndicator( loc )
	local caster = self:GetCaster()
	local pos = loc
	local caster_loc = caster:GetAbsOrigin()
	if pos==caster_loc then
		pos = pos +caster:GetForwardVector()*500
	end
	local direction 	= (pos - caster_loc):Normalized()
	local distance = self:GetSpecialValueFor("distance")
	if self:GetRuneType()==2 then
		distance = distance * (1+self:GetSpecialValueFor("rune_2_long")*0.01)
	end

	local target_pos = caster_loc + direction* distance

	ParticleManager:SetParticleControl( self.effect_cast, 0,caster_loc)
	ParticleManager:SetParticleControl( self.effect_cast, 1, caster_loc)
	ParticleManager:SetParticleControl( self.effect_cast, 2, target_pos)
	ParticleManager:SetParticleControl( self.effect_cast, 3, Vector(200,200,0))
	ParticleManager:SetParticleControl( self.effect_cast, 4, Vector(0,128,255))
	ParticleManager:SetParticleControl( self.effect_cast, 6, Vector(1,1,1))
end

function chaotic_lightning_bolt:DestroyCustomIndicator()
	ParticleManager:DestroyParticle( self.effect_cast, true ) 
	ParticleManager:ReleaseParticleIndex( self.effect_cast )

end


function chaotic_lightning_bolt:GetCastRange()
	if IsClient() then
		return 30000
	end
	local caster = self:GetCaster()
	local distance = self:GetSpecialValueFor("distance")
	if self:GetRuneType()==2 then
		distance = distance * (1+self:GetSpecialValueFor("rune_2_long")*0.01)
	end

	return distance - caster:GetCastRangeBonus()

end

function chaotic_lightning_bolt:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/chaotic_spell/lightning_bolt/cast_effect/thundergods_wrath_start_bolt_parent.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/chaotic_spell/chaotic_lightning_bolt/hit_effect/effect.vpcf", context )
end

function chaotic_lightning_bolt:GetManaCost(iLevel)
	local cost = self.BaseClass.GetManaCost(self,iLevel)
	cost = cost * self:GetManaCostGain()
	return cost
end



function chaotic_lightning_bolt:OnSpellStart()

	local caster = self:GetCaster()
	local pos = self:GetCursorPosition()
	local caster_loc = caster:GetAbsOrigin()
	if pos==caster_loc then
		pos = pos +caster:GetForwardVector()
	end
	local direction 	= (pos - caster_loc):Normalized()
	direction.z = 0
	local distance = self:GetSpecialValueFor("distance")
	if self:GetRuneType()==2 then
		distance = distance * (1+self:GetSpecialValueFor("rune_2_long")*0.01)
	end

	local target_pos = caster_loc + direction* distance
	local pfx = ParticleManager:CreateParticle( "particles/rebuild/chaotic_spell/lightning_bolt/cast_effect/thundergods_wrath_start_bolt_parent.vpcf", PATTACH_CUSTOMORIGIN, caster )
	-- ParticleManager:SetParticleControl( pfx, 1, caster_loc  )
	ParticleManager:SetParticleControlEnt( pfx, 1, caster, PATTACH_POINT_FOLLOW, "attach_attack1" ,Vector(0,0,0), true )
	ParticleManager:SetParticleShouldCheckFoW(pfx,false)
	ParticleManager:SetParticleControl( pfx, 2, target_pos + Vector(0,0,64)  )
	ParticleManager:SetParticleControlForward(pfx, 0, direction)  --方向
	ParticleManager:ReleaseParticleIndex(pfx)
	caster:EmitSound("chaotic_lightning_bolt_cast")
	

	local tTargets = FindUnitsInLine(caster:GetTeamNumber(), caster_loc, target_pos,nil, self:GetSpecialValueFor("width"),
	DOTA_UNIT_TARGET_TEAM_ENEMY,
	DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
	DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES)
	-- local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(1)
	-- local stun_duration = self:GetSpecialValueFor("duration")

	local damageTable = {
		attacker	= self:GetCaster(),
		-- victim = target,
		damage		= (self:GetSpecialValueFor("base_damage") + caster:HDGetPrimaryStatValue()*self:GetSpecialValueFor("bonus_damage"))*self:GetEffectGain(),
		damage_type	= self:GetAbilityDamageType(),
		ability		= self,
		hd_flags = HD_DAMAGE_FLAG_LIGHTING_DAMAGE,
	}
	local elecshocking = self:GetSpecialValueFor("elecshocking")
	if self:GetRuneType()==3 then
		elecshocking = elecshocking * (1+self:GetSpecialValueFor("rune_3_bonus")*0.01)
		damageTable.damage = damageTable.damage * (1-self:GetSpecialValueFor("rune_3_damage")*0.01)
	end

	local line_dir = target_pos - caster_loc --线的向量

	local rune_1_debuff_duration = self:GetSpecialValueFor("rune_1_debuff_duration")
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

		if self:GetRuneType()==2 then
			local no_magicres = 0
			local magic_res = unit:Script_GetMagicalArmorValue(true,self)
			if magic_res>0 then
				no_magicres = magic_res*100
			end

			local modifier 
			if no_magicres>0 then
				modifier = unit:AddNewModifier(self:GetCaster(), self, "modifier_chaotic_lightning_bolt_rune_2", {duration = 0.1,stack = no_magicres})
			end
			unit:Elecshocking(caster,self,elecshocking)
			damageTable.victim = unit
			ApplyDamage(damageTable)
			if unit:IsAlive() then
				if modifier then
					modifier:SafeDestroy()
				end
			end
		else
			unit:Elecshocking(caster,self,elecshocking)
			damageTable.victim = unit
			ApplyDamage(damageTable)
		end
		
		if self:GetRuneType()==1 then
			if IsValid(unit) and unit:IsAlive() then
				unit:AddNewModifier(caster, self, "modifier_chaotic_lightning_bolt_rune1_debuff", {duration =rune_1_debuff_duration,stack_time=rune_1_debuff_duration})
			end
		end
		
		 
	end


end





modifier_chaotic_lightning_bolt_rune1_debuff = advanced_modifier({})

function modifier_chaotic_lightning_bolt_rune1_debuff:IsHidden() return false end
function modifier_chaotic_lightning_bolt_rune1_debuff:IsPurgable() return false end
function modifier_chaotic_lightning_bolt_rune1_debuff:IsDebuff() return true end

function modifier_chaotic_lightning_bolt_rune1_debuff:OnCreated(keys)
	self.bonus_damage = self:GetAbility():GetSpecialValueFor("rune_1_bonus_damage")
	if IsServer() then
		self.tData = {}
		table.insert(self.tData, { dieTime = self:GetDieTime() })
		self:IncrementStackCount()
		self:StartIntervalThink(0.1)
	end
end


function modifier_chaotic_lightning_bolt_rune1_debuff:OnRefresh(params)
	if IsServer() then
		-- local dieTime = self:GetDieTime()
		local dieTime = GameRules:GetGameTime()+params.stack_time

		
		table.insert(self.tData, {dieTime = dieTime })
		self:IncrementStackCount()
	end
end

function modifier_chaotic_lightning_bolt_rune1_debuff:OnIntervalThink()
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

function modifier_chaotic_lightning_bolt_rune1_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP,  
	}
end

function modifier_chaotic_lightning_bolt_rune1_debuff:OnTooltip() return self:GetStackCount()*self.bonus_damage end
function modifier_chaotic_lightning_bolt_rune1_debuff:Advanced_GetModifierIncomingDamage_Percentage(keys)	
	if IsServer() and DamageFilter(keys.record,HD_DAMAGE_FLAG_LIGHTING_DAMAGE) then
		return self:GetStackCount()*self.bonus_damage
	end
	return 0
end
function modifier_chaotic_lightning_bolt_rune1_debuff:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,

    }
end


modifier_chaotic_lightning_bolt_rune_2 = class({})

function modifier_chaotic_lightning_bolt_rune_2:IsDebuff()			return true end
function modifier_chaotic_lightning_bolt_rune_2:IsHidden() 			return true end
function modifier_chaotic_lightning_bolt_rune_2:IsPurgable() 		return false end
function modifier_chaotic_lightning_bolt_rune_2:IsPurgeException() 	return false end
function modifier_chaotic_lightning_bolt_rune_2:OnCreated(keys)
	if IsServer() then
		self:SetStackCount(keys.stack)
	end
end	
function modifier_chaotic_lightning_bolt_rune_2:DeclareFunctions() return
	 {MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,} end
function modifier_chaotic_lightning_bolt_rune_2:GetModifierMagicalResistanceBonus() return -self:GetStackCount() end









