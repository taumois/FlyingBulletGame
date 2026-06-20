extends Node2D

const CHUNK_SIZE = 1_000
const HOUSES_PER_CHUNK = 3
const HOUSE = preload("res://scenes/house.tscn")

var bullet
var loaded_chunks: Array[Chunk]
var seed
var bullet_chunk

func _ready() -> void:
	loaded_chunks.resize(9)
	bullet = %Bullet
	seed = randf()


func _process(delta: float) -> void:
	bullet_chunk = Chunk.new(bullet.position / CHUNK_SIZE)
	if not chunk_loaded(bullet_chunk):
		load_chunk(bullet_chunk)
		loaded_chunks.append(bullet_chunk)
		#print(loaded_chunks.size())

func load_chunk(chunk: Chunk) -> void:
	var chunk_position = chunk.position() * CHUNK_SIZE
	var chunk_id = randf_from_seed(chunk.x * chunk.y)
	
	var house_id = chunk_id
	for i in HOUSES_PER_CHUNK:
		var house = HOUSE.instantiate()
		var position_offset_within_chunk = Vector2(randf_from_seed(house_id) * CHUNK_SIZE, randf_from_seed(house_id) * CHUNK_SIZE)
		house_id = randf_from_seed(house_id)
		house.position = Vector2(chunk_position) + position_offset_within_chunk
		chunk.houses.append(house)
		add_child(house)


func randf_from_seed(seed: float) -> float:
	var random_float_decimal = fmod(rand_from_seed(seed * 100.0)[0], 1.0)
	print(random_float_decimal)
	return random_float_decimal


func chunk_loaded(chunk: Chunk) -> bool:
	for loaded_chunk in loaded_chunks:
		if loaded_chunk != null:
			if loaded_chunk.x != null:
				if loaded_chunk.position() == chunk.position():
					return true
				if not loaded_chunk.is_adjacent_to_chunk(bullet_chunk):
					for house in loaded_chunk.houses:
						house.queue_free()
					loaded_chunk.houses.clear()
					loaded_chunk.x = null
					loaded_chunk = null
	return false

class Chunk:
	var x
	var y
	var houses: Array[Node2D]
	
	func _init(position: Vector2) -> void:
		x = position.x
		y = position.y
	
	func position() -> Vector2i:
		return Vector2i(x, y)
	
	
	func is_adjacent_to_chunk(chunk: Chunk) -> bool:
		return --chunk.x <= x and x <= ++chunk.x and --chunk.y <= y and y <= ++chunk.y
