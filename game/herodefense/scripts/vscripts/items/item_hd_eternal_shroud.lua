item_hd_eternal_shroud = class({})
-- LinkLuaModifier("modifier_item_hd_eternal_shroud_arua", "items/item_hd_eternal_shroud", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_eternal_shroud", "items/item_hd_eternal_shroud", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_eternal_shroud_disarm", "items/item_hd_eternal_shroud", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_eternal_shroud_active_lifesteal", "items/item_hd_eternal_shroud", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_eternal_shroud_active_shield", "items/item_hd_eternal_shroud", LUA_MODIFIER_MOTION_NONE)

-- Item Passive
function item_hd_eternal_shroud:GetIntrinsicModifierName()
	return "modifier_item_hd_eternal_shroud"
end


function item_hd_eternal_shroud:OnSpellStart()
	local duration = self:GetSpecialValueFor("duration")
	local target = self:GetCursorTarget()
	local caster = self:GetCaster()
	local ModifierStatusGain =  caster:GetModifierDurationGainIndex(1)
	EmitSoundOn("Hero_OgreMagi.FireShield.Target", self:GetCaster())
	-- caster:Purge(false, true, false, false, false)
	caster:AddNewModifier(caster, self, "modifier_item_hd_eternal_shroud_active_shield", {duration = duration*ModifierStatusGain,index=caster:GetIntellect(false)*7+800})
end






-- modifier_item_hd_eternal_shroud_arua = class({})

-- function modifier_item_hd_eternal_shroud_arua:IsHidden() return true end
-- function modifier_item_hd_eternal_shroud_arua:IsAura() return true end
-- function modifier_item_hd_eternal_shroud_arua:GetAuraDuration() return 0.5 end
-- function modifier_item_hd_eternal_shroud_arua:GetModifierAura() return "modifier_item_hd_eternal_shroud" end
-- function modifier_item_hd_eternal_shroud_arua:GetAuraRadius() return self:GetAbility():GetSpecialValueFor("aura_radius") end
-- function modifier_item_hd_eternal_shroud_arua:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
-- function modifier_item_hd_eternal_shroud_arua:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
-- function modifier_item_hd_eternal_shroud_arua:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end











modifier_item_hd_eternal_shroud = advanced_modifier({})

function modifier_item_hd_eternal_shroud:IsDebuff() return false end
function modifier_item_hd_eternal_shroud:IsHidden() return true end
function modifier_item_hd_eternal_shroud:IsPurgable() return false end
-- function modifier_item_hd_eternal_shroud:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end



function modifier_item_hd_eternal_shroud:OnCreated(keys)
    self.ability = self:GetAbility()

	self.bonus_life_steal = self.ability:GetSpecialValueFor("bonus_life_steal")*0.01  --在这里先计算就不用每次攻击都浪费一次计算了
	self.bonus_health_regeneration = self.ability:GetSpecialValueFor("bonus_health_regeneration")
	self.bonus_magic_resistance = self.ability:GetSpecialValueFor("bonus_magic_resistance")


end



function modifier_item_hd_eternal_shroud:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,       --魔法抗性
		MODIFIER_EVENT_ON_TAKEDAMAGE,                     --受到伤害事件

	}
end

function modifier_item_hd_eternal_shroud:AdvancedGetModifierConstantManaRegen()
	return self.bonus_health_regeneration
end

function modifier_item_hd_eternal_shroud:GetModifierMagicalResistanceBonus() return self.bonus_magic_resistance end



