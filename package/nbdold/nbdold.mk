################################################################################
#
# nbd
#
################################################################################

NBDOLD_VERSION = 3.9.1
NBDOLD_SOURCE = nbd-$(NBDOLD_VERSION).tar.xz
NBDOLD_SITE = http://downloads.sourceforge.net/project/nbd/nbd/$(NBDOLD_VERSION)
NBDOLD_CONF_OPTS = --enable-lfs
NBDOLD_DEPENDENCIES = libglib2
NBDOLD_LICENSE = GPL-2.0
NBDOLD_LICENSE_FILES = COPYING

ifeq ($(BR2_TOOLCHAIN_USES_UCLIBC),y)
# We have linux/falloc.h
# but uClibc lacks fallocate(2) which is a glibc-ism
NBDOLD_CONF_ENV = ac_cv_header_linux_falloc_h=no
endif

ifneq ($(BR2_PACKAGE_NBDOLD_CLIENT),y)
NBDOLD_TOREMOVE += /usr/sbin/nbd-client
endif
ifneq ($(BR2_PACKAGE_NBDOLD_SERVER),y)
NBDOLD_TOREMOVE += /usr/bin/nbd-server
endif
ifneq ($(BR2_PACKAGE_NBDOLD_TRDUMP),y)
NBDOLD_TOREMOVE += /usr/bin/nbd-trdump
endif

define NBDOLD_CLEANUP_AFTER_INSTALL
	rm -f $(addprefix $(TARGET_DIR), $(NBDOLD_TOREMOVE))
endef

NBDOLD_POST_INSTALL_TARGET_HOOKS += NBDOLD_CLEANUP_AFTER_INSTALL

$(eval $(autotools-package))
