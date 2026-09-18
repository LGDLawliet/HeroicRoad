--特效优化 √
Advanced_double_edge = class({})

LinkLuaModifier("modifier_Advanced_double_edge_buff", "skills/Advanced_double_edge", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_double_edge_buff_lv15", "skills/Advanced_double_edge", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_double_edge_buff_lv20", "skills/Advanced_double_edge", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_Advanced_double_edge_buff_unlock2", "skills/Advanced_double_edge", LUA_MODIFIER_MOTION_NONE)
function Advanced_double_edge:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_centaur/centaur_double_edge.vpcf", context )

	PrecacheResource( "particle", "particles/econ/items/centaur/centaur_ti9/centaur_double_edge_ti9.vpcf", context )

	PrecacheResource( "particle", "particles/rebuild/spell/double_edge/unlock2/effect", context )


	
end
function Advanced_double_edge:CheckKV(key)
	local table = {

		base_damage =10,
		bonus_damage = 0.06,

	}
	local value = table[key] or -1
	return value

end

function Advanced_double_edge:UnlockFirstCore(key)
	self:GetCaster():AddItemByName("item_hd_infernal_menace")
	return true
end
function Advanced_double_edge:UnlockSecondCore(key)
	return true
end
function Advanced_double_edge:UnlockThirdCore(key)
	return true
end
function Advanced_double_edge:GetAbilityTextureName()
	if self:GetCaster():HasModifier("modifier_item_hd_infernal_menace") then
		return "centaur_double_edge_ti9"
	end
	return "centaur_double_edge"
end


function Advanced_double_edge:OnAdvancedUpgrade()
	if self.advanced_level>=20 then
		local caster = self:GetCaster()
		if not caster:HasModifier("modifier_Advanced_double_edge_buff_lv20") then
			caster:AddNewModifier(caster, self, "modifier_Advanced_double_edge_buff_lv20", {}) 
		end
	end
end
function Advanced_double_edge:OnSpellStart(talent3Target)
	-- unit identifier
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	if talent3Target then
		target = talent3Target
	end
	-- cancel if linken
	if target:TriggerSpellAbsorb( self ) then
		return
	end

	-- load data
	local damage = self:GetSpecialValueFor("base_damage") + caster:GetStrength()*self:GetSpecialValueFor("bonus_damage")
	local modifier = caster:FindModifierByName("modifier_Advanced_double_edge_buff_lv20")
	if modifier then
		damage = damage + (caster:GetMaxHealth()* modifier:GetStackCount()*0.01)
	end
	local radius = self:GetSpecialValueFor("radius")
	if self:GetAutoCastState() then
		if self.advanced_level>=5 then
			damage = damage * 3
		else
			damage = damage * 2
		end
		
	end
	local self_damage = 1
	self_damage = self_damage + damage
	local modifier = caster:FindModifierByName("modifier_Advanced_double_edge_buff_lv15")
	if modifier then
		damage = damage * (1+modifier:GetStackCount()*0.1)
		modifier:SafeDestroy()
	end

	-- Find Units in Radius
	local enemies = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),
		target:GetOrigin(),	nil,
		radius,DOTA_UNIT_TARGET_TEAM_ENEMY,DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,0,0,	false
	)

	-- Precache damage
	local damageTable = {
		-- victim = target,
		attacker = caster,
		damage = damage,
		damage_type = self:GetAbilityDamageType(),
		ability = self, --Optional.
	}

	local endcooldown = false
	local modifie = caster:FindModifierByName("modifier_item_hd_infernal_menace")
	if modifie then
		for _,enemy in pairs(enemies) do
			damageTable.victim = enemy
			ApplyDamage(damageTable)
			if not enemy:IsAlive() then
				modifie:EffectStack()
				endcooldown = true
			end
		end
	else
		for _,enemy in pairs(enemies) do
			damageTable.victim = enemy
			ApplyDamage(damageTable)
		end
	end
	if endcooldown then
		self:EndCooldown()
	end
	
	damageTable.damage = self_damage
	local modifier = caster:FindModifierByName("modifier_Advanced_double_edge_buff")
	if modifier then
		damageTable.damage = damageTable.damage * (1-modifier:GetStackCount()*0.1)
	end
	-- Apply self-damage
	if not talent3Target then
		damageTable.victim = caster
		--damageTable.damage_flags = DOTA_DAMAGE_FLAG_NON_LETHAL
		ApplyDamage( damageTable )
	end


	caster:AddNewModifier(caster, self, "modifier_Advanced_double_edge_buff", {duration=7}) 
	if self.advanced_level>=15 then
		caster:AddNewModifier(caster, self, "modifier_Advanced_double_edge_buff_lv15", {}) 
	end
	-- Play effects
	self:PlayEffects( target )
	if self.unlock2 and target:IsAlive() then
		local modifier = caster:AddNewModifier(caster, self, "modifier_Advanced_double_edge_buff_unlock2", {duration = 15}) 
		if modifier then
			modifier:InitTarget(target,0.5)
		end
	end
