item_hd_yulsarias_glacier = class({})
-- LinkLuaModifier("modifier_item_hd_yulsarias_glacier_arua", "items/item_hd_yulsarias_glacier", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_yulsarias_glacier_arua_effect", "items/item_hd_yulsarias_glacier", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_yulsarias_glacier", "items/item_hd_yulsarias_glacier", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_yulsarias_glacier_active", "items/item_hd_yulsarias_glacier", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_yulsarias_glacier_active2", "items/item_hd_yulsarias_glacier", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_yulsarias_glacier_debuff", "items/item_hd_yulsarias_glacier", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_yulsarias_glacier_buff", "items/item_hd_yulsarias_glacier", LUA_MODIFIER_MOTION_NONE)


-- Item Passive
-- require('internal/timers')   --计时器功能
function item_hd_yulsarias_glacier:GetIntrinsicModifierName()
	return "modifier_item_hd_yulsarias_glacier"
end
function item_hd_yulsarias_glacier:Precache( context )
	PrecacheResource( "particle", "particles/econ/items/ancient_apparition/aa_blast_ti_5/ancient_apparition_ice_blast_explode_ti5.vpcf", context )

end



function item_hd_yulsarias_glacier:OnSpellStart()

	local caster    =   self:GetCaster()
	-- local target = self:GetCursorTarget()
	-- if target:GetTeamNumber()==caster:GetTeamNumber() then
	-- 	target:AddNewModifier(caster, self, "modifier_item_hd_yulsarias_glacier_active", {duration = 5})
	-- else
	-- 	target:AddNewModifier(caster, self, "modifier_item_hd_yulsarias_glacier_active2", {duration = 5})
	-- end
	caster:EmitSound("Hero_Crystal.CrystalNova.Yulsaria")
	caster:AddNewModifier(caster, self, "modifier_item_hd_yulsarias_glacier_debuff", {duration = 5})


	local particle_cast_fx = ParticleManager:CreateParticle("particles/econ/items/ancient_apparition/aa_blast_ti_5/ancient_apparition_ice_blast_explode_ti5.vpcf", PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControl(particle_cast_fx, 0, caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(particle_cast_fx, 1, caster:GetAbsOrigin())
	DestroyParticleByDelay(particle_cast_fx,2)
end




modifier_item_hd_yulsarias_glacier = advanced_modifier({})

function modifier_item_hd_yulsarias_glacier:IsDebuff() return false end
function modifier_item_hd_yulsarias_glacier:IsHidden() return true end
function modifier_item_hd_yulsarias_glacier:IsPurgable() return false end



function modifier_item_hd_yulsarias_glacier:OnCreated(keys)
    self.ability = self:GetAbility()


	self.bonus_int = self.ability:GetSpecialValueFor("bonus_int")


	self.bonus_health = self.ability:GetSpecialValueFor("bonus_health")
	
	self.bonus_armor = self.ability:GetSpecialValueFor("bonus_armor")
	
end


function modifier_item_hd_yulsarias_glacier:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,            --智力
		MODIFIER_PROPERTY_HEALTH_BONUS,                     --生命值
	}
end


function modifier_item_hd_yulsarias_glacier:GetModifierBonusStats_Intellect()	return self.bonus_int end
function modifier_item_hd_yulsarias_glacier:GetModifierHealthBonus()	return self.bonus_health end

function modifier_item_hd_yulsarias_glacier:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }
end
function modifier_item_hd_yulsarias_glacier:Advanced_GetModifierPhysicalArmorBonus()
    return self.bonus_armor
end

modifier_item_hd_yulsarias_glacier_active = class({})

