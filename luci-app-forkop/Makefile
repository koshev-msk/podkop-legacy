include $(TOPDIR)/rules.mk

PKG_NAME:=luci-app-forkop

FORKOP_SOURCE_VERSION:=$(or $(FORKOP_PACKAGE_VERSION),$(FORKOP_VERSION))
FORKOP_HAS_RELEASE_VERSION:=$(if $(filter dev,$(FORKOP_SOURCE_VERSION)),,$(FORKOP_SOURCE_VERSION))
FORKOP_GIT_DIR:=$(dir $(firstword $(MAKEFILE_LIST)))
FORKOP_GIT_COMMIT:=$(shell git -C $(FORKOP_GIT_DIR) rev-parse --short HEAD 2>/dev/null || echo unknown)
FORKOP_GIT_TAG:=$(shell git -C $(FORKOP_GIT_DIR) describe --tags --abbrev=0 --match '[0-9]*.[0-9]*.[0-9]*' 2>/dev/null | grep -E '^[0-9]+\.[0-9]+\.[0-9]+$$')
FORKOP_GIT_VERSION:=$(or $(FORKOP_GIT_TAG),0.0.0)_git~$(FORKOP_GIT_COMMIT)
FORKOP_COMPILED_VERSION:=$(or $(FORKOP_HAS_RELEASE_VERSION),$(FORKOP_GIT_VERSION))
FORKOP_RELEASE_VERSION_VALID:=$(if $(FORKOP_HAS_RELEASE_VERSION),$(shell printf '%s\n' '$(FORKOP_SOURCE_VERSION)' | grep -Eq '^[0-9]+\.[0-9]+\.[0-9]+$$' && printf '1'),1)

ifeq ($(FORKOP_RELEASE_VERSION_VALID),)
$(error FORKOP_PACKAGE_VERSION and FORKOP_VERSION must use x.y.z format)
endif

PKG_VERSION:=$(or $(FORKOP_HAS_RELEASE_VERSION),$(FORKOP_GIT_VERSION))
PKG_RELEASE:=
PKG_PO_VERSION:=$(PKG_VERSION)

LUCI_TITLE:=LuCI Forkop app
LUCI_DEPENDS:=+luci-base +forkop
LUCI_PKGARCH:=all
LUCI_LANG.ru:=Русский (Russian)
LUCI_LANG.en:=English
LUCI_MAINTAINER:=ushan0v <ushan0v@users.noreply.github.com>
LUCI_DESCRIPTION:=Rule-based Forkop LuCI app with hybrid sing-box + zapret orchestration
LUCI_MINIFY_JS:=0

PKG_LICENSE:=GPL-2.0-or-later
LUCI_LANGUAGES:=en ru

define Build/Prepare/$(PKG_NAME)
	sed -i -e 's/__COMPILED_VERSION_VARIABLE__/$(FORKOP_COMPILED_VERSION)/g' $(PKG_BUILD_DIR)/htdocs/luci-static/resources/view/forkop/main.js
endef

include $(TOPDIR)/feeds/luci/luci.mk

# call BuildPackage - OpenWrt buildroot signature
