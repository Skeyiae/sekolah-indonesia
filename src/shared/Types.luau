-- Types.luau
-- Shared type definitions

export type CanvasData = {
	CanvasId: string,
	Owner: Player?,
	SurfacePart: Part,
	SurfaceGui: SurfaceGui?,
	LastModified: number,
}

export type DrawPoint = {
	X: number,
	Y: number,
	Color: Color3,
	Size: number,
}

export type DrawStroke = {
	Points: {DrawPoint},
	Color: Color3,
	Size: number,
}

return {}
