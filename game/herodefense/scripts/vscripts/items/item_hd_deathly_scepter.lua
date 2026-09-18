item_hd_deathly_scepter = class({})
-- LinkLuaModifier("modifier_item_hd_deathly_scepter_arua", "items/item_hd_deathly_scepter", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_deathly_scepter_arua_effect", "items/item_hd_deathly_scepter", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_deathly_scepter", "items/item_hd_deathly_scepter", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_deathly_scepter_active", "items/item_hd_deathly_scepter", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_deathly_scepter_effect", "items/item_hd_deathly_scepter", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_deathly_scepter_effect2", "items/item_hd_deathly_scepter", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_deathly_scepter_active_standby", "items/item_hd_deathly_scepter", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_deathly_scepter_debuff", "items/item_hd_deathly_scepter", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_deathly_scepter_thinker", "items/item_hd_deathly_scepter", LUA_MODIFIER_MOTION_NONE)



-- Item Passive
-- require('internal/timers')   --计时器功能
function item_hd_deathly_scepter:GetIntrinsicModifierName()
	return "modifier_item_hd_deathly_scepter"
end



function item_hd_deathly_scepter:OnSpellStart()

	local caster    =   self:GetCaster()
	local target = self:GetCursorTarget()
	caster:EmitSound("undying_undying_big_fleshgolem_08")
	target:AddNewModifier(caster, self, "modifier_item_hd_deathly_scepter_active", {duration = 6})

end





modifier_item_hd_deathly_scepter = advanced_modifier({})

function modifier_item_hd_deathly_scepter:IsDebuff() return false end
function modifier_item_hd_deathly_scepter:IsHidden() return true end
function modifier_item_hd_deathly_scepter:IsPurgable() return false end


function modifier_item_hd_deathly_scepter:OnCreated(keys)
    self.ability = self:GetAbility()

 
    local parent = self:GetParent()


	self.bonus_int = self.ability:GetSpecialValueFor("bonus_int")

	self.bonus_summon_intensity = self.ability:GetSpecialValueFor("bonus_summon_intensity")



end


function modifier_item_hd_deathly_scepter:DeclareFunctions()
	return {

		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,            --智力

	}
end

-- advanced_modifier
function modifier_item_hd_deathly_scepter:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_Summon_Intensity,
    }
end
function modifier_item_hd_deathly_scepter:Advanced_GetModifier_Summon_Intensity(keys)
	return self.bonus_summon_intensity 
end





function modifier_item_hd_deathly_scepter:GetModifierBonusStats_Intellect()	return self.bonus_int end

modifier_item_hd_deathly_scepter_active = class({})

function modifier_item_hd_deathly_scepter_active:IsDebuff() return true end
function modifier_item_hd_deathly_scepter_active:IsHidden() return false end
function modifier_item_hd_deathly_scepter_active:IsPurgable() return false end
function modifier_item_hd_deathly_scepter_active:GetTexture()return "item_deathly_scepter" end
function modifier_item_hd_deathly_scepter_active:GetEffectName() return "particles/econ/items/undying/undying_pale_augur/undying_pale_augur_decay_strength_buff.vpcf" end
function modifier_item_hd_deathly_scepter_active:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end



function modifier_item_hd_deathly_scepter_active:DeclareFunctions()
	return {
			MODIFIER_EVENT_ON_DEATH,                            --死亡
	}
end


function modifier_item_hd_deathly_scepter_active:OnDeath(keys)
    if not IsServer() then
        return
    end

    if keys.unit == self:GetParent() then
		local caster = self:GetCaster()
		local pos = keys.unit:GetAbsOrigin()
		local unitname = "npc_hd_skeleton_archer"
		local damage_index = 1.2
		local health_index = 1
		if caster:GetStrength()>caster:GetAgility() then
			unitname = "npc_hd_skeleton_archer_warrior"
			damage_index = 1
			health_index = 1.2	
		end

		local life_duration = self:GetAbility():GetSpecialValueFor("duration")
		if life_duration<=0 then
			return
		end
		local pfx_name = "particles/units/heroes/hero_undying/undying_tombstone_spawn.vpcf"
		local pfx = ParticleManager:CreateParticle(pfx_name, PATTACH_ABSORIGIN, keys.unit)
		ParticleManager:SetParticleControl(pfx, 0, keys.unit:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(pfx)
		local caster_damage = caster:GetBaseDamageMax()
		local caster_health = caster:GetMaxHealth()
		local caster_armor = caster:GetPhysicalArmorValue(false)
		local damage = (math.min(keys.unit:GetBaseDamageMax()*0.5,caster_damage*2)+caster:GetBaseDamageMax())*0.5*damage_index
		local health = (math.min(keys.unit:GetMaxHealth()*0.5,caster_health*2)+caster:GetMaxHealth())*0.5*health_index
		local armor = (math.min(keys.unit:GetPhysicalArmorValue(false)*0.5,caster_armor*2)+caster:GetPhysicalArmorValue(false))*0.5
		-- local mana = (keys.unit:GetMaxMana()+caster:GetMaxMana())*0.5


		local unit = caster:SummonUnit(unitname,life_duration,keys.unit:GetAbsOrigin(),nil,self:GetAbility(),0,health,0,damage,armor,1,1)
		unit:EmitSound("undying_undying_big_laugh_06")


        

    end
   
end
