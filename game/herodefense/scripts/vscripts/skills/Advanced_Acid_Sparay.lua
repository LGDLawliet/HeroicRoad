--特效优化 √
LinkLuaModifier("modifier_Advanced_Acid_Sparay_thinker", "skills/Advanced_Acid_Sparay", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Acid_Sparay_debuff", "skills/Advanced_Acid_Sparay", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Acid_Sparay_unlock3", "skills/Advanced_Acid_Sparay", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Acid_Sparay_unlock3_effect", "skills/Advanced_Acid_Sparay", LUA_MODIFIER_MOTION_NONE)

Advanced_Acid_Sparay = Advanced_Acid_Sparay or class ({})


function Advanced_Acid_Sparay:IsHiddenWhenStolen()return false end

function Advanced_Acid_Sparay:GetAOERadius()return self:GetSpecialValueFor("radius") end

function Advanced_Acid_Sparay:OnSpellStart()
	local caster = self:GetCaster()
	CreateModifierThinker(caster, self, "modifier_Advanced_Acid_Sparay_thinker", {duration = self:GetSpecialValueFor("duration")}, self:GetCursorPosition(), caster:GetTeamNumber(), false)
end


function Advanced_Acid_Sparay:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/spell/acid_sparay/unlock3/effect/new_effect/new_effect/aqua_regia/new_effect_aqua_regia_alchemist_acid_spray.vpcf", context )


end



function Advanced_Acid_Sparay:CheckKV(key)
	local table = {
		damage = 2,
		bonus_damage = 0.005,
		armor_reduce = 0.3,

	}
	local value = table[key] or -1
	return value

end

function Advanced_Acid_Sparay:UnlockFirstCore(key)
    -- local caster = self:GetCaster()
	-- caster:AddNewModifier(caster,self,"modifier_Advanced_Unstable_Concoction_unlock1",{})
	-- self:SetLevel(0)
	-- self:SetLevel(1)
	return true
end
function Advanced_Acid_Sparay:UnlockSecondCore(key)
	-- local caster = self:GetCaster()
	-- caster:AddNewModifier(caster,self,"modifier_Advanced_Decrepify_aura",{})
	return true
end
function Advanced_Acid_Sparay:UnlockThirdCore(key)
	local caster = self:GetCaster()
	caster:AddNewModifier(caster,self,"modifier_Advanced_Acid_Sparay_unlock3",{})
	return true
end

modifier_Advanced_Acid_Sparay_thinker = class({})

function modifier_Advanced_Acid_Sparay_thinker:IsAura()return self:GetAbility() and true or false end
function modifier_Advanced_Acid_Sparay_thinker:OnCreated(keys)
	if IsServer() then
		EmitSoundOn( "Hero_Alchemist.AcidSpray", self:GetParent() )
		self.caster = self:GetCaster()
		self.thinker = self:GetParent()
		self.ability = self:GetAbility()
		self.thinker_loc = self.thinker:GetAbsOrigin()
		self.advanced_level = self.ability.advanced_level
		self.thinker:EmitSound("Hero_Alchemist.AcidSpray")

		self.radius			= self.ability:GetSpecialValueFor("radius")
		self.damage			= self.ability:GetSpecialValueFor("damage") +(self.ability:GetSpecialValueFor("bonus_damage"))*self.caster:GetBaseDamageMax()



		if self.caster:FindModifierByName("modifier_heroTalent_npc_dota_hero_alchemist_3") then
			self.radius = self.radius + self.caster:FindModifierByName("modifier_heroTalent_npc_dota_hero_alchemist_3"):GetStackCount()*100
			print("radius="..self.radius)
		end

		self.particle = ParticleManager:CreateParticle("particles/new_effect/new_effect/aqua_regia/new_effect_aqua_regia_alchemist_acid_spray.vpcf", PATTACH_POINT_FOLLOW, self.thinker)
		ParticleManager:SetParticleControl(self.particle, 0, (Vector(0, 0, 0)))
		ParticleManager:SetParticleControl(self.particle, 1, (Vector(self.radius, 1, 1)))
		ParticleManager:SetParticleControl(self.particle, 15, (Vector(25, 150, 25)))
		ParticleManager:SetParticleControl(self.particle, 16, (Vector(0, 0, 0)))


		self:StartIntervalThink(1)
	end
end

function modifier_Advanced_Acid_Sparay_thinker:OnIntervalThink()
	local ability = self:GetAbility()
	if not ability or ability:IsNull() then
		self:SafeDestroy()
		return
	end
	local units = FindUnitsInRadius(self.thinker:GetTeamNumber(),
		self.thinker_loc,nil,self.radius,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		DOTA_UNIT_TARGET_FLAG_NONE,
		FIND_ANY_ORDER,
		false)
		-- print(#units)


	if #units<=0 then
		return
	end
	local caster = self:GetCaster()
	local damageTable = {
		attacker	= caster,
		damage		= self.damage,
		damage_type	= self.ability:GetAbilityDamageType(),
		ability		= self.ability,
	}
	-- local count = 0
	
	for _, unit in ipairs(units) do
		damageTable.victim = unit
		ApplyDamage( damageTable)
	
	end

	if ability.unlock1 then
		if caster:GetRandomEffect(20,INT_TYPE,1)  >= RandomInt(1, 100) then
			local unstable_concoction = caster:FindAbilityByName("Advanced_Unstable_Concoction")
			if unstable_concoction then
				for _, unit in ipairs(units) do
					unstable_concoction:CastToTarget_acid_sparay(unit)
					break
				end
			end
		end
	end


end

function modifier_Advanced_Acid_Sparay_thinker:GetAuraRadius()return self.radius end
function modifier_Advanced_Acid_Sparay_thinker:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_Advanced_Acid_Sparay_thinker:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_Advanced_Acid_Sparay_thinker:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end

function modifier_Advanced_Acid_Sparay_thinker:GetModifierAura()return "modifier_Advanced_Acid_Sparay_debuff" end


function modifier_Advanced_Acid_Sparay_thinker:OnDestroy(keys)
	if IsServer() then
		local thinker = self:GetParent()
		thinker:StopSound("Hero_Alchemist.AcidSpray")
		ParticleManager:DestroyParticle(self.particle, true)
		ParticleManager:ReleaseParticleIndex(self.particle)
		UTIL_Remove(self:GetParent())
	end
end



modifier_Advanced_Acid_Sparay_debuff = modifier_Advanced_Acid_Sparay_debuff or advanced_modifier({})

function modifier_Advanced_Acid_Sparay_debuff:IsDebuff()return true end
function modifier_Advanced_Acid_Sparay_debuff:IsPurgable()return true end

function modifier_Advanced_Acid_Sparay_debuff:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_Advanced_Acid_Sparay_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,         --魔法抗性
	}
end


function modifier_Advanced_Acid_Sparay_debuff:GetModifierMoveSpeedBonus_Constant() return -80-self:GetStackCount()*self.reduce_per_stack*4  end
function modifier_Advanced_Acid_Sparay_debuff:GetModifierAttackSpeedBonus_Constant() return -self:GetStackCount()*3*self.reduce_per_stack  end
function modifier_Advanced_Acid_Sparay_debuff:GetModifierMagicalResistanceBonus() return self.magic_res  end



function modifier_Advanced_Acid_Sparay_debuff:OnCreated()
	--该技能需要从网表拿等级数据 自定义变量拿不到该值

	local ability = self:GetAbility()
	if not ability or ability:IsNull() then
		self:SafeDestroy()
		return
	end
	self.advanced_level = ability:GetSpecialValueFor("advanced_level")
	self.armor_reduce = self:GetAbility():GetSpecialValueFor("armor_reduce")
	self.magic_res = 0
	--LV15解锁腐蚀
	if self.advanced_level>=15 then
		self.armor_reduce = self.armor_reduce*1.5
		self.magic_res = -20
	end
	self.reduce_per_stack = 1
	--LV5解锁粘性+
	if self.advanced_level>=5 then
		self.reduce_per_stack = 1.5
	end
	self.king_water = -20
	--LV10解锁王水
	if self.advanced_level>=10 then
		self.king_water = -35
	end
	if self:GetUnlock(2)==2 then
		self.unlock2 = true
	end
	if not IsServer() then
		return
	end


	self:StartIntervalThink(1)
end




function modifier_Advanced_Acid_Sparay_debuff:OnIntervalThink()
	local ability = self:GetAbility()
	if not ability or ability:IsNull() then
		self:SafeDestroy()
		return
	end
	if not IsServer() then
		return
	end

	self:IncrementStackCount()
end


function modifier_Advanced_Acid_Sparay_debuff:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS_PERCENTAGE,
		advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
    }
