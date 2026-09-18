item_hd_tears_of_aquastar = class({})

LinkLuaModifier("modifier_item_hd_tears_of_aquastar", "items/item_hd_tears_of_aquastar", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_tears_of_aquastar_active", "items/item_hd_tears_of_aquastar", LUA_MODIFIER_MOTION_NONE)

function item_hd_tears_of_aquastar:GetIntrinsicModifierName()
	return "modifier_item_hd_tears_of_aquastar"
end




function item_hd_tears_of_aquastar:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/items/tears_of_aquastar/effect_lvl5.vpcf", context )

end



function item_hd_tears_of_aquastar:OnSpellStart()

	local caster    =   self:GetCaster()
	local target = self:GetCursorTarget()

	if target:HasModifier("modifier_item_hd_tears_of_aquastar_active") then
		return
	end
	if self.modifier and not self.modifier:IsNull() then
		self.modifier:SafeDestroy()
	end
	target:EmitSound("DOTA_Item.HavocHammer.Cast")

	local particle = ParticleManager:CreateParticle("particles/rebuild/items/tears_of_aquastar/effect_lvl5.vpcf", PATTACH_POINT_FOLLOW, target)
	ParticleManager:SetParticleControl(particle, 0, target:GetAbsOrigin())
	DestroyParticleByDelay(particle,4)
	self.modifier = target:AddNewModifier(caster, self, "modifier_item_hd_tears_of_aquastar_active", {})
	

end





modifier_item_hd_tears_of_aquastar = class({})

function modifier_item_hd_tears_of_aquastar:IsDebuff() return false end
function modifier_item_hd_tears_of_aquastar:IsHidden() return true end
function modifier_item_hd_tears_of_aquastar:IsPurgable() 		return false end
function modifier_item_hd_tears_of_aquastar:IsPurgeException() 	return false end
function modifier_item_hd_tears_of_aquastar:RemoveOnDeath()  return false end


function modifier_item_hd_tears_of_aquastar:OnCreated(keys)
	self.bonus_health = self:GetAbility():GetSpecialValueFor("bonus_health")
end
function modifier_item_hd_tears_of_aquastar:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_HEALTH_BONUS,                     --生命值
	}
end


function modifier_item_hd_tears_of_aquastar:GetModifierHealthBonus()	return self.bonus_health end



modifier_item_hd_tears_of_aquastar_active = class({})

function modifier_item_hd_tears_of_aquastar_active:IsDebuff() return false end
function modifier_item_hd_tears_of_aquastar_active:IsHidden() return false end
function modifier_item_hd_tears_of_aquastar_active:IsPurgable() return false end
function modifier_item_hd_tears_of_aquastar_active:GetTexture()return "item_tears_of_aquastar" end
function modifier_item_hd_tears_of_aquastar_active:IsPurgeException() return false end
function modifier_item_hd_tears_of_aquastar_active:RemoveOnDeath() return false end
function modifier_item_hd_tears_of_aquastar_active:OnCreated(keys)
	if IsServer() then
		self:StartIntervalThink(0.2)
	end
end
function modifier_item_hd_tears_of_aquastar_active:OnIntervalThink()
	local ability = self:GetAbility()
	if not ability then
		self:SafeDestroy()
		return
	end
end
function modifier_item_hd_tears_of_aquastar_active:GetModifierIncomingDamage_Percentage(keys)
	if not IsServer() then
		return
	end
	local parent = self:GetParent()
	local ability = self:GetAbility()
	if not ability then
		self:SafeDestroy()
		return
	end

	if keys.damage >=  parent:GetHealth()*0.5 then
		if ability:GetCurrentCharges()<=0 then
			if  50>=RandomInt(1, 100)  then
				return -25
			end
			return 0
		end
		local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_omniknight/omniknight_purification_hit.vpcf", PATTACH_ABSORIGIN, parent)
		ParticleManager:SetParticleControl(pfx, 0, parent:GetAbsOrigin())
		ParticleManager:SetParticleControl(pfx, 1, parent:GetAbsOrigin())

		ParticleManager:ReleaseParticleIndex(pfx)
		--SpendCharge用不了不知道为啥
		ability:SetCurrentCharges(ability:GetCurrentCharges()-1)
		return -1000
	end
	return 0
end



function modifier_item_hd_tears_of_aquastar_active:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_TAKEDAMAGE,                       --受到伤害事件

	}
end



function modifier_item_hd_tears_of_aquastar_active:OnTakeDamage(keys)
    if IsServer() then  
		if keys.unit == self:GetParent() then
			if keys.damage<=0 then	return	end
			-- print("take damage")
			if keys.unit:GetHealth()<=0 then

				local ability = self:GetAbility()
				local charge = ability:GetCurrentCharges()
				if charge<=0 then
					if  15>=RandomInt(1, 100)  then
						--do nothing 
					else
						return 
					end
				else
					ability:SetCurrentCharges(charge-1)
				end

				local parent = self:GetParent()
				local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_omniknight/omniknight_purification_hit.vpcf", PATTACH_ABSORIGIN, parent)
				ParticleManager:SetParticleControlEnt(pfx, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0,0,0), true)
				ParticleManager:SetParticleControlEnt(pfx, 1, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0,0,0), true)
				ParticleManager:ReleaseParticleIndex(pfx)

				parent:SetHealth(1)
				parent:ModifyHealth(parent:GetMaxHealth(), self:GetAbility() , false, DOTA_DAMAGE_FLAG_REFLECTION+DOTA_DAMAGE_FLAG_HPLOSS+DOTA_CUSTOM_DAMAGE_FLAG_NO_ADDITIONAL_EFFECT)
				parent:AddNewModifier(nil, nil, "modifier_invulnerable", {duration=2}) 
			
				
			end

		end

    end 
end