-- function modifier_item_hd_yulsarias_glacier_active:IsDebuff() return false end
function modifier_item_hd_yulsarias_glacier_active:IsHidden() return false end
function modifier_item_hd_yulsarias_glacier_active:IsPurgable() return false end
function modifier_item_hd_yulsarias_glacier_active:IsPurgeException() return true end
function modifier_item_hd_yulsarias_glacier_active:GetTexture()return "item_yulsarias_glacier" end
function modifier_item_hd_yulsarias_glacier_active:GetEffectName() return "particles/generic_gameplay/generic_frozen.vpcf" end
function modifier_item_hd_yulsarias_glacier_active:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_item_hd_yulsarias_glacier_active:DeclareFunctions()
	return {

		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,       --攻击速度
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,       --移动速度百分比
	
		

	}
end


function modifier_item_hd_yulsarias_glacier_active:GetModifierAttackSpeedBonus_Constant() 	return -10000 end
function modifier_item_hd_yulsarias_glacier_active:GetModifierMoveSpeedBonus_Percentage()	return -1000 end

function modifier_item_hd_yulsarias_glacier_active:OnCreated(keys)
	if IsServer() then
		self.mana = self:GetCaster():GetIntellect(false)*0.5
		self:StartIntervalThink(1)
	end
end


function modifier_item_hd_yulsarias_glacier_active:OnIntervalThink()
	if IsServer() then
		self:GetParent():GiveMana(self.mana)
	end
end




modifier_item_hd_yulsarias_glacier_active2 = class({})

function modifier_item_hd_yulsarias_glacier_active:IsDebuff() return true end
function modifier_item_hd_yulsarias_glacier_active2:IsHidden() return false end
function modifier_item_hd_yulsarias_glacier_active2:IsPurgable() return false end
function modifier_item_hd_yulsarias_glacier_active2:IsPurgeException() return true end
function modifier_item_hd_yulsarias_glacier_active2:GetTexture()return "item_yulsarias_glacier" end
function modifier_item_hd_yulsarias_glacier_active2:GetEffectName() return "particles/generic_gameplay/generic_frozen.vpcf" end
function modifier_item_hd_yulsarias_glacier_active2:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_item_hd_yulsarias_glacier_active2:DeclareFunctions()
	return {

		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,       --攻击速度
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,       
	
		

	}
end


function modifier_item_hd_yulsarias_glacier_active2:GetModifierAttackSpeedBonus_Constant() 	return 100 end
function modifier_item_hd_yulsarias_glacier_active2:GetModifierMoveSpeedBonus_Constant()	return 120 end


function modifier_item_hd_yulsarias_glacier_active2:CheckState()
	local state = {
		[MODIFIER_STATE_SILENCED] = true
	}
	


	return state
end




modifier_item_hd_yulsarias_glacier_debuff = class({})

function modifier_item_hd_yulsarias_glacier_debuff:IsDebuff() return true end
function modifier_item_hd_yulsarias_glacier_debuff:IsHidden() return false end
function modifier_item_hd_yulsarias_glacier_debuff:IsPurgable() return true end
function modifier_item_hd_yulsarias_glacier_debuff:GetTexture()return "item_yulsarias_glacier" end
function modifier_item_hd_yulsarias_glacier_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,     


	}
end
function modifier_item_hd_yulsarias_glacier_debuff:GetModifierSpellAmplify_Percentage() return -150 end
function modifier_item_hd_yulsarias_glacier_debuff:OnDestroy()
	if IsServer() then
		self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_item_hd_yulsarias_glacier_buff", {duration = 5})
	end
end

modifier_item_hd_yulsarias_glacier_buff = advanced_modifier({})

function modifier_item_hd_yulsarias_glacier_buff:IsDebuff() return false end
function modifier_item_hd_yulsarias_glacier_buff:IsHidden() return false end
function modifier_item_hd_yulsarias_glacier_buff:IsPurgable() return true end
function modifier_item_hd_yulsarias_glacier_buff:GetTexture()return "item_yulsarias_glacier" end

function modifier_item_hd_yulsarias_glacier_buff:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS
    }
end
function modifier_item_hd_yulsarias_glacier_buff:Advanced_GetModifierSpellAmplifyBonus() return 80 end