end

--------------------------------------------------------------------------------
function Advanced_double_edge:PlayEffects( target )
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_centaur/centaur_double_edge.vpcf"
	if self:GetCaster():HasModifier("modifier_item_hd_infernal_menace") then
		particle_cast = "particles/econ/items/centaur/centaur_ti9/centaur_double_edge_ti9.vpcf"
	end
	local sound_cast = "Hero_Centaur.DoubleEdge"

	-- Get Data
	local forward = (target:GetOrigin()-self:GetCaster():GetOrigin()):Normalized()

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		0,
		self:GetCaster(),
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		self:GetCaster():GetOrigin(), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		1,
		target,
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		target:GetOrigin(), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControl( effect_cast, 3, target:GetOrigin() )
	ParticleManager:SetParticleControlForward( effect_cast, 2, forward )
	ParticleManager:SetParticleControlForward( effect_cast, 5, forward )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOn( sound_cast, target )
end


function Advanced_double_edge:CastUnlock1ItemEffect(target)
	-- unit identifier
	local caster = self:GetCaster()
	if target:TriggerSpellAbsorb( self ) then
		return
	end

	-- load data
	local damage = self:GetSpecialValueFor("base_damage") + caster:GetStrength()*self:GetSpecialValueFor("bonus_damage")
	local modifier = caster:FindModifierByName("modifier_Advanced_double_edge_buff_lv20")
	if modifier then
		damage = damage + (caster:GetMaxHealth()* modifier:GetStackCount()*0.01)
	end
	local radius = self:GetSpecialValueFor("radius")
	if self:GetAutoCastState() then
		damage = damage * 3

	end
	local self_damage = 1
	self_damage = self_damage + damage

	
	local damageTable = {
		victim = target,
		attacker = caster,
		damage = damage,
		damage_type = self:GetAbilityDamageType(),
		ability = self, --Optional.
	}
	ApplyDamage(damageTable)
	--local modifie = caster:FindModifierByName("modifier_item_hd_infernal_menace")
	--if modifie then
	--	if not target:IsAlive() then
	--		modifie:EffectStack()
	--		self:EndCooldown()
	--	end
	--end
	
	damageTable.damage = self_damage
	local modifier = caster:FindModifierByName("modifier_Advanced_double_edge_buff")
	if modifier then
		damageTable.damage = damageTable.damage * (1-modifier:GetStackCount()*0.1)
	end
	damageTable.damage = damageTable.damage
	damageTable.victim = caster
	damageTable.damage_flags = DOTA_DAMAGE_FLAG_NON_LETHAL
	ApplyDamage( damageTable )

	caster:AddNewModifier(caster, self, "modifier_Advanced_double_edge_buff", {duration=7}) 
	self:PlayEffects( target )
end



