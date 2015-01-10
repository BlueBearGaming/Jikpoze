part of bluebear;

class EngineEvent {
	String code;
	String type;
	DateTime timestamp;
	dynamic data;

	EngineEvent.fromJson(String jsonString) {
		var decoded = JSON.decode(jsonString);
		code = decoded['code'];
		type = decoded['type'];
		timestamp = new DateTime.fromMillisecondsSinceEpoch(decoded['timestamp']);

		// These symbols are the names of the Library, the Class and the constructor for the Class that you want to dynamically load
		final Symbol librarySymbol = const Symbol("bluebear");
		final Symbol constructorSymbol = const Symbol("fromJsonData");
		Symbol classSymbol = new Symbol(type);

		MirrorSystem mirrorSystem = currentMirrorSystem();
		LibraryMirror libraryMirror = mirrorSystem.findLibrary(librarySymbol);
		ClassMirror classMirror = libraryMirror.declarations[classSymbol];
		if (null == classMirror) {
			throw "Class not found : $type";
		}
		InstanceMirror dataClassInstanceMirror = classMirror.newInstance(constructorSymbol, [decoded['data']]);

		//Get the reflectee object from the InstanceMirror
		data = dataClassInstanceMirror.reflectee;
	}
}