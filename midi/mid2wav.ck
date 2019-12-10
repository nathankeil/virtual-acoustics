//----------------------------------------------------------------------
// file>         mid2wav.ck
// author>       Nathan Keil
// date>         October 31, 2018
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

// create array of [StkInstrument]
StkInstrument stkInstruments[23];
    
new BandedWG @=> BandedWG @ inst1;
new BlowBotl @=> BlowBotl @ inst2;
new BlowHole @=> BlowHole @ inst3;
new Bowed @=> Bowed @ inst4;
new Brass @=> Brass @ inst5;
new Clarinet @=> Clarinet @ inst6;
new Flute @=> Flute @ inst7;
new Mandolin @=> Mandolin @ inst8;
new ModalBar @=> ModalBar @ inst9;
new Moog @=> Moog @ inst10;
new Saxofony @=> Saxofony @ inst11;
new Shakers @=> Shakers @ inst12;
new Sitar @=> Sitar @ inst13;
new StifKarp @=> StifKarp @ inst14;
new VoicForm @=> VoicForm @ inst15;
new FM @=> FM @ inst16;
new BeeThree @=> BeeThree @ inst17;
new FMVoices @=> FMVoices @ inst18;
new HevyMetl @=> HevyMetl @ inst19;
new PercFlut @=> PercFlut @ inst20;
new Rhodey @=> Rhodey @ inst21;
new TubeBell @=> TubeBell @ inst22;
new Wurley @=> Wurley @ inst23;
    
inst1 @=> stkInstruments[0];
inst2 @=> stkInstruments[1];
inst3 @=> stkInstruments[2];
inst4 @=> stkInstruments[3];
inst5 @=> stkInstruments[4];
inst6 @=> stkInstruments[5];
inst7 @=> stkInstruments[6];
inst8 @=> stkInstruments[7];
inst9 @=> stkInstruments[8];
inst10 @=> stkInstruments[9];
inst11 @=> stkInstruments[10];
inst12 @=> stkInstruments[11];
inst13 @=> stkInstruments[12];
inst14 @=> stkInstruments[13];
inst15 @=> stkInstruments[14];
inst16 @=> stkInstruments[15];
inst17 @=> stkInstruments[16];
inst18 @=> stkInstruments[17];
inst19 @=> stkInstruments[18];
inst20 @=> stkInstruments[19];
inst21 @=> stkInstruments[20];
inst22 @=> stkInstruments[21];
inst23 @=> stkInstruments[22];
    
// stkInstruments[selection-1] @=> stk;

// initialize variables
MidiFileIn min;
MidiMsg msg;
string filename;

// get file from command-line argument
if(me.args() == 0)
{
    // send error message
    <<<"no file given:">>>;
    me.exit();
}
else
    me.sourceDir() + me.arg(0) => filename;

// append extension
filename + ".mid" => string midifilename;    

// check MIDI file
if(!min.open(midifilename))
{
    <<<"unable to open MIDI file:", "'" + me.arg(0) + "'">>>;
    me.exit();
}

// print number of tracks in file
<<<"'" + me.arg(0) + "':", min.numTracks(), "tracks">>>;

// initialize array of instruments
int instruments[me.args()-1];

// assign instruments to array
for(0 => int i; i < instruments.size(); i++)
    Std.atoi(me.arg(i+1)) => instruments[i];

// initialize index
0 => int n;

