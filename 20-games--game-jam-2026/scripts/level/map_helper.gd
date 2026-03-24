extends Node2D

@export var grid : TileMapLayer

func is_tile_occupied(pos) -> bool:
	var coords = grid.local_to_map(pos)
	
	if grid.get_cell_source_id(coords) != -1:
		return true
	else:
		return false

func snap_to_grid(body, pos):
	var current_cell = grid.local_to_map(pos)
	
	if body.global_position != grid.map_to_local(current_cell):
		body.global_position = grid.map_to_local(current_cell)
