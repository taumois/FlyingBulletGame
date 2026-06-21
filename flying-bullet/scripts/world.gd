extends Node2D

const CHUNK_SIZE = 200
const HOUSES_PER_CHUNK = 1
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
					print(randf())
					var new_chunk = Chunk.new(Vector2i((i % 3) - 1 + bullet_chunk.x, roundi(i / 3 - 0.25) - 0.5 + bullet_chunk.y))
					loaded_chunks[i].remove_houses()
					load_chunk(new_chunk)
					loaded_chunks[i] = new_chunk

func load_chunk(chunk: Chunk) -> void:
	var chunk_id = fmod(chunk.x * chunk.y * seed, 1.0)
	var house = HOUSE.instantiate()
	house.position = chunk.position() * CHUNK_SIZE + Vector2i(Vector2.ONE * chunk_id * CHUNK_SIZE)
	chunk.houses.push_back(house)
	add_child(house)


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
