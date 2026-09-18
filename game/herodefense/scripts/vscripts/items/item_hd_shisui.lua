item_hd_shisui = class({})
-- LinkLuaModifier("modifier_item_hd_shisui_arua", "items/item_hd_shisui", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_shisui_arua_effect", "items/item_hd_shisui", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_shisui", "items/item_hd_shisui", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_shisui_active", "items/item_hd_shisui", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_shisui_debuff", "items/item_hd_shisui", LUA_MODIFIER_MOTION_NONE)


function item_hd_shisui:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/items/shisui/water_gush1.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/items/shisui/water_gush2.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/items/shisui/water_gush3.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/items/shisui/water_gush4.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/items/shisui/water_gush5.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/items/shisui/water_gush6.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/items/shisui/water_gush7.vpcf", context )


end
function item_hd_shisui:GetIntrinsicModifierName()
	return "modifier_item_hd_shisui"
end
function item_hd_shisui:OnProjectileHit(target, location)
	if not target then
		return
	end
	-- if keys.hit == 1 and target:TriggerStandardTargetSpell(self) then
	-- 	return true
	-- end
	target:EmitSound("Ability.GushImpact")
	target:AddNewModifier(target, self, "modifier_item_hd_shisui_debuff", {duration = 7})


end


modifier_item_hd_shisui = class({})

function modifier_item_hd_shisui:IsDebuff() return false end
function modifier_item_hd_shisui:IsHidden() return true end
function modifier_item_hd_shisui:IsPurgable() return false end
function modifier_item_hd_shisui:IsPurgeException() return false end
function modifier_item_hd_shisui:RemoveOnDeath() return false end

function modifier_item_hd_shisui:OnCreated(keys)
    local ability = self:GetAbility()
	self.bonus_damage = ability:GetSpecialValueFor("bonus_damage")
	self.bonus_attack_speed = ability:GetSpecialValueFor("bonus_attack_speed")
	if IsServer() then
		-- local parent = self:GetParent()
		self:StartIntervalThink(1)
	end
end


function modifier_item_hd_shisui:DeclareFunctions()
	local funcs = {

		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,           --攻击力
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}

	return funcs
end


function modifier_item_hd_shisui:GetModifierPreAttack_BonusDamage()
	return self.bonus_damage
end


function modifier_item_hd_shisui:GetModifierAttackSpeedBonus_Constant()
	return self.bonus_attack_speed
end

function modifier_item_hd_shisui:OnAttackLanded(keys)
	if not IsServer() then return end
	if keys.attacker ~= self:GetParent() then
		return
	end
	if not keys.attacker:IsApplyModifier() then
		return
	end
	local parent = self:GetParent()
	if parent:GetRandomEffect(13,INT_TYPE,1)  > RandomInt(1, 100) then
		local info = 
		{
			Target = keys.target,
			Source = parent,
			Ability = self:GetAbility(),	
			EffectName = "particles/rebuild/items/shisui/water_gush"..RandomInt(1, 7)..".vpcf",
			iMoveSpeed = 3000,
			-- vSourceLoc = caster:GetAbsOrigin(),
			bDrawsOnMinimap = false,  --？？
			bDodgeable = true,   --可躲闪
			bIsAttack = false,   --攻击效果
			bVisibleToEnemies = true,  --对敌人可视
			bReplaceExisting = false, --替换现有的
			flExpireTime = GameRules:GetGameTime() + 10, --存在时间
			bProvidesVision = false, --提供视野
			-- ExtraData = {hit = i}   --额外的数据
		}
		ProjectileManager:CreateTrackingProjectile(info)
		parent:EmitSound("Ability.GushCast")
		parent:AddNewModifier(parent, self:GetAbility(), "modifier_item_hd_shisui_active", {duration = 2})

	end

	
end






modifier_item_hd_shisui_active =modifier_item_hd_shisui_active or  class({})

function modifier_item_hd_shisui_active:IsDebuff()	return false end
function modifier_item_hd_shisui_active:IsHidden()	return true end
function modifier_item_hd_shisui_active:IsPurgable() return false end
function modifier_item_hd_shisui_active:IsPurgeException() return false end
function modifier_item_hd_shisui_active:DeclareFunctions()	return 
	{
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_PROJECTILE_SPEED_BONUS
	} 
end
function modifier_item_hd_shisui_active:OnCreated(keys)
	if IsServer() then
		self.bonus_speed = 800
	end
end
function modifier_item_hd_shisui_active:GetModifierAttackSpeedBonus_Constant(keys)
	return self.bonus_speed
end
function modifier_item_hd_shisui_active:GetModifierProjectileSpeedBonus(keys)
	return 6000
end
function modifier_item_hd_shisui_active:OnAttackLanded(keys)
	if not IsServer() then
		return 
	end
	local caster = self:GetCaster()
	if keys.attacker ~= caster then
		return
	end

	self:DecrementStackCount()
	if self:GetStackCount()<=0 then
		self:SafeDestroy()
	end
	
end






modifier_item_hd_shisui_debuff = advanced_modifier({})

function modifier_item_hd_shisui_debuff:IsHidden()	return false end
function modifier_item_hd_shisui_debuff:IsDebuff()	return true end
function modifier_item_hd_shisui_debuff:IsPurgable()	return false end
function modifier_item_hd_shisui_debuff:OnCreated(params)
	self.ability = self:GetAbility()
	if IsServer() then
		self.tData = {}
		table.insert(self.tData, { dieTime = self:GetDieTime() })
		self:IncrementStackCount()
		self:StartIntervalThink(0.1)
		
		-- self.bonus_armor = self.ability:GetSpecialValueFor("bonus_armor")
		-- self.bonus_health_regeneration = self.ability:GetSpecialValueFor("bonus_health_regeneration")
	end
end
function modifier_item_hd_shisui_debuff:OnRefresh(params)
	if IsServer() then
		local dieTime = self:GetDieTime()
		if self:GetStackCount()>= (20) then
			--移除第一个 添加一个
			table.remove(self.tData, 1)
			table.insert(self.tData, {dieTime = dieTime })

		else
			--当叠加乘数没达到最高时
			table.insert(self.tData, {dieTime = dieTime })
			self:IncrementStackCount()
		end
	end
end

function modifier_item_hd_shisui_debuff:OnIntervalThink()
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


function modifier_item_hd_shisui_debuff:DeclareFunctions()
	return { MODIFIER_PROPERTY_TOOLTIP}
end

function modifier_item_hd_shisui_debuff:OnTooltip()
    return self:Advanced_GetModifierPhysicalArmorBonus()
end

-- advanced_modifier

function modifier_item_hd_shisui_debuff:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }
end
function modifier_item_hd_shisui_debuff:Advanced_GetModifierPhysicalArmorBonus()
    return -2*self:GetStackCount()
end

