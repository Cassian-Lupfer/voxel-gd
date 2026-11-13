extends Node3D

var rng = RandomNumberGenerator.new()
var surfaceTool: SurfaceTool = SurfaceTool.new()
var cubeMesh: BoxMesh = BoxMesh.new()

var noise: FastNoiseLite = FastNoiseLite.new()
var noiseScale: float = 0.5
var noiseThreshold: float = 0.1

const CHUNK_SIZE: int = 32
enum dir {
	ABOVE,
	UNDER,
	LEFT,
	RIGHT,
	FRONT,
	BACK
}

func _ready() -> void:
	rng.randomize()
	noise.seed = 1
	
	generateChunk()

func generateChunk():
	for x in range(-CHUNK_SIZE/2, CHUNK_SIZE/2):
		for z in range(-CHUNK_SIZE/2, CHUNK_SIZE/2):
			for y in range(-CHUNK_SIZE/2, CHUNK_SIZE/2):
				if noise.get_noise_3dv(Vector3(x, y, z) * (1.0/noiseScale)) > noiseThreshold and !checkAllNeighbors(Vector3(x, y, z)):
					var cubeMeshInst: MeshInstance3D = MeshInstance3D.new()
					cubeMeshInst.mesh = cubeMesh
					cubeMeshInst.position = Vector3(x, y, z)
					self.add_child(cubeMeshInst)

func checkNeighbor(cubePos: Vector3, direction: dir) -> bool:
	var vecAdd: Vector3 = Vector3.ZERO
	match direction:
		dir.ABOVE:
			vecAdd = Vector3(0.0, 1.0, 0.0)
			if (cubePos.y+vecAdd.y) > CHUNK_SIZE/2:
				return false
		dir.UNDER:
			vecAdd = Vector3(0.0, -1.0, 0.0)
			if (cubePos.y+vecAdd.y) < -CHUNK_SIZE/2:
				return false
		dir.LEFT:
			vecAdd = Vector3(-1.0, 0.0, 0.0)
			if (cubePos.x+vecAdd.x) < -CHUNK_SIZE/2:
				return false
		dir.RIGHT:
			vecAdd = Vector3(1.0, 0.0, 0.0)
			if (cubePos.x+vecAdd.x) > CHUNK_SIZE/2:
				return false
		dir.FRONT:
			vecAdd = Vector3(0.0, 0.0, 1.0)
			if (cubePos.z+vecAdd.z) > CHUNK_SIZE/2:
				return false
		dir.BACK:
			vecAdd = Vector3(0.0, 0.0, -1.0)
			if (cubePos.z+vecAdd.z) < -CHUNK_SIZE/2:
				return false
	
	if noise.get_noise_3dv(Vector3(cubePos+vecAdd) * (1.0/noiseScale)) > noiseThreshold:
		return true
	return false

func checkAllNeighbors(cubePos: Vector3) -> bool:
	if (
	checkNeighbor(cubePos, dir.ABOVE) and
	checkNeighbor(cubePos, dir.UNDER) and
	checkNeighbor(cubePos, dir.LEFT) and
	checkNeighbor(cubePos, dir.RIGHT) and
	checkNeighbor(cubePos, dir.FRONT) and
	checkNeighbor(cubePos, dir.BACK)):
		return true
	return false
