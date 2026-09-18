item_hd_rose_scepter = class({})

LinkLuaModifier("modifier_item_hd_rose_scepter", "items/item_hd_rose_scepter", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_rose_scepter_active", "items/item_hd_rose_scepter", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_item_hd_rose_scepter_thinker", "items/item_hd_rose_scepter", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_item_hd_rose_scepter_debuff", "items/item_hd_rose_scepter", LUA_MODIFIER_MOTION_NONE)




function item_hd_rose_scepter:GetIntrinsicModifierName()
	return "modifier_item_hd_rose_scepter"
end
function item_hd_rose_scepter:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/spell/rose_scepter/effect_parent.vpcf", context )
end


function item_hd_rose_scepter:OnSpellStart()
	local caster = self:GetCaster()
	CreateModifierThinker(caster, self, "modifier_item_hd_rose_scepter_thinker", {duration = 15}, self:GetCursorPosition(), caster:GetTeamNumber(), false)
end


modifier_item_hd_rose_scepter = advanced_modifier({})

function modifier_item_hd_rose_scepter:IsDebuff() return false end
function modifier_item_hd_rose_scepter:IsHidden() return true end
function modifier_item_hd_rose_scepter:IsPurgable() return false end
function modifier_item_hd_rose_scepter:IsPurgeException() return false end
function modifier_item_hd_rose_scepter:RemoveOnDeath() return false end


function modifier_item_hd_rose_scepter:OnCreated(keys)
    self.ability = self:GetAbility()
	self.bonus_int = self.ability:GetSpecialValueFor("bonus_int")
	self.bonus_spell_damage = self.ability:GetSpecialValueFor("bonus_spell_damage")
end

function modifier_item_hd_rose_scepter:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
	}
end

function modifier_item_hd_rose_scepter:GetModifierBonusStats_Intellect() return self.bonus_int end
function modifier_item_hd_rose_scepter:Advanced_GetModifierSpellAmplifyBonus() return self.bonus_spell_damage end


function modifier_item_hd_rose_scepter:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS
    }
end








modifier_item_hd_rose_scepter_thinker = class({})

function modifier_item_hd_rose_scepter_thinker:IsAura()return true end
function modifier_item_hd_rose_scepter_thinker:OnCreated(keys)
	if IsServer() then
		self.thinker = self:GetParent()
		self.radius			= 600
		self.thinker:EmitSound("Hero_DarkWillow.Bramble.Spawn")

		self.particle = ParticleManager:CreateParticle("particles/rebuild/spell/rose_scepter/effect_parent.vpcf", PATTACH_POINT_FOLLOW, self.thinker)
		ParticleManager:SetParticleControlEnt( self.particle, 0, self.thinker, PATTACH_POINT_FOLLOW, "" , self.thinker:GetOrigin(), true )
		ParticleManager:SetParticleControlEnt( self.particle, 2, self.thinker, PATTACH_POINT_FOLLOW, "" , self.thinker:GetOrigin(), true )
		ParticleManager:SetParticleControlEnt( self.particle, 3, self.thinker, PATTACH_POINT_FOLLOW, "" , self.thinker:GetOrigin(), true )
		ParticleManager:SetParticleControlEnt( self.particle, 5, self.thinker, PATTACH_POINT_FOLLOW, "" , self.thinker:GetOrigin(), true )
		ParticleManager:SetParticleControlEnt( self.particle, 9, self.thinker, PATTACH_POINT_FOLLOW, "" , self.thinker:GetOrigin(), true )
		ParticleManager:SetParticleControl(self.particle, 10, (Vector(self.radius, 0, 0)))
	end
end



function modifier_item_hd_rose_scepter_thinker:GetAuraRadius()return self.radius end
function modifier_item_hd_rose_scepter_thinker:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_item_hd_rose_scepter_thinker:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_item_hd_rose_scepter_thinker:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_item_hd_rose_scepter_thinker:GetModifierAura()return "modifier_item_hd_rose_scepter_debuff" end
function modifier_item_hd_rose_scepter_thinker:OnDestroy(keys)
	if IsServer() then
		ParticleManager:DestroyParticle(self.particle, false)
		ParticleManager:ReleaseParticleIndex(self.particle)
		UTIL_Remove(self:GetParent())
	end
end







modifier_item_hd_rose_scepter_debuff = modifier_item_hd_rose_scepter_debuff or class({})

function modifier_item_hd_rose_scepter_debuff:IsDebuff()return true end
function modifier_item_hd_rose_scepter_debuff:IsPurgable()return true end
function modifier_item_hd_rose_scepter_debuff:GetTexture() return "item_rose_scepter" end
-- function modifier_item_hd_rose_scepter_debuff:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_item_hd_rose_scepter_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,         --魔法抗性
	}
end


function modifier_item_hd_rose_scepter_debuff:GetModifierMagicalResistanceBonus() return -self:GetStackCount()  end



function modifier_item_hd_rose_scepter_debuff:OnCreated()
	--该技能需要从网表拿等级数据 自定义变量拿不到该值

	local ability = self:GetAbility()
	if not ability or ability:IsNull() then
		self:SafeDestroy()
		return
	end

	if not IsServer() then
		return
	end
	local caster = self:GetCaster()
	local bonus =math.floor( caster:GetSpellAmplification(false)/0.2)
	bonus = math.max(bonus,0)
	bonus = math.min(20,bonus)
	self:SetStackCount(20+bonus)

	self:StartIntervalThink(1)
	local caster = self:GetCaster()
	self.damageTable = {
		attacker	= caster,
		-- damage		= self.damage,
		victim = self:GetParent(),
		damage_type	= DAMAGE_TYPE_MAGICAL,
		ability		= ability,
	}
end




function modifier_item_hd_rose_scepter_debuff:OnIntervalThink()
	local ability = self:GetAbility()
	if not ability or ability:IsNull() then
		self:SafeDestroy()
		return
	end
	local caster = self:GetCaster()
	self.damageTable.damage = caster:GetIntellect(false) *1.5 + caster:GetMaxMana()*0.08
	ApplyDamage( self.damageTable)
	
end