creep_special_gain_Magic_Conversion = class({})
-- LinkLuaModifier("modifier_creep_special_gain_Magic_Conversion_arua", "skills/creep_special_gain_Magic_Conversion", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_creep_special_gain_Magic_Conversion_arua_effect", "skills/creep_special_gain_Magic_Conversion", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creep_special_gain_Magic_Conversion", "special_gain/creep_special_gain_Magic_Conversion", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creep_special_gain_Magic_Conversion_buff", "special_gain/creep_special_gain_Magic_Conversion", LUA_MODIFIER_MOTION_NONE)

-- Item Passive
-- require('internal/timers')   --计时器功能
function creep_special_gain_Magic_Conversion:GetIntrinsicModifierName()
	return "modifier_creep_special_gain_Magic_Conversion"
end


modifier_creep_special_gain_Magic_Conversion = class({})




function modifier_creep_special_gain_Magic_Conversion:IsHidden() 
	return true
end
function modifier_creep_special_gain_Magic_Conversion:IsPurgable() return false end
function modifier_creep_special_gain_Magic_Conversion:IsDebuff() return false end
-- function modifier_creep_special_gain_Magic_Conversion:GetEffectName() return "particles/rebuild/painful_last_wish/debuff.vpcf" end
-- function modifier_creep_special_gain_Magic_Conversion:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end

function modifier_creep_special_gain_Magic_Conversion:OnCreated(table)
	if IsServer() then
		local caster = self:GetCaster()
		-- self:SetStackCount(10)
		self.item = caster:AddItemByName("item_hd_revenants_brooch_player")
		self:StartIntervalThink(1)
	end
end

function modifier_creep_special_gain_Magic_Conversion:OnIntervalThink()
	if 5>=RandomInt(1, 100) then
		if self.item and not self.item:IsNull() then
			self.item:OnSpellStart()

			local parent = self:GetParent()
			parent:AddNewModifier(parent, self:GetAbility(), "modifier_creep_special_gain_Magic_Conversion_buff", {duration = 15})
		    local heroes = GetAllRealHeroes()
			for _, unit in ipairs(heroes) do
				if unit:IsAlive() and  unit:IsAttackImmune() then
					parent:MoveToTargetToAttack(unit)
					break
				end
			end
		end
	end
end







-- function modifier_creep_special_gain_Magic_Conversion:DeclareFunctions()
-- 	return {
-- 		MODIFIER_PROPERTY_PROCATTACK_CONVERT_PHYSICAL_TO_MAGICAL,
-- 		MODIFIER_PROPERTY_ALWAYS_ETHEREAL_ATTACK
-- 	}
-- end

-- function modifier_creep_special_gain_Magic_Conversion:GetModifierProcAttack_ConvertPhysicalToMagical()
-- 	return 1
-- end

-- function modifier_creep_special_gain_Magic_Conversion:GetAllowEtherealAttack()
-- 	return true
-- end


modifier_creep_special_gain_Magic_Conversion_buff = class({})
function modifier_creep_special_gain_Magic_Conversion_buff:IsHidden() 	return true end
function modifier_creep_special_gain_Magic_Conversion_buff:IsPurgable() return false end
function modifier_creep_special_gain_Magic_Conversion_buff:IsDebuff() return false end
function modifier_creep_special_gain_Magic_Conversion_buff:OnCreated(table)
	if IsServer() then
		self:StartIntervalThink(1)
	end
end

function modifier_creep_special_gain_Magic_Conversion_buff:OnIntervalThink()
	local parent = self:GetParent()
	local modifier = parent:FindModifierByName("modifier_item_hd_revenants_brooch_player")
	if not modifier then
		self:SafeDestroy()
		return
	end
	local heroes = GetAllRealHeroes()
	for _, unit in ipairs(heroes) do
		if unit:IsAlive() and unit:IsAttackImmune() then
			-- print("go2")
			parent:MoveToTargetToAttack(unit)
			break
		end
	end
end


function modifier_creep_special_gain_Magic_Conversion_buff:OnDestroy()
	if IsServer() then
		self:GetParent():Stop()
	end
end