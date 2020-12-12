import std.process;
import std.json;
import std.file;
import std.stdio;
import std.parallelism;
import std.array;
import std.format;

struct TargetInfo
{
	string name;
	string version_;
}

void main()
{
	if (!exists("dub.selections.json"))
	{
		writeln("fetch-selections: Skip the process because dub.selections.json is not found");
		return;
	}

	const json = std.file.readText("dub.selections.json");
	auto selections = parseJSON(json)["versions"];

	auto targets = appender!(TargetInfo[]);
	foreach (string key, ref value; selections)
	{
		targets.put(TargetInfo(key, value.str));
	}

	foreach (t; parallel(targets.data))
	{
		const command = format!"dub fetch %s@%s"(t.name, t.version_);
		writeln("start: ", command);
		scope (success) writeln("complete: ", command);
		scope (failure) writeln("failure: ", command);

		auto pid = spawnShell(command, stdin, stdout, stderr, null, Config.retainStdout | Config.retainStderr);
		pid.wait();
	}
}
