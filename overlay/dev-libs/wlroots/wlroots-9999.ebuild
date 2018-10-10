# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit git-r3 meson
#inherit meson

DESCRIPTION="i3-compatible Wayland window manager"
HOMEPAGE="http://swaywm.org/"

EGIT_REPO_URI="https://github.com/swaywm/wlroots.git"
EGIT_CLONE_TYPE="shallow"

#SRC_URI="https://distfiles.gentoo.org/distfiles/wlroots-0.1.tar.xz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~arm64"
IUSE="libcap systemd elogind X"

DEPEND="dev-libs/libinput
	x11-libs/libxkbcommon
	x11-libs/libdrm
	dev-libs/wayland
	dev-libs/wayland-protocols
	virtual/libudev
	x11-libs/pixman
	media-libs/mesa[egl,gles2,gbm]
	X? ( x11-libs/libxcb )
	X? ( x11-proto/xcb-proto )
	libcap? ( sys-libs/libcap )
	systemd? ( sys-apps/systemd )"

RDEPEND="${DEPEND}"

#PATCHES="${FILESDIR}/tty.patch"

src_configure() {
	local emesonargs=(
			-Dlibcap=$(usex libcap enabled disabled)
			-Dlogind=$(usex elogind enabled disabled)
			-Dxcb-errors=$(usex X enabled disabled)
			-Dxwayland=$(usex X enabled disabled)
			-Dx11-backend=$(usex X enabled disabled)
			-Drootston=false
			-Dexamples=false
	)

	meson_src_configure
}
