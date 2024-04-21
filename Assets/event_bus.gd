extends Node

@export var events_at_once = 500

enum PROCESSING_MODE {IDLE, PHYSICS}
@export var processing_mode : int = 0

var events_lock = Mutex.new()
var receivers_lock = Mutex.new()
var receivers = {}
var events = []

class Event:
	var emitter = null
	var receiver = null
	var method = null
	var value = null
	var coupled = false;

func _ready():
	set_process(false)
	set_physics_process(false)
	if (processing_mode == PROCESSING_MODE.IDLE):
		set_process(true)
	elif(processing_mode == PROCESSING_MODE.PHYSICS):
		set_physics_process(true)

func _process(delta):
	_process_events();

func _physics_process(delta):
	_process_events()

func _process_events():
	if events.size() == 0:
		return

	var num = min(events_at_once, events.size())
	for i in range(0, num):
		events_lock.lock()
		var event = events.pop_front()
		events_lock.unlock()
		
		if (is_instance_valid(event.receiver)):
			var allow = true
			
			#If coupled
			if (event.coupled):
				if (typeof(event.emitter) == TYPE_ARRAY):
					#There's an array of conditions
					for patient in event.emitter:
						if (!is_instance_valid(patient)):
							allow = false
				#There's a single condition
				elif (!is_instance_valid(event.emitter)):
					allow = false
				
				if (allow):
					event.receiver.call(event.method, event.value)
			else:
				event.receiver.call(event.method, event.value)

func publish_coupled(event_name, emitter, value = null):
	if (receivers.has(event_name)):
		var event_receivers = receivers[event_name]
		for receiver in event_receivers.keys():
			var event = Event.new()
			event.emitter = emitter
			event.coupled = true
			event.receiver = receiver
			event.method = event_receivers[receiver]
			event.value = value

			events_lock.lock()
			events.push_back(event)
			events_lock.unlock()

func publish(event_name, value = null):
	if (receivers.has(event_name)):
		var event_receivers = receivers[event_name]
		for receiver in event_receivers.keys():
			var event = Event.new()
			event.receiver = receiver
			event.coupled = false
			event.method = event_receivers[receiver]
			event.value = value

			events_lock.lock()
			events.push_back(event)
			events_lock.unlock()

func subscribe(event_name, receiver, method):
	if !receiver.has_method(method):
		printerr(receiver, " doesn't have method ", method)
		return

	receivers_lock.lock()
	if !receivers.has(event_name):
		receivers[event_name] = {}
	receivers_lock.unlock()
	receivers[event_name][receiver] = method;


func unsubscribe(event_name, receiver):
	receivers[event_name].erase(receiver)

func queue_size():
	return events.size()
	
func retrieve_request(request:Dictionary, values_array:Array, keys_array:Array = []):
	for value in request.values():
		values_array.append(value)
