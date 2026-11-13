extends Node3D

@onready var camera: Camera3D = self.get_node("Camera3D")

const SPEED: int = 10

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	#get_viewport().debug_draw = Viewport.DEBUG_DRAW_WIREFRAME

func _process(delta: float) -> void:
	$UI/FPSLabel.text = "FPS: "+str((Engine.get_frames_per_second()))

func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("forward"):
		self.position -= self.basis.z * delta * SPEED
	if Input.is_action_pressed("backward"):
		self.position += self.basis.z * delta * SPEED
	if Input.is_action_pressed("left"):
		self.position -= self.basis.x * delta * SPEED
	if Input.is_action_pressed("right"):
		self.position += self.basis.x * delta * SPEED

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var mouseX: float = event.relative.x
		var mouseY: float = event.relative.y
		
		self.rotation.y -= mouseX * 0.01
		self.rotation.x -= mouseY * 0.01
