include $(TOPDIR)/rules.mk

PKG_NAME:=podkop
PKG_BASE_VERSION=0.7.19

PKG_GIT_BRANCH := $(shell git -C $(dir $(firstword $(MAKEFILE_LIST))) rev-parse --abbrev-ref HEAD 2>/dev/null || echo unknown)
PKG_GIT_COMMIT := $(shell git -C $(dir $(firstword $(MAKEFILE_LIST))) rev-parse --short HEAD 2>/dev/null || echo unknown)

PKG_VERSION := $(if $(PODKOP_VERSION),$(PODKOP_VERSION)-$(PKG_GIT_BRANCH)~$(PKG_GIT_COMMIT),$(PKG_BASE_VERSION)-$(PKG_GIT_BRANCH)~$(PKG_GIT_COMMIT))
#PKG_VERSION := $(if $(PODKOP_VERSION),$(PODKOP_VERSION),0.$(shell date +%d%m%Y))

PKG_RELEASE:=1

PKG_MAINTAINER:=ITDog <podkop@itdog.info>
PKG_LICENSE:=GPL-2.0-or-later

include $(INCLUDE_DIR)/package.mk

define Package/podkop
	SECTION:=net
	CATEGORY:=Network
	DEPENDS:=+sing-box +curl +jq +kmod-ipt-tproxy +iptables-mod-tproxy +ipset +kmod-ipt-ipset +coreutils-base64 +bind-dig
	CONFLICTS:=https-dns-proxy nextdns luci-app-passwall luci-app-passwall2
	TITLE:=Domain routing app
	URL:=https://podkop.net
	PKGARCH:=all
endef

define Package/podkop/description
	Domain routing. Use of VLESS, Shadowsocks technologies
endef

define Build/Configure
endef

define Build/Compile
endef

define Package/podkop/prerm
#!/bin/sh

grep -q "105 podkop" /etc/iproute2/rt_tables && sed -i "/105 podkop/d" /etc/iproute2/rt_tables

/etc/init.d/podkop stop

exit 0
endef

define Package/podkop/conffiles
/etc/config/podkop
endef

define Package/podkop/install
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) ./files/etc/init.d/podkop $(1)/etc/init.d/podkop

	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_CONF) ./files/etc/config/podkop $(1)/etc/config/podkop

	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) ./files/usr/bin/podkop $(1)/usr/bin/podkop

	$(INSTALL_DIR) $(1)/usr/lib/podkop
	$(CP) ./files/usr/lib/* $(1)/usr/lib/podkop/

	sed -i -e 's/__COMPILED_VERSION_VARIABLE__/$(PKG_VERSION)/g' $(1)/usr/lib/podkop/constants.sh
endef

$(eval $(call BuildPackage,podkop))