function Advanced_double_edge:CastUnlock2ItemEffect(target)
	-- cancel if linken
	if target:TriggerSpellAbsorb( self ) then
		return
	end
	local caster = self:GetCaster()
	-- load data
	local damage = self:GetSpecialValueFor("base_damage") + caster:GetStrength()*self:GetSpecialValueFor("bonus_damage")
	local modifier = caster:FindModifierByName("modifier_Advanced_double_edge_buff_lv20")
	if modifier then
		damage = damage + (caster:GetMaxHealth()* modifier:GetStackCount()*0.01)
	end
	local radius = self:GetSpecialValueFor("radius")
	if self:GetAutoCastState() then
		if self.advanced_level>=5 then
			damage = damage * 3
		else
			damage = damage * 2
		end
		
	end
	local self_damage = 1
	self_damage = self_damage + damage
	local enemies = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),
		target:GetOrigin(),	nil,
		radius,DOTA_UNIT_TARGET_TEAM_ENEMY,DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,0,0,	false
	)
	local damageTable = {
		-- victim = target,
		attacker = caster,
		damage = damage,
		damage_type = self:GetAbilityDamageType(),
		ability = self, --Optional.
	}
	local endcooldown = false
	local modifie = caster:FindModifierByName("modifier_item_hd_infernal_menace")
	if modifie then
		for _,enemy in pairs(enemies) do
			damageTable.victim = enemy
			ApplyDamage(damageTable)
			if not enemy:IsAlive() then
				modifie:EffectStack()
				endcooldown = true
			end
		end
	else
		for _,enemy in pairs(enemies) do
			damageTable.victim = enemy
			ApplyDamage(damageTable)
		end
	end
	if endcooldown then
		self:EndCooldown()
	end
	damageTable.damage = self_damage
	local modifier = caster:FindModifierByName("modifier_Advanced_double_edge_buff")
	if modifier then
		damageTable.damage = damageTable.damage * (1-modifier:GetStackCount()*0.1)
	end
	damageTable.victim = caster
	damageTable.damage_flags = DOTA_DAMAGE_FLAG_NON_LETHAL
	ApplyDamage( damageTable )
	caster:AddNewModifier(caster, self, "modifier_Advanced_double_edge_buff", {duration=7}) 
	self:PlayEffects( target )

end



modifier_Advanced_double_edge_buff = class({})

function modifier_Advanced_double_edge_buff:IsBuff()                return true end
function modifier_Advanced_double_edge_buff:IsPurgable() 			return false end
function modifier_Advanced_double_edge_buff:IsPurgeException() 		return true end
function modifier_Advanced_double_edge_buff:IsHidden()				return false end
function modifier_Advanced_double_edge_buff:RemoveOnDeath()      	return true end
function modifier_Advanced_double_edge_buff:OnCreated()
	if IsServer() then
		self:IncrementStackCount()
	end
end
function modifier_Advanced_double_edge_buff:OnRefresh()
	if IsServer() then
		local max = 5
		if self:GetAbility().advanced_level>=10 then
			max = 7
		end
		self:SetStackCount(math.min(self:GetStackCount()+1,max))
	end
end





modifier_Advanced_double_edge_buff_lv15 = class({})

function modifier_Advanced_double_edge_buff_lv15:IsDebuff() return false end
function modifier_Advanced_double_edge_buff_lv15:IsHidden() return false end
function modifier_Advanced_double_edge_buff_lv15:IsPurgable() return true end
function modifier_Advanced_double_edge_buff_lv15:OnCreated()
	if IsServer() then
		self.parent = self:GetParent()
		self.prevLoc = self.parent:GetAbsOrigin()
		self.move_dis = 0
		self.timer = 0
		self:StartIntervalThink( 0.2 )
	end

end

function modifier_Advanced_double_edge_buff_lv15:OnRefresh()
	self:OnCreated()
end

function modifier_Advanced_double_edge_buff_lv15:OnIntervalThink()
	self.timer = self.timer +0.2
	self.move_dis =self.move_dis+ CalculateDistance(self.prevLoc, self.parent)
	if self.move_dis>=200 then
		local stack = self.move_dis/200
		self.move_dis = self.move_dis - stack*200
		self:SetStackCount(math.min(self:GetStackCount()+stack,40))
	end
	self.prevLoc = self:GetParent():GetAbsOrigin()
	if self.timer>=5 then
		self:StartIntervalThink(-1 )
	end
end







modifier_Advanced_double_edge_buff_lv20 = class({})

function modifier_Advanced_double_edge_buff_lv20:IsDebuff()			return false end
function modifier_Advanced_double_edge_buff_lv20:IsHidden() 			return false end
function modifier_Advanced_double_edge_buff_lv20:IsPurgable() 		return false end
function modifier_Advanced_double_edge_buff_lv20:IsPurgeException() 	return false end
function modifier_Advanced_double_edge_buff_lv20:RemoveOnDeath() return false end
function modifier_Advanced_double_edge_buff_lv20:GetAttributes() return   MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_Advanced_double_edge_buff_lv20:OnCreated()
	if IsServer() then
		self.damage_count = 0
	end
