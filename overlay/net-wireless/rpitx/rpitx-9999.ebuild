# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3

DESCRIPTION="Radio transmitter for Raspberry Pi"
HOMEPAGE="https://github.com/F5OEO/rpitx"
EGIT_REPO_URI="https://github.com/F5OEO/rpitx.git"
EGIT_BRANCH="v2beta"

LICENSE="GPL"
SLOT="0"
KEYWORDS="~arm ~arm64"
IUSE="dvb"

DEPEND="net-wireless/librpitx
		media-libs/libsndfile
		media-gfx/imagemagick
		net-libs/liquid-dsp"
RDEPEND="${DEPEND}"
BDEPEND=""

src_prepare() {
	sed -i -e "s|CC *=.*|CC = ${CHOST}-gcc|" -e "s|CCP *=.*|CCP = ${CHOST}-g++|" -e "s|CFLAGS[\t ]*= |CFLAGS += |" -e "s|CFLAGS_Piam *=|CFLAGS_Piam = \$(CFLAGS)|" -e "s|CFLAGS_Pifm *=|CFLAGS_Pifm = \$(CFLAGS)|" \
	-e "s|CFLAGS_Pidcf77 *=|CFLAGS_Pidcf77 = \$(CFLAGS)|" -e "s|LDFLAGS *= |LDFLAGS += |" -e "s|-O3 ||" -e "s|\$(AR)|${CHOST}-ar|" -e "s| \.\./dvbrf| \.\./dvbrf \.\./pifm \.\./piam \.\./pidcf77|" \
	-e "s|librpitx/src/librpitx\.a|/usr/${CHOST}/usr/lib64/librpitx\.a|" -e "s|\.\./fm|fm|" -e "s|\.\./am|am|" -e "s|\.\./dcf77|dcf77|" -e "s|RpiTx\.cpp|RpiTx.c|" -e "s| librpitx/src/librpitx.h||" src/Makefile || die
	sed -i -e "s|#include \"librpitx/src/librpitx.h\"|#include <librpitx/librpitx.h>|" -e "s|#include \"../librpitx/src/librpitx.h\"|#include <librpitx/librpitx.h>|" src/*/*.c src/*.c src/*/*.cpp src/*.cpp || die
	#sed -i -e "s|#include \"mailbox.h\"|#include <librpitx/mailbox.h>|" -e "s|#include \"RpiGpio.h\"|#include <librpitx/gpio.h>|" -e "s|#include \"RpiDma.h\"|#include <librpitx/dma.h>|" src/RpiTx.c || die
	use !dvb && sed -i -e "s| \.\./dvbrf||" -e "s| /usr/bin| ${D}/usr/bin|" src/Makefile || die
	default
}

src_compile() {
	cd src
	default
}

src_install() {
	dobin pisstv piopera pifsq pichirp sendiq tune freedv pifm piam pidcf77
	use dvb && dobin dvbrf
	#dobin ../snapsstv.sh ../testam.sh ../testfsq.sh ../testopera.sh ../testssb.sh ../testsstv.sh ../testvfo.sh ../transponder.sh
}
