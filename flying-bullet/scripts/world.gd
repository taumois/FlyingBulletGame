extends Node2D

const FULL_ROTATION = 2 * PI
const CHUNK_SIZE = 8_000
const HOUSES_PER_CHUNK = 3
const HOUSES_SCALE = Vector2(5.0, 15.0)
const CHUNK_HOUSE = preload("res://scenes/house.tscn")

var bullet: CharacterBody2D
var loaded_chunks: Array[Chunk]
var house_bank: Array[StaticBody2D]
var seeds: Array[float]
var bullet_chunk: Chunk

func _ready() -> void:
	bullet = %Bullet
	seeds.resize(HOUSES_PER_CHUNK * 9 * 3)
	for i in seeds.size():
		seeds[i] = randf()
	loaded_chunks.resize(9)
	house_bank.resize(9 * HOUSES_PER_CHUNK)
	for i in house_bank.size():
		var house = CHUNK_HOUSE.instantiate()
		house.scale = HOUSES_SCALE
		house_bank[i] = house
	bullet_chunk = Chunk.new(Vector2i(1.0, 1.0))
	for i in loaded_chunks.size():
		var chunk = Chunk.new(Vector2i.ZERO)
		loaded_chunks[i] = chunk


func get_bullet_current_chunk() -> Chunk:
	var chunk_position = Vector2i(roundi(bullet.position.x / CHUNK_SIZE), roundi(bullet.position.y / CHUNK_SIZE))
	var chunk = Chunk.new(chunk_position)
	return chunk


func _physics_process(delta: float) -> void:
	bullet.special_physics_process(delta)
	var bullet_current_chunk = get_bullet_current_chunk()
	if bullet_current_chunk.is_chunk(bullet_chunk):
		return
	bullet_chunk = bullet_current_chunk
	for i in loaded_chunks.size():
		var flt_i = float(i)
		var chunk = Chunk.new(Vector2i(roundi(fmod(flt_i, 3)) - 1 + bullet_chunk.position.x, roundi(flt_i / 3 - 1.25) + bullet_chunk.position.y))
		var half_seeds_size = roundi(float(seeds.size()) / 2)
		var chunk_seed_base = rand_from_seed((chunk.position.x + 7) * chunk.position.y + chunk.position.x)[0] % half_seeds_size
		for j in HOUSES_PER_CHUNK:
			if get_child_count() > 4:
				remove_child(loaded_chunks[i].houses[j])
			var house = get_house_from_bank()
			var house_seed_base = (chunk_seed_base + j * 3)
			house.position.x = chunk.real_position.x - 0.5 * CHUNK_SIZE + seeds[house_seed_base + 0] * CHUNK_SIZE
			house.position.y = chunk.real_position.y - 0.5 * CHUNK_SIZE + seeds[house_seed_base + 1] * CHUNK_SIZE
			house.rotation = FULL_ROTATION * seeds[house_seed_base + 2]
			add_child(house)
			chunk.houses[j] = house
		loaded_chunks[i].houses.clear()
		loaded_chunks[i] = chunk


func get_house_from_bank() -> StaticBody2D:
	for house in house_bank:
		if house.get_parent() == null:
			return house
	print("This shouldn't be printed")
	return null


class Chunk:
	var position: Vector2i
	var real_position: Vector2
	var houses: Array[StaticBody2D]
	
	func _init(chunk_position: Vector2i) -> void:
		self.position = chunk_position
		self.real_position = position * CHUNK_SIZE
		houses.resize(HOUSES_PER_CHUNK)
	
	
	func is_chunk(chunk: Chunk) -> bool:
		return position == chunk.position
