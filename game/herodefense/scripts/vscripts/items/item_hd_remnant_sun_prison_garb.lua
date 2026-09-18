item_hd_remnant_sun_prison_garb = class({})

LinkLuaModifier("modifier_item_hd_remnant_sun_prison_garb", "items/item_hd_remnant_sun_prison_garb", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_remnant_sun_prison_garb_active", "items/item_hd_remnant_sun_prison_garb", LUA_MODIFIER_MOTION_NONE)


function item_hd_remnant_sun_prison_garb:GetIntrinsicModifierName()
	return "modifier_item_hd_remnant_sun_prison_garb"
end


function item_hd_remnant_sun_prison_garb:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/spell/remnant_sun_prison_garb/effecta.vpcf", context )
end


function item_hd_remnant_sun_prison_garb:OnSpellStart()

	local caster    =   self:GetCaster()
	local health = caster:GetHealth()
	caster:EmitSound("Hero_SkeletonKing.Hellfire_Blast")

	caster:ModifyHealth(math.max(health*0.8,1), self, false, 0)
	local index = math.max(1,caster:GetStrength()*10)
	caster:AddNewModifier(caster, self, "modifier_item_hd_remnant_sun_prison_garb_active", {duration = 15,index=health*0.2})

end



modifier_item_hd_remnant_sun_prison_garb = advanced_modifier({})

function modifier_item_hd_remnant_sun_prison_garb:IsDebuff() return false end
function modifier_item_hd_remnant_sun_prison_garb:IsHidden() return true end
function modifier_item_hd_remnant_sun_prison_garb:IsPurgable() return false end
function modifier_item_hd_remnant_sun_prison_garb:IsPurgeException() return false end
function modifier_item_hd_remnant_sun_prison_garb:RemoveOnDeath() return false end


function modifier_item_hd_remnant_sun_prison_garb:OnCreated(keys)
    local ability = self:GetAbility()
	self.bonus_armor = ability:GetSpecialValueFor("bonus_armor")
	self.bonus_health = ability:GetSpecialValueFor("bonus_health")
	
end



function modifier_item_hd_remnant_sun_prison_garb:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_HEALTH_BONUS,       
	}
end



function modifier_item_hd_remnant_sun_prison_garb:GetModifierHealthBonus() return self.bonus_health end

function modifier_item_hd_remnant_sun_prison_garb:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }
end
function modifier_item_hd_remnant_sun_prison_garb:Advanced_GetModifierPhysicalArmorBonus()
    return self.bonus_armor
end


modifier_item_hd_remnant_sun_prison_garb_active = advanced_modifier({})

function modifier_item_hd_remnant_sun_prison_garb_active:IsDebuff() return false end
function modifier_item_hd_remnant_sun_prison_garb_active:IsHidden() return false end
function modifier_item_hd_remnant_sun_prison_garb_active:IsPurgable() return true end
function modifier_item_hd_remnant_sun_prison_garb_active:GetTexture()return "item_remnant_sun_prison_garb" end


function modifier_item_hd_remnant_sun_prison_garb_active:OnCreated(keys)
    local parent = self:GetParent()
	if IsServer() then
		
		self:SetStackCount(keys.index)
		self.damage = self:GetStackCount()*0.5
		self:StartIntervalThink(1)
		self.nFXIndex = ParticleManager:CreateParticle( "particles/rebuild/spell/remnant_sun_prison_garb/effecta.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
		ParticleManager:SetParticleControlEnt( self.nFXIndex, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetAbsOrigin(), true )
		-- self:AddParticle( self.nFXIndex, false, false, -1, true, false )
	end
end
function modifier_item_hd_remnant_sun_prison_garb_active:OnRefresh(keys)
	if IsServer() then
		self:SetStackCount(keys.index)
		self.damage = self:GetStackCount()*0.5
		self:StartIntervalThink(1)
	end
end
function modifier_item_hd_remnant_sun_prison_garb_active:OnDestroy()
	if IsServer() then
		if self.nFXIndex then
			ParticleManager:DestroyParticle(self.nFXIndex, false)
			ParticleManager:ReleaseParticleIndex(self.nFXIndex)
		end
	end
end
function modifier_item_hd_remnant_sun_prison_garb_active:OnIntervalThink()
	if IsServer() then

		local units = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil,  500,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
	   DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)  

		for i, unit in pairs(units) do
			-- print(i)
			local damageTable = {
				victim = unit,
				attacker = self:GetParent(),
				damage = self.damage,
				damage_type =DAMAGE_TYPE_MAGICAL,
				damage_flags = 
				DOTA_DAMAGE_FLAG_REFLECTION, --Optional.
				ability = self:GetAbility(), --Optional.
				}
			local applydamage = ApplyDamage(damageTable)
			if i>=5 then
				break
			end
		end

		
	end
end



function modifier_item_hd_remnant_sun_prison_garb_active:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP,   	   
	}
end

function modifier_item_hd_remnant_sun_prison_garb_active:Advanced_GetModifierIncomingDamage_Percentage(keys)

	if not IsServer() then
		return 0
	end
	local parent = self:GetParent()
	local health = parent:GetMaxHealth()*0.015+200
	if keys.damage<=health then
		return -100
	end
	return 0
end


function modifier_item_hd_remnant_sun_prison_garb_active:ADDeclareFunctions()
    return 
    {

		advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
    }
end


function modifier_item_hd_remnant_sun_prison_garb_active:OnTooltip()
	return self:GetParent():GetMaxHealth()*0.015+200

end

