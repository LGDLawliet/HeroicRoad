
-- LinkLuaModifier("modifier_item_hd_bottledthundertorm_buff", "items/item_hd_bottledthundertorm", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_bottledthundertorm_active", "items/item_hd_bottledthundertorm", LUA_MODIFIER_MOTION_NONE)


item_hd_bottledthundertorm = item_hd_bottledthundertorm or class({})
function item_hd_bottledthundertorm:OnSpellStart()
	if IsServer() then
		-- local mana_restore_pct = self:GetSpecialValueFor( "mana_restore_pct" )
		local caster = self:GetCaster()
		if caster:HasModifier("modifier_item_hd_bottledthundertorm_active") then
			return
		end
		caster:AddNewModifier(caster, self, "modifier_item_hd_bottledthundertorm_active", {})
		self:SpendCharge(0)
	end
end

function item_hd_bottledthundertorm:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/items/bottled_thunder_storm/effect.vpcf", context )

end



modifier_item_hd_bottledthundertorm_active = modifier_item_hd_bottledthundertorm_active or class({})

function modifier_item_hd_bottledthundertorm_active:IsDebuff() return false end
function modifier_item_hd_bottledthundertorm_active:IsHidden() return false end
function modifier_item_hd_bottledthundertorm_active:IsPurgable() return false end
function modifier_item_hd_bottledthundertorm_active:IsPurgeException() return false end
function modifier_item_hd_bottledthundertorm_active:GetTexture()return "item_bottledthundertorm" end
function modifier_item_hd_bottledthundertorm_active:RemoveOnDeath() return false end


function modifier_item_hd_bottledthundertorm_active:OnCreated(keys)
    if IsServer() then
        if not self:GetParent():IsRealHero() then
            return false
        end
        self.parent = self:GetParent()
        self.currentPos = self.parent:GetAbsOrigin()
        local interval = 0.06
        self:StartIntervalThink(interval)     

    end
end
function modifier_item_hd_bottledthundertorm_active:OnIntervalThink()
  

	local dis = CalculateDistance(self.parent:GetAbsOrigin(),self.currentPos)
    if dis>=300 then
		local caster = self:GetCaster()
		caster:EmitSound("Hero_StormSpirit.BallLightning")
	
		local particle = ParticleManager:CreateParticle("particles/rebuild/items/bottled_thunder_storm/effect.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(particle, 0, caster:GetAbsOrigin())
		ParticleManager:SetParticleControl(particle, 1, self.currentPos)
		DestroyParticleByDelay(particle,2)
		local tTargets = FindUnitsInLine(caster:GetTeamNumber(), self.parent:GetAbsOrigin(), self.currentPos,nil, 150,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		DOTA_UNIT_TARGET_FLAG_NONE)
		local damageTable = {
			-- victim = target,
			damage = caster:HDGetPrimaryStatValue()*6,
			damage_type = DAMAGE_TYPE_MAGICAL,
			attacker = caster,
			ability = nil,
			damage_flags = DOTA_DAMAGE_FLAG_NONE
		}
		for i, enemy in pairs(tTargets) do
			damageTable.victim = enemy
			ApplyDamage(damageTable)
		end
    end
	self.currentPos = self.parent:GetAbsOrigin()
end



