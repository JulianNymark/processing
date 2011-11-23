Settings s = new Settings();
MassHandler mh = new MassHandler(s);
MouseDrag md = new MouseDrag(mh);

void setup() {
    size(1280, 800);
    frameRate(60);
    //see Settings for the actual settings
}

void draw() {
    background(105);
    md.update();
    mh.update();
}

