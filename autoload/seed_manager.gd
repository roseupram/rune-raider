extends Node

const ALPHABET = "0123456789ABCDEFGHIJKLMNPQRSTUVWXYZ"
const CODE_BIT = 8
var MOD_BASE = int(pow(ALPHABET.length(),CODE_BIT))

var main_seed = 2
var RNG_cache={}


func encode_seed(sd:int):
	if sd==0:
		return ALPHABET[0]
	var BASE = ALPHABET.length()
	var value =sd % MOD_BASE
	var result=""
	while value>0:
		result= ALPHABET[value%BASE]+result
		value/=BASE
	return result
	
func decode_seed(code:String):
	var BASE = ALPHABET.length()
	code = code.strip_edges().to_upper()
	var result = 0
	for i in range(min(code.length(),CODE_BIT)):
		var index = ALPHABET.find(code[i])
		if index==-1:
			push_error("invalid code ",code)
			return -1
		result= index+result*BASE
	return result



func start_new_run():
	var us = Time.get_ticks_usec()
	var unix_time = Time.get_unix_time_from_system()
	main_seed = int(unix_time*1000*us+unix_time) % MOD_BASE
	var encode = encode_seed(main_seed)
	print("seed is {2}, unix_time={0}, us={1} | {3},{4}".format([
		unix_time*1000,us,encode,main_seed,decode_seed(encode)]))

func get_RNG(name:String):
	if RNG_cache.has(name):
		return RNG_cache[name]
	var rng = RandomNumberGenerator.new()
	rng.seed=hash(str(main_seed)+name)
	RNG_cache[name]=rng
	return rng
	
