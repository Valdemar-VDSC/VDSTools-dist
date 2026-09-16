#import <AppKit/AppKit.h>

static void rrect(NSRect r, CGFloat rad, NSColor *fill, NSColor *stroke, CGFloat lw) {
  NSBezierPath *p = [NSBezierPath bezierPathWithRoundedRect:r xRadius:rad yRadius:rad];
  if (fill) { [fill set]; [p fill]; }
  if (stroke) { [stroke set]; p.lineWidth = lw; [p stroke]; }
}
static void draw(NSString *s, NSPoint at, NSFont *f, NSColor *c, CGFloat tracking) {
  NSMutableDictionary *a = [@{NSFontAttributeName:f, NSForegroundColorAttributeName:c} mutableCopy];
  if (tracking != 0) a[NSKernAttributeName] = @(tracking);
  [s drawAtPoint:at withAttributes:a];
}
static void render(NSString *out, NSString *shotPath, CGFloat H, BOOL en) {
  const CGFloat W = 1280, S = 1.5;
  const CGFloat dy = (H - 500) / 2;
  NSColor *ink   = [NSColor colorWithSRGBRed:0.925 green:0.941 blue:0.957 alpha:1];
  NSColor *muted = [NSColor colorWithSRGBRed:0.53 green:0.58 blue:0.63 alpha:1];
  NSColor *acc   = [NSColor colorWithSRGBRed:0.298 green:0.745 blue:0.792 alpha:1];
  NSColor *bg1   = [NSColor colorWithSRGBRed:0.047 green:0.059 blue:0.075 alpha:1];
  NSColor *bg2   = [NSColor colorWithSRGBRed:0.074 green:0.114 blue:0.133 alpha:1];

  NSBitmapImageRep *rep = [[NSBitmapImageRep alloc] initWithBitmapDataPlanes:NULL
      pixelsWide:W*S pixelsHigh:H*S bitsPerSample:8 samplesPerPixel:4 hasAlpha:YES isPlanar:NO
      colorSpaceName:NSDeviceRGBColorSpace bytesPerRow:0 bitsPerPixel:0];
  rep.size = NSMakeSize(W, H);
  [NSGraphicsContext saveGraphicsState];
  [NSGraphicsContext setCurrentContext:[NSGraphicsContext graphicsContextWithBitmapImageRep:rep]];

  [bg1 set]; NSRectFill(NSMakeRect(0,0,W,H));
  for (int i = 0; i < 12; i++) {
    CGFloat r = 240 + (CGFloat)i/12.0 * 320;
    [[bg2 colorWithAlphaComponent:.075] set];
    [[NSBezierPath bezierPathWithOvalInRect:NSMakeRect(W*0.74 - r, H*0.52 - r*0.72, r*2, r*1.44)] fill];
  }

  // ── la capture, recadrée sur la barre latérale et le tableau ──
  NSImage *shot = [[NSImage alloc] initWithContentsOfFile:shotPath];
  NSBitmapImageRep *sr = (NSBitmapImageRep *)shot.representations.firstObject;
  CGFloat px = sr.pixelsWide, py = sr.pixelsHigh;
  // recadrage en PIXELS de la source ; l'origine d'un NSRect est en bas à gauche.
  CGFloat cx0 = 0, cx1 = 1960, cyTop = 98, cyBot = 1205;
  NSRect src = NSMakeRect(cx0, py - cyBot, cx1 - cx0, cyBot - cyTop);
  src.origin.x *= shot.size.width / px;  src.size.width  *= shot.size.width / px;
  src.origin.y *= shot.size.height / py; src.size.height *= shot.size.height / py;

  CGFloat cardW = 700, cardH = cardW * (cyBot - cyTop) / (cx1 - cx0);
  NSRect card = NSMakeRect(W - cardW - 56, (H - cardH)/2, cardW, cardH);

  [NSGraphicsContext saveGraphicsState];
  NSShadow *sh = [NSShadow new];
  sh.shadowColor = [NSColor colorWithSRGBRed:0 green:0 blue:0 alpha:.55];
  sh.shadowBlurRadius = 34; sh.shadowOffset = NSMakeSize(0, -10);
  [sh set];
  rrect(card, 10, [NSColor colorWithSRGBRed:.1 green:.12 blue:.14 alpha:1], nil, 0);
  [NSGraphicsContext restoreGraphicsState];

  [NSGraphicsContext saveGraphicsState];
  [[NSBezierPath bezierPathWithRoundedRect:card xRadius:10 yRadius:10] addClip];
  [shot drawInRect:card fromRect:src operation:NSCompositingOperationSourceOver fraction:1
      respectFlipped:YES hints:@{NSImageHintInterpolation:@(NSImageInterpolationHigh)}];
  [NSGraphicsContext restoreGraphicsState];
  rrect(NSInsetRect(card, .5, .5), 10, nil, [NSColor colorWithSRGBRed:1 green:1 blue:1 alpha:.14], 1);

  // ── le texte ──
  draw(@"VDSTools", NSMakePoint(64, 288+dy), [NSFont systemFontOfSize:60 weight:NSFontWeightHeavy], ink, -1.4);
  rrect(NSMakeRect(66, 276+dy, 72, 5), 2.5, acc, nil, 0);
  draw(en ? @"Native macOS for Xojo," : @"macOS natif pour Xojo,", NSMakePoint(64, 236+dy),
       [NSFont systemFontOfSize:21 weight:NSFontWeightMedium], ink, 0);
  draw(en ? @"in pure Xojo" : @"en Xojo pur", NSMakePoint(64, 208+dy),
       [NSFont systemFontOfSize:21 weight:NSFontWeightMedium], ink, 0);
  draw(en ? @"No plugin, no external framework," : @"Aucun plugin, aucun framework externe,", NSMakePoint(64, 176+dy),
       [NSFont systemFontOfSize:14 weight:NSFontWeightRegular], muted, 0);
  draw(en ? @"no compiled Objective-C — only Declares." : @"aucun Objective-C compilé — que des Declare.", NSMakePoint(64, 156+dy),
       [NSFont systemFontOfSize:14 weight:NSFontWeightRegular], muted, 0);

  NSArray *chips = en ? @[@"100 classes", @"27 IDE controls", @"macOS 15+"]
                      : @[@"100 classes", @"27 contrôles dans l'IDE", @"macOS 15+"];
  CGFloat x = 64, y = 96+dy;
  for (NSString *c in chips) {
    NSFont *f = [NSFont systemFontOfSize:12 weight:NSFontWeightSemibold];
    CGFloat tw = [c sizeWithAttributes:@{NSFontAttributeName:f}].width;
    if (x + tw + 24 > 480) { x = 64; y -= 36; }
    rrect(NSMakeRect(x, y, tw+24, 28), 14, [acc colorWithAlphaComponent:.14], [acc colorWithAlphaComponent:.45], 1);
    draw(c, NSMakePoint(x+12, y+7), f, acc, 0);
    x += tw + 34;
  }

  [NSGraphicsContext restoreGraphicsState];
  [[rep representationUsingType:NSBitmapImageFileTypePNG properties:@{}] writeToFile:out atomically:YES];
  printf("%-16s %.0fx%.0f\n", out.lastPathComponent.UTF8String, W, H);
}
int main(int argc, char **argv) { @autoreleasepool {
  [NSApplication sharedApplication];
  NSString *d = [NSString stringWithUTF8String:argv[1]];
  NSString *fr = [d stringByAppendingPathComponent:@"shot-fr.png"];
  NSString *en = [d stringByAppendingPathComponent:@"shot-en.png"];
  render([d stringByAppendingPathComponent:@"banner-fr.png"], fr, 500, NO);
  render([d stringByAppendingPathComponent:@"banner-en.png"], en, 500, YES);
  render([d stringByAppendingPathComponent:@"social.png"],    fr, 640, NO);
}}
