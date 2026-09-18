item_hd_book_of_death_2 = class({})

LinkLuaModifier("modifier_item_hd_book_of_death_2", "items/item_hd_book_of_death_2", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_book_of_death_2_active", "items/item_hd_book_of_death_2", LUA_MODIFIER_MOTION_NONE)


-- Item Passive
-- require('internal/timers')   --计时器功能
function item_hd_book_of_death_2:GetIntrinsicModifierName()
	return "modifier_item_hd_book_of_death_2"
end



function item_hd_book_of_death_2:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_visage/visage_soul_assumption_bolt1.vpcf", context )

end






function item_hd_book_of_death_2:InsertSummon(unit)
	if not self.summon_table then
		self.summon_table = {}
	end
	self.summon_table[unit] = true
end

function item_hd_book_of_death_2:RemoveSummon(unit)
	self.summon_table[unit] = nil
end
function item_hd_book_of_death_2:GetSummonList()
	if not self.summon_table then
		self.summon_table = {}
	end
	return self.summon_table
end

function item_hd_book_of_death_2:OnProjectileHit(target, location)
	if not target then
		return
	end
	-- if keys.hit == 1 and target:TriggerStandardTargetSpell(self) then
	-- 	return true
	-- end
	target:EmitSound("Hero_Visage.SoulAssumption.Target")
	local modifier = target:FindModifierByName("modifier_item_hd_book_of_death_2_active")
	if modifier then
		modifier:AddStack()
	end

end







modifier_item_hd_book_of_death_2 = advanced_modifier({})

function modifier_item_hd_book_of_death_2:IsDebuff() return false end
function modifier_item_hd_book_of_death_2:IsHidden() return true end
function modifier_item_hd_book_of_death_2:IsPurgable() return false end
function modifier_item_hd_book_of_death_2:IsPurgeException() return false end
function modifier_item_hd_book_of_death_2:RemoveOnDeath() return false end


function modifier_item_hd_book_of_death_2:OnCreated(keys)
    local ability = self:GetAbility()
    local parent = self:GetParent()
	self.bonus_summon_intensity =ability:GetSpecialValueFor("bonus_summon_intensity")
	self.bonus_health =ability:GetSpecialValueFor("bonus_health")

end



function modifier_item_hd_book_of_death_2:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_HEALTH_BONUS, 
		MODIFIER_EVENT_ON_DEATH

	}
end


function modifier_item_hd_book_of_death_2:GetModifierHealthBonus()	return self.bonus_health end
function modifier_item_hd_book_of_death_2:OnSummonUnit(keys)
	if IsServer() then
		local unit = keys.target
		if unit:IsUndead() then
			
			unit:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_item_hd_book_of_death_2_active", {})

		end
	end
end
function modifier_item_hd_book_of_death_2:OnDeath(keys)
    if not IsServer() then
        return
    end
	local ability = self:GetAbility()
	if not ability then
		return
	end
    if keys.unit ~= self:GetParent() and CalculateDistance(keys.unit,self:GetParent())<=1000 then
		local parent = self:GetParent()
		-- local target = keys.attacker
		local ability = self:GetAbility()
		local info = 
		{
			-- Target = enemy,
			Source = parent,
			Ability = ability,	
			EffectName = "particles/units/heroes/hero_visage/visage_soul_assumption_bolt1.vpcf",
			iMoveSpeed = 2000,
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
		
		local list = ability:GetSummonList()
		for key, value in pairs(list) do
			if not key:IsNull() and key:IsAlive() then
				info.Target = key
				ProjectileManager:CreateTrackingProjectile(info)
			end

		end

    end


end

-- advanced_modifier
function modifier_item_hd_book_of_death_2:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_Summon_Intensity,
    }
end
function modifier_item_hd_book_of_death_2:Advanced_GetModifier_Summon_Intensity(keys)
	return self.bonus_summon_intensity 
end

modifier_item_hd_book_of_death_2_active = class({})

function modifier_item_hd_book_of_death_2_active:IsDebuff() return false end
function modifier_item_hd_book_of_death_2_active:IsHidden() return false end
function modifier_item_hd_book_of_death_2_active:IsPurgable() return false end
function modifier_item_hd_book_of_death_2_active:GetTexture() return "item_book_of_death_2" end

function modifier_item_hd_book_of_death_2_active:OnCreated(keys)
	if IsServer() then
		self:GetAbility():InsertSummon(self:GetParent())
	end

end

function modifier_item_hd_book_of_death_2_active:OnDestroy()
	if IsServer() then
		self:GetAbility():RemoveSummon(self:GetParent())
	end

end

function modifier_item_hd_book_of_death_2_active:AddStack()
	self:SetStackCount(math.min(self:GetStackCount()+4,100))
end





function modifier_item_hd_book_of_death_2_active:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,   


	}
end


function modifier_item_hd_book_of_death_2_active:GetModifierDamageOutgoing_Percentage()	return self:GetStackCount() end
