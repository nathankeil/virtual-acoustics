// select instrument:
// 1: BandedWG
// 2: BlowBotl
// 3: BlowHole
// 4: Bowed
// 5: Brass
// 6: Clarinet
// 7: Flute
// 8: Mandolin
// 9: ModalBar
// 10: Moog
// 11: Saxofony
// 12: Shakers
// 13: Sitar
// 14: StifKarp
// 15: VoicForm
// 16: FM
// 17: BeeThree
// 18: FMVoices
// 19: HevyMetl
// 20: PercFlut
// 21: Rhodey 
// 22: TubeBell
// 23: Wurley

fun StkInstrument stkSelect(int selection)
{
    // create array of [StkInstrument]
    StkInstrument instruments[23];
    
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

    inst1 @=> instruments[0];
    inst2 @=> instruments[1];
    inst3 @=> instruments[2];
    inst4 @=> instruments[3];
    inst5 @=> instruments[4];
    inst6 @=> instruments[5];
    inst7 @=> instruments[6];
    inst8 @=> instruments[7];
    inst9 @=> instruments[8];
    inst10 @=> instruments[9];
    inst11 @=> instruments[10];
    inst12 @=> instruments[11];
    inst13 @=> instruments[12];
    inst14 @=> instruments[13];
    inst15 @=> instruments[14];
    inst16 @=> instruments[15];
    inst17 @=> instruments[16];
    inst18 @=> instruments[17];
    inst19 @=> instruments[18];
    inst20 @=> instruments[19];
    inst21 @=> instruments[20];
    inst22 @=> instruments[21];
    inst23 @=> instruments[22];
    
    return StkInstrument stk;
    instruments[selection-1] @=> stk;
}

if(me.args() != 0)
    spork ~ stkSelect(me.arg(0));
