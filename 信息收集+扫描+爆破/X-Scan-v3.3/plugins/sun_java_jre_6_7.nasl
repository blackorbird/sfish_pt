#
#  (C) Tenable Network Security, Inc.
#



include("compat.inc");

if (description)
{
  script_id(33488);
  script_version("$Revision: 1.5 $");

  script_cve_id(
    "CVE-2008-3103",
    "CVE-2008-3104",
    "CVE-2008-3105",
    "CVE-2008-3106",
    "CVE-2008-3107",
    "CVE-2008-3109",
    "CVE-2008-3110",
    "CVE-2008-3111",
    "CVE-2008-3112",
    "CVE-2008-3114",
    "CVE-2008-3115"
  );
  script_bugtraq_id(30140, 30141, 30142, 30143, 30144, 30146, 30148);
  script_xref(name:"OSVDB", value:"46955");
  script_xref(name:"OSVDB", value:"46956");
  script_xref(name:"OSVDB", value:"46958");
  script_xref(name:"OSVDB", value:"46959");
  script_xref(name:"OSVDB", value:"46960");
  script_xref(name:"OSVDB", value:"46961");
  script_xref(name:"OSVDB", value:"46963");
  script_xref(name:"OSVDB", value:"46964");
  script_xref(name:"OSVDB", value:"46965");
  script_xref(name:"OSVDB", value:"46966");
  script_xref(name:"OSVDB", value:"46967");

  script_name(english:"Sun Java JDK/JRE 6 < Update 7 Multiple Vulnerabilities" );
  script_summary(english:"Checks version of Sun JRE"); 
 
 script_set_attribute(attribute:"synopsis", value:
"The remote Windows host has an application that is affected by
multiple vulnerabilities." );
 script_set_attribute(attribute:"description", value:
"The version of Sun Java Runtime Environment (JRE) 6.0 installed on the
remote host is affected by multiple security issues :

- A vulnerability in the JRE could allow unauthorized access to certain
  URL resources or cause a denial of service condition while
  processing XML data. In order to successfully exploit this issue
  a JAX-WS client/service included with a trusted application should
  process the malicious XML content (238628).

- A vulnerability in the JRE may allow an untrusted applet to access
  information from another applet (238687).

- A buffer overflow vulnerability in Java Web Start could allow an
  untrusted applet to elevate its privileges to read, write and
  execute local applications available to user running an untrusted
  application (238905).

- A vulnerability in Java Web Start, could allow an untrusted
  application to create or delete arbitrary files subject to
  the privileges of the user running the application (238905).

- A vulnerability in Java Web Start, may disclose the location of
  Java Web Start cache (238905).

- An implementation defect in the JRE may allow an applet designed to run
  'only' on JRE 5.0 Update 6 or later may run on older releases of the JRE.
  Note this only affects Windows Vista releases of the JRE (238966).

- Vulnerability in Sun Java Management Extensions (JMX) could allow a 
  JMX client running on a remote host to perform unauthorized actions 
  on a host running JMX with local monitoring enabled (238965).

- A vulnerability in the JRE could allow an untrusted applet /
  application to elevate its privileges to read, write and execute 
  local applications with privileges of the user running an untrusted
  applet (238967,238687).

- A vulnerability in the JRE may allow an untrusted applet to establish
  connections to services running on the localhost and potentially
  exploit vulnerabilities existing in the underlying JRE (238968)." );
 script_set_attribute(attribute:"see_also", value:"http://sunsolve.sun.com/search/document.do?assetkey=1-66-238628-1" );
 script_set_attribute(attribute:"see_also", value:"http://sunsolve.sun.com/search/document.do?assetkey=1-66-238687-1" );
 script_set_attribute(attribute:"see_also", value:"http://sunsolve.sun.com/search/document.do?assetkey=1-66-238905-1" );
 script_set_attribute(attribute:"see_also", value:"http://sunsolve.sun.com/search/document.do?assetkey=1-66-238965-1" );
 script_set_attribute(attribute:"see_also", value:"http://sunsolve.sun.com/search/document.do?assetkey=1-66-238966-1" );
 script_set_attribute(attribute:"see_also", value:"http://sunsolve.sun.com/search/document.do?assetkey=1-66-238967-1" );
 script_set_attribute(attribute:"see_also", value:"http://sunsolve.sun.com/search/document.do?assetkey=1-66-238968-1" );
 script_set_attribute(attribute:"solution", value:
"Update to Sun Java JDK and JRE 6 Update 7 or later and remove if
necessary any affected versions." );
 script_set_attribute(attribute:"cvss_vector", value: "CVSS2#AV:N/AC:M/Au:N/C:C/I:C/A:C" );

script_end_attributes();

 
  script_category(ACT_GATHER_INFO);
  script_family(english:"Windows");

  script_copyright(english:"This script is Copyright (C) 2008-2009 Tenable Network Security, Inc.");

  script_dependencies("sun_java_jre_installed.nasl");
  script_require_keys("SMB/Java/JRE/Installed");

  exit(0);
}


include("global_settings.inc");


# Check each installed JRE.
installs = get_kb_list("SMB/Java/JRE/*");
if (isnull(installs)) exit(0);

info = "";
foreach install (keys(installs))
{
  ver = install - "SMB/Java/JRE/";
  if (ver =~ "^1\.6\.0_0[0-6][^0-9]?")
    info += '  - ' + ver + ', under ' + installs[install] + '\n';
}


# Report if any were found to be vulnerable.
if (info)
{
  if (report_verbosity)
  {
    if (max_index(split(info)) > 1) s = "s of Sun's JRE are";
    else s = " of Sun's JRE is";

    report = string(
      "\n",
      "The following vulnerable instance", s, " installed on the\n",
      "remote host :\n",
      "\n",
      info
    );
    security_hole(port:get_kb_item("SMB/transport"), extra:report);
  }
  else security_hole(get_kb_item("SMB/transport"));
}