end
function modifier_Advanced_double_edge_buff_lv20:DeclareFunctions() 
	return {
		MODIFIER_EVENT_ON_TAKEDAMAGE,
	} 
end

function modifier_Advanced_double_edge_buff_lv20:OnTakeDamage(keys)
	if IsServer() and keys.unit==self:GetParent() then
		if not self:GetParent():IsRealHero() then
			return false
		end
		local caster = self:GetCaster()
		if keys.inflictor and keys.inflictor==self:GetAbility() then
			if keys.damage>=10 then
				self.damage_count = self.damage_count + keys.damage
				if self.damage_count>=caster:GetMaxHealth()*2 then
					self.damage_count = 0
					local max = 20
					if self:GetAbility().unlock3 then
						max =150
					end
					self:SetStackCount(math.min(self:GetStackCount()+1, max))
				end
			end
		end

	end
end


modifier_Advanced_double_edge_buff_unlock2 = modifier_Advanced_double_edge_buff_unlock2 or class({})

function modifier_Advanced_double_edge_buff_unlock2:IsDebuff()			return false end
function modifier_Advanced_double_edge_buff_unlock2:IsHidden() 			return false end
function modifier_Advanced_double_edge_buff_unlock2:IsPurgable() 		return false end
function modifier_Advanced_double_edge_buff_unlock2:IsPurgeException() 	return false end
function modifier_Advanced_double_edge_buff_unlock2:RemoveOnDeath() return false end
function modifier_Advanced_double_edge_buff_unlock2:InitTarget(target,interval)
	self.target = target
	self.interval = interval
	local caster = self:GetCaster()
	self.radius = math.max( self:GetAbility():GetCastRange(caster:GetOrigin(), target) +  caster:GetCastRangeBonus() ,100)

	self.nFXIndex = ParticleManager:CreateParticle( "particles/rebuild/spell/double_edge/unlock2/effectrope_arcana.vpcf", PATTACH_ABSORIGIN_FOLLOW,caster )
	ParticleManager:SetParticleControlEnt( self.nFXIndex, 0, caster, PATTACH_POINT_FOLLOW, nil,caster:GetAbsOrigin(), true )
	ParticleManager:SetParticleControl( self.nFXIndex, 60, Vector(self.radius,0,0) )
	self:AddParticle( self.nFXIndex, false, false, -1, true, false )
	
	self:StartIntervalThink(self.interval)
end

function modifier_Advanced_double_edge_buff_unlock2:OnIntervalThink()
	if self.target:IsNull() or not self.target:IsAlive() then
		self:SafeDestroy()
		return
	end
	local parent = self:GetParent()
	if CalculateDistance(self.target,parent)>self.radius then
		self:SafeDestroy()
		return
	end
	
	parent:FaceTowards(self.target:GetOrigin())
	local rate = 1.2/self.interval
	parent:StartGestureWithPlaybackRate(ACT_DOTA_CAST_ABILITY_2, rate)
	self.interval = math.max(self.interval-0.01,0.1)
	self:StartIntervalThink(self.interval)
	self:GetAbility():CastUnlock2ItemEffect(self.target)
end


function modifier_Advanced_double_edge_buff_unlock2:CheckState()
	local state = {
		[MODIFIER_STATE_DISARMED] = true,
	}

	return state
end

function modifier_Advanced_double_edge_buff_unlock2:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ORDER,
	}

	return funcs
end


function modifier_Advanced_double_edge_buff_unlock2:OnOrder( params )
	if params.unit~=self:GetParent() then return end

	if 	params.order_type==DOTA_UNIT_ORDER_MOVE_TO_POSITION or
		params.order_type==DOTA_UNIT_ORDER_MOVE_TO_TARGET or
		params.order_type==DOTA_UNIT_ORDER_ATTACK_TARGET or
		params.order_type==DOTA_UNIT_ORDER_STOP or
		params.order_type==DOTA_UNIT_ORDER_HOLD_POSITION 

	then
		self:SafeDestroy()
	end
end