end
function modifier_Advanced_Acid_Sparay_debuff:Advanced_GetModifierPhysicalArmorBonusPercentage()
    return self.king_water 
end



function modifier_Advanced_Acid_Sparay_debuff:Advanced_GetModifierPhysicalArmorBonus() 
	--LV20解锁化学反应
	local base = -self.armor_reduce
	if self.advanced_level>=20 then
		local index = (self:GetParent():GetHealthPercent()*0.005)+1
		base = base *index
	end
	if self.unlock2 and self:GetParent():HasModifier("modifier_Advanced_corrosive_haze") then
		base = base * 2
	end
	-- print("base=",base)
	return math.max(base,-60)  
end





modifier_Advanced_Acid_Sparay_unlock3 = class({})

function modifier_Advanced_Acid_Sparay_unlock3:IsHidden()	return false end
function modifier_Advanced_Acid_Sparay_unlock3:IsDebuff()	return false end
function modifier_Advanced_Acid_Sparay_unlock3:IsPurgable()	return false end
function modifier_Advanced_Acid_Sparay_unlock3:IsPurgeException() return false end
function modifier_Advanced_Acid_Sparay_unlock3:RemoveOnDeath() return false end
function modifier_Advanced_Acid_Sparay_unlock3:CheckState()
	local state = {[MODIFIER_STATE_DISARMED] = true}
	

	return state
