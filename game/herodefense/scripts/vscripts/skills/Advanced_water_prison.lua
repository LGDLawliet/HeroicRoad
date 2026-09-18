Advanced_water_prison = class({})
LinkLuaModifier( "modifier_Advanced_water_prison", "skills/Advanced_water_prison", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_water_prison_debuff", "skills/Advanced_water_prison", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_water_prison_unlock3_debuff", "skills/Advanced_water_prison", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_water_prison_unlock3_buff", "skills/Advanced_water_prison", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------
-- Init Abilities
function Advanced_water_prison:Precache( context )
	PrecacheResource( "particle", "particles/econ/items/kunkka/kunkka_immortal/kunkka_immortal_ghost_ship_impact.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/spell/water_prison/water_prison.vpcf", context )
	PrecacheResource( "particle", "particles/econ/items/monkey_king/arcana/water/monkey_king_spring_arcana_water.vpcf", context )
	PrecacheResource( "particle", "particles/econ/items/kunkka/divine_anchor/hero_kunkka_dafx_skills/kunkka_spell_torrent_splash_fxset.vpcf", context )
	

end
function Advanced_water_prison:UnlockFirstCore(key)
	-- local caster = self:GetCaster()
	-- local modifier = caster:AddNewModifier(caster,self,"modifier_Advanced_hyakkiyakou_unlock1",{})
	
	return true
end
function Advanced_water_prison:UnlockSecondCore(key)
	-- local caster = self:GetCaster()
	-- local modifier = caster:AddNewModifier(caster,self,"modifier_Advanced_fear_arua_unlock2",{})
	
	return true
end
function Advanced_water_prison:UnlockThirdCore(key)
	-- local caster = self:GetCaster()
	-- local modifier = caster:AddNewModifier(caster,self,"modifier_Advanced_fear_arua_unlock2",{})
	
	return true
end


function Advanced_water_prison:GetBehavior()

	if self:GetUnlock(3)==3 then
		return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET +DOTA_ABILITY_BEHAVIOR_AUTOCAST
	end

	return self.BaseClass.GetBehavior(self)
end

function Advanced_water_prison:CheckKV(key)
	local table = {
		damage=10,
		bonus_damage=0.1,



	}
	if self:GetUnlock(2)==2 then
		table.bonus_damage = 0.3
	end
	local value = table[key] or -1
	return value

end
function Advanced_water_prison:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	-- load data
	local duration = self:GetSpecialValueFor( "duration" )
	local radius = self:GetSpecialValueFor("radius")
	if self.advanced_level>=5 then
		radius = radius +100
	end


	if self:GetAutoCastState() and not IsEnemy(target,caster) and not target:IsRealHero() then
		target:AddNewModifier(caster, self, "modifier_Advanced_water_prison_unlock3_debuff", {duration = 30  } )
		target:AddNewModifier(caster, self, "modifier_Advanced_water_prison", {duration =30,unlock3=1} )
	else
		target:AddNewModifier(caster, self, "modifier_Advanced_water_prison", { duration = duration } )
	end
	
	local effect_cast = ParticleManager:CreateParticle( "particles/econ/items/monkey_king/arcana/water/monkey_king_spring_arcana_water.vpcf", PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControl( effect_cast, 0, target:GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector(radius,0,0) )
	ParticleManager:ReleaseParticleIndex( effect_cast )
	-- play effects
	local sound_cast = "Ability.pre.Torrent"
	local sound_target = "Hero_Kunkaa.Tidebringer"
	EmitSoundOn( sound_cast, caster )
	EmitSoundOn( sound_target, target )
	if self.unlock2 then
		local units = FindUnitsInRadius(caster:GetTeamNumber(), target:GetOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_FARTHEST, false)
		local count = 4

		for i, enemy in ipairs(units) do
			if target~=enemy then
				count = count- 1
				enemy:AddNewModifier(caster, self, "modifier_Advanced_water_prison", { duration = duration+RandomFloat(0.2, 2.5) } )
				if count<=0 then
					break
				end
			end
		end
	end
end





modifier_Advanced_water_prison = advanced_modifier({})

function modifier_Advanced_water_prison:IsHidden()	return false end
function modifier_Advanced_water_prison:IsDebuff()	return self:GetParent():GetTeamNumber()~=self:GetCaster():GetTeamNumber() end
function modifier_Advanced_water_prison:IsPurgable()	return false end
function modifier_Advanced_water_prison:IsPurgeException() return false end
-- function modifier_Advanced_water_prison:RemoveOnDeath() return true end
function modifier_Advanced_water_prison:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,         --魔法抗性
		MODIFIER_PROPERTY_DISABLE_HEALING,
	}

	return funcs
end

function modifier_Advanced_water_prison:GetDisableHealing()	
	return self.disableRegen
end

function modifier_Advanced_water_prison:GetOverrideAnimation( params )
	return ACT_DOTA_FLAIL
end
function modifier_Advanced_water_prison:AdvancedGetModifierConstantHealthRegenPercentage()
	return self.bonus_regen
end
function modifier_Advanced_water_prison:GetModifierMagicalResistanceBonus() return self.bonus_magic_res end
function modifier_Advanced_water_prison:Advanced_GetModifierPhysicalArmorBonus() return self.bonus_armor end
function modifier_Advanced_water_prison:OnCreated( kv )
	self.bonus_armor = 0
	self.bonus_magic_res = 0
	local ability = self:GetAbility()
	self.type = 1
	self.disableRegen = 0
	self.bonus_regen = 0
	if self:GetParent():GetTeamNumber()==self:GetCaster():GetTeamNumber() then
		self.type = 2
		self.bonus_armor = ability:GetSpecialValueFor("bonus_armor")
		self.bonus_magic_res = ability:GetSpecialValueFor("bonus_magic_res")
		if self:GetAbility():GetSpecialValueFor("advanced_level")>=15  then
			self.bonus_regen = 5
		end
	else
		if self:GetAbility():GetSpecialValueFor("advanced_level")>=15  then
			self.disableRegen = 1
		end
	end
	self.trigger = false

	self:StartIntervalThink(0.3)
	self.radius = ability:GetSpecialValueFor("radius")

	if ability:GetSpecialValueFor("advanced_level")>=5 then
		self.radius = self.radius +100
	end
	if not IsServer() then return end
	if kv.unlock3 then
		self.unlock3 = true
	end
	self.nFXIndex = ParticleManager:CreateParticle( "particles/rebuild/spell/water_prison/water_prison.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControlEnt( self.nFXIndex, 0, self:GetParent(), PATTACH_POINT_FOLLOW, nil, self:GetParent():GetAbsOrigin(), true )
	ParticleManager:SetParticleControl( self.nFXIndex, 60, Vector(40,160,96))
	ParticleManager:SetParticleControl( self.nFXIndex, 61, Vector(2,2,2))
	self:AddParticle( self.nFXIndex, false, false, -1, true, false )
	
end
function modifier_Advanced_water_prison:IsAura()
	return not self.unlock3
end




function modifier_Advanced_water_prison:GetModifierAura()	return "modifier_Advanced_water_prison_debuff" end
function modifier_Advanced_water_prison:GetAuraRadius()	return self.radius  end
function modifier_Advanced_water_prison:GetAuraSearchTeam()	return DOTA_UNIT_TARGET_TEAM_BOTH end
function modifier_Advanced_water_prison:GetAuraSearchType()	return DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC end
function modifier_Advanced_water_prison:GetAuraSearchFlags()	return DOTA_UNIT_TARGET_FLAG_NONE  end
function modifier_Advanced_water_prison:GetAuraEntityReject(hEntity)

	if hEntity==self:GetParent()  then
		return true
	else
		if hEntity:GetTeam() == self:GetCaster():GetTeam()   then
			if self:GetAbility():GetSpecialValueFor("advanced_level")<20 then
				return true
			end
		end
	end
	return false
end
function modifier_Advanced_water_prison:OnIntervalThink()
	if not self.trigger then
		self.trigger = true
		self:StartIntervalThink(0.1)
	end
	if not self:GetParent():IsAlive() then
		self:SafeDestroy()
	end
	
end

function modifier_Advanced_water_prison:OnDestroy()
	if IsServer() then
		if self.nFXIndex then
			ParticleManager:DestroyParticle(self.nFXIndex, true)
			ParticleManager:ReleaseParticleIndex(self.nFXIndex)
			self.nFXIndex = nil
		end
		local parent = self:GetParent()
		local effect_cast = ParticleManager:CreateParticle( "particles/econ/items/kunkka/kunkka_immortal/kunkka_immortal_ghost_ship_impact.vpcf", PATTACH_ABSORIGIN_FOLLOW, parent )
		ParticleManager:SetParticleControl( effect_cast, 0, parent:GetOrigin() )
		ParticleManager:SetParticleControl( effect_cast, 3, parent:GetOrigin() )
		ParticleManager:ReleaseParticleIndex( effect_cast )
		parent:EmitSound("Ability.Ghostship.crash")
		local ability = self:GetAbility()
		if not ability or ability:IsNull() then
			return
		end
		local caster = self:GetCaster()


		local units = FindUnitsInRadius(caster:GetTeamNumber(), parent:GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
		local damageTable = {

			attacker =caster,
			damage = caster:GetIntellect(false)*ability:GetSpecialValueFor("bonus_damage")+ability:GetSpecialValueFor("damage"),
			damage_type = ability:GetAbilityDamageType(),
			ability = ability, --Optional.
		}

	
		for _, enemy in ipairs(units) do
			damageTable.victim = enemy
			ApplyDamage(damageTable)
		end
	end
end


function modifier_Advanced_water_prison:CheckState()
	local state = {
		
	}
	if self.trigger then
		state = {
			[MODIFIER_STATE_STUNNED] = true,
			[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		}
		if self.type==1 then
			state[MODIFIER_STATE_INVULNERABLE] = true
	
		end

		
	end

	return state
end



function modifier_Advanced_water_prison:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		advanced_MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE
    }
end






modifier_Advanced_water_prison_debuff = advanced_modifier({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_Advanced_water_prison_debuff:IsHidden()	return false end
function modifier_Advanced_water_prison_debuff:IsDebuff()	return self:GetParent():GetTeamNumber()~=self:GetCaster():GetTeamNumber() end
function modifier_Advanced_water_prison_debuff:IsPurgable()	return false end
function modifier_Advanced_water_prison_debuff:DeclareFunctions()
	return {


		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,       
		MODIFIER_PROPERTY_DISABLE_HEALING,


	}
end

function modifier_Advanced_water_prison_debuff:Advanced_GetModifierAttackSpeedPercentage()	return self.attack_slow end
function modifier_Advanced_water_prison_debuff:GetModifierMoveSpeedBonus_Constant()	return  self.move_slow end


function modifier_Advanced_water_prison_debuff:CheckState()
	local state = {
		
	}
	if self:GetAbility():GetSpecialValueFor("advanced_level")>=10 and self:GetParent():GetTeamNumber()~=self:GetCaster():GetTeamNumber() then
		state = {
			[MODIFIER_STATE_ROOTED] = true,
			[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
			[MODIFIER_STATE_PASSIVES_DISABLED] = true,
		}

		
	end

	return state
end

function modifier_Advanced_water_prison_debuff:GetDisableHealing()	
	return self.disableRegen
end

function modifier_Advanced_water_prison_debuff:AdvancedGetModifierConstantHealthRegenPercentage()
	return self.bonus_regen
end




function modifier_Advanced_water_prison_debuff:OnCreated()	
	self.type = 2
	self.move_slow = 0
	self.attack_slow = 0
	if self:GetParent():GetTeamNumber()~=self:GetCaster():GetTeamNumber() then
		self.type = 1
		self.attack_slow = -20
		self.move_slow = -200
	end
	
	local parent = self:GetParent()

	self.disableRegen = 0
	self.bonus_regen = 0
	if self.type==2 then
		self.bonus_regen = 5
	else
		if self:GetAbility():GetSpecialValueFor("advanced_level")>=20  then
			self.disableRegen = 1
		end
	end
	if IsServer() then
		if self.type==1 then
			self:SetStackCount(25)
		end
		if self:GetAbility().unlock1 then
			self:StartIntervalThink(RandomFloat(1, 3))
		end
	end
end


function modifier_Advanced_water_prison_debuff:OnIntervalThink()
	local center = self:GetAuraOwner()
	if center then
		center = center:GetOrigin() + Vector(RandomInt(-300, 300),RandomInt(-300, 300),0)
	end
	local caster = self:GetCaster()
	local nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/kunkka/divine_anchor/hero_kunkka_dafx_skills/kunkka_spell_torrent_splash_fxset.vpcf", PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( nFXIndex, 0, center)
	ParticleManager:ReleaseParticleIndex(nFXIndex)
	self:GetParent():EmitSound("Ability.Torrent")
	local ability = self:GetAbility()
	local radius = ability:GetSpecialValueFor("radius")+100

	local units = FindUnitsInRadius(caster:GetTeamNumber(), center, nil, radius*0.5, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
	local damageTable = {

		attacker =caster,
		damage = caster:GetIntellect(false)*ability:GetSpecialValueFor("bonus_damage")+ability:GetSpecialValueFor("damage"),
		damage_type = ability:GetAbilityDamageType(),
		ability = ability, --Optional.
	}


	for i, enemy in ipairs(units) do
		damageTable.victim = enemy
		ApplyDamage(damageTable)
		if i>=2 then
			break
		end
	end
	self:StartIntervalThink(-1)
end



function modifier_Advanced_water_prison_debuff:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
		advanced_MODIFIER_PROPERTY_ATTACKSPEED_PERCENTAGE,
		advanced_MODIFIER_PROPERTY_StatusResistance,


    }
end
function modifier_Advanced_water_prison_debuff:Advanced_GetModifier_StatusResistance(keys)
	return self:GetStackCount()
end







modifier_Advanced_water_prison_unlock3_debuff = class({})

function modifier_Advanced_water_prison_unlock3_debuff:IsHidden()	return true end
function modifier_Advanced_water_prison_unlock3_debuff:IsDebuff()	return true end
function modifier_Advanced_water_prison_unlock3_debuff:IsPurgable()	return false end
function modifier_Advanced_water_prison_unlock3_debuff:IsPurgeException() return false end

function modifier_Advanced_water_prison_unlock3_debuff:OnCreated()	

	if IsServer() then
		
		self:StartIntervalThink(1)
		
	end
end




function modifier_Advanced_water_prison_unlock3_debuff:OnIntervalThink()
	local parent = self:GetParent()
	local stack = parent:GetMaxHealth()*0.04
	local caster = self:GetCaster()
	if caster:IsAlive() then
		local ability = self:GetAbility()
		if not ability then
			self:SafeDestroy()

			return
		end
		parent:ModifyHealth(parent:GetHealth()-stack,nil,false,0)
		stack = stack *0.2
		caster:AddNewModifier(parent, ability, "modifier_Advanced_water_prison_unlock3_buff", {duration=30,index=stack}) 
	end
	
end















modifier_Advanced_water_prison_unlock3_buff = class({})

function modifier_Advanced_water_prison_unlock3_buff:IsHidden()	return false end
function modifier_Advanced_water_prison_unlock3_buff:IsDebuff()	return false end
function modifier_Advanced_water_prison_unlock3_buff:IsPurgable()	return false end
function modifier_Advanced_water_prison_unlock3_buff:IsPurgeException() return false end
function modifier_Advanced_water_prison_unlock3_buff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_HEALTH_BONUS,                     --生命值
		MODIFIER_PROPERTY_MANA_BONUS,                       --魔法值,
	}

	return funcs
end

function modifier_Advanced_water_prison_unlock3_buff:GetModifierHealthBonus()	
	local bonus = math.min(self:GetStackCount(),20000)
	return bonus
end

function modifier_Advanced_water_prison_unlock3_buff:GetModifierManaBonus()	
	local bonus = math.min(self:GetStackCount()*0.5,10000)
	return bonus
end

function modifier_Advanced_water_prison_unlock3_buff:OnCreated(params)
	self.ability = self:GetAbility()
	if IsServer() then
		self.tData = {}
		table.insert(self.tData, { dieTime = self:GetDieTime(),stack = params.index })
		self:SetStackCount( params.index )
		self:StartIntervalThink(0.1)
		
		-- self.bonus_armor = self.ability:GetSpecialValueFor("bonus_armor")
		-- self.bonus_health_regeneration = self.ability:GetSpecialValueFor("bonus_health_regeneration")
	end
end
function modifier_Advanced_water_prison_unlock3_buff:OnRefresh(params)
	if IsServer() then
		local dieTime = self:GetDieTime()
		table.insert(self.tData, {dieTime = dieTime ,stack = params.index})
		self:SetStackCount(self:GetStackCount()+ params.index )	
		if self:GetStackCount()>= 25000 then --积攒太多了可能很卡
			self:SetStackCount(self:GetStackCount()- self.tData[1].stack )
			table.remove(self.tData, 1)
		end
	end
end

function modifier_Advanced_water_prison_unlock3_buff:OnIntervalThink()
	if IsServer() then
		local fGameTime = GameRules:GetGameTime()
		for i = #self.tData, 1, -1 do
			if fGameTime >= self.tData[i].dieTime then
				self:SetStackCount(self:GetStackCount()- self.tData[i].stack )
				table.remove(self.tData, i)
			end
		end
	end
end





