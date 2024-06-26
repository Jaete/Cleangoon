extends RayCast2D


signal collided(collider)


var last_collider: Object


func _physics_process(_delta: float) -> void:
	if not is_colliding():
		last_collider = null
		return
	var found_collider: Object = get_collider()
	if found_collider != last_collider && !found_collider is TileMap:
		last_collider = found_collider
		emit_signal("collided", found_collider)
