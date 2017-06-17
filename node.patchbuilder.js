//
// SMTk - Starbound Mod Toolkit
// ---
// @copyright (c) 2017 Damian Bushong <katana@odios.us>
// @license MIT license
// @url <https://github.com/damianb/>
// @reddit <https://reddit.com/u/katana__>
//
/*jslint node: true, asi: true */
"use strict"
let sbPatchbuilder = require('sb-buildpatches')
sbPatchbuilder({
	workingDir: process.env.patchbasedir,
	dest: process.env.srcdir,
	starboundAssets: process.env.sbassetsdir
})