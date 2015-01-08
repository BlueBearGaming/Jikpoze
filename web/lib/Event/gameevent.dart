part of jikpoze;

class GameEvent extends Event {
	String code;

	EventData data;

	GameEvent(Object jsonObject) : super(jsonObject.type) {

	}
}