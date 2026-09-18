item_hd_tesla_high_energy_gun = class({})

LinkLuaModifier("modifier_item_hd_tesla_high_energy_gun", "items/item_hd_tesla_high_energy_gun", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_tesla_high_energy_gun_debuff", "items/item_hd_tesla_high_energy_gun", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_tesla_high_energy_gun_cd", "items/item_hd_tesla_high_energy_gun", LUA_MODIFIER_MOTION_NONE)

function item_hd_tesla_high_energy_gun:GetIntrinsicModifierName()
	return "modifier_item_hd_tesla_high_energy_gun"
end
function item_hd_tesla_high_energy_gun:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/items/tesla_high_energy_gun/effect.vpcf", context )
end


function item_hd_tesla_high_energy_gun:OnSpellStart()
	local caster = self:GetCaster()
	local pos = self:GetCursorPosition()
	self:ReleaseLaser(pos,1)
end
function item_hd_tesla_high_energy_gun:ReleaseLaser(pos,index)
	local caster = self:GetCaster()

	local direction = (pos - caster:GetAbsOrigin()):Normalized()

	local vAttachmentSourcePos = caster:GetAttachmentOrigin(caster:ScriptLookupAttachment( "attach_hitloc" ) )
	local target_pos = vAttachmentSourcePos+direction*(self:GetCastRange(pos, caster) + caster:GetCastRangeBonus())
	local pfx = ParticleManager:CreateParticle( "particles/rebuild/items/tesla_high_energy_gun/effect.vpcf", PATTACH_ABSORIGIN, caster )
	ParticleManager:SetParticleControl( pfx, 9, vAttachmentSourcePos )
	ParticleManager:SetParticleControl( pfx, 1, target_pos )
	DestroyParticleByDelay(pfx,2)
	caster:EmitSound("Hero_Tinker.LaserImpact")

	local tTargets = FindUnitsInLine(caster:GetTeamNumber(), vAttachmentSourcePos,target_pos,nil, 200,
	DOTA_UNIT_TARGET_TEAM_ENEMY,
	DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
	DOTA_UNIT_TARGET_FLAG_NONE)
	local damageTable =
	{
		-- victim = hitEnemy,
		attacker = caster,
		damage = caster:GetAverageTrueAttackDamage(nil)*index*self:GetSpecialValueFor("damage_preatk"),
		damage_type = DAMAGE_TYPE_PHYSICAL,
		damage_flag = DOTA_DAMAGE_FLAG_NONE,
		ability = self,
	}
	
	for _, hitEnemy in pairs( tTargets ) do
		damageTable.victim = hitEnemy
		if hitEnemy:IsAlive() then
			hitEnemy:AddNewModifier(caster, self, "modifier_item_hd_tesla_high_energy_gun_debuff", { duration = self:GetSpecialValueFor("duration")} 	)
		end
		ApplyDamage( damageTable )
		
		
	end

end

modifier_item_hd_tesla_high_energy_gun = advanced_modifier({})

function modifier_item_hd_tesla_high_energy_gun:IsDebuff() return false end
function modifier_item_hd_tesla_high_energy_gun:IsHidden() return false end
function modifier_item_hd_tesla_high_energy_gun:IsPurgable() return false end
function modifier_item_hd_tesla_high_energy_gun:IsPurgeException() return false end
function modifier_item_hd_tesla_high_energy_gun:RemoveOnDeath() return false end


function modifier_item_hd_tesla_high_energy_gun:OnCreated(keys)
    self.ability = self:GetAbility()
	self.bonus_damage = self.ability:GetSpecialValueFor("bonus_damage")
	self.attack_range = self.ability:GetSpecialValueFor("bonus_attack_range")
	if IsServer() then
		self:StartIntervalThink(0.2)
	end
end

function modifier_item_hd_tesla_high_energy_gun:OnIntervalThink(keys)
    self.ability = self:GetAbility()
	self.takerange = self:GetCaster():Script_GetAttackRange()-self:GetCaster():GetBaseAttackRange()
	self.rangedamage = math.max(self.takerange,0)*self:GetAbility():GetSpecialValueFor("range_damage")
	self:SetStackCount(self.rangedamage)
end

function modifier_item_hd_tesla_high_energy_gun:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}
end
function modifier_item_hd_tesla_high_energy_gun:Advanced_GetModifierAttackRangeBonus() return  self:GetCaster():IsRangedAttacker() and self.attack_range or 0 end
function modifier_item_hd_tesla_high_energy_gun:Advanced_GetModifierPreAttack_BonusDamage() return self.bonus_damage + self:GetStackCount() end

function modifier_item_hd_tesla_high_energy_gun:OnAttackLanded(keys)
	if not IsServer() then return end
	local cd = self:GetAbility():GetSpecialValueFor("cd")
	self.index = self:GetAbility():GetSpecialValueFor("index")*0.01
	if keys.attacker ~= self:GetParent() then
		return
	end
	if not keys.attacker:IsApplyModifier() then
		return
	end
	local ability = self:GetAbility()
	if keys.damage<=0 then
		return
	end
	if not keys.attacker:HasModifier("modifier_item_hd_tesla_high_energy_gun_cd") then
		ability:ReleaseLaser(keys.target:GetOrigin(),self.index)
		keys.attacker:AddNewModifier(keys.attacker,self:GetAbility(),"modifier_item_hd_tesla_high_energy_gun_cd",{duration = cd})
	end

	
end


function modifier_item_hd_tesla_high_energy_gun:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
		advanced_MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE
	
    }
end


modifier_item_hd_tesla_high_energy_gun_debuff = modifier_item_hd_tesla_high_energy_gun_debuff or advanced_modifier({})

function modifier_item_hd_tesla_high_energy_gun_debuff:IsDebuff()return true end
function modifier_item_hd_tesla_high_energy_gun_debuff:IsPurgable()return true end
function modifier_item_hd_tesla_high_energy_gun_debuff:GetTexture() return "item_tesla_high_energy_gun" end
function modifier_item_hd_tesla_high_energy_gun_debuff:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
    }
end
function modifier_item_hd_tesla_high_energy_gun_debuff:Advanced_GetModifierIncomingDamage_Percentage(keys)
	if keys.damage_type ==DAMAGE_TYPE_PHYSICAL then
    	return self:GetAbility():GetSpecialValueFor("active_incoming")
	else
		return 0
	end
end


modifier_item_hd_tesla_high_energy_gun_cd = advanced_modifier({})

function modifier_item_hd_tesla_high_energy_gun_cd:IsDebuff() return false end
function modifier_item_hd_tesla_high_energy_gun_cd:IsHidden() return true end
function modifier_item_hd_tesla_high_energy_gun_cd:IsPurgable() return false end
