#
# (C) Tenable Network Security, Inc.
#

include("compat.inc");

if(description)
{
 script_id(11364);
 script_version("$Revision: 1.13 $");
 script_cve_id("CVE-2003-1076");
 script_bugtraq_id(7033);
 script_xref(name:"OSVDB", value:"15147");
 
 script_name(english:"Solaris sendmail .forward Local Privilege Escalation");
 
 script_set_attribute(attribute:"synopsis", value:
"The remote server is vulnerable to a privilege escalation attack." );
 script_set_attribute(attribute:"description", value:
"The remote sendmail server, according to its version number, may be
vulnerable to a local privilege escalation attack when using forward
files. 

*** Sun did not increase the version number of their sendmail
*** when patching Solaris 7 and 8, so this might be a false
*** positive on these platforms.

An attacker may set up a special .forward file in his home and send a
mail to himself, which will trick sendmail and will allow him to
execute arbitrary commands with root privileges." );
 script_set_attribute(attribute:"solution", value: "Upgrade to the latest version of sendmail" );
 script_set_attribute(attribute:"cvss_vector", value: "CVSS2#AV:L/AC:L/Au:N/C:C/I:C/A:C" );
	
script_end_attributes();

 script_summary(english: "Checks the version number of sendmail");
 script_category(ACT_GATHER_INFO);
 script_copyright(english:"This script is Copyright (C) 2003-2009 Tenable Network Security, Inc.");
 script_family(english:"SMTP problems");
 if ( ! defined_func("bn_random") )
 	script_dependencie("smtpserver_detect.nasl", "os_fingerprint.nasl");
 else
 	script_dependencie("smtpserver_detect.nasl", "os_fingerprint.nasl", "solaris7_107684.nasl", "solaris7_x86_107685.nasl", "solaris8_110615.nasl", "solaris8_x86_110616.nasl", "solaris9_113575.nasl", "solaris9_x86_114137.nasl");
 script_require_ports("Services/smtp", 25);

 script_require_keys("SMTP/sendmail");
 exit(0);
}

#
# The script code starts here
#

include("smtp_func.inc");

if ( get_kb_item("BID-8641") ) exit(0);

port = get_kb_item("Services/smtp");
if(!port) port = 25;

banner = get_smtp_banner(port:port);
if(banner)
{
  os = get_kb_item("Host/OS");

  if(os && (("Solaris 6" >< os)   ||
     ("Solaris 7" >< os)   ||
     ("Solaris 8" >< os)))
  { 
     if(egrep(pattern:".*Sendmail ((5\.79.*|5\.[89].*|[67]\..*|8\.[0-9]\..*|8\.10\..*|8\.11\.[0-5])\+Sun/|SMI-[0-8]\.).*", string:banner, icase:TRUE))
 	security_hole(port);
  }
  else if(!os || "Solaris 9" >< os)
  {
   if(egrep(pattern:".*Sendmail (5\.79.*|5\.[89].*|[67]\..*|8\.[0-9]\..*|8\.1[0-1]\..*|8\.12\.[0-7])\+Sun/.*", string:banner, icase:TRUE))
 	security_hole(port);
  }
}
