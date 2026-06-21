extends Node2D

const CHUNK_SIZE = 4000
const HOUSES_PER_CHUNK = 6
const HOUSE = preload("res://scenes/house.tscn")

var bullet
var loaded_chunks: Array[Chunk]
var seed
var bullet_chunk

func _ready() -> void:
	bullet = %Bullet
	seed = randf()
	loaded_chunks.resize(9)
	bullet_chunk = Chunk.new(bullet.position / CHUNK_SIZE)
	for i in loaded_chunks.size():
			var new_chunk = Chunk.new(Vector2i((i % 3) - 1, roundi(i / 3 - 0.5) - 0.5))
			load_chunk(new_chunk)
			loaded_chunks[i] = new_chunk


func _process(delta: float) -> void:
	var new_bullet_chunk = Chunk.new(bullet.position / CHUNK_SIZE)
	if new_bullet_chunk.is_chunk(bullet_chunk):
		return
	bullet_chunk = new_bullet_chunk
	
	for i in loaded_chunks.size():
		if not loaded_chunks[i].is_adjacent_to_chunk(bullet_chunk):
			for j in loaded_chunks.size():
					var new_chunk = Chunk.new(Vector2i((j % 3) - 1 + bullet_chunk.x, roundi(j / 3 - 0.25) - 0.5 + bullet_chunk.y))
					if not chunk_in_loaded_chunks(new_chunk):
						loaded_chunks[i].remove_houses()
						load_chunk(new_chunk)
						loaded_chunks[i] = new_chunk

func load_chunk(chunk: Chunk) -> void:
	var chunk_unique_randf = fmod(chunk.x * chunk.y * seed, 1.0)
	var house_unique_randf_x = fmod(rand_from_seed(chunk_unique_randf)[0] / chunk_unique_randf / PI, 1.0)
	var house_unique_randf_y = fmod(rand_from_seed(chunk_unique_randf)[0] / chunk_unique_randf / seed, 1.0)
	
	for i in HOUSES_PER_CHUNK:
		var house = HOUSE.instantiate()
		house_unique_randf_x = fmod(rand_from_seed(house_unique_randf_x)[0] / house_unique_randf_y, 1.0)
		house_unique_randf_y = fmod(rand_from_seed(house_unique_randf_y)[0] / house_unique_randf_x, 1.0)
		house.position = chunk.position() * CHUNK_SIZE + Vector2i(house_unique_randf_x * CHUNK_SIZE, house_unique_randf_y * CHUNK_SIZE)
		house.rotation = 2.0 * PI * chunk_unique_randf
		house.scale.x = 5.0
		house.scale.y = 5.0
		chunk.houses.push_back(house)
		add_child(house)


func chunk_in_loaded_chunks(chunk: Chunk) -> bool:
	for loaded_chunk in loaded_chunks:
		if chunk.x == loaded_chunk.x:
			if chunk.y == loaded_chunk.y:
				return true
	return false


class Chunk:
	var x
	var y
	var houses: Array[Node2D]
	
	func _init(position: Vector2i) -> void:
		x = position.x
		y = position.y
	
	
	func position() -> Vector2i:
		return Vector2i(x, y)
	
	
	func is_adjacent_to_chunk(chunk: Chunk) -> bool:
		var x_adjacent = chunk.x - 1 <= x and x <= chunk.x + 1
		var y_adjacent = chunk.y - 1 <= y and y <= chunk.y + 1
		return x_adjacent and y_adjacent

	
	func is_chunk(chunk: Chunk) -> bool:
		return chunk.x == x and chunk.y == y
	

	func remove_houses() -> void:
		for house in houses:
			house.queue_free()
		houses.clear()
