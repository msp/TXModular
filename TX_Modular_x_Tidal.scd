// Copyright (C) 2015  Paul Miller. This file is part of TX Modular system distributed under the terms of the GNU General Public License (see file LICENSE).

// PLEASE NOTE - make sure you have added the TX Modular extensions to SuperCollider before starting
// See the help file:   Adding_TX_Classes_To_SC3

// To start the TX Modular system:


TXSystem1.start;

TXSystem1.syncStart

s.makeGui
s.plotTree

a = TXSystem1.arrSystemModules[0]
a.createSynthNote(60, 120, 0);
a.releaseSynthGate(60);
a.setSynthArgSpec("hammer_pos", 1.0.rand);

(
t =
Task({
	loop {
		var note = 60;
		// a.setSynthArgSpec("hammer_pos", 1.0.rand);

		a.createSynthNote(note, 120, 0);
		0.25.wait;

		a.releaseSynthGate(note);

		0.25.wait;
	}
}).play;
)

t.stop;
// TXSystem1.setSynthValue ?



// Copying what `createSynthNote' does! (mostly) ////////////////////////////////////
(
var txSynth, txSynthDef, arrSynthArgs = [], synthDefName = "clonedTX", argNote=60, argVeloc=100, argEnvTime=1, seqLatencyOn=1, argNoteDetune=0;

// this would be the instance I created in the TX GUI
// txSynth = TXPianoStringSt.arrInstances[0];
txSynth = TXSystem1.arrSystemModules[0];

// so, grab it's def, really this is a 'clone' or create operation, I should rename it!
j = txSynth.getSynthDef(synthDefName);


// clone the synth state locally
txSynth.arrSynthArgSpecs.do({ arg item, i;
	"item".postln;
	item.postln;
	arrSynthArgs = arrSynthArgs.addAll([item.at(0), item.at(1)]);
});

"normal...".postln;
arrSynthArgs.postln;
"collect...".postln;


// this is what's passed when the SynthDef is created.. It's won't work to play it.
// arrSynthArgs = txSynth.arrSynthArgSpecs.collect({arg item, i; item.at(2)});
// arrSynthArgs.postln;


// play the synth on the same node as the orig TX synth
x = Synth.new(synthDefName,
	arrSynthArgs ++ [\note, argNote + argNoteDetune, \velocity, argVeloc, \envtime, argEnvTime],
	// [], // so, the templated SynthDef doesn't have useful args :/
	txSynth.moduleNode,
	\addToTail ;
);
)
x.free;
/////////////////////////////////////////////////////////////////////////////////
(
t =
Task({
	loop {
		var txSynth, txSynthDef, arrSynthArgs = [], synthDefName = "clonedTX", argNote=60, argVeloc=100;
		var argEnvTime=1, seqLatencyOn=1, argNoteDetune=0;

		// this would be the instance I created in the TX GUI
		// txSynth = TXPianoStringSt.arrInstances[0];
		txSynth = TXSystem1.arrSystemModules[0];

		// so, grab it's def, really this is a 'clone' or create operation, I should rename it!
		j = txSynth.getSynthDef(synthDefName);

		// clone the synth state locally
		txSynth.arrSynthArgSpecs.do({ arg item, i;
			arrSynthArgs = arrSynthArgs.addAll([item.at(0), item.at(1)]);
		});

		// arrSynthArgs.postln;
		("playing..."+synthDefName).postln;

		// play the synth on the same node as the orig TX synth
		x = Synth.new(synthDefName,
			arrSynthArgs ++ [\note, argNote + argNoteDetune, \velocity, argVeloc, \envtime, argEnvTime],
			// [], // so, the templated SynthDef doesn't have useful args :/
			txSynth.moduleNode,
			\addToTail ;
		);
		2.5.wait;
		("freeing..."+synthDefName).postln;
		x.free;
		0.5.wait;
	}
}).play;
)

x.free;t.stop;

// PANIC ////////////////////////////////////////////////////////////////////////
a.allNotesOff;

TXSystem1.arrSystemModules.do { |module|
	module.allNotesOff;
};


Server.freeAll
Server.killAll