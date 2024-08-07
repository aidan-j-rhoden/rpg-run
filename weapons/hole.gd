extends CSGSphere3D
# Holes, we've all got 'em

@onready var raycast: RayCast3D = $RayCast3D

var adjusted: bool = false

func _physics_process(_delta: float) -> void:
	if raycast.is_colliding() and not adjusted:
		adjusted = true

		var normal = raycast.get_collision_normal()
		look_at(global_transform.origin + normal, Vector3.UP)
		if normal != Vector3.UP and normal != Vector3.DOWN:
			self.rotate_object_local(Vector3(1, 0, 0), 90)
