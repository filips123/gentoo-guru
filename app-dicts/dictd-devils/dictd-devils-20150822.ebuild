# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="The Devil's Dictionary for dict"
HOMEPAGE="http://www.dict.org"
SRC_URI="http://www.gutenberg.org/files/972/972.zip -> ${P}.zip"
S="$WORKDIR"
LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND=">=app-text/dictd-1.5.5"
BDEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}/format.patch" )

src_prepare() {
	eapply_user

	sed -e 's/\r//g' -i 972.txt
	sed -e "/^ *THE DEVIL'S DICTIONARY/,/^End of Project Gutenberg's The Devil's Dictionary/!{w COPYING.gutenberg" -e 'd}' -i 972.txt
	sed -e '/^\S/{: l;N;s/\n *\(.\)/ \1/g;t l}' -i 972.txt
	sed -e "s/^\\([A-Zor .'?-]*[^,A-Zor .'?-]\\)/ \1/" -i 972.txt
	sed -e '/^ /y/,/\a/' -i 972.txt
}

src_compile() {
	head -n -6 972.txt | dictfmt -u "${SRC_URI% ->*}" \
		-s "The Devil's Dictionary (2015-08-22 Project Gutenberg version)" \
		--headword-separator " or " \
		--columns 80 \
		-h devils
	sed -e 'y/\a/,/' -i devils.dict
	dictzip devils.dict
}

src_install() {
	insinto /var/dict
	doins devils.dict.dz devils.index
}
