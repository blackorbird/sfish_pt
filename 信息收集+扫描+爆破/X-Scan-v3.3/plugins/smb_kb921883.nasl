#
# (C) Tenable Network Security, Inc.
#

include("compat.inc");

if(description)
{
 script_id(22194);
 script_version("$Revision: 1.11 $");

 script_cve_id("CVE-2006-3439");
 script_bugtraq_id(19409);
 script_xref(name:"OSVDB", value:"27845");

 script_name(english:"MS06-040: Vulnerability in Server Service Could Allow Remote Code Execution (921883) (uncredentialed check)");
 script_summary(english:"Determines the presence of update 921883");
 
 script_set_attribute(
  attribute:"synopsis",
  value:string(
   "Arbitrary code can be executed on the remote host due to a flaw in the\n",
   "'Server' service."
  )
 );
 script_set_attribute(
  attribute:"description", 
  value:string(
   "The remote host is vulnerable to a buffer overrun in the 'Server'\n",
   "service that may allow an attacker to execute arbitrary code on the\n",
   "remote host with 'SYSTEM' privileges."
  )
 );
 script_set_attribute(
  attribute:"solution", 
  value:string(
   "Microsoft has released a set of patches for Windows 2000, XP and\n",
   "2003 :\n",
   "\n",
   "http://www.microsoft.com/technet/security/bulletin/ms06-040.mspx"
  )
 );
 script_set_attribute(
  attribute:"cvss_vector", 
  value:"CVSS2#AV:N/AC:L/Au:N/C:C/I:C/A:C"
 );
 script_end_attributes();

 script_category(ACT_GATHER_INFO);
 script_copyright(english:"This script is Copyright (C) 2006-2009 Tenable Network Security, Inc.");
 script_family(english:"Windows");
 script_dependencies("smb_nativelanman.nasl","smb_login.nasl");
 script_require_keys("Host/OS/smb");
 script_require_ports(139, 445);
 exit(0);
}

#

include ('smb_func.inc');

global_var rpipe;

function  NetPathCanonicalize ()
{
 local_var fid, data, rep, ret;

 fid = bind_pipe (pipe:"\browser", uuid:"4b324fc8-1670-01d3-1278-5a47bf6ee188", vers:3);
 if (isnull (fid))
   return 0;

 # we initialize the buffer first
 data = class_parameter (name:"m", ref_id:0x20000) +
	class_name (name:"") + 
	raw_dword (d:20) +
        class_name (name:"nessus") + # wcscpy in the buffer
	raw_dword (d:1) +
	raw_dword (d:0) ;
	

 data = dce_rpc_pipe_request (fid:fid, code:0x1f, data:data);
 if (!data)
   return 0;

 rep = dce_rpc_parse_response (fid:fid, data:data);
 if (!rep || (strlen(rep) != 32))
   return 0;
 
 ret = get_dword (blob:rep, pos:strlen(rep)-4);
 if ((ret != 0x84b) && (ret != 0x7b))
   return 0;

 # the patch should fill the buffer with 0, else it will return "nessus"
 data = class_parameter (name:"m", ref_id:0x20000) +
	class_name (name:"") +  # the path reinitialize the buffer
	raw_dword (d:20) +
        class_name (name:"") +
	raw_dword (d:1) +
	raw_dword (d:0) ;
 
 data = dce_rpc_pipe_request (fid:fid, code:0x1f, data:data);
 if (!data)
   return 0;

 rep = dce_rpc_parse_response (fid:fid, data:data);
 if (!rep || (strlen(rep) != 32))
   return 0;

 ret = get_dword (blob:rep, pos:strlen(rep)-4);
 if ((ret != 0x84b) && (ret != 0x7b))
   return 0;

 ret = get_dword (blob:rep, pos:0);
 if (ret != 20)
   return 0;

 ret = get_string (blob:rep, pos:4, _type:1);
 if (ret == "nessus\")
   return 1;

 return 0;
}

os = get_kb_item ("Host/OS/smb") ;
if ("Windows" >!< os) exit(0);

name	= kb_smb_name();
port	= kb_smb_transport();

if ( ! get_port_state(port) ) exit(0);
soc = open_sock_tcp(port);
if ( ! soc ) exit(0);

session_init(socket:soc, hostname:name);

r = NetUseAdd(share:"IPC$");
if ( r == 1 )
{
 ret = NetPathCanonicalize ();
 if (ret == 1)
   security_hole(port:port);

 NetUseDel();
}
