item_hd_shivas_staff = class({})

LinkLuaModifier("modifier_item_hd_shivas_staff", "items/item_hd_shivas_staff", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_shivas_staff_active", "items/item_hd_shivas_staff", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_item_hd_shivas_staff_thinker", "items/item_hd_shivas_staff", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_item_hd_shivas_staff_debuff", "items/item_hd_shivas_staff", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_shivas_staff_frozen", "items/item_hd_shivas_staff", LUA_MODIFIER_MOTION_NONE)





function item_hd_shivas_staff:GetIntrinsicModifierName()
	return "modifier_item_hd_shivas_staff"
end
function item_hd_shivas_staff:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/items/ice_blast/effect.vpcf", context )
end
function item_hd_shivas_staff:GetAOERadius()
	return 400
end

function item_hd_shivas_staff:OnSpellStart()
	
	local pos = self:GetCursorPosition()
	self:FrozenEffect(pos)
end

function item_hd_shivas_staff:FrozenEffect(pos)
	local caster = self:GetCaster()
	-- local caster_pos = caster:GetOrigin()
	local particle_cast_fx = ParticleManager:CreateParticle("particles/rebuild/items/ice_blast/effect.vpcf", PATTACH_WORLDORIGIN , caster)
	ParticleManager:SetParticleControl(particle_cast_fx, 0, pos)
	ParticleManager:SetParticleControl(particle_cast_fx, 1, Vector(400,0,0))
	DestroyParticleByDelay(particle_cast_fx,4)
	for i = 1, 6, 1 do
		local new_pos = RotatePosition(pos+caster:GetForwardVector()*200, QAngle(0, 60*i, 0), pos)
		local particle_cast_fx = ParticleManager:CreateParticle("particles/rebuild/items/ice_blast/effect.vpcf", PATTACH_WORLDORIGIN , caster)
		ParticleManager:SetParticleControl(particle_cast_fx, 0, new_pos)
		ParticleManager:SetParticleControl(particle_cast_fx, 1, Vector(400,0,0))
		DestroyParticleByDelay(particle_cast_fx,4)
	end
	-- ParticleManager:ReleaseParticleIndex(particle_cast_fx)
	

	caster:EmitSound("Hero_Crystal.CrystalNova")
	local enemies = FindUnitsInRadius(
	caster:GetTeamNumber(),	-- int, your team number
	pos,	-- point, center point
	nil,	-- handle, cacheUnit. (not known)
	400,	-- float, radius. or use FIND_UNITS_EVERYWHERE
	DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
	DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
	DOTA_UNIT_TARGET_FLAG_NONE,	-- int, flag filter
	FIND_CLOSEST,	-- int, order filter
	false	-- bool, can grow cache
	)


	local damage_table = {attacker = self:GetCaster(), damage = 1800+caster:GetIntellect(false)*18, damage_type = DAMAGE_TYPE_MAGICAL, ability = self}
	for i,unit in pairs(enemies) do
		damage_table.victim = unit
		ApplyDamage(damage_table)
		-- unit:AddNewModifier(caster, self, "modifier_item_hd_shivas_staff_frozen", {duration = 1})
		unit:AddNewModifier(caster, self, "modifier_item_hd_shivas_staff_debuff", {duration = 6})
	end
end



modifier_item_hd_shivas_staff = advanced_modifier({})

function modifier_item_hd_shivas_staff:IsDebuff() return false end
function modifier_item_hd_shivas_staff:IsHidden() return true end
function modifier_item_hd_shivas_staff:IsPurgable() return false end
function modifier_item_hd_shivas_staff:IsPurgeException() return false end
function modifier_item_hd_shivas_staff:RemoveOnDeath() return false end


function modifier_item_hd_shivas_staff:OnCreated(keys)
    self.ability = self:GetAbility()
	self.bonus_int = self.ability:GetSpecialValueFor("bonus_int")
	self.bonus_spell_damage = self.ability:GetSpecialValueFor("bonus_spell_damage")
end

function modifier_item_hd_shivas_staff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
	}
end

function modifier_item_hd_shivas_staff:GetModifierBonusStats_Intellect() return self.bonus_int end
function modifier_item_hd_shivas_staff:Advanced_GetModifierSpellAmplifyBonus() return self.bonus_spell_damage end




function modifier_item_hd_shivas_staff:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS
    }
end



modifier_item_hd_shivas_staff_debuff = modifier_item_hd_shivas_staff_debuff or class({})

function modifier_item_hd_shivas_staff_debuff:IsDebuff()return true end
function modifier_item_hd_shivas_staff_debuff:IsPurgable()return true end
function modifier_item_hd_shivas_staff_debuff:GetTexture() return "item_shivas_staff" end
function modifier_item_hd_shivas_staff_debuff:OnCreated()
	


	self.frozen = true
	self:StartIntervalThink(1)

end


function modifier_item_hd_shivas_staff_debuff:OnRefresh(keys)

	self.frozen = true
	self:StartIntervalThink(1)
end


function modifier_item_hd_shivas_staff_debuff:OnIntervalThink()
	self.frozen  = false
	
end

function modifier_item_hd_shivas_staff_debuff:CheckState()
	local state = {}
	if self.frozen then  
		state = {
			[MODIFIER_STATE_FROZEN] = true,
			[MODIFIER_STATE_STUNNED] = true
		}
	end

	return state
end

function modifier_item_hd_shivas_staff_debuff:DeclareFunctions()    return {MODIFIER_PROPERTY_DISABLE_HEALING,}end
function modifier_item_hd_shivas_staff_debuff:GetDisableHealing()	return 1 end

