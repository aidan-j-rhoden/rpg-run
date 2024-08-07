extends CharacterBody3D

@onready var cam_mount: Node3D = $CamMount
@onready var animation_player: AnimationPlayer = $Visuals/mixamo_base/AnimationPlayer
@onready var animation_tree: AnimationTree = $Visuals/mixamo_base/AnimationTree

@onready var visuals: Node3D = $Visuals

@onready var rpg: Node3D = $Visuals/mixamo_base/Armature/Skeleton3D/BoneAttachment3D/RPG

const JUMP_VELOCITY = 4.5

var SPEED = 1.75
var walk_speed:float = 1.75
var run_speed:float = 3.9
var running:bool = false
var locked:bool = false

@export var senstivity_h:float = 0.3
@export var senstivity_v:float = 0.3

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotate_y(deg_to_rad(-event.relative.x * senstivity_h))
		visuals.rotate_y(deg_to_rad(event.relative.x * senstivity_h))
		cam_mount.rotate_x(deg_to_rad(-event.relative.y * senstivity_v))
	if Input.is_action_just_pressed("escape"):
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _physics_process(delta: float) -> void:
	if not animation_tree["parameters/kick/active"]:
		locked = false

	if Input.is_action_just_pressed("kick") and is_on_floor():
		if not animation_tree["parameters/kick/active"]:
			locked = true
			animation_tree["parameters/kick/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE
	if Input.is_action_just_pressed("shoot"):
		if not animation_tree["parameters/fire/active"]:
			animation_tree["parameters/fire/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE

	if Input.is_action_pressed("sprint"):
		SPEED = run_speed
		running = true
	else:
		SPEED = walk_speed
		running = false

	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		if not animation_tree["parameters/jump/active"]:
			animation_tree["parameters/jump/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("left", "right", "forward", "back")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		if not locked:
			if is_on_floor():
				if running:
					if animation_tree["parameters/state/current_state"] != "running":
						animation_tree["parameters/state/transition_request"] = "run"
				else:
					if animation_tree["parameters/state/current_state"] != "walking":
						animation_tree["parameters/state/transition_request"] = "walk"

			visuals.look_at(position + direction)

		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		if not locked and is_on_floor():
			if animation_tree["parameters/state/current_state"] != "idle":
				animation_tree["parameters/state/transition_request"] = "idle"

		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	if not locked:
		move_and_slide()

func fire():
	rpg.fire()
