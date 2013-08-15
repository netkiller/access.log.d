import std.stdio;
import std.getopt; 
import std.string;
import std.regex;

enum database { mongo, mysql, pgsql }; 
enum logformat { nginx, httpd, squid }; 


void usage(string proc){
	writef("%s --format=nginx --db=mongo --table=bbs\r\n", proc);
	writef("%s -f nginx -d mongo -t bbs\r\n", proc);
	
}
void process(logformat fmt, database db, string table){
	auto r = regex("");
	
	// nginx
	if(fmt == logformat.nginx){
		r = regex(`^(\S+) (\S+) (\S+) \[(.+)\] "([^"]+)" ([0-9]{3}) ([0-9]+) "([^"]+)" "([^"]+)" "([^"]+)"`);
	}
	// apache2
	if(fmt == logformat.httpd){
		r = regex(`^(\S+) (\S+) (\S+) \[(.+)\] "([^"]+)" ([0-9]{3}) ([0-9]+) "([^"]+)" "([^"]+)"`);
	}

	foreach(line; stdin.byLine)
	{
		//writeln(line);
		//auto m = match(line, r);
		foreach(m; match(line, r)){
			//writeln(m.hit);
			auto c = m.captures;
			c.popFront();
			//writeln(c);
			// SQL
			if(db == database.mysql || db == database.pgsql){
				auto value = join(c, "\",\"");
				auto sql = format("insert into %s(remote_addr,unknow,remote_user,time_local,request,status,body_bytes_sent,http_referer,http_user_agent,http_x_forwarded_for) value(\"%s\");", table, value );
				writeln(sql);
			}
			// MongoDB
			if(db == database.mongo){
				string bson = format("db.logging.%s.save({
						'remote_addr': '%s',
						'remote_user': '%s',
						'time_local': '%s',
						'request': '%s',
						'status': '%s',
						'body_bytes_sent':'%s',
						'http_referer': '%s',
						'http_user_agent': '%s',
						'http_x_forwarded_for': '%s'
						})",table,
						c[0],c[2],c[3],c[4],c[5],c[6],c[7],c[8],c[9]
						);
				writeln(bson);
			}

		}
	}

}
void main(string[] args) {
	logformat fmt;
	database db; 
	string table = "log";
	bool help = false;

	getopt( args, 
		"format|f", &fmt, 
		"db|d", &db, 
		"table|t", &table,
		"help|h|v", &help
	);
	if( help ){
		usage(args[0]);
	}else{
		process(fmt,db,table);
	}
}