// process each track concurrently in separate shreds
for(1 => int t; t < min.numTracks(); t++)
{
    spork ~ seq(t, instruments[n]);
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
fun void seq(int track, int instrument)
{   
    // get samples from ugen
    Gain g => WvOut w => blackhole;
    // append track number to output file
    filename + "-" + track => w.wavFilename;
    // print output file name and directory
    <<<"writing to file:", "'" + w.filename() + "'">>>;
    // set output gain
    1 => g.gain;
    
    /*
    // initialize ugen
    StkInstrument inst[4];
    
    // assign an instrument to inst
    for(0 => int i; i < 4; i++)
        stkInstruments[instrument-1] @=> inst[i];
    */
    
    // hack
    if(instrument == 1) {
        BandedWG inst[4];
        
        // 4-note polyphony
        for(int i; i < inst.size(); i++) inst[i] => g;
        
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
                // convert note value to frequency
                msg.data2 => Std.mtof => inst[note].freq;
                // normalize velocity value
                msg.data3/127.0 => inst[note].noteOn;
                // increment note var
                (note+1)%inst.size() => note;
            }
        }
    }
    
    if(instrument == 2) {
        BlowBotl inst[4];
        
        // 4-note polyphony
        for(int i; i < inst.size(); i++) inst[i] => g;
        
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
                // convert note value to frequency
                msg.data2 => Std.mtof => inst[note].freq;
                // normalize velocity value
                msg.data3/127.0 => inst[note].noteOn;
                // increment note var
                (note+1)%inst.size() => note;
            }
        }
    }
    
    if(instrument == 3) {
        BlowHole inst[4];
        
        // 4-note polyphony
        for(int i; i < inst.size(); i++) inst[i] => g;
        
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
                // convert note value to frequency
                msg.data2 => Std.mtof => inst[note].freq;
                // normalize velocity value
                msg.data3/127.0 => inst[note].noteOn;
                // increment note var
                (note+1)%inst.size() => note;
            }
        }
    }
    
    if(instrument == 4) {
        Bowed inst[4];
        
        // 4-note polyphony
        for(int i; i < inst.size(); i++) inst[i] => g;
        
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
                // convert note value to frequency
                msg.data2 => Std.mtof => inst[note].freq;
                // normalize velocity value
                msg.data3/127.0 => inst[note].noteOn;
                // increment note var
                (note+1)%inst.size() => note;
            }
        }
    }
    
    if(instrument == 5) {
        Brass inst[4];
        
        // 4-note polyphony
        for(int i; i < inst.size(); i++) inst[i] => g;
        
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
                // convert note value to frequency
                msg.data2 => Std.mtof => inst[note].freq;
                // normalize velocity value
                msg.data3/127.0 => inst[note].noteOn;
                // increment note var
                (note+1)%inst.size() => note;
            }
        }
    }
    
    if(instrument == 6) {
        Clarinet inst[4];
        
        // 4-note polyphony
        for(int i; i < inst.size(); i++) inst[i] => g;
        
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
                // convert note value to frequency
                msg.data2 => Std.mtof => inst[note].freq;
                // normalize velocity value
                msg.data3/127.0 => inst[note].noteOn;
                // increment note var
                (note+1)%inst.size() => note;
            }
        }
    }
    
    if(instrument == 7) {
        Flute inst[4];
        
        // 4-note polyphony
        for(int i; i < inst.size(); i++) inst[i] => g;
        
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
                // convert note value to frequency
                msg.data2 => Std.mtof => inst[note].freq;
                // normalize velocity value
                msg.data3/127.0 => inst[note].noteOn;
                // increment note var
                (note+1)%inst.size() => note;
            }
        }
    }
    
    if(instrument == 8) {
        Mandolin inst[4];
        
        // 4-note polyphony
        for(int i; i < inst.size(); i++) inst[i] => g;
        
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
                // convert note value to frequency
                msg.data2 => Std.mtof => inst[note].freq;
                // normalize velocity value
                msg.data3/127.0 => inst[note].noteOn;
                // increment note var
                (note+1)%inst.size() => note;
            }
        }
    }
    
    if(instrument == 9) {
        ModalBar inst[4];
        
        // 4-note polyphony
        for(int i; i < inst.size(); i++) inst[i] => g;
        
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
                // convert note value to frequency
                msg.data2 => Std.mtof => inst[note].freq;
                // normalize velocity value
                msg.data3/127.0 => inst[note].noteOn;
                // increment note var
                (note+1)%inst.size() => note;
            }
        }
    }
    
    if(instrument == 10) {
        Moog inst[4];
        
        // 4-note polyphony
        for(int i; i < inst.size(); i++) inst[i] => g;
        
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
                // convert note value to frequency
                msg.data2 => Std.mtof => inst[note].freq;
                // normalize velocity value
                msg.data3/127.0 => inst[note].noteOn;
                // increment note var
                (note+1)%inst.size() => note;
            }
        }
    }
    
    if(instrument == 11) {
        Saxofony inst[4];
        
        // 4-note polyphony
        for(int i; i < inst.size(); i++) inst[i] => g;
        
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
                // convert note value to frequency
                msg.data2 => Std.mtof => inst[note].freq;
                // normalize velocity value
                msg.data3/127.0 => inst[note].noteOn;
                // increment note var
                (note+1)%inst.size() => note;
            }
        }
    }
    
    if(instrument == 12) {
        Shakers inst[4];
        
        // 4-note polyphony
        for(int i; i < inst.size(); i++) inst[i] => g;
        
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
                // convert note value to frequency
                msg.data2 => Std.mtof => inst[note].freq;
                // normalize velocity value
                msg.data3/127.0 => inst[note].noteOn;
                // increment note var
                (note+1)%inst.size() => note;
            }
        }
    }
    
    if(instrument == 13) {
        Sitar inst[4];
        
        // 4-note polyphony
        for(int i; i < inst.size(); i++) inst[i] => g;
        
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
                // convert note value to frequency
                msg.data2 => Std.mtof => inst[note].freq;
                // normalize velocity value
                msg.data3/127.0 => inst[note].noteOn;
                // increment note var
                (note+1)%inst.size() => note;
            }
        }
    }
    
    if(instrument == 14) {
        StifKarp inst[4];
        
        // 4-note polyphony
        for(int i; i < inst.size(); i++) inst[i] => g;
        
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
                // convert note value to frequency
                msg.data2 => Std.mtof => inst[note].freq;
                // normalize velocity value
                msg.data3/127.0 => inst[note].noteOn;
                // increment note var
                (note+1)%inst.size() => note;
            }
        }
    }
    
    if(instrument == 15) {
        VoicForm inst[4];
        
        // 4-note polyphony
        for(int i; i < inst.size(); i++) inst[i] => g;
        
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
                // convert note value to frequency
                msg.data2 => Std.mtof => inst[note].freq;
                // normalize velocity value
                msg.data3/127.0 => inst[note].noteOn;
                // increment note var
                (note+1)%inst.size() => note;
            }
        }
    }
    
    if(instrument == 16) {
        FM inst[4];
        
        // 4-note polyphony
        for(int i; i < inst.size(); i++) inst[i] => g;
        
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
                // convert note value to frequency
                msg.data2 => Std.mtof => inst[note].freq;
                // normalize velocity value
                msg.data3/127.0 => inst[note].noteOn;
                // increment note var
                (note+1)%inst.size() => note;
            }
        }
    }
    
    if(instrument == 17) {
        BeeThree inst[4];
        
        // 4-note polyphony
        for(int i; i < inst.size(); i++) inst[i] => g;
        
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
                // convert note value to frequency
                msg.data2 => Std.mtof => inst[note].freq;
                // normalize velocity value
                msg.data3/127.0 => inst[note].noteOn;
                // increment note var
                (note+1)%inst.size() => note;
            }
        }
    }
    
    if(instrument == 18) {
        FMVoices inst[4];
        
        // 4-note polyphony
        for(int i; i < inst.size(); i++) inst[i] => g;
        
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
                // convert note value to frequency
                msg.data2 => Std.mtof => inst[note].freq;
                // normalize velocity value
                msg.data3/127.0 => inst[note].noteOn;
                // increment note var
                (note+1)%inst.size() => note;
            }
        }
    }
    
    if(instrument == 19) {
        HevyMetl inst[4];
        
        // 4-note polyphony
        for(int i; i < inst.size(); i++) inst[i] => g;
        
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
                // convert note value to frequency
                msg.data2 => Std.mtof => inst[note].freq;
                // normalize velocity value
                msg.data3/127.0 => inst[note].noteOn;
                // increment note var
                (note+1)%inst.size() => note;
            }
        }
    }
    
    if(instrument == 20) {
        PercFlut inst[4];
        
        // 4-note polyphony
        for(int i; i < inst.size(); i++) inst[i] => g;
        
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
                // convert note value to frequency
                msg.data2 => Std.mtof => inst[note].freq;
                // normalize velocity value
                msg.data3/127.0 => inst[note].noteOn;
                // increment note var
                (note+1)%inst.size() => note;
            }
        }
    }
    
    if(instrument == 21) {
        Rhodey inst[4];
        
        // 4-note polyphony
        for(int i; i < inst.size(); i++) inst[i] => g;
        
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
                // convert note value to frequency
                msg.data2 => Std.mtof => inst[note].freq;
                // normalize velocity value
                msg.data3/127.0 => inst[note].noteOn;
                // increment note var
                (note+1)%inst.size() => note;
            }
        }
    }
    
    if(instrument == 22) {
        TubeBell inst[4];
        
        // 4-note polyphony
        for(int i; i < inst.size(); i++) inst[i] => g;
        
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
                // convert note value to frequency
                msg.data2 => Std.mtof => inst[note].freq;
                // normalize velocity value
                msg.data3/127.0 => inst[note].noteOn;
                // increment note var
                (note+1)%inst.size() => note;
            }
        }
    }

    if(instrument == 23) {
        Wurley inst[4];
   
     // 4-note polyphony
        for(int i; i < inst.size(); i++) inst[i] => g;
        
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
                // convert note value to frequency
                msg.data2 => Std.mtof => inst[note].freq;
                // normalize velocity value
                msg.data3/127.0 => inst[note].noteOn;
                // increment note var
                (note+1)%inst.size() => note;
            }
        }
    }
    
    // increment counter
    c++;
    
    // close wave file when shred is removed
    null @=> w;
    
}
