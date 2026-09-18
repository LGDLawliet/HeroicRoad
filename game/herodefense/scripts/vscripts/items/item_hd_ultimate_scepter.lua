item_hd_ultimate_scepter = class({})

LinkLuaModifier("modifier_item_hd_ultimate_scepter", "items/item_hd_ultimate_scepter", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_ultimate_scepter_active", "items/item_hd_ultimate_scepter", LUA_MODIFIER_MOTION_NONE)


function item_hd_ultimate_scepter:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/items/ultimate_scepter/effect.vpcf", context )
end

function item_hd_ultimate_scepter:GetIntrinsicModifierName()
	return "modifier_item_hd_ultimate_scepter"
end

function item_hd_ultimate_scepter:OnSpellStart()

	local caster    =   self:GetCaster()
	local caster_pos = caster:GetAbsOrigin()
	-- local pos = self:GetCursorPosition()
	-- local angle = AngleBetween(caster:GetAbsOrigin(),pos)

	-- local direction = GetDirection2D(pos, caster_pos)
	-- pos = caster:GetAbsOrigin() + direction*(-200)
	-- print(angle)
	-- print(caster:GetAbsOrigin())
	-- print(pos)
	local particle = ParticleManager:CreateParticle("particles/rebuild/items/ultimate_scepter/effect.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(particle, 0, caster:GetAbsOrigin()+Vector(0,0,500))
	ParticleManager:SetParticleControlEnt(particle, 1, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
	DestroyParticleByDelay(particle,3)
	caster:AddNewModifier(caster, self, "modifier_item_hd_ultimate_scepter_active", {duration = 5})
	caster:EmitSound("hud.equip.agh_scepter")

end

modifier_item_hd_ultimate_scepter = advanced_modifier({})

function modifier_item_hd_ultimate_scepter:IsDebuff() return false end
function modifier_item_hd_ultimate_scepter:IsHidden() return true end
function modifier_item_hd_ultimate_scepter:IsPurgable() return false end
function modifier_item_hd_ultimate_scepter:IsPurgeException() return false end


function modifier_item_hd_ultimate_scepter:ADDeclareFunctions()
	return 
	{
		advanced_MODIFIER_PROPERTY_ADVANCED_LEVEL_BONUS
	}
end


function modifier_item_hd_ultimate_scepter:Advanced_GetAdvancedLevelBonus(keys)
	return 4
end
modifier_item_hd_ultimate_scepter_active = advanced_modifier({})

function modifier_item_hd_ultimate_scepter_active:IsDebuff() return false end
function modifier_item_hd_ultimate_scepter_active:IsHidden() return false end
function modifier_item_hd_ultimate_scepter_active:IsPurgable() return false end
function modifier_item_hd_ultimate_scepter_active:IsPurgeException() return false end

function modifier_item_hd_ultimate_scepter_active:ADDeclareFunctions()
	return 
	{
		advanced_MODIFIER_PROPERTY_ADVANCED_LEVEL_BONUS
	}
end


function modifier_item_hd_ultimate_scepter_active:Advanced_GetAdvancedLevelBonus(keys)
	-- 主动效果是两倍 保证等于上面那个加成就行
	return 4
end