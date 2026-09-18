item_hd_a_stick = class({})

LinkLuaModifier("modifier_item_hd_a_stick", "items/item_hd_a_stick", LUA_MODIFIER_MOTION_NONE)

function item_hd_a_stick:GetIntrinsicModifierName()
	return "modifier_item_hd_a_stick"
end

function item_hd_a_stick:OnProjectileHit(target, location)
	if not target then
		return
	end
	-- print("hhhhhh")
	if target:IsMagicImmune() or target:TriggerStandardTargetSpell(self) or not target:IsAlive() then
		return
	end
	target:EmitSound("Hero_SkywrathMage.ArcaneBolt.Impact")
	local damage = self:GetCaster():GetIntellect(false)
	--print(damage)
	local damageTable = {
						victim = target,
						attacker = self:GetCaster(),
						damage = damage,
						damage_type = DAMAGE_TYPE_MAGICAL,
						damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
						ability = self, --Optional.
						}
	ApplyDamage(damageTable)
end


----------------------------------------------------------

modifier_item_hd_a_stick = advanced_modifier({})

function modifier_item_hd_a_stick:IsDebuff() return false end
function modifier_item_hd_a_stick:IsHidden() return true end

function modifier_item_hd_a_stick:IsPurgable() 		return false end
function modifier_item_hd_a_stick:IsPurgeException() 	return false end
function modifier_item_hd_a_stick:RemoveOnDeath()  return false end


function modifier_item_hd_a_stick:OnCreated(keys)
    self.ability = self:GetAbility()
    local parent = self:GetParent()
	self.damage = self.ability:GetSpecialValueFor("damage_index")
end

function modifier_item_hd_a_stick:ADDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST = {self:GetParent(), nil},
	}
end



function modifier_item_hd_a_stick:OnAbilityFullyCast(keys)
	if not IsServer() then
		return
	end
	if keys.unit ~= self:GetParent()  or self:GetParent():IsIllusion() then 
		return 
	end
	if self:GetAbility():IsCooldownReady() then
		local caster = self:GetParent()
		local range = self:GetAbility():GetSpecialValueFor("cast_range")
		local units = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, range,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
	   DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)  
	   if #units<=0 then
		   return
	   end
	   self:GetAbility():UseResources(true, true, true,true)
	   local target = units[1]
	   
		local info = 
	{
		Target = target,
		Source = caster,
		Ability = self:GetAbility(),	
		EffectName = "particles/units/heroes/hero_skywrath_mage/skywrath_mage_arcane_bolt.vpcf" ,
		iMoveSpeed = 2000,
		iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_1,
		bDrawsOnMinimap = false,
		bDodgeable = false,
		bIsAttack = false,
		bVisibleToEnemies = true,
		bReplaceExisting = false,
		flExpireTime = GameRules:GetGameTime() + 10,
		bProvidesVision = false,	
	}
	ProjectileManager:CreateTrackingProjectile(info)
	--如果有primary_arcane_bolt,advance则使用timer延迟0.5s后再释放一个
	if 	caster:HasAbility("Primary_arcane_bolt") or caster:HasAbility("Middle_arcane_bolt") or	caster:HasAbility("Advanced_arcane_bolt") then
		Timers:CreateTimer(0.5, function()
			
			ProjectileManager:CreateTrackingProjectile(info)
		end)
	end
	
	end
end


