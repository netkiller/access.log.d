import std.regex;
import std.stdio;
import std.string;
import std.array;

void main()
{
    // nginx
	//auto r = regex(`^(\S+) (\S+) (\S+) \[(.+)\] "([^"]+)" ([0-9]{3}) ([0-9]+) "([^"]+)" "([^"]+)" "([^"]+)"`);

	// apache2
	auto r = regex(`^(\S+) (\S+) (\S+) \[(.+)\] "([^"]+)" ([0-9]{3}) ([0-9]+) "([^"]+)" "([^"]+)"`);

	foreach(line; stdin.byLine)
	{

		foreach(m; match(line, r)){
			//writeln(m.hit);
			auto c = m.captures;
			c.popFront();
			//writeln(c);
			auto value = join(c, "\",\"");
			auto sql = format("insert into log(remote_addr,unknow,remote_user,time_local,request,status,body_bytes_sent,http_referer,http_user_agent,http_x_forwarded_for) value(\"%s\");", value );
			writeln(sql);
		}
	}
}
