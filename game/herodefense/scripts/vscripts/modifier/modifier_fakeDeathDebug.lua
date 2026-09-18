--傻子的力量
--------------------------------------------------------------------------------
modifier_fakeDeathDebug = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_fakeDeathDebug:IsHidden()return false end
function modifier_fakeDeathDebug:IsDebuff()return false end
function modifier_fakeDeathDebug:IsStunDebuff()return false end
function modifier_fakeDeathDebug:IsPurgable()return false end
function modifier_fakeDeathDebug:GetTexture() return "snapfire_gobble_up" end
function modifier_fakeDeathDebug:IsPurgeException() 	return false end
