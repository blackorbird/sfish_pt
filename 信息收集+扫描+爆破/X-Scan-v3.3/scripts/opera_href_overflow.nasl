#
# (C) Tenable Network Security
#

if(description)
{
 script_id(11900);
 script_bugtraq_id(8853);
 script_cve_id("CAN-2003-0870");
 
 script_version("$Revision: 1.5 $");

 name["english"] = "Opera web browser HREF overflow";

 script_name(english:name["english"]);
 
 desc["english"] = "
The remote host is using Opera - an alternative web browser.

The version installed is vulnerable to a buffer overflow in the code which
parses HREF tags in the server.

To exploit them, an attacker would need to set up a rogue web site, then
lure a user of this host visit it using Opera. He would then be able
to execute arbitrary code on this host.

Solution : Install Opera 7.21 or newer
Risk factor : High";



 script_description(english:desc["english"]);
 
 summary["english"] = "Determines the version of Opera.exe";

 script_summary(english:summary["english"]);
 
 script_category(ACT_GATHER_INFO);
 
 script_copyright(english:"This script is Copyright (C) 2003 Tenable Network Security");
 family["english"] = "Windows";
 script_family(english:family["english"]);
 
 script_dependencies("opera_multiple_flaws.nasl");
 script_require_keys("Host/Windows/Opera/Version");
 exit(0);
}



v = get_kb_item("Host/Windows/Opera/Version");
if(strlen(v))
{
  v2 = split(v, sep:'.', keep:FALSE);
  if(int(v2[0]) < 7 || (int(v2[0]) == 7 && int(v2[1]) < 21))security_hole(port);
}