function modifier_item_hd_eternal_shroud:OnTakeDamage(tg)
    if IsServer() then   
		local Ability = tg.inflictor
		--初始判断 满足以下:
		--造成伤害者是状态携带者
		--伤害者不是幻象
		--伤害类型是技能伤害
		--不带反甲伤害标签
		--不带不造成吸血标签
		-- print("tg.damage_category="..tg.damage_category)
		local parent = self:GetParent()

        if tg.attacker==parent 
		and not parent:IsIllusion() 
		and tg.damage_category==DOTA_DAMAGE_CATEGORY_SPELL
		and bit.band( tg.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION ) ~= DOTA_DAMAGE_FLAG_REFLECTION 
		and  bit.band( tg.damage_flags, DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL ) ~= DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL then 

			--该生命吸血受到吸血增强影响
            local life_steal_gain = parent:GetModifierLifeStealGain(1)
			local hp = 0
			hp=tg.damage*self.bonus_life_steal*life_steal_gain
            hp = hp-hp%1
			-- print("hp="..hp)
			if hp<=0 then return end   --没有吸血效果了就不执行了

			if Ability then
				local nFXIndex = ParticleManager:CreateParticle( "particles/items3_fx/octarine_core_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, tg.attacker )
				ParticleManager:ReleaseParticleIndex( nFXIndex )
			else
				local nFXIndex = ParticleManager:CreateParticle( "particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, tg.attacker )
				ParticleManager:ReleaseParticleIndex( nFXIndex )
			end
            parent:Heal(hp, self.ability)

        end 
    end 
end



function modifier_item_hd_eternal_shroud:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,

    }
end

modifier_item_hd_eternal_shroud_active_shield = advanced_modifier({})
function modifier_item_hd_eternal_shroud_active_shield:IsHidden() return false end
function modifier_item_hd_eternal_shroud_active_shield:IsDebuff() return false end
function modifier_item_hd_eternal_shroud_active_shield:IsPurgable() return false end
function modifier_item_hd_eternal_shroud_active_shield:IsPurgeException() return false end
function modifier_item_hd_eternal_shroud_active_shield:IsStunDebuff() return false end
function modifier_item_hd_eternal_shroud_active_shield:AllowIllusionDuplicate() return false end
function modifier_item_hd_eternal_shroud_active_shield:GetTexture()return "item_eternal_shroud" end
function modifier_item_hd_eternal_shroud_active_shield:StatusEffectPriority() return MODIFIER_PRIORITY_NORMAL end

function modifier_item_hd_eternal_shroud_active_shield:OnCreated(keys)


    if not IsServer() then
        return
    end
    self.pfx = ParticleManager:CreateParticle("particles/new_effect/new_effect/electrostatic_armor_shield_edge.vpcf", PATTACH_POINT_FOLLOW, self:GetParent())
    ParticleManager:SetParticleControlEnt(self.pfx, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
    local ex = self:GetParent():GetModelScale() * 100
    ParticleManager:SetParticleControl(self.pfx, 1, Vector(ex,ex,ex))
    self:AddParticle(self.pfx, false, false, 15, false, false)
	-- print("keys.index="..keys.index)
    self:SetStackCount(keys.index)
    self:StartIntervalThink(0.2)
end

function modifier_item_hd_eternal_shroud_active_shield:OnRefresh(keys)
    if not IsServer() then
        return
    end
	self:SetStackCount(keys.index)
    -- self:SetStackCount(self:GetStackCount()+keys.index)
end


function modifier_item_hd_eternal_shroud_active_shield:ADDeclareFunctions()
	return {
		MODIFIER_SPECIAL_CALCULATE_TOTAL_CONSTANT_BLOCK = {nil, self:GetParent()},
		advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS
	}
end


function modifier_item_hd_eternal_shroud_active_shield:AdvancedGetModifierTotal_ConstantBlock(keys)
	if not IsServer() then
		return 0 
	end
	if keys.block_disabled then
        return 0 
    end

	if keys.damage_type~=DAMAGE_TYPE_MAGICAL then
		return 0
	end
	local stack = self:GetStackCount()
    --计算护盾值
	if keys.damage >  self:GetStackCount()then
		self:SetStackCount(0)
	else
        self:SetStackCount(self:GetStackCount()- math.max(0, keys.damage))
        stack=keys.damage
	end
	return stack

end



function modifier_item_hd_eternal_shroud_active_shield:OnDestroy()
    if not IsServer() then
        return
    end
    -- print("destroy")
end

function modifier_item_hd_eternal_shroud_active_shield:OnIntervalThink()
    if not IsServer() then
        return
    end
    if self:GetStackCount()<=0 then
		-- print("destroying")
        self:SafeDestroy()
        ParticleManager:DestroyParticle(self.pfx, true)
    end
end




function modifier_item_hd_eternal_shroud_active_shield:Advanced_GetModifierSpellAmplifyBonus()
    return 15
end