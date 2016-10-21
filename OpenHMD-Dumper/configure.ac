name='openhmd'
version='0.0.1'
library_interface_version='0:0:0'
email='noname@nurd.se'

AC_PREREQ([2.13])
AC_INIT([openhmd], [0.0.1], [noname@nurd.se])
AM_INIT_AUTOMAKE([foreign -Wall])
m4_ifdef([AM_PROG_AR], [AM_PROG_AR])
LT_INIT
AC_CANONICAL_HOST

# 0.24 automatically calls AC_SUBST() in PKG_CHECK_MODULES()
PKG_PROG_PKG_CONFIG([0.24])

m4_ifdef([AM_SILENT_RULES], [AM_SILENT_RULES([yes])])

hidapi="hidapi"

AC_SUBST(PKG_CONFIG_EXTRA_PATH, "")
AC_SUBST(EXTRA_LD_FLAGS, "")

AC_MSG_CHECKING([operating system])
AS_CASE(["$host"],
	[*-linux*],
		[AC_MSG_RESULT([$host (Linux)])
		hidapi="hidapi-libusb"

		#link with realtime lib on linux for clock_gettime
		AC_SUBST(EXTRA_LD_FLAGS, "-lrt -lpthread")],
	[*-freebsd*],
		[AC_SUBST(PKG_CONFIG_EXTRA_PATH, "libdata/")])

# Dumper Driver
AC_ARG_ENABLE([driver-dumper],
        [AS_HELP_STRING([--disable-driver-dumper],
                [disable building of Dumper [default=yes]])],
        [driver_dumper_enabled=$enableval],
        [driver_dumper_enabled='yes'])

AM_CONDITIONAL([BUILD_DRIVER_DUMPER], [test "x$driver_dumper_enabled" != "xno"])

# Libs required by Dumper Driver
AS_IF([test "x$driver_dumper_enabled" != "xno"],
	[PKG_CHECK_MODULES([hidapi], [$hidapi] >= 0.0.5)])

AC_PROG_CC
AC_PROG_CC_C99

AC_CONFIG_HEADERS([config.h])
AC_CONFIG_FILES([Makefile src/Makefile examples/Makefile examples/dumper/Makefile])
AC_OUTPUT
