-- Defines the Entity's type, base, printable name, and author for shared access (both server and client)
ENT.Type = "anim" -- Sets the Entity type to 'anim', indicating it's an animated Entity.
ENT.Base = "base_gmodentity" -- Specifies that this Entity is based on the 'base_gmodentity', inheriting its functionality.
ENT.PrintName = "Fairies" -- The name that will appear in the spawn menu.
ENT.Author = "MarkedOff" -- The author's name for this Entity.
ENT.Category = "MarkedOff" -- The category for this Entity in the spawn menu.
ENT.Contact = "" -- The contact details for the author of this Entity.
ENT.Purpose = "" -- The purpose of this Entity.
ENT.Spawnable = true -- Specifies whether this Entity can be spawned by players in the spawn menu.
ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

function ENT:SetupDataTables()
	self:NetworkVar( "Float", 0, "Progress")

	if SERVER then
		self:SetProgress(0)
	end

end