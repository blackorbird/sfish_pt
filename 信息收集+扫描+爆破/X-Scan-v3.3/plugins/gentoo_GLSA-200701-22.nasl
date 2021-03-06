# This script was automatically generated from 
#  http://www.gentoo.org/security/en/glsa/glsa-200701-22.xml
# It is released under the Nessus Script Licence.
# The messages are release under the Creative Commons - Attribution /
# Share Alike license. See http://creativecommons.org/licenses/by-sa/2.0/
#
# Avisory is copyright 2001-2006 Gentoo Foundation, Inc.
# GLSA2nasl Convertor is copyright 2004-2009 Tenable Network Security, Inc.

if (! defined_func('bn_random')) exit(0);

include('compat.inc');

if (description)
{
 script_id(24258);
 script_version("$Revision: 1.4 $");
 script_xref(name: "GLSA", value: "200701-22");
 script_cve_id("CVE-2007-0247", "CVE-2007-0248");

 script_set_attribute(attribute:'synopsis', value: 'The remote host is missing the GLSA-200701-22 security update.');
 script_set_attribute(attribute:'description', value: 'The remote host is affected by the vulnerability described in GLSA-200701-22
(Squid: Multiple Denial of Service vulnerabilities)


    Squid fails to correctly handle ftp:// URI\'s. There is also an error in
    the external_acl queue which can cause an infinite looping condition.
  
Impact

    An attacker could attempt to retrieve a specially crafted URI via a
    Squid server causing the service to crash. If an attacker could
    generate a sufficiently high load on the Squid services, they could
    cause a Denial of Service by forcing Squid into an infinite loop.
  
Workaround

    There is no known workaround at this time.
  
');
script_set_attribute(attribute:'solution', value: '
    All Squid users should upgrade to the latest version:
    # emerge --sync
    # emerge --ask --oneshot --verbose ">=net-proxy/squid-2.6.7"
  ');
script_set_attribute(attribute: 'cvss_vector', value: 'CVSS2#AV:N/AC:L/Au:N/C:N/I:N/A:P');
script_set_attribute(attribute: 'see_also', value: 'http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2007-0247');
script_set_attribute(attribute: 'see_also', value: 'http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2007-0248');

script_set_attribute(attribute: 'see_also', value: 'http://www.gentoo.org/security/en/glsa/glsa-200701-22.xml');

script_end_attributes();

 script_copyright(english: "(C) 2009 Tenable Network Security, Inc.");
 script_name(english: '[GLSA-200701-22] Squid: Multiple Denial of Service vulnerabilities');
 script_category(ACT_GATHER_INFO);
 script_family(english: "Gentoo Local Security Checks");
 script_dependencies("ssh_get_info.nasl");
 script_require_keys('Host/Gentoo/qpkg-list');
 script_summary(english: 'Squid: Multiple Denial of Service vulnerabilities');
 exit(0);
}

include('qpkg.inc');

if ( ! get_kb_item('Host/Gentoo/qpkg-list') ) exit(1, 'No list of packages');
if (qpkg_check(package: "net-proxy/squid", unaffected: make_list("ge 2.6.7"), vulnerable: make_list("lt 2.6.7")
)) { security_warning(0); exit(0); }
exit(0, "Host is not affected");
