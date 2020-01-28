//----------------------------------------------------------------------
// file>         mid2wav.ck
// author>       Nathan Keil
// date>         January 27, 2020
// 
// description> 
//     synthesizes a MIDI file using an STK instrument(s) specified by 
//     one or more arguments and writes the output to a separate .wav 
//     file for each track in the MIDI file, ignoring track 0. takes 
//     input from two or more command-line arguments in the form of a 
//     MIDI file without the extension (.mid) and an integer(s) 
//     representing the instrument (see README.txt). can be done in non-
//     real time by using silent mode (-s) 
//
// arguments>    
//     mid2wav.ck:<filename>:<instrument1><instrument2><...>
//----------------------------------------------------------------------

// initialize variables
MidiFileIn min;
MidiMsg msg;
string midifilename;
string wavfilename;

// get file from command-line argument
if(me.args() == 0)
{
    // send error message
    <<<"no file given:">>>;
    me.exit();
}
else
{
    // add full path
    me.dir(1) + "data/midi/" + me.arg(0) => midifilename;
    me.dir(1) + "data/audio/" + me.arg(0) => wavfilename; 
}

// append extension
midifilename + ".mid" => midifilename;    

// check MIDI file
if(!min.open(midifilename))
{
    <<<"unable to open MIDI file:", "'" + me.arg(0) + "'">>>;
    me.exit();
}

// print number of tracks in file
<<<"'" + me.arg(0) + "':", min.numTracks(), "tracks">>>;

// initialize index variable
0 => int n;

// process each track concurrently in separate shreds
for(1 => int t; t < min.numTracks(); t++)
{
    spork ~ seq(t);
    n++;
}

// initialize counter variable
1 => int c;

// increment time while tracks are being processed
while(c < min.numTracks())
    1::second => now;

// close MIDI file when completed
min.close();

// function to sequence MIDI data
fun void seq(int track)
{   
    // get samples from ugen
    Gain g => WvOut w => blackhole;
    
    // append track number to output file
    wavfilename + "-" + track => w.wavFilename;
    
    // print output file name and directory
    <<<"writing to file:", "'" + w.filename() + "'">>>;
    
    // set output gain
    1 => g.gain;
    
    // initialize ugen
    VoicForm inst[4];
    
    // phonemes
    [ "eee", "ihh", "ehh", "aaa", "ahh", "aww", "ohh", "uhh", "uuu", "ooo" ] @=> string phoNames[];

    // 4-note polyphony
    for(int i; i < inst.size(); i++) 
    {
        0.95 => inst[i].gain;
        0.5 => inst[i].loudness;
        0.01 => inst[i].vibratoGain;
        inst[i] => g;
    }
    
    // initialize note variable
    int note;
    
    // assign values to ugen parameters
    while(min.read(msg, track))
    {    
        // check if duration > 0
        if(msg.when > 0::second)
            // increment time
            msg.when => now;
        
        // check status (data1), note (data2), velocity (data3)
        if((msg.data1 & 0xF0) == 0x90 && msg.data2 > 0 && msg.data3 > 0)
        {
            // assign random phoneme to note
            phoNames[Math.random2(0,phoNames.cap()-1)] => inst[note].phoneme;
            
            // convert note value to frequency
            msg.data2 => Std.mtof => inst[note].freq;
            
            // normalize velocity value
            msg.data3/127.0 => inst[note].noteOn;
            
            // increment note var
            (note+1)%inst.size() => note;
        }
    }
    
    // increment counter
    c++;
    
    // close wave file when shred is removed
    null @=> w;
    
}