end
function modifier_Advanced_Acid_Sparay_unlock3:IsAura()
	return (not self:GetCaster():PassivesDisabled())
end

function modifier_Advanced_Acid_Sparay_unlock3:GetModifierAura()	return "modifier_Advanced_Acid_Sparay_unlock3_effect" end
function modifier_Advanced_Acid_Sparay_unlock3:GetAuraRadius()	return 800  end
function modifier_Advanced_Acid_Sparay_unlock3:GetAuraSearchTeam()	return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_Advanced_Acid_Sparay_unlock3:GetAuraSearchType()	return DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC end

function modifier_Advanced_Acid_Sparay_unlock3:GetAuraSearchFlags()	return DOTA_UNIT_TARGET_FLAG_NONE  end

function modifier_Advanced_Acid_Sparay_unlock3:OnCreated(keys)
	if IsServer() then
		if not self:GetParent():IsRealHero() then
			return
		end
		self.nFXIndex = ParticleManager:CreateParticle( "particles/rebuild/spell/acid_sparay/unlock3/effect/new_effect/new_effect/aqua_regia/new_effect_aqua_regia_alchemist_acid_spray.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
		ParticleManager:SetParticleControlEnt( self.nFXIndex, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, nil, self:GetCaster():GetAbsOrigin(), true )
		ParticleManager:SetParticleControl( self.nFXIndex, 1, Vector(800,1,1) )
		self:AddParticle( self.nFXIndex, false, false, -1, true, false )
		
	end

end





modifier_Advanced_Acid_Sparay_unlock3_effect = modifier_Advanced_Acid_Sparay_unlock3_effect or class({})

function modifier_Advanced_Acid_Sparay_unlock3_effect:IsDebuff()return true end
function modifier_Advanced_Acid_Sparay_unlock3_effect:IsPurgable()return true end
function modifier_Advanced_Acid_Sparay_unlock3_effect:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_INCOMING_PHYSICAL_DAMAGE_PERCENTAGE
	}
end

function modifier_Advanced_Acid_Sparay_unlock3_effect:GetModifierIncomingPhysicalDamage_Percentage() return 65  end

