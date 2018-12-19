# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3

DESCRIPTION="Radio frequency transmitter library for Raspberry Pi"
HOMEPAGE="https://github.com/F5OEO/librpitx"
EGIT_REPO_URI="https://github.com/F5OEO/librpitx.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~arm ~arm64"
IUSE=""

DEPEND="net-misc/ntp"
RDEPEND="${DEPEND}"
BDEPEND=""

PATCHES="${FILESDIR}/musl.patch"

src_prepare() {
	sed -i -e "s|CC *=.*|CC = ${CHOST}-gcc|" -e "s|CCP *=.*|CCP = ${CHOST}-g++|" -e "s|CFLAGS.*= |CFLAGS += |" -e "s|LDFLAGS.*= |LDFLAGS += |" -e "s|-O3 ||" -e "s|\$(AR)|${CHOST}-ar|" src/Makefile || die
	default
}

src_compile() {
	cd src
	default
}

src_install() {
	mkdir src/librpitx
	cp src/*.h src/librpitx
	doheader -r src/librpitx
	dolib.a src/librpitx.a
}
