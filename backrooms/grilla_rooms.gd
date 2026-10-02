extends Node3D
@export var tileScene : PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(5):
		for j in range(5):
			var tile = tileScene.instantiate()
			
			add_child(tile)
			tile.position = Vector3(i*20,0,j*20)
		pass
		
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
