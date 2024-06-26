extends RayCast2D


signal collided(collider)
signal stop_colliding()


var last_collider: Object


func _physics_process(_delta: float) -> void:
	if not is_colliding():
		last_collider = null
		stop_colliding.emit()
		return
	var found_collider: Object = get_collider()
	if found_collider != last_collider && !found_collider is TileMap:
		last_collider = found_collider
		emit_signal("collided", found_collider)
